package themes {
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.skins.SmartDisplayObjectStateValueSelector;
	import feathers.text.BitmapFontTextFormat;
	import feathers.themes.MetalWorksMobileTheme;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.TextFormat;
	import starling.textures.Texture;
	import util.Assets;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class OduncuTheme extends MetalWorksMobileTheme {
		
		public static const UPGRADE_BUTTON:String = "upgradeButton";
		public static const BACK_BUTTON:String = "oduncuBackButton";
		public static const STATS_LABEL:String = "statsLabel";
		
		protected var _upgradeButtonTexture:Texture;
		protected var _upgradeButtonSelectedTexture:Texture;
		
		protected var _backButtonTexture:Texture;
		protected var _backButtonSelectedTexture:Texture;
		
		protected var _visitorBlackElementFormat:ElementFormat;
		
		public function OduncuTheme() {
			super(false);
		}
		
		override protected function initializeFonts():void {
			super.initializeFonts();
			
			_visitorBlackElementFormat = new ElementFormat(new FontDescription("Visitor TT1 BRK"), 12);
		}
		
		override protected function initializeTextures():void {
			super.initializeTextures();
			
			_upgradeButtonTexture = Assets.assetManager.getTexture("upgradeButton");
			_upgradeButtonSelectedTexture = Assets.assetManager.getTexture("upgradeButtonSelected");
			
			_backButtonTexture = Assets.assetManager.getTexture("skipUp");
			_backButtonSelectedTexture = Assets.assetManager.getTexture("skipDown");
		}
		
		override protected function initializeStyleProviders():void {
			super.initializeStyleProviders();
			
			this.getStyleProviderForClass(Button).setFunctionForStyleName(UPGRADE_BUTTON, this.setUpgradeButton);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(BACK_BUTTON, this.setBackButton);
			this.getStyleProviderForClass(Label).setFunctionForStyleName(STATS_LABEL, this.setStatsLabel);
		}
		
		private function setBackButton(button:Button):void {
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = _backButtonTexture;
			skinSelector.setValueForState(_backButtonSelectedTexture, Button.STATE_DOWN, false);
			skinSelector.setValueForState(_backButtonSelectedTexture, Button.STATE_DISABLED, false);
			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
			button.defaultLabelProperties.elementFormat = _visitorBlackElementFormat;
		}
		
		protected function setUpgradeButton(button:Button):void {
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = _upgradeButtonTexture;
			skinSelector.setValueForState(_upgradeButtonSelectedTexture, Button.STATE_DOWN, false);
			skinSelector.setValueForState(_upgradeButtonSelectedTexture, Button.STATE_DISABLED, false);
			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
			button.defaultLabelProperties.elementFormat = _visitorBlackElementFormat;
		}
		
		private function setStatsLabel(label:Label):void {
			label.textRendererProperties.elementFormat = this._visitorBlackElementFormat;
			label.textRendererProperties.disabledElementFormat = this._visitorBlackElementFormat;
		}
	
	}

}