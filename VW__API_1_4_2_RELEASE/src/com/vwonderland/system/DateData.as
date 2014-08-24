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

package com.vwonderland.system
{
	/**
	 * Date Data
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  21.07.2010
	 */	
	public class DateData 
	{		
		/**
		 * English days - ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
		 */		
		public static const DAYS:Array = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
		
		/**
		 * English abbreviated days - ["Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"];
		 */		
		public static const DAYS_ABBREVIATED:Array = ["Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"];
		
		/**
		 * Korean days - ["일", "월", "화", "수", "목", "금", "토"];
		 */		
		public static const DAYS_KOR:Array = ["일", "월", "화", "수", "목", "금", "토"];
		
  		/**
  		 * English months - ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
  		 */		
  		public static const MONTHS:Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
  		
		/**
		 * English abbreviated months - ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
		 */  		
		public static const MONTHS_ABBREVIATED:Array = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
		
  		/**
  		 * Days in month - [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  		 */	
  		public static const DAYSINMONTH:Array = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
		
		/**
		 * 1 Minute to Sec unit - 60 Sec
		 */
		public static const MIN_TO_SEC:int = 60;
		
		/**
		 * 1 Hour to Sec unit - 360 Sec
		 */
		public static const HOUR_TO_SEC:int = 60 * 60;
		
		/**
		 * 1 Day to Sec unit - 8640 Sec
		 */
		public static const DAY_TO_SEC:int = HOUR_TO_SEC * 24;
	}
}