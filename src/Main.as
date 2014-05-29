package {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import services.GameCenterManager;
	import services.GameManager;
	import services.IntroAnimationManager;
	import services.MainMenuManager;
	import sound.SoundManager;
	import starling.core.Starling;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	import util.Assets;
	import util.FlashStageHelper;
	import util.LocaleUtil;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	
	public class Main extends Sprite {
		
		private var _starling:Starling;
		
		public function Main():void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.ACTIVATE, activate);
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			FlashStageHelper.stage = stage;
			LocaleUtil.initialize();
			
			Starling.handleLostContext = true;
			var viewPort:Rectangle = RectangleUtil.fit(new Rectangle(0, 0, 800, 400), new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight), ScaleMode.NO_BORDER);
			_starling = new Starling(StarlingMain, stage, viewPort, null, "auto", "auto");
			_starling.stage.stageWidth = 800;
			_starling.stage.stageHeight = 400;
			_starling.antiAliasing = 1;
			_starling.start();
			
			GameCenterManager.instance.initialize();
		}
		
		public static function onStarlingReady():void {
			Assets.initialize(startAnimation);
		}
		
		public static function startAnimation():void {
			new IntroAnimationManager(initMenu);
		}
		
		public static function initMenu():void {
			new MainMenuManager(onStartGame);
		}
		
		public static function onStartGame(e:TimerEvent = null):void {
			new GameManager(initMenu);
		}
		
		private function activate(e:Event):void {
			_starling.start();
			SoundManager.instance.unpauseAll();
			if (GameManager.instance) {
				GameManager.instance.paused = false;
			}
		}
		
		private function deactivate(e:Event):void {
			if (GameManager.instance) {
				GameManager.instance.paused = true;
			}
			SoundManager.instance.pauseAll();
			_starling.stop(true);
		}
	
	}

}