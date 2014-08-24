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
	import flash.display.InteractiveObject;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	/**
	 * static ContextMenu setting Utils
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  14.07.2010
	 */
	public class ContextMenuUtil
	{
		/**
		 * _scope에 표기되는 contextMenu display setting
		 * @example Basic usage:<listing version="3.0">
		 InitUtil.SetInit(this, StageAlign.TOP_LEFT, StageScaleMode.NO_SCALE);
		 InitUtil.SetTabFocusEnable(this, false);
		 ContextMenuUtil.setContextMenu(this, false); 
		 *    </listing> 
		 * @param _scope
		 * @param _displayContextMenu
		 */
		static public function setContextMenu(_scope:InteractiveObject, _displayContextMenu:Boolean):void
		{
			var _contextMenu:ContextMenu;
			if(_scope.contextMenu != null) {
				_contextMenu = _scope.contextMenu;
			}else{
				_contextMenu = new ContextMenu();
				_scope.contextMenu = _contextMenu;
			}
			if (!_displayContextMenu) _contextMenu.hideBuiltInItems();
		}
		
		/**
		 * _contextMenu에서 _captionStr 문자열과 일치하는 caption을 가지는 ContextMenuItem 반환.
		 * @example Basic usage:<listing version="3.0">
		 private var contextMenuCaptionArr:Array = ["vw", "v-wonderland", "example"];
		 
		 public function TestContextMenuUtil() {
		 ContextMenuUtil.setContextMenu(this, false);
		 
		 var _contextMenuItem:ContextMenuItem;
		 for(var i:uint = 0; i &#60; contextMenuCaptionArr.length; ++i) {
		 _contextMenuItem = new ContextMenuItem(contextMenuCaptionArr[i]);
		 _contextMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, contextMenuItemSelectInteraction);
		 this.contextMenu.customItems.push(_contextMenuItem);
		 }
		 this.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, contextMenuSelectInteraction);
		 
		 //use ContextMenuUtil.getContextMenuItemByCaption() Function
		 _contextMenuItem = ContextMenuUtil.getContextMenuItemByCaption(this.contextMenu, "v-wonderland");
		 _contextMenuItem.enabled = false;
		 _contextMenuItem.separatorBefore = true;
		 }
		 
		 private function contextMenuItemSelectInteraction(e:ContextMenuEvent):void {
		 var _contextMenuItem:ContextMenuItem = e.currentTarget as ContextMenuItem;
		 trace(_contextMenuItem.caption);
		 _contextMenuItem.enabled = false;
		 _contextMenuItem.separatorBefore = true;
		 }
		 
		 private function contextMenuSelectInteraction(e:ContextMenuEvent):void {
		 trace("contextMenuSelectInteraction e :", e);
		 }
		 *    </listing>
		 * @param _contextMenu
		 * @param _captionStr
		 * @return ContextMenuItem
		 */
		static public function getContextMenuItemByCaption(_contextMenu:ContextMenu, _captionStr:String):ContextMenuItem {
			var contextMenuItemNum:int = _contextMenu.customItems.length;
			var _contextMenuItem:ContextMenuItem;
			for(var i:uint = 0; i < contextMenuItemNum; ++i) {
				_contextMenuItem = _contextMenu.customItems[i];
				if(_contextMenuItem.caption == _captionStr) {
					return _contextMenuItem;
					break;
				}
			}
			trace("[com.vwonderland.common.ContextMenuUtil.getContextMenuItemByCaption] _captionStr 문자열과 일치하는 caption을 가지는 ContextMenuItem이 존재하지 않습니다. null을 반환합니다.");
			return null;
		}
	}
}
