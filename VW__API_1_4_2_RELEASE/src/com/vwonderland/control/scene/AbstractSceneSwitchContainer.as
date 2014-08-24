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

package com.vwonderland.control.scene
{
	import com.vwonderland.base.AbstractControllableMovieClip;
	import com.vwonderland.base.AbstractControllableScene;
	import com.vwonderland.base.IControllableScene;
	import com.vwonderland.base.IResizeableObject;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * abstract scene switch container class
	 * @example Basic usage:<listing version="3.0">
	private var _sceneSwitchContainer:AbstractSceneSwitchContainer;
	private var _scene_1:SceneSample_1;
	private var _scene_2:SceneSample_2;

	public function TestSceneSwitchContainer():void {
		_sceneSwitchContainer = new AbstractSceneSwitchContainer();
		_sceneSwitchContainer.init();
		this.addChild(_sceneSwitchContainer);
		
		var _button:MovieClip;
		for(var i:uint = 0; i &#60; 2; ++i) {
			_button = new MovieClip();
			_button.index = int(i + 1);
			_button.addChild(SimpleRect.drawRectSprite(20, 20, 0xff0000));
			InteractionUtil.makeSimpleButtonInteraction(_button, buttonMouseInteraction);
			
			_button.x = i &#42; 30;
			_button.y = 200;
			this.addChild(_button);
		}
	}
	
	private function buttonMouseInteraction(e:MouseEvent):void {
		var _targetButton:MovieClip = e.currentTarget as MovieClip;
		var targetIndex:int = _targetButton.index;
		switch(e.type) {
			case MouseEvent.CLICK :
				if(targetIndex == 1) {
					_scene_1 = new SceneSample_1();
					_sceneSwitchContainer.setScene(_scene_1, "scene_1"); //set new scene
					_sceneSwitchContainer.switchScene(); //new scene entranceScene()
				}else if(targetIndex == 2) {
					_scene_2 = new SceneSample_2();
					_sceneSwitchContainer.setScene(_scene_2, "scene_2"); //set new scene
					_sceneSwitchContainer.switchScene(); //new scene entranceScene()
				}
			break;
		}
	}
	
	//make extra SceneSample_1 Class extends AbstractControllableScene
	public class SceneSample_1 extends AbstractControllableScene
	{	
		override public function destroy(_obj:Object=null):void {
			DisplayUtil.removeDisplayObject(this);
		}
		
		override public function entranceScene(_obj:Object=null):void {
			if(_rect != null) TweenMax.to( _rect, 2, {x:100, alpha:1, ease:Quint.easeInOut} );
		}
		
		override public function exitScene(_obj:Object=null):void {
			if(_rect != null) TweenMax.to( _rect, 2, {x:200, alpha:0.5, ease:Quint.easeInOut, onComplete:destroy} );
		}
		
		private var _rect:Sprite;
		
		public function SceneSample_1() {
		}
		
		override public function init(_obj:Object = null):void {
			_rect = SimpleRect.drawRectSprite();
			_rect.alpha = 0;
			this.addChild(_rect);
		}
	}
	
	//make extra SceneSample_2 Class extends AbstractControllableScene
	public class SceneSample_2 extends AbstractControllableScene
	{	
		override public function destroy(_obj:Object=null):void {
			DisplayUtil.removeDisplayObject(this);
		}
		
		override public function entranceScene(_obj:Object=null):void {
			if(_diagonalRect != null) TweenMax.to( _diagonalRect, 2, {x:100, alpha:1, ease:Quint.easeInOut} );
		}
		
		override public function exitScene(_obj:Object=null):void {
			if(_diagonalRect != null) TweenMax.to( _diagonalRect, 2, {x:200, alpha:0.5, ease:Quint.easeInOut, onComplete:destroy} );
		}
		
		private var _diagonalRect:Sprite;
		
		public function SceneSample_2() {
		}
		
		override public function init(_obj:Object = null):void {
			_diagonalRect = SimpleRect.drawDiagonalRectSpriteByGapBottomX();
			_diagonalRect.alpha = 0;
			_diagonalRect.y = 200;
			this.addChild(_diagonalRect);
		}
	}
	 *    </listing>  
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  12.02.2011
	 */
	public class AbstractSceneSwitchContainer extends AbstractControllableMovieClip implements IResizeableObject
	{	
		/**
		 * (override detail define) resize
		 * @param _obj
		 */
		public function	resize(_obj:Object=null):void {
			//override define detail
		}
		
		/**
		 * set current scene to scene container
		 * @param _scene
		 * @param _sceneName
		 * @param _sceneParamObj
		 */
		public function	setScene(_scene:Object, _sceneName:String, _sceneParamObj:Object=null):void {
			if(_currentScene != null) _prevScene = _currentScene;
			_currentScene = _scene;
			_currentScene.sceneName = _sceneName;
			_container.addChild(DisplayObject(_currentScene));
			_currentScene.init(_sceneParamObj);
		}
		
		/**
		 * call prev scene exitScene(_prevSceneParamObj) &#38; call current scene entranceScene(_currentSceneParamObj)
		 * @param _currentSceneParamObj
		 * @param _prevSceneParamObj
		 */
		public function	switchScene(_currentSceneParamObj:Object=null, _prevSceneParamObj:Object=null):void {
			if(_prevScene != null) {
				_prevScene.exitScene(_prevSceneParamObj);
				_prevScene = null;
			}
			if(_currentScene != null) _currentScene.entranceScene(_currentSceneParamObj);
		}
		
		/**
		 * change status of current scene - call currentScene changeSceneStatus(_obj)
		 * @param _obj
		 */
		public function	changeSceneStatus(_obj:Object=null):void {
			if(_currentScene != null) _currentScene.changeSceneStatus(_obj);
		}
		
		/**
		 * prev display scene
		 * @default 
		 */
		protected var _prevScene:Object;
		
		/**
		 * current display scene
		 * @default 
		 */
		protected var _currentScene:Object;
		
		/**
		 * scene container
		 * @default 
		 */
		protected var _container:Sprite;
		
		/**
		 * get prev scene
		 * @return 
		 */
		public function	get prevSwitchScene():Object {
			return _prevScene;
		}
		
		/**
		 * get current scene
		 * @return 
		 */
		public function	get currentSwitchScene():Object {
			return _currentScene;
		}
		
		/**
		 * Contructor
		 */
		public function AbstractSceneSwitchContainer()
		{
		}
		
		override public function init(_obj:Object = null):void {
			_container = new Sprite();
			this.addChild(_container);
			
			setInstance(_obj);
		}
		
		/**
		 * (override detail define) instance variables setting
		 * @param _obj
		 */
		protected function setInstance(_obj:Object):void {
			//override instance setting
		}
	}
}