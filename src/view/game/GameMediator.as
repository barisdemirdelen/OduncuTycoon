package view.game {
	import aze.motion.eaze;
	import feathers.core.PopUpManager;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import model.Adam;
	import model.PlayerData;
	import model.Tree;
	import robotlegs.extensions.starlingViewMap.impl.StarlingMediator;
	import services.AdmobService;
	import services.GameCenterManager;
	import services.GameStateManager;
	import services.SoundManager;
	import services.TreeGeneratorService;
	import signals.TreeGeneratedSignal;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.EnterFrameEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import util.Assets;
	import util.LocaleUtil;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class GameMediator extends StarlingMediator {
		
		[Inject]
		public var view:GameView;
		
		[Inject]
		public var admobService:AdmobService;
		
		[Inject]
		public var treeGeneratorService:TreeGeneratorService;
		
		[Inject]
		public var treeGeneratedSignal:TreeGeneratedSignal;
		
		[Inject]
		public var gameStateManager:GameStateManager;
		
		[Inject]
		public var playerData:PlayerData;
		
		private var _stage:Stage;
		private var _gameTimer:Timer;
		private var _finishTimer:Timer;
		private var _trees:Array;
		private var _boss:Tree;
		private var _adam:Adam;
		
		private var _bossCreationRatio:Number;
		private var _treeCreationRatio:Number;
		
		private var _score:Number;
		
		private const _darbeArray:Array = ["normal", "average", "underwhelming", "overwhelming", "incredible", "amazing", "mindblowing", "proper", "adequate", "solid", "veryGood", "good", "magnificent", "ordinary", "extraordinary", "unbelievable", "insane", "crazy", "weak", "impossible", "critical", "tremendous", "golden", "classy", "sneaky", "deadly", "bruiser"];
		
		override public function initialize():void {
			super.initialize();
			
			_stage = Starling.current.stage;
			_score = 0;
			_boss = null;
			_bossCreationRatio = 0.05;
			_treeCreationRatio = 0.025;
			_trees = new Array();
			
			_adam = new Adam();
			_adam.y = _stage.stageHeight - _adam.clip.height + 5;
			_adam.x = _stage.stageWidth / 2 - _adam.clip.width / 2;
			_adam.creatureDyingSignal.addOnce(onAdamDying);
			_adam.creatureTookDamageSignal.add(onAdamTookDamage);
			_adam.attackDamage = playerData.attackDamage;
			_adam.attackSpeed = playerData.attackSpeed;
			_adam.maxHealth = playerData.health;
			_adam.health = playerData.health;
			view.adamLayer.addChild(_adam.container);
			
			_gameTimer = new Timer(50);
			_gameTimer.addEventListener(TimerEvent.TIMER, onTick);
			_gameTimer.start();
			
			treeGeneratedSignal.add(onTreeCreated);
			treeGeneratorService.start(view.treeLayer);
			
			view.gameScene.addEventListener(TouchEvent.TOUCH, onClick);
			Starling.current.stage.addEventListener(EnterFrameEvent.ENTER_FRAME, onFrame);
			
			SoundManager.instance.playTestereCleanSound();
			admobService.showAds();
		}
		
		private function onFrame(e:EnterFrameEvent):void {
			if (_adam.dead || gameStateManager.paused) {
				return;
			}
			
			var adamHitBounds:Rectangle = _adam.getHitBounds(view.gameScene);
			var sawHitBounds:Rectangle = _adam.getSawHitBounds(view.gameScene);
			
			for each (var tree:Tree in _trees) {
				if (tree.dying) {
					continue;
				}
				var treeHitBounds:Rectangle = tree.getHitBounds(view.gameScene);
				if (sawHitBounds.intersects(treeHitBounds)) {
					_adam.addHitTarget(tree);
					_adam.startHitting();
				} else if (adamHitBounds.intersects(treeHitBounds)) {
					tree.startHitting();
					tree.addHitTarget(_adam);
				} else {
					tree.x += tree.speed;
				}
			}
		}
		
		private function onTick(e:TimerEvent):void {
			if (_adam.dead) {
				for each (var tree:Tree in _trees) {
					tree.deathDance();
				}
				return;
			}
			if (gameStateManager.paused) {
				return;
			}
			
			if (_trees.length == 0) {
				SoundManager.instance.stopAgacWalkSound();
			}
			view.scoreField.text = LocaleUtil.localize("wood") + ": " + _score;
		}
		
		private function onTreeCreated(tree:Tree):void {
			_trees.push(tree);
			tree.creatureTookDamageSignal.add(onTreeTookDamage);
			tree.creatureDyingSignal.addOnce(onTreeDying);
			tree.creatureDeadSignal.addOnce(onTreeDead);
		}
		
		private function onTreeDying(tree:Tree):void {
			tree.creatureTookDamageSignal.remove(onTreeDying);
			_adam.removeHitTarget(tree);
			_score += tree.maxHealth;
		}
		
		private function onTreeDead(tree:Tree):void {
			if (tree == _boss) {
				_boss = null;
				view.backgroundSprite.removeChildren();
				view.backgroundSprite.addChild(Assets.getMovieClip("arkaplan"));
				SoundManager.instance.stopBossSound();
			}
			_trees.splice(_trees.indexOf(tree), 1);
		}
		
		private function onTreeTookDamage(tree:Tree):void {
			if (!view.gameScene) {
				return;
			}
			var textField:TextField = view.createTextField("-" + tree.lastTakenDamage, 0xffffff);
			textField.x = tree.x;
			if (tree.facingRight) {
				textField.x -= tree.clip.width;
			}
			textField.y = tree.y + 3 * tree.clip.height / 4;
			eaze(textField).to(2.5, {y: -textField.height}).onComplete(onHitScoreFinished, textField);
			
			view.gameScene.addChild(textField);
		}
		
		private function onClick(e:TouchEvent):void {
			if (_adam.dead) {
				return;
			}
			
			var touch:Touch = e.getTouch(view.gameScene, TouchPhase.BEGAN);
			
			if (!touch) {
				return;
			}
			if (touch.globalX >= _stage.stageWidth / 2) {
				if (_adam.clip.scaleX < 0) {
					_adam.changeDirection();
				}
			} else {
				if (_adam.clip.scaleX > 0) {
					_adam.changeDirection();
				}
			}
		}
		
		public function onAdamDying(adam:Adam):void {
			for each (var tree:Tree in _trees) {
				tree.killTweens();
				tree.removeAllHitTargets();
			}
			treeGeneratorService.stop();
			_adam.creatureTookDamageSignal.remove(onAdamTookDamage);
			SoundManager.instance.stopAgacWalkSound();
			SoundManager.instance.stopBossSound();
			_finishTimer = new Timer(3000, 1);
			_finishTimer.addEventListener(TimerEvent.TIMER, onFinished);
			_finishTimer.start();
		}
		
		public function onAdamTookDamage(adam:Adam):void {
			var textField:TextField = view.createTextField("-" + _adam.lastTakenDamage, 0x000000);
			textField.x = _adam.x;
			if (_adam.facingRight) {
				textField.x -= _adam.clip.width;
			}
			textField.y = _adam.y + 3 * _adam.clip.height / 4;
			eaze(textField).to(2.5, {y: -textField.height}).onComplete(onHitScoreFinished, textField);
			view.gameScene.addChild(textField);
		}
		
		public function onFinished(e:Event = null):void {
			GameCenterManager.instance.submitScore(_score);
			var deathPopup:DeathPopupView = new DeathPopupView();
			deathPopup.scoreText.text = LocaleUtil.localize("wood") + ": "+ _score;
			PopUpManager.addPopUp(deathPopup);
		}
		
		private function onHitScoreFinished(hitScoreText:TextField):void {
			hitScoreText.removeFromParent(true);
		}
		
		override public function destroy():void {
			admobService.hideAds();
			
			treeGeneratorService.stop();
			treeGeneratedSignal.remove(onTreeCreated);
			SoundManager.instance.stopTestereCleanSound();
			for each (var tree:Tree in _trees) {
				tree.destroy();
			}
			
			if (_gameTimer) {
				_gameTimer.removeEventListener(TimerEvent.TIMER, onTick);
				_gameTimer.stop();
				_gameTimer = null;
			}
			
			view.gameScene.removeEventListener(TouchEvent.TOUCH, onClick);
			
			_adam.destroy();
			super.destroy();
		}
	
	}

}