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
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.system.LoaderContext;
	import flash.utils.getDefinitionByName;
	
	/**
	 * 복수의 Image 파일을 Load하여 사용하기 위한 ImageLoader
	 * @example Basic usage:<listing version="3.0">
	private var _imageLoader:ImageLoader;
		
	public function TestImageLoader():void {
		_imageLoader = new ImageLoader();
		
		//base required handler
		_imageLoader.addEventListener(ImageLoader.LOAD_PROGRESS, loadProgress_hd);
		_imageLoader.addEventListener(ImageLoader.LOAD_COMPLETE, loadComplete_hd);
		_imageLoader.addEventListener(ImageLoader.LOAD_IOERROR, loadIOError_hd);
		_imageLoader.addEventListener(ImageLoader.LOAD_SECURITYERROR, loadSecurityError_hd);
		_imageLoader.addEventListener(ImageLoader.ACCESS_IMG_SECURITYERROR, accessImgSecurityError_hd);
		
		//option handler
		_imageLoader.addEventListener(ImageLoader.LOAD_PER_COMPLETE, loadPerComplete_hd);
		_imageLoader.addEventListener(ImageLoader.LOADER_ERROR, loaderError_hd);
		
		//use
		_imageLoader.addURL("../bin-debug/contactUs_1.png", "img_1");
		_imageLoader.addURL("../bin-debug/contactUs_2.png", "img_2"); 
		_imageLoader.start();
	}
	
	private function loadPerComplete_hd(e:CustomEvent):void {
		trace("===== loadPerComplete_hd =====");
		trace("_imageLoader.bytesLoadedCurrent :", _imageLoader.bytesLoadedCurrent);
		trace("_imageLoader.bytesTotalCurrent :", _imageLoader.bytesTotalCurrent);
		trace("_imageLoader.percentageLoadedCurrent :", _imageLoader.percentageLoadedCurrent);
		trace("_imageLoader.bytesLoaded :", _imageLoader.bytesLoaded);
		trace("_imageLoader.bytesTotal :", _imageLoader.bytesTotal);
		trace("_imageLoader.percentageLoaded :", _imageLoader.percentageLoaded);
	}
	
	private function loadProgress_hd(e:CustomEvent):void {
		trace("===== loadProgress_hd =====");
		trace("_imageLoader.bytesLoadedCurrent :", _imageLoader.bytesLoadedCurrent);
		trace("_imageLoader.bytesTotalCurrent :", _imageLoader.bytesTotalCurrent);
		trace("_imageLoader.percentageLoadedCurrent :", _imageLoader.percentageLoadedCurrent);
		trace("_imageLoader.bytesLoaded :", _imageLoader.bytesLoaded);
		trace("_imageLoader.bytesTotal :", _imageLoader.bytesTotal);
		trace("_imageLoader.percentageLoaded :", _imageLoader.percentageLoaded);
	}
	
	private function loadComplete_hd(e:CustomEvent):void {
		trace("loadComplete_hd");
		
		var _bitmap:Bitmap = _imageLoader.getImg("img_1") as Bitmap;
		if(_bitmap != null) this.addChild(_bitmap);
	}
	
	private function loadSecurityError_hd(e:CustomEvent):void {
		trace("loadSecurityError_hd");
	}
	
	private function loadIOError_hd(e:CustomEvent):void {
		trace("loadIOError_hd");
	}
	
	private function accessImgSecurityError_hd(e:CustomEvent):void {
		trace("accessImgSecurityError_hd");
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
	public class ImageLoader extends EventDispatcher
	{
		/**
		 * image 파일 load 작업이 진행되어 data가 수신될 경우 전달됩니다.
		 */
		static public const LOAD_PROGRESS:String = "com.vwonderland.net.ImageLoader.LOAD_PROGRESS";
		
		/**
		 * 1개의 image 파일이 load 완료될 경우마다 전달됩니다.
		 */
		static public const LOAD_PER_COMPLETE:String = "com.vwonderland.net.ImageLoader.LOAD_PER_COMPLETE";
		
		/**
		 * 모든 image 파일에 대한 load 완료와 load error 처리가 완료되었을 경우 전달됩니다(모든 image 파일이 성공적으로 load되었을 경우에만 전달되는 이벤트가 아닙니다).
		 */
		static public const LOAD_COMPLETE:String = "com.vwonderland.net.ImageLoader.LOAD_COMPLETE";
		
		/**
		 * image 파일 load 도중 IOError가 발생할 경우 전달됩니다.
		 */
		static public const LOAD_IOERROR:String = "com.vwonderland.net.ImageLoader.LOAD_IOERROR";
		
		/**
		 * image 파일 load 도중 SecurityError가 발생할 경우 전달됩니다.
		 */
		static public const LOAD_SECURITYERROR:String = "com.vwonderland.net.ImageLoader.LOAD_SECURITYERROR";
		
		/**
		 * image 파일 contentLoaderInfo의 content 속성에 접근시 SecurityError가 발생할 경우 전달됩니다.
		 */
		static public const ACCESS_IMG_SECURITYERROR:String = "com.vwonderland.net.ImageLoader.ACCESS_IMG_SECURITYERROR";
		
		/**
		 * image 파일을 load하기 위한 Loader의 load() method 호출시 Error가 발생할 경우 전달됩니다.
		 */
		static public const LOADER_ERROR:String = "com.vwonderland.net.ImageLoader.LOADER_ERROR";
		
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
		private var loadedImg_arr:Array; 
		
		private var addItemNum:uint = 0;
		private var loadingIndex:int = 0;
		
		private var _loadSuccessNum:int = 0;
		private var _loadFailNum:int = 0;
		private var _loadCompleteNum:int = 0;
		private var _bytesLoadedAccumulated:Number = 0;
		
		/**
		 * 현재 Load중인 image 파일에 대한 bytesLoaded 반환
		 * @return Number
		 */
		public function	get bytesLoadedCurrent():Number {
			return _bytesLoadedCurrent;
		}
		
		/**
		 * 현재 Load중인 image 파일에 대한 bytesTotal 반환
		 * @return 
		 */
		public function	get bytesTotalCurrent():Number {
			return _bytesTotalCurrent;
		}
		
		/**
		 * 현재 Load중인 image 파일에 대한 percentage( bytesLoadedCurrent/bytesTotalCurrent ) 반환
		 * @return 
		 */
		public function	get percentageLoadedCurrent():Number {
			return _percentageLoadedCurrent;
		}
		
		/**
		 * Load하는 모든 image 파일에 대한 bytesLoaded 반환
		 * @return 
		 */
		public function	get bytesLoaded():Number {
			return _bytesLoaded;
		}
		
		/**
		 * Load하는 모든 image 파일에 대한 bytesTotal 반환. 모든 Bitmap 파일의 connection이 연결되지 않았을 경우에는 0을 반환합니다.
		 * @return 
		 */
		public function	get bytesTotal():Number {
			return _bytesTotal;
		}
		
		/**
		 * Load하는 모든 image 파일에 대한 percentage
		 * @return 
		 */
		public function	get percentageLoaded():Number {
			return _percentageLoaded;
		}
		
		/**
		 * 모든 image 파일에 대한 Load 완료 여부 반환
		 * @return 
		 */
		public function	get isFinished():Boolean {
			return _isFinished;
		}
		
		/**
		 * addURL method를 통해 등록된 모든 image 파일의 갯수 반환
		 * @return 
		 * @see #addURL()
		 */
		public function get itemTotal():uint {
			return loadItemInfo_arr.length;
		}
		
		/**
		 * image 파일 Load중 IOError, SecurityError, Loader Error 없이 Load 완료된 횟수 반환 
		 * @return 
		 */
		public function	get loadSuccessNum():uint {
			return _loadSuccessNum;
		}
		
		/**
		 * image 파일 Load중 IOError, SecurityError, Loader Error 발생 횟수 반환 
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
			loadedImg_arr = new Array();
			
			addItemNum = 0; 
			loadingIndex = 0; 
			
			_loadSuccessNum = 0; 
			_loadFailNum = 0;	
			_loadCompleteNum = 0; 
			_bytesLoadedAccumulated = 0;
		}
		
		/**
		 * Load 완료된 image file 반환
		 * @param _id
		 * @return 
		 * @throws Error
		 */
		public function	getImg(_id:String):Bitmap {
			var dataIndex:int = -1;
			for(var i:uint = 0; i < loadItemInfo_arr.length; ++i) {
				if(loadItemInfo_arr[i]["_id"] == _id) {
					dataIndex = i;
					break;
				}
			}
			
			if(dataIndex < 0) {
				throw new Error( "[com.vwonderland.net.ImageLoader] 등록된 id 중 '" + _id + "'는 존재하지 않습니다." );
				return;
			}
			return loadedImg_arr[dataIndex] as Bitmap;
		}
		
		/**
		 * Load할 image의 정보를 ImageLoader instance에 등록
		 * @param _url
		 * @param _id
		 * @param _preventCache		cache data의 사용을 방지할 경우, true 설정
		 * @param _loaderContext
		 * @throws Error
		 */
		public function	addURL(_url:String, _id:String, _preventCache:Boolean = false, _loaderContext:LoaderContext = null):void {
			for each (var item:* in loadItemInfo_arr){
				if(item["_id"] == _id) throw new Error( "[com.vwonderland.net.ImageLoader] 같은 id가 이미 등록되어 있습니다." );
			}
			
			var _loadItemObj:* = new Object();
			_loadItemObj._id = _id;
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
				throw new Error( "[com.vwonderland.net.ImageLoader] 등록된 Image의 URL이 존재하지 않습니다." );
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
		public function ImageLoader()
		{
			super();
			loadItemInfo_arr = new Array();
			loader_arr = new Array();
			loadedImg_arr = new Array();
		}
		
		private function loadNext():void {
			if(loadingIndex >= loadItemInfo_arr.length) {
				//trace("[com.vwonderland.net.ImageLoader] ImageLoader load Complete" );
				_isLoading = false;
				_isFinished = true;
				dispatchEvent(new CustomEvent(LOAD_COMPLETE));
				return;
			}
			
			var _loader:Loader = loader_arr[loadingIndex] as Loader;
			try {
				_loader.load(new URLRequest(String(loadItemInfo_arr[loadingIndex]["_url"])), loadItemInfo_arr[loadingIndex]["_loaderContext"]);
			} catch(error:Error) {
				trace("[com.vwonderland.net.ImageLoader] Loader load Error" );
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
				if(_loader != null) {
					var _loadedBmp:Bitmap = _loader.contentLoaderInfo.content as Bitmap;
					loadedImg_arr.push(_loadedBmp);
				}
			} catch(error:SecurityError) {
				trace("[com.vwonderland.net.ImageLoader] ImageLoader access Img Security Error" );
				loadedImg_arr.push(null);
				dispatchEvent(new CustomEvent(ACCESS_IMG_SECURITYERROR));
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
			trace("[com.vwonderland.net.ImageLoader] ImageLoader SecurityError - " + String(loadItemInfo_arr[loadingIndex]["_url"]) );
			loadingIndex++;
			_loadFailNum++;
			_loadCompleteNum++;
			
			loadedImg_arr.push(null);
			dispatchEvent(new CustomEvent(LOAD_SECURITYERROR));
			loadNext();
		}
		
		/**
		 * 
		 * @param event
		 */
		protected function ioError_hd(event:IOErrorEvent):void {
			trace("[com.vwonderland.net.ImageLoader] ImageLoader IOError - " + String(loadItemInfo_arr[loadingIndex]["_url"]));
			loadingIndex++;
			_loadFailNum++;
			_loadCompleteNum++;
			
			loadedImg_arr.push(null);
			dispatchEvent(new CustomEvent(LOAD_IOERROR));
			loadNext();
		}
	}
}