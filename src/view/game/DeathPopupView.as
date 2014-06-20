package view.game {
	import feathers.controls.LayoutGroup;
	import starling.display.Button;
	import starling.display.Quad;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import util.Assets;
	import util.LocaleUtil;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class DeathPopupView extends LayoutGroup {
		
		private var _scoreText:TextField;
		private var _menuButton:Button;
		
		public function DeathPopupView() {
			_scoreText = createTextField(LocaleUtil.localize(LocaleUtil.localize("score") + ": 0"));
			_menuButton = new Button(Assets.assetManager.getTexture("skipUp"), "", Assets.assetManager.getTexture("skipDown"));
		}
		
		override protected function initialize():void {
			super.initialize();
			
			var deathBg:Quad = new Quad(200, 200, 0x000000);
			addChild(deathBg);
			
			var deathText:TextField = createTextField(LocaleUtil.localize("deathText"));
			deathText.y = 10;
			deathText.x = 10;
			deathText.hAlign = HAlign.LEFT;
			addChild(deathText);
			
			_scoreText.y = 10 + deathText.height;
			_scoreText.x = 10;
			_scoreText.hAlign = HAlign.LEFT;
			addChild(_scoreText);
			
			_menuButton.y = 190 - _menuButton.height;
			_menuButton.x = 100 - _menuButton.width / 2;
			addChild(_menuButton);
		}
		
		public function createTextField(text:String, color:uint = 0xffffff):TextField {
			var textField:TextField = new TextField(200, 75, text, "visitor", 24, color);
			return textField;
		}
		
		public function get menuButton():Button {
			return _menuButton;
		}
		
		public function get scoreText():TextField {
			return _scoreText;
		}
	
	}

}