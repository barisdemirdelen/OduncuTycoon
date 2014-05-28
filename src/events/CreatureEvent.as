package events {
	import flash.events.Event;
	import model.Creature;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class CreatureEvent extends Event {
		
		public static const CREATURE_DYING:String = "creatureDying";
		public static const CREATURE_DEAD:String = "creatureDead";
		public static const CREATURE_TOOK_DAMAGE:String = "creatureTookDamage";
		
		private var _creature:Creature;
		
		public function CreatureEvent(type:String, creature:Creature, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			_creature = creature;
		}
		
		public function get creature():Creature {
			return _creature;
		}
		
		public function set creature(value:Creature):void {
			_creature = value;
		}
	
	}

}