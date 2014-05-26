package sound {
	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	public class OduncuSound {
		
		private var soundVolume:Number;
		private var soundControl:SoundChannel;
		private var isplaying:Boolean;
		private var muted:Boolean;
		private var position:Number;
		private var ispaused:Boolean;
		private var playcount:Number;
		
		private var _sound:Sound
		
		public function OduncuSound(sound:Sound, soundvolume:Number) {
			super();
			_sound = sound;
			soundControl = new SoundChannel();
			setVolume(soundvolume);
			isplaying = false;
			muted = false;
			ispaused = false;
			position = 0;
			playcount = 0;
		}
		
		public function setVolume(sv:Number):void {
			soundVolume = sv;
			soundControl.soundTransform = new SoundTransform(soundVolume);
		}
		
		public function getVolume():Number {
			return soundVolume;
		}
		
		public function stopPlaying():void {
			ispaused = false;
			isplaying = false;
			position = 0;
			soundControl.stop();
		}
		
		public function startPlaying(starttime:Number = 0, playcount_in:Number = 1):void {
			soundControl = new SoundChannel();
			soundControl = _sound.play(starttime, playcount_in);
			isplaying = true;
			playcount = playcount_in;
		}
		
		public function mute():void {
			if (soundControl == null) {
				soundControl = new SoundChannel();
			}
			soundControl.soundTransform = new SoundTransform(0);
			muted = true;
		}
		
		public function unmute():void {
			if (soundControl == null) {
				soundControl = new SoundChannel();
			}
			soundControl.soundTransform = new SoundTransform(soundVolume);
			muted = false;
		}
		
		public function pause():void {
			if (isPlaying()) {
				ispaused = true;
				if (soundControl.position > 0) {
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
	
	}

}