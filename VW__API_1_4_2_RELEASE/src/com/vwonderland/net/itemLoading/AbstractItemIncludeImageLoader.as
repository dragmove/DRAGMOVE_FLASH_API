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

package com.vwonderland.net.itemLoading 
{
	import com.vwonderland.base.AbstractControllableMovieClip;
	import com.vwonderland.event.CustomEvent;
	import com.vwonderland.net.ImageLoader;
	
	import flash.system.LoaderContext;
	
	/**
	 * AbstractControllableMovieClip include ImageLoader
	 * @example Basic usage:<listing version="3.0">
	private var imageURL:String = "http://www.v-wonderland.com/banner/banner_1.jpg";
	private var _itemThumbnailLoadManager:ItemLoadingManager;
	
	public function TestAbstractItemIncludeImageLoader():void {
		var _bannerItem:BannerItem;
		_bannerItem = new BannerItem();
		
		//base required handler
		_bannerItem.addEventListener(AbstractItemIncludeImageLoader.LOAD_COMPLETE, bannerItemEventHandler);
		_bannerItem.addEventListener(AbstractItemIncludeImageLoader.LOAD_PROGRESS, bannerItemEventHandler);
		_bannerItem.addEventListener(AbstractItemIncludeImageLoader.LOAD_IOERROR, bannerItemEventHandler);
		_bannerItem.addEventListener(AbstractItemIncludeImageLoader.LOAD_SECURITYERROR, bannerItemEventHandler);
		
		//option handler
		_bannerItem.addEventListener(AbstractItemIncludeImageLoader.ACCESS_IMG_SECURITYERROR, bannerItemEventHandler);
		_bannerItem.addEventListener(AbstractItemIncludeImageLoader.LOADER_ERROR, bannerItemEventHandler);			
		
		//use BannerItem extends AbstractItemIncludeImageLoader
		_bannerItem.init();
		_bannerItem.addURL(imageURL, "bannerThumbnail");
		_bannerItem.startLoad();
		
		this.addChild(_bannerItem);
	}
	
	private function bannerItemEventHandler(e:CustomEvent):void {
		switch(e.type) {
			case AbstractItemIncludeImageLoader.LOAD_COMPLETE :
				trace("AbstractItemIncludeImageLoader.LOAD_COMPLETE");
			break;	
			
			case AbstractItemIncludeImageLoader.LOAD_PROGRESS :
				trace("AbstractItemIncludeImageLoader.LOAD_PROGRESS");
			break;
			
			case AbstractItemIncludeImageLoader.LOAD_IOERROR :
				trace("AbstractItemIncludeImageLoader.LOAD_IOERROR");
			break;
			
			case AbstractItemIncludeImageLoader.LOAD_SECURITYERROR :
				trace("AbstractItemIncludeImageLoader.LOAD_SECURITYERROR");
			break;
			
			case AbstractItemIncludeImageLoader.ACCESS_IMG_SECURITYERROR :
				trace("AbstractItemIncludeImageLoader.ACCESS_IMG_SECURITYERROR");
			break;
			
			case AbstractItemIncludeImageLoader.LOADER_ERROR :
				trace("AbstractItemIncludeImageLoader.LOADER_ERROR");
			break;
		}
	}
	
	//make BannerItem Class extends AbstractItemIncludeImageLoader
	public class BannerItem extends AbstractItemIncludeImageLoader
	{
		private var _thumbnail:Bitmap;
		
		override protected function destroyDetail(_obj:Object=null):void {
			trace("BannerItem instance 내부 visual setting 및 임의 설정에 대한 destroy");
		}
		
		override protected function setInstance(_obj:Object=null):void {
			trace("BannerItem instance 내부 visual setting 및 임의 설정");
		}
		
		override protected function loadCompleteDetail():void {
			_thumbnail = _imageLoader.getImg("bannerThumbnail") as Bitmap; 
			if(_thumbnail != null) this.addChild(_thumbnail);
		}
		
		override protected function loadProgressDetail():void {
			//trace("loadProgressDetail - BannerItem thumbnail Load process");
		}
		
		override protected function loadIOErrorDetail():void {
			//trace("loadIOErrorDetail - BannerItem thumbnail Load Fail");
		}
		
		override protected function loadSecurityErrorDetail():void {
			//trace("loadSecurityErrorDetail - BannerItem thumbnail Load Fail");
		}
		
		override protected function loadAccessImgSecurityErrorDetail():void { //OPTION
			//trace("loadAccessImgSecurityErrorDetail - BannerItem thumbnail Load Fail");
		}
		
		override protected function loaderErrorDetail():void { //OPTION
			//trace("loaderErrorDetail - BannerItem thumbnail Load Fail");
		}
	}
	 *    </listing>
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  01.10.2010
	 */
	public class AbstractItemIncludeImageLoader extends AbstractControllableMovieClip 
	{
		//=====================
		// Variables - event
		//=====================	
		/**
		 * 내부 ImageLoader instance의 ImageLoader.LOAD_PER_COMPLETE 전달시, 발생(ImageLoader.COMPLETE Event 전달시 발생하는 Event가 아니므로, 혼동이 없도록 주의 필요)하는 Event입니다. 
		 * @default 
		 */
		static public const LOAD_COMPLETE:String = "com.vwonderland.net.itemLoading.AbstractItemIncludeImageLoader.LOAD_COMPLETE";
		
		/**
		 * 내부 ImageLoader instance의 ImageLoader.LOAD_PROGRESS 전달시, 발생하는 Event입니다.
		 * @default 
		 */
		static public const LOAD_PROGRESS:String = "com.vwonderland.net.itemLoading.AbstractItemIncludeImageLoader.LOAD_PROGRESS";
		
		/**
		 * 내부 ImageLoader instance의 ImageLoader.LOAD_IOERROR 전달시, 발생하는 Event입니다.
		 * @default 
		 */
		static public const LOAD_IOERROR:String = "com.vwonderland.net.itemLoading.AbstractItemIncludeImageLoader.LOAD_IOERROR";
		
		/**
		 * 내부 ImageLoader instance의 ImageLoader.LOAD_SECURITYERROR 전달시, 발생하는 Event입니다.
		 * @default 
		 */
		static public const LOAD_SECURITYERROR:String = "com.vwonderland.net.itemLoading.AbstractItemIncludeImageLoader.LOAD_SECURITYERROR";
		
		/**
		 * 내부 ImageLoader instance의 ImageLoader.ACCESS_IMG_SECURITYERROR 전달시, 발생하는 Event입니다.
		 * @default 
		 */
		static public const ACCESS_IMG_SECURITYERROR:String = "com.vwonderland.net.itemLoading.AbstractItemIncludeImageLoader.ACCESS_IMG_SECURITYERROR";
		
		/**
		 * 내부 ImageLoader instance의 ImageLoader.LOADER_ERROR 전달시, 발생하는 Event입니다.
		 * @default 
		 */
		static public const LOADER_ERROR:String = "com.vwonderland.net.itemLoading.AbstractItemIncludeImageLoader.LOADER_ERROR";
		
		//=====================
		// Variables
		//=====================
		/**
		 * AbstractItemIncludeImageLoader Class 내부에 기본적으로 포함된 ImageLoader instance
		 * @default 
		 */
		protected var _imageLoader:ImageLoader;
		private var _isLoadStarted:Boolean = false;
		private var _isLoadFinished:Boolean = false;
		private var _isLoadIOError:Boolean = false;
		private var flag_assignImageURL:Boolean = false; //addURL Function 실행으로 load할 image File URL의 할당 여부
		
		/**
		 * ImageLoader instance의 image File Load 시작 여부 반환
		 * @return 
		 */
		public function get isLoadStarted():Boolean {
			return _isLoadStarted;
		}
		
		/**
		 * ImageLoader instance의 image File Load 완료 여부 반환
		 * @return 
		 */
		public function get isLoadFinished():Boolean {
			return _isLoadFinished;
		}
		
		/**
		 * ImageLoader instance의 image File Load IOError 발생 여부 반환
		 * @return 
		 */
		public function get isLoadIOError():Boolean {
			return _isLoadIOError;
		}
		
		/**
		 * ImageLoader instance 반환
		 * @return 
		 */
		public function	get imageLoader():ImageLoader {
			return _imageLoader;
		}
		
		//==================
		// Public function
		//==================
		override public function destroy(_obj:Object = null):void {
			if(_imageLoader != null) {
				_imageLoader.destroy();
				removeListeners();
				_imageLoader = null;
			}
			_isLoadFinished = false;
			_isLoadIOError = false;
			flag_assignImageURL = false;
			
			destroyDetail(_obj);
		}
		
		/**
		 * 로드할 image File의 정보를 내부 ImageLoader instance에 등록 (addURL Function을 이용하여 등록할 수 있는 image File의 갯수는 1개입니다.)
		 * @param _url
		 * @param _id
		 * @param _preventCache		cache data의 사용을 방지할 경우, true 설정
		 * @param _loaderContext
		 */
		public function addURL(_url:String, _id:String, _preventCache:Boolean = false, _loaderContext:LoaderContext = null):void {
			if(flag_assignImageURL) {
				trace("[com.vwonderland.net.itemLoading.AbstractItemIncludeImageLoader] addURL Function을 수행할 수 없습니다. addURL Function이 이전에 수행되어, load하기 위한 Image File의 URL이 할당되어 있는 상태입니다.");
				return;
			}
			if(_imageLoader != null) {
				_imageLoader.addURL(_url, _id, _preventCache, _loaderContext);
			}else{
				trace("[com.vwonderland.net.itemLoading.AbstractItemIncludeImageLoader] ImageLoader instance가 존재하지 않아 addURL Function을 수행할 수 없습니다. AbstractItemIncludeImageLoader를 상속한 Class의 instance를 재생성하여 사용하시기 바랍니다.");
				return;
			}
			flag_assignImageURL = true;
		}
		
		/**
		 * Load process start
		 */
		public function startLoad():void {
			if(_isLoadStarted) {
				trace("[com.vwonderland.net.itemLoading.AbstractItemIncludeImageLoader] Image File Load Process가 이미 시작되어, startLoad Function은 수행할 수 없습니다.");
				return;
			}
			if(_isLoadFinished) {
				trace("[com.vwonderland.net.itemLoading.AbstractItemIncludeImageLoader] Image File Load가 완료되어, 더 이상 startLoad Function은 수행할 수 없습니다.");
				return;
			}
			if(!flag_assignImageURL) {
				trace("[com.vwonderland.net.itemLoading.AbstractItemIncludeImageLoader] addURL Function을 통한 Image File의 URL이 할당되지 않아, startLoad Function은 수행할 수 없습니다.");
				return;
			}
			if(_imageLoader != null) {
				_imageLoader.start();
			}else{
				trace("[com.vwonderland.net.itemLoading.AbstractItemIncludeImageLoader] ImageLoader instance가 존재하지 않아 startLoad Function을 수행할 수 없습니다. AbstractItemIncludeImageLoader를 상속한 Class의 instance를 재생성하여 사용하시기 바랍니다.");
				return;
			}
		}
		
		/**
		 * (override detail define) ImageLoader instance 및 Load Process 관련 destroy 처리를 제외한, setInstance Function을 통해 임의 정의한 부분의 destroy detail 정의
		 * @param _obj
		 */
		protected function destroyDetail(_obj:Object = null):void {
			//override define detail
		}
		
		/**
		 * (override detail define) instance variables setting
		 * @param _obj
		 */
		protected function setInstance(_obj:Object = null):void {
			//override define detail
		}
		
		/**
		 * (override detail define) ImageLoader instance의 ImageLoader.LOAD_COMPLETE 발생시, 관련 처리 detail 정의
		 */
		protected function loadCompleteDetail():void {
			//override define detail
		}
		
		/**
		 * (override detail define) ImageLoader instance의 ImageLoader.LOAD_PROGRESS 발생시, 관련 처리 detail 정의
		 */
		protected function loadProgressDetail():void {
			//override define detail
		}
		
		/**
		 * (override detail define) ImageLoader instance의 ImageLoader.LOAD_IOERROR 발생시, 관련 처리 detail 정의
		 */
		protected function loadIOErrorDetail():void {
			//override define detail
		}
		
		/**
		 * (override detail define) ImageLoader instance의 ImageLoader.LOAD_SECURITYERROR 발생시, 관련 처리 detail 정의
		 */
		protected function loadSecurityErrorDetail():void {
			//override define detail
		}
		
		/**
		 * (override detail define) ImageLoader instance의 ImageLoader.ACCESS_IMG_SECURITYERROR 발생시, 관련 처리 detail 정의
		 */
		protected function loadAccessImgSecurityErrorDetail():void { //OPTION
			//override define detail
		}
		
		/**
		 * (override detail define) ImageLoader instance의 ImageLoader.LOADER_ERROR 발생시, 관련 처리 detail 정의
		 */
		protected function loaderErrorDetail():void { //OPTION
			//override define detail
		}
		
		//=========================
		// Constructor
		//=========================
		/**
		 * Constructor
		 */
		public function AbstractItemIncludeImageLoader() {
		}
		
		override public function init(_obj:Object = null):void {
			setImageLoader(); 
			setInstance(_obj);
		}
		
		/**
		 * 
		 */
		protected function setImageLoader():void {
			if(_imageLoader != null) {
				_imageLoader.destroy();
				removeListeners();
				_imageLoader = null;
			}
			_imageLoader = new ImageLoader();
			_imageLoader.addEventListener(ImageLoader.LOAD_PER_COMPLETE, imageLoaderEvent_hd);
			_imageLoader.addEventListener(ImageLoader.LOAD_PROGRESS, imageLoaderEvent_hd);
			_imageLoader.addEventListener(ImageLoader.LOAD_IOERROR, imageLoaderEvent_hd);
			_imageLoader.addEventListener(ImageLoader.LOAD_SECURITYERROR, imageLoaderEvent_hd);
			_imageLoader.addEventListener(ImageLoader.ACCESS_IMG_SECURITYERROR, imageLoaderEvent_hd);
			_imageLoader.addEventListener(ImageLoader.LOADER_ERROR, imageLoaderEvent_hd);
		}
		
		/**
		 * 
		 */
		protected function removeListeners():void {
			if(_imageLoader != null) {
				_imageLoader.removeEventListener(ImageLoader.LOAD_PER_COMPLETE, imageLoaderEvent_hd);
				_imageLoader.removeEventListener(ImageLoader.LOAD_PROGRESS, imageLoaderEvent_hd);
				_imageLoader.removeEventListener(ImageLoader.LOAD_IOERROR, imageLoaderEvent_hd);
				_imageLoader.removeEventListener(ImageLoader.LOAD_SECURITYERROR, imageLoaderEvent_hd);
				_imageLoader.removeEventListener(ImageLoader.ACCESS_IMG_SECURITYERROR, imageLoaderEvent_hd);
				_imageLoader.removeEventListener(ImageLoader.LOADER_ERROR, imageLoaderEvent_hd);
			}
		}
		
		/**
		 * 
		 * @param e
		 */
		protected function imageLoaderEvent_hd(e:CustomEvent):void {
			var evtStr:String;
			
			switch(e.type) {
				case ImageLoader.LOAD_PER_COMPLETE :
					evtStr = LOAD_COMPLETE;
					_isLoadFinished = true;
					loadCompleteDetail();
				break;	
				
				case ImageLoader.LOAD_PROGRESS :
					evtStr = LOAD_PROGRESS;
					loadProgressDetail();
				break;
				
				case ImageLoader.LOAD_IOERROR :
					evtStr = LOAD_IOERROR;
					_isLoadIOError = true;
					loadIOErrorDetail();
				break;
				
				case ImageLoader.LOAD_SECURITYERROR :
					evtStr = LOAD_SECURITYERROR;
					loadSecurityErrorDetail();
				break;
				
				case ImageLoader.ACCESS_IMG_SECURITYERROR :
					evtStr = ACCESS_IMG_SECURITYERROR;
					loadAccessImgSecurityErrorDetail();
				break;
				
				case ImageLoader.LOADER_ERROR :
					evtStr = LOADER_ERROR;
					loaderErrorDetail();
				break;
			}
			
			dispatchEvent(new CustomEvent(evtStr));
		}
	}
}

