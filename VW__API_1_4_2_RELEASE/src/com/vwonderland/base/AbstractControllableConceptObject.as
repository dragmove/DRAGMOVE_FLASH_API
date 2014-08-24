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
	import flash.events.EventDispatcher;

	/**
	 * initialize, destroy Function과 index, extraObject Variable을 지니는 EventDispatcher. Stage 상에 addChild 시키지 않고 사용할 객체의 Abstract Class
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  14.07.2010
	 */
	public class AbstractControllableConceptObject extends EventDispatcher implements IControllableObject
	{
		/**
		 * @private
		 * order Variable
		 */
		private var idx:int;

		/** extra Variable*/
		public var extraObject:Object;

		/**
		 * object order(index) Variable
		 * @return int
		 */
		public function get index():int
		{
			return idx;
		}
		
		public function set index(_value:int):void
		{
			idx=_value;
		}

		/** initialize Function.
		 *  need to use override.
		 *
		 *  @param _obj  initialize Object Variable
		 *  @see #destroy()
		 */
		public function init(_obj:Object=null):void
		{
			//override initialization
		}

		/** destroy Function.
		 *  need to use override
		 *
		 *  @param _obj  destroy Object Variable
		 *  @see #init()
		 */
		public function destroy(_obj:Object=null):void
		{
			//override destroy
		}

		/** Constructor*/
		public function AbstractControllableConceptObject()
		{
		}
	}
}
