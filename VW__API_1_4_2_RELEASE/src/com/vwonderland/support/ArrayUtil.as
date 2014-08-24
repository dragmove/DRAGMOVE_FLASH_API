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

package com.vwonderland.support {
	import flash.utils.ByteArray;
	
	/**
	 * static Array Utils
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  14.07.2010
	 */	
	public class ArrayUtil {
		/**
		 * Number type value들이 담긴 Array 내부의 값 중 value값과 가장 가까운 값을 찾아내고 배열의 인덱스 값을 반환합니다.(동일한 오차일 경우, 가장 뒤쪽에 존재하는 값의 위치를 반환합니다.)
		 * @example Basic usage:
		 * <listing version="3.0">
		var array:Array = new Array(100,200,300,400,500);
		var value:Number = 180;
		trace(ArrayUtil.getNearArrayPositionByValue(array , value));  // 1
		
		array = new Array(100,400,200,300,50);
		value = 40;
		trace(ArrayUtil.getNearArrayPositionByValue(array , value));  // 4
		
		array = new Array(-100,-200,-300,100,500);
		value = -180;
		trace(ArrayUtil.getNearArrayPositionByValue(array , value));  // 1
		 * </listing>
		 * @param _arr
		 * @param _value
		 * @return int
		 * @see #getNearArrayValueByValue()
		 */
		static public function getNearArrayPositionByValue(_arr:Array, _value:Number):int{
			var nearIndex:int;
			var minValue:Number = Math.abs(_value - _arr[0]);
			for(var i:uint = 0 ; i < _arr.length ; i++){
				if(minValue >= Math.abs(_value - _arr[i])){
					minValue = Math.abs(_value - _arr[i]);
					nearIndex = i;
				}
			}
			return nearIndex;
		}
		
		/**
		 * Number type value들이 담긴 Array 내부의 값 중 value값과 가장 가까운 값을 찾아내고 그 값을 반환합니다.(동일한 오차일 경우, 가장 뒤쪽에 존재하는 값의 위치를 반환합니다.)
		 * @example Basic usage:
		 * <listing version="3.0">			
		var array:Array = new Array(100,200,300,400,500);
		var value:Number = 180;
		trace(ArrayUtil.getNearArrayValueByValue(array , value));  // 200
		
		array = new Array(100,400,200,300,50);
		value = 40;
		trace(ArrayUtil.getNearArrayValueByValue(array , value));  // 50
		
		array = new Array(-100,-200,-300,100,500);
		value = -180;
		trace(ArrayUtil.getNearArrayValueByValue(array , value));  // -200
		 * </listing>
		 * @param _arr
		 * @param _value
		 * @return int
		 * @see #getNearArrayPositionByValue()
		 */
		static public function getNearArrayValueByValue(_arr:Array, _value:Number):Number{
			var nearIndex:int;
			var minValue:Number = Math.abs(_value - _arr[0]);
			for(var i:uint = 0 ; i < _arr.length ; i++){
				if(minValue >= Math.abs(_value - _arr[i])){
					minValue = Math.abs(_value - _arr[i]);
					nearIndex = i;
				}
			}
			return _arr[nearIndex];
		}
		
		/**
		 * Array 내부의 객체의 Number type 속성의 크기를 비교하여, 속성 크기의 순서대로 정렬된 Array를 반환.
		 * @example Basic usage:<listing version="3.0">
		 var elementArr:Array = [{x:10}, {x:0}, {x:30}, {x:20}, {x:50}, {x:40}];
		 var arrangeArr:Array = ArrayUtil.getArrangedArrByElementNumberTypeProperty(elementArr, "x");
		 
		 var _element:&#42;;
		 for(var i:uint = 0; i &#60; arrangeArr.length; ++i) {
		 	_element = arrangeArr[i];
		 	trace("_element.x :", _element.x);
		 }
		 *    </listing> 
		 * @param _arr
		 * @param _elementNumberTypePropertyName	uint, int, Number type property name of element in Array
		 * @return Array
		 */
		static public function getArrangedArrByElementNumberTypeProperty(_arr:Array, _elementNumberTypePropertyName:String):Array {
			var tarray:Array = _arr;
			var returnArr:Array = new Array();
			var _elementObj:*;
			var _compareElementObj:*;
			var comparisonCount:uint = 0;
			
			var tarrayLenth:uint = tarray.length;
			for(var i:uint = 0; i < tarrayLenth; ++i) {
				_elementObj = tarray[i];
				if(!_elementObj.hasOwnProperty(_elementNumberTypePropertyName)) {
					trace("[com.vwonderland.support.ArrayUtil.arrangArrByElementProperty] - Array 내부의 객체에 _elementNumberTypePropertyName 문자열과 일치하는 속성이 존재하지 않습니다. null을 반환합니다."); 
					break;
					return null;
				}else{
					if(typeof _elementObj[_elementNumberTypePropertyName] != "number") {
						trace("[com.vwonderland.support.ArrayUtil.arrangArrByElementProperty] - Array 내부의 객체의 _elementNumberTypePropertyName 속성은 uint, int, Number type이 아닙니다. null을 반환합니다.");
						break;
						return null;
					}
				}
				if(returnArr.length <= 0) {
					returnArr.push(_elementObj);
				}else{
					comparisonCount = 0;
					for(var k:uint = 0; k < returnArr.length; ++k) {
						_compareElementObj = returnArr[k]; 
						if(_compareElementObj != _elementObj) {
							if(_compareElementObj[_elementNumberTypePropertyName] > _elementObj[_elementNumberTypePropertyName]) {
								break;
							}else{
								comparisonCount++;
							}
						}
					}
					returnArr.splice(comparisonCount, 0, _elementObj);
				}
			}
			return returnArr;
		} 
		
		/**
		 * Array를 복사한 새 Array를 반환.
		 * @example Basic usage:<listing version="3.0">
		var _testArr:Array = ["VW", "V-WONDERLAND", "EXTENSION"];
		var _cloneArr:Array = ArrayUtil.getCloneArray(_testArr);
		trace(_cloneArr); //display VW,V-WONDERLAND,EXTENSION
		 *    </listing> 
		 * @param _arr
		 * @return Array
		 * 
		 */			
		public static function getCloneArray(_arr:Array):Array 
		{
			var cloneArr:Array = _arr.concat();
			return cloneArr;
		}
		
		/**
		 * Number type value들이 담긴 Array 내부의 값 중 가장 큰 값을 반환
		 * @example Basic usage:<listing version="3.0">
		var numArr:Array = [10, 30, 20, 120, 55];
		trace(ArrayUtil.getMaxNumberByArr(numArr)); //display 120
		 *    </listing> 
		 * @param _arr
		 * @return Number
		 * @see #getMinNumberByArr()
		 */
		static public function getMaxNumberByArr(_arr:Array):Number {
			var tarray: Array = _arr;
			tarray.sort( Array.NUMERIC );
			return tarray[ tarray.length - 1 ];
		}
		
		/**
		 * Number type value들이 담긴 Array 내부의 값 중 가장 작은 값을 반환(Array의 length가 1보다 작을 경우, 0을 반환합니다.)
		 * @example Basic usage:<listing version="3.0">
		var numArr:Array = [10, 30, 20, 120, 55];
		trace(ArrayUtil.getMinNumberByArr(numArr)); //display 10
		 *    </listing> 
		 * @param _arr
		 * @return Number
		 * @see #getMaxNumberByArr()
		 */
		static public function getMinNumberByArr(_arr:Array):Number {
			var tarray: Array = _arr;
			tarray.sort( Array.NUMERIC );
			return tarray[ 0 ];
		}
		
		/**
		 * Number type value들이 담긴 Array 내부의 값 중 가장 큰 값이 있는 위치값을 반환(같은 값이 존재할 경우, 가장 뒤쪽에 존재하는 값의 위치를 반환합니다.)
		 * @example Basic usage:<listing version="3.0">
		 var numArr:Array = [10, 30, 20, 120, 55];
		 trace(ArrayUtil.getMaxNumberPositionByArr(numArr)); //가장 큰 값인 120의 위치인 3 이 반환
		 *    </listing> 
		 * @param _arr
		 * @return uint
		 * @see #getMinNumberPositionByArr()
		 */
		static public function getMaxNumberPositionByArr(_arr:Array):uint {
			if(_arr.length <= 1) return 0;
			var tempPosition:uint = 0;
			var tempNumber:Number = _arr[0];
			
			for(var i:uint = 1; i < _arr.length; ++i) {
				var comparisonNumber:Number = _arr[i];
				tempNumber = Math.max(tempNumber, comparisonNumber);
				if(tempNumber == comparisonNumber) tempPosition = i;
			}
			return tempPosition;
		}
		
		/**
		 * Number type value들이 담긴 Array 내부의 값 중 가장 작은 값이 있는 위치값을 반환(같은 값이 존재할 경우, 가장 뒤쪽에 존재하는 값의 위치를 반환합니다.)
		 * @example Basic usage:<listing version="3.0">
		var numArr:Array = [10, 30, 20, 120, 55];
		trace(ArrayUtil.getMinNumberPositionByArr(numArr)); //가장 작은 값인 10의 위치인 0 이 반환
		 *    </listing> 
		 * @param _arr
		 * @return uint
		 * @see #getMaxNumberPositionByArr()
		 */
		static public function getMinNumberPositionByArr(_arr:Array):uint {
			if(_arr.length <= 1) return 0;
			var tempPosition:uint = 0;
			var tempNumber:Number = _arr[0];
			
			for(var i:uint = 1; i < _arr.length; ++i) {
				var comparisonNumber:Number = _arr[i];
				tempNumber = Math.min(tempNumber, comparisonNumber);
				if(tempNumber == comparisonNumber) tempPosition = i;
			}
			return tempPosition;
		}
		
		/**
		 * _arr 내부의 원소를 random하게 Mix합니다.
		 * @example Basic usage:<listing version="3.0">
		var _testArr:Array = [10, 30, 20, 120, 55];
		ArrayUtil.randomSort(_testArr);
		trace(_testArr);
		 *    </listing> 
		 * @param _arr
		 */
		static public function randomSort(_arr:Array):void {
			_arr.sort(
				function( _elementA:Object, _elementB:Object):Number {
					var _num:Number = Math.random() - .5;
					var value: int = ( _num > 0 )? 1 : -1;
					return value;
				}
			);
		}
	}
} 
