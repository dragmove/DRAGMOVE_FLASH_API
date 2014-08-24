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
	 * pattern 을 그려내는 Shape의 Abstract Class
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  23.05.2011
	 */
	public class AbstractPattern extends Shape
	{
		/**
		 * pattern의 기본 형태를 그리는 Shape
		 */
		public var pattern:Shape;
		
		/**
		 * pattern의 기본형태를 반복적으로 그리는 BitmapData
		 */
		public var convertPattern:BitmapData;
		
		/**
		 * AbstractPattern을 상속받아 사용하는 pattern과 convertPattern의 제거
		 */
		public function destroy(_obj:Object = null):void{
			if(pattern != null) pattern = null;
			if(convertPattern != null){
				convertPattern.dispose();
				convertPattern = null;
			}
		}
		
		/**
		 * Constructor
		 */
		public function AbstractPattern()
		{
		}
	}
}