package services {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class BurgerManager {
		
		private var _callBack:Function;
		
		public function BurgerManager(callBack:Function) {
			_callBack = callBack;
			init();
		}
		
		protected function init():void {
		
		}
		
		protected function destroy(e:Event = null):void {
			if (_callBack != null) {
				_callBack();
			}
		}
	
	}

}