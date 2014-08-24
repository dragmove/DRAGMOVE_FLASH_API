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

package com.vwonderland.control.slider 
{
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * horizontal slider class 
	 * @example Basic usage:<listing version="3.0">
	private var _btn:Sprite;
	private var _bg:Sprite;
	private var _slider:SliderHorizontal;
	
	public function TEST_SLIDER_HORIZONTAL()
	{
		_bg = SimpleRect.drawRectSprite(150, 100, 0x0000ff);
		_bg.x = 100;
		this.addChild(_bg);
		
		_btn = SimpleRect.drawRectSprite(50, 10, 0xff0000);
		_btn.x = 100;
		_btn.y = 100
		this.addChild(_btn);
		
		_slider = new SliderHorizontal(this.stage, _btn, _btn.x, _btn.y, 100, 0, true, true, _bg, 0.1);
		
		//base required handler
		_slider.addEventListener(SliderBase.ROLLOVER_SLIDER, sliderMouseInteraction);
		_slider.addEventListener(SliderBase.ROLLOUT_SLIDER, sliderMouseInteraction);
		_slider.addEventListener(SliderBase.PRESS_SLIDER, sliderMouseInteraction);
		_slider.addEventListener(SliderBase.DRAG_SLIDER, sliderMouseInteraction);
		_slider.addEventListener(SliderBase.RELEASE_SLIDER, sliderMouseInteraction);
		
		//option handler 
		_slider.addEventListener(SliderBase.RELEASE_OUTSIDE_SLIDER, sliderMouseInteraction);
		_slider.addEventListener(SliderBase.RELEASE_INSIDE_SLIDER, sliderMouseInteraction);
		_slider.addEventListener(SliderBase.WHEEL_SCROLL_SLIDER, sliderMouseInteraction);
		
		//set percentage
		_slider.percentage = 0.5;
		
		//slider의 drag 가능한 최대 범위(0 ~ 100 px) 사이의 실제 slide 수행 가능한 limit 범위(0 ~ 30px) 정의
		//_slider.restrictDragDistance(30);  
	}
	
	private function sliderMouseInteraction(e:Event):void {
		switch(e.type) {
			case SliderBase.ROLLOVER_SLIDER :
				TweenMax.to(_btn, 0.1, {tint:0x000000, ease:Expo.easeOut} );
			break;	
			
			case SliderBase.ROLLOUT_SLIDER :
				if(!_slider.dragStatus)TweenMax.to(_btn, 0.3, {tint:null, ease:Cubic.easeOut} );
			break;
			
			case SliderBase.PRESS_SLIDER :
				TweenMax.to(_btn, 0.1, {height:15, ease:Expo.easeOut} );
			break;	
			
			case SliderBase.DRAG_SLIDER :
				trace("_slider.percentage :", _slider.percentage);
			break;
			
			case SliderBase.RELEASE_SLIDER :
				TweenMax.to(_btn, 0.3, {tint:null, ease:Cubic.easeOut} );
				TweenMax.to(_btn, 0.3, {height:10, ease:Cubic.easeOut} );
			break;
			
			case SliderBase.RELEASE_OUTSIDE_SLIDER :
				trace("SliderBase.RELEASE_OUTSIDE_SLIDER");
			break;
			
			case SliderBase.RELEASE_INSIDE_SLIDER :
				trace("SliderBase.RELEASE_INSIDE_SLIDER");
			break;
			
			case SliderBase.WHEEL_SCROLL_SLIDER :
				trace("SliderBase.WHEEL_SCROLL_SLIDER");
				trace("_slider.percentage :", _slider.percentage);
			break;
		}
	}
	 *    </listing>
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  17.08.2010
	 */	
	public class SliderHorizontal extends SliderBase {
		
		/**
		 * slider의 drag 가능한 범위의 재정의
		 * @param _dragDistance
		 * @see #restrictDragDistance()
		 */
		override public function setDragDistance(_dragDistance:Number):void {
			dragBoundsWidth = _dragDistance;
			dragBoundsRect = new Rectangle(dragBoundsLeft, dragBoundsTop, dragBoundsWidth, dragBoundsHeight);
		}
		
		/**
		 * slider의 drag 가능한 최대 범위 사이의 실제 slide 수행 가능한 limit 범위의 정의
		 * @param _restrictDistance
		 * @see #setDragDistance()
		 */
		override public function restrictDragDistance(_restrictDistance:Number):void {
			var restrictDragBounds:Number = checkRestrictValue(_restrictDistance);
			restrictSliderValue = restrictDragBounds / dragBoundsWidth;
			
			dragBoundsRect = new Rectangle(dragBoundsLeft, dragBoundsTop, restrictDragBounds, dragBoundsHeight);
		}
		
		//================
		// Constructor
		//================
		/**
		 * Constructor
		 * @param _stage 								stage
		 * @param _dragTarget 							drag 기능을  가지는 Sprite 객체
		 * @param _dragStartX 							_dragTarget의 drag x축 시작 좌표 
		 * @param _dragStartY 							_dragTarget의 drag y축 시작 좌표
		 * @param _dragDistance 						_dragTarget의 drag 가능한 범위
		 * @param _initPercentage 						_dragDistance 범위를 0 ~ 1 사이의 value로 환산하였을 때의  _dragTarget의 초기 위치
		 * @param _snapPixel 							_dragTarget의 x, y축 위치가 int type으로 pixel과 맞물리는지의 설정 여부
		 * @param _flagUseWheel							MouseWheelEvent를 이용한 _dragTarget의 scroll 기능의 이용 여부
		 * @param _interactiveObjectCreateWheelEvent	MouseWheelEvent를 발생시키는 InteractiveObject (_flagUseWheel가 true일 경우) 
		 * @param _changePercentagePerWheelTick			MouseWheelEvent의 발생시, percentage의 변화량
		 * @throws Error
		 */
		
		public function SliderHorizontal(_stage:Stage, _dragTarget:Sprite, _dragStartX:Number, _dragStartY:Number, _dragDistance:Number, _initPercentage:Number = 0, _snapPixel:Boolean = false, _flagUseWheel:Boolean = false, _interactiveObjectCreateWheelEvent:InteractiveObject = null, _changePercentagePerWheelTick:Number = 0.1) { 
			super(_stage, _dragTarget, _dragStartX, _dragStartY, _dragDistance, _initPercentage, _snapPixel, _flagUseWheel, _interactiveObjectCreateWheelEvent, _changePercentagePerWheelTick);
			
			if(_initPercentage < 0 || _initPercentage > 1) throw new Error("[com.vwonderland.control.slider.SliderHorizontal] _initPercentage parameter must set 0 ~ 1 Number value");
			targetStage = _stage;
			
			dragTarget = _dragTarget;
			dragBoundsLeft = _dragStartX;
			dragBoundsTop = _dragStartY;
			dragBoundsWidth = _dragDistance;
			dragBoundsHeight = 0;
			dragBoundsRect = new Rectangle(dragBoundsLeft, dragBoundsTop, dragBoundsWidth, dragBoundsHeight);
			flag_snapPixel = _snapPixel;
			
			makeMouseInteraction();
			setPercentage(_initPercentage);
			
			if(_flagUseWheel) {
				flag_useWheel = true;
				interactiveObjCreateWheelEvent = _interactiveObjectCreateWheelEvent
				changePercentageWheelValue = _changePercentagePerWheelTick;
				makeWheelInteraction();
			}
		}
		
		/**
		 * 
		 * @param e
		 */
		override protected function dragTargetDragInteraction(e:MouseEvent):void {
			if(flag_dragStatus) return;
			flag_dragStatus = true;
			
			targetStage.addEventListener(MouseEvent.MOUSE_UP, dragTargetRelease);
			targetStage.addEventListener(MouseEvent.MOUSE_MOVE, dragTargetMove);
			
			dragTarget.startDrag(false, dragBoundsRect);
			
			sliderValue = (dragTarget.x - dragBoundsLeft) / dragBoundsWidth;
			if(isNaN(sliderValue)) {
				trace("[com.vwonderland.control.slider.SliderHorizontal] slider value is NaN. set zero");
				sliderValue = 0;
			}
			
			sliderValueStock = sliderValue;
			dispatchPressEvent();
		}
		
		/**
		 * 
		 * @param e
		 */
		override protected function dragTargetMove(e:MouseEvent = null):void {
			if (e) e.updateAfterEvent();
			
			sliderValue = (dragTarget.x - dragBoundsLeft) / dragBoundsWidth;
			if(isNaN(sliderValue)) {
				trace("[com.vwonderland.control.slider.SliderHorizontal] slider value is NaN. set zero");
				sliderValue = 0;
			}
			sliderValueStock = sliderValue;
			dragTarget.startDrag(false, dragBoundsRect); //drag도중, restrictDragDistance() Function을 통하여 실제 slide 수행 가능한 limit 범위의 변경 적용
			
			dispatchDragEvent();
		}
		
		override protected function setPercentage(_percentage:Number):void {
			if(_percentage < 0 || _percentage > 1) throw new Error("[com.vwonderland.control.slider.SliderHorizontal] _percentage parameter must set 0 ~ 1 Number value");
			sliderValue = sliderValueStock = _percentage;
			
			if(flag_snapPixel) {
				dragTarget.y = Math.floor(dragBoundsTop);
				dragTarget.x = Math.floor(dragBoundsLeft + (dragBoundsWidth * sliderValue));
			}else{
				dragTarget.y = dragBoundsTop;
				dragTarget.x = dragBoundsLeft + (dragBoundsWidth * sliderValue);
			}
		}
		
		protected function checkRestrictValue(_restrictDistance:Number):Number {
			var restrictDistance:Number = _restrictDistance;
			var restrictValue:Number = _restrictDistance / dragBoundsWidth;
			
			if(restrictValue > 1) {
				trace("[com.vwonderland.control.slider.SliderHorizontal] drag 제한 범위가 drag 가능한 범위를 초과합니다. drag 제한 범위는 drag 가능한 범위 값으로 변경 조정됩니다.");
				restrictDistance = dragBoundsWidth;
			}
			if(restrictValue < 0) {
				trace("[com.vwonderland.control.slider.SliderHorizontal] drag 제한 범위가 0보다 작습니다. drag 제한 범위는 0으로 변경 조정됩니다.");
				restrictDistance = 0;
			}
			return restrictDistance;
		}
	}
}