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
	import com.vwonderland.base.AbstractControllableMovieClip;
	import com.vwonderland.control.SimpleTimer;
	import com.vwonderland.display.DisplayUtil;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * Rect Class (can control vertices, indices, uvData made by Graphics.drawTriangles())
	 * @example Basic usage:<listing version="3.0">
	private var SEGMENT_W:uint = 5;
	private var SEGMENT_H:uint = 5;
	private var _renderTimer:SimpleTimer;
	private var _trianglesRect:TrianglesRect;
	
	public function TestTrianglesRect()
	{
		var _texture:TextureClip = new TextureClip(); //require texture displayObject or Bitmap
		var _textureBmp:Bitmap = DisplayUtil.makeCaptureBitmap(_texture, false, true);
		
		_trianglesRect = new TrianglesRect();
		_trianglesRect.init();
		_trianglesRect.setTrianglesWireFrame(true, 1, 0, 0.1);
		_trianglesRect.makeTrianglesRect(_textureBmp.bitmapData, 100, 100, SEGMENT_W, SEGMENT_H);
		_trianglesRect.render();
		_trianglesRect.x = 300;
		_trianglesRect.y = 300;
		this.addChild(_trianglesRect);
		
		setRenderTimer();
		startRender();
		
		movePolygonRectVerticesPosition();
	}
	
	private function movePolygonRectVerticesPosition():void {
		var _obj:&#42;;
		
		//1. use getVertexPosition, setVertexPosition method
		var _targetVertexPoint:Point;
		for(var i:uint = 0; i &#60;&#61; _trianglesRect.getFinalVertexIndex(); ++i) {
			_obj = new Object();
			_obj.x = _trianglesRect.getVertexPosition(i).x;
			_obj.y = _trianglesRect.getVertexPosition(i).y;
			
			_targetVertexPoint = new Point(_obj.x &#45; 100, _obj.y &#45; 100);
			TweenMax.to( _obj, 1, {delay:i &#42; MathUtil.getRandomNumberMinToMax(0.005, 0.01), x:_targetVertexPoint.x, y:_targetVertexPoint.y, ease:Quint.easeInOut, onUpdate:updateVerticesPosition, onUpdateParams:&#91;i, _obj&#93;} );
		}
		
		/&#42;
		//2. access vertex data directly
		var i:uint, x:uint, y:uint;
		for(x = 0; x &#60;&#61; SEGMENT_W; ++x) {
			for(y = 0; y &#60;&#61; SEGMENT_H; ++y) {
				i = (y &#42; (SEGMENT_W + 1) + x) &#42; 2;
				_obj = new Object();
				_obj.x = _trianglesRect.vertices[i]; //vertex position x
				_obj.y = _trianglesRect.vertices[i + 1]; //vertex position y
				TweenMax.to( _obj, 1, {delay:i &#42; MathUtil.getRandomNumberMinToMax(0.005, 0.01), x:_obj.x-100, y:_obj.y-100, ease:Quint.easeInOut, onUpdate:updateVerticesPositionDirectly, onUpdateParams:&#91;i, _obj&#93;} );
			}
		}
		&#42;/
	}
	
	private function updateVerticesPosition(_verticeIndex:uint, _obj:&#42;):void {
		_trianglesRect.setVertexPosition(_verticeIndex, _obj.x, _obj.y);
	}
	
	/&#42;
	private function updateVerticesPositionDirectly(_verticeIndex:uint, _obj:*):void {
		_trianglesRect.vertices[_verticeIndex] = _obj.x;
		_trianglesRect.vertices[_verticeIndex + 1] = _obj.y;
	}
	&#42;/
	
	private function setRenderTimer():void {
		_renderTimer = new SimpleTimer(20, this, renderInteraction);
	}
	
	private function renderInteraction():void {
		_trianglesRect.render();
	}
	
	private function startRender():void {
		if(_renderTimer != null) _renderTimer.start();
	}
	 *    </listing>
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 10.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  16.08.2011
	 */
	public class TrianglesRect extends AbstractControllableMovieClip
	{
		/**
		 * destroy TrianglesRect. dispose used bitmapData.
		 */
		override public function destroy(_obj:Object = null):void {
			if(_renderTimer != null) {
				_renderTimer.destroy();
				_renderTimer = null;
			}
			if(_renderBitmapData != null) {
				_renderBitmapData.dispose();
				_renderBitmapData = null;
			}
			if (_canvas != null) {
				DisplayUtil.removeDisplayObject(_canvas);
				_canvas=null;
			}
			baseVerticesVector = null;
			verticesVector = null;
			indicesVector = null;
			uvDataVector = null;
			
			destroyDetail(_obj);
		}
		
		/**
		 * get final vertex index in verticesVector
		 * @return uint
		 */
		public function getFinalVertexIndex():uint {
			return Number(verticesVector.length / NUM_COORDINATE) - 1;
		}

		/**
		 * set x, y position of some vertex in verticesVector. first vertex index is 0.
		 * @param _vertexIndex
		 * @param _vertexPosX
		 * @param _vertexPosY
		 */
		public function setVertexPosition(_vertexIndex:uint, _vertexPosX:Number, _vertexPosY:Number):void {
			if (_vertexIndex > Number(verticesVector.length / NUM_COORDINATE) - 1) {
				trace("[com.vwonderland.display.TrianglesRect] _vertexIndex의 index를 가지는 vertex point가 존재하지 않습니다.");
				return;
			}
			verticesVector[_vertexIndex * NUM_COORDINATE] = _vertexPosX;
			verticesVector[_vertexIndex * NUM_COORDINATE + 1] = _vertexPosY;
		}

		/**
		 * get x, y, position of some vertex in verticesVector by vertex index. first vertex index is 0.
		 * @param _vertexIndex
		 * @return Point
		 */
		public function getVertexPosition(_vertexIndex:uint):Point {
			if (_vertexIndex > Number(verticesVector.length / NUM_COORDINATE) - 1) {
				trace("[com.vwonderland.display.TrianglesRect] _vertexIndex의 index를 가지는 vertex point가 존재하지 않습니다.");
				return null;
			}
			var _point:Point = new Point(verticesVector[_vertexIndex * NUM_COORDINATE], verticesVector[_vertexIndex * NUM_COORDINATE + 1]);
			return _point;
		}

		/**
		 * make bitmap texture mapping Triangles that use vertices, indices, uvData information on canvas Sprite
		 * @param _bitmapData	mapping BitmapData
		 * @param _width
		 * @param _height
		 * @param _segmentWNum
		 * @param _segmentHNum
		 * @param _culling		TriangleCulling.NEGATIVE, TriangleCulling.NONE, TriangleCulling.POSITIVE
		 */
		public function makeTrianglesRect(_bitmapData:BitmapData, _width:Number, _height:Number, _segmentWNum:uint=1, _segmentHNum:uint=1, _culling:String="none"):void {
			_renderBitmapData=_bitmapData;

			var verticesVectorLength:uint=(_segmentWNum + 1) * (_segmentHNum + 1) * NUM_COORDINATE;
			baseVerticesVector=new Vector.<Number>(verticesVectorLength, true);
			verticesVector=new Vector.<Number>(verticesVectorLength, true);
			indicesVector=new Vector.<int>(_segmentWNum * _segmentHNum * NUM_POINT_PER_POLYGONRECT, true);
			uvDataVector=new Vector.<Number>(verticesVectorLength, true);

			var rectWidth:Number=_width / _segmentWNum;
			var rectHeight:Number=_height / _segmentHNum;
			var i:uint, x:uint, y:uint;
			for (x=0; x <= _segmentWNum; ++x) {
				for (y=0; y <= _segmentHNum; ++y) {
					i=(y * (_segmentWNum + 1) + x) * NUM_COORDINATE;

					verticesVector[i]=rectWidth * x;
					verticesVector[i + 1]=rectHeight * y;
					baseVerticesVector[i]=verticesVector[i];
					baseVerticesVector[i + 1]=verticesVector[i + 1];
					uvDataVector[i]=verticesVector[i] / _width;
					uvDataVector[i + 1]=verticesVector[i + 1] / _height;
					//trace("verticesVector[" + i + "], [" + (i + 1) + "] :", verticesVector[i], verticesVector[i + 1]);
					//trace("uvDataVector[" + i + "], [" + (i + 1) + "] :", uvDataVector[i], uvDataVector[i + 1]);
				}
			}
			for (x=0; x < _segmentWNum; ++x) {
				i=(x * (NUM_POINT_PER_POLYGONRECT * _segmentHNum));
				for (y=0; y < _segmentHNum; ++y) {
					indicesVector[i + y * NUM_POINT_PER_POLYGONRECT + 0]=(y + 0) * (_segmentWNum + 1) + (x + 0);
					indicesVector[i + y * NUM_POINT_PER_POLYGONRECT + 1]=(y + 0) * (_segmentWNum + 1) + (x + 1);
					indicesVector[i + y * NUM_POINT_PER_POLYGONRECT + 2]=(y + 1) * (_segmentWNum + 1) + (x + 0);
					indicesVector[i + y * NUM_POINT_PER_POLYGONRECT + 3]=(y + 0) * (_segmentWNum + 1) + (x + 1);
					indicesVector[i + y * NUM_POINT_PER_POLYGONRECT + 4]=(y + 1) * (_segmentWNum + 1) + (x + 0);
					indicesVector[i + y * NUM_POINT_PER_POLYGONRECT + 5]=(y + 1) * (_segmentWNum + 1) + (x + 1);
					//trace(indicesVector[i + y * NUM_POINT_PER_POLYGONRECT + 0],
					//	indicesVector[i + y * NUM_POINT_PER_POLYGONRECT + 1],
					//	indicesVector[i + y * NUM_POINT_PER_POLYGONRECT + 2],
					//	indicesVector[i + y * NUM_POINT_PER_POLYGONRECT + 3],
					//	indicesVector[i + y * NUM_POINT_PER_POLYGONRECT + 4],
					//	indicesVector[i + y * NUM_POINT_PER_POLYGONRECT + 5]);
				}
			}
			cullingStr=_culling;
			setRenderTimer(GAP_RENDER_TIMER);
		}

		/**
		 * render canvas Sprite
		 */
		public function render():void {
			if (_canvas != null) {
				_canvas.graphics.clear();
				if (flag_displayTrianglesWireFrame) _canvas.graphics.lineStyle(wireFrameThickness, wireFrameColor, wireFrameAlpha);
				_canvas.graphics.beginBitmapFill(_renderBitmapData, null, false, true);
				_canvas.graphics.drawTriangles(verticesVector, indicesVector, uvDataVector, cullingStr);
				_canvas.graphics.endFill();
			}
			renderDetail();
		}

		/**
		 * start render timer
		 */
		public function startRender():void {
			if (_renderTimer != null) _renderTimer.start();
		}

		/**
		 * stop render timer
		 */
		public function stopRender():void {
			if (_renderTimer != null) _renderTimer.stop();
		}

		/**
		 * get texture mapping bitmapData 
		 * @return BitmapData
		 */
		public function get renderBitmapData():BitmapData {
			if (_renderBitmapData != null) return _renderBitmapData;
			trace("[com.vwonderland.display.TrianglesRect] texture mapping을 위한 BitmapData가 존재하지 않으므로 null을 반환합니다.");
			return null;
		}

		/**
		 * get base vextices Vector
		 * @return Vector.<Number>
		 */
		public function get baseVertices():Vector.<Number> {
			return baseVerticesVector;
		}

		/**
		 * set base vextices Vector
		 * @param _baseVerticesVector
		 */
		public function set baseVertices(_baseVerticesVector:Vector.<Number>):void {
			baseVerticesVector=_baseVerticesVector;
		}

		/**
		 * get vertices Vector to move
		 * @return Vector.<Number>
		 */
		public function get vertices():Vector.<Number> {
			return verticesVector;
		}

		/**
		 * set vertices Vector to move
		 * @param _verticesVector
		 */
		public function set vertices(_verticesVector:Vector.<Number>):void {
			verticesVector=_verticesVector;
		}

		/**
		 * get indices data
		 * @return int
		 */
		public function get indices():Vector.<int> {
			return indicesVector;
		}

		/**
		 * set indices data
		 * @param _indicesVector
		 */
		public function set indices(_indicesVector:Vector.<int>):void {
			indicesVector=_indicesVector;
		}

		/**
		 * get uvData
		 * @return Vector.<Number>
		 */
		public function get uvData():Vector.<Number> {
			return uvDataVector;
		}

		/**
		 * set uvData 
		 * @param _uvDataVector
		 */
		public function set uvData(_uvDataVector:Vector.<Number>):void {
			uvDataVector=_uvDataVector;
		}

		/**
		 * view or hide Triangles wire frame
		 * @param _flag_displayPolygonWireFrame
		 * @param _thickness
		 * @param _color
		 * @param _alpha
		 */
		public function setTrianglesWireFrame(_flag_displayTrianglesWireFrame:Boolean, _thickness:Number=1.0, _color:uint=0, _alpha:Number=1.0):void {
			flag_displayTrianglesWireFrame=_flag_displayTrianglesWireFrame;
			wireFrameThickness=_thickness;
			wireFrameColor=_color;
			wireFrameAlpha=_alpha;
		}

		private const NUM_POINT_PER_POLYGONRECT:uint=6; //2 triangle's vertex number
		private const NUM_COORDINATE:uint=2; //x, y coordinate
		
		private var flag_displayTrianglesWireFrame:Boolean=false;
		private var wireFrameThickness:Number;
		private var wireFrameColor:uint;
		private var wireFrameAlpha:Number;

		/**
		 * triangles canvas
		 */
		protected var _canvas:Sprite;
		
		/**
		 * texture mapping bitmapData
		 */
		protected var _renderBitmapData:BitmapData;

		/**
		 * fixed base vertices Vector
		 */
		protected var baseVerticesVector:Vector.<Number>;
		
		/**
		 * control vertices Vector
		 */
		protected var verticesVector:Vector.<Number>;
		
		/**
		 * indices Vetor
		 */
		protected var indicesVector:Vector.<int>;
		
		/**
		 * uv Vector
		 */
		protected var uvDataVector:Vector.<Number>;
		
		/**
		 * TriangleCulling.NEGATIVE, TriangleCulling.NONE, TriangleCulling.POSITIVE
		 */
		protected var cullingStr:String;
		
		/**
		 * canvas render timer Gap
		 */
		protected var GAP_RENDER_TIMER:Number=100;
		
		/**
		 * canvas render timer
		 */
		protected var _renderTimer:SimpleTimer;

		/**
		 * Constructor
		 */
		public function TrianglesRect()
		{
		}

		override public function init(_obj:Object=null):void
		{
			if (_canvas != null) {
				DisplayUtil.removeDisplayObject(_canvas);
				_canvas=null;
			}
			_canvas=new Sprite();
			this.addChild(_canvas);

			setInstance(_obj);
		}

		/**
		 * (override detail define) instance variables setting
		 * @param _paramObj
		 */
		protected function setInstance(_paramObj:Object):void {
			//override instance setting
		}
		
		/**
		 * (override detail define) TrianglesRect의 기본 설정 내역의 destroy 처리를 제외한, setInstance Function을 통해 임의 정의한 부분의 destroy detail 정의
		 * @param _obj
		 */
		protected function destroyDetail(_obj:Object = null):void {
			//override define detail
		}

		/**
		 * set canvas render timer
		 * @param _delayTime
		 */
		protected function setRenderTimer(_delayTime:Number):void {
			if (_renderTimer != null) {
				_renderTimer.destroy();
				_renderTimer=null;
			}
			_renderTimer=new SimpleTimer(_delayTime, this, renderTimerInteraction);
		}

		/**
		 * render timer handler
		 */
		protected function renderTimerInteraction():void {
			render();
		}
		
		/**
		 * (override detail define) render public method 실행시, 함께 실행될 render detail 내역 정의
		 */
		protected function renderDetail():void {
			//override define detail
		}
	}
}