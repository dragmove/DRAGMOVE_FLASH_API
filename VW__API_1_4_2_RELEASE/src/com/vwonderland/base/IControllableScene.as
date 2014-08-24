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
	 * Interface include entranceScene(), exitScene(), changeSceneStatus() Function
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  19.01.2011
	 */
	public interface IControllableScene extends IControllableObject, IResizeableObject
	{
		/** entranceScene Function.
		 *  need to use override.
		 *
		 *  @param _obj  entranceScene Object Variable
		 *  @see #exitScene()
		 *  @see #changeSceneStatus()
		 */
		function entranceScene(_obj:Object=null):void;
		
		/** exitScene Function.
		 *  need to use override.
		 *
		 *  @param _obj  exitScene Object Variable
		 *  @see #entranceScene()
		 *  @see #changeSceneStatus()
		 */
		function exitScene(_obj:Object=null):void;
		
		/** changeSceneStatus Function.
		 *  need to use override.
		 *
		 *  @param _obj  changeSceneStatus Object Variable
		 *  @see #entranceScene()
		 *  @see #exitScene()
		 */
		function changeSceneStatus(_obj:Object=null):void;
		
		/**
		 * sceneName Variable
		 */
		function get sceneName():String;
		function set sceneName(_name:String):void;
		
		/**
		 * sceneHeight Variable
		 */
		function get sceneHeight():Number;
		function set sceneHeight(_height:Number):void;
		
		/**
		 * sceneWidth Variable
		 */
		function get sceneWidth():Number;
		function set sceneWidth(_width:Number):void;
	}
}

