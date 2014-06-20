package view.mainMenu {
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import services.GameCenterManager;
	import services.SoundManager;
	import util.FlashStageHelper;
	import util.LocaleUtil;
	import view.base.BaseFlashView;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class MainMenuView extends BaseFlashView {
		
		private var _mainMenu:MovieClip;
		private var _startButton:SimpleButton;
		private var _highScoreButton:SimpleButton;
		private var _achievementButton:SimpleButton;
		private var _upgradeButton:SimpleButton;
		
		public function MainMenuView() {
			_mainMenu = new mainMenuSprite();
			_startButton = _mainMenu.getChildByName("startButton") as SimpleButton;
			_highScoreButton = _mainMenu.getChildByName("highScores") as SimpleButton;
			_achievementButton = _mainMenu.getChildByName("achievements") as SimpleButton;
			_upgradeButton = _mainMenu.getChildByName("upgrade") as SimpleButton;
		}
		
		override public function initialize():void {
			super.initialize();
			FlashStageHelper.stage.frameRate = 30;
			FlashStageHelper.add(_mainMenu);
			
			(_highScoreButton.upState as TextField).text = LocaleUtil.localize("highScores");
			(_highScoreButton.overState as TextField).text = LocaleUtil.localize("highScores");
			(_highScoreButton.downState as TextField).text = LocaleUtil.localize("highScores");
			(_highScoreButton.hitTestState as TextField).text = LocaleUtil.localize("highScores");
			
			(_achievementButton.upState as TextField).text = LocaleUtil.localize("achievements");
			(_achievementButton.overState as TextField).text = LocaleUtil.localize("achievements");
			(_achievementButton.downState as TextField).text = LocaleUtil.localize("achievements");
			(_achievementButton.hitTestState as TextField).text = LocaleUtil.localize("achievements");
			
			(_upgradeButton.upState as TextField).text = LocaleUtil.localize("upgrade");
			(_upgradeButton.overState as TextField).text = LocaleUtil.localize("upgrade");
			(_upgradeButton.downState as TextField).text = LocaleUtil.localize("upgrade");
			(_upgradeButton.hitTestState as TextField).text = LocaleUtil.localize("upgrade");
		
		}
		
		override public function dispose():void {
			super.dispose();
			
			if (_mainMenu) {
				FlashStageHelper.remove(_mainMenu);
				_mainMenu = null;
			}
		}
		
		public function get startButton():SimpleButton {
			return _startButton;
		}
		
		public function get highScoreButton():SimpleButton {
			return _highScoreButton;
		}
		
		public function get achievementButton():SimpleButton {
			return _achievementButton;
		}
		
		public function get mainMenu():MovieClip {
			return _mainMenu;
		}
		
		public function get upgradeButton():SimpleButton {
			return _upgradeButton;
		}
	
	}

}