/**
 * Licensed under the MIT License
 *
 * Copyright (c) 2010 VW
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 
 */

package com.vwonderland.net {
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	
	/**
	 * HyperLink, Javascript Link Utils
	 * @example Basic usage:<listing version="3.0">
	//url Link
	var url:String = "http://www.v-wonderland.com/";
	Link.getURL(url);
	Link.getURL(url, "_blank");
	
	//javascript call
	var javascriptFunctionName:String = "callJS"; //javascript callJS() 함수명
	Link.getURL(javascriptFunctionName, "javascript"); //단독 javascript 함수 실행
	Link.getURL(javascriptFunctionName, "javascript", param_1, param_2, param_3...); //parameter를 가지는 javascript 함수 실행 
	
	//javascript call (직접 String 정의 사용방법)
	Link.getURL("javascript:callJS()"); //단독 javascript 함수 실행
	Link.getURL("javascript:callJS('param_1', 'param_2', 'param_3')"); //parameter를 가지는 javascript 함수 실행
	 *    </listing>
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  19.07.2010
	 */	
	public class Link 
	{
		public static const BLANK:String = "_blank";
		
		public static const PARENT:String = "_parent";
		
		public static const SELF:String = "_self";
		
		public static const TOP:String = "_top";
		
		public static const JAVASCRIPT:String = "javascript";
		
		/**
		 * URL link 기능 및 javascript 실행 기능 제공
		 * @param _url
		 * @param _window
		 */
		public static function getURL(_url:String, _window:String = "_self", ...jsParamRest):void {
			if(String(_url) == "") {
				trace("[com.vwonderland.net.Link.getURL] URL or Javascript String 정보가 존재하지 않습니다.");
				return;
			}
			
			var request:URLRequest = new URLRequest(_url);
			try {
				if (_window == "javascript") {
					if(Capabilities.playerType == "StandAlone" || Capabilities.playerType == "External") {
						trace("[com.vwonderland.net.Link.getURL] Link Javascript Func :", _url);
						if(jsParamRest.length > 0) trace("[com.vwonderland.net.Link.getURL] Link Javascript param :", jsParamRest);
						return;
					}
					
					if(jsParamRest.length > 0) {
						jsParamRest.unshift(_url);
						ExternalInterface.call.apply(null, jsParamRest);
					}else{
						ExternalInterface.call(_url);
					}
				}else {
					if(Capabilities.playerType == "StandAlone" || Capabilities.playerType == "External") {
						trace("[com.vwonderland.net.Link.getURL] Link url    :", _url);
						trace("[com.vwonderland.net.Link.getURL] Link window :", _window);
						return;
					}
					navigateToURL(request, _window);
				}
            }
            catch (e:Error) {
				trace("[com.vwonderland.net.Link.getURL] URLRequest Error");
            }
		}
		
		/**
		 * Constructor
		 */
		public function Link():void {
		}
	}
}