/**
 * Licensed under the MIT License
 *
 * Copyright (c) 2010 VW
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 
 */

package com.vwonderland.support {
	import com.vwonderland.system.LanguageData;
	
	/**
	 * static String Utils
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  14.07.2010
	 */	
	public class StringUtil
	{
		/**
		 * 문장 내에 기본 영문자와 숫자, 기본 심볼 문자만이 존재하는지의 여부를 반환
		 * @example Basic usage:<listing version="3.0">
		var _englishStr:String = "v-wonderland extension";
		trace("StringUtil.getFlagEnglishStr(_englishStr) :", StringUtil.getFlagEnglishStr(_englishStr)); //true
			
		var _koreanStr:String = "브이더블유 익스텐션 v-wonderland extension";
		trace("StringUtil.getFlagEnglishStr(_koreanStr) :", StringUtil.getFlagEnglishStr(_koreanStr)); //false
		 *    </listing>
		 * @param _str
		 * @return Boolean
		 */
		
		public static function getFlagEnglishStr(_str:String):Boolean {
			var flag:Boolean = true;
			var splitArr:Array = _str.split("");
			var strArr:Array = new Array();
			
			var _str:String;
			var unicode:int;
			for(var i:uint = 0; i < splitArr.length; ++i) {
				_str = splitArr[i];
				unicode = _str.charCodeAt();
				if(unicode < 32 || unicode > 126) { // !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
					flag = false;
					break;
				} 
			}
			return flag;
		}
		
		/**
		 * 문장 내의 각 한글 character를 초,성,성으로 분해하여 담은 Array(character가 한글이 아닐 경우에는 Array에 바로 담습니다)들을 별도의 Array에 순차적으로 담아 2차원 배열(Array) 형태로 반환
		 * @example Basic usage:<listing version="3.0">
		var testStr:String = "브이더블유 익스텐션 v-wonderland extension";
		var returnArr:Array = StringUtil.breakSetenceStr(testStr);
		trace(returnArr); //ㅂ,브,ㅇ,이,ㄷ,더,ㅂ,브,블,ㅇ,유, ,ㅇ,이,익,ㅅ,스,ㅌ,테,텐,ㅅ,셔,션, ,[,v,-,w,o,n,d,e,r,l,a,n,d, ,e,x,t,e,n,s,i,o,n,]
		
		var _arr:Array;
		for (var i:uint = 0; i &#60; returnArr.length; ++i) {
			_arr = returnArr[i];
			trace("_arr :", _arr);
		}
		 *    </listing>
		 * @param _str
		 * @return Array
		 * @see #breakCharacterStr()
		 */
		public static function breakSetenceStr(_str:String):Array {
			var splitArr:Array = _str.split("");
			var strArr:Array = new Array();
			
			var _str:String;
			for(var i:uint = 0; i < splitArr.length; ++i) {
				_str = splitArr[i];
				strArr.push(StringUtil.breakCharacterStr(_str));
			}
			return strArr;
		}
		
		/**
		 * 한글 character를 초,중,종성으로 분해하여 Array에 담아 반환(character가 한글이 아닐 경우 Array에 담아 단순 반환) 
		 * <p>link - http://en.wikipedia.org/wiki/Korean_language_and_computers#Hangul_Syllables_Area</p>
		 * @example Basic usage:<listing version="3.0">
		var testChaStr:String = "껌";
		trace(StringUtil.breakCharacterStr(testChaStr)); //ㄲ, 꺼, 껌
		 *    </listing> 
		 * @param _oneCharacterStr
		 * @return Array
		 * @see #breakSetenceStr()
		 */
		public static function breakCharacterStr(_oneCharacterStr:String):Array {
			var valueArr:Array = new Array();
			var unicode:Number = _oneCharacterStr.charCodeAt();
			
			var initialValue:Number; //Initial Jamo
			var MedialValue:Number; //Initial Jamo + Medial Jamo
			
			if(unicode >= 44032 && unicode <= 55203) { //hangul (Unicode 44032 ~ 55203) 
				initialValue = Math.floor((unicode - 44032) / 588); //Initial Jamo index
				valueArr.push(String(LanguageData.INITIAL_JAMO_KOR[initialValue]));
				
				var initialJamoUnicode:Number = initialValue * 588 + 44032; // Initial Jamo + ㅏ(Medial Jamo[0]) + no Final Jamo
				MedialValue = Math.floor( (unicode - initialJamoUnicode) / 28 ) * 28 + initialJamoUnicode;
				
				var medialJamoUnicodeIndex:Number = Math.floor( (unicode - initialJamoUnicode) / 28 );
				
				//ㅘ, ㅙ, ㅚ (9, 10, 11) -> add ㅗ (8)
				if(medialJamoUnicodeIndex >= 9 && medialJamoUnicodeIndex <= 11) valueArr.push(String.fromCharCode(initialJamoUnicode + 8 * 28)); //valueArr.push(LanguageData.MEDIAL_JAMO_KOR[8]);
				
				//ㅝ, ㅞ, ㅟ (14, 15, 16) -> add ㅜ(13)
				if(medialJamoUnicodeIndex >= 14 && medialJamoUnicodeIndex <= 16) valueArr.push(String.fromCharCode(initialJamoUnicode + 13 * 28));//valueArr.push(LanguageData.MEDIAL_JAMO_KOR[13]);
				
				//ㅢ (19) -> add ㅡ(18)
				if(medialJamoUnicodeIndex == 19) valueArr.push(String.fromCharCode(initialJamoUnicode + 18 * 28)); //valueArr.push(LanguageData.MEDIAL_JAMO_KOR[18]);
				
				valueArr.push(String.fromCharCode(MedialValue));
				
				//add Final Jamo
				var finalJamoUnicodeIndex:int = unicode - MedialValue;
				if(finalJamoUnicodeIndex != 0) {
					//ㄲ, ㄳ (2, 3) -> add ㄱ(1)
					if(finalJamoUnicodeIndex >= 2 && finalJamoUnicodeIndex <= 3) {
						valueArr.push(String.fromCharCode(MedialValue + 1));
					}
					
					//ㄵ, ㄶ(5, 6) -> add ㄴ(4)
					if(finalJamoUnicodeIndex >= 5 && finalJamoUnicodeIndex <= 6) {
						valueArr.push(String.fromCharCode(MedialValue + 4));
					}
					
					//ㄺ, ㄻ, ㄼ, ㄽ, ㄾ, ㄿ, ㅀ (9, 10, 11, 12, 13, 14, 15) -> add ㄹ(8)
					if(finalJamoUnicodeIndex >= 9 && finalJamoUnicodeIndex <= 15) {
						valueArr.push(String.fromCharCode(MedialValue + 8));
					}
					
					//ㅄ (18) -> add ㅂ(17)
					if(finalJamoUnicodeIndex == 18) {
						valueArr.push(String.fromCharCode(MedialValue + 17));
					}
					
					//ㅆ (20) -> add ㅅ(19)
					if(finalJamoUnicodeIndex == 20) {
						valueArr.push(String.fromCharCode(MedialValue + 19));
					}
					
					valueArr.push(_oneCharacterStr);
				}
			}else if(unicode >= 32 && unicode <= 126) { // !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
				if(unicode == 32){ //" "
					valueArr.push(" ");
				}else if(unicode == 92){ //\
					valueArr.push(String.fromCharCode(unicode));
				}else{
					valueArr.push(String.fromCharCode(unicode));
				}
			}else{
				valueArr.push(String.fromCharCode(unicode));
			}
			
			return valueArr;
		}
		
		/**
		 * String 내의 특정 문자열을 변환하여 출력.
		 * @example Basic usage:<listing version="3.0">
		var testStr:String = "      test 입니다.     ";
		trace(StringUtil.replaceStr(testStr, "tes", "nex"));
		 *    </listing>
		 * @param _targetStr
		 * @param _findStr
		 * @param _changeStr
		 * @return 
		 */
		public static function replaceStr(_targetStr:String, _findStr:String, _changeStr:String):String
		{		   
			return _targetStr.split(_findStr).join(_changeStr);
		}
		
		/**
		 * String 내의 모든 공백 문자열 삭제 
		 * @example Basic usage:<listing version="3.0">
		var testStr:String = "      test      입     니다.     ";
		trace(StringUtil.removeWhiteSpaceStr(testStr));
		 *    </listing>
		 * @param _str
		 * @return String
		 */
		public static function removeWhiteSpaceStr(_str:String):String 
		{
			return _str.split(" ").join("");
		}
		
		/**
		 * String 앞, 뒤 공백 문자열 삭제
		 * @example Basic usage:<listing version="3.0">
		var testStr:String = "      test 입니다.     ";
		trace(StringUtil.trim(testStr));
		 *    </listing>
		 * @param _str
		 * @return String
		 */
		public static function trim(_str:String): String
		{
			var characters: Array = _str.split( "" );
			for( var i: int = 0; i< characters.length; i++ ){
				if( isWhitespace( characters[ i ] )){
					characters.splice( i, 1 );
					i--;
				} else {
					break;
				}
			}
			for ( i = characters.length - 1; i >= 0; i-- ){
				if( isWhitespace( characters[ i ] )){
					characters.splice( i, 1 );
				} else {
					break;
				}
			}
			return characters.join( "" );
		}
		
		private static function isWhitespace( ch: String ): Boolean
		{
			return ch == '\r' ||
				   ch == '\n' ||
				   ch == '\f' ||
				   ch == '\t' ||
				   ch == ' ';
		}
		
		/**
		 * String의 length가 특정한 숫자보다 길 경우, String을 특정한 숫자까지만 표기. String의 마지막 글자 이후 _cutAddStr String의 추가 가능
		 * @example Basic usage:<listing version="3.0">
		trace(StringUtil.cutStrByIndex("v-wonderland", 3, " extension"));
		 *    </listing>  
		 * @param _str
		 * @param _cutStringIndex
		 * @param _cutAddStr
		 * @return String
		 */
		static public function cutStrByIndex(_str:String, _cutStringIndex:uint, _cutAddStr:String = ""):String {
			var tempStr:String = _str;
			if (_str.length > _cutStringIndex) tempStr = _str.substr(0, _cutStringIndex) + _cutAddStr;
			return tempStr;
		}
		
		/**
		 * int type의 정수 형태로 param value 입력이 요구됩니다.)를 ','를 이용한 금액 표기 형태로 변경 출력. Number value(비트 연산 최대값 문제로 Number type으로 설정)
		 * @example Basic usage:<listing version="3.0">
		var cost:Number = 300000000000000000;
		trace(StringUtil.numberToPriceStr(cost)); //display 300,000,000,000,000,000
		 *    </listing> 
		 * @param _number
		 * @param _addStr
		 * @return String
		 */
		static public function numberToPriceStr(_number:Number, _addStr:String = ","):String {
			if (isNaN(_number)) return "[com.vwonderland.support.StringUtil.numberToPriceStr] 유효하지 않은 number 입니다.";
			var arr:Array = String(_number).split(""); 
			var tlen:int = arr.length; 
			var clen:int = Math.ceil(tlen / 3); 
			var i:int;
			for (i=1; i<clen; i++) arr.splice(tlen - i * 3, 0, _addStr); 
			return arr.join(""); 
		}
		
		/**
		 * int value의 자리 수를 특정 자리 수 형태로 변환 출력. 
		 * @example Basic usage:<listing version="3.0">
		trace(StringUtil.intToCipherStr(8, 3)); // 008 (8을 세자리 수 String 형태로 반환합니다.)
		trace(StringUtil.intToCipherStr(21, 5)); // 00021 (21을 다섯자리 수 String 형태로 반환합니다.)
		trace(StringUtil.intToCipherStr(11, 7, "+")); // +++++11 (11을 일곱자리 수 String 형태로 만들되, "0"이 아닌 "+"를 앞자릿수에 추가하여 반환합니다.)
		trace(StringUtil.intToCipherStr(-22, 6)); // -000022 (-22를 여섯자리 수 String 형태로 만들되, -22가 음수이므로 음수 기호를 추가하여 반환합니다.)
		 *    </listing> 
		 * @param _value
		 * @param _cipher
		 * @param _addStr
		 * @return String
		 */
		static public function intToCipherStr(_number:int, _cipher:uint, _addStr:String = "0"):String {
			if (isNaN(_number)) return "[com.vwonderland.support.StringUtil.intToCipherStr] 유효하지 않은 number 입니다.";
			var flag_positive:Boolean = MathUtil.getFlagPositiveNumber(_number);
			var _str:String = String(Math.abs(_number));
			
			if(_cipher == _str.length) {
				if(!flag_positive) _str = "-" + _str;
				return _str;
			}
			if(_cipher > _str.length) {
				while(_str.length < _cipher) {
					_str = _addStr + _str;
				}
			}else{
				trace("[com.vwonderland.support.StringUtil.intToCipherStr] number의 자릿수보다 변환할 자릿수(cipher)가 작으므로 number를 그대로 출력합니다.");
			}
			if(!flag_positive) _str = "-" + _str;
			return _str;
		}
		
		/**
		 * 주민등록번호(한국) 유효성 check
		 * <br>Only korean
		 * @example Basic usage:<listing version="3.0">
		trace(StringUtil.checkJumin("810215", "1055127")); //유효한 주민등록번호일 경우, true 반환
		 *    </listing>  
		 * @param _firstStr String 주민등록번호 앞자리
		 * @param _lastStr String 주민등록번호 뒷자리
		 * @return Boolean
		 */		
		public static function checkJumin(_firstStr:String, _lastStr:String):Boolean
		{
			var len1:Number = _firstStr.length;
			var len2:Number = _lastStr.length;
			
			//String length check
			if(len1 != 6){
				trace("[com.vwonderland.support.StringUtil.checkJumin] 주민번호 앞자리 길이가 정확하지 않습니다.");
				return false;
			}
			if(len2 != 7){
				trace("[com.vwonderland.support.StringUtil.checkJumin] 주민번호 뒷자리 길이가 정확하지 않습니다.");
				return false;
			}			 
			
			// birth check
			var bYear:String = _firstStr.substr(0,2); // 연도 뒷자리
			var month:Number = Number(_firstStr.substr(2,2)); // 월
			var day:Number = Number(_firstStr.substr(4,2)); // 일			   
			var yunYear:Boolean; // 윤년여부
			var fYear:String; // 연도 앞자리			   
			var sex_no:Number = Number(_lastStr.charAt(0)); // 성별부분			   
			if(sex_no < 1 || sex_no > 4){
				trace("[com.vwonderland.support.StringUtil.checkJumin] 주민번호 뒷자리의 시작은 1~4입니다.");
				return false;
			} else {
				if(sex_no == 3 || sex_no == 4){ // 2000년대 출생일 경우
					fYear = "20";
				} else { // 1900년대 출생일 경우
					fYear = "19";
				}
			}
			
			var birthYear:Number = Number(fYear + bYear); // 출생년도			   
			if(birthYear%4 == 0 && birthYear%100 != 0){ // 윤년여부
				yunYear = true;
			} else {
				if(birthYear%400 == 0){
					yunYear = true;
				} else {
					yunYear = false;
				}
			}			   
			if(month < 1 || month > 12){
				trace("[com.vwonderland.support.StringUtil.checkJumin] 월이 맞지 않습니다.");
				return false;
			}			   
			if(day < 1 || day > 31){
				trace("[com.vwonderland.support.StringUtil.checkJumin] 일이 맞지 않습니다.");
				return false;
			}   
			var m30_ary:Array = [4, 6, 9, 11];
			var isThirtyDays:Boolean = false;			   
			for(var i:int=0; i<m30_ary.length; i++){
				if(m30_ary[i] == month) isThirtyDays = true;
			}
			if(isThirtyDays == true && day > 30){ // 30일까지 있는 달인데 일이 30일이 넘어가는 경우
				trace("[com.vwonderland.support.StringUtil.checkJumin] 30일까지만 있는 달입니다.");
				return false;
			}
			if(month == 2){
				if(day < 1 || day > 29){
					trace("[com.vwonderland.support.StringUtil.checkJumin] 2월은 최대 29일까지입니다.");
					return false;
				}
				if(yunYear == false && day > 28){ // 평년인데 28일이 넘어가는 경우
					trace("[com.vwonderland.support.StringUtil.checkJumin] 평년의 2월은 28일까지입니다.");
					return false;
				}
			}			   
			return true;
		}
		
		/**
		 * e-mail address 유효성 check
		 * @example Basic usage:<listing version="3.0">
		trace(StringUtil.checkEmail(_value)); //_str parameter가 유효한 e-mail 주소 String일 경우, true 반환
		 *    </listing>  
		 * @param _str E-mail address String
		 * @return Boolean
		 */			
		public static function checkEmail(_str:String):Boolean
		{ 
			if(_str.indexOf("@") < 1){
				trace("[com.vwonderland.support.StringUtil.checkEmail] '@'문자가 빠지거나 맨 처음에 위치할 수 없습니다.");
				return false;
			}
			if(_str.indexOf(".") < -1){
				trace("[com.vwonderland.support.StringUtil.checkEmail] '.'문자가 빠지거나 맨 처음에 위치할 수 없습니다.");
				return false;
			}
			if(_str.indexOf("@") != _str.lastIndexOf("@")){
				trace("[com.vwonderland.support.StringUtil.checkEmail] '@'는 두 개이상 들어갈 수 없습니다.");
				return false;
			}
			if(_str.indexOf(".") - _str.indexOf("@") < 2){
				trace("[com.vwonderland.support.StringUtil.checkEmail] '.'이 '@'보다 먼저 위치할 수 없으며 '@' 바로 다음에 '.'이 위치할 수 없습니다.");
				return false;
			}
			if(_str.lastIndexOf(".") == _str.length-1){
				trace("[com.vwonderland.support.StringUtil.checkEmail] 마지막에 '.'이 위치할 수 없습니다.");
				return false;
			}
			
			var lastStrLen:Number = _str.substr(_str.lastIndexOf(".")+1).length;
			if(lastStrLen < 2 || lastStrLen > 4){
				trace("[com.vwonderland.support.StringUtil.checkEmail] 도메인명의 마지막 문자는 영문 2~4개여야 합니다.");
				return false;
			}
			return true;
		}
	}
}