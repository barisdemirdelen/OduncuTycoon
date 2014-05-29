package model {
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class PlayerData {
		
		private static var _instance:PlayerData;
		
		private var _sawDamage:Number;
		private var _sawSpeed:Number;
		
		public function PlayerData() {
			if (_instance) {
				return;
			}
		}
		
		public static function get instance():void {
			return _instance;
		}
		
		public function get sawDamage():Number {
			return _sawDamage;
		}
		
		public function set sawDamage(value:Number):void {
			_sawDamage = value;
		}
		
		public function get sawSpeed():Number {
			return _sawSpeed;
		}
		
		public function set sawSpeed(value:Number):void {
			_sawSpeed = value;
		}
	
	}

}