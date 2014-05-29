package {
	import feathers.themes.MetalWorksMobileTheme;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class StarlingMain extends Sprite {
		
		public function StarlingMain() {
			new MetalWorksMobileTheme(false);
			Main.onStarlingReady();
		}
	}

}