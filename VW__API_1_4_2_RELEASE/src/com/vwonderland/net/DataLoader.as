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

package com.vwonderland.net
{
	import com.vwonderland.event.CustomEvent;
	
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLStream;
	import flash.net.URLVariables;
	
	/**
	 * server side script측에 data를 전달하고, 결과값를 받는 DataLoader
	 * @example Basic usage:<listing version="3.0">
		private var _dataLoader:DataLoader;
		private var dataURL:String = "http://www.v-wonderland.com/xml/exampleBoard.asp";
		
		public function TestDataLoader():void {
			
			//URLVariables setting
			var urlVariables:URLVariables = new URLVariables();
			urlVariables.pageNo = 1;
			urlVariables.mainCategory = 1;
			urlVariables.subCategory = 2;
			
			_dataLoader = new DataLoader(dataURL, urlVariables, URLLoaderDataFormat.VARIABLES, false);
			_dataLoader.addEventListener(DataLoader.LOAD_PROGRESS, loadDataProgress_hd);
			_dataLoader.addEventListener(DataLoader.LOAD_COMPLETE, loadDataComplete_hd);
			_dataLoader.addEventListener(DataLoader.LOAD_IOERROR, loadDataIOError_hd);
			_dataLoader.addEventListener(DataLoader.LOAD_SECURITYERROR, loadDataSecurityError_hd);
			
			_dataLoader.start();
		}
		
		private function removeXmlLoaderEventHandler():void {
			_dataLoader.removeEventListener(DataLoader.LOAD_PROGRESS, loadDataProgress_hd);
			_dataLoader.removeEventListener(DataLoader.LOAD_COMPLETE, loadDataComplete_hd);
			_dataLoader.removeEventListener(DataLoader.LOAD_IOERROR, loadDataIOError_hd);
			_dataLoader.removeEventListener(DataLoader.LOAD_SECURITYERROR, loadDataSecurityError_hd);
		}
		
		private function loadDataProgress_hd(e:CustomEvent):void {
			trace("_dataLoader.bytesLoaded :", _dataLoader.bytesLoaded);
			trace("_dataLoader.bytesTotal :", _dataLoader.bytesTotal);
			trace("_dataLoader.percentageLoaded :", _dataLoader.percentageLoaded);
		}
					
		private function loadDataComplete_hd(e:CustomEvent):void {
			trace("loadDataComplete_hd");
			var dataObj:&#42; = _dataLoader.getData();
			if(dataObj != null) {
				//if loaded data is Object type
				trace(dataObj.variableName_1);
				trace(dataObj.variableName_2);
				
				//if loaded data is xml type
				//System.useCodePage = false;
				//var _dataXML:XML = new XML(dataObj);
				//trace(_dataXML);
			}
		}
		
		private function loadDataIOError_hd(e:CustomEvent):void {
			trace("loadDataIOError_hd");
			removeXmlLoaderEventHandler();
		}
		
		private function loadDataSecurityError_hd(e:CustomEvent):void {
			trace("loadDataSecurityError_hd");
			removeXmlLoaderEventHandler();
		}
	 *    </listing>
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  07.09.2010
	 */
	public class DataLoader extends EventDispatcher
	{
		/**
		 * data load 작업이 진행되어 data가 수신될 경우 전달됩니다.
		 */
		static public const LOAD_PROGRESS:String = "com.vwonderland.net.DataLoader.LOAD_PROGRESS";
		
		/**
		 * URLLoader의 data load가 완료되었을 경우 전달됩니다. 
		 */
		static public const LOAD_COMPLETE:String = "com.vwonderland.net.DataLoader.LOAD_COMPLETE";
		
		/**
		 * data load 도중 IOError가 발생할 경우 전달됩니다.
		 */
		static public const LOAD_IOERROR:String = "com.vwonderland.net.DataLoader.LOAD_IOERROR";
		
		/**
		 * data load 도중 SecurityError가 발생할 경우 전달됩니다.
		 */
		static public const LOAD_SECURITYERROR:String = "com.vwonderland.net.DataLoader.LOAD_SECURITYERROR";
		
		private var _isLoading:Boolean = false;
		private var _isFinished:Boolean = false;
		
		private var _bytesLoaded:Number = 0;
		private var _bytesTotal:Number = 0;
		private var _percentageLoaded:Number = 0;
		
		private var _url:String;
		private var _urlRequest:URLRequest;
		private var _urlLoader:URLLoader;
		
		/**
		 * Load하는 data에 대한 bytesLoaded 반환
		 * @return 
		 */
		public function	get bytesLoaded():Number {
			return _bytesLoaded;
		}
		
		/**
		 * Load하는 data에 대한 bytesTotal 반환(data가 load되지 않는 경우에는 0을 반환합니다).
		 * @return 
		 */
		public function	get bytesTotal():Number {
			return _bytesTotal;
		}
		
		/**
		 * Load하는 data에 대한 percentage 반환
		 * @return 
		 */
		public function	get percentageLoaded():Number {
			return _percentageLoaded;
		}
		
		/**
		 * data에 대한 Load 완료 여부 반환
		 * @return 
		 */
		public function	get isFinished():Boolean {
			return _isFinished;
		}
		
		//=========================
		// public function
		//=========================
		/**
		 * destroy
		 * @param _obj
		 */
		public function	destroy(_obj:Object = null):void {
			if(_isLoading) _urlLoader.close();
			removeListeners(_urlLoader);
			
			_url = "";
			_urlRequest = null;
			_urlLoader = null;
			
			_isLoading = false;
			_isFinished = false;
			
			_bytesLoaded = 0;
			_bytesTotal = 0;
			_percentageLoaded = 0;
		}
		
		/**
		 * loaded data return
		 * @return 
		 */
		public function	getData():* {
			var _dataObj:* = _urlLoader.data;
			if(_dataObj == null) {
				if(_isLoading == false && _isFinished == true) { //load Finished
					trace("[com.vwonderland.net.DataLoader] Data load process가 완료되었으나, 반환된 Data는 null value를 가집니다.");
				}else{
					trace("[com.vwonderland.net.DataLoader] Data load process가 시작 or 완료되지 않아, 반환할 Data가 존재하지 않습니다. null을 반환합니다.");
				}
				
				return null;
			}
			
			return _dataObj;
		}
		
		/**
		 * DataLoader start send &#38; load data
		 * @throws Error
		 * @throws Error
		 */
		public function	start():void {
			if(_isLoading) _urlLoader.close();
			
			if(_urlRequest.url == "") {
				throw new Error( "[com.vwonderland.net.DataLoader] Data 전달을 위한 URL이 존재하지 않습니다." );
				return;
			}
			
			_isLoading = true;
			_isFinished = false;
			
			_bytesLoaded = 0;
			_bytesTotal = 0;
			_percentageLoaded = 0;
			
			try {
				_urlLoader.load(_urlRequest);
			} catch(error:Error) {
				throw new Error( "[com.vwonderland.net.DataLoader] DataLoader load Data Error" );
				return;
			}
		}
		
		//=========================
		// Constructor
		//=========================
		/**
		 * Constructor
		 * @param _targetURL send &#38; load data URL
		 * @param _urlVariables urlVariables
		 * @param _dataFormat URLLoaderDataFormat.VARIABLES or URLLoaderDataFormat.TEXT or URLLoaderDataFormat.BINARY
		 * @param _usePOSTtypeUrlRequest GET 방식 통신시 false, POST 방식 통신시 true 설정
		 */
		public function DataLoader(_targetURL:String, _urlVariables:URLVariables, _dataFormat:String = URLLoaderDataFormat.VARIABLES, _usePOSTtypeUrlRequest:Boolean = false)
		{
			super();
			_url = _targetURL;
			_urlRequest = new URLRequest(_targetURL);
			_urlRequest.data = _urlVariables;
			if(_usePOSTtypeUrlRequest) _urlRequest.method = URLRequestMethod.POST;
			
			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = _dataFormat;
			setListeners(_urlLoader);
		}
		
		/**
		 * 
		 * @param _urlLoaderInstance
		 */
		protected function setListeners(_urlLoaderInstance:URLLoader):void {
			_urlLoaderInstance.addEventListener(Event.COMPLETE, complete_hd);
			_urlLoaderInstance.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatus_hd);
			_urlLoaderInstance.addEventListener(IOErrorEvent.IO_ERROR, ioError_hd);
			_urlLoaderInstance.addEventListener(Event.OPEN, open_hd);
			_urlLoaderInstance.addEventListener(ProgressEvent.PROGRESS, progress_hd);
			_urlLoaderInstance.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError_hd);
		}
		
		/**
		 * 
		 * @param _urlLoaderInstance
		 */
		protected function removeListeners(_urlLoaderInstance:URLLoader):void {
			_urlLoaderInstance.removeEventListener(Event.COMPLETE, complete_hd);
			_urlLoaderInstance.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatus_hd);
			_urlLoaderInstance.removeEventListener(IOErrorEvent.IO_ERROR, ioError_hd);
			_urlLoaderInstance.removeEventListener(Event.OPEN, open_hd);
			_urlLoaderInstance.removeEventListener(ProgressEvent.PROGRESS, progress_hd);
			_urlLoaderInstance.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError_hd);
		}
		
		/**
		 * 
		 * @param event
		 */
		protected function open_hd(event:Event):void {
			//trace("open_hd :", event);
		}
		
		/**
		 * 
		 * @param event
		 */
		protected function httpStatus_hd(event:HTTPStatusEvent):void {
			//trace("httpStatus_hd :", event);
		}
		
		/**
		 * 
		 * @param event
		 */
		protected function complete_hd(event:Event):void {
			_isLoading = false;
			_isFinished = true;
			dispatchEvent(new CustomEvent(LOAD_COMPLETE));
		}
		
		/**
		 * 
		 * @param event
		 */
		protected function progress_hd(event:ProgressEvent):void {
			_bytesLoaded = event.bytesLoaded;
			_bytesTotal = event.bytesTotal;
			_percentageLoaded = _bytesLoaded / _bytesTotal;
			dispatchEvent(new CustomEvent(LOAD_PROGRESS));
		}
		
		/**
		 * 
		 * @param event
		 */
		protected function securityError_hd(event:SecurityErrorEvent):void {
			trace("[com.vwonderland.net.DataLoader] DataLoader SecurityError - " + String(_url) );
			dispatchEvent(new CustomEvent(LOAD_SECURITYERROR));
		}
		
		/**
		 * 
		 * @param event
		 */
		protected function ioError_hd(event:IOErrorEvent):void {
			trace("[com.vwonderland.net.DataLoader] DataLoader IOError - " + String(_url));
			dispatchEvent(new CustomEvent(LOAD_IOERROR));
		}
	}
}