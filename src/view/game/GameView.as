package view.game {
	import feathers.controls.LayoutGroup;
	import flash.text.TextFormat;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import util.Assets;
	import util.FlashStageHelper;
	import util.LocaleUtil;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class GameView extends LayoutGroup {
		
		private var _stage:Stage;
		private var _gameScene:Sprite;
		
		private var _gameHeight:Number;
		private var _gameWidth:Number;
		
		private var _scoreField:TextField;
		private var _textFormat:TextFormat;
		
		private var _treeLayer:Sprite;
		private var _bossLayer:Sprite;
		private var _adamLayer:Sprite;
		private var _backgroundSprite:Sprite;
		
		public function GameView() {
			_gameScene = new Sprite();
			_backgroundSprite = new Sprite();
			_bossLayer = new Sprite();
			_treeLayer = new Sprite();
			_adamLayer = new Sprite();
		}
		
		override protected function initialize():void {
			super.initialize();
			
			FlashStageHelper.stage.frameRate = 60;
			_stage = Starling.current.stage;
			_stage.addChild(_gameScene);
			
			_backgroundSprite.addChild(Assets.getMovieClip("arkaplan"));
			_gameScene.addChild(_backgroundSprite);
			_gameScene.addChild(Assets.getMovieClip("kesilmisodunlar"));
			_gameScene.addChild(_bossLayer);
			_gameScene.addChild(_treeLayer);
			_gameScene.addChild(_adamLayer);
			
			_gameScene.addChild(Assets.getMovieClip("cimenler"));
			
			_scoreField = createTextField(LocaleUtil.localize("wood") + ": 0");
			_scoreField.x = 150;
			_scoreField.y = 15;
			_scoreField.hAlign = HAlign.LEFT;
			_gameScene.addChild(_scoreField);
		}
		
		public function createTextField(text:String, color:uint = 0xffffff):TextField {
			var textField:TextField = new TextField(200, 75, text, "visitor", 24, color);
			return textField;
		}
		
		override public function dispose():void {
			super.dispose()
			
			if (_gameScene) {
				_gameScene.removeFromParent(true);
				_gameScene = null;
			}
		}
		
		public function get gameScene():Sprite {
			return _gameScene;
		}
		
		public function get adamLayer():Sprite {
			return _adamLayer;
		}
		
		public function get bossLayer():Sprite {
			return _bossLayer;
		}
		
		public function get treeLayer():Sprite {
			return _treeLayer;
		}
		
		public function get scoreField():TextField {
			return _scoreField;
		}
		
		public function get backgroundSprite():Sprite {
			return _backgroundSprite;
		}
	
	}

}