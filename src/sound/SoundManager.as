package sound{

	import flash.events.Event;
	import flash.media.AudioPlaybackMode;
	import flash.media.SoundMixer;

	public class SoundManager {
		
		private static var mInstance:SoundManager;

		private var muted:Boolean;

		private var bossSound:OduncuSound;
		private var testereCleanSound:OduncuSound;
		private var testereTurnOnSound:OduncuSound;
		private var testereHitSound:OduncuSound;
		private var agacWalkSound:OduncuSound;

		public function SoundManager() {
			if (mInstance) {
				return;
			}
			muted = false;
			SoundMixer.audioPlaybackMode = AudioPlaybackMode.AMBIENT;
			bossSound = new OduncuSound(new bossSoundObject(),0.8);
			testereCleanSound = new OduncuSound(new testereCleanSoundObject(),0.4);
			testereTurnOnSound = new OduncuSound(new testereTurnOnSoundObject(),0.4);
			testereHitSound = new OduncuSound(new testereHitSoundObject(),0.4);
			agacWalkSound = new OduncuSound(new agacWalkSoundObject(),0.4);
		}
		
		public static function get instance():SoundManager {
			if (!mInstance) {
				mInstance = new SoundManager();
			}
			return mInstance;
		}

		public function reset() : void {
			bossSound.stopPlaying();
			testereCleanSound.stopPlaying();
			testereTurnOnSound.stopPlaying();
			testereHitSound.stopPlaying();
			agacWalkSound.stopPlaying();
			setMuted(isMuted());
		}

		public function playBossSound() : void {
			bossSound.startPlaying(0,999);
			setMuted(isMuted());
		}

		public function stopBossSound(): void {
			bossSound.stopPlaying();
		}

		public function playTestereCleanSound(): void {
			testereCleanSound.startPlaying(0,999);
			setMuted(isMuted());
		}

		public function stopTestereCleanSound(): void {
			testereCleanSound.stopPlaying();
		}

		private function handleTestereComplete(event:Event): void {
			playTestereCleanSound();
		}

		public function playTestereTurnOnSound(): void {
			testereTurnOnSound.startPlaying();
			setMuted(isMuted());
		}

		public function playTestereHitSound(): void {
			//testereHitSound.stopPlaying();
			if(!testereHitSound.isPlaying()) {
			testereHitSound.startPlaying();
			setMuted(isMuted());
			}
		}

		public function playAgacWalkSound(): void {
			agacWalkSound.startPlaying(0,999);
			setMuted(isMuted());
		}

		public function stopAgacWalkSound(): void {
			agacWalkSound.stopPlaying();
		}

		public function isAgacPlaying():Boolean {
			return agacWalkSound.isPlaying();
		}

		public function isMuted():Boolean {
			return muted;
		}

		public function setMuted(muted_in:Boolean): void {
			muted = muted_in;
			if (muted == false) {
				bossSound.unmute();
				testereTurnOnSound.unmute();
				testereCleanSound.unmute();
				testereHitSound.unmute();
				agacWalkSound.unmute();
			} else {
				bossSound.mute();
				testereTurnOnSound.mute();
				testereCleanSound.mute();
				testereHitSound.mute();
				agacWalkSound.mute();
			}
		}

		public function pauseAll(): void {
			bossSound.pause();
			testereTurnOnSound.pause();
			testereCleanSound.pause();
			testereHitSound.pause();
			agacWalkSound.pause();
		}

		public function unpauseAll(): void {
			bossSound.unpause();
			testereTurnOnSound.unpause();
			testereCleanSound.unpause();
			testereHitSound.unpause();
			agacWalkSound.unpause();
			setMuted(isMuted());
		}

	}

}