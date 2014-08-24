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

package com.vwonderland.display {
	import flash.display.*;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	
	/**
	 * static Display Utils
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  15.07.2010
	 */	
	public class DisplayUtil {
		
		/**
		 * DisplayObject 객체의 parent.removeChild 수행
		 * @example Basic usage:<listing version="3.0"> 
		var _rect:Sprite = SimpleRect.drawRectSprite();
		this.addChild(_rect);
		DisplayUtil.removeDisplayObject(_rect);
		 *    </listing> 
		 * @param _displayObject
		 */
		static public function removeDisplayObject(_displayObject:DisplayObject):void {
			if(_displayObject is DisplayObject) {
				if(_displayObject.parent != null) {
					_displayObject.parent.removeChild(_displayObject);
				}else{
					trace("[com.vwonderland.display.DisplayUtil] removeDisplayObject Function을 수행할 수 없습니다. DisplayObject instance의 parent instance가 존재하지 않습니다.");
				}
			}
		}
		
		/**
		 * DisplayObjectContinaer 객체 내부의 모든 display 객체의 removeChild 수행
		 * @example Basic usage:<listing version="3.0"> 
		var _parentRect:Sprite = SimpleRect.drawRectSprite();
		this.addChild(_parentRect);
		
		var _childRect:Sprite = SimpleRect.drawRectSprite(100, 100, 0xff0000);
		_childRect.x = 50;
		_childRect.y = 50;
		_parentRect.addChild(_childRect);
		
		var _childCircle:Sprite = SimpleCircle.drawCircleSprite(50, 0x00ff00);
		_childCircle.x = 150;
		_childCircle.y = 150;
		_parentRect.addChild(_childCircle);
		
		DisplayUtil.removeAllChildren(_parentRect);
		 *    </listing> 
		 * @param _displayObjectContainer
		 */
		static public function removeAllChildren(_displayObjectContainer:DisplayObjectContainer):void {
			var count:int = _displayObjectContainer.numChildren;
			for(var i:uint = 0; i < count; ++i) {
				_displayObjectContainer.removeChildAt(0);
			}
		}
		
		/**
		 * DisplayObject 객체를 capture하여 Bitmap을 반환
		 * @example Basic usage:<listing version="3.0">
		var _tf:TextField = new TextField();
		_tf.text = "v-wonderland";
		
		var _tfCaptureBmp:Bitmap = DisplayUtil.makeCaptureBitmap(_tf, true, true);
		this.addChild(_tfCaptureBmp);
		 *    </listing> 
		 * @param _displayObject
		 * @param _transparent
		 * @param _smoothing
		 * @return Bitmap
		 * @see flash.Display.Bitmap
		 */
		
		static public function makeCaptureBitmap(_displayObject:DisplayObject, _transparent:Boolean, _smoothing:Boolean = true):Bitmap {
			var _returnBitmap:Bitmap;
			var _bitmapData:BitmapData;
			var color:uint = 0xFFFFFFFF;
			if(_transparent) color = 0;
			_bitmapData = new BitmapData(_displayObject.width, _displayObject.height, _transparent, color);
			_bitmapData.draw(_displayObject);
			_returnBitmap = new Bitmap(_bitmapData, PixelSnapping.AUTO, true);
			return _returnBitmap;
		}
		
		/**
		 * 특정 Area의 width, height에 맞춰 size 변경된 image(or Rectangle, MovieClip, Sprite)의 width, height 값을 가지는 Rectangle 반환.
		 * @example Basic usage:<listing version="3.0">
		var _bmp:Bitmap = new Bitmap(new _linkageBitmapName(0, 0));
		this.addChild(_bmp);
			
		var rect:Rectangle = DisplayUtil.getFitRectSize(_bmp.width, _bmp.height, 100, 100); //_bmp 객체의 width, height 비율을 유지하면서 100, 100 size의 Area 내에 포함되는 크기의 Rectangle 반환.
		bmp.width = rect.width;
		bmp.height = rect.height;
		 *    </listing> 
		 * @param _originalWidth original width
		 * @param _originalHeight original height
		 * @param _areaWidth area width
		 * @param _areaHeight area height
		 * @param _flag_fillArea fill the area
		 * @return Rectangle
		 */		
		public static function getFitRectSize(_originalWidth:Number, _originalHeight:Number, _areaWidth:int, _areaHeight:int, _flag_fillArea:Boolean=false):Rectangle {
			var sH:int;
			var sW:int;
			var sPer:Number = _areaWidth / _areaHeight;
			var imgPer:Number = _originalWidth / _originalHeight;
			var imgX:int = 0;
			var imgY:int = 0;
			
			if (_flag_fillArea) {
				if (imgPer > sPer) {
					sW = Math.round(_originalWidth * (_areaHeight / _originalHeight));
					sH = _areaHeight;
					imgX = Math.round((_areaWidth - sW) >> 1);
					imgY = 0;
				} else {
					sW = _areaWidth;
					sH = Math.round(_originalHeight * (_areaWidth / _originalWidth));			
					imgX = 0;
					imgY = Math.round((_areaHeight - sH) >> 1);
				}
			} else {
				if (imgPer < sPer) {
					sW = Math.round(_originalWidth * (_areaHeight / _originalHeight));
					sH = _areaHeight;
					imgX = Math.round((_areaWidth - sW) >> 1);
					imgY = 0;
				} else {
					sW = _areaWidth;
					sH = Math.round(_originalHeight * (_areaWidth / _originalWidth));			
					imgX = 0;
					imgY = Math.round((_areaHeight - sH) >> 1);
				}
			}
			return new Rectangle(imgX, imgY, sW, sH);
		}
	}
} 
