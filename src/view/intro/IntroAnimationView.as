package view.intro {
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import util.FlashStageHelper;
	import view.base.BaseFlashView;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class IntroAnimationView extends BaseFlashView {
		
		private var _introAnimation:MovieClip;
		private var _skipButton:SimpleButton;
		
		public function IntroAnimationView():void {
			_introAnimation = new introAnimationSprite();
			_skipButton = new skipButtonSprite();
		}
		
		override public function initialize():void {
			super.initialize();
			FlashStageHelper.add(_introAnimation);
			_skipButton.x = FlashStageHelper.stage.fullScreenWidth - 100;
			_skipButton.y = FlashStageHelper.stage.fullScreenHeight - 100;
			FlashStageHelper.add(_skipButton);
		}
		
		override public function dispose():void {
			super.dispose();
			if (_introAnimation) {
				FlashStageHelper.stage.removeChild(_introAnimation);
			}
			
			if (_skipButton) {
				FlashStageHelper.stage.removeChild(_skipButton);
			}
		}
		
		public function get introAnimation():MovieClip {
			return _introAnimation;
		}
		
		public function get skipButton():SimpleButton {
			return _skipButton;
		}
	}

}