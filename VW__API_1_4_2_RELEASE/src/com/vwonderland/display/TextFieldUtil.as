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
	import com.vwonderland.control.SimpleTimer;
	import com.vwonderland.support.StringUtil;
	
	import flash.display.*;
	import flash.text.*;
	
	/**
	 * static TextField Utils
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  15.07.2010
	 */	
	public class TextFieldUtil {
		
		/**
		 * make preSetting TextField
		 * @example Basic usage:<listing version="3.0">
		var _testStr:String = "가장 중요한 것은 흥미나 호기심을 가진 것을, 뭐든지 곧바로 실행해보는 행동력이라고 생각합니다. 상상만으로는 아무 것도 태어나지 않고, 해 보면 반드시 무엇인가 다음으로 연결되거나 얻는 것이 있습니다.";
		var _testTF:TextField = TextFieldUtil.makeTF(300, 40, "dotum", 12, 0x5f5f5f, false, false, false, false, -1);
		_testTF.border = true;
		TextFieldUtil.setTextByTextWidth(_testStr, _testTF, "...");
		this.addChild(_testTF);
		 *    </listing> 
		 * @param _width
		 * @param _height
		 * @param _fontName
		 * @param _fontSize
		 * @param _fontColor
		 * @param _embedFonts
		 * @param _multiline
		 * @param _wordWrap
		 * @param _bold
		 * @param _letterSpacing
		 * @param _leading
		 * @param _thickness
		 * @param _sharpness
		 * @param _align
		 * @param _autoSize
		 * @param _selectable
		 * @return TextField
		 */
		static public function makeTF(_width:Number, 
									  _height:Number, 
									  
									  _fontName:String,
									  _fontSize:Number,
									  _fontColor:uint,
									  
									  _embedFonts:Boolean = false, 
									  _multiline:Boolean = false,
									  _wordWrap:Boolean = false,
									  _bold:Boolean = false,
									  
									  _letterSpacing:Number = 0,
									  _leading:Number = 0,
									  _thickness:Number = 0,
									  _sharpness:Number = 0, 
									  
									  _align:String = "left",
									  _autoSize:String = "none",
									  _selectable:Boolean = false
		):TextField {
			var _tf:TextField = new TextField();
			_tf.width = _width;
			_tf.height = _height;
			
			var _tFormat:TextFormat = new TextFormat(_fontName, _fontSize, _fontColor, _bold);
			_tf.embedFonts = _embedFonts;
			_tf.multiline = _multiline;
			_tf.wordWrap = _wordWrap;
			
			_tFormat.letterSpacing = _letterSpacing;
			_tFormat.leading = _leading;
			
			if(_thickness != 0 || _sharpness != 0) _tf.antiAliasType = AntiAliasType.ADVANCED;
			_tf.thickness = _thickness;
			_tf.sharpness = _sharpness;
			
			_tFormat.align = _align;
			_tf.autoSize = _autoSize;
			_tf.selectable = _selectable;
			_tf.defaultTextFormat = _tFormat;
			return _tf;
		}
		
		/**
		 * multiLine TextField를 여러 개의 singleLine TextField로 분해하여, Array에 담아 반환
		 * @example Basic usage:<listing version="3.0">
		var _testTF:TextField = new TextField();
		_testTF.width = 200;
		_testTF.height = 200;
		_testTF.multiline = true;
		_testTF.wordWrap = true;
		_testTF.border = true;
		_testTF.text = "가장 중요한 것은 흥미나 호기심을 가진 것을, 뭐든지 곧바로 실행해보는 행동력이라고 생각합니다. 상상만으로는 아무 것도 태어나지 않고, 해 보면 반드시 무엇인가 다음으로 연결되거나 얻는 것이 있습니다.";
		this.addChild(_testTF);
		
		var tempArr:Array = TextFieldUtil.divideMultiLineTextField(_testTF);
		
		var _testTF_0:TextField = tempArr[0];
		_testTF_0.border = true;
		_testTF_0.x = 200;
		this.addChild(_testTF_0);
		
		var _testTF_1:TextField = tempArr[1];
		_testTF_1.border = true;
		_testTF_1.x = 200;
		_testTF_1.y = 30;
		this.addChild(_testTF_1);
		 *    </listing>
		 * @param _multiLineTextField
		 * @param _textFieldAutoSize
		 * @return Array
		 */
		
		static public function divideMultiLineTextField(_multiLineTextField:TextField, _textFieldAutoSize:String = "left"):Array {
			var returnArr:Array = new Array();
			var tempTFformat:TextFormat = _multiLineTextField.defaultTextFormat;
			
			var textField:TextField;
			var tempStr:String;
			for(var i:uint = 0; i < _multiLineTextField.numLines; ++i) {
				textField = new TextField();
				textField.defaultTextFormat = tempTFformat;
				textField.type = TextFieldType.DYNAMIC;
				textField.width = _multiLineTextField.width;
				textField.text = _multiLineTextField.getLineText(i);
				textField.autoSize = _textFieldAutoSize;
				textField.setTextFormat(tempTFformat);
				returnArr.push(textField);
			}
			return returnArr;
		}
		
		/**
		 * multiline TextField 전용 method. multiline TextField에 입력되는 String value의 textWidth를 계산하여, _limitNumLine 행의 text에 _addStr 추가하여 표기 제한.  
		 * @example Basic usage:<listing version="3.0">
		var _testTF:TextField = new TextField();
		_testTF.width = 200;
		_testTF.height = 200;
		_testTF.multiline = true;
		_testTF.wordWrap = true;
		_testTF.border = true;
		this.addChild(_testTF);
		
		var _testStr:String = "가장 중요한 것은 흥미나 호기심을 가진 것을, 뭐든지 곧바로 실행해보는 행동력이라고 생각합니다. 상상만으로는 아무 것도 태어나지 않고, 해 보면 반드시 무엇인가 다음으로 연결되거나 얻는 것이 있습니다.";
		TextFieldUtil.setMultiLineTextByTextWidth(_testStr, _testTF, 2, "...");
		 *    </listing>
		 * @param _txt
		 * @param _textField
		 * @param _limitNumLine
		 * @param _addStr
		 * @throws Error
		 * @see #setTextByTextWidth()
		 */
		static public function setMultiLineTextByTextWidth(_txt:String, _textField:TextField, _limitNumLine:uint, _addStr:String):void {
			const GAP_CHECK:int = 5; //font별 특성상 발생하는 오차값의 임의 정의.
			var marginSpaceX:Number;
			var tempText:String = _txt;
			var tempLimitLine:int = _limitNumLine;
			var tempTFwidth:Number = _textField.width;
			
			if(_limitNumLine < 1) {
				throw new Error("[com.vwonderland.display.TextFieldUtil.setMultiLineTextByTextWidth] - _limitNumLine param은 1 이상이어야 합니다.");
				_textField.text = _txt;
				return;
			}
			_textField.text = _addStr;
			
			if(_textField.numLines > 1) {
				throw new Error("[com.vwonderland.display.TextFieldUtil.setMultiLineTextByTextWidth] - 추가되는 _addStr param의 길이가, _textField param의 textWidth보다 깁니다.");
				_textField.text = _txt;
				return;
			}
			marginSpaceX = _textField.textWidth + GAP_CHECK;
			_textField.text = _txt;
			
			if (_textField.numLines >= _limitNumLine) {
				var firstStrIndex:int = _textField.getLineOffset(_limitNumLine - 1);
				var prevStr:String = _txt.substr(0, firstStrIndex);
				for (var i:int = firstStrIndex; i < _txt.length; ++i) {
					var prevNumLine:int = _textField.numLines;
					prevStr += _txt.charAt(i);
					_textField.text = prevStr;
					
					var nextNumLine:int = _textField.numLines;
					if(nextNumLine < _limitNumLine) continue;
					var lastStrIndex:int = _textField.getCharIndexAtPoint(tempTFwidth - marginSpaceX, _textField.getLineMetrics(_limitNumLine - 1).height * _limitNumLine - 0.5);
					
					if (lastStrIndex >= 0) {
						_textField.text = _txt.substr(0, lastStrIndex) + _addStr;
						return;
					}
					if (lastStrIndex < 0 && _limitNumLine == prevNumLine && prevNumLine < nextNumLine) {
						_textField.text = _textField.text.substr(0, _textField.text.length - 1) + _addStr;
						return;
					}
					if (lastStrIndex < 0 && _limitNumLine < nextNumLine) {
						_textField.text = _textField.text.substr(0, _textField.text.length - 1) + _addStr;
						return;
					}
				}
			}
		}
		
		/**
		 * singleline TextField 전용 method. singleLine TextField에 입력되는 String value의 textWidth를 계산하여, _addStr 추가하여 표기 제한.
		 * @example Basic usage:<listing version="3.0">
		var _testTF:TextField = new TextField();
		_testTF.width = 400;
		_testTF.height = 20;
		_testTF.border = true;
		this.addChild(_testTF);
		
		var _testStr:String = "가장 중요한 것은 흥미나 호기심을 가진 것을, 뭐든지 곧바로 실행해보는 행동력이라고 생각합니다. ";
		TextFieldUtil.setTextByTextWidth(_testStr, _testTF, "...");
		 *    </listing>
		 * @param _txt
		 * @param _textField
		 * @param _addStr
		 * @see #setMultiLineTextByTextWidth()
		 */
		static public function setTextByTextWidth(_txt:String, _textField:TextField, _addStr:String):void {
			const GAP_CHECK:int = 5; //font별 특성상 발생하는 오차값의 임의 상수 정의. 
			var marginSpace:Number;
			var tempText:String = _txt;
			var tempTextField:TextField = _textField;
			var tempAddText:String = "";
			
			tempTextField.text = _addStr;
			marginSpace = tempTextField.textWidth + GAP_CHECK;
			tempTextField.text = "";
			
			var prevTextWidth:Number;
			var prevText:String = "";
			
			for (var i:uint = 0; i < _txt.length; ++i) {
				tempAddText += tempText.charAt(i);
				tempTextField.text = tempAddText;
				
				if( tempTextField.textWidth + marginSpace >= tempTextField.width ) {
					tempTextField.text = prevText + _addStr;
					return;
				}
				
				if( tempTextField.textWidth + marginSpace <= prevTextWidth) { //_addStr로 "..."이나 "///"와 같은 기호들이 들어갈 경우, textField의 textWidth가 계속해서 같은 값으로 나오는 현상이 발생 합니다. 이 경우, 이전 값과 같은 textWidth값이 나올 경우 연산을 중지토록 합니다.
					tempTextField.text = prevText + _addStr;
					return;
				}
				
				prevText = tempTextField.text;
				prevTextWidth = tempTextField.textWidth + marginSpace		
			}
		}
	}
} 
