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
	 * static XML Utils
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  20.05.2011
	 */	
	public class XmlUtil
	{
		/**
		 * xml 내의 특정한 속성명과 속성값을 가지는 Node들을 담은 Array 반환 
		 * @example Basic usage:<listing version="3.0">
		 //XML setting 
		 var xml:XML = 
		 &#60;data&#62;
			 &#60;depth1 depth1code="1" depth2code="0" depth3code="0"&#62;
				 &#60;name&#62;&#60;![CDATA[1_0_0]]&#62;&#60;/name&#62;
				 &#60;linkURL target="_self"&#62;&#60;![CDATA[1_0_0.asp]]&#62;&#60;/linkURL&#62;
				 
				 &#60;depth2 depth1code="1" depth2code="1" depth3code="0"&#62;
					 &#60;name&#62;&#60;![CDATA[1_1_0]]&#62;&#60;/name&#62;
					 &#60;linkURL target="_self"&#62;&#60;![CDATA[1_1_0.asp]]&#62;&#60;/linkURL&#62;
				 
					 &#60;depth3 depth1code="1" depth2code="1" depth3code="1"&#62;
						 &#60;name&#62;&#60;![CDATA[1_1_1]]&#62;&#60;/name&#62;
						 &#60;linkURL target="_self"&#62;&#60;![CDATA[1_1_1.asp]]&#62;&#60;/linkURL&#62;
					 &#60;/depth3&#62;
				 
					 &#60;depth3 depth1code="1" depth2code="1" depth3code="2"&#62;
						 &#60;name&#62;&#60;![CDATA[1_1_2]]&#62;&#60;/name&#62;
						 &#60;linkURL target="_self"&#62;&#60;![CDATA[1_1_2.asp]]&#62;&#60;/linkURL&#62;
					 &#60;/depth3&#62;
				 &#60;/depth2&#62;
				 
				 &#60;depth2 depth1code="1" depth2code="2" depth3code="0"&#62;
					 &#60;name&#62;&#60;![CDATA[1_2_0]]&#62;&#60;/name&#62;
					 &#60;linkURL target="_self"&#62;&#60;![CDATA[1_2_0.asp]]&#62;&#60;/linkURL&#62;
				 &#60;/depth2&#62;
			 &#60;/depth1&#62;
		 &#60;/data&#62;
		 
		 trace("XmlUtil.getNodesArrayByAttribute return Array :", XmlUtil.getNodesArrayByAttribute(xml, "depth1code", "1", "depth2code", "1", "depth3code", "2"));
		 *    </listing>
		 * @param _xml
		 * @param _attributeNameStr
		 * @param _attributeValueStr
		 * @param restAttributeNameStrAndValueStr
		 * @return Array
		 */
		static public function getNodesArrayByAttribute(_xml:XML, _attributeNameStr:String, _attributeValueStr:String, ...restAttributeNameStrAndValueStr):Array {
			var searchFlowNum:uint = 0;
			var searchAttributeNameStr:String = _attributeNameStr;
			var searchAttributeValueStr:String = _attributeValueStr;
			var returnNodeArr:Array = new Array();
			
			var returnXml:XML;
			var returnNodeXml:XML;
			var xmlList:XMLList = _xml.descendants("*");
			var xmlListLength:uint = xmlList.length();
			for(var i:uint = 0; i < xmlListLength; ++i) {
				if(String(xmlList[i].attribute(searchAttributeNameStr)) == searchAttributeValueStr) {
					returnXml = xmlList[i];
					returnNodeXml = XML(returnXml);
					returnNodeArr.push(returnNodeXml);
				}
			}
			
			if(returnNodeArr.length <= 0) {
				trace("[com.vwonderland.support.XmlUtil.getNodesArrayByAttribute] " + _attributeNameStr + " 속성에 해당하는 " + _attributeValueStr + " 값이 존재하지 않습니다. null을 반환합니다.");
				return null;
			}
			if(restAttributeNameStrAndValueStr.length <= 0) return returnNodeArr;
			
			if(MathUtil.getFlagEvenInt(restAttributeNameStrAndValueStr.length)) { 
				var searchNodeArr:Array;
				while(searchFlowNum < restAttributeNameStrAndValueStr.length) {
					searchAttributeNameStr = restAttributeNameStrAndValueStr[searchFlowNum]; //rest의 첫번째 변수로 검색
					searchFlowNum++;
					searchAttributeValueStr = restAttributeNameStrAndValueStr[searchFlowNum];
					searchFlowNum++;
					
					searchNodeArr = new Array();
					for(var j:uint = 0; j < returnNodeArr.length; ++j) {
						if(String(returnNodeArr[j].attribute(searchAttributeNameStr)) == searchAttributeValueStr) {
							returnXml = XML(returnNodeArr[j]);
							searchNodeArr.push(returnXml);
						}
					}
					if(searchNodeArr.length > 0) {
						returnNodeArr = searchNodeArr;
					}else{
						trace("[com.vwonderland.support.XmlUtil.getNodesArrayByAttribute] restAttributeNameStrAndValueStr parameter 중 " + searchAttributeNameStr + " 속성에 해당하는 " + searchAttributeValueStr + " 값이 존재하지 않습니다. null을 반환합니다.");
						return null;
					}
				}
			}else{
				trace("[com.vwonderland.support.XmlUtil.getNodesArrayByAttribute] restAttributeNameStrAndValueStr parameter의 속성과 값이 한 쌍으로 전달되지 않았습니다. null을 반환합니다.");
				return null;
			}
			return returnNodeArr;
		}
	}
}