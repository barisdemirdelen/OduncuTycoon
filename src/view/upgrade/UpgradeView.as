package view.upgrade {
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.controls.ScrollContainer;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.TiledRowsLayout;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import themes.OduncuTheme;
	import util.Assets;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class UpgradeView extends LayoutGroup {
		
		private var _upgradesContainer:ScrollContainer;
		private var _mainContainer:LayoutGroup;
		private var _backButton:Button;
		
		public function UpgradeView() {
			_mainContainer = new LayoutGroup();
			_upgradesContainer = new ScrollContainer();
			_backButton = new Button();
		}
		
		override protected function initialize():void {
			super.initialize();
			
			setSize(Starling.current.stage.stageWidth, Starling.current.stage.stageHeight);
			var background:MovieClip = Assets.getMovieClip("upgradePopupBackground");
			addChild(background);
			
			_mainContainer.layout = new AnchorLayout();
			_mainContainer.setSize(Starling.current.stage.stageWidth, Starling.current.stage.stageHeight);
			addChild(_mainContainer);
			
			_backButton.styleName = OduncuTheme.BACK_BUTTON;
			_backButton.setSize(50, 50);
			var backButtonLayoutData:AnchorLayoutData = new AnchorLayoutData();
			backButtonLayoutData.bottom = 15;
			backButtonLayoutData.horizontalCenter = 0;
			_backButton.layoutData = backButtonLayoutData;
			_mainContainer.addChild(_backButton)
			
			_upgradesContainer.setSize(600, 100);
			var upgradesContainerLayoutData:AnchorLayoutData = new AnchorLayoutData();
			upgradesContainerLayoutData.bottom = 15;
			upgradesContainerLayoutData.bottomAnchorDisplayObject = _backButton;
			upgradesContainerLayoutData.horizontalCenter = 0;
			_upgradesContainer.layoutData = upgradesContainerLayoutData;
			var upgradesContainerLayout:HorizontalLayout = new HorizontalLayout();
			upgradesContainerLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
			_upgradesContainer.layout = upgradesContainerLayout;
			_upgradesContainer.clipContent = true;
			_mainContainer.addChild(_upgradesContainer);
		}
		
		public function get upgradesContainer():ScrollContainer {
			return _upgradesContainer;
		}
		
		public function get backButton():Button {
			return _backButton;
		}
	
	}

}