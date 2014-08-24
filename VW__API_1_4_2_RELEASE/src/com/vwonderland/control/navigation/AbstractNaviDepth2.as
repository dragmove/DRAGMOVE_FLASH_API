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
	
	import flash.events.TimerEvent;

	/**
	 * Abstract depth2 navigation class
	 * @example <b>Required Setting to use AbstractNaviDepth2</b>
				<ul><li>아래의 구현 예시 구문에 사용된 Navi Class는 AbstractNaviDepth1 Class를 상속한, 예시 Class 입니다. 직접 Navi 관련 Class는 별도 정의하여 만들어야 합니다. </li>
					<li>아래의 구현 예시 구문에 사용된 NaviButtonDepth1 Class는 AbstractControllableMovieClip Class를 상속한, 예시 Class 입니다. 직접 Depth1 Button 관련 Class는 별도 정의하여 만들어야 합니다. </li>
					<li>아래의 구현 예시 구문에 사용된 NaviButtonDepth2 Class는 AbstractControllableMovieClip Class를 상속한, 예시 Class 입니다. 직접 Depth2 Button 관련 Class는 별도 정의하여 만들어야 합니다. </li>
					<li>반드시 1depth button MouseEvent 발생시, <b>AbstractNaviDepth2.ROLLOVER_DEPTH1_BUTTON, AbstractNaviDepth2.ROLLOUT_DEPTH1_BUTTON, AbstractNaviDepth2.CLICK_DEPTH1_BUTTON</b> CustomEvent를 발생시켜야 합니다. 자세한 사항은 구현 예시 구문의 NaviButtonDepth1 Class 내부 구현 참조바랍니다. </li> 
					<li>반드시 2depth button MouseEvent 발생시, <b>AbstractNaviDepth2.ROLLOVER_DEPTH2_BUTTON, AbstractNaviDepth2.ROLLOUT_DEPTH2_BUTTON, AbstractNaviDepth2.CLICK_DEPTH2_BUTTON</b> CustomEvent를 발생시켜야 합니다. 자세한 사항은 구현 예시 구문의 NaviButtonDepth1 Class 내부 구현 참조바랍니다. </li>
					<li>rollOverDetailDepth1BtnInteraction() - 반드시 currentStatusDepth1 변수가 <b>rollOverDetailDepth1BtnInteraction</b> Function 내에서 설정되어야 합니다.</li>
					<li>rollOverDetailDepth2BtnInteraction() - 반드시 currentStatusDepth1, currentStatusDepth2 변수가 <b>rollOverDetailDepth2BtnInteraction</b> Function 내에서 설정되어야 합니다.</li></ul>
					<p/>Basic usage: <listing version="3.0">
	private var xml:XML;
	private var _navigation:Navi;
	
	//XML setting
	xml = 
	&#60;data&#62;
		&#60;depth1 pageCode="0100"&#62;
			&#60;name&#62;&#60;![CDATA[메뉴_1]]&#62;&#60;/name&#62;
			&#60;linkURL target="_self"&#62;&#60;![CDATA[/menu_1.html]]&#62;&#60;/linkURL&#62;
			
			&#60;depth2 pageCode="0101"&#62;
				&#60;name&#62;&#60;![CDATA[메뉴_1_1]]&#62;&#60;/name&#62;
				&#60;linkURL target="_self"&#62;&#60;![CDATA[/menu_1_1.html]]&#62;&#60;/linkURL&#62;
			&#60;/depth2&#62;
			
			&#60;depth2 pageCode="0102"&#62;
				&#60;name&#62;&#60;![CDATA[메뉴_1_2]]&#62;&#60;/name&#62;
				&#60;linkURL target="_self"&#62;&#60;![CDATA[/menu_1_2.html]]&#62;&#60;/linkURL&#62;
			&#60;/depth2&#62;
		&#60;/depth1&#62;
		
		&#60;depth1 pageCode="0200"&#62;
			&#60;name&#62;&#60;![CDATA[메뉴_2]]&#62;&#60;/name&#62;
			&#60;linkURL target="_self"&#62;&#60;![CDATA[/menu_2.html]]&#62;&#60;/linkURL&#62;
			
			&#60;depth2 pageCode="0201"&#62;
				&#60;name&#62;&#60;![CDATA[메뉴_2_1]]&#62;&#60;/name&#62;
				&#60;linkURL target="_self"&#62;&#60;![CDATA[/menu_2_1.html]]&#62;&#60;/linkURL&#62;
			&#60;/depth2&#62;
			
			&#60;depth2 pageCode="0202"&#62;
				&#60;name&#62;&#60;![CDATA[메뉴_2_2]]&#62;&#60;/name&#62;
				&#60;linkURL target="_self"&#62;&#60;![CDATA[/menu_2_2.html]]&#62;&#60;/linkURL&#62;
			&#60;/depth2&#62;
			
			&#60;depth2 pageCode="0203"&#62;
				&#60;name&#62;&#60;![CDATA[메뉴_2_3]]&#62;&#60;/name&#62;
				&#60;linkURL target="_self"&#62;&#60;![CDATA[/menu_2_3.html]]&#62;&#60;/linkURL&#62;
			&#60;/depth2&#62;
		&#60;/depth1&#62;
		
		&#60;depth1 pageCode="0300"&#62;
			&#60;name&#62;&#60;![CDATA[메뉴_3]]&#62;&#60;/name&#62;
			&#60;linkURL target="_self"&#62;&#60;![CDATA[/menu_3.html]]&#62;&#60;/linkURL&#62;
		&#60;/depth1&#62;
		
		&#60;depth1 pageCode="0400"&#62;
			&#60;name&#62;&#60;![CDATA[메뉴_4]]&#62;&#60;/name&#62;
			&#60;linkURL target="_self"&#62;&#60;![CDATA[/menu_4.html]]&#62;&#60;/linkURL&#62;
			
			&#60;depth2 pageCode="0401"&#62;
				&#60;name&#62;&#60;![CDATA[메뉴_4_1]]&#62;&#60;/name&#62;
				&#60;linkURL target="_self"&#62;&#60;![CDATA[/menu_4_1.html]]&#62;&#60;/linkURL&#62;
			&#60;/depth2&#62;
			
			&#60;depth2 pageCode="0402"&#62;
				&#60;name&#62;&#60;![CDATA[메뉴_4_2]]&#62;&#60;/name&#62;
				&#60;linkURL target="_self"&#62;&#60;![CDATA[/menu_4_2.html]]&#62;&#60;/linkURL&#62;
			&#60;/depth2&#62;
		&#60;/depth1&#62;
	&#60;/data&#62;
	
	//2depth navigation instance make, use
	var paramObj:&#42; = new Object();
	paramObj.xml = xml;
	
	_navigation = new Navi();
	_navigation.init(paramObj); //navigation shape, button setting
	this.addChild(_navigation);
	
	var pageCodeDepth1:int = 1;
	var pageCodeDepth2:int = 2;
	_navigation.activateNavi(1, 2); //1depth button_1, 2depth button_2 activation
	
	//make extra Navi Class extends AbstractNaviDepth2
	public class Navi extends AbstractNaviDepth2
	{
		private const HEIGHT_DEPTH1_BUTTON:Number = 20;
		private const HEIGHT_DEPTH2_BUTTON:Number = 20;
		private var xml:XML;
		private var depth1BtnArr:Array;
		private var depth1BtnNum:int;
		private var depth2BtnNumArr:Array;
		
		public function Navi()
		{
			GAP_TIMER = 500; // Timer gap private setting
		}
		
		override protected function setInstance(_paramObj:Object):void {
			xml = _paramObj.xml; //_paramObj from init(_obj:Object = null) public method
			
			depth1BtnNum = xml.depth1.length(); //navigation depth1 menu node length
			depth1BtnArr = new Array();
			depth2BtnNumArr = new Array();
			
			var paramObj:Object;
			var _d1Btn:NaviButtonDepth1;
			for (var i:uint = 0; i &#60; depth1BtnNum; ++i) {
				paramObj = new Object();
				paramObj.name = String(xml.depth1&#91;i&#93;.name);
				paramObj.linkURL = String(xml.depth1&#91;i&#93;.linkURL);
				paramObj.target = String(xml.depth1&#91;i&#93;.linkURL.&#64;target);
				
				//NaviButtonDepth1 Class는 AbstractControllableMovieClip Class를 상속한, 예시 Class 입니다. 직접 Depth1 Button 관련 Class는 별도 정의하여 만들어야 합니다.
				_d1Btn = new NaviButtonDepth1();
				_d1Btn.extraObject = paramObj;
				_d1Btn.index = int(i + 1);
				
				_d1Btn.init();
				_d1Btn.setDepth2Btn(xml, _d1Btn.index);
				
				_d1Btn.y = i &#42; HEIGHT_DEPTH1_BUTTON;
				this.addChild(_d1Btn);
				
				depth1BtnArr.push(_d1Btn);
				depth2BtnNumArr.push(xml.depth1[i].depth2.length());
			}
			if (timer != null) timer.start();
		}
		
		override protected function rollOverDetailDepth1BtnInteraction(e:CustomEvent):void { //AbstractNaviDepth2.ROLLOVER_DEPTH1_BUTTON CustomEvent 발생시 실행됩니다.
			//반드시 currentStatusDepth1 변수가 rollOverDetailDepth1BtnInteraction Function 내에서 설정되어야 합니다. 
			//rollOverDetailDepth1BtnInteraction Function 실행 이후, displayNaviStatusDepth1(currentStatusDepth1); 이 실행됩니다.
			currentStatusDepth1 = int(e.obj.depth1_index);
		}
		
		override protected function rollOutDetailDepth1BtnInteraction(e:CustomEvent):void { //AbstractNaviDepth2.ROLLOUT_DEPTH1_BUTTON CustomEvent 발생시 실행됩니다.
			//depth1 button rollOut Detail define
		}
		
		override protected function clickDetailDepth1BtnInteraction(e:CustomEvent):void { //AbstractNaviDepth2.CLICK_DEPTH1_BUTTON CustomEvent 발생시 실행됩니다.
			var _d1Btn:NaviButtonDepth1 = e.obj.target as NaviButtonDepth1;
			Link.getURL(String(_d1Btn.extraObject.linkURL), String(_d1Btn.extraObject.target));
		}
		
		override protected function displayNaviStatusDepth1(_d1_index:int=0, _obj:Object=null):void { //detail define navigation depth1 button visual interaction
			activateDepth1Btn(_d1_index);
			controlDepth1BtnPosY(_d1_index);
			displayNaviStatusDepth2(_d1_index, 0);
		}
		
		override protected function displayNaviStatusDepth2(_d1_index:int = 0, _d2_index:int = 0, _obj:Object = null):void { //detail define navigation depth2 button visual interaction
			activateDepth2Btn(_d1_index, _d2_index);
		}
		
		override protected function rollOverDetailDepth2BtnInteraction(e:CustomEvent):void { //AbstractNaviDepth2.ROLLOVER_DEPTH2_BUTTON CustomEvent 발생시 실행됩니다.
			//반드시 currentStatusDepth1, currentStatusDepth2가 rollOverDetailDepth2BtnInteraction Function 내에서 설정되어야 합니다. 
			//rollOverDetailDepth2BtnInteraction Function 실행 이후, displayNaviStatusDepth2(currentStatusDepth1, currentStatusDepth2); 이 실행됩니다.
			currentStatusDepth1 = int(e.obj.depth1_index);
			currentStatusDepth2 = int(e.obj.depth2_index);
		}
		
		override protected function rollOutDetailDepth2BtnInteraction(e:CustomEvent):void { //AbstractNaviDepth2.ROLLOUT_DEPTH2_BUTTON CustomEvent 발생시 실행됩니다.
			//depth2 button rollOut Detail define
		}
		
		override protected function clickDetailDepth2BtnInteraction(e:CustomEvent):void { //AbstractNaviDepth2.CLICK_DEPTH2_BUTTON CustomEvent 발생시 실행됩니다.
			var _d2Btn:NaviButtonDepth2 = e.obj.target as NaviButtonDepth2;
			Link.getURL(String(_d2Btn.extraObject.linkURL), String(_d2Btn.extraObject.target));
		}
		
		private function activateDepth1Btn(_d1_index:int):void { //depth1 button들의 활성화, 비활성화를 위한 임의 정의 함수
			var _d1Btn:NaviButtonDepth1;
			for(var i:uint = 0; i &#60; depth1BtnArr.length; ++i) {
				_d1Btn = depth1BtnArr[i] as NaviButtonDepth1;
				if(_d1Btn.index != _d1_index) {
					_d1Btn.deactivate();
				} else {
					_d1Btn.activate();
				}
			}
		}
		
		private function controlDepth1BtnPosY(_d1_index:int):void { //depth1 button들의 y위치 변경을 위한 임의 정의 함수
			var targetPosY:int = 0;
			var d2BtnNum:int = 0;
			var _d1Btn:NaviButtonDepth1;
			for(var i:uint = 0; i &#60; depth1BtnArr.length; ++i) {
				_d1Btn = depth1BtnArr[i] as NaviButtonDepth1;
				TweenMax.to(_d1Btn, 0.4, {y:targetPosY, ease:Quint.easeOut} );
				
				targetPosY = targetPosY + HEIGHT_DEPTH2_BUTTON;
				d2BtnNum = int(depth2BtnNumArr[_d1_index - 1]);
				if(_d1_index == _d1Btn.index) targetPosY = targetPosY + d2BtnNum &#42; HEIGHT_DEPTH2_BUTTON;
			}
		}
		
		private function activateDepth2Btn(_d1_index:int = 0, _d2_index:int = 0):void { //depth1 button 내부의 depth2 button들의 활성화, 비활성화를 위한 임의 정의 함수
			var _d1Btn:NaviButtonDepth1;
			for(var i:uint = 0; i &#60; depth1BtnArr.length; ++i) {
				_d1Btn = depth1BtnArr[i] as NaviButtonDepth1;
				if(_d1Btn.index != _d1_index) {
					_d1Btn.activateDepth2Btn(0);
					_d1Btn.openDepth2Menu(false);
				} else {
					_d1Btn.activateDepth2Btn(_d2_index);
					_d1Btn.openDepth2Menu(true);
				}
			}
		}
	}
	
	//make extra NaviButtonDepth1 Class extends AbstractControllableMovieClip
	public class NaviButtonDepth1 extends AbstractControllableMovieClip
	{
		public function	activate():void {
			TweenMax.to(_tf, 0.1, {tint:0xff0000, ease:Expo.easeOut} );
			TweenMax.to(_bg, 0.1, {tint:0x000000, ease:Expo.easeOut} );
		}
		
		public function	deactivate():void {
			TweenMax.to(_tf, 0.5, {tint:null, ease:Cubic.easeOut} );
			TweenMax.to(_bg, 0.5, {tint:null, ease:Cubic.easeOut} );
		}
		
		public function	activateDepth2Btn(_d2_index:int):void {
			var _d2Btn:NaviButtonDepth2;
			for(var i:uint = 0; i &#60; depth2BtnArr.length; ++i) {
				_d2Btn = depth2BtnArr[i] as NaviButtonDepth2;
				if(_d2Btn.index != _d2_index) {
					_d2Btn.deactivate();
				} else {
					_d2Btn.activate();
				}
			}
		}
		
		public function	openDepth2Menu(_flag_open:Boolean):void {
			if(depth2BtnArr.length &#60;= 0) return;
			if(_flag_open) {
				TweenMax.to(_depth2MenuContainerMask, 0.4, {height:depth2BtnArr.length &#42; 20, ease:Quint.easeOut} );
			}else{
				TweenMax.to(_depth2MenuContainerMask, 0.4, {height:0, ease:Quint.easeOut} );
			}
		}
		
		public function setDepth2Btn(_xml:XML, _d1_index:int):void {
			depth2BtnArr = new Array();
			var depth2BtnNum:int = _xml.depth1[_d1_index - 1].depth2.length();
			var _d2Btn:NaviButtonDepth2;
			var paramObj:&#42;;
			for (var i:uint = 0; i &#60; depth2BtnNum; ++i) {
				paramObj = new Object();
				paramObj.name = String(_xml.depth1[_d1_index - 1].depth2[i].name);
				paramObj.linkURL = String(_xml.depth1[_d1_index - 1].depth2[i].linkURL);
				paramObj.target = String(_xml.depth1[_d1_index - 1].depth2[i].linkURL.&#64;target);
				
				_d2Btn = new NaviButtonDepth2();
				_d2Btn.extraObject = paramObj;
				_d2Btn.index = int(i + 1);
				_d2Btn.y = i &#42; 20;
				_d2Btn.init();
				_depth2MenuContainer.addChild(_d2Btn);
				
				InteractionUtil.makeSimpleButtonInteraction(_d2Btn, depth2BtnMouseInteraction); //buttons must connect depth1BtnMouseInteraction eventListener 
				depth2BtnArr.push(_d2Btn);
			}
		}
		
		private var _btnCover:Sprite;
		private var _bottomLine:Sprite;
		private var _bg:Sprite;
		private var _tf:TextField;
		
		private var _depth2MenuContainer:Sprite;
		private var _depth2MenuContainerMask:Sprite;
		private var depth2BtnArr:Array;
		
		public function NaviButtonDepth1(){
		}
		
		override public function init(_obj:Object = null):void {
			//depth1 button setting
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
			
			_btnCover = SimpleRect.drawRectSprite(100, 20, 0, 0);
			InteractionUtil.makeSimpleButtonInteraction(_btnCover, depth1BtnMouseInteraction);
			this.addChild(_btnCover);
			
			//depth2MenuContainer, depth2MenuContainerMask setting
			_depth2MenuContainer = new Sprite();
			_depth2MenuContainer.y = 20;
			this.addChild(_depth2MenuContainer);
			
			_depth2MenuContainerMask = SimpleRect.drawRectSprite(100, 100, 0xff0000);
			_depth2MenuContainerMask.height = 0;
			_depth2MenuContainerMask.y = 20;
			this.addChild(_depth2MenuContainerMask);
			
			_depth2MenuContainer.mask = _depth2MenuContainerMask;
		}
		
		private function setTitle(_title:String):void {
			if(_tf != null) TextFieldUtil.setTextByTextWidth(_title, _tf, "");
		}
		
		private function depth1BtnMouseInteraction(e:MouseEvent):void {
			var paramObj:&#42; = new Object();
			paramObj.target = this;
			paramObj.depth1_index = int(this.index);
			
			switch(e.type) {
				case MouseEvent.ROLL_OVER :
					//반드시 1depth button MouseEvent.ROLL_OVER 발생시, AbstractNaviDepth2.ROLLOVER_DEPTH1_BUTTON CustomEvent를 발생시키고 상위의 Class에서 필요한 1depth button의 정보를 전달합니다.
					dispatchEvent(new CustomEvent(AbstractNaviDepth2.ROLLOVER_DEPTH1_BUTTON, paramObj));
				break;	
				
				case MouseEvent.ROLL_OUT :
					//반드시 1depth button MouseEvent.ROLL_OUT 발생시, AbstractNaviDepth2.ROLLOUT_DEPTH1_BUTTON CustomEvent를 발생시키고 상위의 Class에서 필요한 1depth button의 정보를 전달합니다.
					dispatchEvent(new CustomEvent(AbstractNaviDepth2.ROLLOUT_DEPTH1_BUTTON, paramObj));
				break;
				
				case MouseEvent.CLICK :
					//반드시 1depth button MouseEvent.CLICK 발생시, AbstractNaviDepth2.CLICK_DEPTH1_BUTTON CustomEvent를 발생시키고 상위의 Class에서 필요한 1depth button의 정보를 전달합니다.
					dispatchEvent(new CustomEvent(AbstractNaviDepth2.CLICK_DEPTH1_BUTTON, paramObj));
				break;
			}
		}
		
		private function depth2BtnMouseInteraction(e:MouseEvent):void {
			var paramObj:&#42; = new Object();
			
			paramObj.target = e.currentTarget as NaviButtonDepth2;
			paramObj.depth1_index = int(this.index);
			paramObj.depth2_index = int(e.currentTarget.index);
			
			switch(e.type) {
				case MouseEvent.ROLL_OVER :
					//반드시 2depth button MouseEvent.ROLL_OVER 발생시, AbstractNaviDepth2.ROLLOVER_DEPTH2_BUTTON CustomEvent를 발생시키고 상위의 Class에서 필요한 1depth button의 정보를 전달합니다.
					dispatchEvent(new CustomEvent(AbstractNaviDepth2.ROLLOVER_DEPTH2_BUTTON, paramObj));
				break;	
				
				case MouseEvent.ROLL_OUT :
					//반드시 2depth button MouseEvent.ROLL_OUT 발생시, AbstractNaviDepth2.ROLLOUT_DEPTH2_BUTTON CustomEvent를 발생시키고 상위의 Class에서 필요한 1depth button의 정보를 전달합니다.
					dispatchEvent(new CustomEvent(AbstractNaviDepth2.ROLLOUT_DEPTH2_BUTTON, paramObj));
				break;
				
				case MouseEvent.CLICK :
					//반드시 2depth button MouseEvent.CLICK 발생시, AbstractNaviDepth2.CLICK_DEPTH2_BUTTON CustomEvent를 발생시키고 상위의 Class에서 필요한 1depth button의 정보를 전달합니다.
					dispatchEvent(new CustomEvent(AbstractNaviDepth2.CLICK_DEPTH2_BUTTON, paramObj));
				break;
			}
		}	
	}
	
	//make extra NaviButtonDepth2 Class extends AbstractControllableMovieClip
	public class NaviButtonDepth2 extends AbstractControllableMovieClip
	{
		public function	activate():void {
			TweenMax.to(_tf, 0.1, {tint:0xff8400, ease:Expo.easeOut} );
			TweenMax.to(_bg, 0.1, {tint:0x444444, ease:Expo.easeOut} );
		}
		
		public function	deactivate():void {
			TweenMax.to(_tf, 0.5, {tint:null, ease:Cubic.easeOut} );
			TweenMax.to(_bg, 0.5, {tint:null, ease:Cubic.easeOut} );
		}
		
		private var _bottomLine:Sprite;
		private var _bg:Sprite;
		private var _tf:TextField;
		
		public function NaviButtonDepth2(){
		}
		
		override public function init(_obj:Object = null):void {
			_bg = SimpleRect.drawRectSprite(100, 20, 0x72716f);
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
	 * @since  05.10.2010
	 */
	
	public class AbstractNaviDepth2 extends AbstractControllableMovieClip 
	{
		/**
		 * (must dispatch) depth1 Button 객체 Mouse RollOver시, CustomEvent를 통해 발생시켜야 할 Event입니다.
		 * @see #rollOverDetailDepth1BtnInteraction()
		 */
		static public const ROLLOVER_DEPTH1_BUTTON:String = "com.vwonderland.control.navigation.AbstractNaviDepth2.ROLLOVER_DEPTH1_BUTTON";
		
		/**
		 * (must dispatch) depth1 Button 객체 Mouse RollOut시, CustomEvent를 통해 발생시켜야 할 Event입니다.
		 * @see #rollOutDetailDepth1BtnInteraction() 
		 */
		static public const ROLLOUT_DEPTH1_BUTTON:String = "com.vwonderland.control.navigation.AbstractNaviDepth2.ROLLOUT_DEPTH1_BUTTON";
		
		/**
		 * (must dispatch) depth1 Button 객체 Mouse Click시, CustomEvent를 통해 발생시켜야 할 Event입니다.
		 * @see #clickDetailDepth2BtnInteraction() 
		 */
		static public const CLICK_DEPTH1_BUTTON:String = "com.vwonderland.control.navigation.AbstractNaviDepth2.CLICK_DEPTH1_BUTTON";
		
		/**
		 * (must dispatch) depth2 Button 객체 Mouse RollOver시, CustomEvent를 통해 발생시켜야 할 Event입니다.
		 * @see #rollOverDetailDepth2BtnInteraction()
		 */
		static public const ROLLOVER_DEPTH2_BUTTON:String = "com.vwonderland.control.navigation.AbstractNaviDepth2.ROLLOVER_DEPTH2_BUTTON";
		
		/**
		 * (must dispatch) depth2 Button 객체 Mouse RollOut시, CustomEvent를 통해 발생시켜야 할 Event입니다.
		 * @see #rollOutDetailDepth2BtnInteraction() 
		 */
		static public const ROLLOUT_DEPTH2_BUTTON:String = "com.vwonderland.control.navigation.AbstractNaviDepth2.ROLLOUT_DEPTH2_BUTTON";
		
		/**
		 * (must dispatch) depth2 Button 객체 Mouse Click시, CustomEvent를 통해 발생시켜야 할 Event입니다.
		 * @see #clickDetailDepth2BtnInteraction() 
		 */
		static public const CLICK_DEPTH2_BUTTON:String = "com.vwonderland.control.navigation.AbstractNaviDepth2.CLICK_DEPTH2_BUTTON";
		
		/**
		 * navigation control Timer
		 * @default 
		 */
		protected var timer:SimpleTimer;
		
		/**
		 * navigation control Timer delay
		 * @default 
		 */
		protected var GAP_TIMER:Number = 1000;
		
		/**
		 * navigation display depth1 value
		 * @see #currentStatusDepth2
		 * @see #activateDepth1
		 * @see #activateDepth2
		 */
		protected var currentStatusDepth1:int;
		
		/**
		 * navigation display depth2 value
		 * @see #currentStatusDepth1
		 * @see #activateDepth1
		 * @see #activateDepth2 
		 */
		protected var currentStatusDepth2:int;
		
		/**
		 * navigation activate depth1 value
		 * @see #currentStatusDepth1 
		 * @see #currentStatusDepth2
		 * @see #activateDepth2
		 */
		protected var activateDepth1:int;
		
		/**
		 * navigation activate depth2 value
		 * @see #currentStatusDepth1
		 * @see #currentStatusDepth2 
		 * @see #activateDepth1
		 */
		protected var activateDepth2:int;
		
		
		/**
		 * destroy AbstractNaviDepth2 instance 
		 */
		override public function destroy(_obj:Object = null):void {
			if(timer != null) {
				timer.destroy();
				timer = null;
			}
			removeListeners();
			destroyDetail(_obj);
		}
		
		/**
		 * (override detail define) AbstractNaviDepth2 Class의 기본 설정 내역의 destroy 처리를 제외한, setInstance Function을 통해 임의 정의한 부분의 destroy detail 정의
		 * @param _obj
		 */
		protected function destroyDetail(_obj:Object = null):void {
			//override define detail
		}
		
		/**
		 * (base detail logic exist) AbstractNaviDepth2 Class를 상속하여 구현된 navigation Instance를 외부로부터 활성화
		 * @param _d1_index 	활성화시킬 depth1 button index
		 * @param _d2_index 	활성화시킬 depth2 button index
		 * @param _obj			추가 기능 구현을 위한 extra Variable
		 */
		public function	activateNavi(_d1_index:int, _d2_index:int, _obj:Object = null):void {
			displayNaviStatus(_d1_index, _d2_index, _obj);
			currentStatusDepth1 = activateDepth1 = _d1_index;
			currentStatusDepth2 = activateDepth2 = _d2_index;
		}
		
		/**
		 * (override detail define) instance variables setting
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
		protected function rollOverDetailDepth1BtnInteraction(e:CustomEvent):void {
			//override depth1 button rollover Detail define
			
			//example)
			//currentStatusDepth1 = int(e.obj.depth1_index);
		}
		
		/**
		 * (override detail define) depth1 button rollOut시 상태 변화 상세 정의
		 * @param e
		 * @see #depth1BtnMouseInteraction()
		 */
		protected function rollOutDetailDepth1BtnInteraction(e:CustomEvent):void {
			//override depth1 button rollOut Detail define 
		}
		
		/**
		 * (override detail define) depth1 button click시 상태 변화 상세 정의
		 * @param e
		 * @see #depth1BtnMouseInteraction()
		 */
		protected function clickDetailDepth1BtnInteraction(e:CustomEvent):void {
			//override depth1 button click Detail define
		}
		
		/**
		 * (override detail define) depth2 button rollover시 상태 변화 상세 정의 - currentStatusDepth1, currentStatusDepth2 정의 필수
		 * @param e
		 */
		protected function rollOverDetailDepth2BtnInteraction(e:CustomEvent):void {
			//override depth2 button rollover Detail define
			
			//example
			//currentStatusDepth1 = int(e.obj.depth1_index);
			//currentStatusDepth2 = int(e.obj.depth2_index);
		}
		
		/**
		 * (override detail define) depth2 button rollOut시 상태 변화 상세 정의
		 * @param e
		 */
		protected function rollOutDetailDepth2BtnInteraction(e:CustomEvent):void {
			//override depth2 button rollout Detail define
		}
		
		/**
		 * (override detail define) depth2 button click시 상태 변화 상세 정의
		 * @param e
		 */
		protected function clickDetailDepth2BtnInteraction(e:CustomEvent):void {
			//override depth2 button click Detail define
		}
		
		/**
		 * (override detail define) depth1 display 상태 변화 상세 정의
		 * @param _d1_index		depth1 index
		 * @param _obj			추가 기능 구현을 위한 extra Variable
		 * @see #displayNaviStatusDepth2()
		 * @see #displayNaviStatus()
		 */
		protected function displayNaviStatusDepth1(_d1_index:int = 0, _obj:Object = null):void {
			//override only depth1 button display change logic
		}
		
		/**
		 * (override detail define) depth2 display 상태 변화 상세 정의
		 * @param _d1_index		depth1 index
		 * @param _d2_index		depth2 index
		 * @param _obj			추가 기능 구현을 위한 extra Variable
		 * @see #displayNaviStatusDepth1()
		 * @see #displayNaviStatus()
		 */
		protected function displayNaviStatusDepth2(_d1_index:int = 0, _d2_index:int = 0, _obj:Object = null):void {
			//override only depth2 button display change logic
		}
		
		/**
		 * (base detail logic exist) depth1, depth2 display 상태 변화 상세 정의
		 * @param _d1_index		depth1 index
		 * @param _d2_index		depth2 index
		 * @param _obj			추가 기능 구현을 위한 extra Variable
		 * @see #displayNaviStatusDepth1()
		 * @see #displayNaviStatusDepth2()
		 */
		protected function displayNaviStatus(_d1_index:int = 0, _d2_index:int = 0, _obj:Object = null):void {
			displayNaviStatusDepth1(_d1_index, _obj);
			displayNaviStatusDepth2(_d1_index, _d2_index, _obj);
		}
		
		/**
		 * (base detail logic exist) Timer 실행을 통한  display 상태 변화 정의(기본적으로 displayNaviStatus Function 실행)
		 * @param _d1_index		depth1 index
		 * @param _d2_index		depth2 index
		 * @param _obj			추가 기능 구현을 위한 extra Variable
		 * @see #displayNaviStatus()
		 */
		protected function displayNaviStatusByTimer(_d1_index:int, _d2_index:int, _obj:Object = null):void {
			displayNaviStatus(_d1_index, _d2_index, _obj);
		}
		
		/**
		 * Contructor
		 */
		public function AbstractNaviDepth2() {
		}
		
		override public function init(_obj:Object = null):void {
			setTimer(GAP_TIMER, false);
			setListeners();
			setInstance(_obj);
		}
		
		/**
		 * 
		 */
		protected function setListeners():void {
			addEventListener(ROLLOVER_DEPTH1_BUTTON, depth1BtnMouseInteraction, true);
			addEventListener(ROLLOUT_DEPTH1_BUTTON, depth1BtnMouseInteraction, true);
			addEventListener(CLICK_DEPTH1_BUTTON, depth1BtnMouseInteraction, true);
			
			addEventListener(ROLLOVER_DEPTH2_BUTTON, depth2BtnMouseInteraction, true);
			addEventListener(ROLLOUT_DEPTH2_BUTTON, depth2BtnMouseInteraction, true);
			addEventListener(CLICK_DEPTH2_BUTTON, depth2BtnMouseInteraction, true);
			
			addEventListener(ROLLOVER_DEPTH1_BUTTON, depth1BtnMouseInteraction);
			addEventListener(ROLLOUT_DEPTH1_BUTTON, depth1BtnMouseInteraction);
			addEventListener(CLICK_DEPTH1_BUTTON, depth1BtnMouseInteraction);
			
			addEventListener(ROLLOVER_DEPTH2_BUTTON, depth2BtnMouseInteraction);
			addEventListener(ROLLOUT_DEPTH2_BUTTON, depth2BtnMouseInteraction);
			addEventListener(CLICK_DEPTH2_BUTTON, depth2BtnMouseInteraction);
		}
		
		/**
		 * 
		 */
		protected function removeListeners():void {
			removeEventListener(ROLLOVER_DEPTH1_BUTTON, depth1BtnMouseInteraction, true);
			removeEventListener(ROLLOUT_DEPTH1_BUTTON, depth1BtnMouseInteraction, true);
			removeEventListener(CLICK_DEPTH1_BUTTON, depth1BtnMouseInteraction, true);
			
			removeEventListener(ROLLOVER_DEPTH2_BUTTON, depth2BtnMouseInteraction, true);
			removeEventListener(ROLLOUT_DEPTH2_BUTTON, depth2BtnMouseInteraction, true);
			removeEventListener(CLICK_DEPTH2_BUTTON, depth2BtnMouseInteraction, true);
			
			removeEventListener(ROLLOVER_DEPTH1_BUTTON, depth1BtnMouseInteraction);
			removeEventListener(ROLLOUT_DEPTH1_BUTTON, depth1BtnMouseInteraction);
			removeEventListener(CLICK_DEPTH1_BUTTON, depth1BtnMouseInteraction);
			
			removeEventListener(ROLLOVER_DEPTH2_BUTTON, depth2BtnMouseInteraction);
			removeEventListener(ROLLOUT_DEPTH2_BUTTON, depth2BtnMouseInteraction);
			removeEventListener(CLICK_DEPTH2_BUTTON, depth2BtnMouseInteraction);
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
			if(timer != null){
				timer.stop();
				timerInitializationAction();
			}
		}
		
		/**
		 * 
		 */
		protected function timerInitializationAction():void {
			displayNaviStatusByTimer(activateDepth1, activateDepth2);
			currentStatusDepth1 = activateDepth1;
			currentStatusDepth2 = activateDepth2;
		}
		
		/**
		 * (base detail logic exist) depth1 button Mouse interaction Event handler (ROLLOVER_DEPTH1_BUTTON, ROLLOUT_DEPTH1_BUTTON, CLICK_DEPTH1_BUTTON CustomEvent 관련 Event handler)
		 * @param e
		 * @see #setInstance()
		 * @see #depth2BtnMouseInteraction()
		 */
		protected function depth1BtnMouseInteraction(e:CustomEvent):void {
			switch(e.type) {
				case ROLLOVER_DEPTH1_BUTTON :
					if(timer != null) timer.stop();
					rollOverDetailDepth1BtnInteraction(e);
					displayNaviStatusDepth1(currentStatusDepth1);
				break;
				
				case ROLLOUT_DEPTH1_BUTTON :
					if(timer != null) timer.start();
					rollOutDetailDepth1BtnInteraction(e);
				break;
				
				case CLICK_DEPTH1_BUTTON :
					clickDetailDepth1BtnInteraction(e);
				break;
			}
		}
		
		/**
		 * (base detail logic exist) depth2 button Mouse interaction Event handler (ROLLOVER_DEPTH2_BUTTON, ROLLOUT_DEPTH2_BUTTON, CLICK_DEPTH2_BUTTON CustomEvent 관련 Event handler) 
		 * @param e
		 * @see #setInstance()
		 * @see #depth1BtnMouseInteraction()
		 */
		protected function depth2BtnMouseInteraction(e:CustomEvent):void {
			switch(e.type) {
				case ROLLOVER_DEPTH2_BUTTON :
					if(timer != null) timer.stop();
					rollOverDetailDepth2BtnInteraction(e);
					displayNaviStatusDepth2(currentStatusDepth1, currentStatusDepth2);
					break;	
				
				case ROLLOUT_DEPTH2_BUTTON :
					if(timer != null) timer.start();
					rollOutDetailDepth2BtnInteraction(e);
					break;
				
				case CLICK_DEPTH2_BUTTON :
					clickDetailDepth2BtnInteraction(e);
					break;
			}
		}
	}
}