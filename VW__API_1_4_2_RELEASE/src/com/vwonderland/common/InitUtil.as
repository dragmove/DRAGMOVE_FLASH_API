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

package com.vwonderland.common
{
	import flash.display.*;

	/**
	 * static initialization Utils
	 * @example Basic usage:<listing version="3.0">
	InitUtil.SetInit(this, StageAlign.TOP_LEFT, StageScaleMode.NO_SCALE);
	InitUtil.SetTabFocusEnable(this, false);
	ContextMenuUtil.setContextMenu(this, false);
	 *    </listing>
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  14.07.2010
	 */
	public class InitUtil
	{

		/**
		 * simple stageAlign, scaleMode setting
		 * @param _scope
		 * @param _stageAlign
		 * @param _scaleMode
		 */
		static public function SetInit(_scope:DisplayObject, _stageAlign:String, _scaleMode:String):void
		{
			if(_stageAlign != null && _stageAlign != "") _scope.stage.align=_stageAlign;
			if(_scaleMode != null && _scaleMode != "") _scope.stage.scaleMode=_scaleMode;
		}

		/**
		 * simple Tab focusRect setting
		 * @param scope
		 * @param _tabFocus
		 */
		static public function SetTabFocusEnable(_scope:DisplayObjectContainer, _tabFocus:Boolean=false):void
		{
			_scope.focusRect = _tabFocus;
			_scope.tabChildren = _tabFocus;
			_scope.tabEnabled = _tabFocus;
		}

		/**
		 * FlashVars parameter setting. Local, Server 상태에 따라 parameter value를 다르게 설정.
		 * @example Basic usage:<listing version="3.0">
		 * var naviXmlPath:String = InitUtil.setParameters(this.stage, "naviXmlPath", "../flash/xml/navi.xml");
		 * trace("local naviXmlPath :", naviXmlPath); //FlashVars를 통해 flash로 전달되는 naviXmlPath Value가 존재할 경우 표기. 존재하지 않을 경우 "../flash/xml/navi.xml" 표기.
		 * 		</listing>
		 * @param $stage Stage
		 * @param $name Server 상태일 경우 or FlashVars를 통해 flash로 전달되는 Parameters Name
		 * @param $local Local 상태일 경우 or FlashVars를 통해 flash로 전달되는 Parameters가 없을 경우, 반환되는 String value
		 * @return
		 *
		 */
		public static function setParameters(_stage:Stage, _paramName:String, _local:String):String
		{
			var url:String=String(_stage.loaderInfo.url).slice(0, 4);
			var obj:Object=LoaderInfo(_stage.loaderInfo).parameters;
			if (obj[_paramName] == undefined && url == "file")
				return _local;
			else
				return String(obj[_paramName]);
		}
	}
}
