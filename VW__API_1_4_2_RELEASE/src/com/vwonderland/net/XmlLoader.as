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
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLStream;
	
	/**
	 * 복수의 xml 파일을 Load하여 사용하기 위한 XmlLoader
	 * @example Basic usage:<listing version="3.0">
		private var _xmlLoader:XmlLoader;
		
		private function TestXmlLoader():void {
			_xmlLoader = new XmlLoader();
			
			//base required handler
			_xmlLoader.addEventListener(XmlLoader.LOAD_PROGRESS, loadProgress_hd);
			_xmlLoader.addEventListener(XmlLoader.LOAD_COMPLETE, loadComplete_hd);
			_xmlLoader.addEventListener(XmlLoader.LOAD_IOERROR, loadIOError_hd);
			_xmlLoader.addEventListener(XmlLoader.LOAD_SECURITYERROR, loadSecurityError_hd);
			
			//option handler
			_xmlLoader.addEventListener(XmlLoader.LOAD_PER_COMPLETE, loadPerComplete_hd);
			_xmlLoader.addEventListener(XmlLoader.PARSING_ERROR, parsingError_hd);
			_xmlLoader.addEventListener(XmlLoader.URLSTREAM_ERROR, urlStreamError_hd);
			_xmlLoader.addEventListener(XmlLoader.TOTALZERO_ERROR, totalZeroError_hd);
			
			//use
			_xmlLoader.addURL("../bin-debug/companyReport.xml", "first", true); //euc-kr, use cache data
			_xmlLoader.addURL("../bin-debug/companyVision.xml", "second", false, true, true); //utf-8, prevent cache data, POST type URLRequest
			_xmlLoader.start();
		}
		
		private function loadPerComplete_hd(e:CustomEvent):void {
			trace("_xmlLoader.bytesLoadedCurrent :", _xmlLoader.bytesLoadedCurrent);
			trace("_xmlLoader.bytesTotalCurrent :", _xmlLoader.bytesTotalCurrent);
			trace("_xmlLoader.percentageLoadedCurrent :", _xmlLoader.percentageLoadedCurrent);
			trace("_xmlLoader.bytesLoaded :", _xmlLoader.bytesLoaded);
			trace("_xmlLoader.bytesTotal :", _xmlLoader.bytesTotal);
			trace("_xmlLoader.percentageLoaded :", _xmlLoader.percentageLoaded);
		}
		
		private function parsingError_hd(e:CustomEvent):void {
			trace("parsingError");
		}
		
		private function loadProgress_hd(e:CustomEvent):void {
			trace("_xmlLoader.bytesLoadedCurrent :", _xmlLoader.bytesLoadedCurrent);
			trace("_xmlLoader.bytesTotalCurrent :", _xmlLoader.bytesTotalCurrent);
			trace("_xmlLoader.percentageLoadedCurrent :", _xmlLoader.percentageLoadedCurrent);
			trace("_xmlLoader.bytesLoaded :", _xmlLoader.bytesLoaded);
			trace("_xmlLoader.bytesTotal :", _xmlLoader.bytesTotal);
			trace("_xmlLoader.percentageLoaded :", _xmlLoader.percentageLoaded);
		}
		
		private function loadComplete_hd(e:CustomEvent):void {
			var _xml:XML = _xmlLoader.getXML("first") as XML;
			trace("_xml :", _xml);
			
			var _second_xml:XML = _xmlLoader.getXML("second") as XML;
			trace("_second_xml :", _second_xml);
		}
		
		private function loadSecurityError_hd(e:CustomEvent):void {
			trace("loadSecurityError_hd");
		}
		
		private function loadIOError_hd(e:CustomEvent):void {
			trace("loadIOError_hd");
		}
		
		private function urlStreamError_hd(e:CustomEvent):void {
			trace("urlStreamError_hd");
		}
		
		private function totalZeroError_hd(e:CustomEvent):void {
			trace("totalZeroError_hd");
		}
	 *    </listing>
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  22.07.2010
	 */
	public class XmlLoader extends EventDispatcher
	{
		/**
		 * xml 파일 load 작업이 진행되어 data가 수신될 경우 전달됩니다.
		 */
		static public const LOAD_PROGRESS:String = "com.vwonderland.net.XmlLoader.LOAD_PROGRESS";
		
		/**
		 * 1개의 xml 파일이 load 완료될 경우마다 전달됩니다.
		 */
		static public const LOAD_PER_COMPLETE:String = "com.vwonderland.net.XmlLoader.LOAD_PER_COMPLETE";
		
		/**
		 * 모든 xml 파일에 대한 load 완료와 load error 처리가 완료되었을 경우 전달됩니다(모든 xml 파일이 성공적으로 load되었을 경우에만 전달되는 이벤트가 아닙니다).
		 */
		static public const LOAD_COMPLETE:String = "com.vwonderland.net.XmlLoader.LOAD_COMPLETE";
		
		/**
		 * xml 파일 load 도중 IOError가 발생할 경우 전달됩니다.
		 */
		static public const LOAD_IOERROR:String = "com.vwonderland.net.XmlLoader.LOAD_IOERROR";
		
		/**
		 * xml 파일 load 도중 SecurityError가 발생할 경우 전달됩니다.
		 */
		static public const LOAD_SECURITYERROR:String = "com.vwonderland.net.XmlLoader.LOAD_SECURITYERROR";
		
		/**
		 * load된 xml 파일의 parsing 도중 Error가 발생할 경우 전달됩니다.  
		 */
		static public const PARSING_ERROR:String = "com.vwonderland.net.XmlLoader.PARSING_ERROR";
		
		/**
		 * xml 파일 load 도중 URLStream 관련 Error가 발생할 경우 전달됩니다.  
		 */
		static public const URLSTREAM_ERROR:String = "com.vwonderland.net.XmlLoader.URLSTREAM_ERROR";
		
		/**
		 * load된 xml 파일의 bytesTotal 속성의 값이 0일 경우 전달됩니다.
		 */
		static public const TOTALZERO_ERROR:String = "com.vwonderland.net.XmlLoader.TOTALZERO_ERROR";
		
		static public const UTF_8:String = "utf-8";
		
		static public const EUC_KR:String = "euc-kr";
		
		private var _isLoading:Boolean = false;
		private var _isFinished:Boolean = false;
		
		private var _bytesLoadedCurrent:Number = 0;
		private var _bytesTotalCurrent:Number = 0;
		private var _percentageLoadedCurrent:Number = 0;
		
		private var _bytesLoaded:Number = 0;
		private var _bytesTotal:Number = 0;
		private var _percentageLoaded:Number = 0;
		
		private var urlStream_arr:Array;
		private var loadItemInfo_arr:Array;
		private var loadedXml_arr:Array;
		
		private var addItemNum:uint = 0;
		private var loadingIndex:int = 0;
		
		private var _loadSuccessNum:int = 0;
		private var _loadFailNum:int = 0;
		private var _loadCompleteNum:int = 0;
		private var _bytesLoadedAccumulated:Number = 0;
		
		/**
		 * 현재 Load중인 xml 파일에 대한 bytesLoaded 반환
		 * @return Number
		 */
		public function	get bytesLoadedCurrent():Number {
			return _bytesLoadedCurrent;
		}
		
		/**
		 * 현재 Load중인 xml 파일에 대한 bytesTotal 반환
		 * @return 
		 */
		public function	get bytesTotalCurrent():Number {
			return _bytesTotalCurrent;
		}
		
		/**
		 * 현재 Load중인 xml 파일에 대한 percentage( bytesLoadedCurrent/bytesTotalCurrent ) 반환
		 * @return 
		 */
		public function	get percentageLoadedCurrent():Number {
			return _percentageLoadedCurrent;
		}
		
		/**
		 * Load하는 모든 xml 파일에 대한 bytesLoaded 반환
		 * @return 
		 */
		public function	get bytesLoaded():Number {
			return _bytesLoaded;
		}
		
		/**
		 * Load하는 모든 xml 파일에 대한 bytesTotal 반환. 모든 xml 파일의 connection이 연결되지 않았을 경우에는 0을 반환합니다.
		 * @return 
		 */
		public function	get bytesTotal():Number {
			return _bytesTotal;
		}
		
		/**
		 * Load하는 모든 xml 파일에 대한 percentage
		 * @return 
		 */
		public function	get percentageLoaded():Number {
			return _percentageLoaded;
		}
		
		/**
		 * 모든 xml 파일에 대한 Load 완료 여부 반환
		 * @return 
		 */
		public function	get isFinished():Boolean {
			return _isFinished;
		}
		
		/**
		 * addURL method를 통해 등록된 모든 xml 파일의 갯수 반환
		 * @return 
		 * @see #addURL()
		 */
		public function get itemTotal():uint {
			return loadItemInfo_arr.length;
		}
		
		/**
		 * xml 파일 Load중 IOError, SecurityError, URLStream loading Error 없이 Load 완료된 횟수 반환 
		 * @return 
		 */
		public function	get loadSuccessNum():uint {
			return _loadSuccessNum;
		}
		
		/**
		 * xml 파일 Load중 IOError, SecurityError, URLStream loading Error 발생 횟수 반환 
		 * @return 
		 */
		public function	get loadFailNum():uint { 
			return _loadFailNum;
		}
		
		//=========================
		// public function
		//=========================
		/**
		 * destroy
		 * @param _obj
		 */
		public function	destroy(_obj:Object = null):void {
			var _urlStream:URLStream;
			for(var i:uint = 0; i < urlStream_arr.length; ++i) {
				_urlStream = urlStream_arr[i];
				removeListeners(_urlStream);
				
				if(_isLoading) {
					try {
						_urlStream.close();
					} catch(error:Error) {
						
					}
				}
				
				_urlStream = null;
			}
			
			_isLoading = false;
			_isFinished = false;
			
			_bytesLoadedCurrent = 0;
			_bytesTotalCurrent = 0;
			_percentageLoadedCurrent = 0;
			_bytesLoaded = 0;
			_bytesTotal = 0;
			_percentageLoaded = 0;
			
			urlStream_arr = new Array();
			loadItemInfo_arr = new Array();
			loadedXml_arr = new Array();
			
			addItemNum = 0; 
			loadingIndex = 0; 
			
			_loadSuccessNum = 0; 
			_loadFailNum = 0;	
			_loadCompleteNum = 0; 
			_bytesLoadedAccumulated = 0;
		}
		
		/**
		 * addURL() Function을 통해 등록한 id에 해당하는 xml data를 return
		 * @param _id
		 * @return XML
		 * @throws Error
		 * @see #addURL()
		 */
		public function	getXML(_id:String):XML {
			var dataIndex:int = -1;
			for(var i:uint = 0; i < loadItemInfo_arr.length; ++i) {
				if(loadItemInfo_arr[i]["_id"] == _id) {
					dataIndex = i;
					break;
				}
			}
			if(dataIndex < 0) {
				throw new Error( "[com.vwonderland.net.XmlLoader] 등록된 id 중 '" + _id + "'는 존재하지 않습니다." );
				return;
			}
			return loadedXml_arr[dataIndex] as XML;
		}
		
		/**
		 * 로드할 xml의 정보를 XmlLoader instance에 등록
		 * @param _url xmlURL
		 * @param _id xml id
		 * @param _useCodePage utf-8은 false, euc-kr은 true 설정
		 * @param _preventCache cache 사용시 false, cache 방지시 true 설정
		 * @param _usePOSTtypeUrlRequest GET 방식 통신시 false, POST 방식 통신시 true 설정
		 * @throws Error
		 * @see #getXML()
		 */
		public function	addURL(_url:String, _id:String, _useCodePage:Boolean = false, _preventCache:Boolean = false, _usePOSTtypeUrlRequest:Boolean = false):void {
			for each (var item:* in loadItemInfo_arr){
				if(item["_id"] == _id) throw new Error( "[com.vwonderland.net.XmlLoader] 같은 id가 이미 등록되어 있습니다." );
			}
			
			var _loadItemObj:* = new Object();
			_loadItemObj._id = _id;
			_loadItemObj._useCodePage = _useCodePage;
			_loadItemObj._bytesTotalPerFile = 0;
			_loadItemObj._usePOSTtypeUrlRequest = _usePOSTtypeUrlRequest;
			
			var _changedURL:String;
			if (_preventCache) {
				if (_url.indexOf("?") == -1) _changedURL = _url + "?tempCache="+(new Date()).getTime();
				else _changedURL = _url + "&tempCache="+(new Date()).getTime();
			} else _changedURL = _url;
			
			_loadItemObj._url = _changedURL;
			loadItemInfo_arr.push(_loadItemObj);
			
			var _urlStream:URLStream = new URLStream();
			setListeners(_urlStream);
			urlStream_arr.push(_urlStream);
			addItemNum++;
		}
		
		/**
		 * XmlLoader start load data
		 * @throws Error
		 */
		public function	start():void {
			if(loadItemInfo_arr.length <= 0) {
				throw new Error( "[com.vwonderland.net.XmlLoader] 등록된 XML URL이 존재하지 않습니다." );
				return;
			}
			_isLoading = true;
			_isFinished = false;
			loadNext();
		}
		
		//=========================
		// Constructor
		//=========================
		/**
		 * Constructor
		 */
		public function XmlLoader()
		{
			super();
			loadItemInfo_arr = new Array();
			urlStream_arr = new Array();
			loadedXml_arr = new Array();
		}
		
		protected function loadNext():void {
			if(loadingIndex >= loadItemInfo_arr.length) {
				_isLoading = false;
				_isFinished = true;
				dispatchEvent(new CustomEvent(LOAD_COMPLETE));
				return;
			}
			
			var _urlStream:URLStream = urlStream_arr[loadingIndex] as URLStream;
			try {
				var _urlRequest:URLRequest = new URLRequest(String(loadItemInfo_arr[loadingIndex]["_url"]));
				if(loadItemInfo_arr[loadingIndex] != null && Boolean(loadItemInfo_arr[loadingIndex]._usePOSTtypeUrlRequest) == true) _urlRequest.method = URLRequestMethod.POST;
				_urlStream.load(_urlRequest);
			} catch(error:Error) {
				trace("[com.vwonderland.net.XmlLoader] URLStream load Error" );
				dispatchEvent(new CustomEvent(URLSTREAM_ERROR));
				
				loadingIndex++;
				_loadFailNum++;
				_loadCompleteNum++;
				loadNext();
			}
		}
		
		/**
		 * 
		 * @param _urlStream
		 */
		protected function setListeners(_urlStream:URLStream):void {
			_urlStream.addEventListener(Event.COMPLETE, complete_hd);
			_urlStream.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatus_hd);
			_urlStream.addEventListener(IOErrorEvent.IO_ERROR, ioError_hd);
			_urlStream.addEventListener(Event.OPEN, open_hd);
			_urlStream.addEventListener(ProgressEvent.PROGRESS, progress_hd);
			_urlStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError_hd);
		}
		
		/**
		 * 
		 * @param _urlStream
		 */
		protected function removeListeners(_urlStream:URLStream):void {
			_urlStream.removeEventListener(Event.COMPLETE, complete_hd);
			_urlStream.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatus_hd);
			_urlStream.removeEventListener(IOErrorEvent.IO_ERROR, ioError_hd);
			_urlStream.removeEventListener(Event.OPEN, open_hd);
			_urlStream.removeEventListener(ProgressEvent.PROGRESS, progress_hd);
			_urlStream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError_hd);
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
			if(_bytesTotalCurrent <= 0) {
				trace("[com.vwonderland.net.XmlLoader] XmlLoader bytesTotal is Zero Error - " + String(loadItemInfo_arr[loadingIndex]["_url"]) );
				dispatchEvent(new CustomEvent(TOTALZERO_ERROR));
			}  
			_bytesLoadedAccumulated += _bytesTotalCurrent;
			
			var _urlStream:URLStream = urlStream_arr[loadingIndex];
			try {
				var xmlString:String;
				if(loadItemInfo_arr[loadingIndex]["_useCodePage"] == true) {
					xmlString = _urlStream.readMultiByte(_urlStream.bytesAvailable, EUC_KR);
				}else{
					xmlString = _urlStream.readUTFBytes(_urlStream.bytesAvailable);
				}
				
				var xml:XML = new XML(xmlString);
				loadedXml_arr.push(xml);
			} catch(error:Error) {
				trace("[com.vwonderland.net.XmlLoader] XmlLoader parsing XML Error" );
				loadedXml_arr.push(null);
				dispatchEvent(new CustomEvent(PARSING_ERROR));
			}
			dispatchEvent(new CustomEvent(LOAD_PER_COMPLETE));
			
			loadingIndex++;
			_loadSuccessNum++;
			_loadCompleteNum++;
			loadNext();
		}
		
		/**
		 * 
		 * @param event
		 */
		protected function progress_hd(event:ProgressEvent):void {
			_bytesLoadedCurrent = event.bytesLoaded;
			_bytesTotalCurrent = loadItemInfo_arr[loadingIndex]["_bytesTotalPerFile"] = event.bytesTotal;
			_percentageLoadedCurrent = _bytesLoadedCurrent / _bytesTotalCurrent;
			_bytesLoaded = _bytesLoadedAccumulated + _bytesLoadedCurrent;
			_percentageLoaded = _loadCompleteNum / itemTotal + (_bytesLoadedCurrent / _bytesTotalCurrent) / itemTotal;
			
			_bytesTotal = 0;
			if(loadingIndex >= loadItemInfo_arr.length - 1) {
				for(var i:uint = 0; i < loadItemInfo_arr.length; ++i) {
					_bytesTotal += Number(loadItemInfo_arr[i]["_bytesTotalPerFile"]);
				}
			}
			dispatchEvent(new CustomEvent(LOAD_PROGRESS));
		}
		
		/**
		 * 
		 * @param event
		 */
		protected function securityError_hd(event:SecurityErrorEvent):void {
			trace("[com.vwonderland.net.XmlLoader] XmlLoader SecurityError - " + String(loadItemInfo_arr[loadingIndex]["_url"]) );
			loadingIndex++;
			_loadFailNum++;
			_loadCompleteNum++;
			
			loadedXml_arr.push(null);
			dispatchEvent(new CustomEvent(LOAD_SECURITYERROR));
			loadNext();
		}
		
		/**
		 * 
		 * @param event
		 */
		protected function ioError_hd(event:IOErrorEvent):void {
			trace("[com.vwonderland.net.XmlLoader] XmlLoader IOError - " + String(loadItemInfo_arr[loadingIndex]["_url"]));
			loadingIndex++;
			_loadFailNum++;
			_loadCompleteNum++;
			
			loadedXml_arr.push(null);
			dispatchEvent(new CustomEvent(LOAD_IOERROR));
			loadNext();
		}
	}
}