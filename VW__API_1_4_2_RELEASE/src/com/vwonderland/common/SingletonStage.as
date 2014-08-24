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
	import flash.display.Stage;
	
	/**
	 * Singleton Stage를 정의하여, 모든 위치에서 stage에 접근할 수 있는 공통된 경로를 제공합니다.
	 * @example Basic usage:<listing version="3.0">
	 SingletonStage.getInstance().setStage(this.stage); //Singleton Stage setting
	 trace(SingletonStage.getInstance().getStage()); //Singlton Stage 참조
	 trace(SingletonStage.getInstance().getStage().stageWidth); //Singlton Stage의 stageWidth 참조
	 *    </listing>
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  22.07.2010
	 */
	public class SingletonStage
	{
		static private var _instance:SingletonStage=new SingletonStage();
		static private var _stage:Stage;
		
		/**
		 * SingletonStage 객체 생성시, Stage.getInstance()를 사용해야 합니다. SingletonStage은 Singlton pattern으로 관리됩니다.
		 * @throws Error
		 */
		public function SingletonStage()
		{
			if (_instance) throw new Error("[com.vwonderland.util.SingletonStage] SingletonStage instance 생성시, Stage.getInstance()를 사용해야 합니다. ");
		}
		
		/**
		 * SingletonStage 객체를 반환합니다.
		 * @return
		 */
		static public function getInstance():SingletonStage
		{
			return SingletonStage._instance;
		}
		
		/**
		 * SingletonStage 객체 내부의 Stage를 정의합니다.
		 * @param _targetStage
		 * @see #getStage()
		 */
		public function setStage(_targetStage:Stage):void
		{
			trace("[com.vwonderland.util.SingletonStage] SingletonStage._stage가 새롭게 정의되었습니다.");
			_stage=_targetStage;
		}
		
		/**
		 * SingletonStage 객체 내부에 정의된 Stage를 반환합니다.
		 * @return
		 * @see #setStage()
		 */
		public function getStage():Stage
		{
			return _stage;
		}
	}
}