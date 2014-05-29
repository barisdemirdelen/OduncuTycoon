package model {
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class PlayerData {
		
		private static var _instance:PlayerData;
		
		private var _currentWood:Number;
		private var _totalWood:Number;
		
		private var _attackDamage:Number;
		private var _attackSpeed:Number;
		
		public function PlayerData() {
			if (_instance) {
				return;
			}
		}
		
		public static function get instance():void {
			return _instance;
		}
		
		public function get attackDamage():Number {
			return _attackDamage;
		}
		
		public function set attackDamage(value:Number):void {
			_attackDamage = value;
		}
		
		public function get attackSpeed():Number {
			return _attackSpeed;
		}
		
		public function set attackSpeed(value:Number):void {
			_attackSpeed = value;
		}
		
		public function get currentWood():Number {
			return _currentWood;
		}
		
		public function set currentWood(value:Number):void {
			_currentWood = value;
		}
		
		public function get totalWood():Number {
			return _totalWood;
		}
		
		public function set totalWood(value:Number):void {
			_totalWood = value;
		}
	
	}

}