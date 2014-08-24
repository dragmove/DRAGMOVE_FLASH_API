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
	import com.vwonderland.base.AbstractControllableConceptObject;
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * abstract slider class 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  16.08.2010
	 */	
	public class SliderBase extends AbstractControllableConceptObject {
		
		/**
		 * dragTarget 객체에 Mouse RollOver시 발생하는 Event입니다.
		 */
		static public const ROLLOVER_SLIDER:String = "com.vwonderland.control.slider.SliderBase.ROLLOVER_SLIDER";
		
		/**
		 * dragTarget 객체에 Mouse RollOut시 발생하는 Event입니다.
		 */
		static public const ROLLOUT_SLIDER:String = "com.vwonderland.control.slider.SliderBase.ROLLOUT_SLIDER";
		
		/**
		 * dragTarget 객체에 Mouse Press시 발생하는 Event입니다.
		 */
		static public const PRESS_SLIDER:String = "com.vwonderland.control.slider.SliderBase.PRESS_SLIDER";
		
		/**
		 * dragTarget 객체를 drag하는 도중, dragTarget 객체 외부에서 Mouse Release시 발생하는 Event입니다.
		 */
		static public const RELEASE_OUTSIDE_SLIDER:String = "com.vwonderland.control.slider.SliderBase.RELEASE_OUTSIDE_SLIDER";
		
		/**
		 * dragTarget 객체를 drag하는 도중, dragTarget 객체 내부에서 Mouse Release시 발생하는 Event입니다.
		 */
		static public const RELEASE_INSIDE_SLIDER:String = "com.vwonderland.control.slider.SliderBase.RELEASE_INSIDE_SLIDER";
		
		/**
		 * dragTarget 객체를 drag하는 도중, Mouse Release시 발생하는 Event입니다.
		 */
		static public const RELEASE_SLIDER:String = "com.vwonderland.control.slider.SliderBase.RELEASE_SLIDER";
		
		/**
		 * dragTarget 객체를 drag시 반복하여 발생하는 Event입니다.
		 */
		static public const DRAG_SLIDER:String = "com.vwonderland.control.slider.SliderBase.DRAG_SLIDER";
		
		/**
		 * dragTarget 객체를 Mouse Wheel scroll시 반복하여 발생하는 Event입니다.
		 */
		static public const WHEEL_SCROLL_SLIDER:String = "com.vwonderland.control.slider.SliderBase.WHEEL_SCROLL_SLIDER";
		
		/**
		 * 현재 dragTarget 객체를 drag하고 있는지의 여부 반환
		 */
		protected var flag_dragStatus:Boolean = false;
		
		/**
		 * drag할 객체
		 */
		protected var dragTarget:Sprite;
		
		/**
		 * dragTarget의 drag x축 시작 좌표 
		 */
		protected var dragBoundsLeft:Number;
		
		/**
		 * dragTarget의 drag y축 시작 좌표
		 */
		protected var dragBoundsTop:Number;
		
		/**
		 * dragTarget의 drag 가능한 x축 범위
		 */
		protected var dragBoundsWidth:Number;
		
		/**
		 * dragTarget의 drag 가능한 y축 범위
		 */
		protected var dragBoundsHeight:Number;
		
		/**
		 * dragTarget의 drag 가능한 범위 Rectangle 
		 */
		protected var dragBoundsRect:Rectangle;
		
		/**
		 * slider scroll이 이뤄지는 stage
		 */
		protected var targetStage:Stage;
		
		/**
		 * sliderValue 의 내부 저장소
		 */
		protected var sliderValueStock:Number;
		
		/**
		 * slider percentage value (0 ~ 1 사이의 slider value)
		 */
		protected var sliderValue:Number = 0;
		
		/**
		 * slider restrictPercentage value (0 ~ 1 사이의 slider value 사이의 실제 slide 수행 가능한 limit value)
		 */
		protected var restrictSliderValue:Number = 1;
		
		/**
		 * dragTarget의 x, y 위치가 int type으로 pixel과 맞물리는지의 설정 여부
		 */
		protected var flag_snapPixel:Boolean = false;
		
		/**
		 * MouseWheelEvent를 이용한 scroll 기능의 이용 여부
		 */
		protected var flag_useWheel:Boolean = false;
		
		/**
		 * MouseWheelEvent를 발생시키는 InteractiveObject (_flagUseWheel가 true일 경우) 
		 */
		protected var interactiveObjCreateWheelEvent:InteractiveObject;
		
		/**
		 * MouseWheelEvent의 발생시, percentage의 변화량
		 */
		protected var changePercentageWheelValue:Number;
		
		//================
		// Public function
		//================
		/**
		 * destroy slider 
		 * @param _obj
		 */
		override public function destroy(_obj:Object = null):void {
			if (dragTarget != null) {
				removeMouseInteraction();
				dragTarget = null;
			}
			targetStage.removeEventListener(MouseEvent.MOUSE_UP, dragTargetRelease);
			targetStage.removeEventListener(MouseEvent.MOUSE_MOVE, dragTargetMove);
			removeWheelInteraction();
			
			flag_dragStatus = false;
			dragBoundsRect = null;
			destroyDetail(_obj);
		}
		
		/**
		 * (override detail define) SliderBase Class의 기본 설정 내역의 destroy 처리를 제외한, setInstance Function을 통해 임의 정의한 부분의 destroy detail 정의
		 * @param _obj
		 */
		protected function destroyDetail(_obj:Object = null):void {
			//override define detail
		}
		
		/**
		 * get &#38; set slider percentage (0 ~ 1 사이의 slider value)
		 * @return Number
		 */
		public function get percentage():Number {
			return sliderValue;
		}
		
		/**
		 * get &#38; set slider percentage (0 ~ 1 사이의 slider value)
		 * @param _percentage
		 */
		public function set percentage(_percentage:Number):void {
			setPercentage(_percentage);
		}
		
		/**
		 * slider가 drag 되고 있는 상태인지의 여부 반환
		 * @return Boolean
		 */
		public function	get dragStatus():Boolean {
			return flag_dragStatus;
		}
		
		/**
		 * slider의 drag 가능한 최대 범위의 재정의
		 * @param _dragDistance
		 */
		public function setDragDistance(_dragDistance:Number):void {
			//override define detail
		}
		
		/**
		 * slider의 drag 가능한 최대 범위 사이의 실제 slide 수행 가능한 limit 범위의 정의
		 * @param _restrictDistance
		 */
		public function	restrictDragDistance(_restrictDistance:Number):void {
			//override define detail
		}
		
		/**
		 * set slider basic mouseEvent 
		 */
		public function makeMouseInteraction():void {
			if(dragTarget != null) {
				dragTarget.buttonMode = true;
				dragTarget.addEventListener(MouseEvent.ROLL_OVER, dragTargetMouseInteraction);
				dragTarget.addEventListener(MouseEvent.ROLL_OUT, dragTargetMouseInteraction);
				dragTarget.addEventListener(MouseEvent.MOUSE_DOWN, dragTargetDragInteraction);
			}
		}
		
		/**
		 * remove slider basic mouseEvent
		 */
		public function removeMouseInteraction():void {
			if(dragTarget != null) {
				dragTarget.buttonMode = false;
				dragTarget.removeEventListener(MouseEvent.ROLL_OVER, dragTargetMouseInteraction);
				dragTarget.removeEventListener(MouseEvent.ROLL_OUT, dragTargetMouseInteraction);
				dragTarget.removeEventListener(MouseEvent.MOUSE_DOWN, dragTargetDragInteraction);
			}
		}
		
		/**
		 * set slider mouseWheel Interaction
		 */
		public function	makeWheelInteraction():void {
			if(flag_useWheel == true && interactiveObjCreateWheelEvent != null) interactiveObjCreateWheelEvent.addEventListener(MouseEvent.MOUSE_WHEEL, dragTargetWheelInteraction);
		}
		
		/**
		 * remove slider mouseWheel Interaction
		 */
		public function	removeWheelInteraction():void {
			if(flag_useWheel == true && interactiveObjCreateWheelEvent != null) interactiveObjCreateWheelEvent.removeEventListener(MouseEvent.MOUSE_WHEEL, dragTargetWheelInteraction);
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
		 * @param _snapPixel							_dragTarget의 x, y축 위치가 int type으로 pixel과 맞물리는지의 설정 여부
		 * @param _flagUseWheel							MouseWheelEvent를 이용한 _dragTarget의 scroll 기능의 이용 여부
		 * @param _interactiveObjectCreateWheelEvent	MouseWheelEvent를 발생시키는 InteractiveObject (_flagUseWheel가 true일 경우) 
		 * @param _changePercentagePerWheelTick			MouseWheelEvent의 발생시, percentage의 변화량
		 */
		public function SliderBase(_stage:Stage, _dragTarget:Sprite, _dragStartX:Number, _dragStartY:Number, _dragDistance:Number, _initPercentage:Number = 0, _snapPixel:Boolean = false, _flagUseWheel:Boolean = false, _interactiveObjectCreateWheelEvent:InteractiveObject = null, _changePercentagePerWheelTick:Number = 0.1) { 
		}
		
		/**
		 * mouseWheel interaction
		 * @param e
		 */
		protected function dragTargetWheelInteraction(e:MouseEvent):void {
			var delta:int = int(e.delta);
			var wheelValue:Number;
			if(delta != 0) {
				if(delta > 0) {
					wheelValue = sliderValue - changePercentageWheelValue;
					if(wheelValue < 0) wheelValue = 0;
				}else{
					wheelValue = sliderValue + changePercentageWheelValue;
					if(wheelValue > restrictSliderValue) wheelValue = restrictSliderValue;
				}
				setPercentage(wheelValue);
				dispatchWheelScrollEvent();
			}
		}
		
		/**
		 * mouse rollOver, rollOut interaction
		 * @param e
		 */
		protected function dragTargetMouseInteraction(e:MouseEvent):void {
			switch(e.type) {
				case MouseEvent.ROLL_OVER :
					dispatchRollOverEvent();
				break;
				
				case MouseEvent.ROLL_OUT :
					dispatchRollOutEvent();
				break;
			}
		}
		
		/**
		 * (override detail define) mouse drag interaction
		 * @param e
		 */
		protected function dragTargetDragInteraction(e:MouseEvent):void {
			//override define detail
		}
		
		/**
		 * mouse releaseOutside, releaseInside interaction
		 * @param e
		 */
		protected function dragTargetRelease(e:MouseEvent):void {
			targetStage.removeEventListener(MouseEvent.MOUSE_UP, dragTargetRelease);
			targetStage.removeEventListener(MouseEvent.MOUSE_MOVE, dragTargetMove);
			setPercentage(sliderValue);
			
			if(e.target != dragTarget) {
				dragTarget.stopDrag();
				dispatchReleaseOutsideEvent();
			}else{
				dragTarget.stopDrag();
				dispatchReleaseInsideEvent();
			}
			dispatchReleaseEvent();
			flag_dragStatus = false;
		}
		
		/**
		 * (override detail define) mouse drag move interaction
		 * @param e
		 */
		protected function dragTargetMove(e:MouseEvent = null):void {
			//override define detail
		}
		
		/**
		 * (override detail define) define detail change by set percentage
		 * @param _percentage
		 */
		protected function setPercentage(_percentage:Number):void {
			//override define detail
		}
		
		/**
		 * dispatch dragTarget rollOver mouseEvent
		 */
		protected function dispatchRollOverEvent():void {
			dispatchEvent(new Event(ROLLOVER_SLIDER));
		}
		
		/**
		 * dispatch dragTarget rollOut mouseEvent
		 */
		protected function dispatchRollOutEvent():void {
			dispatchEvent(new Event(ROLLOUT_SLIDER));
		}
		
		/**
		 * dispatch dragTarget press mouseEvent
		 */
		protected function dispatchPressEvent():void {
			dispatchEvent(new Event(PRESS_SLIDER));
		}
		
		/**
		 * dispatch dragTarget drag mouseEvent
		 */
		protected function dispatchDragEvent():void {
			dispatchEvent(new Event(DRAG_SLIDER));
		}
		
		/**
		 * dispatch dragTarget release mouseEvent
		 */
		protected function dispatchReleaseEvent():void {
			dispatchEvent(new Event(RELEASE_SLIDER));
		}
		
		/**
		 * dispatch dragTarget releaseOutside mouseEvent
		 */
		protected function dispatchReleaseOutsideEvent():void {
			dispatchEvent(new Event(RELEASE_OUTSIDE_SLIDER));
		}
		
		/**
		 * dispatch dragTarget releaseInside mouseEvent
		 */
		protected function dispatchReleaseInsideEvent():void {
			dispatchEvent(new Event(RELEASE_INSIDE_SLIDER));
		}
		
		/**
		 * dispatch dragTarget wheelScroll mouseEvent
		 */
		protected function dispatchWheelScrollEvent():void {
			dispatchEvent(new Event(WHEEL_SCROLL_SLIDER));
		}
	}
}