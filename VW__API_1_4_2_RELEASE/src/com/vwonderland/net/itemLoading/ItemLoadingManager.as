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
	import com.vwonderland.base.AbstractControllableConceptObject;
	import com.vwonderland.event.CustomEvent;
	
	/**
	 * AbstractControllableConceptObject manage Loading Process of AbstractItemIncludeImageLoader instances
	 * @example Basic usage:<listing version="3.0">
	private var imageURLArr:Array = ["http://www.v-wonderland.com/banner/banner_1.jpg", "http://www.v-wonderland.com/banner/banner_2.jpg", "http://www.v-wonderland.com/banner/banner_3.jpg, "http://www.v-wonderland.com/banner/banner_4.jpg"]; 
	private var _itemThumbnailLoadManager:ItemLoadingManager;
	
	public function TestItemLoadingManager():void {
		_itemThumbnailLoadManager = new ItemLoadingManager();
		 
		//base required handler
		_itemThumbnailLoadManager.addEventListener(ItemLoadingManager.LOAD_COMPLETE, itemLoadingManagerHandler);
		_itemThumbnailLoadManager.addEventListener(ItemLoadingManager.LOAD_PROGRESS, itemLoadingManagerHandler);
		_itemThumbnailLoadManager.addEventListener(ItemLoadingManager.LOAD_PER_COMPLETE, itemLoadingManagerHandler);
		_itemThumbnailLoadManager.addEventListener(ItemLoadingManager.LOAD_PER_IOERROR, itemLoadingManagerHandler);
		_itemThumbnailLoadManager.addEventListener(ItemLoadingManager.LOAD_PER_SECURITYERROR, itemLoadingManagerHandler);
		
		//option handler
		_itemThumbnailLoadManager.addEventListener(ItemLoadingManager.ACCESS_PER_IMG_SECURITYERROR, itemLoadingManagerHandler);
		_itemThumbnailLoadManager.addEventListener(ItemLoadingManager.LOADER_PER_ERROR, itemLoadingManagerHandler);
		
		//use ItemLoadingManager
		_itemThumbnailLoadManager.init();
		
		var _bannerItem:BannerItem;
		for(var i:uint = 0; i &#60; imageURLArr.length; ++i) {
			_bannerItem = new BannerItem();
			_bannerItem.index = i;
			_bannerItem.init();
			_bannerItem.x = i &#42; 100;
			_bannerItem.addURL(imageURLArr[i], "bannerThumbnail");
			this.addChild(_bannerItem);
			 
			_itemThumbnailLoadManager.addItem(_bannerItem);
		}
	 
		_itemThumbnailLoadManager.startLoad(1); //등록된 thumbnail을 하나씩 순차적으로 load합니다.
		//_itemThumbnailLoadManager.startLoad(1, true); //등록된 thumbnail을 random하게 하나씩 순차적으로 load합니다.
		//_itemThumbnailLoadManager.startLoad(2); //등록된 thumbnail의 최초 2개를 동시에 load 시작하고, 이 중 1개의 load가 완료될 때마다 나머지 thumbnail들의 load가 순차적으로 수행됩니다.
		//_itemThumbnailLoadManager.startLoad(); //등록된 모든 thumbnail을 동시에 load합니다.
	}
	
	private function itemLoadingManagerHandler(e:CustomEvent):void {
		switch(e.type) {
			case ItemLoadingManager.LOAD_COMPLETE :
				trace("ItemLoadingManager.LOAD_COMPLETE - 등록된 모든 bannerItem의 Load Process 완료");
				
				trace("등록된 item의 전체 갯수 :", _itemThumbnailLoadManager.itemTotal);
				trace("load 성공한 item의 갯수 :", _itemThumbnailLoadManager.loadSuccessNum);
				trace("load 실패한 item의 갯수 :", _itemThumbnailLoadManager.loadFailNum);
			break;
			
			case ItemLoadingManager.LOAD_PROGRESS :
				trace("ItemLoadingManager.LOAD_PROGRESS");
			break;
			
			case ItemLoadingManager.LOAD_PER_COMPLETE :
				trace("ItemLoadingManager.LOAD_PER_COMPLETE");
			break;
			
			case ItemLoadingManager.LOAD_PER_IOERROR :
				trace("ItemLoadingManager.LOAD_PER_IOERROR");
			break;	
			
			case ItemLoadingManager.LOAD_PER_SECURITYERROR :
				trace("ItemLoadingManager.LOAD_PER_SECURITYERROR");
			break;
			
			case ItemLoadingManager.ACCESS_PER_IMG_SECURITYERROR :
				trace("ItemLoadingManager.ACCESS_PER_IMG_SECURITYERROR");
			break;
			
			case ItemLoadingManager.LOADER_PER_ERROR :
				trace("ItemLoadingManager.LOADER_PER_ERROR");
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
		
		override protected function loadAccessImgSecurityErrorDetail():void {
			//trace("loadAccessImgSecurityErrorDetail - BannerItem thumbnail Load Fail");
		}
		
		override protected function loaderErrorDetail():void {
			//trace("loaderErrorDetail - BannerItem thumbnail Load Fail");
		}
	}
	 *    </listing>
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  01.10.2010
	 */
	public class ItemLoadingManager extends AbstractControllableConceptObject
	{
		//====================
		// Variables - event
		//====================		
		/**
		 * addItem Function을 수행하여 등록한 각 AbstractItemIncludeImageLoader instance 내부의 Loading Process 도중 LOAD_COMPLETE Event 전달시 발생하는 Event입니다. 
		 * @default 
		 */
		static public const LOAD_PER_COMPLETE:String = "com.vwonderland.net.itemLoading.ItemLoadingManager.LOAD_PER_COMPLETE"; //item 하나의 파일 로드 완료시마다 발생
		
		/**
		 * addItem Function을 수행하여 등록한 각 AbstractItemIncludeImageLoader instance 내부의 Loading Process 도중 LOAD_IOERROR Event 전달시 발생하는 Event입니다.
		 * @default 
		 */
		static public const LOAD_PER_IOERROR:String = "com.vwonderland.net.itemLoading.ItemLoadingManager.LOAD_PER_IOERROR"; //item 하나의 파일 로드 완료시마다 발생
		
		/**
		 * addItem Function을 수행하여 등록한 모든 AbstractItemIncludeImageLoader instance 내부의 Loading Process 완료시 발생(Loading Process의 정상 수행, Error 발생 관계없이 모든 instance 내부의 Loading Process가 전부 완료되었을 경우 발생)하는 Event입니다. 
		 * @default 
		 */
		static public const LOAD_COMPLETE:String = "com.vwonderland.net.itemLoading.ItemLoadingManager.LOAD_COMPLETE"; //모든 item 내부의 파일 로드 + Error 발생 완료시 발생
		
		/**
		 * addItem Function을 수행하여 등록한 각 AbstractItemIncludeImageLoader instance 내부의 Loading Process 진행중 발생하는 Event입니다.
		 * @default 
		 */
		static public const LOAD_PROGRESS:String = "com.vwonderland.net.itemLoading.ItemLoadingManager.LOAD_PROGRESS"; //Loading process가 실행되고 있는 동안 계속 발생 
		
		/**
		 * addItem Function을 수행하여 등록한 각 AbstractItemIncludeImageLoader instance 내부의 Loading Process 도중 LOAD_SECURITYERROR Event 전달시 발생하는 Event입니다.
		 * @default 
		 */
		static public const LOAD_PER_SECURITYERROR:String = "com.vwonderland.net.itemLoading.ItemLoadingManager.LOAD_PER_SECURITYERROR"; //item 하나의 파일 securityError 발생시마다 발생
		
		/**
		 * addItem Function을 수행하여 등록한 각 AbstractItemIncludeImageLoader instance 내부의 Loading Process 도중 ACCESS_IMG_SECURITYERROR Event 전달시 발생하는 Event입니다.
		 * @default 
		 */
		static public const ACCESS_PER_IMG_SECURITYERROR:String = "com.vwonderland.net.itemLoading.ItemLoadingManager.ACCESS_PER_IMG_SECURITYERROR"; //item 하나의 파일 access image securityError 발생시마다 발생
		
		/**
		 * addItem Function을 수행하여 등록한 각 AbstractItemIncludeImageLoader instance 내부의 Loading Process 도중 LOADER_ERROR Event 전달시 발생하는 Event입니다.
		 * @default 
		 */
		static public const LOADER_PER_ERROR:String = "com.vwonderland.net.itemLoading.ItemLoadingManager.LOADER_PER_ERROR"; //item 하나의 파일 Loader error 발생시마다 발생
		
		//====================
		// Variables
		//====================
		/**
		 * 
		 * @default 
		 */
		protected var loadingItem_arr:Array; //AbstractItemIncludeImageLoader instance를 담는 배열
		private var loadingItem_copyArr:Array; //loadingItem_arr clone
		
		private var loadProgress_num:int = 0; //load 중인 item의 갯수
		private var loadComplete_num:int = 0; //load가 실패하거나 성공하여, 로드의 흐름이 완료된 AbstractItemIncludeImageLoader instance의 갯수
		
		private var loadSuccess_num:int = 0; //load가 성공한 AbstractItemIncludeImageLoader instance의 갯수
		private var loadFail_num:int = 0; //load가 실패한 AbstractItemIncludeImageLoader instance의 갯수
		
		private var flag_randomLoadProcess:Boolean = false; //random load 설정 여부
		private var _isFinished:Boolean = false; //등록된 모든 AbstractItemIncludeImageLoader instance의 load Finish 여부
		//private var loadingSuccessItem_arr:Array;
		//private var loadingFailItem:Array;
		
		/**
		 * 모든 AbstractItemIncludeImageLoader instance 내부의 Image Load Process 완료 여부 반환
		 * @return 
		 */
		public function	get isFinished():Boolean {
			return _isFinished;
		}
		
		/**
		 * addItem Function을 통해 등록된 모든 AbstractItemIncludeImageLoader instance의 갯수 반환
		 * @return 
		 * @see #addItem()
		 */
		public function	get itemTotal():uint {
			return loadingItem_arr.length; 
		}
		
		/**
		 * AbstractItemIncludeImageLoader instance 내부의 Image Load중 IOError, SecurityError, Access image SecurityError, Loader Error 없이 Load 완료된 횟수 반환 
		 * @return 
		 */
		public function	get loadSuccessNum():uint {
			return loadSuccess_num;
		}
		
		/**
		 * AbstractItemIncludeImageLoader instance 내부의 Image Load중 IOError, SecurityError, Loader Error 발생 횟수 반환 
		 * @return 
		 */
		public function	get loadFailNum():uint {
			return loadFail_num;
		}
		
		//==================
		// Public function
		//==================
		override public function destroy(_obj:Object = null):void {
			var loadingItemNum:int = loadingItem_arr.length;
			var _itemIncludeImageLoader:AbstractItemIncludeImageLoader;
			for(var i:uint = 0; i < loadingItemNum; ++i) {
				_itemIncludeImageLoader = loadingItem_arr[i] as AbstractItemIncludeImageLoader;
				_itemIncludeImageLoader.removeEventListener(AbstractItemIncludeImageLoader.LOAD_COMPLETE,loadProcess_hd);
				_itemIncludeImageLoader.removeEventListener(AbstractItemIncludeImageLoader.LOAD_PROGRESS,loadProcess_hd);
				_itemIncludeImageLoader.removeEventListener(AbstractItemIncludeImageLoader.LOAD_IOERROR,loadProcess_hd);
				_itemIncludeImageLoader.removeEventListener(AbstractItemIncludeImageLoader.LOAD_SECURITYERROR, loadProcess_hd);
				_itemIncludeImageLoader.removeEventListener(AbstractItemIncludeImageLoader.ACCESS_IMG_SECURITYERROR, loadProcess_hd);
				_itemIncludeImageLoader.removeEventListener(AbstractItemIncludeImageLoader.LOADER_ERROR, loadProcess_hd);
				_itemIncludeImageLoader = null;
			}
			loadingItem_arr = null;
			loadingItem_copyArr = null;
			loadProgress_num = 0;
			loadComplete_num = 0;
			loadSuccess_num = 0;
			loadFail_num = 0;
			flag_randomLoadProcess = false;
			_isFinished = false;
			
			destroyDetail(_obj);
		}
		
		/**
		 * load process 수행을 위한 AbstractItemIncludeImageLoader instance 등록
		 * @param _itemIncludeImageLoader
		 * @see #removeItem()
		 */
		public function addItem(_itemIncludeImageLoader:AbstractItemIncludeImageLoader):void {
			if(loadingItem_arr == null) {
				trace("[com.vwonderland.net.itemLoading.ItemLoadingManager] addItem Function을 수행할 수 없습니다. init Function을 실행하여 ItemLoadingManager의 초기화 후 addItem Function의 수행이 가능합니다.");
				return;
			}
			if(loadingItem_arr.indexOf(_itemIncludeImageLoader) < 0) { 
				_itemIncludeImageLoader.addEventListener(AbstractItemIncludeImageLoader.LOAD_COMPLETE, loadProcess_hd);
				_itemIncludeImageLoader.addEventListener(AbstractItemIncludeImageLoader.LOAD_PROGRESS, loadProcess_hd);
				_itemIncludeImageLoader.addEventListener(AbstractItemIncludeImageLoader.LOAD_IOERROR, loadProcess_hd);
				_itemIncludeImageLoader.addEventListener(AbstractItemIncludeImageLoader.LOAD_SECURITYERROR, loadProcess_hd);
				_itemIncludeImageLoader.addEventListener(AbstractItemIncludeImageLoader.ACCESS_IMG_SECURITYERROR, loadProcess_hd);
				_itemIncludeImageLoader.addEventListener(AbstractItemIncludeImageLoader.LOADER_ERROR, loadProcess_hd);
				loadingItem_arr.push(_itemIncludeImageLoader);
			}else{
				trace("[com.vwonderland.net.itemLoading.ItemLoadingManager] addItem Function은 수행할 수 없습니다. addItem Function을 수행하여 등록할 AbstractItemIncludeImageLoader instance와, 동일한 AbstractItemIncludeImageLoader instance가 이미 등록되어 있습니다.");
				return;
			}
		}
		
		/**
		 * addItem Function을 통해 등록된 AbstractItemIncludeImageLoader instance 등록 해제
		 * @param _itemIncludeImageLoader
		 * @see #addItem()
		 */
		public function removeItem(_itemIncludeImageLoader:AbstractItemIncludeImageLoader):void {
			if(loadingItem_arr == null) {
				trace("[com.vwonderland.net.itemLoading.ItemLoadingManager] removeItem Function을 수행할 수 없습니다. init Function을 실행하여 ItemLoadingManager의 초기화 후 removeItem Function의 수행이 가능합니다.");
				return;
			}
			
			var removeIndex:int = loadingItem_arr.indexOf(_itemIncludeImageLoader);
			if(removeIndex > -1) {	
				var splicedArr:Array = loadingItem_arr.splice( removeIndex, 1); 
				var splicedLoadingItem:AbstractItemIncludeImageLoader = splicedArr[0] as AbstractItemIncludeImageLoader;
				
				splicedLoadingItem.removeEventListener(AbstractItemIncludeImageLoader.LOAD_COMPLETE,loadProcess_hd);
				splicedLoadingItem.removeEventListener(AbstractItemIncludeImageLoader.LOAD_PROGRESS,loadProcess_hd);
				splicedLoadingItem.removeEventListener(AbstractItemIncludeImageLoader.LOAD_IOERROR,loadProcess_hd);
				splicedLoadingItem.removeEventListener(AbstractItemIncludeImageLoader.LOAD_SECURITYERROR, loadProcess_hd);
				splicedLoadingItem.removeEventListener(AbstractItemIncludeImageLoader.ACCESS_IMG_SECURITYERROR, loadProcess_hd);
				splicedLoadingItem.removeEventListener(AbstractItemIncludeImageLoader.LOADER_ERROR, loadProcess_hd);
				
				splicedLoadingItem = null;
			}else{
				trace("[com.vwonderland.net.itemLoading.ItemLoadingManager] removeItem Function은 수행할 수 없습니다. 등록된 AbstractItemIncludeImageLoader instance가 존재하지 않아, removeItem Function을 수행하여 해당 AbstractItemIncludeImageLoader instance는 등록 해제할 수 없습니다.");
				return;
			}
		}
		
		/**
		 * 등록된 모든 AbstractItemIncludeImageLoader instance의 Loading Process start
		 * @param _loadingItemNumFromTheStart	최초에, 등록된 AbstractItemIncludeImageLoader instance 중 몇개의 내부 Loading Process를 시작할 것인지 지정합니다. (0으로 설정시, 동시에 모든  AbstractItemIncludeImageLoader instance 내부의 Loading Process를 시작합니다.)
		 * @param _loadRandom					true 설정시, 등록된 모든 AbstractItemIncludeImageLoader instance 내부의 Loading Process는 random한 순서로 진행됩니다.
		 */
		public function startLoad(_loadingItemNumFromTheStart:uint = 0, _loadRandom:Boolean = false):void {
			if(_isFinished) {
				trace("[com.vwonderland.net.itemLoading.ItemLoadingManager] startLoad Function을 수행할 수 없습니다. 등록되어 있는 모든 AbstractItemIncludeImageLoader instance의 loading process가 이미 완료된 상태입니다.");
				return;
			}
			if(loadingItem_arr.length <= 0) {
				trace("[com.vwonderland.net.itemLoading.ItemLoadingManager] startLoad Function을 수행할 수 없습니다. addItem Function을 실행하여 등록된 AbstractItemIncludeImageLoader instance가 존재하지 않습니다.");
				return;
			}
			if(_loadingItemNumFromTheStart > loadingItem_arr.length) {
				trace("[com.vwonderland.net.itemLoading.ItemLoadingManager] _loadingItemNumFromTheStart value가, addItem Function을 실행하여 등록된 AbstractItemIncludeImageLoader instance의 갯수보다 큽니다. _loadingItemNumFromTheStart value를 조정하여, 모든 AbstractItemIncludeImageLoader instance의 loading을 동시에 진행합니다.");
			}
			
			flag_randomLoadProcess = _loadRandom;
			loadingItem_copyArr = loadingItem_arr.concat();
			var startLoadNum:uint = (_loadingItemNumFromTheStart >= loadingItem_arr.length) ? loadingItem_arr.length : _loadingItemNumFromTheStart;
			var tempLoadingItem:AbstractItemIncludeImageLoader;
			
			if(startLoadNum <= 0) { //1. 전체 동시 로드
				for(var i:uint = 0; i < loadingItem_arr.length; ++i) {
					tempLoadingItem = loadingItem_arr[i] as AbstractItemIncludeImageLoader;
					tempLoadingItem.startLoad();
					loadProgress_num++;
				}
			}else{
				if(!_loadRandom) { //2. 순차적 로드
					for(var j:uint = 0; j < _loadingItemNumFromTheStart; ++j) {
						loadNext();
					}
				}else{ //3. 랜덤 로드				
					for(var k:uint = 0; k < _loadingItemNumFromTheStart; ++k) {
						loadNextRandom();
					}
				}
			}
		}
		
		/**
		 * (override detail define) destroy detail setting
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
		
		//================
		// Constructor
		//================
		/**
		 * Constructor
		 */
		public function ItemLoadingManager() {
		}
		
		override public function init(_obj:Object = null):void {
			loadingItem_arr = new Array();
			setInstance(_obj);
		}
		
		private function loadNext():Boolean {
			var isNext:Boolean = true;
			if (loadProgress_num >= loadingItem_arr.length) {
				isNext = false;
				return isNext;
			}
			
			var tempLoadingItem:AbstractItemIncludeImageLoader = loadingItem_arr[loadProgress_num] as AbstractItemIncludeImageLoader;
			tempLoadingItem.startLoad();
			
			loadProgress_num++;
			return isNext;
		};
		
		private function loadNextRandom():Boolean {
			var isNext:Boolean = true;
			if (loadProgress_num >= loadingItem_arr.length) {
				isNext = false;
				return isNext;
			}
			
			var randomIndex:uint = Math.floor(Math.random() * loadingItem_copyArr.length)
			var tempLoadingItem:AbstractItemIncludeImageLoader = loadingItem_copyArr.splice(randomIndex, 1)[0] as AbstractItemIncludeImageLoader;
			
			tempLoadingItem.startLoad();	
			loadProgress_num++;
			
			return isNext;
		};
		
		/**
		 * 
		 * @param e
		 */
		protected function loadProcess_hd(e:CustomEvent):void {
			if(_isFinished) return;
			
			var paramObj:* = new Object();
			paramObj.target = e.target;
			
			switch(e.type) {
				case AbstractItemIncludeImageLoader.LOAD_COMPLETE : // <- ImageLoader.LOAD_PER_COMPLETE
					loadSuccess_num++;
					loadComplete_num++;
					if(loadComplete_num >= loadingItem_arr.length) {
						_isFinished = true;
						dispatchEvent(new CustomEvent(LOAD_PER_COMPLETE, paramObj));
						dispatchEvent(new CustomEvent(LOAD_COMPLETE));
						return;
					}
					dispatchEvent(new CustomEvent(LOAD_PER_COMPLETE, paramObj));
					distinguishRandomLoadProcess(flag_randomLoadProcess);
				break;	
				
				case AbstractItemIncludeImageLoader.LOAD_IOERROR :
					loadFail_num++;
					loadComplete_num++;
					if(loadComplete_num >= loadingItem_arr.length) {
						_isFinished = true;
						dispatchEvent(new CustomEvent(LOAD_PER_IOERROR, paramObj));
						dispatchEvent(new CustomEvent(LOAD_COMPLETE));
						return;
					}
					dispatchEvent(new CustomEvent(LOAD_PER_IOERROR, paramObj));
					distinguishRandomLoadProcess(flag_randomLoadProcess);
				break;
				
				case AbstractItemIncludeImageLoader.LOAD_PROGRESS :
					dispatchEvent(new CustomEvent(LOAD_PROGRESS, paramObj));
				break;
				
				case AbstractItemIncludeImageLoader.LOAD_SECURITYERROR :
					loadFail_num++;
					loadComplete_num++;
					if(loadComplete_num >= loadingItem_arr.length) {
						_isFinished = true;
						dispatchEvent(new CustomEvent(LOAD_PER_SECURITYERROR, paramObj));
						dispatchEvent(new CustomEvent(LOAD_COMPLETE));
						return;
					}
					dispatchEvent(new CustomEvent(LOAD_PER_SECURITYERROR, paramObj));
					distinguishRandomLoadProcess(flag_randomLoadProcess);
				break;
				
				case AbstractItemIncludeImageLoader.ACCESS_IMG_SECURITYERROR :
					loadFail_num++;
					loadComplete_num++;
					if(loadComplete_num >= loadingItem_arr.length) {
						_isFinished = true;
						dispatchEvent(new CustomEvent(ACCESS_PER_IMG_SECURITYERROR, paramObj));
						dispatchEvent(new CustomEvent(LOAD_COMPLETE));
						return;
					}
					dispatchEvent(new CustomEvent(ACCESS_PER_IMG_SECURITYERROR, paramObj));
					distinguishRandomLoadProcess(flag_randomLoadProcess);
				break;
				
				case AbstractItemIncludeImageLoader.LOADER_ERROR :
					loadFail_num++;
					loadComplete_num++;
					if(loadComplete_num >= loadingItem_arr.length) {
						_isFinished = true;
						dispatchEvent(new CustomEvent(LOADER_PER_ERROR, paramObj));
						dispatchEvent(new CustomEvent(LOAD_COMPLETE));
						return;
					}
					dispatchEvent(new CustomEvent(LOADER_PER_ERROR, paramObj));
					distinguishRandomLoadProcess(flag_randomLoadProcess);
				break;		
			}
		}
		
		private function distinguishRandomLoadProcess(_flag_randomLoadProcess:Boolean):void {
			if(_flag_randomLoadProcess) {
				loadNextRandom();
			}else{
				loadNext();
			}
		}
	}
}

