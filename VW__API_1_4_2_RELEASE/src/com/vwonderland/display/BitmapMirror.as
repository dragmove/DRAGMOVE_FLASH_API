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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	/**
	 * DisplayObject를 복사하여, 반사된 효과의 Bitmap을 생성합니다.
	 * @example Basic usage:
	 * 해당 예제는 빨간색 사각형을 source로, 반사된 효과의 Bitmap을 생성합니다.
	 * <listing version="3.0">
	var bg:Shape = new Shape();
	bg.graphics.beginFill(0x333333);
	bg.graphics.drawRect(0, 0, 600, 300);
	bg.graphics.endFill();
	this.addChild(bg);
	
	var pictureBitmapData:BitmapData = new BitmapData(200, 200, false, 0xff0000);
	var pictureBitmap:Bitmap = new Bitmap(pictureBitmapData);
	this.addChild(pictureBitmap);
	
	var pictureMirror:BitmapMirror = new BitmapMirror(pictureBitmap, 1, 1, 90);
	pictureMirror.x = pictureBitmap.width + 1;
	this.addChild(pictureMirror);
	 * </listing>
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  23.05.2011
	 */
	public class BitmapMirror extends Bitmap
	{
		private var _captureBitmapData:BitmapData;
		
		/**
		 * Constructor(_sourceDisplayObject를 캡쳐하여 gradiant mask를 씌운 Bitmap을 생성합니다)
		 * @param _sourceDisplayObject source DisplayObject
		 * @param _reflect 반사값
		 * @param _reflectRatio 반사 비율
		 * @param _angle 반사 효과 각도
		 */
		public function BitmapMirror(_sourceDisplayObject:DisplayObject, _reflect:Number=0.2, _reflectRatio:Number=0.8, _angle:Number=90)
		{
			var sourceWidth:uint = _sourceDisplayObject.width;
			var sourceHeight:uint = _sourceDisplayObject.height;
			var colors:Array = [0x000000, 0x000000];
			var alphas:Array = [_reflect, 0];
			var reflectRatios:Array = [0, _reflectRatio * 255];
			var angle:Number = (_angle / 180) * Math.PI;
			
			//create originalBitmapData
			var originalBitmapData:BitmapData = new BitmapData(sourceWidth, sourceHeight, true, 0xffffff);
			var transformMatrix:Matrix = new Matrix();
			transformMatrix.scale(_sourceDisplayObject.scaleX, _sourceDisplayObject.scaleY);
			originalBitmapData.draw(_sourceDisplayObject, transformMatrix);
			
			//mirror bitmap
			var reflectBitmap:Bitmap = new Bitmap(); 
			reflectBitmap.bitmapData = originalBitmapData;
			reflectBitmap.scaleY = -1;
			reflectBitmap.y = reflectBitmap.height;
			
			//gradient matrix
			var gradientMatrix:Matrix = new Matrix(); 
			gradientMatrix.createGradientBox(sourceWidth, sourceHeight, angle, 0, 0);
			
			//gradient mask
			var reflectMask:Shape = new Shape(); 
			reflectMask.graphics.lineStyle();
			reflectMask.graphics.beginBitmapFill(reflectBitmap.bitmapData);
			reflectMask.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, reflectRatios, gradientMatrix);
			reflectMask.graphics.drawRect(0, 0, sourceWidth, sourceHeight);
			reflectMask.graphics.endFill();
			reflectMask.cacheAsBitmap = true; //true 설정시, alpha, matrix 적용 후 mask 가능
			
			reflectBitmap.cacheAsBitmap = true;
			reflectBitmap.mask = reflectMask;
			
			var captureSprite:Sprite = new Sprite();
			captureSprite.addChild(reflectBitmap);
			captureSprite.addChild(reflectMask);
			
			_captureBitmapData = new BitmapData(sourceWidth, sourceHeight, true, 0x000000);
			_captureBitmapData.draw(captureSprite);
			this.bitmapData = _captureBitmapData;
			
			if(originalBitmapData != null) {
				originalBitmapData.dispose();
				originalBitmapData = null;
			}
			if(reflectBitmap != null) {
				reflectBitmap.bitmapData.dispose();
				reflectBitmap.bitmapData = null;
				reflectBitmap = null;
			}
			if(captureSprite != null) {
				DisplayUtil.removeAllChildren(captureSprite);
				captureSprite = null;
			}
		}
		
		/**
		 * destroy(BitmapMirror BitmapData dispose)
		 */
		public function destroy(_obj:Object = null):void{
			if(this.bitmapData != null) {
				this.bitmapData.dispose();
				this.bitmapData = null;
			}
			if(_captureBitmapData !=null) {
				_captureBitmapData.dispose();
				_captureBitmapData = null;
			}
		}
	}
}