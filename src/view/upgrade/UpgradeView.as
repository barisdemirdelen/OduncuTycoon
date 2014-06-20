package view.upgrade {
	import feathers.controls.LayoutGroup;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import util.Assets;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class UpgradeView extends LayoutGroup {
		
		public function UpgradeView() {
		
		}
		
		override protected function initialize():void {
			super.initialize();
			
			var background:MovieClip = Assets.getMovieClip("upgradePopupBackground");
			addChild(background);
			background.width = Starling.current.stage.stageWidth + 200;
			background.height = Starling.current.stage.stageHeight + 200;
			background.x = -100;
			background.y = -100;
			
			//var upgradesContainer:LayoutGroup = new LayoutGroup();
			//upgradesContainer.la
			
			
		}
	
	}

}