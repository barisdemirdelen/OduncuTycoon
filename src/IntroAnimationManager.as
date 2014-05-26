package {
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class IntroAnimationManager extends BurgerManager {
		
		private var _introAnimation:MovieClip;
		private var _skipButton:SimpleButton;
		
		public function IntroAnimationManager(callBack:Function) {
			super(callBack);
		}
		
		override protected function init() : void {
			super.init();
			
			_introAnimation = new introAnimationSprite();
			FlashStageHelper.add(_introAnimation);
			
			_skipButton = new skipButtonSprite();
			_skipButton.x = FlashStageHelper.stage.fullScreenWidth - 100;
			_skipButton.y = FlashStageHelper.stage.fullScreenHeight - 100;
			_skipButton.addEventListener(TouchEvent.TOUCH_TAP, onSkipClick);
			_skipButton.addEventListener(MouseEvent.CLICK, onSkipClick);
			FlashStageHelper.add(_skipButton);
			
			_introAnimation.addEventListener(Event.ENTER_FRAME, onAnimationTick);
		}
		
		private function onSkipClick(e:Event):void {
			destroy();
		}
		
		private function onAnimationTick(e:Event):void {
			if (_introAnimation.currentFrame >= 360) {
				destroy();
			}
		}
		
		override protected function destroy(e:Event = null):void {
			if (_introAnimation) {
				_introAnimation.removeEventListener(Event.ENTER_FRAME, onAnimationTick);
				FlashStageHelper.stage.removeChild(_introAnimation);
				_introAnimation = null;
			}
			
			if (_skipButton) {
				_skipButton.removeEventListener(TouchEvent.TOUCH_TAP, onSkipClick);
				_skipButton.removeEventListener(MouseEvent.MOUSE_DOWN, onSkipClick);
				FlashStageHelper.stage.removeChild(_skipButton);
				_skipButton = null;
			}
			
			super.destroy(e);
		}
	
	}

}