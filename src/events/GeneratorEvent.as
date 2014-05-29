package events {
	import flash.events.Event;
	import model.Tree;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class GeneratorEvent extends Event {
		
		public static const TREE_GENERATED:String = "treeGenerated";
		
		private var _tree:Tree;
		
		public function GeneratorEvent(type:String, tree:Tree, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			_tree = tree;
		}
		
		public function get tree():Tree {
			return _tree;
		}
		
		public function set tree(value:Tree):void {
			_tree = value;
		}
	
	}

}