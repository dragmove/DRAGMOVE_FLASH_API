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

package com.vwonderland.control.navigation 
{
	import com.vwonderland.base.AbstractControllableMovieClip;
	import com.vwonderland.control.SimpleTimer;
	import com.vwonderland.event.CustomEvent;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	
	/**
	 * Abstract depth1 navigation class
	 * @example <b>Required Setting to use AbstractNaviDepth1</b>
				<ul><li>아래의 구현 예시 구문에 사용된 Navi Class는 AbstractNaviDepth1 Class를 상속한, 예시 Class 입니다. 직접 Navi 관련 Class는 별도 정의하여 만들어야 합니다. </li>
					<li>아래의 구현 예시 구문에 사용된 NaviButtonDepth1 Class는 AbstractControllableMovieClip Class를 상속한, 예시 Class 입니다. 직접 Depth1 Button 관련 Class는 별도 정의하여 만들어야 합니다. </li>
					<li>setInstance() - 반드시 Navigation button들의 ROLL_OVER, ROLL_OUT, CLICK MouseEvent는 <b>depth1BtnMouseInteraction</b> Function을 eventListener로 등록해야 합니다. </li>
					<li>rollOverDetailDepth1BtnInteraction() - 반드시 currentStatusDepth1 변수는 <b>rollOverDetailDepth1BtnInteraction</b> Function 내에서 설정되어야 합니다.</li></ul>
					<p/>Basic usage: <listing version="3.0">
	private var xml:XML;
	private var _navigation:Navi;
	
	//XML setting
	xml = 
	&#60;data&#62;
		&#60;name&#62;&#60;![CDATA[Index]]&#62;&#60;/name&#62;
		&#60;linkURL target="_self"&#62;&#60;![CDATA[/]]&#62;&#60;/linkURL&#62;
	
		&#60;depth1 pageCode="01"&#62;
			&#60;name&#62;&#60;![CDATA[메뉴_1]]&#62;&#60;/name&#62;
			&#60;linkURL target="_self"&#62;&#60;![CDATA[/menu_1.html]]&#62;&#60;/linkURL&#62;
		&#60;/depth1&#62;
			
		&#60;depth1 pageCode="02"&#62;
			&#60;name&#62;&#60;![CDATA[메뉴_2]]&#62;&#60;/name&#62;
			&#60;linkURL target="_self"&#62;&#60;![CDATA[/menu_2.html]]&#62;&#60;/linkURL&#62;
		&#60;/depth1&#62;
			
		&#60;depth1 pageCode="03"&#62;
			&#60;name&#62;&#60;![CDATA[메뉴_3]]&#62;&#60;/name&#62;
			&#60;linkURL target="_self"&#62;&#60;![CDATA[/menu_3.html]]&#62;&#60;/linkURL&#62;
		&#60;/depth1&#62;
	&#60;/data&#62;
	
	//1depth navigation instance make, use
	var paramObj:&#42; = new Object();
	paramObj.xml = xml;
	
	_navigation = new Navi();
	_navigation.init(paramObj); //navigation shape, button setting
	this.addChild(_navigation);
	
	var pageCodeNo:int = 1;
	_navigation.activateNavi(pageCodeNo); //1depth button_1 activation. external depth1 pageCode setting
	
	//make extra Navi Class extends AbstractNaviDepth1
	public class Navi extends AbstractNaviDepth1
	{
		private const GAP_Y_BUTTON:Number = 20;
		private var xml:XML;
		private var btnArr:Array;
		private var btnNum:int;
		
		public function Navi()
		{
			GAP_TIMER = 500; // Timer gap setting
		}
		
		override protected function setInstance(_paramObj:Object):void {
			xml = _paramObj.xml; //_paramObj from init(_obj:Object = null) public method
			
			btnNum = xml.depth1.length(); //navigation menu node length
			btnArr = new Array();
			
			var paramObj:Object;
			var _d1Btn:NaviButtonDepth1;
			for (var i:uint = 0; i &#60; btnNum; ++i) {
				paramObj = new Object();
				paramObj.name = String(xml.depth1&#91;i&#93;.name);
				paramObj.linkURL = String(xml.depth1&#91;i&#93;.linkURL);
				paramObj.target = String(xml.depth1&#91;i&#93;.linkURL.&#64;target);
				
				//NaviButtonDepth1 Class는 AbstractControllableMovieClip Class를 상속한, 예시 Class 입니다. 직접 Depth1 Button 관련 Class는 별도 정의하여 만들어야 합니다.
				_d1Btn = new NaviButtonDepth1();
				_d1Btn.extraObject = paramObj;
				
				_d1Btn.index = int(i + 1);
				_d1Btn.y = i &#42; GAP_Y_BUTTON;
				_d1Btn.init();
				this.addChild(_d1Btn);
				
				//반드시 Navigation button들의 ROLL_OVER, ROLL_OUT, CLICK MouseEvent는 depth1BtnMouseInteraction Function을 eventListener로 등록해야 합니다.
				//각 MouseEvent 발생시의 상세 기능 구현은 rollOverDetailDepth1BtnInteraction, rollOutDetailDepth1BtnInteraction, clickDetailDepth1BtnInteraction Function 내에 기술해야 합니다.
				InteractionUtil.makeSimpleButtonInteraction(_d1Btn, depth1BtnMouseInteraction); //buttons must connect depth1BtnMouseInteraction eventListener 
				btnArr.push(_d1Btn);
			}
			
			if (timer != null) timer.start();
		}
		
		override protected function rollOverDetailDepth1BtnInteraction(e:MouseEvent):void {
			//반드시 currentStatusDepth1 변수는 rollOverDetailDepth1BtnInteraction Function 내에서 설정되어야 합니다. 
			//rollOverDetailDepth1BtnInteraction Function 실행 이후, displayNaviStatus(currentStatusDepth1); 이 실행됩니다.
			currentStatusDepth1 = int(e.currentTarget.index);
		}
		
		override protected function rollOutDetailDepth1BtnInteraction(e:MouseEvent):void {
			//depth1 button rollOut Detail define
		}
		
		override protected function clickDetailDepth1BtnInteraction(e:MouseEvent):void {
			var _target:NaviButtonDepth1 = e.currentTarget as NaviButtonDepth1;
			Link.getURL(String(_target.extraObject.linkURL), String(_target.extraObject.target));
		}
		
		override protected function displayNaviStatus(_d1_index:int):void { //detail define navigation button visual interaction
			var _d1Btn:NaviButtonDepth1;
			for(var i:uint = 0; i &#60; btnArr.length; ++i) {
				_d1Btn = btnArr[i] as NaviButtonDepth1;
				
				if(_d1Btn.index != _d1_index) {
					_d1Btn.deactivate();
				} else {
					_d1Btn.activate();
				}
			}
		}
	}
	 
	//make extra NaviButtonDepth1 Class extends AbstractControllableMovieClip
	public class NaviButtonDepth1 extends AbstractControllableMovieClip
	{
		public function activate():void {
			TweenMax.to(_tf, 0.1, {tint:0xff0000, ease:Expo.easeOut} );
			TweenMax.to(_bg, 0.1, {tint:0x000000, ease:Expo.easeOut} );
		}
		
		public function deactivate():void {
			TweenMax.to(_tf, 0.5, {tint:null, ease:Cubic.easeOut} );
			TweenMax.to(_bg, 0.5, {tint:null, ease:Cubic.easeOut} );
		}
		
		private var _bottomLine:Sprite;
		private var _bg:Sprite;
		private var _tf:TextField;
		
		public function NaviButtonDepth1(){
		}
		
		override public function init(_obj:Object = null):void {
			_bg = SimpleRect.drawRectSprite(100, 20, 0xc8c6c3);
			this.addChild(_bg);
			
			_bottomLine = SimpleRect.drawRectSprite(100, 1, 0xffffff, 0.5);
			_bottomLine.y = 19;
			this.addChild(_bottomLine);
			
			_tf = TextFieldUtil.makeTF(80, 15, "dotum", 11,  0xffffff, false, false, false);
			if(extraObject != null) setTitle(String(extraObject.name));
			_tf.x = 9;
			_tf.y = 2;
			this.addChild(_tf);
		}
		
		private function setTitle(_title:String):void {
			if(_tf != null) TextFieldUtil.setTextByTextWidth(_title, _tf, "");
		}
	}
	 *    </listing>
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  12.08.2010
	 */
	public class AbstractNaviDepth1 extends AbstractControllableMovieClip {
		
		/**
		 * navigation control Timer
		 */
		protected var timer:SimpleTimer;
		
		/**
		 * navigation control Timer delay
		 */
		protected var GAP_TIMER:Number = 1000;
		
		/**
		 * navigation display depth1 value
		 * @see #activateDepth1
		 */
		protected var currentStatusDepth1:int;
		
		/**
		 * navigation activate depth1 value
		 * @see #currentStatusDepth1
		 */
		protected var activateDepth1:int;
		
		/**
		 * destroy AbstractNaviDepth1 instance 
		 */
		override public function destroy(_obj:Object = null):void {
			if(timer != null) {
				timer.destroy();
				timer = null;
			}
			destroyDetail(_obj);
		}
		
		/**
		 * (base detail logic exist) AbstractNaviDepth1 Class를 상속하여 구현된 navigation Instance를 외부로부터 활성화
		 * @param _d1_index 활성화시킬 button index
		 */
		public function	activateNavi(_d1_index:int):void {
			displayNaviStatus(_d1_index);
			currentStatusDepth1 = activateDepth1 = _d1_index;
		}
		
		/**
		 * (override detail define) AbstractNaviDepth1 Class의 기본 설정 내역의 destroy 처리를 제외한, setInstance Function을 통해 임의 정의한 부분의 destroy detail 정의
		 * @param _obj
		 */
		protected function destroyDetail(_obj:Object = null):void {
			//override define detail
		}
		
		/**
		 * (override detail define) instance variables setting - depth1 button의 depth1BtnMouseInteraction() eventListener 등록 필수 
		 * @param _paramObj
		 * @see #depth1BtnMouseInteraction()
		 */
		protected function setInstance(_paramObj:Object):void {
			//override instance setting
		}
		
		/**
		 * (override detail define) depth1 button rollover시 상태 변화 상세 정의 - currentStatusDepth1 정의 필수 
		 * @param e
		 * @see #depth1BtnMouseInteraction()
		 */
		protected function rollOverDetailDepth1BtnInteraction(e:MouseEvent):void {
			//override depth1 button rollover Detail define
			
			//example)
			//var _targetBtn:MovieClip = e.currentTarget as MovieClip;
			//currentStatusDepth1 = _targetBtn.index;
		}
		
		/**
		 * (override detail define) depth1 button rollOut시 상태 변화 상세 정의
		 * @param e
		 * @see #depth1BtnMouseInteraction()
		 */
		protected function rollOutDetailDepth1BtnInteraction(e:MouseEvent):void {
			//override depth1 button rollOut Detail define
		}
		
		/**
		 * (override detail define) depth1 button click시 상태 변화 상세 정의
		 * @param e
		 * @see #depth1BtnMouseInteraction()
		 */
		protected function clickDetailDepth1BtnInteraction(e:MouseEvent):void {
			//override depth1 button click Detail define
		}
		
		/**
		 * (override detail define) display 상태 변화 상세 정의
		 * @param _d1_index
		 */
		protected function displayNaviStatus(_d1_index:int):void {
			//override depth1 button display change logic
		}
		
		
		/**
		 * Contructor
		 */
		public function AbstractNaviDepth1() {
		}
		
		
		override public function init(_obj:Object = null):void {
			setTimer(GAP_TIMER, false);
			setInstance(_obj);
		}
		
		/**
		 * 
		 * @param _delayTime
		 * @param _flag_directStart
		 */
		protected function setTimer(_delayTime:Number = 1000, _flag_directStart:Boolean = false):void {
			if(timer != null) {
				timer.destroy();
				timer = null;
			}
			
			timer = new SimpleTimer(_delayTime, this, timerInitialization, _flag_directStart);
		}
		
		/**
		 * 
		 * @param e
		 */
		protected function timerInitialization(e:TimerEvent = null):void {
			if(timer != null) {			
				timer.stop();
				timerInitializationAction();
			}
		}
		
		/**
		 * 
		 */
		protected function timerInitializationAction():void {
			displayNaviStatusByTimer(activateDepth1);
			currentStatusDepth1 = activateDepth1;
		}
		
		/**
		 * (base detail logic exist) depth1 button Mouse interaction Event handler
		 * @param e
		 * @see #setInstance()
		 */
		protected function depth1BtnMouseInteraction(e:MouseEvent):void {
			switch(e.type) {
				case MouseEvent.ROLL_OVER :
				if(timer != null) timer.stop();
				rollOverDetailDepth1BtnInteraction(e);
				displayNaviStatus(currentStatusDepth1);
				break;
				
				case MouseEvent.ROLL_OUT :
				if(timer != null) timer.start();
				rollOutDetailDepth1BtnInteraction(e);
				break;
				
				case MouseEvent.CLICK :
				clickDetailDepth1BtnInteraction(e);
				break;
			}
		}
		
		/**
		 * (base detail logic exist) Timer 실행을 통한  display 상태 변화 정의(기본적으로 displayNaviStatus Function 실행)
		 * @param _d1_index
		 */
		protected function displayNaviStatusByTimer(_d1_index:int):void {
			displayNaviStatus(_d1_index);
		}
	}
}