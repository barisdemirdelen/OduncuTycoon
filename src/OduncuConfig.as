package {
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IInjector;
	import services.AdmobService;
	import services.GameCenterManager;
	import services.GameStateManager;
	import services.ScreenManager;
	import services.TreeGeneratorService;
	import signals.ChangeScreenSignal;
	import signals.TreeGeneratedSignal;
	import view.base.MainFlashView;
	import view.base.MainStarlingView;
	import view.game.DeathPopupMediator;
	import view.game.DeathPopupView;
	import view.game.DeathPopupView;
	import view.game.GameMediator;
	import view.game.GameView;
	import view.intro.IntroAnimationMediator;
	import view.intro.IntroAnimationView;
	import view.mainMenu.MainMenuMediator;
	import view.mainMenu.MainMenuView;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class OduncuConfig implements IConfig {
		
		[Inject]
		public var injector:IInjector;
		
		[Inject]
		public var mediatorMap:IMediatorMap;
		
		[Inject]
		public var commandMap:IEventCommandMap;
		
		[Inject]
		public var contextView:ContextView;
		
		/* INTERFACE robotlegs.bender.framework.api.IConfig */
		public function configure():void {
			
			injector.map(MainFlashView).asSingleton();
			injector.map(MainStarlingView).asSingleton();
			
			injector.map(ScreenManager).asSingleton();
			injector.map(GameCenterManager).asSingleton();
			injector.map(TreeGeneratorService).asSingleton();
			injector.map(GameStateManager).asSingleton();
			injector.map(AdmobService).asSingleton();
			
			injector.map(ChangeScreenSignal).asSingleton();
			injector.map(TreeGeneratedSignal).asSingleton();
			
			mediatorMap.map(IntroAnimationView).toMediator(IntroAnimationMediator);
			mediatorMap.map(MainMenuView).toMediator(MainMenuMediator);
			mediatorMap.map(GameView).toMediator(GameMediator);
			mediatorMap.map(DeathPopupView).toMediator(DeathPopupMediator);
			
			contextView.view.addChild(MainFlashView(injector.getInstance(MainFlashView)));
			ScreenManager(injector.getInstance(ScreenManager)).initialize(); 
		}
	
	}

}