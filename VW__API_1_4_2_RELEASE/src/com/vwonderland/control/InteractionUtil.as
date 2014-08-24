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

package com.vwonderland.control {
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * Interaction Control Utils
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  15.07.2010
	 */	
	public class InteractionUtil {
		
		/**
		 * DisplayObjectContainer 이하의 display 객체의 mouseChildren, mouseEnable property simple Control
		 * @example Basic usage:<listing version="3.0"> 
		 * InteractionUtil.setMouseEnable(displayObjectContainer instance, false);
		 *    </listing>
		 * @param _dpObj
		 * @param _flag_mouseInteraction
		 */
		static public function setMouseEnable(_dpObj:DisplayObjectContainer, _flag_mouseInteraction:Boolean):void {
			_dpObj.mouseChildren = _flag_mouseInteraction;
			_dpObj.mouseEnabled = _flag_mouseInteraction;
		}
		
		/**
		 * Sprite 이하의 display 객체의 buttonMode, mouseEnabled property simple Control
		 * @example Basic usage:<listing version="3.0">
		var _btn:Sprite = SimpleRect.drawRectSprite(100, 100, 0xff0000);
		_btn.buttonMode = true;
		this.addChild(_btn);
			 
		InteractionUtil.setMouseInteractionEnable(_btn, false);
		 *    </listing> 
		 * @param _dpObj
		 * @param _flag_mouseInteraction
		 * @see #removeSimpleButtonInteraction()
		 * @see #makeSimpleButtonInteraction()
		 */
		static public function setMouseInteractionEnable(_dpObj:Sprite, _flag_mouseInteraction:Boolean):void {
			if(!_flag_mouseInteraction) {
				_dpObj.buttonMode = false;
				_dpObj.mouseEnabled = false;
			}else{
				_dpObj.buttonMode = true;
				_dpObj.mouseEnabled = true;
			}
		}
		
		/**
		 * Sprite 이하의 display 객체에 buttonMode true setting 및 rollOver, rollOut, click MouseEvent 등록(removeSimpleButtonInteraction function과 함께 사용).
		 * @example Basic usage:<listing version="3.0">
		public function TestBtnInteraction():void {
			var _btn:Sprite = SimpleRect.drawRectSprite(100, 100, 0xff0000);
			InteractionUtil.makeSimpleButtonInteraction(_btn, btnMouseInteraction);
			this.addChild(_btn);
		}
		
		private function btnMouseInteraction(e:MouseEvent):void {
			switch(e.type) {
				case MouseEvent.ROLL_OVER :
					//rollOver interaction
					trace("rollOver interaction");
				break;	
				
				case MouseEvent.ROLL_OUT :
					//rollOut interaction
					trace("rollOut interaction");
				break;
				
				case MouseEvent.CLICK :
					//click interaction
					trace("click interaction");
				break;
			}
		}
		 *    </listing>
		 * @param _dpObj
		 * @param _mouseInteractionFunction
		 * @see #removeSimpleButtonInteraction()
		 */
		static public function makeSimpleButtonInteraction(_dpObj:Sprite, _mouseInteractionFunction:Function):void {
			var dpObj:Sprite = _dpObj as Sprite;
			dpObj.buttonMode = true;
			dpObj.mouseChildren = false;
			
			dpObj.addEventListener( MouseEvent.ROLL_OVER, _mouseInteractionFunction );
			dpObj.addEventListener( MouseEvent.ROLL_OUT, _mouseInteractionFunction );
			dpObj.addEventListener( MouseEvent.CLICK, _mouseInteractionFunction );
		}
		
		/**
		 * Sprite 이하의 display 객체에 등록된 buttonMode true setting 및 rollOver, rollOut, click MouseEvent 삭제(makeSimpleButtonInteraction function과 함께 사용).
		 * @example Basic usage:<listing version="3.0">
		private var _btn:Sprite;
		
		public function TestBtnInteraction():void {
			_btn = SimpleRect.drawRectSprite(100, 100, 0xff0000);
			InteractionUtil.makeSimpleButtonInteraction(_btn, btnMouseInteraction);
			this.addChild(_btn);
		}
		
		private function btnMouseInteraction(e:MouseEvent):void {
			switch(e.type) {
				case MouseEvent.ROLL_OVER :
					//rollOver interaction
				break;	
				
				case MouseEvent.ROLL_OUT :
					//rollOut interaction
				break;
				
				case MouseEvent.CLICK :
					InteractionUtil.removeSimpleButtonInteraction(_btn, btnMouseInteraction); //_btn Click시, buttonInteraction 삭제
					//추가 명령의 수행
				break;
			}
		}
		 *    </listing>
		 * @param _dpObj
		 * @param _mouseInteractionFunction
		 * @see #makeSimpleButtonInteraction()
		 */
		static public function removeSimpleButtonInteraction(_dpObj:Sprite, _mouseInteractionFunction:Function):void {
			var dpObj:Sprite = _dpObj as Sprite;
			dpObj.buttonMode = false;
			
			dpObj.removeEventListener( MouseEvent.ROLL_OVER, _mouseInteractionFunction );
			dpObj.removeEventListener( MouseEvent.ROLL_OUT, _mouseInteractionFunction );
			dpObj.removeEventListener( MouseEvent.CLICK, _mouseInteractionFunction );
		}
		
	}
} 
