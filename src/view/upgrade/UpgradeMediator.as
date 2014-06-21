package view.upgrade {
	import feathers.controls.Button;
	import feathers.controls.Label;
	import model.PlayerData;
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
		
		[Inject]
		public var playerData:PlayerData;
		
		override public function initialize():void {
			super.initialize();
			
			updateStats();
			
			view.upgradesContainer.addChild(createUpgradeButton("damage"));
			view.upgradesContainer.addChild(createUpgradeButton("attackSpeed"));
			view.upgradesContainer.addChild(createUpgradeButton("health"));
			
			view.backButton.addEventListener(Event.TRIGGERED, onBackTriggered);
		}
		
		private function onBackTriggered(e:Event):void {
			view.backButton.removeEventListener(Event.TRIGGERED, onBackTriggered);
			changeScreenSignal.dispatch(ScreenManager.MAIN_MENU);
		}
		
		public function createStat(name:String, text:String):Label {
			var label:Label = new Label();
			label.name = name;
			label.styleName = OduncuTheme.STATS_LABEL;
			label.text = text;
			label.setSize(200, 25);
			return label;
		}
		
		public function createUpgradeButton(name:String):Button {
			var button:Button = new Button();
			button.name = name;
			button.styleName = OduncuTheme.UPGRADE_BUTTON;
			button.setSize(125, 75);
			button.label = name;
			button.addEventListener(Event.TRIGGERED, onUpgradeButtonTriggered);
			return button;
		}
		
		private function updateStats():void {
			view.statsContainer.removeChildren();
			view.statsContainer.addChild(createStat("damage", "damage: " + playerData.attackDamage));
			view.statsContainer.addChild(createStat("attackSpeed", "attackSpeed: " + playerData.attackSpeed));
			view.statsContainer.addChild(createStat("health", "health: " + playerData.health));
		}
		
		private function onUpgradeButtonTriggered(e:Event):void {
			switch (Button(e.currentTarget).name) {
				case "damage": 
					playerData.attackDamage *= 1.16;
					playerData.attackDamage = Math.ceil(playerData.attackDamage);
					break;
				case "attackSpeed": 
					Math.max(0.1, playerData.attackSpeed -= 0.025);
					break;
				case "health": 
					playerData.health *= 1.16;
					playerData.health = Math.ceil(playerData.health);
					break;
				default: 
					break;
			}
			updateStats();
		}
	
	}

}