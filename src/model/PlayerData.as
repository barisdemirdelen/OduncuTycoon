package model {
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class PlayerData {
		
		private var _currentWood:Number;
		private var _totalWood:Number;
		
		private var _attackDamage:Number = 1;
		private var _attackSpeed:Number = 1;
		private var _health:Number = 4;
		
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
		
		public function get health():Number {
			return _health;
		}
		
		public function set health(value:Number):void {
			_health = value;
		}
	
	}

}