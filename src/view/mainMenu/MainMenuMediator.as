package view.mainMenu {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import robotlegs.bender.bundles.mvcs.Mediator;
	import services.GameCenterManager;
	import services.ScreenManager;
	import services.SoundManager;
	import signals.ChangeScreenSignal;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class MainMenuMediator extends Mediator {
		
		[Inject]
		public var view:MainMenuView;
		
		[Inject]
		public var changeScreenSignal:ChangeScreenSignal;
		
		private var _oynakTimer:Timer;
		
		override public function initialize():void {
			super.initialize();
			
			view.startButton.addEventListener(MouseEvent.CLICK, onStartClick);
			view.highScoreButton.addEventListener(MouseEvent.CLICK, onHighScoresClick);
			view.achievementButton.addEventListener(MouseEvent.CLICK, onAchievementClick);
			view.upgradeButton.addEventListener(MouseEvent.CLICK, onUpgradeClick);
			
			if (!GameCenterManager.isSupported) {
				view.highScoreButton.visible = false;
				view.achievementButton.visible = false;
			}
		}
		
		private function onUpgradeClick(e:Event):void {
			changeScreenSignal.dispatch(ScreenManager.UPGRADE);
		}
		
		private function onHighScoresClick(e:Event):void {
			GameCenterManager.instance.showLeaderboardView();
		}
		
		private function onAchievementClick(e:Event):void {
			GameCenterManager.instance.showAchievementsView();
		}
		
		private function onStartClick(e:Event):void {
			view.startButton.removeEventListener(MouseEvent.CLICK, onStartClick);
			
			SoundManager.instance.playTestereTurnOnSound();
			
			var header:MovieClip = MovieClip(MovieClip(view).mainMenu).getChildByName("txtHeader") as MovieClip;
			header.gotoAndPlay("oynak");
			_oynakTimer = new Timer(1000, 1);
			_oynakTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onOynakFinished);
			_oynakTimer.start();
		}
		
		private function onOynakFinished(e:TimerEvent):void {
			changeScreenSignal.dispatch(ScreenManager.GAME);
		}
		
		override public function destroy():void {
			view.startButton.removeEventListener(MouseEvent.CLICK, onStartClick);
			view.highScoreButton.removeEventListener(MouseEvent.CLICK, onHighScoresClick);
			view.achievementButton.removeEventListener(MouseEvent.CLICK, onAchievementClick);
			
			if (_oynakTimer) {
				_oynakTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, destroy);
				_oynakTimer.stop();
				_oynakTimer = null;
			}
			
			super.destroy();
		}
	
	}

}