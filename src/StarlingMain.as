package {
	import feathers.themes.MetalWorksMobileTheme;
	import robotlegs.bender.bundles.mvcs.MVCSBundle;
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.framework.impl.Context;
	import robotlegs.extensions.starlingViewMap.StarlingViewMapExtension;
	import starling.core.Starling;
	import starling.display.Sprite;
	import themes.OduncuTheme;
	import util.Assets;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class StarlingMain extends Sprite {
		
		private var _context:Context;
		
		public function StarlingMain() {
			Assets.initialize(onAssetsLoaded);
		}
		
		private function onAssetsLoaded():void {
			_context = new Context();
			_context.install(MVCSBundle,StarlingViewMapExtension);
			_context.configure(new ContextView(Starling.current.nativeStage));
			_context.configure(OduncuConfig, Starling.current);
			_context.initialize();
			new OduncuTheme();
		}
	}

}