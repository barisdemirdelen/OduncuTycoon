package {
	import aze.motion.eaze;
	import flash.display.SimpleButton;
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.sensors.Accelerometer;
	import flash.system.Capabilities;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import model.Adam;
	import model.Boss;
	import model.Tree;
	import so.cuo.platform.admob.Admob;
	import so.cuo.platform.admob.AdmobEvent;
	import so.cuo.platform.admob.AdmobPosition;
	import sound.SoundManager;
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
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class GameManager extends BurgerManager {
		
		private var _gameScene:Sprite;
		
		private var _gameTimer:Timer;
		private var _finishTimer:Timer
		private var _trees:Array;
		
		private var _bossCreationRatio:Number;
		private var _treeCreationRatio:Number;
		
		private var _gameHeight:Number;
		private var _gameWidth:Number;
		
		private var _boss:Tree;
		private var _adam:Adam;
		
		private var _scoreField:TextField;
		private var _score:Number;
		private var _lastScore:Number;
		
		private var _textFormat:TextFormat;
		private var _startTime:int;
		
		private var _treeSpeed:Number;
		private var _paused:Boolean;
		
		private var _playButton:SimpleButton;
		private var _pauseButton:SimpleButton;
		private var _muteButton:SimpleButton;
		private var _unmuteButton:SimpleButton;
		
		private var _accelerometer:Accelerometer;
		private var _adamSpeed:Number;
		
		private var _stage:Stage;
		private var _treeLayer:Sprite;
		private var _bossLayer:Sprite;
		private var _adamLayer:Sprite;
		
		private const _adamOffset:Number = 5;
		private var _backgroundSprite:Sprite;
		
		private var _killedTreeCount:int;
		private var _lastKillCount:int;
		
		private const _darbeArray:Array = ["normal", "average", "underwhelming", "overwhelming", "incredible", "amazing", "mindblowing", "proper", "adequate", "solid", "veryGood", "good", "magnificent", "ordinary", "extraordinary", "unbelievable", "insane", "crazy", "weak", "impossible", "critical", "tremendous", "golden", "classy", "sneaky", "deadly", "bruiser"];
		
		private var _admob:Admob;
		private var _massacreTimer:Timer;
		
		private static var _instance:GameManager;
		
		public function GameManager(callback:Function) {
			super(callback);
		}
		
		override protected function init():void {
			super.init();
			
			if (_instance) {
				_instance.destroy();
			}
			
			_instance = this;
			FlashStageHelper.stage.frameRate = 60;
			_stage = Starling.current.stage;
			_treeSpeed = 0.95;
			_score = 0;
			_lastScore = 0;
			_boss = null;
			_bossCreationRatio = 0.05;
			_treeCreationRatio = 0.025;
			_killedTreeCount = 0;
			_lastKillCount = 0;
			_paused = false;
			
			_gameScene = new Sprite();
			_stage.addChild(_gameScene);
			
			_backgroundSprite = new Sprite();
			_backgroundSprite.addChild(Assets.getMovieClip("arkaplan"));
			_gameScene.addChild(_backgroundSprite);
			_gameScene.addChild(Assets.getMovieClip("kesilmisodunlar"));
			
			_bossLayer = new Sprite();
			_gameScene.addChild(_bossLayer);
			
			_treeLayer = new Sprite();
			_gameScene.addChild(_treeLayer);
			
			_adamLayer = new Sprite();
			_gameScene.addChild(_adamLayer);
			_adam = new Adam();
			
			_adam.y = _stage.stageHeight - _adam.clip.height + 5;
			_adam.x = _stage.stageWidth / 2 - _adam.clip.width / 2;
			_adamLayer.addChild(_adam.clip);
			_gameScene.addChild(Assets.getMovieClip("cimenler"));
			
			_admob = Admob.getInstance(); //create a instance
			trace(_admob.supportDevice);
			if (Capabilities.manufacturer.toLowerCase().indexOf("ios") != -1) { //ios
				//ios
				_admob.setKeys("ca-app-pub-7819139870608872/4507989657")
			} else {
				_admob.setKeys("ca-app-pub-7819139870608872/9077790053")
			}
			_admob.addEventListener(AdmobEvent.onBannerReceive, onAdReceived);
			_admob.addEventListener(AdmobEvent.onBannerFailedReceive, onAdFailed);
			_admob.enableTrace = Capabilities.isDebugger;
			_admob.showBanner(Admob.SMART_BANNER, AdmobPosition.TOP_RIGHT);
			
			_trees = new Array();
			SoundManager.instance.playTestereCleanSound();
			_gameScene.addEventListener(TouchEvent.TOUCH, onClick);
			_scoreField = createTextField(LocaleUtil.localize("score") + ": " + _score);
			_scoreField.x = 150;
			_scoreField.y = 15;
			_scoreField.hAlign = HAlign.LEFT;
			_gameScene.addChild(_scoreField);
			_startTime = getTimer();
			
			_gameTimer = new Timer(50);
			_gameTimer.addEventListener(TimerEvent.TIMER, onTick);
			_gameTimer.start();
			
			Starling.current.stage.addEventListener(EnterFrameEvent.ENTER_FRAME, onFrame);
			
			_massacreTimer = new Timer(1000);
			_massacreTimer.addEventListener(TimerEvent.TIMER, onMassacreTimer);
			_massacreTimer.start();
		}
		
		private function onFrame(e:EnterFrameEvent):void {
			if (_adam.dead || _paused) {
				return;
			}
			
			var adamHitBounds:Rectangle = _adam.getHitBounds(_gameScene);
			var sawHitBounds:Rectangle = _adam.getSawHitBounds(_gameScene);
			
			for each (var tree:Tree in _trees) {
				if (tree.dying) {
					continue;
				}
				var treeHitBounds:Rectangle = tree.getHitBounds(_gameScene);
				if (sawHitBounds.intersects(treeHitBounds)) {
					//tree.dying = true;
					//if (tree.isBoss) {
					//eaze(tree.clip).to(4, {y: _stage.stageHeight}).onComplete(onTreeDead, tree);
					//} else {
					//if (tree.facingRight) {
					//eaze(tree.clip).to(2.5, {y: _stage.stageHeight + tree.clip.height, x: tree.clip.x - tree.clip.height, rotation: -Math.PI / 2}).onComplete(onTreeDead, tree);
					//} else {
					//eaze(tree.clip).to(2.5, {y: _stage.stageHeight + tree.clip.height, x: tree.clip.x + tree.clip.height, rotation: Math.PI / 2}).onComplete(onTreeDead, tree);
					//}
					//}
					//var y:Number = _stage.stageHeight - 20 * Math.random();
					//var x:Number = _stage.stageWidth / 2 - Math.random() * 5;
					//if (_adam.scaleX > 0) {
					//x = _stage.stageWidth / 2 + Math.random() * 10;
					//}
					//var hitScoreText:TextField = createTextField(String(Math.floor(Math.random() * 9002)));
					//hitScoreText.x = x;
					//hitScoreText.y = y;
					//_gameScene.addChild(hitScoreText);
					//eaze(hitScoreText).to(2, {y: -hitScoreText.height}).onComplete(onHitScoreFinished, hitScoreText);
					//
					//var randomDarbe:String = _darbeArray[Math.floor(Math.random() * _darbeArray.length)];
					//var localizedDarbe:String = LocaleUtil.localize(randomDarbe) + " " + LocaleUtil.localize("blow") + "!";
					//var darbeText:TextField = createTextField(localizedDarbe);
					//y = _stage.stageHeight - 20 * Math.random();
					//x = _stage.stageWidth / 2 + Math.random() * 5;
					//if (_adam.scaleX > 0) {
					//x = _stage.stageWidth / 2 - Math.random() * 10;
					//}
					//darbeText.x = x;
					//darbeText.y = y;
					//_gameScene.addChild(darbeText);
					//eaze(darbeText).to(2.5, {y: -darbeText.height}).onComplete(onHitScoreFinished, darbeText);
					SoundManager.instance.playTestereHitSound();
				} else if (adamHitBounds.intersects(treeHitBounds)) {
					
						//killAdam();
						//break;
				} else {
					tree.x += tree.speed;
				}
			}
			if (_adam.dead) {
				for each (tree in _trees) {
					tree.killTweens();
				}
				return;
			}
		}
		
		private function onTick(e:TimerEvent):void {
			if (_adam.dead) {
				for each (var tree:Tree in _trees) {
					tree.clip.scaleX *= -1;
					if (tree.clip.scaleX < 0) {
						tree.clip.x += tree.clip.width
					} else {
						tree.clip.x -= tree.clip.width
					}
				}
				return;
			}
			if (_paused) {
				return;
			}
			
			if (_trees.length == 0) {
				SoundManager.instance.stopAgacWalkSound();
			}
			_lastScore = _score;
			_score = int(getTimer() - _startTime);
			_scoreField.text = LocaleUtil.localize("score") + ": " + _score;
			
			checkAchievements();
			
			_treeSpeed *= 1500 / 1499;
			_treeCreationRatio *= 1500 / 1499;
			if (_treeCreationRatio >= Math.random()) {
				var newTree:Tree = new Tree();
				_treeLayer.addChild(newTree.clip);
				
				newTree.y = _stage.stageHeight - newTree.clip.height;
				var left:Boolean = Math.random() < 0.5;
				if (left || newTree is Boss) {
					newTree.facingRight = false;
					newTree.x = _stage.stageWidth;
					newTree.speed = -_treeSpeed;
					_trees.push(newTree);
				} else {
					newTree.facingRight = true;
					GraphicsUtil.reverseHorizontal(newTree.clip);
					newTree.x -= 2 * newTree.clip.width;
					newTree.speed = _treeSpeed;
					_trees.push(newTree);
				}
			}
		}
		
		public function killAdam():void {
			_adam.die();
			SoundManager.instance.stopAgacWalkSound();
			SoundManager.instance.stopBossSound();
			_finishTimer = new Timer(3000, 1);
			_finishTimer.addEventListener(TimerEvent.TIMER, onFinished);
			_finishTimer.start();
			
			for each (var tree:Tree in _trees) {
				tree.killTweens();
			}
			
			if (_killedTreeCount == 0) {
				GameCenterManager.instance.unlockAchievement("dieFirst");
			}
			
			GameCenterManager.instance.incrementAchievement("die10");
			GameCenterManager.instance.incrementAchievement("die100");
			GameCenterManager.instance.incrementAchievement("die1000");
		}
		
		private function checkAchievements():void {
			checkScoreAchievementFor(10000);
			checkScoreAchievementFor(50000);
			checkScoreAchievementFor(100000);
			checkScoreAchievementFor(150000);
			checkScoreAchievementFor(200000);
			checkScoreAchievementFor(300000);
		}
		
		private function checkScoreAchievementFor(desiredScore:Number):void {
			if (_lastScore < desiredScore && _score >= desiredScore) {
				GameCenterManager.instance.unlockAchievement("reach" + desiredScore);
			}
		}
		
		public function onFinished(e:Event = null):void {
			var deathPopup:Sprite = new Sprite();
			
			var deathBg:Quad = new Quad(200, 200, 0x000000);
			deathPopup.addChild(deathBg);
			var deathText:TextField = createTextField(LocaleUtil.localize("deathText"));
			deathText.y = 10;
			deathText.x = 10;
			deathText.hAlign = HAlign.LEFT;
			deathPopup.addChild(deathText);
			
			var scoreText:TextField = createTextField(LocaleUtil.localize(LocaleUtil.localize("score") + ": " + _score));
			scoreText.y = 10 + deathText.height;
			scoreText.x = 10;
			scoreText.hAlign = HAlign.LEFT;
			deathPopup.addChild(scoreText);
			
			deathPopup.x = 300;
			deathPopup.y = 100;
			_stage.addChild(deathPopup);
			
			var menuButton:Button = new Button(Assets.assetManager.getTexture("skipUp"), "", Assets.assetManager.getTexture("skipDown"));
			menuButton.addEventListener(TouchEvent.TOUCH, function(e:TouchEvent):void {
					var touch:Touch = e.getTouch(menuButton, TouchPhase.ENDED);
					if (touch) {
						menuButton.removeEventListeners(TouchEvent.TOUCH);
						destroy();
					}
				});
			menuButton.y = 190 - menuButton.height;
			menuButton.x = 100 - menuButton.width / 2;
			deathPopup.addChild(menuButton);
			
			GameCenterManager.instance.submitScore(_score);
		}
		
		private function onHitScoreFinished(hitScoreText:TextField):void {
			_gameScene.removeChild(hitScoreText);
		}
		
		//
		private function onTreeDead(tree:Tree):void {
			if (tree == _boss) {
				_boss = null;
				_backgroundSprite.removeChildren();
				_backgroundSprite.addChild(Assets.getMovieClip("arkaplan"));
				SoundManager.instance.stopBossSound();
			}
			_trees.splice(_trees.indexOf(tree), 1);
			tree.destroy();
			_killedTreeCount++;
			GameCenterManager.instance.incrementAchievement("kill10");
			GameCenterManager.instance.incrementAchievement("kill100");
			GameCenterManager.instance.incrementAchievement("kill1000");
			GameCenterManager.instance.incrementAchievement("kill10000");
		}
		
		private function onClick(e:TouchEvent):void {
			if (_adam.dead) {
				return;
			}
			
			var touch:Touch = e.getTouch(_gameScene, TouchPhase.BEGAN);
			
			if (!touch) {
				return;
			}
			if (touch.globalX >= _stage.stageWidth / 2) {
				if (_adam.clip.scaleX < 0) {
					GraphicsUtil.reverseHorizontal(_adam.clip);
				}
			} else {
				if (_adam.clip.scaleX > 0) {
					GraphicsUtil.reverseHorizontal(_adam.clip);
				}
			}
		}
		
		private function createTextField(text:String):TextField {
			var textField:TextField = new TextField(200, 75, text, "visitor", 24, 0xffffff);
			return textField;
		}
		
		override protected function destroy(e:Event = null):void {
			
			SoundManager.instance.stopTestereCleanSound();
			for each (var tree:Tree in _trees) {
				tree.destroy();
			}
			
			if (_gameTimer) {
				_gameTimer.removeEventListener(TimerEvent.TIMER, onTick);
				_gameTimer.stop();
				_gameTimer = null;
			}
			
			if (_massacreTimer) {
				_massacreTimer.removeEventListener(TimerEvent.TIMER, onMassacreTimer);
				_massacreTimer.stop();
				_massacreTimer = null;
			}
			
			if (_gameScene) {
				_gameScene.removeEventListener(TouchEvent.TOUCH, onClick);
				_gameScene.removeFromParent(true);
				_gameScene = null;
			}
			
			if (_admob) {
				_admob.hideBanner();
				_admob = null;
			}
			
			_instance = null;
			
			super.destroy(e);
		}
		
		private function onAdFailed(e:AdmobEvent):void {
			trace(e.data);
		}
		
		private function onAdReceived(e:AdmobEvent):void {
			trace(e.data.width, e.data.height);
		}
		
		private function onAccelerometerUpdate(e:AccelerometerEvent):void {
			trace(e.accelerationX);
			_adamSpeed -= e.accelerationX;
		}
		
		private function onMassacreTimer(e:TimerEvent):void {
			if (_killedTreeCount >= _lastKillCount + 10) {
				GameCenterManager.instance.unlockAchievement("kill10Sec1");
			}
			_lastKillCount = _killedTreeCount;
		}
		
		public static function get instance():GameManager {
			return _instance;
		}
	
	}

}