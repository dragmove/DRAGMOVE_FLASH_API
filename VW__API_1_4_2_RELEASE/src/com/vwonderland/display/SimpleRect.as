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
	import com.vwonderland.support.MathUtil;
	import flash.display.*;

	/**
	 * static draw Rect Utils
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  20.07.2010
	 */
	public class SimpleRect
	{
		/**
		 * rect가 그려진 Shape 반환
		 * @example Basic usage:<listing version="3.0">
		var _squareShape:Shape = SimpleRect.drawRectShape(100, 100, 0xff0000);
		this.addChild(_squareShape);
		 *    </listing>
		 * @param _width
		 * @param _height
		 * @param _color
		 * @param _alpha
		 * @param _border
		 * @param _borderThickness
		 * @param _borderColor
		 * @return Shape
		 */
		static public function drawRectShape(_width:uint=100, _height:uint=100, _color:uint=0x000000, _alpha:Number=1, _border:Boolean=false, _borderThickness:Number=1, _borderColor:Number=0x000000):Shape
		{
			var square_shape:Shape=new Shape();
			square_shape.graphics.beginFill(_color, _alpha);
			if (_border) square_shape.graphics.lineStyle(_borderThickness, _borderColor);
			square_shape.graphics.drawRect(0, 0, _width, _height);
			square_shape.graphics.endFill();
			return square_shape;
		}

		/**
		 * rect가 그려진 Sprite 반환
		 * @example Basic usage:<listing version="3.0">
		var _squareSprite:Sprite = SimpleRect.drawRectSprite(100, 100, 0xff0000);
		this.addChild(_squareSprite);
		 *    </listing>
		 * @param _width
		 * @param _height
		 * @param _color
		 * @param _alpha
		 * @param _border
		 * @param _borderThickness
		 * @param _borderColor
		 * @return Sprite
		 * @see #drawRectSpriteCenterAxis()
		 */
		static public function drawRectSprite(_width:uint=100, _height:uint=100, _color:uint=0x000000, _alpha:Number=1, _border:Boolean=false, _borderThickness:Number=1, _borderColor:Number=0x000000):Sprite
		{
			var square_sprite:Sprite=new Sprite();
			square_sprite.graphics.beginFill(_color, _alpha);
			if (_border) square_sprite.graphics.lineStyle(_borderThickness, _borderColor);
			square_sprite.graphics.drawRect(0, 0, _width, _height);
			square_sprite.graphics.endFill();
			return square_sprite;
		}

		/**
		 * rect의 중앙에 기준점을 지니는, rect가 그려진 Sprite 반환
		 * @example Basic usage:<listing version="3.0">
		var _squareSpriteCenterAxis:Sprite = SimpleRect.drawRectSpriteCenterAxis(100, 100, 0xff0000); //Rect의 중심에 기준점을 가지는 사각형 Sprite 객체 생성
		_squareSpriteCenterAxis.x = 100;
		_squareSpriteCenterAxis.y = 100;
		this.addChild(_squareSpriteCenterAxis);
		 *    </listing>
		 * @param _width
		 * @param _height
		 * @param _color
		 * @param _alpha
		 * @param _border
		 * @param _borderThickness
		 * @param _borderColor
		 * @return Sprite
		 * @see #drawRectSprite()
		 */
		static public function drawRectSpriteCenterAxis(_width:uint=100, _height:uint=100, _color:uint=0x000000, _alpha:Number=1, _border:Boolean=false, _borderThickness:Number=1, _borderColor:Number=0x000000):Sprite
		{
			var square_sprite:Sprite=new Sprite();
			square_sprite.graphics.beginFill(_color, _alpha);
			if (_border) square_sprite.graphics.lineStyle(_borderThickness, _borderColor);
			square_sprite.graphics.drawRect(0, 0, _width, _height);
			square_sprite.graphics.endFill();
			square_sprite.x=-_width / 2;
			square_sprite.y=-_height / 2;

			var containerSprite:Sprite=new Sprite();
			containerSprite.addChild(square_sprite);
			return containerSprite;
		}
		
		/**
		 * 지정된 width, height 내에서 기울어진 사각형(평행사변형)을 만들어 반환합니다(_gapBottomX value에 의해, 기울어진 사각형이 만들어집니다)
		 * @example Basic usage:<listing version="3.0">
		var diagonalSprite:Sprite = SimpleRect.drawDiagonalRectSpriteByGapBottomX(100, 100, 50);
		this.addChild(diagonalSprite);
		 *    </listing>
		 * @param _width
		 * @param _height
		 * @param _gapBottomX
		 * @param _color
		 * @param _alpha
		 * @return Sprite
		 * @throws Error
		 * @see #drawDiagonalRectSpriteByRotation()
		 */
		static public function drawDiagonalRectSpriteByGapBottomX(_width:Number=100, _height:Number=100, _gapBottomX:Number=50, _color:uint=0x000000, _alpha:Number=1):Sprite
		{
			if (Math.abs(_gapBottomX) >= _width) throw new Error("[com.vwonderland.display.SimpleRect.drawDiagonalRectSpriteByGapBottomX] _gapBottomX param is too long");
			var sprite:Sprite=new Sprite();
			sprite.graphics.lineStyle(0, _color, 0, true, LineScaleMode.NONE);
			sprite.graphics.beginFill(_color, _alpha);
			if (_gapBottomX > 0) {
				sprite.graphics.moveTo(0, 0);
				sprite.graphics.lineTo(_width - _gapBottomX, 0);
				sprite.graphics.lineTo(_width, _height);
				sprite.graphics.lineTo(_gapBottomX, _height);
				sprite.graphics.lineTo(0, 0);
			} else {
				sprite.graphics.moveTo(-_gapBottomX, 0);
				sprite.graphics.lineTo(_width, 0);
				sprite.graphics.lineTo(_width + _gapBottomX, _height);
				sprite.graphics.lineTo(0, _height);
				sprite.graphics.lineTo(-_gapBottomX, 0);
			}
			sprite.graphics.endFill();
			return sprite;
		}
		
		/**
		 * 지정된 width, height 내에서 기울어진 사각형(평행사변형)을 만들어 반환합니다(_rotation value에 의해 기울어진 사각형이 만들어집니다)
		 * @example Basic usage:<listing version="3.0">
		var diagonalSprite:Sprite = SimpleRect.drawDiagonalRectSpriteByRotation(100, 100, 10);
		this.addChild(diagonalSprite);
		 *    </listing>
		 * @param _width
		 * @param _height
		 * @param _rotation
		 * @param _color
		 * @param _alpha
		 * @return 
		 * @throws Error
		 * @see #drawDiagonalRectSpriteByGapBottomX()
		 */
		static public function drawDiagonalRectSpriteByRotation(_width:Number=100, _height:Number=100, _rotation:Number=40, _color:uint=0x000000, _alpha:Number=1):Sprite
		{
			if (Math.abs(_rotation) > 45) throw new Error("[com.vwonderland.display.SimpleRect.drawDiagonalRectSpriteByRotation] _rotation param is too Big");
			var gapBottomX:Number=Math.tan(MathUtil.degreeToRadian(_rotation)) * _height;
			var sprite:Sprite=new Sprite();
			sprite.graphics.lineStyle(0, _color, 0, true, LineScaleMode.NONE);
			sprite.graphics.beginFill(_color, _alpha);
			if (gapBottomX > 0) {
				sprite.graphics.moveTo(0, 0);
				sprite.graphics.lineTo(_width - gapBottomX, 0);
				sprite.graphics.lineTo(_width, _height);
				sprite.graphics.lineTo(gapBottomX, _height);
				sprite.graphics.lineTo(0, 0);

			} else {
				sprite.graphics.moveTo(-gapBottomX, 0);
				sprite.graphics.lineTo(_width, 0);
				sprite.graphics.lineTo(_width + gapBottomX, _height);
				sprite.graphics.lineTo(0, _height);
				sprite.graphics.lineTo(-gapBottomX, 0);
			}
			sprite.graphics.endFill();
			return sprite;
		}

	}
}