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

package com.vwonderland.display.pattern
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	
	/**
	 * Grid 무늬의 Shape 생성
	 * @example Basic usage:<listing version="3.0">
	var pattern:Grid = new Grid(500, 400, 0xff0000, 1, 10); // Grid 무늬의 패턴 Shape 객체 생성
	this.addChild(pattern);
	 * </listing>
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  23.05.2011
	 */
	public class Grid extends AbstractPattern
	{
		/**
		 * Grid 무늬의 Shape 생성
		 * @param _width
		 * @param _height
		 * @param _color
		 * @param _alpha
		 * @param _dotSize
		 */
		public function Grid(_width:Number, _height:Number, _color:Number=0x000000, _alpha:Number=1, _dotSize:uint=10)
		{
			var gridLineSize:int = 1;
			pattern = new Shape();
			convertPattern = new BitmapData(_dotSize, _dotSize, true, _color);
			
			convertPattern.lock();
			with(pattern.graphics){
				beginFill(_color, _alpha);
				drawRect(_dotSize-gridLineSize, 0, gridLineSize, _dotSize);
				drawRect(0, _dotSize-gridLineSize, _dotSize-gridLineSize, gridLineSize);
				endFill();
			}
			convertPattern.draw(pattern);
			
			graphics.beginBitmapFill(convertPattern, null, true);
			graphics.drawRect(0, 0, _width, _height);
			graphics.endFill();
			convertPattern.unlock();
		}
	}
}