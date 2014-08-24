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

package com.vwonderland.data
{
	/**
	 * HashMap class
	 * @example Basic usage:
	 * <listing version="3.0">
	var hash:HashMap = new HashMap();
	var object:Object = {a:"aaa" , b:"bbb"};
	hash.putAll(object);
	
	var point:Point = new Point(22,23);
	hash.put("point" , new Point(1,2));
	hash.put("rectangle" , new Rectangle(0,0,1,1));
	hash.put("arr1" , new Array(0,1,2,3));
	hash.put("arr2" , new Array(33, 33));
	hash.put("point" , new Point(3333,444));
	hash.put("po1" , point);
	
	trace(hash.getKeys());   // a,point,po1,b,rectangle,arr1,arr2
	trace(hash.getValues());  // aaa,(x=3333, y=444),(x=22, y=23),bbb,(x=0, y=0, w=1, h=1),0,1,2,3,33,33
	trace(hash.size);  // 7
	trace(hash.remove("point"));  // true
	trace(hash.getKeys());  // a,po1,b,rectangle,arr1,arr2
	trace(hash.size);  // 6
	trace(hash.getClasses(String));  // aaa,bbb
	trace(hash.getKey(point));  // po1
	trace(hash.isEmpty());  // false
	trace(hash.clear());
	trace(hash.isEmpty());  // true
	 * </listing>
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  23.05.2011
	 */
	dynamic public class HashMap extends Object// AbstractHash
	{
		
		/**
		 * 빈 상태(empty)의 HashMap 작성(해당 구현은 맵의 순서를 항상 일정하게 유지하는 것을 보증하지 않습니다)
		 */
		public function HashMap() {
		}
		
		/**
		 * 지정된 key와 value를 HashMap에 등록
		 * @example Basic usage:
		 * <listing version="3.0">
		var hash:HashMap = new HashMap();
		hash.put("point1", new Point(100, 200));
		hash.put("rectangle1", new Rectangle(0, 0, 330, 120));
		trace(hash.getValue("point1")); // (x=100, y=200)
	 	 * </listing>
		 * @param _key
		 * @param _value
		 */
		public function put(_key:String, _value:Object):void {
			this[_key] = _value;
		}
		
		/**
		 * 지정된 맵으로부터 모든 맵핑을 HashMap에 복사
		 * @example Basic usage:
		 * <listing version="3.0">
		var hash:HashMap = new HashMap();
		var object:Object = {akey:"Avalue", bkey:"Bvalue" }
		hash.putAll(object);
		trace(hash.getKeys()); // akey,bkey
		trace(hash.getValues()); // Avalue,Bvalue
	 	 * </listing>
		 * @param _obj
		 */
		public function putAll(_obj:Object):void {
			var key:String;
			for(key in _obj){
				this.put(key, _obj[key]);
			}
		}
		
		/**
		 * 지정된 key를 이용해, 해당 key와 맵핑된 value 반환
		 * @example Basic usage:
		 * <listing version="3.0">
		var hash:HashMap = new HashMap();
		var point:Point = new Point(100, 200);
		hash.put("pointKey", point);
		trace(hash.getValue("pointKey")); // (x=100, y=200)
	 	 * </listing>
		 * @param _key
		 * @return Object
		 */
		public function getValue(_key:String):Object {
			return this[_key];
		}
		
		/**
		 * 지정된 value를 이용해, 해당 value와 맵핑된 key를 반환
		 * @example Basic usage:
		 * <listing version="3.0">
		var hash:HashMap = new HashMap();
		var point:Point = new Point(100, 200);
		hash.put("pointKey", point);
		trace(hash.getKey(point)); // pointKey
	 	 * </listing>
		 * @param _value
		 * @return String
		 */
		public function getKey(_value:Object):String {
			var hashKey:Array = getKeys()
			for(var i:uint = 0; i < hashKey.length ; i++){
				if(_value == this[hashKey[i]]){
					var key:String = hashKey[i];
					break;
				}
			}
			return key;
		}
		
		/**
		 * HashMap에 포함된 모든 key를 배열에 담아 반환
		 * @example Basic usage:
		 * <listing version="3.0">
		var hash:HashMap = new HashMap();
		hash.put("point1", new Point(100, 200));
		hash.put("rectangle1", new Rectangle(0, 0, 330, 120));
		hash.put("str", "HASHMAP");
		trace(hash.getKeys()); // point1, rectangle1, str
	 	 * </listing>
		 * @return Array
		 */
		public function getKeys():Array {
			var hashKey:Array = new Array();
			var key:String;
			for(key in this) hashKey.push(key);
			return hashKey;
		}
		
		/**
		 * HashMap에 포함된 모든 value를 배열에 담아 반환
		 * @example Basic usage:
		 * <listing version="3.0">
		var hash:HashMap = new HashMap();
		hash.put("point1" , new Point(100, 200));
		hash.put("rectangle1" , new Rectangle(0, 0, 330, 120));
		hash.put("str", "HASHMAP");
		trace(hash.getValues()); // (x=100, y=200), (x=0, y=0, w=330, h=120), HASHMAP
	 	 * </listing>
		 * @return Array
		 */
		public function getValues():Array {
			var hashValue:Array = new Array();
			var key:String;
			for(key in this) hashValue.push(this.getValue(key));
			return hashValue;
		}
		
		/**
		 * 지정된 Class를 이용해 HashMap이 포함하고 있는 동일한 Class의 value를 배열에 담아 반환
		 * @example Basic usage:
		 * <listing version="3.0">
		var hash:HashMap = new HashMap();
		hash.put("point1" , new Point(100, 200));
		hash.put("rectangle1" , new Rectangle(0,0, 330, 120));
		hash.put("point2" , new Point(99, 77));
		hash.put("str" , "HASHMAP");
		trace(hash.getClasses(Point)); // (x=100,y=200), (x=99,y=77)
	 	 * </listing>
		 * @param className
		 * @return Array
		 */
		public function getClasses(className:Class):Array {
			var classArray:Array = new Array();
			var key:String;
			for(key in this){
				if(this[key] is className) classArray.push(this.getValue(key));
			}
			return classArray;
		}
		
		/**
		 * HashMap으로부터 지정된 key의 맵핑 삭제
		 * @example Basic usage:
		 * <listing version="3.0">
		var hash:HashMap = new HashMap();
		hash.put("point1", new Point(100, 200));
		hash.put("rectangle1", new Rectangle(0, 0, 330, 120));
		hash.put("point2", new Point(99, 77));
		hash.put("str", "HASHMAP");
		trace(hash.getValue("point1")); // (x=100, y=200)
		
		hash.remove("point1");
		trace(hash.getValue("point1")); // null
	 	 * </listing>
		 * @param key
		 * @return Boolean
		 */
		public function remove(key:String):Boolean {
			var removed:Boolean = false;
			if(this[key]){
				delete this[key];
				removed = true;
			}
			return removed;
		}
		
		/**
		 * HashMap의 모든 맵핑 삭제
		 * @example Basic usage:
		 * <listing version="3.0">
		var hash:HashMap = new HashMap();
		hash.put("point1", new Point(100, 200));
		hash.put("rectangle1", new Rectangle(0, 0, 330, 120));
		hash.put("point2", new Point(99, 77));
		hash.put("str", "HASHMAP");
		trace(hash.size); // 4
		
		hash.clear();
		trace(hash.size); // 0
	 	 * </listing>
		 */
		public function clear():void {
			var key:String;
			for(key in this){
				delete this[key];
			}
		}
		
		/**
		 * HashMap 내의 모든 맵핑 수 반환
		 * @example Basic usage:
		 * <listing version="3.0">
		var hash:HashMap = new HashMap();
		trace(hash.size); // 0
		
		hash.put("point1", new Point(100, 200));
		trace(hash.size); // 1
		
		hash.put("rectangle1", new Rectangle(0, 0, 330, 120));
		trace(hash.size); // 2
		
		hash.put("point2", new Point(99, 77));
		trace(hash.size); // 3
	 	 * </listing>
		 * @return int
		 */
		public function get size():int {
			var cnt:int = 0;
			var key:String;
			for(key in this) cnt++;
			return cnt;
		}
		
		/**
		 * HashMap에 맵핑된 데이터가 존재하지 않는지의 확인(맵핑된 데이터가 없다면 true 반환)
		 * @example Basic usage:
		 * <listing version="3.0">
		var hash:HashMap = new HashMap();
		trace(hash.isEmpty()); // true
		
		hash.put("point1", new Point(100, 200));
		trace(hash.isEmpty()); // false
	 	 * </listing>
		 * @return Boolean
		 */
		public function isEmpty():Boolean{
			var key:String;
			for(key in this){
				return false;
			}
			return true;
		}
	}
}