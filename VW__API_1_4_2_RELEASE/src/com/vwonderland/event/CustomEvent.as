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

package com.vwonderland.event {
	import flash.events.Event;
	
	/**
	 * simple CustomEvent
	 * @example Basic usage:<listing version="3.0">
	public class TestCustomEvent extends Sprite {
		public static const SHOUT_EVENT:String = "shout_event";
		
		private var test_str:String = "vwonderland";
		private var test_uint:uint = 8;
		private var test_arr:Array = [0, 1, 2, 3];
		
		public function TestCustomEvent():void {
			init();
		}
		
		public function init():void {
			addEventListener(TestCustomEvent.SHOUT_EVENT, listen_hd);
			
			//CustomEvent를 통해 전달할 parameter들을 Object 객체에 담는다.
			var paramObj:Object = new Object();
			paramObj.param_str = test_str;
			paramObj.param_uint = test_uint;
			paramObj.param_arr = test_arr;
			
			//CustomEvent를 발생시키며, 여러 parameter들이 담긴 Object 객체를 전달한다.  
			dispatchEvent(new CustomEvent(TestCustomEvent.SHOUT_EVENT, paramObj));
		}
		
		private function listen_hd(e:CustomEvent):void {
			//CustomEvent로부터 전달된 parameter들을 확인한다.
			trace(e.obj.param_str);
			trace(e.obj.param_uint);
			trace(e.obj.param_arr);
		}
	}
     *    </listing>
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  15.07.2010
	 */	
	public class CustomEvent extends Event {
		
		/** @private*/	
		private var _obj:Object; 
		
		//================
		// getter
		//================
		/**
		 * Indicates parameter Object Variable
		 * @return Object
		 */
		public function get obj():Object {
			return _obj;
		}
		
		//================
		// Constructor
		//================
		/**
		 * Constructor
		 * @param type
		 * @param param_obj
		 * @param bubbles
		 * @param cancelable
		 */
		public function CustomEvent(_type:String, _param_obj:Object = null, _bubbles:Boolean = false, _cancelable:Boolean = false):void {
			super(_type, _bubbles, _cancelable); 
			_obj = _param_obj;
		}
	}
}
