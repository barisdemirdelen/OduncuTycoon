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
		
		public static var DIFFICULTY:Number = 1.16;
		
		protected var _generationTimer:Timer;
		protected var _difficultyTimer:Timer;
		
		protected var _running:Boolean;
		protected var _scene:DisplayObjectContainer;
		
		protected var _difficultyLevel:uint = 0;
		protected var _treeSpeed:Number;
		protected var _treeHealth:Number;
		protected var _treeDamage:Number;
		protected var _treeAttackSpeed:Number;
		protected var _treeInterval:Number;
		
		public function start(scene:DisplayObjectContainer):void {
			if (_running) {
				return;
			}
			
			_treeSpeed = 0.95;
			_treeHealth = 3;
			_treeDamage = 1;
			_treeInterval = 4000;
			_treeAttackSpeed = 1;
			addGenerationTimer(_treeInterval);
			
			_difficultyTimer = new Timer(5000, 0);
			_difficultyTimer.addEventListener(TimerEvent.TIMER, onIncreaseDifficulty);
			_difficultyTimer.start();
			
			_scene = scene;
			_running = true;
		}
		
		protected function onIncreaseDifficulty(e:TimerEvent):void {
			_difficultyLevel++;
			
			_treeHealth = _treeHealth * DIFFICULTY;
			_treeDamage = _treeDamage * DIFFICULTY;
			_treeAttackSpeed = Math.max(0.025, _treeAttackSpeed - 0.025);
			_treeInterval = Math.max(100, _treeInterval - 100);
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
			
			newTree.attackDamage = _treeDamage;
			newTree.attackSpeed = _treeAttackSpeed;
			newTree.maxHealth = _treeHealth;
			newTree.health = _treeHealth;
			_scene.addChild(newTree.container);
			
			dispatchEvent(new GeneratorEvent(GeneratorEvent.TREE_GENERATED, newTree));
			addGenerationTimer(_treeInterval);
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