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
	import com.vwonderland.support.MathUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	/**
	 * vibration Motion Effect to Sprite
	 * @example Basic usage:<listing version="3.0">
	private var _targetSprite:Sprite;
	private var _vibration:Vibration;
	
	public function TestVibration():void {
		_targetSprite = new Sprite();
		
		var _shapeSprite:Sprite = SimpleRect.drawRectSprite(100, 100);
		_shapeSprite.x = -_shapeSprite.width / 2;
		_shapeSprite.y = -_shapeSprite.height / 2;
		_targetSprite.addChild(_shapeSprite);
		
		_targetSprite.x = stage.stageWidth / 2;
		_targetSprite.y = stage.stageHeight / 2;
		this.addChild(_targetSprite);
		
		InteractionUtil.makeSimpleButtonInteraction(_targetSprite, mouseInteraction);
		_vibration = new Vibration(_targetSprite, 1000, 30, new Point(stage.stageWidth / 2, stage.stageHeight / 2), 10, 0, 5, Vibration.OMNIDIRECTIONAL, true);
	}
	
	private function mouseInteraction(e:MouseEvent):void {
		switch(e.type) {
			case MouseEvent.CLICK :
				_vibration.start();
			break;
		}
	}
	 *    </listing>
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  23.08.2010
	 */	
	public class Vibration extends AbstractControllableConceptObject {
		
		/**
		 * vibration effect direction - 전방향 진동
		 */
		static public const OMNIDIRECTIONAL:String = "com.vwonderland.effect.motion.Vibration.OMNIDIRECTIONAL";
		
		/**
		 * vibration effect direction - 수평 진동
		 */
		static public const HORIZONTAL:String = "com.vwonderland.effect.motion.Vibration.HORIZONTAL";
		
		/**
		 * vibration effect direction - 수직 진동
		 */
		static public const VERTICAL:String = "com.vwonderland.effect.motion.Vibration.VERTICAL";
		
		/**
		 * vibration effect 완료시 발생하는 Event입니다.
		 */
		static public const VIBRATION_COMPLETE:String = "com.vwonderland.effect.motion.VIBRATION_COMPLETE";
		
		/**
		 * vibration decrescendo 단계 계수 (Flash TimerEvent 간격이 frame, memory 등의 영향을 받으므로 setDecrescendoDivideCoefficient() Function을 통해 조정가능합니다.) 
		 * @see #setDecrescendoDivideCoefficient() 
		 */
		protected var DECRESCENDO_DIVIDE_COEFFICIENT:int = 20;
		
		/**
		 * OMNIDIRECTIONAL vibration 계수
		 */
		protected var OMNIDIRECTIONAL_VIBRATION_ROTATION_COEFFICIENT:int = 45;
		
		private const ORIGIANL_VIBRATION_STRENGTH_PERCENTAGE:int = 1;
		private var _vibrateTargetSpr:Sprite;
		private var vibrateDurationTime:Number;
		private var vibrateCycleTime:Number;
		private var basePosPoint:Point;
		private var vibrateRadius:Number;
		private var origianlVibrateRadius:Number;
		private var vibrateDirection:String;
		private var flag_decrescendo:Boolean;
		private var vibrateAngleRange:Number;
		private var originalVibrateAngleRange:Number;
		private var vibrationStrengthPercentage:Number;
		private var fluctuationRange:Number;
		private var decrescendoCycle:int;
		private var prevPoint:Point;
		private var prevRadian:Number;
		private var prevAngle:Number;
		private var _vibrateCycleTimer:SimpleTimer;
		private var _timer:SimpleTimer;
		private var _decrescendoTimer:SimpleTimer;
		
		/**
		 * decrescendo option 이용시, vibration decrescendo 단계 계수 변경
		 * @param _value
		 */
		public function	setDecrescendoDivideCoefficient(_value:int):void {
			if(_value <= 0 || _value > 100) {
				trace("[com.vwonderland.effect.motion.Vibration] DECRESCENDO_DIVIDE_COEFFICIENT value는 1 ~ 100 사이의 값이어야 합니다.");
				return;
			}
			
			DECRESCENDO_DIVIDE_COEFFICIENT = _value;
		}
		
		/**
		 * destroy Vibration
		 */
		override public function destroy(_obj:Object = null):void {	
			stop();
			if(_timer != null) {
				_timer.destroy();
				_timer = null;
			}
			
			if(_decrescendoTimer != null) {
				_decrescendoTimer.destroy();
				_decrescendoTimer = null;
			}
			
			if(_vibrateCycleTimer != null) {
				_vibrateCycleTimer.destroy();
				_vibrateCycleTimer = null;
			}
		}
		
		/**
		 * stop vibration effect (use with start() Function)
		 * @see #start()
		 */
		public function	stop():void {
			if(_timer != null) _timer.stop();
			if(_decrescendoTimer != null) _decrescendoTimer.stop();
			if(_vibrateCycleTimer != null) _vibrateCycleTimer.stop();
			_vibrateTargetSpr.x = basePosPoint.x;
			_vibrateTargetSpr.y = basePosPoint.y;
			_vibrateTargetSpr.rotation = 0;
		}
		
		/**
		 * start vibration effect (use with stop() Function)
		 * @see #stop()  
		 */
		public function	start():void {
			vibrateRadius = origianlVibrateRadius;
			vibrationStrengthPercentage = ORIGIANL_VIBRATION_STRENGTH_PERCENTAGE;
			vibrateAngleRange = originalVibrateAngleRange;
			if(_timer != null) {
				_timer.stop();
				_timer.start();
			}
			
			if(_decrescendoTimer != null) {
				_decrescendoTimer.stop();
				_decrescendoTimer.start();
			}
			
			if(_vibrateCycleTimer != null) {
				_vibrateCycleTimer.stop();
				_vibrateCycleTimer.start();
			}
		}
		
		//=========================
		// Constructor
		//=========================
		/**
		 * Constructor
		 * @param _vibrateTarget 		진동 대상 Sprite
		 * @param _vibrateDurationTime	진동 전체 밀리초 단위 진행 시간
		 * @param _vibrateCycleTime		진동 motion이 1번 이루어지는 밀리초 단위 지연 시간
		 * @param _basePoint			진동 기준 위치 (진동 완료 후, 진동대상은 진동 기준 위치로 이동합니다.)
		 * @param _vibrateRadius		진동 반지름
		 * @param _fluctuationRange		진동 변동폭
		 * @param _vibrateAngleRange	진동 각도
		 * @param _vibrateDirection		진동 방향 (전방향, 횡방향, 종방향)
		 * @param _flag_decrescendo		진동 감소 여부
		 */
		public function	Vibration(_vibrateTarget:Sprite, _vibrateDurationTime:Number, _vibrateCycleTime:Number, _basePoint:Point, _vibrateRadius:Number, _fluctuationRange:Number = 0, _vibrateAngleRange:Number = 0, _vibrateDirection:String = Vibration.OMNIDIRECTIONAL, _flag_decrescendo:Boolean = false) {
			super();
			
			_vibrateTargetSpr = _vibrateTarget;
			vibrateDurationTime = _vibrateDurationTime;
			vibrateCycleTime = _vibrateCycleTime;
			
			if(vibrateDurationTime <= _vibrateCycleTime) {
				throw new Error("[com.vwonderland.effect.motion.Vibration] _vibrateCycleTime value는 _vibrateDurationTime value보다 작아야 합니다.");
				return;
			}
			
			basePosPoint = _basePoint;
			vibrateRadius = origianlVibrateRadius = _vibrateRadius;
			fluctuationRange = _fluctuationRange;
			vibrateDirection = _vibrateDirection;
			flag_decrescendo = _flag_decrescendo;
			vibrationStrengthPercentage = ORIGIANL_VIBRATION_STRENGTH_PERCENTAGE;
			vibrateAngleRange = originalVibrateAngleRange = MathUtil.getAngleBasedOnSystem(_vibrateAngleRange);
			
			_timer = new SimpleTimer(vibrateDurationTime, this, timerEventHandler, false);
			_vibrateCycleTimer = new SimpleTimer(vibrateCycleTime, this, vibrateCycleTimerEventHandler, false);
			
			if(_flag_decrescendo) {
				decrescendoCycle = vibrateDurationTime / DECRESCENDO_DIVIDE_COEFFICIENT;
				_decrescendoTimer = new SimpleTimer(decrescendoCycle, this, descrescendoTimerEventHandler, false);
			}
		}
		
		private function vibrateCycleTimerEventHandler():void {
			performVibrationMotion();
		}
		
		/**
		 * vibration descrescendo Function
		 */
		protected function descrescendoTimerEventHandler():void {
			vibrationStrengthPercentage -= 1 / DECRESCENDO_DIVIDE_COEFFICIENT;
			if(vibrationStrengthPercentage < 0) vibrationStrengthPercentage = 0;
			
			vibrateRadius -= origianlVibrateRadius / DECRESCENDO_DIVIDE_COEFFICIENT;
			if(vibrateRadius < 0) vibrateRadius = 0;
			
			vibrateAngleRange -= originalVibrateAngleRange / DECRESCENDO_DIVIDE_COEFFICIENT;
			if(vibrateAngleRange < 0) vibrateAngleRange = 0;
		}
		
		/**
		 * vibration perform Function
		 * @param e
		 */
		protected function performVibrationMotion():void
		{
			var targetPoint:Point;
			var fluctuationValue:Number;
			var randomFluctuation:Number;
			var tempValue:Number;
			var targetAngle:Number;
			
			if(prevPoint != null) {
				switch(vibrateDirection) {
					case OMNIDIRECTIONAL :
						randomFluctuation = MathUtil.getRandomSurroundPoint(0, 0, vibrateRadius * fluctuationRange).x;
						var rotationValue:Number = MathUtil.getAngleBasedOnSystem(MathUtil.radianToDegree(prevRadian) + 180) + MathUtil.getRandomPositiveNegative() * OMNIDIRECTIONAL_VIBRATION_ROTATION_COEFFICIENT;
						prevRadian = MathUtil.degreeToRadian(Math.round(rotationValue));
						
						targetPoint = MathUtil.getRotatedPointAroundStandardPoint(new Point(0, 0), new Point(vibrateRadius + randomFluctuation, 0), rotationValue);
						targetPoint = new Point(MathUtil.ceilUnit(targetPoint.x, 0.01), MathUtil.ceilUnit(targetPoint.y, 0.1)); 	
					break;	
					
					case HORIZONTAL :
						randomFluctuation = MathUtil.getRandomSurroundPoint(0, 0, vibrateRadius * fluctuationRange).x;
						tempValue = vibrateRadius;
						if(MathUtil.getFlagPositiveNumber(prevPoint.x)) tempValue *= -1;
						fluctuationValue = MathUtil.ceilUnit(tempValue + randomFluctuation, 0.1);
						targetPoint = new Point(fluctuationValue, 0);
					break;
					
					case VERTICAL :
						randomFluctuation = MathUtil.getRandomSurroundPoint(0, 0, vibrateRadius * fluctuationRange).y;
						tempValue = vibrateRadius;
						if(MathUtil.getFlagPositiveNumber(prevPoint.y)) tempValue *= -1;
						fluctuationValue = MathUtil.ceilUnit(tempValue + randomFluctuation, 0.1);
						targetPoint = new Point(0, fluctuationValue);
					break;
				}
				
				targetAngle = vibrateAngleRange;
				if(MathUtil.getFlagPositiveNumber(prevAngle)) targetAngle *= -1;
			}else{ 
				switch(vibrateDirection) {
					case OMNIDIRECTIONAL :
						randomFluctuation = MathUtil.getRandomSurroundPoint(0, 0, vibrateRadius * fluctuationRange).x;
						var randomRadian:Number = Math.random() * Math.PI * 2;
						prevRadian = Math.round(randomRadian);
						targetPoint = MathUtil.getRotatedPointAroundStandardPoint(new Point(0, 0), new Point(vibrateRadius + randomFluctuation, 0), MathUtil.radianToDegree(prevRadian));
					break;	
					
					case HORIZONTAL :
						randomFluctuation = MathUtil.getRandomSurroundPoint(0, 0, vibrateRadius * fluctuationRange).x;
						fluctuationValue = MathUtil.getRandomPositiveNegative() * MathUtil.ceilUnit(vibrateRadius  + randomFluctuation, 0.1);
						targetPoint = new Point(fluctuationValue, 0);	
					break;
					
					case VERTICAL :
						randomFluctuation = MathUtil.getRandomSurroundPoint(0, 0, vibrateRadius * fluctuationRange).y;
						fluctuationValue = MathUtil.getRandomPositiveNegative() * MathUtil.ceilUnit(vibrateRadius  + randomFluctuation, 0.1);
						targetPoint = new Point(0, fluctuationValue);
					break;
				}
				
				targetAngle = MathUtil.getRandomPositiveNegative() * vibrateAngleRange;
			}
			
			prevPoint = targetPoint;
			_vibrateTargetSpr.x = basePosPoint.x + prevPoint.x;
			_vibrateTargetSpr.y = basePosPoint.y + prevPoint.y;
			
			prevAngle = targetAngle = MathUtil.getAngleBasedOnSystem(targetAngle);
			_vibrateTargetSpr.rotation = targetAngle;
		}
		
		private function timerEventHandler():void {
			stop();
			dispatchEvent(new Event(VIBRATION_COMPLETE));
		}
	}
} 
