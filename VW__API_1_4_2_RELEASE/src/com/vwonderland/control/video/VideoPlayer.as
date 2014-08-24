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

package com.vwonderland.control.video
{
	import com.vwonderland.base.AbstractControllableConceptObject;
	import com.vwonderland.base.IControllableObject;
	
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	/**
	 * VideoPlayer. 
	 * <p>cuePoint 기능은 제공하지 않으므로, connectStream Function을 override하여 세부 구현해야 합니다.</p>
	 * <p>SecurityError에 반응하지 않습니다. 이것은 Flash Media Server 또는 Flash Remoting을 실행하는 응용 프로그램 서버에서 NetConnection.call 함수가 호출될 때 SecurityError Event가 발생하기 때문입니다. 본 VideoPlayer Class는 Flash Media Server와 연동하는 기능은 제공하지 않습니다.</p>
	 * @example Basic usage:<listing version="3.0">
	private var prevVideoModeStr:String;
	private var flag_ongoingSeek:Boolean = false; //seek video process 진행중 여부
	private var flag_pressProgressBtn:Boolean = false; //progressBtn Mouse press 상태여부
	private var videoProgressPercentage:Number = 0;
	
	//instance
	private var _player:VideoPlayer;
	
	private var _progressBarBg:Sprite;
	private var _downloadBar:Sprite;
	private var _progressBtn:Sprite;
	private var _progressSeekSlider:SliderHorizontal;
	
	private var _playPauseTF:TextField;
	private var _stopTF:TextField;
	
	private var _volumeBarBg:Sprite;
	private var _volumeBtn:Sprite;
	private var _volumeSlider:SliderHorizontal;
	
	private var _panBarBg:Sprite;
	private var _panBtn:Sprite;
	private var _panSlider:SliderHorizontal;
	
	private var _timeTF:TextField;
	private var _downloadTimeTF:TextField;
	private var _durationTimeTF:TextField;
	
	private var _muteTF:TextField;
	private var _fullScreenViewTF:TextField;
	private var _playOtherVideoTF:TextField;
	
	private var _progressCheckTimer:SimpleTimer;
	private var _userInteractionBlock:Sprite;
	
	public function TestVideoPlayer():void {
		//VideoPlayer instance setting
		_player = new VideoPlayer(320, 240);
		this.addChild(_player);
		
		_player.addEventListener(VideoPlayer.READY_VIDEO_METADATA, videoStatusHandler); //Video File의 MetaData의 duration data 취득시
		_player.addEventListener(VideoPlayer.FINISH_VIDEO, videoStatusHandler);			//Video File의 재생 완료시
		_player.addEventListener(VideoPlayer.START_VIDEO, videoStatusHandler);			//Video File의 재생 시작시
		
		_player.addEventListener(VideoPlayer.NETSTREAM_NOT_FOUND, netStreamHandler); 	//재생할 video File을 찾을 수 없을 경우
		_player.addEventListener(VideoPlayer.NETSTREAM_BUFFER_EMPTY, netStreamHandler);	//버퍼를 채우기에 충분할 만큼 신속하게 데이터가 수신되지 않습니다.
		_player.addEventListener(VideoPlayer.NETSTREAM_BUFFER_FULL, netStreamHandler);	//버퍼가 채워지고 스트림이 재생을 시작합니다.
		_player.addEventListener(VideoPlayer.NETSTREAM_BUFFER_FLUSH, netStreamHandler);	//데이터의 스트림이 완료되었고 남아 있는 버퍼가 비워집니다.
		
		_player.setURL("http://www.v-wonderland.com/flv/serverFLV.f4v", 5, true, true, false); //Server File
		//_player.setURL("../flv/localFLV.flv", 5, true, false, false); //Local File
		// 1. setURL - _preventAutoDownload = false일 경우, netStream open 상태입니다. Video File download가 시작됩니다.
		// 2. setURL - _preventAutoDownload = true일 경우, netStream close 상태입니다. _player.play() 실행 시점부터 video File download &#38; play가 시작됩니다.
		
		//VideoPlayer Control Button Setting
		_playPauseTF = TextFieldUtil.makeTF(50, 15, "dotum", 11, 0x000000, false, false, false, false, 0, 0, 0, 0, TextFormatAlign.CENTER);
		_playPauseTF.border = true;
		_playPauseTF.text = "PLAY";
		_playPauseTF.y = 270;
		_playPauseTF.addEventListener(MouseEvent.CLICK, _playPauseTFMouseInteraction);
		this.addChild(_playPauseTF);
		
		_stopTF = TextFieldUtil.makeTF(50, 15, "dotum", 11, 0x000000, false, false, false, false, 0, 0, 0, 0, TextFormatAlign.CENTER);
		_stopTF.border = true;
		_stopTF.text = "STOP";
		_stopTF.x = 50;
		_stopTF.y = 270;
		_stopTF.addEventListener(MouseEvent.CLICK, _stopTFMouseInteraction);
		this.addChild(_stopTF);
		
		//ProgressBarBg &#38; download Bar &#38; progress seek Btn setting
		_progressBarBg = SimpleRect.drawRectSprite(320, 10, 0xcccccc);
		_progressBarBg.y = 245;
		this.addChild(_progressBarBg);
		
		_downloadBar = SimpleRect.drawRectSprite(320, 10, 0xff9000);
		_downloadBar.width = 0;
		_downloadBar.y = 245;
		this.addChild(_downloadBar);
		
		_progressBtn = SimpleRect.drawRectSprite(10, 10, 0xff0000);
		_progressBtn.y = 245;
		this.addChild(_progressBtn);
		
		//Time display Setting
		_timeTF = TextFieldUtil.makeTF(50, 15, "dotum", 11, 0x000000, false, false, false, false, 0, 0, 0, 0, TextFormatAlign.CENTER);
		_timeTF.border = true;
		_timeTF.y = 300;
		_timeTF.text = "00:00";
		this.addChild(_timeTF);
		
		_downloadTimeTF = TextFieldUtil.makeTF(50, 15, "dotum", 11, 0x000000, false, false, false, false, 0, 0, 0, 0, TextFormatAlign.CENTER);
		_downloadTimeTF.border = true;
		_downloadTimeTF.y = 315;
		_downloadTimeTF.text = "00:00";
		this.addChild(_downloadTimeTF);
		
		_durationTimeTF = TextFieldUtil.makeTF(50, 15, "dotum", 11, 0x000000, false, false, false, false, 0, 0, 0, 0, TextFormatAlign.CENTER);
		_durationTimeTF.border = true;
		_durationTimeTF.y = 330;
		_durationTimeTF.text = "00:00";
		this.addChild(_durationTimeTF);
		
		//sound mute control Button Setting
		_muteTF = TextFieldUtil.makeTF(100, 15, "dotum", 11, 0x000000, false, false, false, false, 0, 0, 0, 0, TextFormatAlign.CENTER);
		_muteTF.border = true;
		_muteTF.text = "SOUND OFF";
		_muteTF.x = 220;
		_muteTF.y = 300;
		_muteTF.addEventListener(MouseEvent.CLICK, _muteTFMouseInteraction);
		this.addChild(_muteTF);
		
		//fullScreen Button Setting
		_fullScreenViewTF = TextFieldUtil.makeTF(100, 15, "dotum", 11, 0x000000, false, false, false, false, 0, 0, 0, 0, TextFormatAlign.CENTER);
		_fullScreenViewTF.text = "FULL BROWSER";
		_fullScreenViewTF.border = true;
		_fullScreenViewTF.x = 220;
		_fullScreenViewTF.y = 315;
		_fullScreenViewTF.addEventListener(MouseEvent.CLICK, _fullScreenViewTFMouseInteraction);
		this.addChild(_fullScreenViewTF);
		
		//Volume control Button Setting
		_volumeBarBg = SimpleRect.drawRectSprite(100, 10, 0xcccccc);
		_volumeBarBg.x = 220;
		_volumeBarBg.y = 270;
		this.addChild(_volumeBarBg);
		
		_volumeBtn = SimpleRect.drawRectSprite(10, 10, 0xff0000);
		_volumeBtn.x = 220;
		_volumeBtn.y = 270;
		this.addChild(_volumeBtn);
		
		//Sound panning control Button Setting;
		_panBarBg = SimpleRect.drawRectSprite(100, 10, 0xcccccc);
		_panBarBg.x = 220;
		_panBarBg.y = 285;
		this.addChild(_panBarBg);
		
		_panBtn = SimpleRect.drawRectSprite(10, 10, 0x000000);
		_panBtn.x = 220;
		_panBtn.y = 285;
		this.addChild(_panBtn);
			
		//playOtherVideo Button Setting
		_playOtherVideoTF = TextFieldUtil.makeTF(100, 26, "dotum", 11, 0x000000, false, true, true, false, 0, 0, 0, 0, TextFormatAlign.CENTER);
		_playOtherVideoTF.border = true;
		_playOtherVideoTF.text = "PLAY OTHER FILE";
		_playOtherVideoTF.x = 220;
		_playOtherVideoTF.y = 330;
		_playOtherVideoTF.addEventListener(MouseEvent.CLICK, _playOtherVideoTFMouseInteraction);
		this.addChild(_playOtherVideoTF);
		
		//progress seek slider, volume control slider, sound panning control slider setting
		_progressSeekSlider = new SliderHorizontal(this.stage, _progressBtn, _progressBarBg.x, _progressBarBg.y, _progressBarBg.width - _progressBtn.width, 0, true);
		_progressSeekSlider.addEventListener(SliderBase.PRESS_SLIDER, sliderMouseInteraction);
		_progressSeekSlider.addEventListener(SliderBase.DRAG_SLIDER, sliderMouseInteraction);
		_progressSeekSlider.addEventListener(SliderBase.RELEASE_SLIDER, sliderMouseInteraction);
		
		_volumeSlider = new SliderHorizontal(this.stage, _volumeBtn, 220, 270, _volumeBarBg.width - _volumeBtn.width, 1, true);
		_volumeSlider.addEventListener(SliderBase.DRAG_SLIDER, volumeSliderMouseInteraction);
		_volumeSlider.addEventListener(SliderBase.RELEASE_SLIDER, volumeSliderMouseInteraction);
		
		_panSlider = new SliderHorizontal(this.stage, _panBtn, 220, 285, _panBarBg.width - _panBtn.width, 1, true);
		_panSlider.addEventListener(SliderBase.DRAG_SLIDER, panSliderMouseInteraction);
		_panSlider.addEventListener(SliderBase.RELEASE_SLIDER, panSliderMouseInteraction);
		
		//progress check timer setting
		setProgressCheckTimer();
		
		//user interaction Block Setting
		_userInteractionBlock = SimpleRect.drawRectSprite(this.stage.stageWidth, this.stage.stageHeight, 0x000000, 0.5);
		this.addChild(_userInteractionBlock);
		setUserInteractionBlock(true);
		
		//set sound volume : 0 ~ 1
		_volumeSlider.percentage = 0.5;
		_player.setVolume(_volumeSlider.percentage); 
		
		//set speaker sound panning : -1 ~ 1
		_panSlider.percentage = 0.5;
		_player.setPan(changeSliderPercentageToPanValue(_panSlider.percentage)); //_panSlider percentage value (0 ~ 1) to pan value (-1 ~ 1)
	}
	
	private function setUserInteractionBlock(_flag_block:Boolean):void {
		_userInteractionBlock.visible = _flag_block;
	}
	
	private function setInteractionInstance():void {
		trace("metadata duration 취득 완료. _progressSeekSlider, _volumeSlider의 slider mouse interaction 허용");
		setUserInteractionBlock(false);
	}
	
	private function seek(_seekTime:Number):void {
		flag_ongoingSeek = true;
		_player.seek(_seekTime);
	}
	
	private function _playOtherVideoTFMouseInteraction(e:MouseEvent):void {
		switch(e.type) {
			case MouseEvent.CLICK :
				flag_ongoingSeek = false;
				flag_pressProgressBtn = false;
				
				_player.setURL("http://www.v-wonderland.com/flv/serverOtherFLV.flv", 5, true, true, false);
				_player.play();
				_playPauseTF.text = "PAUSE";
				
				setProgressCheckTimer();
				_progressSeekSlider.makeMouseInteraction();
				setUserInteractionBlock(true);
			break;
		}
	}
	
	private function _playPauseTFMouseInteraction(e:MouseEvent):void {
		switch(e.type) {
			case MouseEvent.CLICK :
				if(_player.mode != VideoPlayer.MODE_PLAY) {
					_player.play();
					_playPauseTF.text = "PAUSE";
				} else {
					_player.pause();
					_playPauseTF.text = "PLAY";
				}
				break;
		}
	}
	
	private function _stopTFMouseInteraction(e:MouseEvent):void {
		switch(e.type) {
			case MouseEvent.CLICK :
				if(_player.mode != VideoPlayer.MODE_STOP) {
					flag_ongoingSeek = false;
					_player.stop(); 
					//1. stop() - continue download video File  
					//2. stop(true) - close download video File &#38; clear video
				}
				_playPauseTF.text = "PLAY";
				break;
		}
	}
	
	private function _muteTFMouseInteraction(e:MouseEvent):void {
		switch(e.type) {
			case MouseEvent.CLICK :
				if(_player.muteStatus){ //MUTE ON -> MUTE OFF
					_player.setMute(false);
					_muteTF.text = "SOUND OFF";
				}else{
					_player.setMute(true); //MUTE OFF -> MUTE ON
					_muteTF.text = "SOUND ON";
				}
				break;
		}
	}
	
	private function setProgressCheckTimer():void {
		removeProgressCheckTimer();
		_progressCheckTimer = new SimpleTimer(10, this, progressCheckTimerHandler);
		_progressCheckTimer.start();
	}
	
	private function removeProgressCheckTimer():void {
		if(_progressCheckTimer != null) {
			_progressCheckTimer.stop();
			_progressCheckTimer.destroy();
			_progressCheckTimer = null;
		}
	}
	
	private function progressCheckTimerHandler():void {
		//display time, downloadTime, durationTime
		var timeInfoArr:Array = SystemUtil.secondUnitToHourUnit(_player.time); //hour, minute, second
		var downloadInfoArr:Array = SystemUtil.secondUnitToHourUnit(_player.downloadTime); //hour, minute, second
		var durationInfoArr:Array = SystemUtil.secondUnitToHourUnit(_player.duration); //hour, minute, second
		_timeTF.text = String(StringUtil.intToCipherStr(timeInfoArr[1], 2) + ":" + StringUtil.intToCipherStr(timeInfoArr[2], 2));
		_downloadTimeTF.text = String(StringUtil.intToCipherStr(downloadInfoArr[1], 2) + ":" + StringUtil.intToCipherStr(downloadInfoArr[2], 2));
		_durationTimeTF.text = String(StringUtil.intToCipherStr(durationInfoArr[1], 2) + ":" + StringUtil.intToCipherStr(durationInfoArr[2], 2));
		
		//display downloadBar
		_downloadBar.width = _progressBarBg.width &#42; _player.downloadPercentage; 
		
		//Video progress 검색 중이 아니라면, _progressSeekSlider percentage 변경, _progressBtn의 x position 변경
		if(!flag_ongoingSeek) _progressSeekSlider.percentage = _player.progressPercentage;
		
		//Video File의 현재까지의 download percentage 파악, _progressBtn의 drag 가능한 범위 변경
		if(_progressSeekSlider != null) {
			var restrictDragDistance:Number = Math.floor((_progressBarBg.width - _progressBtn.width) &#42; MathUtil.ceilUnit(_player.downloadPercentage, 0.01));
			_progressSeekSlider.restrictDragDistance(restrictDragDistance);
		}
	}
	
	private function sliderMouseInteraction(e:Event):void {
		switch(e.type) {
			case SliderBase.PRESS_SLIDER :
				prevVideoModeStr = _player.mode;
				flag_pressProgressBtn = true;
				flag_ongoingSeek = true;
				
				_player.pause();
			break;	
			
			case SliderBase.DRAG_SLIDER :
				_player.seek(_progressSeekSlider.percentage &#42; _player.duration);
			break;
			
			case SliderBase.RELEASE_SLIDER :
				flag_pressProgressBtn = false;
				_player.seek(_progressSeekSlider.percentage &#42; _player.duration);
				
				switch(prevVideoModeStr) {
					case VideoPlayer.MODE_NONE :
					break;
					
					case VideoPlayer.MODE_INIT :
					break;
					
					case VideoPlayer.MODE_PLAY :
						_player.play();
					break;	
					
					case VideoPlayer.MODE_PAUSE :
					break;
					
					case VideoPlayer.MODE_STOP :
					break;
				}
			break;
		}
	}
	
	private function netStreamHandler(e:Event):void {
		switch(e.type) {
			case VideoPlayer.NETSTREAM_BUFFER_EMPTY :
				//trace("NETSTREAM_BUFFER_EMPTY");
			break;
			
			case VideoPlayer.NETSTREAM_BUFFER_FULL : //progressBtn release + ongoing seek video
				if(flag_pressProgressBtn == false &#38;&#38; flag_ongoingSeek == true) flag_ongoingSeek = false;
			break;
			
			case VideoPlayer.NETSTREAM_BUFFER_FLUSH : //progressBtn release + ongoing seek video
				if(flag_pressProgressBtn == false &#38;&#38; flag_ongoingSeek == true) flag_ongoingSeek = false;
			break;
			
			case VideoPlayer.NETSTREAM_NOT_FOUND : //require change control UI &#38; display UI
				removeProgressCheckTimer();
				_progressSeekSlider.removeMouseInteraction();
			break;
		}
	}
	
	private function videoStatusHandler(e:Event):void {
		switch(e.type) {
			case VideoPlayer.READY_VIDEO_METADATA :
				setInteractionInstance();
			break;
			
			case VideoPlayer.FINISH_VIDEO :
				if(flag_pressProgressBtn) return;
				
				//_player.stop(true); //close download Video File 
				_player.stop(); //continue download Video File
				_playPauseTF.text = "PLAY";
			break;	
			
			case VideoPlayer.START_VIDEO :
				//
			break;
		}
	}
	
	private function volumeSliderMouseInteraction(e:Event):void {
		switch(e.type) {
			case SliderBase.DRAG_SLIDER :
				_player.setVolume(_volumeSlider.percentage);
			break;
			
			case SliderBase.RELEASE_SLIDER :
				_player.setVolume(_volumeSlider.percentage);
			break;
		}
	}
	
	private function panSliderMouseInteraction(e:Event):void {
		switch(e.type) {
			case SliderBase.DRAG_SLIDER :
				_player.setPan(changeSliderPercentageToPanValue(_panSlider.percentage));
				break;
			
			case SliderBase.RELEASE_SLIDER :
				_player.setPan(changeSliderPercentageToPanValue(_panSlider.percentage));
				break;
		}
	}
	
	private function changeSliderPercentageToPanValue(_panSliderPercentage:Number):Number {
		var targetNumber:Number = 0;
		targetNumber = _panSliderPercentage &#42; 2 - 1; //_panSlider percentage value (0 ~ 1) to pan value (-1 ~ 1)
		return targetNumber;
	}
	
	private function _fullScreenViewTFMouseInteraction(e:MouseEvent):void {
		switch(e.type) {
			case MouseEvent.CLICK :
				var screenRectangle:Rectangle = new Rectangle(_player.x, _player.y, 320, 240);
				stage.fullScreenSourceRect = screenRectangle;
				stage.displayState = StageDisplayState.FULL_SCREEN;
			break;
		}
	}
	 *    </listing>
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @author VW, http://www.v-wonderland.com
	 * @since  27.09.2010
	 */	
	public class VideoPlayer extends Sprite implements IControllableObject
	{	
		//========================
		// Variables - video mode
		//========================
		/**
		 * VIDEO MODE - VideoPlayer instance 생성시 or destroy Function 실행 후
		 * @default 
		 */
		static public const MODE_NONE:String = "com.vwonderland.control.video.VideoPlayer.MODE_NONE"; //최초 or Clear() 으로 아무 것도 설정되어 있지 않을 경우
		
		/**
		 * VIDEO MODE - VideoPlayer instance 생성 후, setURL Function 실행으로 play시킬 Video File URL이 할당된 상태
		 * @default 
		 */
		static public const MODE_INIT:String = "com.vwonderland.control.video.VideoPlayer.MODE_INIT"; //setURL() 으로 설정 후, play되지 않는 상태일 경우
		
		/**
		 * VIDEO MODE - setURL Function 실행으로 play시킬 Video File URL이 할당된 후, play Function이 정상적으로 수행된 상태
		 * @default 
		 */
		static public const MODE_PLAY:String = "com.vwonderland.control.video.VideoPlayer.MODE_PLAY";
		
		/**
		 * VIDEO MODE - play Function이 정상적으로 수행된 후, pause Function이 정상적으로 수행된 상태
		 * @default 
		 */
		static public const MODE_PAUSE:String = "com.vwonderland.control.video.VideoPlayer.MODE_PAUSE";
		
		/**
		 * VIDEO MODE - play Function이 정상적으로 수행된 후, stop Function이 정상적으로 수행된 상태
		 * @default 
		 */
		static public const MODE_STOP:String = "com.vwonderland.control.video.VideoPlayer.MODE_STOP";
		
		//========================
		// Variables - event
		//========================
		//EVENT related to VIDEO PLAY
		/**
		 * setURL Function 실행 후, Video File의 MetaData의 duration data 취득시 발생하는 Event입니다.
		 * @default 
		 */
		static public const READY_VIDEO_METADATA:String = "com.vwonderland.control.video.VideoPlayer.READY_VIDEO_METADATA"; //metadata duration data 취득시 발생
		
		/**
		 * Video mode(MODE_NONE, MODE_INIT, MODE_PLAY, MODE_PAUSE, MODE_STOP)의 변경시 발생하는 Event입니다.
		 * @default 
		 */
		static public const CHANGE_VIDEO_MODE:String = "com.vwonderland.control.video.VideoPlayer.CHANGE_VIDEO_MODE";
		
		/**
		 * 화면에 표시되는 video File의 image가 지워질 때 발생하는 Event입니다.
		 * @default 
		 */
		static public const CLEAR_VIDEO:String = "com.vwonderland.control.video.VideoPlayer.CLEAR_VIDEO"; //video 화면이 지워질 때 발생
		
		/**
		 * NetStatusEvent의 NetStream.Play.Start info Code 출력시 발생하는 Event입니다.
		 * @default 
		 */
		static public const START_VIDEO:String = "com.vwonderland.control.video.VideoPlayer.START_VIDEO";
		
		/**
		 * NetStatusEvent의 NetStream.Play.Stop info Code 출력시 발생하는 Event입니다.
		 * @default 
		 */
		static public const FINISH_VIDEO:String = "com.vwonderland.control.video.VideoPlayer.FINISH_VIDEO";
		
		/**
		 * Video File의  MetaData의 duration data 취득과 download 완료, 두 조건의 충족시 발생하는 Event입니다. 
		 * @default 
		 */
		static public const COMPLETE_LOAD_VIDEO:String = "com.vwonderland.control.video.VideoPlayer.COMPLETE_LOAD_VIDEO";
		
		/**
		 * Video File의 download 진행시 발생하는 Event입니다.
		 * @default 
		 */
		static public const PROGRESS_LOAD_VIDEO:String = "com.vwonderland.control.video.VideoPlayer.PROGRESS_LOAD_VIDEO";
		
		//ERROR EVENT
		/**
		 * 기본 비동기 코드에서 비동기적으로 예외 발생시 전달되는 Event입니다. 서버가 정의되지 않은 클라이언트에 대한 메서드를 호출할 때 이 Event가 전달됩니다.
		 * @default 
		 */
		static public const ASYNC_ERROR:String = "com.vwonderland.control.video.VideoPlayer.ASYNC_ERROR";
		
		//OPTION CONNECT STATUS CHECK EVENT
		/**
		 * NetStatusEvent의 NetConnection.Connect.Failed info Code 출력시(Video File을 재생하기 위한 connection 연결 시도에 실패한 경우) 발생하는 Event입니다.
		 * @default 
		 */
		static public const NETCONNECTION_CONNECT_FAIL:String = "com.vwonderland.control.video.VideoPlayer.NETCONNECTION_CONNECT_FAIL";
		
		/**
		 * NetStatusEvent의 NetConnection.Connect.Closed info Code 출력시(Video File을 재생하기 위한 connection 연결이 성공적으로 종료된 경우) 발생하는 Event입니다.
		 * @default 
		 */
		static public const NETCONNECTION_CONNECT_CLOSED:String = "com.vwonderland.control.video.VideoPlayer.NETCONNECTION_CONNECT_CLOSED";
		
		/**
		 * NetStatusEvent의 NetConnection.Connect.Rejected info Code 출력시(Video File을 재생하기 위한 connection 연결 시도에  해당 프로그램에 대한 액세스 권한이 없을 경우) 발생하는 Event입니다.
		 * @default 
		 */
		static public const NETCONNECTION_CONNECT_REJECTED:String = "com.vwonderland.control.video.VideoPlayer.NETCONNECTION_CONNECT_REJECTED";
		
		//OPTION EVENT
		/**
		 * NetStatusEvent의 NetStream.Play.StreamNotFound info Code 출력시(play Function 실행 후, 재생할 video File을 찾을 수 없을 경우) 발생하는 Event입니다 
		 * @default 
		 */
		static public const NETSTREAM_NOT_FOUND:String = "com.vwonderland.control.video.VideoPlayer.NETSTREAM_NOT_FOUND";
		
		/**
		 * NetStatusEvent의 NetStream.Buffer.Empty info Code 출력시(buffer를 채우기에 충분할만큼 신속하게 data가 수신되지 않을 경우이며, NETSTREAM_BUFFER_FULL Event를 추가로 발생시키고 buffer가 채워질 때까지 데이터 흐름을 중단) 발생하는 Event입니다.
		 * @default 
		 */
		static public const NETSTREAM_BUFFER_EMPTY:String = "com.vwonderland.control.video.VideoPlayer.NETSTREAM_BUFFER_EMPTY";
		
		/**
		 * NetStatusEvent의 NetStream.Buffer.Empty info Code 출력시(buffer가 채워지고 stream이 Video File의 재생을 시작할 경우) 발생하는 Event입니다.
		 * @default 
		 */
		static public const NETSTREAM_BUFFER_FULL:String = "com.vwonderland.control.video.VideoPlayer.NETSTREAM_BUFFER_FULL";
		
		/**
		 * NetStatusEvent의 NetStream.Buffer.Flush info Code 출력시(data의 stream이 완료되어 남아 있는 buffer가 비워질 경우) 발생하는 Event입니다.
		 * @default 
		 */
		static public const NETSTREAM_BUFFER_FLUSH:String = "com.vwonderland.control.video.VideoPlayer.NETSTREAM_BUFFER_FLUSH";
		
		/**
		 * NetStatusEvent의 NetStream.Seek.Notify info Code 출력시(seek Function을 이용한 Video File의 keyFrame 검색이 완료되었을 경우) 발생하는 Event입니다.
		 * @default 
		 */
		static public const NETSTREAM_SEEK_NOTIFY:String = "com.vwonderland.control.video.VideoPlayer.NETSTREAM_SEEK_NOTIFY";
		
		/**
		 * NetStatusEvent의 NetStream.Seek.InvalidTime info Code 출력시(seek Function을 이용한 Video File의 keyFrame 검색시, 현재까지 download된 Video data의 끝 부분을 지나서 검색 or 재생하려고 했을 경우) 발생하는 Event입니다.
		 * @default 
		 */
		static public const NETSTREAM_SEEK_INVALIDTIME:String = "com.vwonderland.control.video.VideoPlayer.NETSTREAM_SEEK_INVALIDTIME";
		
		/**
		 * NetStatusEvent의 NetStream.Play.NoSupportedTrackFound info Code 출력시(setURL Function으로 할당된 File이 재생 불가능한 File일 경우) 발생하는 Event입니다.
		 * @default 
		 */
		static public const NETSTREAM_PLAY_NOSUPPORTEDTRACKFOUND:String = "com.vwonderland.control.video.VideoPlayer.NETSTREAM_PLAY_NOSUPPORTEDTRACKFOUND";
		
		//========================
		// Variables
		//========================
		/** extra Variable*/
		public var extraObject:Object;
		
		/**
		 * Indicates Order variable
		 * @return int
		 */
		public function get index():int {
			return idx;
		}
		
		/** @private */
		public function set index(_value:int):void {
			idx=_value;
		}
		
		/**
		 * netStream instance 반환
		 * @return NetStream
		 */
		public function	get netStream():NetStream {
			return _netStream;
		}
		
		/**
		 * Video File의 download percentage(netStream bytesLoaded / netStream bytesTotal) 반환 
		 * @return Number
		 */
		public function	get downloadPercentage():Number {
			return _downloadPercentage;
		}
		
		/**
		 * Video File의 재생 시간 대비 재생 시점에 대한 progress percentage(netStream time / metadata duration) 반환 
		 * @return Number
		 */
		public function	get progressPercentage():Number {
			return _progressPercentage;
		}
		
		/**
		 * 현재 Video mode(MODE_NONE, MODE_INIT, MODE_PLAY, MODE_PAUSE, MODE_STOP) 반환
		 * @return String
		 */
		public function	get mode():String {
			return videoMode;
		}
		
		/**
		 * sound mute 상태 반환
		 * @return Boolean
		 */
		public function	get muteStatus():Boolean {
			return flag_mute;
		}
		
		/**
		 * Video File 재생 헤드의 second 단위 위치 (netStream time) 반환
		 * @return Number
		 */
		public function	get time():Number {
			return _time; 
		}
		
		/**
		 * Video File의 현재까지 download되어  재생 가능한 duration time(downloadPercentage / metadata duration) 반환
		 * @return Number
		 */
		public function	get downloadTime():Number {
			return _downloadTime;
		}
		
		/**
		 * Video File의 재생 시간(metadata duration) 반환
		 * @return Number
		 */
		public function	get duration():Number {
			return _duration;
		}
		
		/**
		 * Video의 width value 반환
		 * @return int
		 */
		public function	get videoWidth():int {
			return _videoWidth;
		}
		
		/**
		 * Video의 width value 변환
		 */
		public function	set videoWidth(_value:int):void {
			if(_video != null) {
				_video.width = _value;
				_videoWidth = _value;
			}
		}
		
		/**
		 * Video의 height value 반환
		 * @return int
		 */
		public function	get videoHeight():int {
			return _videoHeight;
		}
		
		/**
		 * Video의 height value 변환
		 */
		public function	set videoHeight(_value:int):void {
			if(_video != null) {
				_video.height = _value;
				_videoHeight = _value;
			}
		}
		
		/**
		 * metaData Object 반환
		 * @return Object
		 */
		public function	get metaData():Object {
			return _metaData;
		}
		
		/**
		 * @private
		 * order Variable
		 */
		private var idx:int;
		
		private var _video:Video;
		private var _videoWidth:Number;
		private var _videoHeight:Number;
		
		private var _netConnection:NetConnection;
		private var _netStream:NetStream;
		private var _progressStatusCheckObj:Sprite;
		private var _soundTransform:SoundTransform;
		private var _metaData:*;
		private var _netStreamClient:*;
		
		private var flag_checkPolicyFile:Boolean = false; //crossdomain 정책 파일 로드 여부
		private var existDuration:Boolean = false; //metaData에 duration 정보 존재 여부
		private var _duration:Number = 0;
		private var _downloadPercentage:Number = 0;
		private var _progressPercentage:Number = 0;
		private var _downloadTime:Number = 0;
		private var _time:Number = 0;
		
		private var flag_existPlayBreakdown:Boolean = false; //Video File play 내역 존재 여부
		private var videoURL:String;
		private var videoMode:String = MODE_NONE;
		
		private var flag_completeLoadVideoFile:Boolean = false; //Video File download 완료 여부
		private var flag_assignVideoURL:Boolean = false; //setURL Function 실행으로 play시킬 videoURL의 할당 여부
		private var flag_mute:Boolean = false; //mute 상태 여부
		private var soundVolume:Number;
		
		//==================
		// Public function
		//==================
		/** destroy VideoPlayer instance
		 *  @param _obj  destroy extra Object variable
		 *  @see #init()
		 */
		public function destroy(_obj:Object = null):void {
			clearVideo();
			if(_netStream != null) {
				_netStream.removeEventListener(NetStatusEvent.NET_STATUS, netStreamHandler);
				_netStream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				_netStream = null;
			}
			if(_netConnection != null) {
				_netConnection.close();
				_netConnection.removeEventListener(NetStatusEvent.NET_STATUS, netConnectionHandler);
				_netConnection = null;
			}
			if(_netStreamClient != null) {
				delete _netStreamClient.onMetaData;
				_netStreamClient = null;
			}
			if(_video != null) {
				if(this.contains(_video)) this.removeChild(_video);
			}
			_progressStatusCheckObj = null;
			_soundTransform = null;
			_metaData = null;
		}
		
		/** extra initialize Function.
		 *  need to use override.
		 *  @param _obj  initialize extra Object variable
		 *  @see #destroy()
		 */
		public function init(_obj:Object=null):void
		{
			//override extra initialization 
		}
		
		/**
		 * play시킬 Video File URL 및 play option setting
		 * @param _videoURL				Video File(FLV, F4V, etc format) URL to play
		 * @param _bufferSecond			Video buffer second (video File이 중단없이 재생되기 위한 stream buffer time)  
		 * @param _smoothing			Video smoothing option
		 * @param _preventCache			Video File load시에 cache data의 사용을 방지할 경우, true 설정(Local 위치에 존재하는 Video File 사용시, false 설정 필요)
		 * @param _preventAutoDownload	Video File 자동 download 사용을 방지할 경우, true 설정
		 * @param _checkPolicyFile		Video File load 시작 전, 서버로부터 crossdomain 정책 파일을 load해야 할지의 여부(swf 파일의 도메인 외부에서 Video File을 load하고 있으며, BitmapData.draw() 메서드를 사용하여 Video File에 pixel 수준으로 액세스해야 하는 경우입니다.)
		 */
		public function	setURL(_videoURL:String, _bufferSecond:Number = 0.1, _smoothing:Boolean = false, _preventCache:Boolean = false, _preventAutoDownload:Boolean = false, _checkPolicyFile:Boolean = false):void {
			if(_netStream == null) {
				trace("[com.vwonderland.control.video.VideoPlayer] NetStream 객체가 존재하지 않아 setURL Function을 수행할 수 없습니다. 기존 VideoPlayer Instance를 삭제하고, VideoPlayer Instance를 재생성하여 사용하시기 바랍니다.");
				return;
			}
			clearVideo();
			if(_video != null) _video.smoothing = _smoothing;
			
			_netStream.bufferTime = _bufferSecond;
			_netStream.checkPolicyFile = flag_checkPolicyFile = _checkPolicyFile;
			
			var _changedURL:String;
			if (_preventCache) {
				if (_videoURL.indexOf("?") == -1) _changedURL = _videoURL + "?tempCache="+(new Date()).getTime();
				else _changedURL = _videoURL + "&tempCache="+(new Date()).getTime();
			} else _changedURL = _videoURL;
			videoURL = _changedURL;
			
			if(_preventAutoDownload) {
			}else{
				_netStream.play(videoURL);
				_netStream.pause();
				
				flag_existPlayBreakdown = true;
				if(_progressStatusCheckObj != null) startProgressStatusCheckProcess();
			}
			flag_assignVideoURL = true;
			videoMode = MODE_INIT;
			dispatchEvent(new Event(CHANGE_VIDEO_MODE));	
		}
		
		/**
		 * sound mute status setting
		 * @param _flag_mute	true 설정시 mute on, false 설정시 mute off
		 * @see #setVolume()
		 * @see #setPan()
		 */
		public function	setMute(_flag_mute:Boolean = false):void {
			flag_mute = _flag_mute;
			if(_flag_mute) {
				setVolumeDetail(0);
			}else{
				setVolumeDetail(soundVolume);
			}
		}
		
		/**
		 * sound volume setting
		 * @param _volume	0 ~ 1 사이의 sound volume
		 * @see #setMute()
		 * @see #setPan()
		 */
		public function	setVolume(_volume:Number):void {
			if(_soundTransform != null) {
				if(_volume < 0 || _volume > 1) {
					trace("[com.vwonderland.control.video.VideoPlayer] volume value는 0 ~ 1 의 값을 가져야 합니다. setVolume Function은 수행할 수 없습니다.");
					return;
				}
				soundVolume = _volume;
				
				if(flag_mute){
					trace("[com.vwonderland.control.video.VideoPlayer] volume value는 변경되었으나, mute 상태입니다.");
					setVolumeDetail(0);
				}else{
					setVolumeDetail(soundVolume);
				}
			}
		}
		
		/**
		 * speaker sound panning setting
		 * @param _pan		-1 ~ 1 사이의 speaker panning value
		 * @see #setMute()
		 * @see #setVolume()
		 */
		public function	setPan(_pan:Number):void {
			if(_pan < -1 || _pan > 1) {
				trace("[com.vwonderland.control.video.VideoPlayer] pan value는 -1 ~ 1 의 값을 가져야 합니다. setPan Function은 수행할 수 없습니다.");
				return;
			}
			_soundTransform.pan = _pan;
			_netStream.soundTransform = _soundTransform;
		}
		
		/**
		 * play Video File
		 * @see #pause()
		 * @see #stop()
		 */
		public function	play():void {
			if(!flag_assignVideoURL) {
				trace("[com.vwonderland.control.video.VideoPlayer] setURL Function을 통한 Video File의 URL이 할당되지 않아, play Function은 수행할 수 없습니다.");
				return;
			}
			if(!flag_existPlayBreakdown) {
				flag_existPlayBreakdown = true;
				_netStream.play(videoURL);
				if(_progressStatusCheckObj != null) startProgressStatusCheckProcess();
			}else{
				_netStream.resume(); 
			}
			videoMode = MODE_PLAY;
			dispatchEvent(new Event(CHANGE_VIDEO_MODE));
		}
		
		/**
		 * pause Video File
		 * @see #play()
		 * @see #stop()
		 */
		public function	pause():void {
			if(!flag_assignVideoURL) {
				trace("[com.vwonderland.control.video.VideoPlayer] setURL Function을 통한 Video File의 URL이 할당되지 않아, pause Function은 수행할 수 없습니다.");
				return;
			}
			if(!flag_existPlayBreakdown) {
				trace("[com.vwonderland.control.video.VideoPlayer] play Function을 통한 Video File의 재생이 수행되지 않아, pause Function은 수행할 수 없습니다.");
				return;
			}
			_netStream.pause();
			
			videoMode = MODE_PAUSE;
			dispatchEvent(new Event(CHANGE_VIDEO_MODE));
		}
		
		/**
		 * stop Video File
		 * @see #play()
		 * @see #pause()
		 * @param _closeAutoDownload	Video File의 download를 정지시키고 video 이미지를 지울 경우, true 설정
		 */
		public function	stop(_closeAutoDownload:Boolean = false):void {
			if(!flag_assignVideoURL) {
				trace("[com.vwonderland.control.video.VideoPlayer] setURL Function을 통한 Video File의 URL이 할당되지 않아, stop Function은 수행할 수 없습니다.");
				return;
			}
			if(!flag_existPlayBreakdown) {
				trace("[com.vwonderland.control.video.VideoPlayer] play Function을 통한 Video File의 재생이 수행되지 않아, stop Function은 수행할 수 없습니다.");
				return;
			}
			if(_closeAutoDownload) {
				stopProgressStatusCheckProcess();
				if(_netStream != null) _netStream.close();
				if(_video != null) _video.clear();
				
				//existDuration
				//_duration 
				_downloadPercentage = 0;
				_progressPercentage = 0;
				_downloadTime = 0;
				_time = 0;
				flag_existPlayBreakdown = false;
				flag_completeLoadVideoFile = false;
				//flag_assignVideoURL
				
				dispatchEvent(new Event(CLEAR_VIDEO));
			}else{
				_netStream.pause();
				_netStream.seek(0);
			}
			videoMode = MODE_STOP;
			dispatchEvent(new Event(CHANGE_VIDEO_MODE));
		}
		
		/**
		 * seek Video File's keyFrame 	(지정한 _seekTime과 가장 가까운 keyFrame의 검색)
		 * @param _seekTime		Video File에서 이동할 근사적인 시간(second) 값 
		 */
		public function	seek(_seekTime:Number):void {
			if(!flag_assignVideoURL) {
				trace("[com.vwonderland.control.video.VideoPlayer] setURL Function을 통한 video File의 URL이 할당되지 않아, seek Function은 수행할 수 없습니다.");
				return;
			}
			if(_metaData == null) {
				trace("[com.vwonderland.control.video.VideoPlayer] video File의 metaData 정보가 취득되기 전에 seek Function이 수행되어 duration 정보의 취득이 불가합니다.");
				return;
			}
			_netStream.seek(_seekTime);
		}
		
		//================
		// Constructor
		//================
		/**
		 * Constructor
		 * @param _width	Video width
		 * @param _height	Video height
		 */
		public function VideoPlayer(_width:Number = 320, _height:Number = 240) 
		{
			_progressStatusCheckObj = new Sprite();
			_video = new Video(_width, _height);
			this.addChild(_video);
			
			_videoWidth = _width;
			_videoHeight = _height;
			
			_netConnection = new NetConnection();
			_netConnection.addEventListener(NetStatusEvent.NET_STATUS, netConnectionHandler);
			_netConnection.connect(null);
		}
		
		/**
		 * 
		 * @param e
		 */
		protected function netConnectionHandler(e:NetStatusEvent):void
		{
			//trace("e.info.code :", e.info.code);
			switch( e.info.code )
			{
				case "NetConnection.Connect.Success":
					connectStream();
				break;
				
				case "NetConnection.Connect.Failed":
					trace("[com.vwonderland.control.video.VideoPlayer] 연결 시도에 실패했습니다. NETCONNECTION_CONNECT_FAIL Event가 발생합니다.");
					dispatchEvent(new Event(NETCONNECTION_CONNECT_FAIL));
				break;
				
				case "NetConnection.Connect.Closed":
					trace("[com.vwonderland.control.video.VideoPlayer] 연결이 성공적으로 종료되었습니다. NETCONNECTION_CONNECT_CLOSED Event가 발생합니다.");
					dispatchEvent(new Event(NETCONNECTION_CONNECT_CLOSED));
				break;
				
				case "NetConnection.Connect.Rejected":
					trace("[com.vwonderland.control.video.VideoPlayer] 연결 시도에 대한 해당 응용 프로그램에 대한 액세스 권한이 없습니다. NETCONNECTION_CONNECT_REJECTED Event가 발생합니다.");
					dispatchEvent(new Event(NETCONNECTION_CONNECT_REJECTED));
				break;
			}
		}
		
		/**
		 * 
		 */
		protected function connectStream():void
		{
			_netStream = new NetStream(_netConnection);
			_netStream.addEventListener( NetStatusEvent.NET_STATUS, netStreamHandler );
			_netStream.addEventListener( AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler );
			
			_netStreamClient = new Object();
			_netStreamClient.onMetaData = onMetaDataHandler;
			_netStream.client = _netStreamClient;
			
			_soundTransform = new SoundTransform();
			_netStream.soundTransform = _soundTransform;
			soundVolume = _soundTransform.volume;
			
			_video.attachNetStream(_netStream);
		}
		
		/**
		 * 
		 * @param e
		 */
		protected function netStreamHandler(e:NetStatusEvent):void 
		{
			//trace("e.info.code :", e.info.code);
			switch( e.info.code ) {
				case "NetStream.Play.StreamNotFound":
					trace("[com.vwonderland.control.video.VideoPlayer] 재생할 Video File을 찾을 수 없습니다. Video Stream의 모든 데이터 재생을 중단하며, NETSTREAM_NOT_FOUND Event가 발생합니다.");
					stop(true);
					dispatchEvent(new Event(NETSTREAM_NOT_FOUND)); //play() 메서드에 전달된 FLV 파일을 찾을 수 없습니다.
				break;
				
				case "NetStream.Play.Start":
					dispatchEvent(new Event(START_VIDEO)); //재생이 시작되었습니다.
				break;
				
				case "NetStream.Play.Stop":
					dispatchEvent(new Event(FINISH_VIDEO));	//재생이 중지되었습니다.
				break;
				
				case "NetStream.Buffer.Empty" :
					dispatchEvent(new Event(NETSTREAM_BUFFER_EMPTY)); //버퍼를 채우기에 충분할 만큼 신속하게 데이터가 수신되지 않습니다. NetStream.Buffer.Full 메시지가 전송되고 스트림이 다시 재생을 시작할 때까지 즉, 버퍼가 다시 채워질 때까지 데이터 흐름이 중단됩니다.
				break;
				
				case "NetStream.Buffer.Full" :
					dispatchEvent(new Event(NETSTREAM_BUFFER_FULL)); //버퍼가 채워지고 스트림이 재생을 시작합니다.
				break;
				
				case "NetStream.Buffer.Flush" :
					dispatchEvent(new Event(NETSTREAM_BUFFER_FLUSH)); //데이터의 스트림이 완료되었고 남아 있는 버퍼가 비워집니다.
				break;
				
				case "NetStream.Seek.Notify" :
					dispatchEvent(new Event(NETSTREAM_SEEK_NOTIFY)); //검색 작업이 완료되었습니다.
				break;
				
				case "NetStream.Seek.InvalidTime" :
					trace("[com.vwonderland.control.video.VideoPlayer] 현재까지 다운로드된 Video 데이터의 끝 부분을 지나서 검색 or 재생하려고 했습니다. NETSTREAM_SEEK_INVALIDTIME Event가 발생합니다.");
					dispatchEvent(new Event(NETSTREAM_SEEK_INVALIDTIME)); //점진적 다운로드를 통해 다운로드된 비디오에 대해 사용자가 지금까지 다운로드된 비디오 데이터의 끝 부분을 지나서 검색 또는 재생하려고 했거나, 전체 파일이 다운로드된 이후에 비디오 끝 부분을 지나서 검색 또는 재생하려고 했습니다. 
				break;	
				
				case "NetStream.Play.NoSupportedTrackFound" :
					trace("[com.vwonderland.control.video.VideoPlayer] 응용 프로그램이 지원되는 추적(Video, Audio, Data)을 감지하지 않으며 해당 File을 재생하지 않습니다. AIR 및 Flash Player 9.0.115.0 이상에서 사용됩니다. NETSTREAM_PLAY_NOSUPPORTEDTRACKFOUND Event를 발생합니다.");
					dispatchEvent(new Event(NETSTREAM_PLAY_NOSUPPORTEDTRACKFOUND)); //응용 프로그램이 지원되는 추적(비디오, 오디오 또는 데이터)을 감지하지 않으며 해당 파일을 재생하지 않습니다. AIR 및 Flash Player 9.0.115.0 이상에서 사용됩니다.
				break;
			}
		}
		
		private function asyncErrorHandler(e:AsyncErrorEvent):void
		{
			trace("[com.vwonderland.control.video.VideoPlayer] 비동기 오류가 발생하였습니다. ASYNC_ERROR Event가 발생합니다.");
			dispatchEvent(new Event(ASYNC_ERROR));
		}
		
		/**
		 * 
		 * @param _data
		 */
		protected function onMetaDataHandler(_data:Object):void {
			_metaData = _data;
			for( var property:String in _metaData ) trace("[com.vwonderland.control.video.VideoPlayer] video metaData -", property, ":", _metaData[property]);
			if(_metaData != null) {
				if(_metaData.duration != null) {
					_duration = _metaData.duration;
					
					if(existDuration) return;
					existDuration = true;
					dispatchEvent(new Event(READY_VIDEO_METADATA));
				}
			}
		}
		
		private function setVolumeDetail(_volume:Number):void {
			_soundTransform.volume = _volume;
			_netStream.soundTransform = _soundTransform;
		}
		
		private function startProgressStatusCheckProcess():void {
			if(_progressStatusCheckObj.hasEventListener(Event.ENTER_FRAME)) return;
			_progressStatusCheckObj.addEventListener(Event.ENTER_FRAME, progressStatusCheckHandler);
		}
		
		private function stopProgressStatusCheckProcess():void {
			_progressStatusCheckObj.removeEventListener(Event.ENTER_FRAME, progressStatusCheckHandler);
		}
		
		/**
		 * 
		 * @param e
		 */
		protected function progressStatusCheckHandler(e:Event = null):void {
			if(_netStream != null) {
				if(_duration <= 0 || _netStream.time <= 0) {
					_time = 0;
					_progressPercentage = 0;
				}else{
					_time = _netStream.time;
					_progressPercentage = _time / _duration;
					if(_progressPercentage >= 1) _progressPercentage = 1;
				}
				if(_netStream.bytesTotal <= 0 || _netStream.bytesLoaded <= 0) {
					_downloadTime = 0;
					_downloadPercentage = 0;
				}else{
					if(_downloadPercentage >= 1 && _duration > 0) {
						if(flag_completeLoadVideoFile) return;
						flag_completeLoadVideoFile = true;
						_downloadTime = _duration;
						_downloadPercentage = 1;
						dispatchEvent(new Event(COMPLETE_LOAD_VIDEO));
						return;
					}
					_downloadPercentage = _netStream.bytesLoaded / _netStream.bytesTotal;
					_downloadTime = _downloadPercentage * _duration;
				}
				if(flag_completeLoadVideoFile) return;
				dispatchEvent(new Event(PROGRESS_LOAD_VIDEO));
			}
		}
		
		/**
		 * 
		 */
		protected function clearVideo():void {
			stopProgressStatusCheckProcess();
			if(_netStream != null) {
				_netStream.close();
				_netStream.checkPolicyFile = false;
			}
			if(_video != null) _video.clear();
			
			flag_checkPolicyFile = false;
			existDuration = false;
			_duration = 0;
			_downloadPercentage = 0;
			_progressPercentage = 0;
			_downloadTime = 0;
			_time = 0;
			
			flag_existPlayBreakdown = false;
			videoURL = "";
			videoMode = MODE_NONE;
			
			flag_completeLoadVideoFile = false;
			flag_assignVideoURL = false;
			//flag_mute
			
			dispatchEvent(new Event(CHANGE_VIDEO_MODE));
			dispatchEvent(new Event(CLEAR_VIDEO));
		}
	}
}