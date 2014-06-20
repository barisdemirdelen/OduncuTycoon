package view.game {
	import feathers.core.PopUpManager;
	import robotlegs.extensions.starlingViewMap.impl.StarlingMediator;
	import services.ScreenManager;
	import signals.ChangeScreenSignal;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class DeathPopupMediator extends StarlingMediator {
		
		[Inject]
		public var view:DeathPopupView;
		
		[Inject]
		public var changeScreenSignal:ChangeScreenSignal;
		
		override public function initialize():void {
			super.initialize();
			
			view.menuButton.addEventListener(TouchEvent.TOUCH, onMenuButtonClicked);
		}
		
		public function onMenuButtonClicked(e:TouchEvent):void {
			var touch:Touch = e.getTouch(view.menuButton, TouchPhase.ENDED);
			if (touch) {
				view.menuButton.removeEventListeners(TouchEvent.TOUCH);
				PopUpManager.removePopUp(view, true);
				changeScreenSignal.dispatch(ScreenManager.UPGRADE);
			}
		}
	
	}

}