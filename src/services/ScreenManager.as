package services {
	import feathers.core.FeathersControl;
	import signals.ChangeScreenSignal;
	import starling.core.Starling;
	import view.base.BaseFlashView;
	import view.base.MainFlashView;
	import view.base.MainStarlingView;
	import view.game.GameView;
	import view.intro.IntroAnimationView;
	import view.mainMenu.MainMenuView;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class ScreenManager {
		
		public static const INTRO:String = "intro";
		public static const MAIN_MENU:String = "mainMenu";
		public static const GAME:String = "game";
		public static const UPGRADE:String = "upgrade";
		
		[Inject]
		public var mainFlashView:MainFlashView;
		
		[Inject]
		public var mainStarlingView:MainStarlingView;
		
		[Inject]
		public var changeScreenSignal:ChangeScreenSignal;
		
		private var _currentScreen:String;
		
		public function initialize():void {
			changeScreenSignal.add(onChangeScreen);
			changeScreenSignal.dispatch(INTRO);
			Starling.current.stage.addChild(mainStarlingView);
		}
		
		private function onChangeScreen(screenName:String):void {
			if (_currentScreen == screenName) {
				return;
			}
			var newFlashView:BaseFlashView;
			var newStarlingView:FeathersControl;
			switch (screenName) {
				case INTRO: 
					newFlashView = new IntroAnimationView();
					break;
				case MAIN_MENU: 
					newFlashView = new MainMenuView();
					break;
				case GAME: 
					newStarlingView = new GameView();
					break;
				default: 
					break;
			}
			if (newFlashView || newStarlingView) {
				disposeCurrentScreen();
				_currentScreen = screenName;
				if (newFlashView) {
					newFlashView.initialize();
					mainFlashView.addChild(newFlashView);
				} else {
					mainStarlingView.addChild(newStarlingView);
				}
			}
		}
		
		private function disposeCurrentScreen():void {
			for (var i:int = 0; i < mainFlashView.numChildren; i++) {
				var screen:BaseFlashView = mainFlashView.getChildAt(i) as BaseFlashView;
				screen.dispose();
			}
			mainFlashView.removeChildren();
			mainStarlingView.removeChildren(0, -1, true);
		}
	
	}

}