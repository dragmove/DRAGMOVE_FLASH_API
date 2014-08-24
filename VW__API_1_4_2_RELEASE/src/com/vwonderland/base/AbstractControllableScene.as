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

package com.vwonderland.base
{
	/**
	 * AbstractControllableMovieClip를 상속하며 sceneName, sceneHeight Variable을 지니는 MovieClip. scene 간의 전환 motion을 위한 entranceScene(), exitScene() Function과 scene 내부의 상태 변화를 위한 changeSceneStatus(), resize() Function을 가지는 Abstract Class 
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  24.01.2011
	 */
	public class AbstractControllableScene extends AbstractControllableMovieClip implements IControllableScene
	{
		private var internalSceneName:String;
		private var internalSceneHeight:Number;
		private var internalSceneWidth:Number;
		
		/**
		 * sceneName Variable
		 * @return String
		 */
		public function get sceneName():String
		{
			return internalSceneName;
		}
		
		public function set sceneName(_name:String):void
		{
			internalSceneName=_name;
		}
		
		/**
		 * sceneHeight Variable
		 * @return Number
		 */
		public function get sceneHeight():Number
		{
			return internalSceneHeight;
		}
		
		public function set sceneHeight(_height:Number):void
		{
			internalSceneHeight=_height;
		}
		
		/**
		 * sceneWidth Variable
		 * @return Number
		 */
		public function get sceneWidth():Number
		{
			return internalSceneWidth;
		}
		
		public function set sceneWidth(_width:Number):void
		{
			internalSceneWidth=_width;
		}
		
		/** entrance scene motion Function.
		 *  need to use override.
		 *
		 *  @param _obj  Object Variable
		 *  @see #exitScene()
		 */
		public function	entranceScene(_obj:Object=null):void {
			//override entrance scene motion
		}
		
		/** exit scene motion Function.
		 *  need to use override.
		 *
		 *  @param _obj	 Object Variable
		 *  @see #entranceScene()
		 */
		public function	exitScene(_obj:Object=null):void {
			//override exit scene motion
		}
		
		/** change scene status Function.
		 *  need to use override.
		 *
		 *  @param _obj	 Object Variable
		 */
		public function changeSceneStatus(_obj:Object=null):void {
			//override change scene status
		}
		
		/** resize Function.
		 *  need to use override.
		 *
		 *  @param _obj	 Object Variable
		 */
		public function	resize(_obj:Object=null):void {
			//override resize
		}
		
		/** Constructor*/
		public function AbstractControllableScene()
		{
		}
	}
}