package services {
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class GameStateManager {
		private var _paused:Boolean;
		
		public function get paused():Boolean {
			return _paused;
		}
		
		public function set paused(value:Boolean):void {
			_paused = value;
		}
	
	}

}