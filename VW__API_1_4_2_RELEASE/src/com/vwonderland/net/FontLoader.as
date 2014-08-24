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

package com.vwonderland.net
{
	import com.vwonderland.event.CustomEvent;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.system.LoaderContext;
	import flash.text.Font;
	import flash.utils.getDefinitionByName;
	
	/**
	 * 복수의 Font 파일을 Load하여 사용하기 위한 FontLoader
	 * @example Basic usage:<listing version="3.0">
		private var _fontLoader:FontLoader;
		
		public function TestFontLoader():void {
			_fontLoader = new FontLoader();
			
			//base required handler
			_fontLoader.addEventListener(FontLoader.LOAD_PROGRESS, loadProgress_hd);
			_fontLoader.addEventListener(FontLoader.LOAD_COMPLETE, loadComplete_hd);
			_fontLoader.addEventListener(FontLoader.LOAD_IOERROR, loadIOError_hd);
			_fontLoader.addEventListener(FontLoader.LOAD_SECURITYERROR, loadSecurityError_hd);
			_fontLoader.addEventListener(FontLoader.ACCESS_FONT_SECURITYERROR, accessFontSecurityError_hd);
			
			//option handler
			_fontLoader.addEventListener(FontLoader.LOAD_PER_COMPLETE, loadPerComplete_hd);
			_fontLoader.addEventListener(FontLoader.LOADER_ERROR, loaderError_hd);
			
			//use
			_fontLoader.addURL("../bin-debug/font_hyundaiCard.swf", "font_1", "hyundaiCardBold");
			_fontLoader.addURL("../bin-debug/font_malgunGothic.swf", "font_2", "malgunGothic", false); 
			_fontLoader.start();
		}
		
		private function loadPerComplete_hd(e:CustomEvent):void {
			trace("===== loadPerComplete_hd =====");
			trace("_fontLoader.bytesLoadedCurrent :", _fontLoader.bytesLoadedCurrent);
			trace("_fontLoader.bytesTotalCurrent :", _fontLoader.bytesTotalCurrent);
			trace("_fontLoader.percentageLoadedCurrent :", _fontLoader.percentageLoadedCurrent);
			trace("_fontLoader.bytesLoaded :", _fontLoader.bytesLoaded);
			trace("_fontLoader.bytesTotal :", _fontLoader.bytesTotal);
			trace("_fontLoader.percentageLoaded :", _fontLoader.percentageLoaded);
		}
		
		private function loadProgress_hd(e:CustomEvent):void {
			trace("===== loadProgress_hd =====");
			trace("_fontLoader.bytesLoadedCurrent :", _fontLoader.bytesLoadedCurrent);
			trace("_fontLoader.bytesTotalCurrent :", _fontLoader.bytesTotalCurrent);
			trace("_fontLoader.percentageLoadedCurrent :", _fontLoader.percentageLoadedCurrent);
			trace("_fontLoader.bytesLoaded :", _fontLoader.bytesLoaded);
			trace("_fontLoader.bytesTotal :", _fontLoader.bytesTotal);
			trace("_fontLoader.percentageLoaded :", _fontLoader.percentageLoaded);
		}
		
		private function loadComplete_hd(e:CustomEvent):void {
			trace("loadComplete_hd");
			trace("_fontLoader.fontNameArr :", _fontLoader.fontNameArr);
		}
		
		private function loadSecurityError_hd(e:CustomEvent):void {
			trace("loadSecurityError_hd");
		}
		
		private function loadIOError_hd(e:CustomEvent):void {
			trace("loadIOError_hd");
		}
		
		private function accessFontSecurityError_hd(e:CustomEvent):void {
			trace("accessFontSecurityError_hd");
		}
		
		private function loaderError_hd(e:CustomEvent):void {
			trace("loaderError_hd");
		}
	 *    </listing>
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  26.07.2010
	 */
	public class FontLoader extends EventDispatcher
	{
		/**
		 * font swf 파일 load 작업이 진행되어 data가 수신될 경우 전달됩니다.
		 */
		static public const LOAD_PROGRESS:String = "com.vwonderland.net.FontLoader.LOAD_PROGRESS";
		
		/**
		 * 1개의 font swf 파일이 load 완료될 경우마다 전달됩니다.
		 */
		static public const LOAD_PER_COMPLETE:String = "com.vwonderland.net.FontLoader.LOAD_PER_COMPLETE";
		
		/**
		 * 모든 font swf 파일에 대한 load 완료와 load error 처리가 완료되었을 경우 전달됩니다(모든 swf 파일이 성공적으로 load되었을 경우에만 전달되는 이벤트가 아닙니다).
		 */
		static public const LOAD_COMPLETE:String = "com.vwonderland.net.FontLoader.LOAD_COMPLETE";
		
		/**
		 * font swf 파일 load 도중 IOError가 발생할 경우 전달됩니다.
		 */
		static public const LOAD_IOERROR:String = "com.vwonderland.net.FontLoader.LOAD_IOERROR";
		
		/**
		 * font swf 파일 load 도중 SecurityError가 발생할 경우 전달됩니다.
		 */
		static public const LOAD_SECURITYERROR:String = "com.vwonderland.net.FontLoader.LOAD_SECURITYERROR";
		
		/**
		 * font swf 파일 contentLoaderInfo의 content 속성에 접근시 SecurityError가 발생할 경우 전달됩니다.
		 */
		static public const ACCESS_FONT_SECURITYERROR:String = "com.vwonderland.net.FontLoader.ACCESS_FONT_SECURITYERROR";
		
		/**
		 * font swf 파일을 load하기 위한 Loader의 load() method 호출시 Error가 발생할 경우 전달됩니다.
		 */
		static public const LOADER_ERROR:String = "com.vwonderland.net.FontLoader.LOADER_ERROR";
		
		
		private var _isLoading:Boolean = false;
		private var _isFinished:Boolean = false;
		
		private var _bytesLoadedCurrent:Number = 0;
		private var _bytesTotalCurrent:Number = 0;
		private var _percentageLoadedCurrent:Number = 0;
		
		private var _bytesLoaded:Number = 0;
		private var _bytesTotal:Number = 0;
		private var _percentageLoaded:Number = 0;
		
		private var loader_arr:Array;
		private var loadItemInfo_arr:Array;
		private var loadedFont_arr:Array;
		private var loadedFontName_arr:Array; 
		
		private var addItemNum:uint = 0;
		private var loadingIndex:int = 0;
		
		private var _loadSuccessNum:int = 0;
		private var _loadFailNum:int = 0;
		private var _loadCompleteNum:int = 0;
		private var _bytesLoadedAccumulated:Number = 0;
		
		/**
		 * 현재 Load된 font swf 파일의 font name이 담긴 Array 반환
		 * @return Number
		 */
		public function	get fontNameArr():Array {
			return loadedFontName_arr;
		}
		
		/**
		 * Load된 font swf 파일이  담긴 Array 반환
		 * @return Array
		 */
		public function	get fontArr():Array {
			return loadedFont_arr;
		}
		
		/**
		 * 현재 Load중인 font swf 파일에 대한 bytesLoaded 반환
		 * @return Number
		 */
		public function	get bytesLoadedCurrent():Number {
			return _bytesLoadedCurrent;
		}
		
		/**
		 * 현재 Load중인 font swf 파일에 대한 bytesTotal 반환
		 * @return 
		 */
		public function	get bytesTotalCurrent():Number {
			return _bytesTotalCurrent;
		}
		
		/**
		 * 현재 Load중인 font swf 파일에 대한 percentage( bytesLoadedCurrent/bytesTotalCurrent ) 반환
		 * @return 
		 */
		public function	get percentageLoadedCurrent():Number {
			return _percentageLoadedCurrent;
		}
		
		/**
		 * Load하는 모든 font swf 파일에 대한 bytesLoaded 반환
		 * @return 
		 */
		public function	get bytesLoaded():Number {
			return _bytesLoaded;
		}
		
		/**
		 * Load하는 모든 font swf 파일에 대한 bytesTotal 반환(모든 font 파일의 connection이 연결되지 않았을 경우에는 0을 반환합니다).
		 * @return 
		 */
		public function	get bytesTotal():Number {
			return _bytesTotal;
		}
		
		/**
		 * Load하는 모든 font swf 파일에 대한 percentage
		 * @return 
		 */
		public function	get percentageLoaded():Number {
			return _percentageLoaded;
		}
		
		/**
		 * 모든 font swf 파일에 대한 Load 완료 여부 반환
		 * @return 
		 */
		public function	get isFinished():Boolean {
			return _isFinished;
		}
		
		/**
		 * addURL method를 통해 등록된 모든 font swf 파일의 갯수 반환
		 * @return 
		 * @see #addURL()
		 */
		public function get itemTotal():uint {
			return loadItemInfo_arr.length;
		}
		
		/**
		 * font swf 파일 Load중 IOError, SecurityError, Loader Error 없이 load 완료된 횟수 반환 
		 * @return 
		 */
		public function	get loadSuccessNum():uint {
			return _loadSuccessNum;
		}
		
		/**
		 * font swf 파일 Load중 IOError, SecurityError, Loader Error 발생 횟수 반환 
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
			var _loader:Loader;
			for(var i:uint = 0; i < loader_arr.length; ++i) {
				_loader = loader_arr[i];
				removeListeners(_loader);
				
				if(_isLoading) {
					try {
						_loader.close();
					} catch(error:Error) {
						
					}
				}
				_loader = null;
			}
			
			_isLoading = false;
			_isFinished = false;
			
			_bytesLoadedCurrent = 0;
			_bytesTotalCurrent = 0;
			_percentageLoadedCurrent = 0;
			_bytesLoaded = 0;
			_bytesTotal = 0;
			_percentageLoaded = 0;
			
			loader_arr = new Array();
			loadItemInfo_arr = new Array();
			loadedFont_arr = new Array();
			loadedFontName_arr = new Array();
			
			addItemNum = 0; 
			loadingIndex = 0; 
			
			_loadSuccessNum = 0; 
			_loadFailNum = 0;	
			_loadCompleteNum = 0; 
			_bytesLoadedAccumulated = 0;
			
		}
		
		/**
		 * Load 완료된 font swf file 반환
		 * @param _id
		 * @return 
		 * @throws Error
		 */
		public function	getFont(_id:String):MovieClip {
			var dataIndex:int = -1;
			for(var i:uint = 0; i < loadItemInfo_arr.length; ++i) {
				if(loadItemInfo_arr[i]["_id"] == _id) {
					dataIndex = i;
					break;
				}
			}
			
			if(dataIndex < 0) {
				throw new Error( "[com.vwonderland.net.FontLoader] 등록된 id 중 '" + _id + "'는 존재하지 않습니다." );
				return;
			}
			return loadedFont_arr[dataIndex];
		}
		
		/**
		 * Load할 font swf file의 정보를 FontLoader instance에 등록
		 * @param _url
		 * @param _id	
		 * @param _exportFontName	Flash swf File 내부의 export Linkage name
		 * @param _preventCache		cache data의 사용을 방지할 경우, true 설정
		 * @param _loaderContext	
		 * @throws Error
		 */
		public function	addURL(_url:String, _id:String, _exportFontName:String, _preventCache:Boolean = false, _loaderContext:LoaderContext = null):void {
			for each (var item:* in loadItemInfo_arr){
				if(item["_id"] == _id) throw new Error( "[com.vwonderland.net.FontLoader] 같은 id가 이미 등록되어 있습니다." );
			}
			
			var _loadItemObj:* = new Object();
			_loadItemObj._id = _id;
			_loadItemObj._exportFontName = _exportFontName;
			_loadItemObj._loaderContext = _loaderContext;
			_loadItemObj._bytesTotalPerFile = 0;
			
			var _changedURL:String;
			if (_preventCache) {
				if (_url.indexOf("?") == -1) _changedURL = _url + "?tempCache="+(new Date()).getTime();
				else _changedURL = _url + "&tempCache="+(new Date()).getTime();
			} else _changedURL = _url;
			
			_loadItemObj._url = _changedURL;
			loadItemInfo_arr.push(_loadItemObj);
			
			var _loader:Loader = new Loader();
			setListeners(_loader.contentLoaderInfo);
			loader_arr.push(_loader);
			addItemNum++;
		}
		
		/**
		 * Load process start
		 * @throws Error
		 */
		public function	start():void {
			if(loadItemInfo_arr.length <= 0) {
				throw new Error( "[com.vwonderland.net.FontLoader] 등록된 Font URL이 존재하지 않습니다." );
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
		public function FontLoader()
		{
			super();
			loadItemInfo_arr = new Array();
			loader_arr = new Array();
			loadedFont_arr = new Array();
			loadedFontName_arr = new Array();
		}
		
		private function loadNext():void {
			if(loadingIndex >= loadItemInfo_arr.length) {
				//trace("[com.vwonderland.net.FontLoader] FontLoader load Complete" );
				
				for(var i:uint = 0; i < loadedFont_arr.length; ++i) {
					if(loadedFont_arr[i] != null) {
						try {
							Font.registerFont(loadedFont_arr[i].loaderInfo.applicationDomain.getDefinition(loadItemInfo_arr[i]["_exportFontName"]) as Class);
						} catch(error:Error) {
							trace("[com.vwonderland.net.FontLoader] Font.registerFont Error - ", loadItemInfo_arr[i]["_exportFontName"]);
						}
					}
				}
				
				var _allFonts_arr:Array = Font.enumerateFonts(false);
				for(var k:uint = 0; k < _allFonts_arr.length; ++k) {
					trace("[com.vwonderland.net.FontLoader] Loaded Font Name :", _allFonts_arr[k].fontName);
					loadedFontName_arr.push(_allFonts_arr[k].fontName);
				}
				
				_isLoading = false;
				_isFinished = true;
				dispatchEvent(new CustomEvent(LOAD_COMPLETE));
				return;
			}
			
			var _loader:Loader = loader_arr[loadingIndex] as Loader;
			try {
				_loader.load(new URLRequest(String(loadItemInfo_arr[loadingIndex]["_url"])), loadItemInfo_arr[loadingIndex]["_loaderContext"]);
			} catch(error:Error) {
				trace("[com.vwonderland.net.FontLoader] Loader load Error" );
				dispatchEvent(new CustomEvent(LOADER_ERROR));
				
				loadingIndex++;
				_loadFailNum++;
				_loadCompleteNum++;
				loadNext();
			}
		}
		
		/**
		 * 
		 * @param _eventDispatcher
		 */
		protected function setListeners(_eventDispatcher:EventDispatcher):void {
			_eventDispatcher.addEventListener(Event.OPEN, open_hd);
			_eventDispatcher.addEventListener(ProgressEvent.PROGRESS, progress_hd);
			_eventDispatcher.addEventListener(Event.INIT, init_hd);
			_eventDispatcher.addEventListener(Event.COMPLETE, complete_hd);
			_eventDispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatus_hd);
			_eventDispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioError_hd);
			_eventDispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError_hd);
			_eventDispatcher.addEventListener(Event.UNLOAD, unload_hd);
		}
		
		/**
		 * 
		 * @param _eventDispatcher
		 */
		protected function removeListeners(_eventDispatcher:EventDispatcher):void {
			_eventDispatcher.removeEventListener(Event.OPEN, open_hd);
			_eventDispatcher.removeEventListener(ProgressEvent.PROGRESS, progress_hd);
			_eventDispatcher.removeEventListener(Event.INIT, init_hd);
			_eventDispatcher.removeEventListener(Event.COMPLETE, complete_hd);
			_eventDispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatus_hd);
			_eventDispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioError_hd);
			_eventDispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError_hd);
			_eventDispatcher.removeEventListener(Event.UNLOAD, unload_hd);
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
		protected function init_hd(event:Event):void {
			//trace("init_hd :", event);
		}
		
		/**
		 * 
		 * @param event
		 */
		protected function unload_hd(event:Event):void {
			//trace("unload_hd :", event);
		}
		
		/**
		 * 
		 * @param event
		 */
		protected function complete_hd(event:Event):void {
			_bytesLoadedAccumulated += _bytesTotalCurrent;
			
			var _loader:Loader = loader_arr[loadingIndex];
			try {
				var _loadedFont:MovieClip = _loader.contentLoaderInfo.content as MovieClip;
				loadedFont_arr.push(_loadedFont);
			} catch(error:SecurityError) {
				trace("[com.vwonderland.net.FontLoader] FontLoader access Font Security Error" );
				loadedFont_arr.push(null);
				dispatchEvent(new CustomEvent(ACCESS_FONT_SECURITYERROR));
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
			trace("[com.vwonderland.net.FontLoader] FontLoader SecurityError - " + String(loadItemInfo_arr[loadingIndex]["_url"]) );
			loadingIndex++;
			_loadFailNum++;
			_loadCompleteNum++;
			
			loadedFont_arr.push(null);
			dispatchEvent(new CustomEvent(LOAD_SECURITYERROR));
			loadNext();
		}
		
		/**
		 * 
		 * @param event
		 */
		protected function ioError_hd(event:IOErrorEvent):void {
			trace("[com.vwonderland.net.FontLoader] FontLoader IOError - " + String(loadItemInfo_arr[loadingIndex]["_url"]));
			loadingIndex++;
			_loadFailNum++;
			_loadCompleteNum++;
			
			loadedFont_arr.push(null);
			dispatchEvent(new CustomEvent(LOAD_IOERROR));
			loadNext();
		}
	}
}