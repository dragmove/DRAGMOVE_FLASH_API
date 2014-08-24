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
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	/**
	 * simple Timer 
	 * @example Basic usage:<listing version="3.0">
	//USE SAMPLE 1 - simple loop
	private var _simpleTimer:SimpleTimer;
	public function TestSimpleTimer()
	{
		_simpleTimer = new SimpleTimer(1000, this, timerTestFunc, true);
	}
	 
	private function timerTestFunc():void {
		trace("timerTestFunc");
	}
	
	//USE SAMPLE 2 - use Function &#38; parameter
	//stop()   : SimpleTimer를 정지시킵니다. 
	//start()  : SimpleTimer에 설정된 delay time이 지난 후  Timer Event가 발생합니다. 
	private var _simpleTimer:SimpleTimer;
	public function TestSimpleTimer()
	{
		_simpleTimer = new SimpleTimer(1000, this, timerTestFunc, false, "VW", 2010, "wonderland");
		_simpleTimer.start();
	}
	
	private function timerTestFunc(_param_1:String, _param_2:int, _param_3:String):void {
		trace("timerTestFunc");
		trace("_param_1 :", _param_1);
		trace("_param_2 :", _param_2);
		trace("_param_3 :", _param_3);
		
		_simpleTimer.stop();
	}
	 
	//USE SAMPLE 3 - use pause &#38; resume Function
	//pause()  : SimpleTimer를 pause시키며, delay 주기 중 진행된 time, dealy 주기 중 진행되고 남겨진 time, delay 주기의 time을 trace 구문으로 표기합니다. 
	//resume() : pause 상태가 해지되며, 진행되고 남겨진 time이 지난 후 Timer Event가 발생합니다.
	private var _simpleTimer:SimpleTimer;
	private var _btn:Sprite;
		
	public function TestSimpleTimer()
	{
		_btn = SimpleRect.drawRectSprite(100, 100, 0xff0000);
		InteractionUtil.makeSimpleButtonInteraction(_btn, _btnObjMouseInteraction);
		this.addChild(_btn);
		
		setTimer();
	}
		
	private function _btnObjMouseInteraction(e:MouseEvent):void {
		switch(e.type) {
			case MouseEvent.ROLL_OVER :
				if(_simpleTimer != null) _simpleTimer.pause();
			break;	
			
			case MouseEvent.ROLL_OUT :
				if(_simpleTimer != null) _simpleTimer.resume();
			break;
		}
	}
			
	private function setTimer():void {
		_simpleTimer = new SimpleTimer(3000, this, timer_hd, true);
	}
				
	private function timer_hd():void {
		trace("Timer Event");
	}
	 *    </listing>
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  14.07.2010
	 */	
	public class SimpleTimer extends EventDispatcher {
		/** @private*/
		private var callbackScope:Object;
		
		/** @private*/
		private var callbackFunc:Function;
		
		/** @private*/
		private var callbackFunc_arg:Array;
		
		/** @private*/
		private var flag_startTimer:Boolean;
		
		/** @private*/
		private var timer:Timer;
		
		/** @private*/
		private var gapTime:Number;
		
		/** @private*/
		private var flag_pause:Boolean = false;
		
		/** @private*/
		private var flag_occurPauseCycle:Boolean = false;
		
		/** @private*/
		private var startTime:int;
		
		/** @private*/
		private var passedTime:int;
		
		/** @private*/
		private var resumedTime:int;
		
		/** @private*/
		private var pauseTimer:Timer;
		
		/** @private*/
		private var flag_useTimerExperience:Boolean = false;
		
		/** @private*/
		private var pauseRemainTime:int;
		
		
		/**
		 * destroy Timer
		 */
		public function destroy():void {
			flag_pause = false;
			flag_occurPauseCycle = false;
			flag_useTimerExperience = false;
			removePauseTimer();
			
			if (timer != null) {
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, timerListener);
				timer = null;
			}
		}
		
		/**
		 * pause Timer (use with resume() Function)
		 * @see #resume()
		 */
		public function	pause():void {
			if(!flag_useTimerExperience) {
				trace("[com.vwonderland.control.SimpleTimer] timer의 start() Function 사용 이후, pause() Function이 사용가능합니다.");
				return;
			}
			
			if(flag_pause) {
				trace("[com.vwonderland.control.SimpleTimer] 현재 pause 상태입니다.");
				return;
			}
			
			var pauseTime:int;
			var remainTime:int;
			if(flag_occurPauseCycle) {
				stop();
				pauseTime = getTimer();
				
				var resumeAfterTime:int = pauseTime - resumedTime; 
				passedTime += resumeAfterTime;
				remainTime = gapTime - passedTime;
				
				if(remainTime < 0) {
					remainTime = 0;
				}
				
				flag_pause = true;
				setPauseTimer(remainTime);
			}else{
				stop();
				pauseTime = getTimer();
				passedTime = pauseTime - startTime;
				remainTime = gapTime - passedTime;
				
				if(remainTime < 0) {
					//trace("[com.vwonderland.control.SimpleTimer] timer의 stop() 상태에서, pause() Function의 사용입니다.");
					remainTime = 0;
				}
				
				flag_pause = true;
				setPauseTimer(remainTime);
				
				flag_occurPauseCycle = true;
			}
			
			trace("[com.vwonderland.control.SimpleTimer] passedTime:" + passedTime + ", remainingTime:" + remainTime + ", totalDelayTime:" + gapTime);
		}
		
		/**
		 * resume Timer (use with pause() Function)
		 * @see #pause()
		 */
		public function	resume():void {
			if(!flag_useTimerExperience) {
				trace("[com.vwonderland.control.SimpleTimer] timer의 start() Function 사용 이후, resume() Function이 사용가능합니다.");
				return;
			}
			
			if(!flag_pause) {
				trace("[com.vwonderland.control.SimpleTimer] pause 상태가 아니므로, resume() Function의 이용이 불가능합니다.");
				return;
			}
			flag_pause = false;
			
			if(flag_occurPauseCycle) resumedTime = getTimer();
			if(pauseTimer != null) pauseTimer.start();
		}
		
		/**
		 * start Timer (use with stop() Function)
		 * @see #stop()
		 */
		public function	start():void {
			if(!flag_useTimerExperience) flag_useTimerExperience = true;
			
			flag_pause = false;
			flag_occurPauseCycle = false;
			removePauseTimer();
			
			if (timer != null) {
				renewStartTime();
				timer.stop();
				timer.start();
			}
		}
		
		/**
		 * stop Timer (use with start() Function)
		 * @see #start()
		 */
		public function stop():void {
			if (timer != null) timer.stop();
		}
		
		/**
		 * Constructor
		 * @param _gapTime			timer Event 사이의 밀리초 단위 지연 시간
		 * @param _callbackScope	_callbackFunc 함수의 scope
		 * @param _callbackFunc		timer Event 발생시마다 실행할 함수명
		 * @param _flag_startTimer	SimpleTimer 생성시, timer start 여부 setting
		 * @param rest				_callbackFunc 함수의 parameter setting
		 */
		public function SimpleTimer(_gapTime:Number, _callbackScope:Object, _callbackFunc:Function, _flag_startTimer:Boolean = false, ...rest) {
			gapTime = _gapTime;
			callbackScope = _callbackScope;
			callbackFunc = _callbackFunc;
			callbackFunc_arg = rest;
			flag_startTimer = _flag_startTimer;
			
			if (timer != null) {
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, timerListener);
				timer = null;
			}
			
			timer = new Timer(gapTime);
			timer.addEventListener(TimerEvent.TIMER, timerListener);
			if(flag_startTimer) start();
		}
		
		/**
		 * 
		 * @param e
		 */	
		private function timerListener(e:TimerEvent = null):void {
			flag_pause = false;
			flag_occurPauseCycle = false;
			removePauseTimer();
			if (timer != null) renewStartTime();
			
			if(callbackScope != null) callbackFunc.apply(callbackScope, callbackFunc_arg);
		}
		
		/**
		 * 
		 * @param _remainTime
		 */
		private function setPauseTimer(_remainTime:int):void {
			pauseRemainTime = _remainTime;
			
			removePauseTimer();
			pauseTimer = new Timer(_remainTime, 1);
			pauseTimer.addEventListener(TimerEvent.TIMER, pauseTimerListener);
		}
		
		/**
		 * 
		 * @param e
		 */
		private function pauseTimerListener(e:TimerEvent = null):void {
			removePauseTimer();
			timerListener();
			
			if(pauseRemainTime != gapTime) {
				//STATUS : passedTime > 0 && remainingTime < totalDelayTime
				//CALL FUNCTION : 1.timerListener() -> start() -> 2.timerListener()
				start();
			}else{
				//STATUS : passedTime == 0 && remainingTime == totalDelayTime 
				//CALL FUNCTION : 1.timerListener()
			}
		}
		
		private function removePauseTimer():void {
			if(pauseTimer != null) {
				pauseTimer.stop();
				pauseTimer.removeEventListener(TimerEvent.TIMER, pauseTimerListener);
				pauseTimer = null;
			}
		}
		
		private function renewStartTime():void {
			startTime = getTimer();
		}
	}
}