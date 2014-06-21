package view.upgrade {
	import feathers.controls.Button;
	import robotlegs.extensions.starlingViewMap.impl.StarlingMediator;
	import services.ScreenManager;
	import signals.ChangeScreenSignal;
	import starling.events.Event;
	import themes.OduncuTheme;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class UpgradeMediator extends StarlingMediator {
		
		[Inject]
		public var view:UpgradeView;
		
		[Inject]
		public var changeScreenSignal:ChangeScreenSignal;
		
		override public function initialize():void {
			super.initialize();
			
			view.upgradesContainer.addChild(createUpgradeButton("damage"));
			view.upgradesContainer.addChild(createUpgradeButton("attackSpeed"));
			view.upgradesContainer.addChild(createUpgradeButton("health"));
			
			view.backButton.addEventListener(Event.TRIGGERED, onBackTriggered);
		}
		
		private function onBackTriggered(e:Event):void {
			view.backButton.removeEventListener(Event.TRIGGERED, onBackTriggered);
			changeScreenSignal.dispatch(ScreenManager.MAIN_MENU);
		}
		
		public function createUpgradeButton(name:String):Button {
			var button:Button = new Button();
			button.name = name;
			button.styleName = OduncuTheme.UPGRADE_BUTTON;
			button.setSize(125, 75);
			button.label = name;
			return button;
		}
	
	}

}