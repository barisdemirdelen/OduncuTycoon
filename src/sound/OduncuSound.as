package sound {
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	public class OduncuSound {
		
		private var soundVolume:Number;
		private var _soundControl:SoundChannel;
		private var isplaying:Boolean;
		private var muted:Boolean;
		private var position:Number;
		private var ispaused:Boolean;
		private var playcount:Number;
		
		private var _sound:Sound;
		
		public function OduncuSound(sound:Sound, soundvolume:Number) {
			super();
			_sound = sound;
			_soundControl = new SoundChannel();
			_soundControl.addEventListener(Event.SOUND_COMPLETE, onComplete);
			setVolume(soundvolume);
			isplaying = false;
			muted = false;
			ispaused = false;
			position = 0;
			playcount = 0;
		}
		
		private function onComplete(e:Event):void {
			soundControl.removeEventListener(Event.SOUND_COMPLETE, onComplete);
			isplaying = false;
		}
		
		public function setVolume(sv:Number):void {
			soundVolume = sv;
			_soundControl.soundTransform = new SoundTransform(soundVolume);
		}
		
		public function getVolume():Number {
			return soundVolume;
		}
		
		public function stopPlaying():void {
			ispaused = false;
			isplaying = false;
			position = 0;
			_soundControl.stop();
		}
		
		public function startPlaying(starttime:Number = 0, playcount_in:Number = 1):void {
			_soundControl = _sound.play(starttime, playcount_in);
			_soundControl.addEventListener(Event.SOUND_COMPLETE, onComplete);
			isplaying = true;
			playcount = playcount_in;
		}
		
		public function mute():void {
			if (_soundControl == null) {
				_soundControl = new SoundChannel();
				_soundControl.addEventListener(Event.SOUND_COMPLETE, onComplete);
			}
			_soundControl.soundTransform = new SoundTransform(0);
			muted = true;
		}
		
		public function unmute():void {
			if (_soundControl == null) {
				_soundControl = new SoundChannel();
				_soundControl.addEventListener(Event.SOUND_COMPLETE, onComplete);
			}
			soundControl.soundTransform = new SoundTransform(soundVolume);
			muted = false;
		}
		
		public function pause():void {
			if (isPlaying()) {
				ispaused = true;
				if (_soundControl.position > 0) {
					position = soundControl.position;
				} else {
					position = 0;
				}
				stopPlaying();
			}
		}
		
		public function unpause():void {
			if (isPaused()) {
				ispaused = false;
				startPlaying(position, playcount);
			}
		}
		
		public function isPlaying():Boolean {
			return isplaying;
		}
		
		public function isMuted():Boolean {
			return muted;
		}
		
		public function isPaused():Boolean {
			return ispaused;
		}
		
		public function get soundControl():SoundChannel {
			return _soundControl;
		}
		
		public function get sound():Sound {
			return _sound;
		}
	
	}

}