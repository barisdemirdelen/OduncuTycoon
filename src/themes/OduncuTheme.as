package themes {
	import feathers.controls.Button;
	import feathers.skins.SmartDisplayObjectStateValueSelector;
	import feathers.themes.MetalWorksMobileTheme;
	import flash.text.TextFormat;
	import starling.textures.Texture;
	import util.Assets;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class OduncuTheme extends MetalWorksMobileTheme {
		
		public static const UPGRADE_BUTTON:String = "upgradeButton";
		
		protected var _upgradeButtonTexture:Texture;
		protected var _upgradeButtonSelectedTexture:Texture;
		
		protected var _visitorOrangeTextFormat:TextFormat;
		
		public function OduncuTheme() {
			super(false);
		}
		
		override protected function initializeFonts():void {
			super.initializeFonts();
			
			_visitorOrangeTextFormat = new TextFormat("visitor", 24);
		}
		
		override protected function initializeTextures():void {
			super.initializeTextures();
			
			_upgradeButtonTexture = Assets.assetManager.getTexture("upgradeButton");
			_upgradeButtonSelectedTexture = Assets.assetManager.getTexture("upgradeButtonSelected");
		}
		
		override protected function initializeStyleProviders():void {
			super.initializeStyleProviders();
			
			this.getStyleProviderForClass(Button).setFunctionForStyleName(UPGRADE_BUTTON, this.setUpgradeButton);
		}
		
		protected function setUpgradeButton(button:Button):void {
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = _upgradeButtonTexture;
			skinSelector.setValueForState(_upgradeButtonSelectedTexture, Button.STATE_DOWN, false);
			skinSelector.setValueForState(_upgradeButtonSelectedTexture, Button.STATE_DISABLED, false);
			button.stateToSkinFunction = skinSelector.updateValue;
			this.setBaseButtonStyles(button);
			button.defaultLabelProperties.textFormat = _visitorOrangeTextFormat;
		}
	
	}

}