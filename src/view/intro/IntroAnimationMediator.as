package view.intro {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import robotlegs.bender.bundles.mvcs.Mediator;
	import services.ScreenManager;
	import signals.ChangeScreenSignal;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class IntroAnimationMediator extends Mediator {
		
		[Inject]
		public var view:IntroAnimationView;
		
		[Inject]
		public var changeScreenSignal:ChangeScreenSignal;
		
		override public function initialize():void {
			super.initialize();
			
			view.skipButton.addEventListener(MouseEvent.CLICK, onSkipClick);
			view.introAnimation.addEventListener(Event.ENTER_FRAME, onAnimationTick);
		}
	
		
		private function onSkipClick(e:Event):void {
			changeScreenSignal.dispatch(ScreenManager.MAIN_MENU);
		}
		
		private function onAnimationTick(e:Event):void {
			if (view.introAnimation.currentFrame >= 360) {
				changeScreenSignal.dispatch(ScreenManager.MAIN_MENU);
			}
		}
		
		override public function destroy():void {
			view.skipButton.removeEventListener(MouseEvent.CLICK, onSkipClick);
			view.introAnimation.removeEventListener(Event.ENTER_FRAME, onAnimationTick);
			
			super.destroy();
			
		}
		
	}

}