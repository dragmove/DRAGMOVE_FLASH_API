/**
 * The MIT License
 *
 * Copyright (c) 2010 VW
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package com.vwonderland.control
{
	import flash.display.*;
	import flash.events.Event;
	
	/**
	 * static MovieClip Frame Control Util 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  20.07.2010
	 */	
	public class FrameControl
	{
		
		/**
		 * MovieClip Frame Control method
		 * @example Basic usage:<listing version="3.0">
		public function TestFrameControl()
		{	
			var _testMc:TestMovieClip = new TestMovieClip();
			this.addChild(_testMc);
			
			FrameControl.moveGo(_testMc, 1, 0, 0, completeFunc, ["param_1", 2, {}]); //1frame씩 이동 완료시, completeFunc("parame_1", 2, {}) function을 실행합니다.
			//FrameControl.moveGo(_testMc, -1, 15, 5); //15frame에서 5frame까지 1frame씩 이동합니다.
		}
		
		private function completeFunc(_param_1:String, _param_2:Number, _param_3:Object):void {
			trace("_param_1 : " + _param_1);
			trace("_param_2 : " + _param_2);
			trace("_param_3 : " + _param_3);
		}
		 *    </listing> 
		 * @param _movieClip			target movieClip
		 * @param _moveKeyFrame			ENTER_FRAME Event를 발생시마다 이동할 keyFrame 단위
		 * @param _startnum				start frame number(0일 경우, 반영하지 않습니다).
		 * @param _endnum				end frame number(0일 경우, 반영하지 않습니다).
		 * @param _completeFunc			frame 이동 연산 완료시 실행되는 callback function
		 * @param _completeFuncParam	frame 이동 연산 완료시 실행되는 callback function에 전달되는 parameter
		 */
		public static function moveGo(_movieClip:MovieClip, _moveKeyFrame:int, _startnum:int = 0, _endnum:int = 0, _completeFunc:Function = null, _completeFuncParam:Array = null):void
		{
			delete _movieClip.keyFrame;
			delete _movieClip.startnum;
			delete _movieClip.endnum;
			delete _movieClip.func;
			delete _movieClip.param;
			if(_movieClip.hasEventListener(Event.ENTER_FRAME)) _movieClip.removeEventListener(Event.ENTER_FRAME, doMoveGo);
			
			_movieClip.keyFrame = _moveKeyFrame;
			_movieClip.startnum = (0 == _startnum) ? _movieClip.currentFrame : _startnum;
			
			if(0 != _endnum) _movieClip.endnum = _endnum;
			else _movieClip.endnum = (_movieClip.keyFrame > 0) ? _movieClip.totalFrames : 1;
			
			_movieClip.func = _completeFunc;
			_movieClip.param = _completeFuncParam;
			
			_movieClip.gotoAndStop(_movieClip.startnum);
			_movieClip.addEventListener(Event.ENTER_FRAME, doMoveGo);
		}
		
		/**
		 * _displayObjectContainer 객체 내부의 모든 MovieClip 객체를 _keyFrame만큼의 속도로 play
		 * @example Basic usage:<listing version="3.0">
		FrameControl.moveFrameDisplayObjectContainerAllChildren(displayObjectContainer instance, 5); //ENTER_FRAME Event를 발생시마다 5frame씩 이동합니다.
		FrameControl.moveFrameDisplayObjectContainerAllChildren(displayObjectContainer instance, -1); //ENTER_FRAME Event를 발생시마다 -1frame씩 이동합니다.
		 *    </listing>
		 * @param _displayObjectContainer
		 * @param _keyFrame
		 */
		static public function moveFrameDisplayObjectContainerAllChildren(_displayObjectContainer:DisplayObjectContainer, _keyFrame:int):void {
			if (_displayObjectContainer is MovieClip) moveGo(MovieClip(_displayObjectContainer), _keyFrame);
			for (var i:uint = 0; i < _displayObjectContainer.numChildren; ++i) {
				var tempDPobj:DisplayObject = _displayObjectContainer.getChildAt(i) as DisplayObject;
				if (tempDPobj is MovieClip) {
					moveGo(MovieClip(tempDPobj), _keyFrame);
					if(DisplayObjectContainer(tempDPobj).numChildren > 0) moveFrameDisplayObjectContainerAllChildren(DisplayObjectContainer(tempDPobj), _keyFrame);
				}
			}
		}
		
		/**
		 * _displayObjectContainer 객체 내부의 모든 MovieClip 객체의 stop
		 * @example Basic usage:<listing version="3.0">
		FrameControl.stopDisplayObjectContainerAllChildren(displayObjectContainer instance);
		 *    </listing>
		 * @param _displayObjectContainer
		 */
		static public function stopDisplayObjectContainerAllChildren(_displayObjectContainer:DisplayObjectContainer):void {
			if (_displayObjectContainer is MovieClip) {
				if(_displayObjectContainer.hasEventListener(Event.ENTER_FRAME)) _displayObjectContainer.removeEventListener ( Event.ENTER_FRAME, doMoveGo );
				MovieClip(_displayObjectContainer).stop();
			}
			for (var i:uint = 0; i < _displayObjectContainer.numChildren; ++i) {
				var tempDPobj:DisplayObject = _displayObjectContainer.getChildAt(i) as DisplayObject;
				if (tempDPobj is MovieClip) {
					if(tempDPobj.hasEventListener(Event.ENTER_FRAME)) tempDPobj.removeEventListener ( Event.ENTER_FRAME, doMoveGo );
					MovieClip(tempDPobj).stop();
					if(DisplayObjectContainer(tempDPobj).numChildren > 0) stopDisplayObjectContainerAllChildren(DisplayObjectContainer(tempDPobj));
				}
			}
		}
		
		private static function doMoveGo(e:Event):void
		{
			var _mc:Object = e.currentTarget;
			var targetNum:Number = _mc.currentFrame + _mc.keyFrame;
			_mc.gotoAndStop(targetNum);
			if(_mc.currentFrame == _mc.endnum){
				_mc.removeEventListener(Event.ENTER_FRAME, doMoveGo);
				_mc.gotoAndStop(_mc.endnum);
				if(_mc.func != null) _mc.func.apply(null, _mc.param);
			}
		}
	} 
}