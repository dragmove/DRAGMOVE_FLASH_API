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

package com.vwonderland.control.sound
{
	import com.vwonderland.base.AbstractControllableConceptObject;
	
	import flash.media.*;

	/**
	 * abstract simple Sound Controller. can use simply without extended Class
	 * @example Basic usage:<listing version="3.0">
	var _soundController:AbstractSoundController = new AbstractSoundController();
	_soundController.init();
	_soundController.addSound(new LibrarySoundlinkageName(), "SOUND_ROLLOVER_DEPTH1_BUTTON"); //sound, soundName setting
	_soundController.playSound("SOUND_ROLLOVER_DEPTH1_BUTTON"); //play sound
	//_soundController.stopSound(); //stop sound
	 *    </listing>
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  22.07.2010
	 */
	public class AbstractSoundController extends AbstractControllableConceptObject
	{
		private var _sChannel:SoundChannel;
		private var _sTransform:SoundTransform;
		private var _sound:Sound;

		private var soundObj_arr:Array;
		private var soundName_arr:Array;

		/**
		 * set volume (0 ~ 1 number value)
		 * @param _volumeValue
		 */
		public function setVolume(_volumeValue:Number):void
		{
			var targetVolume:Number=_volumeValue;
			if (targetVolume < 0) targetVolume=0;
			if (targetVolume > 1) targetVolume=1;
			if(_sTransform != null) _sTransform.volume=targetVolume;
		}

		/**
		 * 등록된 sound의 갯수
		 * @return int
		 */
		public function get addedSoundNum():int
		{
			if(soundObj_arr != null) {
				return soundObj_arr.length;
			}
			else
			{
				throw new Error("[com.vwonderland.control.sound.AbstractSoundController] Must use init() before use addedSoundNum property.")
			}
		}

		/**
		 * sound 등록
		 * @param _soundObj
		 * @param _soundName
		 * @throws Error
		 * @see #removeSound()
		 */
		public function addSound(_soundObj:Sound, _soundName:String):void
		{
			if (soundObj_arr != null && soundName_arr != null)
			{
				var addSoundIndex:int=soundName_arr.indexOf(_soundName);
				if(addSoundIndex > -1) {
					trace("[com.vwonderland.control.sound.AbstractSoundController] Can't add sound. soundName is already exist.");
					return;
				}
				soundObj_arr.push(_soundObj);
				soundName_arr.push(_soundName);
			}
			else
			{
				throw new Error("[com.vwonderland.control.sound.AbstractSoundController] Must use init() before use addSound() method.")
			}
		}

		/**
		 * 등록된 sound의 삭제
		 * @param _soundName
		 * @throws Error
		 * @see #addSound()
		 */
		public function removeSound(_soundName:String):void
		{
			if (soundObj_arr != null && soundName_arr != null && removeIndex > -1)
			{
				var removeIndex:int=soundName_arr.indexOf(_soundName);
				if(removeIndex < 0) {
					trace("[com.vwonderland.control.sound.AbstractSoundController] Can't remove Sound. soundName is not exist.");
					return;
				}
				soundObj_arr.splice(removeIndex, 1);
				soundName_arr.splice(removeIndex, 1);
			}
			else
			{
				throw new Error("[com.vwonderland.control.sound.AbstractSoundController] Must use init() before use removeSound() method.")
			}
		}

		/**
		 * play sound
		 * @param _soundName
		 * @throws Error
		 * @see #stopSound() 
		 */
		public function playSound(_soundName:String, _startTime:Number = 0, _loops:int = 0):void
		{
			var soundNameIndex:int=soundName_arr.indexOf(_soundName);
			if (soundNameIndex < 0)
			{
				throw new Error("[com.vwonderland.control.sound.AbstractSoundController] Can't search sound name")
				return;
			}
			_sound=Sound(soundObj_arr[soundName_arr.indexOf(_soundName)]);
			_sChannel=_sound.play(0, _loops, _sTransform);
			playSoundDetail(_sound, _sChannel, _sTransform); //hook Function
		}
		
		/**
		 * playSound method로 play시킨 sound의 stop
		 * @see #playSound()
		 */
		public function	stopSound():void {
			if(_sChannel != null) _sChannel.stop();
		}

		//================
		// Constructor
		//================
		/**
		 * Constructor
		 */
		public function AbstractSoundController()
		{
		}

		override public function init(_obj:Object=null):void
		{
			soundObj_arr=new Array();
			soundName_arr=new Array();

			_sChannel=new SoundChannel();
			_sTransform=new SoundTransform();

			setInstance(_obj);
		}

		/**
		 * (override detail define) init detail setting
		 * @param _obj
		 */
		protected function setInstance(_obj:Object):void
		{ 
			//override define Function	
		}

		/**
		 * (override detail define) play sound() hook method
		 * @param _playedSound
		 * @param _playedSoundChannel
		 * @param _playedSoundTransform
		 */
		protected function playSoundDetail(_playedSound:Sound, _playedSoundChannel:SoundChannel, _playedSoundTransform:SoundTransform):void
		{
			//override define Function
			//_playedSound, _sChannel, _sTransform
		}

	}
}

