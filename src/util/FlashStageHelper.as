package util {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class FlashStageHelper {
		private static var _stage:Stage;
		private static var _stageWidthRatio:Number = 1;
		private static var _stageHeightRatio:Number = 1;
		
		public static function add(displayObject:DisplayObject, parent:DisplayObjectContainer = null):void {
			if (_stageWidthRatio == 1 && _stageHeightRatio == 1) {
				if (displayObject is DisplayObjectContainer) {
					var mask:MovieClip = (displayObject as DisplayObjectContainer).getChildByName("maskSprite") as MovieClip;
					_stageWidthRatio = _stage.fullScreenWidth / mask.width;
					_stageHeightRatio = _stage.fullScreenHeight / mask.height;
					
				}
			}
			
			//var bounds:Rectangle = displayObject.getBounds(displayObject);
			//bounds
			
		
			
			if (parent) {
				parent.addChild(displayObject);
			} else {
					displayObject.scaleX = _stageWidthRatio;
				displayObject.scaleY = _stageHeightRatio;
				_stage.addChild(displayObject);
			}
		}
		
		public static function remove(displayObject:DisplayObject):void {
			displayObject.parent.removeChild(displayObject);;
		}
		
		static public function get stage():Stage {
			return _stage;
		}
		
		static public function set stage(value:Stage):void {
			_stage = value;
		}
		
		static public function get stageWidthRatio():Number {
			return _stageWidthRatio;
		}
		
		static public function get stageHeightRatio():Number {
			return _stageHeightRatio;
		}
	
	}

}