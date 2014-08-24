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
	import flash.display.*;
	import flash.geom.*;
	
	/**
	 * static Math Utils
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  15.07.2010
	 */	
	public class MathUtil {
		
		/**
		 * linePoint_1 과 linePoint_2를 지나는 직선 상의, somePoint가 직교하는 Point를 반환. 
		 * @example Basic usage:<listing version="3.0">
		var _linePoint_1:Point = new Point(0, 0);
		var _linePoint_2:Point = new Point(100, 100);
		
		var _somePoint:Point = new Point(50, 100);
		var _crossPoint:Point = MathUtil.getCrossPointBetweenTwoPointsLineAndSomePoint(_somePoint, _linePoint_1, _linePoint_2);
		trace("_crossPoint :", _crossPoint); // (0,0)좌표와 (100,100)좌표를 지나는 직선 상에서, (50,100)의 Point가 직교하는 위치인 (75, 75)의 위치를 반환합니다.
		 *    </listing> 
		 * @param _somePoint
		 * @param _linePoint_1
		 * @param _linePoint_2
		 * @return Point
		 */
		public static function getCrossPointBetweenTwoPointsLineAndSomePoint(_somePoint:Point, _linePoint_1:Point, _linePoint_2:Point):Point {
			if(_linePoint_1.x == _linePoint_2.x && _linePoint_1.y == _linePoint_2.y) {
				trace("[com.vwonderland.support.MathUtil.getCrossPointBetweenTwoPointsLineAndSomePoint] - _linePoint_1과 _linePoint_2의 위치가 같습니다. null을 반환합니다.]");
				return null;
			}
			var denominator:Number = _linePoint_2.x - _linePoint_1.x;
			var numerator:Number = _linePoint_2.y - _linePoint_1.y;
			if(denominator == 0) return new Point(_linePoint_1.x, _somePoint.y);
			if(numerator == 0) return new Point(_somePoint.x, _linePoint_1.y);
			
			var twoPointsLineSlope:Number = numerator / denominator;
			var somePointLineSlope:Number = -1/twoPointsLineSlope;
			var returnPoint:Point = new Point();
			returnPoint.x = (somePointLineSlope*_somePoint.x - twoPointsLineSlope*_linePoint_1.x + _linePoint_1.y - _somePoint.y) / (somePointLineSlope - twoPointsLineSlope);
			returnPoint.y = somePointLineSlope * (returnPoint.x - _somePoint.x) + _somePoint.y;
			return returnPoint; 
		}
		
		/**
		 * curveTo를 이용해 그리는 line은 point가 3개 필요합니다. point가 3개 이상일 경우, 연속된 curve를 연결하는 간단한 방법으로 point와 point 사이의 point를 curveTo Function에 이용하여 line을 그립니다. _pointArr param - Point 객체가 담겨있는 Array. _canvasSprite param - _pointArr param 내의 Point들로 line을 그릴 canvas 역할의 Sprite.
		 * @example Basic usage:<listing version="3.0">
		var _canvas:Sprite = new Sprite();
		this.addChild(_canvas);
			
		var _point:Point;
		var _arr:Array = new Array();
		var i:uint;
		for(i = 0; i &#60; 5; i++) {
			_point = new Point(Math.random() &#42; 200, Math.random() &#42; 200);
			_arr.push(_point);
		}
		MathUtil.drawConnectedOpenCurve(_arr, _canvas, 1, 0xff0000);
		 *    </listing>   
		 * @param _pointArr
		 * @param _canvasSprite
		 * @param _lineThickness
		 * @param _lineColor
		 * @param _lineAlpha
		 * @see #drawConnectedCloseCurve()
		 */
		static public function drawConnectedOpenCurve(_pointArr:Array, _canvasSprite:Sprite, _lineThickness:Number, _lineColor:uint = 0, _lineAlpha:Number = 1.0):void { //Flash Math & Physics Design:ActionScript 3.0による数学・物理学表現[入門編] 古堅 真彦 (2008/12/25) - 236p 참고.
			if (_pointArr.length > 3) new Error("[com.vwonderland.support.MathUtil.drawConnectedOpenCurve] - 3개 이상의 point가 Array 내에 담겨 있어야 합니다.");
			var tempGraphics:Graphics = _canvasSprite.graphics as Graphics;
			tempGraphics.lineStyle(_lineThickness, _lineColor, _lineAlpha);
			tempGraphics.moveTo(_pointArr[0].x, _pointArr[0].y);
			
			for (var i:uint = 1; i <= _pointArr.length - 3; ++i) {
				_canvasSprite.graphics.curveTo(_pointArr[i].x, _pointArr[i].y, (_pointArr[i].x + _pointArr[i + 1].x) / 2, (_pointArr[i].y + _pointArr[i + 1].y) / 2);
			}
			_canvasSprite.graphics.curveTo(_pointArr[_pointArr.length - 2].x, _pointArr[_pointArr.length - 2].y, _pointArr[_pointArr.length - 1].x, _pointArr[_pointArr.length - 1].y);
		}
		
		/**
		 * drawConnectedOpenCurve Function의 기능과 동일하나, line의 시작점과 끝점이 연결된 밀폐된 line을 그립니다.
		 * @example Basic usage:<listing version="3.0">
		var _canvasSprite:Sprite = new Sprite();
		this.addChild(_canvasSprite);
		
		var _point:Point;
		var _pointArr:Array = new Array();
		for(var i:uint = 0; i &#60; 5; ++i) {
			_point = new Point(Math.random() &#42; 200, Math.random() &#42; 200);
			_pointArr.push(_point);
		}
		MathUtil.drawConnectedCloseCurve(_pointArr, _canvasSprite, 1, 0xff0000);
		 *    </listing> 
		 * @param _pointArr
		 * @param _canvasSprite
		 * @param _lineThickness
		 * @param _lineColor
		 * @param _lineAlpha
		 * @see #drawConnectedOpenCurve() 
		 */
		static public function drawConnectedCloseCurve(_pointArr:Array, _canvasSprite:Sprite, _lineThickness:Number, _lineColor:uint = 0, _lineAlpha:Number = 1.0):void {
			if (_pointArr.length > 3) new Error("[com.vwonderland.support.MathUtil.drawConnectedCloseCurve] - 3개 이상의 point가 Array 내에 담겨 있어야 합니다.");
			var tempGraphics:Graphics = _canvasSprite.graphics as Graphics;
			tempGraphics.lineStyle(_lineThickness, _lineColor, _lineAlpha);
			
			var xc1:Number = (_pointArr[0].x + _pointArr[_pointArr.length - 1].x) / 2;
			var yc1:Number = (_pointArr[0].y + _pointArr[_pointArr.length - 1].y) / 2;
			tempGraphics.moveTo(xc1, yc1);
			
			var i:uint = 0;
			for (i = 0; i < _pointArr.length - 1; ++i) {
				_canvasSprite.graphics.curveTo(_pointArr[i].x, _pointArr[i].y, (_pointArr[i].x + _pointArr[i + 1].x) / 2, (_pointArr[i].y + _pointArr[i + 1].y) / 2);
			}
			_canvasSprite.graphics.curveTo(_pointArr[i].x, _pointArr[i].y, xc1, yc1);
		}
		
		/**
		 * 물체의 가속도(_a)와 각도(_rot - x축에 대해 형성된 각도로서 rot = Math.atan2(y,x)의 radian value)에 따른 가속도 벡터의 x축 성분 출력. 
		 * @example Basic usage:<listing version="3.0">
		var y_1:Number = -3;
		var x_1:Number = -7;
		
		var a:Number = 20;
		var rot:Number = Math.atan2(y_1, x_1); //각도의 radian value
		
		var vector_x:Number = MathUtil.setVectorX(a, rot);
		var vector_y:Number = MathUtil.setVectorY(a, rot);
		
		trace("vector_x : " + vector_x);
		trace("vector_y : " + vector_y);
		 *    </listing>
		 * @param _a
		 * @param _rot
		 * @return Number
		 * @see #setVectorY()
		 */
		static public function setVectorX(_a:Number, _rot:Number):Number { //FLASH LAB (パワー・クリエイターズ・ガイド) 高木 久之、西田 幸司、梅津 岳城、 佐分 利仁 (2003/3) 124p 참고
			return _a * Math.cos(_rot);
		}
		
		/**
		 * 물체의 가속도(_a)와 각도(_rot - y축에 대해 형성된 각도로서 rot = Math.atan2(y,x)의 radian value)에 따른 가속도 벡터의 y축 성분 출력. 
		 * @example Basic usage:<listing version="3.0">
		var y_1:Number = -3;
		var x_1:Number = -7;
		
		var a:Number = 20;
		var rot:Number = Math.atan2(y_1, x_1); //각도의 radian value
		
		var vector_x:Number = MathUtil.setVectorX(a, rot);
		var vector_y:Number = MathUtil.setVectorY(a, rot);
		
		trace("vector_x : " + vector_x);
		trace("vector_y : " + vector_y);
		 *    </listing>
		 * @param _a
		 * @param _rot
		 * @return Number
		 * @see #setVectorX()
		 */
		static public function setVectorY(_a:Number, _rot:Number):Number { //FLASH LAB (パワー・クリエイターズ・ガイド) 高木 久之、西田 幸司、梅津 岳城、 佐分 利仁 (2003/3) 124p 참고
			return _a * Math.sin(_rot);
		}
		
		/**
		 * 직각 삼각형의 직각을 이루는 두 변의 길이를 이용하여, 나머지 한 변이 밑변과 이루는 각도 출력
		 * @example Basic usage:<listing version="3.0">
		var triangleXside:Number = 100;
		var triangleYside:Number = 100;
		var _angle:Number = MathUtil.getAngleFromTriangleSide(triangleYside, triangleXside);
		trace("_angle :", _angle); //직각을 이루는 두 변의 길이가 100, 100 px인 직각 삼각형의 나머지 한 변과 밑변이 이루는 각도인 45 출력
		 *    </listing>
		 * @param _ySideWidth
		 * @param _xSideWidth
		 * @return Number
		 */
		static public function getAngleFromTriangleSide(_ySideWidth:Number, _xSideWidth:Number):Number {
			return Math.atan2(_ySideWidth, _xSideWidth) * 180 / Math.PI;
		}
		
		/**
		 * radian value 를 호도각 value로 변환
		 * @example Basic usage:<listing version="3.0">
		var _pi:Number = Math.PI;
		trace(MathUtil.radianToDegree(_pi)); //PI의 호도각 value인 180 출력
		 *    </listing>
		 * @param _radian
		 * @return Number
		 * @see #degreeToRadian()
		 */
		static public function radianToDegree(_radian:Number):Number {
			return _radian * 180 / Math.PI;
		}
		
		/**
		 * 호도각 value를 radian value로 변환 출력
		 * @example Basic usage:<listing version="3.0">
		var _rotationValue:Number = 180;
		trace(MathUtil.degreeToRadian(_rotationValue)); //호도각 180도의 radian value인 3.141592653589793 출력
		 *    </listing>
		 * @param _degree
		 * @return Number
		 * @see #radianToDegree()
		 */
		static public function degreeToRadian(_degree:Number):Number {
			return _degree * Math.PI / 180;
		}
		
		/**
		 * 두 point 사이의 거리 반환
		 * @example Basic usage:<listing version="3.0">
		var _point_1:Point = new Point(0, 0);
		var _point_2:Point = new Point(100, 100);
		trace(MathUtil.getDistanceBetweenTwoPoints(_point_1.x, _point_1.y, _point_2.x, _point_2.y));
		 *    </listing>
		 * @param _point1_x
		 * @param _point1_y
		 * @param _point2_x
		 * @param _point2_y
		 * @return Number
		 */
		static public function getDistanceBetweenTwoPoints(_point1_x:Number, _point1_y:Number, _point2_x:Number, _point2_y:Number):Number {
			var distance: Number = Math.sqrt( Math.pow( _point1_x - _point2_x, 2 ) + Math.pow( _point1_y - _point2_y, 2 ) );
			return distance;
		}
		
		/**
		 * 두 point 사이의 거리를 백분율로 환산하여, 특정 percent에 해당하는 위치를 point로 반환
		 * @example Basic usage:<listing version="3.0">
		var _point_1:Point = new Point(0, 20);
		var _point_2:Point = new Point(100, 20);
		trace(MathUtil.getPercentagePointBetweenTwoPoints(_point_1.x, _point_1.y, _point_2.x, _point_2.y, 0.8)); //두 point 사이의 80 percent의 위치인 x=80, y=20 Point 반환
		 *    </listing>
		 * @param _point1_x
		 * @param _point1_y
		 * @param _point2_x
		 * @param _point2_y
		 * @param _percentage
		 * @return Point
		 */
		static public function getPercentagePointBetweenTwoPoints(_point1_x:Number, _point1_y:Number, _point2_x:Number, _point2_y:Number, _percentage:Number):Point { 
			var diffX:Number = _point2_x - _point1_x;
			var diffY:Number = _point2_y - _point1_y;
			return new Point(diffX * _percentage + _point1_x, diffY *_percentage + _point1_y);
		}
		
		/**
		 * 특정 각도를 Flash System의 각도 단위인 -179 ~ 180 으로 변화하여 반환
		 * @example Basic usage:<listing version="3.0">
		trace(MathUtil.getAngleBasedOnSystem(710)); //-10 반환 (710도는 -10도로 변환)
		 *    </listing>
		 * @param _degree
		 * @return Number
		 */
		static public  function getAngleBasedOnSystem(_degree:Number):Number {
			var degree:Number = _degree % 360; 
			if(180 < degree) return degree - 360;
			return degree;
		}
		
		/**
		 * _standardPoint를 기준점으로, _targetPoint를 _degree만큼 회전시켰을 때의 point 위치를 반환
		 * @example Basic usage:<listing version="3.0">
		var _axisPoint:Point = new Point(100, 100);
		var _targetRotatePoint:Point = new Point(200, 100);
		trace(MathUtil.getRotatedPointAroundStandardPoint(_axisPoint, _targetRotatePoint, 90));  
		//_standardPoint(100, 100)을 기준점으로 _targetPoint(200, 100)를 90도 회전시킨 point(100, 200) 반환
		 *    </listing>
		 * @param _standardPoint
		 * @param _targetPoint
		 * @param _degree
		 * @return Point
		 */
		static public function getRotatedPointAroundStandardPoint(_standardPoint:Point, _targetPoint:Point, _degree:Number):Point {
			var tempPosX:Number = _targetPoint.x;
			var x:Number = _standardPoint.x + (_targetPoint.x - _standardPoint.x) * Math.cos(degreeToRadian(_degree)) - (_targetPoint.y - _standardPoint.y) * Math.sin(degreeToRadian(_degree));
			var y:Number = _standardPoint.y + (tempPosX - _standardPoint.x) * Math.sin(degreeToRadian(_degree)) + (_targetPoint.y - _standardPoint.y) * Math.cos(degreeToRadian(_degree));
			return new Point(x, y);
		}
		
		/**
		 * 특정 point(x: _standardPointX, y:_standardPointY)를 기준점으로, _radius value를 반지름으로 가지는 원 내부의 random한 Point를 반환 
		 * @example Basic usage:<listing version="3.0">
		var _axisPoint:Point = new Point(100, 100);
		trace(MathUtil.getRandomSurroundPoint(_axisPoint.x, _axisPoint.y, 100)); //_axisPoint를 기준으로 100의 반지름을 가지는 원 내부의 random한 위치의 Point 반환
		 *    </listing>
		 * @param _standardPointX
		 * @param _standardPointY
		 * @param _radius
		 * @return Point
		 */
		static public function getRandomSurroundPoint(_standardPointX:Number, _standardPointY:Number, _radius:Number):Point {
			var radian:Number = Math.random() * Math.PI * 2;
			var distance:Number = Math.random() * _radius;
			
			var x:Number = _standardPointX + distance * Math.cos(radian);
			var y:Number = _standardPointY + distance * Math.sin(radian);
			return new Point(x, y);
		}
		
		/**
		 * 최소값 int 이상, 최대값 int 이하의 random int value 반환
		 * @example Basic usage:<listing version="3.0">
		trace(MathUtil.getRandomIntMinToMax(10, 15));
		 *    </listing> 
		 * @param _minValue
		 * @param _maxValue
		 * @return int
		 * @see #getRandomNumberMinToMax()
		 */
		static public function getRandomIntMinToMax(_minValue:int, _maxValue:int):int {
			return _minValue + Math.floor( Math.random() * (_maxValue - _minValue + 1));
		}
		
		/**
		 * 최소 Number 이상, 최대 Number 미만의 random Number value 반환
		 * @example Basic usage:<listing version="3.0">
		trace(MathUtil.getRandomNumberMinToMax(10.5, 20.9));
		 *    </listing>  
		 * @param _minValue
		 * @param _maxValue
		 * @return Number
		 * @see #getRandomIntMinToMax()
		 */
		static public function getRandomNumberMinToMax(_minValue:Number, _maxValue:Number):Number {
			return _minValue + Math.random() * (_maxValue - _minValue);
		}
		
		/**
		 * parameter number value의 양수 판별 여부 반환. (0은 양수로 간주합니다.)
		 * @example Basic usage:<listing version="3.0">
		trace(MathUtil.getFlagPositiveNumber(15)); //return true
		 *    </listing>   
		 * @return Boolean
		 */
		static public function getFlagPositiveNumber(_number:Number):Boolean {
			if(_number >= 0) return true;
			return false;
		}
		
		/**
		 * 1 또는 -1 int value을 random하게 반환
		 * @example Basic usage:<listing version="3.0">
		trace(MathUtil.getRandomPositiveNegative()); //return 1 or -1
		 *    </listing>   
		 * @return int
		 */
		static public function getRandomPositiveNegative():int {
			var distinguishInt:int = Math.round(Math.random());
			if(distinguishInt > 0) return 1;
			return -1;
		}
		
		/**
		 * parameter로 전달되는 모든 Number의 합을 반환
		 * @example Basic usage:<listing version="3.0">
		trace(MathUtil.sum(10, 20, 30, 40)); //10, 20, 30, 40의 합인 100 반환
		 *    </listing>
		 * @param args
		 * @return Number
		 */
		public static function sum( ...args ):Number
		{
			var _sum: Number = 0;
			for( var i:int=0; i<args.length; i++){
				_sum += args[ i ];
			}
			return _sum;
		}
		
		/**
		 * parameter로 전달되는 모든 Number의 평균을 반환
		 * @example Basic usage:<listing version="3.0">
		trace(MathUtil.average(10, 20, 30, 40)); //10, 20, 30, 40의 평균인 25 반환
		 *    </listing>
		 * @param args
		 * @return Number
		 */
		public static function average( ...args ):Number
		{
			var _sum: Number = 0;
			for( var i:int=0; i<args.length; i++){
				_sum += args[ i ];
			}
			return _sum / args.length;
		}
		
		/**
		 * Math.Ceil(Number value) 이하의 random Int 반환 (paramter Number value가 0 이하일 경우는 Number value 초과, 0 이하의 random Int 반환) 
		 * @example Basic usage:<listing version="3.0">
		trace(MathUtil.randomCeilInt(10));
		 *    </listing> 
		 * @param _number
		 * @return int
		 */
		public static function randomCeilInt(_number:Number):int
		{
			var tnum: int = Math.ceil( Math.random() * _number ); 
			return tnum
		}
		
		/**
		 * Number value를  Ceil 연산을 적용, 특정 10 단위 or 특정 소수점 단위로 변환하여 반환  
		 * @example Basic usage:<listing version="3.0">
		var testNumber:Number = 12345.12345;
		trace(MathUtil.ceilUnit(testNumber, 0.1)); //소수점 첫째 자리에서 ceil 연산. 12345.2
		trace(MathUtil.ceilUnit(testNumber, 100)); //100 단위에서 ceil 연산. 12400
		 *    </listing>
		 * @param _number
		 * @param _roundToInterval Interval
		 * @return Number
		 */	
		public static function ceilUnit(_number:Number, _roundToInterval:Number=1):Number 
		{
			return Math.ceil(_number / _roundToInterval) * _roundToInterval;
		}
		
		/**
		 * Number value를  round 연산을 적용, 특정 10 단위 or 특정 소수점 단위로 변환하여 반환  
		 * @example Basic usage:<listing version="3.0">
		var testNumber:Number = 12345.12345;
		trace(MathUtil.roundUnit(testNumber, 0.1)); //소수점 첫째 자리에서 round 연산. 12345.3
		trace(MathUtil.roundUnit(testNumber, 100)); //100 단위에서 round 연산. 12300
		 *    </listing>
		 * @param _number
		 * @param _roundToInterval Interval
		 * @return Number
		 */
		public static function roundUnit(_number:Number, _roundToInterval:Number=1):Number 
		{
			return Math.round(_number / _roundToInterval) * _roundToInterval;
		}
		
		/**
		 * Number value를  floor 연산을 적용, 특정 10 단위 or 특정 소수점 단위로 변환하여 반환 
		 * @example Basic usage:<listing version="3.0">
		var testNumber:Number = 12345.12345;
		trace(MathUtil.floorUnit(testNumber, 0.1)); //소수점 첫째 자리에서 floor 연산. 12345.2
		trace(MathUtil.floorUnit(testNumber, 10)); //10 단위에서 floor 연산. 12340
		 *    </listing>
		 * @param _number
		 * @param _roundToInterval Interval
		 * @return Number
		 */		
		public static function floorUnit(_number:Number, _roundToInterval:Number=1):Number 
		{
			return Math.floor(_number / _roundToInterval) * _roundToInterval;
		}
		
		/**
		 * Fast speed abs function. Math.abs Function과 동일한 연산
		 * @example Basic usage:<listing version="3.0">
		trace(MathUtil.abs(-5));
		 *    </listing> 
		 * @param _number
		 * @return Number
		 */		
		public static function abs(_number:Number):Number
		{
			return _number < 0 ? -_number : _number;
		}
		
		/**
		 * 지정된 최소 ~ 최대값 사이의 특정 value를, 다른 최소 ~ 최대값 영역 사이의 value로 치환하여 출력.
		 * @example Basic usage:<listing version="3.0">
		trace(MathUtil.getRemapValue(80, 0, 100, 1000, 1500)); //0 ~ 100 사이의 80은, 1000 ~ 1500 사이의 1400 으로 치환.
		 *    </listing> 
		 * @param _value		in_min ~ in_max 사이의 특정 Number
		 * @param _minValue 	_value의 최소값
		 * @param _maxValue		_value의 최대값
		 * @param _minRemapValue	remap 최소값
		 * @param _maxRemapValue	remap 최대값
		 * @return Number
		 */
		public static function getRemapValue(_value:Number, _minValue:Number, _maxValue:Number, _minRemapValue:Number, _maxRemapValue:Number):Number 
		{
			return (_value - _minValue) * (_maxRemapValue - _minRemapValue) / (_maxValue - _minValue) + _minRemapValue;
		}
		
		/**
		 * int value를 나눌 수 있는 100 미만의 최소 소수 반환(100 미만의 소수로 나눌 수 없을 경우, -1 반환)
		 * @example Basic usage:<listing version="3.0">
		 trace(MathUtil.getDivisibleMinPrimeNumberUnderOneHundred(153)); //153을 나눌 수 있는 최소 소수 3 출력
		 trace(MathUtil.getDivisibleMinPrimeNumberUnderOneHundred(211)); //211을 나눌 수 있는 100 미만의 소수가 존재하지 않으므로, -1 출력
		 *    </listing> 
		 * @param _number uint value
		 * @return int
		 */
		public static function getDivisibleMinPrimeNumberUnderOneHundred(_number:uint):int {
			var returnValue:int = -1;
			var i:uint;
			for(i = 2; i < 100; ++i) {
				if(_number % i == 0) {
					returnValue = i;
					break;
				}
			}
			return returnValue;
		}
		
		/**
		 * int value의 짝수 여부 반환(0은 짝수로 간주)
		 * @example Basic usage:<listing version="3.0">
		 trace(MathUtil.getFlagEvenInt(-2)); // 짝수. true 반환
		 trace(MathUtil.getFlagEvenInt(135)); // 홀수. false 반환
		 *    </listing> 
		 * @param _number	int value
		 * @return Boolean
		 */
		public static function getFlagEvenInt(_number:int):Boolean {
			if(_number%2 == 0) return true;
			return false;
		}
	}
} 
