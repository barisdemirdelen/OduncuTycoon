package services {
	import events.GeneratorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import model.Boss;
	import model.Tree;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import util.GraphicsUtil;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class TreeGeneratorService extends EventDispatcher {
		
		protected var _generationTimer:Timer;
		protected var _difficultyTimer:Timer;
		
		protected var _running:Boolean;
		protected var _scene:DisplayObjectContainer;
		
		protected static var _instance:TreeGeneratorService;
		
		protected var _treeSpeed:Number;
		
		public static function get instance():TreeGeneratorService {
			if (!_instance) {
				_instance = new TreeGeneratorService();
			}
			return _instance;
		}
		
		public function start(scene:DisplayObjectContainer):void {
			if (_running) {
				return;
			}
			
			_treeSpeed = 0.95;
			addGenerationTimer(4000);
			
			_difficultyTimer = new Timer(5000, 0);
			_difficultyTimer.addEventListener(TimerEvent.TIMER, onIncreaseDifficulty);
			_difficultyTimer.start();
			
			_scene = scene;
			_running = true;
		}
		
		protected function onIncreaseDifficulty(e:TimerEvent):void {
		
		}
		
		protected function onGenerateTree(e:TimerEvent):void {
			var newTree:Tree = new Tree();
			newTree.y = Starling.current.stage.stageHeight - newTree.clip.height;
			var left:Boolean = Math.random() < 0.5;
			if (left || newTree is Boss) {
				newTree.facingRight = false;
				newTree.x = Starling.current.stage.stageWidth;
				newTree.speed = -_treeSpeed;
			} else {
				newTree.facingRight = true;
				GraphicsUtil.reverseHorizontal(newTree.clip);
				newTree.x -= 2 * newTree.clip.width;
				newTree.speed = _treeSpeed;
			}
			_scene.addChild(newTree.container);
			
			dispatchEvent(new GeneratorEvent(GeneratorEvent.TREE_GENERATED, newTree));
			addGenerationTimer(5000);
		}
		
		public function stop():void {
			_running = false;
			
			removeGenerationTimer();
			if (_difficultyTimer) {
				_difficultyTimer.removeEventListener(TimerEvent.TIMER, onIncreaseDifficulty);
				_difficultyTimer.stop();
				_difficultyTimer = null;
			}
		}
		
		protected function removeGenerationTimer():void {
			if (_generationTimer) {
				_generationTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onGenerateTree);
				_generationTimer.stop();
				_generationTimer = null;
			}
		}
		
		protected function addGenerationTimer(time:Number):void {
			removeGenerationTimer();
			_generationTimer = new Timer(time, 1);
			_generationTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onGenerateTree);
			_generationTimer.start();
		}
		
		public function get running():Boolean {
			return _running;
		}
	
	}

}