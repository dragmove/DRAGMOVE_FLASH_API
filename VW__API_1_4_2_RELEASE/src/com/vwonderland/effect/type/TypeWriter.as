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

package com.vwonderland.effect.type {
	import com.vwonderland.base.AbstractControllableConceptObject;
	import com.vwonderland.control.SimpleTimer;
	import com.vwonderland.support.StringUtil;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.text.*;
	
	/**
	 * text typing Motion Effect to TextField
	 * @example Basic usage:<listing version="3.0">
	private var _typeWriterEffect:TypeWriter;
	
	public function TestTypeWriter()
		var _btn:Sprite = SimpleRect.drawRectSprite();
		_btn.x = 300;
		InteractionUtil.makeSimpleButtonInteraction(_btn, btnMouseInteraction);
		this.addChild(_btn);
			
		var testStr:String = "우리는 원더랜드를 꿈꿉니다. \n\n우리들의 첫사랑, 비즈니스 위의 비즈니스... CREATIVITY.. \n세상을 바꾸었던 크리에이터들이 꿈꾸는 원더랜드. \n브이더블유 익스텐션";
		var returnArr:Array = StringUtil.breakSetenceStr(testStr);
		var _tf:TextField = TextFieldUtil.makeTF(300, 200, "돋움", 11, 0x000000, false, true, true);
		_tf.border = true;
		this.addChild(_tf);
			
		_typeWriterEffect = new TypeWriter(testStr, _tf, 40, false);
		_typeWriterEffect.addEventListener(TypeWriter.EFFECT_COMPLETE, completeTypeWriterEffect);
		_typeWriterEffect.start();
	}
	
	private function completeTypeWriterEffect(e:Event):void {
		trace("completeTypeWriterEffect");
	}
		
	private function btnMouseInteraction(e:MouseEvent):void {
		switch(e.type) {
			case MouseEvent.ROLL_OVER :
				_typeWriterEffect.pause(); //pause typing motion
				break;	
			
			case MouseEvent.ROLL_OUT :
				_typeWriterEffect.resume(); //resume typing motion
				break;
			
			case MouseEvent.CLICK :
				_typeWriterEffect.start(true); //start typing motion from beginning Character
				break;
		}
	}
	 *    </listing>
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  19.07.2010
	 */	
	public class TypeWriter extends AbstractControllableConceptObject {
		
		/**
		 * typeWriter effect 완료시 발생하는 Event입니다.
		 */
		static public const EFFECT_COMPLETE:String = "com.vwonderland.effect.type.TypeWriter.EFFECT_COMPLETE";
		
		/**
		 * typeWriter effect가 수행될 TextField
		 */
		protected var _tf:TextField;
		
		/**
		 * typeWriter effect의 속도 및 start(), stop(), pause(), resume() 제어 담당 
		 */
		protected var _timer:SimpleTimer;
		
		/**
		 * text의 각 character별 초,중,종성 분해 정보를 담은 배열들을 모두 지니는 2중 배열 
		 */
		protected var textArray:Array;
		
		/**
		 * textArray index
		 */
		protected var textIndex:int = 0;
		
		/**
		 * character Array index
		 */
		protected var motionChaIndex:int = 0;
		
		/**
		 * textField에 표기되는 text
		 */
		protected var accumulateStr:String = "";
		
		/**
		 * 현재 start() Function가 사용되어 typeWriter effect가 진행 중인지의 여부 
		 */
		protected var flag_useTimerExperience:Boolean = false;
		
		/**
		 * typeWriter effect가 완료되었는지의 여부
		 */
		protected var flag_motionComplete:Boolean = false;
		
		/**
		 * destroy TypeWriter 
		 */
		override public function destroy(_obj:Object = null):void {
			if(_timer != null) {
				_timer.stop();
				_timer.destroy();
				_timer = null;
			}
			
			_tf = null;
			textArray = null;
			textIndex = 0;
			motionChaIndex = 0;
			accumulateStr = "";
			flag_useTimerExperience = false;
			flag_motionComplete = false;
		}
		
		/**
		 * stop typeWriter effect (use with start() Function)
		 * @see #start()
		 */
		public function stop():void {
			if (_timer != null) _timer.stop();
		}
		
		/**
		 * start typeWriter effect (use with stop() Function)
		 * @param _flag_startMotionFromBeginning true : typeWriter effect를 최초 character부터 수행. false : stop() Function이 실행된 시점부터 typeWriter effect 수행
		 * @see #stop()
		 */
		public function	start(_flag_startMotionFromBeginning:Boolean = false):void {
			if(!flag_useTimerExperience) flag_useTimerExperience = true;
			
			if(_flag_startMotionFromBeginning) {
				flag_motionComplete = false;
				textIndex = 0;
				motionChaIndex = 0;
				accumulateStr = "";
				
				if(_timer != null) {
					_timer.stop();
					_timer.start();
				}
			}else{
				if(_timer != null) {
					_timer.stop();
					_timer.start();
				}
			}
		}
		
		/**
		 * pause typeWriter effect (use with resume() Function)
		 * @see #resume()
		 */
		public function	pause():void {
			if(!flag_useTimerExperience) {
				trace("[com.vwonderland.effect.type.TypeWriter] TypeWriter의 start() Function 사용 이후, pause() Function이 사용가능합니다.");
				return;
			}
			
			if(_timer != null) _timer.pause();
		}
		
		/**
		 * resume typeWriter effect (use with pause() Function)
		 * @see #pause()
		 */
		public function	resume():void {
			if(!flag_useTimerExperience) {
				trace("[com.vwonderland.effect.type.TypeWriter] TypeWriter의 start() Function 사용 이후, resume() Function이 사용가능합니다.");
				return;
			}
			
			if(_timer != null) _timer.resume();
		}
		
		/**
		 * Constructor
		 * @param _txt				TypeWriter motion으로 표기되는 Text
		 * @param _textField		TypeWriter motion이 실행되는 textField
		 * @param _typingTimerGap	TypeWriter motion이 1번 이루어지는 밀리초 단위 지연 시간
		 * @param _flag_startTimer	TypeWriter 생성시, typeWriter motion start 여부 setting
		 */
		public function	TypeWriter(_txt:String, _textField:TextField, _typingTimerGap:Number, _flag_startTimer:Boolean = false):void {
			super();
			
			if(_txt == null || _txt == "") {
				trace("[com.vwonderland.effect.type.TypeWriter] TypeWriter effect를 실행하기 위한 _txt value가 존재하지 않습니다.");
				return;
			}
			
			textArray = StringUtil.breakSetenceStr(_txt); 		
			_tf = _textField;
			_timer = new SimpleTimer(_typingTimerGap, this, performTypingMotion, _flag_startTimer); 
		}
		
		/**
		 * typeWriter effect detail perfome Function
		 */
		protected function performTypingMotion():void {
			if(flag_motionComplete) {
				trace("[com.vwonderland.effect.type.TypeWriter] TypeWriter effect가 start() Function 사용 이후, 진행 완료된 상태입니다.");
				flag_useTimerExperience = false;
				if(_timer != null) _timer.stop();
				return;
			}
			
			var motionChaArr:Array = textArray[textIndex];
			var characterLength:int = motionChaArr.length;
			
			var _str:String = motionChaArr[motionChaIndex];
			_tf.text = accumulateStr + _str;
			
			motionChaIndex++;
			if(characterLength <= motionChaIndex) {
				accumulateStr += _str;
				motionChaIndex = 0;
				textIndex++;
				
				if(textIndex >= textArray.length) {
					flag_useTimerExperience = false;
					flag_motionComplete = true;
					if(_timer != null) _timer.stop();
					dispatchEvent(new Event(EFFECT_COMPLETE));
				}
			}
		}
	}
} 
