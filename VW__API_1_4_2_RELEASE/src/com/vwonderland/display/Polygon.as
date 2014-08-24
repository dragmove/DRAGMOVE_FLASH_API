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

package com.vwonderland.display
{
	import flash.display.Shape;
	import flash.geom.Point;
		
	/**
	 * 중점을 기준으로, 면이 있는 2D 다각형을 그립니다.
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  23.05.2011
	 */
	public class Polygon extends Shape
	{
		/**
		 * Polygon instance의 속성 변경시, update를 호출하는 시점에 변경된 속성이 반영됩니다.
		 * @example Basic usage:
		 * <listing version="3.0">
		var polygon = new Polygon(20, 40, 0, 180, 5, 0xff0000); // 내부 반지름 20, 외부 반지름 40, 0도에서 시작되는, 180도에서 끝나는, 5각형의, 빨간 색 다각형을 그립니다.
		polygon.color = 0xffff00; // 노란 색을 지정했지만 반영되지 않습니다.
		polygon.update(); // 지정된 노란 색이 반영됩니다.
		
		polygon.angleFrom = 90; // 90도를 지정했지만 반영되지 않습니다.
		polygon.update(); // 반이 잘린 다각형이 반영됩니다.
		 * </listing>
		 */
		public function update():void {
			var twoPI:Number = 2 * Math.PI;
			var angleStep:Number = _polygonAngleTo / _polygonSegment;
			var angle:Number;
			var i:uint;
			var endAngle:Number;
			var xx:Number = Math.cos(_polygonAngleFrom * twoPI) * _polygonInnerRadius;
			var yy:Number = Math.sin(_polygonAngleFrom * twoPI) * _polygonInnerRadius;
			var startPoint:Point = new Point(xx, yy);
			
			graphics.clear();
			graphics.beginFill(_polygonColor, 50);
			graphics.moveTo(xx, yy);
			
			for(i=1; i<=_polygonSegment; i++){
				angle = (_polygonAngleFrom + i * angleStep) * twoPI;
				xx = Math.cos(angle) * _polygonInnerRadius;
				yy = Math.sin(angle) * _polygonInnerRadius;
				graphics.lineTo(xx, yy);
			}
			
			endAngle = _polygonAngleFrom + _polygonAngleTo;
			for(i=0; i<=_polygonSegment; i++){
				angle = (endAngle - i * angleStep) * twoPI;
				xx = Math.cos(angle) * outerRadius;
				yy = Math.sin(angle) * outerRadius;
				graphics.lineTo(xx, yy);
			}
			graphics.lineTo(startPoint.x, startPoint.y);
		}
		
		/**
		 * 다각형의 시작되는 각도 반환
		 * @return Number
		 */
		public function get angleFrom():Number{ 
			return _polygonAngleFrom * 360 - GAP_CHANGE_ANGLE;
		}
		
		/**
		 * 다각형의 시작되는 각도 지정
		 * @param _angleFrom
		 */
		public function set angleFrom(_angleFrom:Number):void{ 
			_polygonAngleFrom = _angleFrom/360 + GAP_CHANGE_ANGLE/360; //- 0.25;
		}
		
		/**
		 * 다각형의 끝나는 각도 반환
		 * @return Number
		 */
		public function get angleTo():Number{ 
			return _polygonAngleTo * 360;
		}
		
		/**
		 * 다각형의 끝나는 각도 지정
		 * @param _angleTo
		 */
		public function set angleTo(_angleTo:Number):void{ 
			_polygonAngleTo = _angleTo/360; 
		}
		
		/**
		 * 다각형의 색상 반환
		 * @return Number
		 */
		public function get color():Number { 
			return _polygonColor;
		}
		
		/**
		 * 다각형의 색상 지정
		 * @param _color
		 */
		public function set color(_color:Number):void{ 
			_polygonColor = _color; 
		}
		
		/**
		 * 다각형의 내부 반지름 반환
		 * @return Number
		 */
		public function get innerRadius():Number{ 
			return _polygonInnerRadius; 
		}
		
		/**
		 * 다각형의 외부 반지름 반환
		 * @return Number
		 */
		public function get outerRadius():Number{ 
			return _polygonOuterRadius; 
		}
		
		/**
		 * 다각형의 면의 갯수 반환
		 * @return uint
		 */
		public function get segment():uint { 
			return _polygonSegment; 
		}
		
		private const GAP_CHANGE_ANGLE:int = -90;
		private var _polygonInnerRadius:Number;
		private var _polygonOuterRadius:Number;
		private var _polygonAngleFrom:Number;
		private var _polygonAngleTo:Number;
		private var _polygonSegment:uint;
		private var _polygonColor:uint;
		
		/**
		 * <p>Flash의 기본 좌표계에서 -90도만큼 회전시킨 좌표계에 입각하여, 중앙점을 기준으로 다각형을 그립니다.</p>
		 * <p>angleFrom를 60, angleTo을 360으로 지정시 60도에서 시작해 360도에서 끝나는 다각형이 그려집니다.</p>
		 * <p>segment는 Polygon이 그려질때 그 분할면을 지정하게 됩니다.
		 * 예를 들어 angleFrom=0, angleTo=360으로 지정하고,
		 * segment를 4로 지정시 4개의 분할면을 갖게 되는 다각형(사각형)을 그리게 됩니다.
		 * segment를 5로 지정시 5개의 분할면을 갖게 되는 다각형(오각형)을 그리게 됩니다.</p>
		 * @example Basic usage:
		 * <listing version="3.0">
		var polygon1:Polygon = new Polygon(20, 60, 0, 180, 2, 0xff0000); // 내부 반지름 20, 외부 반지름 60, 0도에서 시작되는, 180도에서 끝나는, 2각형, 빨간색 // 화살표(삼각형) 형태의 다각형
		var polygon2:Polygon = new Polygon(40, 60, 0, 270, 30, 0xff0000); // 내부 반지름 40, 외부 반지름 60, 0도에서 시작되는, 270도에서 끝나는, 30각형, 빨간색 // 원 형태의 다각형
		var polygon3:Polygon = new Polygon(40, 60, 0, 360, 4, 0xff0000); // 내부 반지름 20, 외부 반지름 60, 0도에서 시작되는, 360도에서 끝나는, 4각형, 빨간색 // 사각형 형태의 다각형
		polygon1.x = 100;
		polygon1.y = 100;
		polygon2.x = 300;
		polygon2.y = 100;
		polygon3.x = 500;
		polygon3.y = 100;
		this.addChild(polygon1);
		this.addChild(polygon2);
		this.addChild(polygon3);
		 * </listing>
		 * @param _innerRadius 내부 반지름
		 * @param _outerRadius 외부 반지름
		 * @param _angleFrom 다각형이 그려지는 시작 각도
		 * @param _angleTo 다각형이 그려지는 마지막 각도
		 * @param _segment 분할 면 수
		 * @param _color 색상
		 */
		public function Polygon(_innerRadius:Number=20, _outerRadius:Number=60, _angleFrom:Number=0, _angleTo:Number=0, _segment:uint=20, _color:uint=0xff0000){
			_polygonInnerRadius = _innerRadius;
			_polygonOuterRadius = _outerRadius;
			_polygonAngleFrom = _angleFrom/360 + GAP_CHANGE_ANGLE/360; //- 0.25; // degree = 0
			_polygonAngleTo = _angleTo/360;
			_polygonSegment = _segment;
			_polygonColor = _color;
			
			update();
		}
	}
}