package {
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import sound.SoundManager;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class MainMenuManager extends BurgerManager {
		
		private var _mainMenu:MovieClip;
		private var _startButton:SimpleButton;
		private var _highScoreButton:SimpleButton;
		private var _achievementButton:SimpleButton;
		private var _oynakTimer:Timer;
		
		public function MainMenuManager(callBack:Function) {
			super(callBack);
		}
		
		override protected function init():void {
			super.init();
			FlashStageHelper.stage.frameRate = 30;
			_mainMenu = new mainMenuSprite();
			FlashStageHelper.add(_mainMenu);
			
			_startButton = _mainMenu.getChildByName("startButton") as SimpleButton;
			_startButton.addEventListener(TouchEvent.TOUCH_TAP, onStartClick);
			_startButton.addEventListener(MouseEvent.CLICK, onStartClick);
			
			_highScoreButton = _mainMenu.getChildByName("highScores") as SimpleButton;
			_highScoreButton.addEventListener(TouchEvent.TOUCH_TAP, onHighScoresClick);
			_highScoreButton.addEventListener(MouseEvent.CLICK, onHighScoresClick);
			
			_achievementButton = _mainMenu.getChildByName("achievements") as SimpleButton;
			_achievementButton.addEventListener(TouchEvent.TOUCH_TAP, onAchievementClick);
			_achievementButton.addEventListener(MouseEvent.CLICK, onAchievementClick);
			
			(_highScoreButton.upState as TextField).text = LocaleUtil.localize("highScores");
			(_highScoreButton.overState as TextField).text = LocaleUtil.localize("highScores");
			(_highScoreButton.downState as TextField).text = LocaleUtil.localize("highScores");
			(_highScoreButton.hitTestState as TextField).text = LocaleUtil.localize("highScores");
			
			(_achievementButton.upState as TextField).text = LocaleUtil.localize("achievements");
			(_achievementButton.overState as TextField).text = LocaleUtil.localize("achievements");
			(_achievementButton.downState as TextField).text = LocaleUtil.localize("achievements");
			(_achievementButton.hitTestState as TextField).text = LocaleUtil.localize("achievements");
			
			if (!GameCenterManager.isSupported) {
				_highScoreButton.visible = false;
				_achievementButton.visible = false;
			}
		}
		
		private function onHighScoresClick(e:Event):void {
			GameCenterManager.instance.showLeaderboardView();
		}
		
		private function onAchievementClick(e:Event):void {
			GameCenterManager.instance.showAchievementsView();
		}
		
		private function onStartClick(e:Event):void {
			_startButton.removeEventListener(TouchEvent.TOUCH_TAP, onStartClick);
			_startButton.removeEventListener(MouseEvent.CLICK, onStartClick);
			
			SoundManager.instance.playTestereTurnOnSound();
			
			var header:MovieClip = _mainMenu.getChildByName("txtHeader") as MovieClip;
			header.gotoAndPlay("oynak");
			_oynakTimer = new Timer(1000, 1);
			_oynakTimer.addEventListener(TimerEvent.TIMER_COMPLETE, destroy);
			_oynakTimer.start();
		}
		
		override protected function destroy(e:Event = null):void {
			if (_oynakTimer) {
				_oynakTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, destroy);
				_oynakTimer.stop();
				_oynakTimer = null;
			}
			
			if (_mainMenu) {
				FlashStageHelper.remove(_mainMenu);
				_mainMenu = null;
			}
			
			super.destroy(e);
		}
	
	}

}