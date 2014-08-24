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
	import flash.display.*;

	/**
	 * static draw Circle Utils
	 * @example Basic usage:<listing version="3.0">
	var _circle:Sprite = SimpleCircle.drawCircleSprite(100, 0xff0000); //원형의 Sprite 객체 생성
	_circle.x = _circle.y = 100;
	this.addChild(_circle);
	 
	var _gradientCircle:Sprite = SimpleCircle.drawRadialGradientCircleSprite(100, [0xff0000, 0x00ff00], [1,0], [0,255], 0.5); //원형의 Radial Gradient Sprite 객체 생성
	_gradientCircle.x = _gradientCircle.y = 300;
	this.addChild(_gradientCircle);
	 *    </listing>
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  14.04.2011
	 */
	public class SimpleCircle
	{
		/**
		 * circle이 그려진 Sprite instance 반환
		 * @example Basic usage:<listing version="3.0">
		var _circle:Sprite = SimpleCircle.drawCircleSprite(100, 0xff0000);
		_circle.x = _circle.y = 100;
		this.addChild(_circle);
		 *    </listing>
		 * @param _radius
		 * @param _color
		 * @param _alpha
		 * @param _border
		 * @param _borderThickness
		 * @param _borderColor
		 * @param _borderAlpha
		 * @param _borderPixelHinting
		 * @return Sprite
		 * @see #drawRadialGradientCircleSprite()
		 */
		static public function drawCircleSprite(_radius:uint=100, _color:uint=0x000000, _alpha:Number=1, _border:Boolean=false, _borderThickness:Number=1, _borderColor:Number=0x000000, _borderAlpha:Number=1, _borderPixelHinting:Boolean=false):Sprite
		{
			var _circleSprite:Sprite=new Sprite();
			_circleSprite.graphics.beginFill(_color, _alpha);
			if (_border) _circleSprite.graphics.lineStyle(_borderThickness, _borderColor, _borderAlpha, _borderPixelHinting);
			_circleSprite.graphics.drawCircle(0, 0, _radius);
			_circleSprite.graphics.endFill();
			return _circleSprite;
		}
		
		/**
		 * Radial Gradient Circle이 그려진 Sprite instance 반환
		 * @example Basic usage:<listing version="3.0">
		var _gradientCircle:Sprite = SimpleCircle.drawRadialGradientCircleSprite(100, [0xff0000, 0x00ff00], [1,0], [0,255], 0.5);
		_gradientCircle.x = _gradientCircle.y = 100;
		this.addChild(_gradientCircle);
		 *    </listing>
		 * @param _radius
		 * @param _colorsArr
		 * @param _alphasArr
		 * @param _ratiosArr
		 * @param _focalPointRatio
		 * @param _border
		 * @param _borderThickness
		 * @param _borderColor
		 * @param _borderAlpha
		 * @param _borderPixelHinting
		 * @return Sprite
		 * @see #drawCircleSprite()
		 */
		static public function drawRadialGradientCircleSprite(_radius:uint, _colorsArr:Array, _alphasArr:Array, _ratiosArr:Array, _focalPointRatio:Number=0, _border:Boolean=false, _borderThickness:Number=1, _borderColor:Number=0x000000, _borderAlpha:Number=1, _borderPixelHinting:Boolean=false):Sprite
		{
			var _circleSprite:Sprite=new Sprite();
			_circleSprite.graphics.beginGradientFill(GradientType.RADIAL, _colorsArr, _alphasArr, _ratiosArr, null, SpreadMethod.PAD, InterpolationMethod.RGB, _focalPointRatio);
			if (_border) _circleSprite.graphics.lineStyle(_borderThickness, _borderColor, _borderAlpha, _borderPixelHinting);
			_circleSprite.graphics.drawCircle(0, 0, _radius);
			_circleSprite.graphics.endFill();
			return _circleSprite;
		}
	}
}