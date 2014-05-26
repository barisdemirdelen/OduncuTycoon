package {
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import starling.core.Starling;
	import starling.display.Quad;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class DebugUtil {
		private static var quadDic:Dictionary = new Dictionary();
		
		public static function traceRect(name:String, rect:Rectangle, color:uint):void {
			if (quadDic[name]) {
				var quad:Quad = quadDic[name];
				quad.x = rect.x;
				quad.y = rect.y;
				quad.width = rect.width;
				quad.height = rect.height;
				quad.color = color;
			} else {
				quad = new Quad(rect.width, rect.height, color, false);
				quad.x = rect.x;
				quad.y = rect.y;
				Starling.current.stage.addChild(quad);
				quadDic[name] = quad;
			}
		}
		
		public static function removeTrace(name:String):void {
			if (quadDic[name]) {
				Quad(quadDic[name]).removeFromParent(true);
				delete quadDic[name];
			}
		}
	
	}

}