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

package com.vwonderland.effect.motion {
	import com.vwonderland.base.AbstractControllableConceptObject;
	import com.vwonderland.control.SimpleTimer;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.Point;
	
	/**
	 * ripple Motion Effect to Sprite
	 * @example Basic usage:<listing version="3.0">
	private var _rippleTargetImage:TestImageClip; //Test를 위해 제작한 Sprite image clip
	private var _ripple:Ripple;
	
	public function TestRipple():void {
		_rippleTargetImage = new TestImageClip(); //create Sprite image
		this.addChild(_rippleTargetImage);
		
		//create octave, offsetPointArr, speedPointArr Variables to Ripple Effect
		var octaves:uint = 3;
		var offsetPointArr:Array = new Array();
		var speedPointArr:Array = new Array();
		for(var i:uint = 0; i &#60; octaves; ++i) {
			offsetPointArr[i] = new Point(Math.random() &#42; _rippleTargetImage.width, Math.random() &#42; _rippleTargetImage.height);
			speedPointArr[i] = new Point(Math.random() &#42; 2 - 1, Math.random() &#42; 2 - 1);
		}
		
		var perlinNoiseRandomSpeed:Number = Math.floor(Math.random() &#42; 1000);
		_ripple = new Ripple(_rippleTargetImage as Sprite, 5000, 1, 50, 150, octaves, offsetPointArr, speedPointArr, perlinNoiseRandomSpeed, BitmapDataChannel.GREEN, DisplacementMapFilterMode.WRAP, true, true, true);
		_ripple.setDecrescendoDivideCoefficient(50);
		_ripple.addEventListener(Ripple.RIPPLE, rippleEffectHandler);
		_ripple.addEventListener(Ripple.RIPPLE_COMPLETE, rippleEffectHandler);
		_ripple.start();
	}
	
	private function rippleEffectHandler(e:Event):void {
		switch(e.type) {
			case Ripple.RIPPLE :
				trace("Ripple.RIPPLE");
			break;
			
			case Ripple.RIPPLE_COMPLETE :
				trace("Ripple.RIPPLE_COMPLETE");
				if(_ripple != null) _ripple.stop(true); //_rippleTargetImage.filters = null;
			break;	
		}
	}
	 *    </listing>
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  09.04.2011
	 */
	public class Ripple extends AbstractControllableConceptObject {
		
		/**
		 * ripple effect 완료시 발생하는 Event입니다.
		 */
		static public const RIPPLE_COMPLETE:String = "com.vwonderland.effect.motion.Ripple.RIPPLE_COMPLETE";
		
		/**
		 * ripple effect가 한번 실행시마다 발생하는 Event입니다.
		 */
		static public const RIPPLE:String = "com.vwonderland.effect.motion.Ripple.RIPPLE";
		
		/**
		 * ripple decrescendo 단계 계수 (Flash TimerEvent 간격이 frame, memory 등의 영향을 받으므로 setDecrescendoDivideCoefficient() Function을 통해 조정가능합니다.) 
		 * @see #setDecrescendoDivideCoefficient() 
		 */
		protected var DECRESCENDO_DIVIDE_COEFFICIENT:int = 20;
		
		private var _mapBitmapData:BitmapData;
		private var _mapPoint:Point;
		
		private var _rippleTargetSprite:Sprite;
		private var _displacementMapFilter:DisplacementMapFilter;
		private var displacementMapFilterMode:String;
		
		private var origianlMapChangeScaleX:Number;
		private var origianlMapChangeScaleY:Number;
		private var mapChangeScaleX:Number;
		private var mapChangeScaleY:Number;
		private var octaves:uint;
		private var offsetArr:Array;
		private var speedArr:Array;
		
		private var perlinNoiseBaseX:Number;
		private var perlinNoiseBaseY:Number;
		private var perlinNoiseRandomSpeed:int;
		private var displacementMapFilterComponentBitmapDataChannel:uint;
		
		private var flag_perlinNoiseStitch:Boolean;
		private var flag_perlinNoiseFractalNoise:Boolean;
		private var flag_decrescendo:Boolean;
		
		private var _timer:SimpleTimer;
		private var rippleDurationTime:Number;
		
		private var _rippleCycleTimer:SimpleTimer;
		private var _decrescendoTimer:SimpleTimer;
		private var decrescendoCycle:int;
		
		/**
		 * decrescendo option 이용시, ripple decrescendo 단계 계수 변경
		 * @param _value
		 */
		public function	setDecrescendoDivideCoefficient(_value:int):void {
			if(_value <= 0 || _value > 100) {
				trace("[com.vwonderland.effect.motion.Ripple] DECRESCENDO_DIVIDE_COEFFICIENT value는 1 ~ 100 사이의 값이어야 합니다.");
				return;
			}
			
			DECRESCENDO_DIVIDE_COEFFICIENT = _value;
			if(flag_decrescendo) {
				decrescendoCycle = rippleDurationTime / DECRESCENDO_DIVIDE_COEFFICIENT;
				
				if(_decrescendoTimer != null) _decrescendoTimer.destroy();
				_decrescendoTimer = new SimpleTimer(decrescendoCycle, this, descrescendoTimerEventHandler, false);
			}
		}
		
		/**
		 * destroy Ripple
		 */
		override public function destroy(_obj:Object = null):void {	
			if(_timer != null) {
				_timer.destroy();
				_timer = null;
			}
			if(_rippleCycleTimer != null) {
				_rippleCycleTimer.destroy();
				_rippleCycleTimer = null;
			}
			if(_decrescendoTimer != null) {
				_decrescendoTimer.destroy();
				_decrescendoTimer = null;
			}
			if(_mapBitmapData != null) {
				_mapBitmapData.dispose();
				_mapBitmapData = null;
			}
			clear();
		}
		
		/**
		 * stop ripple effect (use with start() Function)
		 * @see #start()
		 */
		public function	stop(_flag_clearRipple:Boolean = false):void {
			if(_timer != null) _timer.stop();
			if(_rippleCycleTimer != null) _rippleCycleTimer.stop();
			if(_decrescendoTimer != null) _decrescendoTimer.stop();
			if(_flag_clearRipple) clear();
		}
		
		/**
		 * start ripple effect (use with stop() Function)
		 * @see #stop()  
		 */
		public function	start():void {
			mapChangeScaleX = origianlMapChangeScaleX;
			mapChangeScaleY = origianlMapChangeScaleY;
			
			if(_decrescendoTimer != null) {
				_decrescendoTimer.stop();
				_decrescendoTimer.start();
			}
			if(_rippleCycleTimer != null) {
				_rippleCycleTimer.stop();
				_rippleCycleTimer.start();
			}
			if(_timer != null) {
				_timer.stop();
				_timer.start();
			}
		}
		
		/**
		 * clear ripple effect filter
		 * @see #stop()
		 */
		private function clear():void {
			if(_rippleTargetSprite != null) _rippleTargetSprite.filters = null;
		}
		
		/**
		 * Constructor
		 * @param _rippleTarget							ripple 대상 Sprite
		 * @param _rippleDurationTime					ripple 전체 밀리초 단위 진행 시간
		 * @param _rippleCycleTime						ripple 연산이 1번 이루어지는 밀리초 단위 지연 시간
		 * @param _mapChangeScaleX						displacementFilter Map 계산에서 x위치 변경 결과의 크기 조절 수치
		 * @param _mapChangeScaleY						displacementFilter Map 계산에서 y위치 변경 결과의 크기 조절 수치
		 * @param _octaves								ripple 개별 노이즈 함수의 수. octave의 수가 많아질수록 보다 상세한 이미지가 만들어지고, 처리 시간도 증가합니다.
		 * @param _offsetPointArr						각 octave의 x,y offset에 해당하는 Point를 담는 배열
		 * @param _speedPointArr						각 octave의 x,y offset Point가 이동하는 x,y 속도를 의미하는 Point를 담는 배열
		 * @param _perlinRandomSpeed					perlinNoise의 난수 초기값
		 * @param _displacementMapBitmapDataChannel		DisplacementMapFilter 적용시 Map 계산시 사용할 색상 채널
		 * @param _displacementMapFilterMode			DisplacementMapFilter 적용시 사용되는 DisplacementMapFilterMode
		 * @param _flag_decrescendo						ripple 감소 여부
		 * @param _flag_perlinStitch					perlinNoise의 가장자리 다듬기 여부
		 * @param _flag_perlinFractalNoise				perlinNoise의 형태 정의. true일 경우 fractalNoise, false일 경우 휘몰아치기 형태 생성
		 * @throws Error
		 */
		public function	Ripple(_rippleTarget:Sprite, _rippleDurationTime:Number, _rippleCycleTime:Number, _mapChangeScaleX:uint, _mapChangeScaleY:uint, _octaves:uint, _offsetPointArr:Array, _speedPointArr:Array, 
							   _perlinRandomSpeed:int, _displacementMapBitmapDataChannel:uint = 1, _displacementMapFilterMode:String = "wrap", _flag_decrescendo:Boolean = false, _flag_perlinStitch:Boolean=true, _flag_perlinFractalNoise:Boolean=true) {
			super();
			if(_rippleDurationTime <= _rippleCycleTime) {
				throw new Error("[com.vwonderland.effect.motion.Ripple] _rippleCycleTime value는 _rippleDurationTime value보다 작아야 합니다.");
				return;
			}
			_rippleTargetSprite = _rippleTarget;
			rippleDurationTime = _rippleDurationTime;
			perlinNoiseBaseX = _rippleTargetSprite.width;
			perlinNoiseBaseY = _rippleTargetSprite.height;
			origianlMapChangeScaleX = mapChangeScaleX = _mapChangeScaleX;
			origianlMapChangeScaleY = mapChangeScaleY = _mapChangeScaleY;
			
			_mapBitmapData = new BitmapData(perlinNoiseBaseX, perlinNoiseBaseY, false, 0x000000);
			_mapPoint = new Point(0, 0);
			
			octaves = _octaves;
			offsetArr = _offsetPointArr;
			speedArr = _speedPointArr;
			perlinNoiseRandomSpeed = _perlinRandomSpeed;
			
			displacementMapFilterComponentBitmapDataChannel = _displacementMapBitmapDataChannel;
			displacementMapFilterMode = _displacementMapFilterMode;
			flag_perlinNoiseStitch = _flag_perlinStitch;
			flag_perlinNoiseFractalNoise = _flag_perlinFractalNoise;
			
			flag_decrescendo = _flag_decrescendo;
			if(flag_decrescendo) {
				decrescendoCycle = rippleDurationTime / DECRESCENDO_DIVIDE_COEFFICIENT;
				_decrescendoTimer = new SimpleTimer(decrescendoCycle, this, descrescendoTimerEventHandler, false);
			}else{
				_timer = new SimpleTimer(rippleDurationTime, this, timerEventHandler, false);
			}
			_rippleCycleTimer = new SimpleTimer(_rippleCycleTime, this, rippleCycleTimerEventHandler, false);
		}
		
		/**
		 * ripple descrescendo Function
		 */
		protected function descrescendoTimerEventHandler():void {
			mapChangeScaleX -= origianlMapChangeScaleX * (1 / DECRESCENDO_DIVIDE_COEFFICIENT);
			mapChangeScaleY -= origianlMapChangeScaleY * (1 / DECRESCENDO_DIVIDE_COEFFICIENT);
			if(mapChangeScaleX < 0) mapChangeScaleX = 0;
			if(mapChangeScaleY < 0) mapChangeScaleY = 0;
		}
		
		/**
		 * rippleCycleTimerEventHandler Function
		 * @param e
		 */
		protected function rippleCycleTimerEventHandler(e:Event = null):void {
			performRippleMotion();
			dispatchEvent(new Event(RIPPLE));
			
			if(flag_decrescendo) {
				if(mapChangeScaleX <= 0 && mapChangeScaleY <= 0) {
					stop();
					dispatchEvent(new Event(RIPPLE_COMPLETE));
				}
			}
		}
		
		/**
		 * ripple perform Function
		 */
		protected function performRippleMotion():void
		{
			for(var i:uint = 0; i < octaves; ++i) {
				offsetArr[i].x += speedArr[i].x;
				offsetArr[i].y += speedArr[i].y;
			}
			_mapBitmapData.perlinNoise(perlinNoiseBaseX, perlinNoiseBaseY, octaves, perlinNoiseRandomSpeed, 
				flag_perlinNoiseStitch, flag_perlinNoiseFractalNoise, 1, true, offsetArr);
			_displacementMapFilter = new DisplacementMapFilter(_mapBitmapData, _mapPoint, displacementMapFilterComponentBitmapDataChannel,
				displacementMapFilterComponentBitmapDataChannel, mapChangeScaleX, mapChangeScaleY, displacementMapFilterMode);
			
			_rippleTargetSprite.filters = [_displacementMapFilter];
		}
		
		/**
		 * 
		 */
		protected function timerEventHandler():void {
			if(flag_decrescendo) return;
			stop();
			dispatchEvent(new Event(RIPPLE_COMPLETE));
		}
	}
} 
