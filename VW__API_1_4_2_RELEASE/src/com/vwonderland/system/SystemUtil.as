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

package com.vwonderland.system {
	import flash.system.Capabilities;
	
	/**
	 * static System Utils
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  15.07.2010
	 */	
	public class SystemUtil {
		/**
		 * File의 확장자를 반환합니다.
		 * @example Basic usage:<listing version="3.0">
		trace("SystemUtil.getFileExtension(_fileURLStr) :", SystemUtil.getFileExtension("../flash/exampleFile.swf&#63;temp=123456789&#38;tempFlag=false")); //확장자 swf 반환
		trace("SystemUtil.getFileExtension(_fileURLStr) :", SystemUtil.getFileExtension("exampleImage.png")); //확장자 png 반환
		 *    </listing>
		 * @param _fileURLStr
		 * @return String
		 */
		static public function getFileExtension(_fileURLStr:String):String {
			var searchStr:String = _fileURLStr.indexOf("?") > -1 ? _fileURLStr.substring(0, _fileURLStr.indexOf("?")) : _fileURLStr;
			var finalPartStr:String = searchStr.substring(searchStr.lastIndexOf("/"));;
			var fileExtensionStr:String = finalPartStr.substring(finalPartStr.lastIndexOf(".") + 1).toLowerCase();
			return fileExtensionStr;
		}
		
		/**
		 * 초 단위의 시간을 시간,분,초 정보로 변환하여 순서대로 Array에 담아 반환합니다. 
		 * @example Basic usage:<listing version="3.0">
		trace(SystemUtil.secondUnitToHourUnit(3700)); // 3700초를 변환하여 담은 배열의 원소인 1,1,40 반환 (1시간 1분 40초) 
     	 *    </listing>
		 * @param _second
		 * @return Array
		 */
		static public function secondUnitToHourUnit(_second:Number):Array {
			var _hour:Number = 0;
			var _min:Number = 0;
			var _sec:Number = 0;
			var _timeInfo:Number = _second;
			_hour = Math.floor(_timeInfo / DateData.HOUR_TO_SEC);
			_timeInfo -= _hour * DateData.HOUR_TO_SEC;
			_min = Math.floor(_timeInfo / DateData.MIN_TO_SEC);
			_timeInfo -= _min * DateData.MIN_TO_SEC;
			_sec = Math.floor(_timeInfo);
			return new Array(_hour, _min, _sec);
		}
		
		/**
		 * base Date로부터 target Date까지의 날짜 및 시간의 차이를 DAY, HOUR, MINUTE, SECOND 정보 순서대로 Array에 담아 반환합니다.
		 * @example Basic usage:<listing version="3.0">
		trace(SystemUtil.getDifferenceBetweenDate(2009, 12, 25, 12, 0, 0, 2010, 12, 25, 12, 30, 30)); //2009.12.25 12시 0분 0초와 2010.12.25 12시 30분 30초와의 차이값인 365,0,30,30 반환 (365일 0시간 30분 30초)
     	 *    </listing>
		 * @param _baseYear 	현재 연도 		- 4자리 연도
		 * @param _baseYear 	현재 월		- 1 ~ 12
		 * @param _baseDay 		현재 일		- 1 ~ 31
		 * @param _baseHour 	현재 시간		- 0 ~ 23
		 * @param _baseMin 		현재 분		- 0 ~ 59
		 * @param _baseSec 		현재 초		- 0 ~ 59
		 * @param _targetYear	target 연도	- 4자리 연도
		 * @param _targetMonth	target 월	- 1 ~ 12
		 * @param _targetDay	target 일	- 1 ~ 31
		 * @param _targetHour	target 시간	- 0 ~ 23
		 * @param _targetMin	target 분	- 0 ~ 59
		 * @param _targetSec	target 초	- 0 ~ 59
		 * @return Array
		 */
		static public function getDifferenceBetweenDate(_baseYear:int, _baseMonth:int, _baseDay:int, _baseHour:int, _baseMin:int, _baseSec:int, 
													  _targetYear:int, _targetMonth:int, _targetDay:int, _targetHour:int, _targetMin:int, _targetSec:int):Array {
			var dateObj:Date = new Date(_baseYear, _baseMonth - 1, _baseDay, _baseHour, _baseMin, _baseSec);
			var _day:Number;
			var _hour:Number;
			var _min:Number;
			var _sec:Number;
			
			var targetUTC:Number = Date.UTC(_targetYear, _targetMonth - 1, _targetDay, _targetHour, _targetMin, _targetSec);
			var nowUTC:Number = Date.UTC(
				dateObj.getFullYear(),
				dateObj.getMonth(),
				dateObj.getDate(),
				dateObj.getHours(),
				dateObj.getMinutes(),
				dateObj.getSeconds()
			);
			
			var gapUTC:Number = targetUTC - nowUTC;
			_day = Math.floor(gapUTC / DateData.DAY_TO_SEC / 1000);
			gapUTC -= _day * DateData.DAY_TO_SEC * 1000;
			
			_hour = Math.floor(gapUTC / DateData.HOUR_TO_SEC / 1000);
			gapUTC -= _hour * DateData.HOUR_TO_SEC * 1000;
			
			_min = Math.floor(gapUTC / DateData.MIN_TO_SEC / 1000);
			gapUTC -= _min * DateData.MIN_TO_SEC * 1000;
			
			_sec = Math.floor(gapUTC / 1000);
			return new Array(_day, _hour, _min, _sec);
		}
		
		/**
		 * Flash player version Check
		 * @example Basic usage:<listing version="3.0">
		SystemUtil.getFlashPlayerVersion();
     	 *    </listing>
		 * @return String
		 */
		static public function getFlashPlayerVersion():String {
			var majorVersion:String = "-1";
			var versionString:String = Capabilities.version; 
			var pattern:RegExp = /^(\w*) (\d*),(\d*),(\d*),(\d*)$/; 
			var result:Object = pattern.exec(versionString); 
			if (result != null) { 
				majorVersion = result[2];
				trace("[com.vwonderland.system.SystemUtil.getFlashPlayerVersion]");
				trace("input: " + result.input); 
				trace("platform: " + result[1]); 
				trace("majorVersion: " + result[2]); 
				trace("minorVersion: " + result[3]);     
				trace("buildNumber: " + result[4]); 
				trace("internalBuildNumber: " + result[5]); 
			} else { 
				trace("[com.vwonderland.system.SystemUtil.getFlashPlayerVersion] Unable to match RegExp."); 
			}
			return majorVersion;
		}
		
		/**
		 * Flash 파일이 실행되는 환경이 Local system인지의 여부 반환
		 * @example Basic usage:<listing version="3.0">
		SystemUtil.getFlagLocalSystem();
		 *    </listing>
		 * @return Boolean
		 */
		static public function getFlagLocalSystem():Boolean {
			if(Capabilities.playerType == "StandAlone" || Capabilities.playerType == "External") {
				return true;
			}
			return false;
		}
	}
} 
