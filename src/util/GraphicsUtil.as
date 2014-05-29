package util {
	import starling.display.DisplayObject;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class GraphicsUtil {
		
		public static function reverseHorizontal(object:DisplayObject) : void {
			object.scaleX *= -1;
			object.pivotX = -object.pivotX;
			object.x -= object.width * object.scaleX;
		}
	
	}

}