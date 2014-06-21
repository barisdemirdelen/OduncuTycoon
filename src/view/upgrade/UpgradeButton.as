package view.upgrade {
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.VerticalLayout;
	import themes.OduncuTheme;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class UpgradeButton extends Button {
		
		private var _headerLabel:Label;
		private var _descriptionLabel:Label;
		
		public function UpgradeButton() {
			_headerLabel = new Label();
			_descriptionLabel = new Label();
		}
		
		override protected function initialize():void {
			super.initialize();
			
			setSize(150, 120);
			var mainContainer:LayoutGroup = new LayoutGroup();
			mainContainer.setSize(this.width, this.height);
			mainContainer.clipContent = true;
			mainContainer.layout = new AnchorLayout();
			addChild(mainContainer);
			
			var labelContainer:LayoutGroup = new LayoutGroup();
			labelContainer.setSize(this.width - 10, this.height - 10);
			var labelContainerLayoutData:AnchorLayoutData = new AnchorLayoutData();
			labelContainerLayoutData.horizontalCenter = 0;
			labelContainerLayoutData.verticalCenter = 0;
			labelContainer.layoutData = labelContainerLayoutData;
			var labelContainerLayout:VerticalLayout = new VerticalLayout();
			labelContainerLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			labelContainerLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			labelContainer.layout = labelContainerLayout;
			mainContainer.addChild(labelContainer);
			
			_headerLabel.setSize(this.width - 30, 20);
			_headerLabel.styleName = OduncuTheme.STATS_LABEL;
			labelContainer.addChild(_headerLabel);
			
			_descriptionLabel.setSize(this.width - 30, 20);
			_descriptionLabel.styleName = OduncuTheme.STATS_LABEL;
			labelContainer.addChild(_descriptionLabel);
		}
		
		public function get headerLabel():Label {
			return _headerLabel;
		}
		
		public function get descriptionLabel():Label {
			return _descriptionLabel;
		}
	
	}

}