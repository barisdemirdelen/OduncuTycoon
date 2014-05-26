package {
	import aze.motion.easing.Linear;
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
	import so.cuo.platform.admob.Admob;
	import so.cuo.platform.admob.AdmobEvent;
	import so.cuo.platform.admob.AdmobPosition;
	import sound.SoundManager;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Stage;
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
		private var _adam:MovieClip;
		private var _adamPatlama:MovieClip;
		
		private var _gameTimer:Timer;
		private var _finishTimer:Timer
		private var _trees:Array;
		
		private var _bossCreationRatio:Number;
		private var _treeCreationRatio:Number;
		
		private var _gameHeight:Number;
		private var _gameWidth:Number;
		
		private var _boss:Tree;
		private var _dead:Boolean;
		
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
		
		private const _adamOffset:Number = 5;
		private var _backgroundSprite:Sprite;
		
		private const ADAM_PATLAMA:Rectangle = new Rectangle(-319, -30, 551, -148);
		private const ADAM_HITBOX:Rectangle = new Rectangle(28, 10, 29, 87);
		private const SAW_HITBOX:Rectangle = new Rectangle(57, 53, 38, 20);
		private const TREE_HITBOX:Rectangle = new Rectangle(65, 28, 42, 276);
		private const BOSS_HITBOX:Rectangle = new Rectangle(11, 149, 532, 400);
		
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
			_treeSpeed = 30;
			_score = 0;
			_lastScore = 0;
			_dead = false;
			_boss = null;
			_bossCreationRatio = 0.05;
			_treeCreationRatio = 0.025;
			_adamSpeed = 0;
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
			
			_adam = Assets.getMovieClip("sagadogru");
			_adamPatlama = Assets.getMovieClip("adamSprite");
			_adamPatlama.loop = false;
			_adamPatlama.stop();
			
			_adam.y = _stage.stageHeight - _adam.height + 5;
			_adam.x = _stage.stageWidth / 2 - _adam.width / 2;
			_gameScene.addChild(_adam);
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
			
			//if(!_banner) {
			//if (Capabilities.manufacturer.toLowerCase().indexOf("ios") != -1) {
			////ios
			//_banner = new MoPubBanner("3267561bf1e24a9ba7faf0272a1f6e32", MoPubSize.banner);
			//} else {
			//_banner = new MoPubBanner("84c56954f79242e9aa1cf146a5a1a5b5", MoPubSize.banner);
			//}
			//
			//if(_banner) {
			//_banner.y = 0;
			//_banner.x = Starling.current.nativeStage.width - 320;
			//_banner.width = 320;
			//_banner.height = 50;
			//_banner.load();
			//_banner.show();
			//}
			//}
			
			_trees = new Array();
			SoundManager.instance.playTestereCleanSound();
			_gameScene.addEventListener(TouchEvent.TOUCH, onClick);
			_scoreField = createTextField(LocaleUtil.localize("score") + ": " + _score);
			_scoreField.x = 150;
			_scoreField.y = 15;
			_scoreField.hAlign = HAlign.LEFT;
			_gameScene.addChild(_scoreField);
			_startTime = getTimer();
			//
			//_accelerometer = new Accelerometer();
			//if (Accelerometer.isSupported) {
			////_accelerometer.addEventListener(AccelerometerEvent.UPDATE, onAccelerometerUpdate);
			//}
			//
			_gameTimer = new Timer(50);
			_gameTimer.addEventListener(TimerEvent.TIMER, onTick);
			_gameTimer.start();
			
			_massacreTimer = new Timer(1000);
			_massacreTimer.addEventListener(TimerEvent.TIMER, onMassacreTimer);
			_massacreTimer.start();
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
		
		private function onTick(e:TimerEvent):void {
			if (_dead) {
				for each (var tree2:Tree in _trees) {
					tree2.clip.scaleX *= -1;
					if (tree2.clip.scaleX < 0) {
						tree2.clip.x += tree2.clip.width
					} else {
						tree2.clip.x -= tree2.clip.width
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
			
			_treeSpeed *= 1499 / 1500;
			_treeCreationRatio *= 1500 / 1499;
			//
			if (_treeCreationRatio >= Math.random()) {
				if (!_boss && _bossCreationRatio >= Math.random()) {
					newTree = new Tree(true);
					_boss = newTree;
					_backgroundSprite.removeChildren();
					_backgroundSprite.addChild(Assets.getMovieClip("bossarkaplan"));
					SoundManager.instance.playBossSound();
					_bossLayer.addChild(newTree.clip);
				} else {
					var newTree:Tree = new Tree(false);
					_treeLayer.addChild(newTree.clip);
				}
				if (!SoundManager.instance.isAgacPlaying()) {
					SoundManager.instance.playAgacWalkSound();
				}
				
				newTree.clip.y = _stage.stageHeight - newTree.clip.height
				var left:Boolean = Math.random() < 0.5;
				if (left || newTree.isBoss) {
					newTree.facingRight = false;
					newTree.clip.x = _stage.stageWidth;
					//
					eaze(newTree.clip).easing(Linear.easeNone).to(_treeSpeed, {x: -newTree.clip.width}).onComplete(onTreeDead, newTree);
					_trees.push(newTree);
				} else {
					newTree.facingRight = true;
					GraphicsUtil.reverseHorizontal(newTree.clip);
					newTree.clip.x -= 2 * newTree.clip.width;
					
					eaze(newTree.clip).easing(Linear.easeNone).to(_treeSpeed, {x: _stage.stageWidth}).onComplete(onTreeDead, newTree);
					_trees.push(newTree);
				}
			}
			//
			
			var adamBounds:Rectangle = _adam.getBounds(_gameScene);
			var adamHitBounds:Rectangle = ADAM_HITBOX.clone();
			var sawHitBounds:Rectangle = SAW_HITBOX.clone();
			if (_adam.scaleX < 0) {
				adamHitBounds.offset(ADAM_HITBOX.width - ADAM_HITBOX.x / 2, 0);
				sawHitBounds.offset(-ADAM_HITBOX.width - SAW_HITBOX.x / 2 + 5, 0);
			}
			adamHitBounds.offset(adamBounds.x, adamBounds.y);
			sawHitBounds.offset(adamBounds.x, adamBounds.y);
			
			for each (var tree:Tree in _trees) {
				if (tree.dying) {
					continue;
				}
				
				var treeBounds:Rectangle = tree.clip.getBounds(_gameScene);
				var treeHitBounds:Rectangle = tree.isBoss ? BOSS_HITBOX.clone() : TREE_HITBOX.clone();
				if (tree.clip.scaleX < 0) {
					treeHitBounds.offset(tree.isBoss ? BOSS_HITBOX.width - BOSS_HITBOX.x : TREE_HITBOX.width - TREE_HITBOX.x, 0);
				}
				treeHitBounds.offset(treeBounds.x, treeBounds.y);
				
				if (sawHitBounds.intersects(treeHitBounds)) {
					tree.dying = true;
					if (tree.isBoss) {
						eaze(tree.clip).to(4, {y: _stage.stageHeight}).onComplete(onTreeDead, tree);
					} else {
						if (tree.facingRight) {
							eaze(tree.clip).to(2.5, {y: _stage.stageHeight + tree.clip.height, x: tree.clip.x - tree.clip.height, rotation: -Math.PI / 2}).onComplete(onTreeDead, tree);
						} else {
							eaze(tree.clip).to(2.5, {y: _stage.stageHeight + tree.clip.height, x: tree.clip.x + tree.clip.height, rotation: Math.PI / 2}).onComplete(onTreeDead, tree);
						}
					}
					var y:Number = _stage.stageHeight - 20 * Math.random();
					var x:Number = _stage.stageWidth / 2 - Math.random() * 5;
					if (_adam.scaleX > 0) {
						x = _stage.stageWidth / 2 + Math.random() * 10;
					}
					var hitScoreText:TextField = createTextField(String(Math.floor(Math.random() * 9002)));
					hitScoreText.x = x;
					hitScoreText.y = y;
					_gameScene.addChild(hitScoreText);
					eaze(hitScoreText).to(2, {y: -hitScoreText.height}).onComplete(onHitScoreFinished, hitScoreText);
					
					var randomDarbe:String = _darbeArray[Math.floor(Math.random() * _darbeArray.length)];
					var localizedDarbe:String = LocaleUtil.localize(randomDarbe) + " " + LocaleUtil.localize("blow") + "!";
					var darbeText:TextField = createTextField(localizedDarbe);
					y = _stage.stageHeight - 20 * Math.random();
					x = _stage.stageWidth / 2 + Math.random() * 5;
					if (_adam.scaleX > 0) {
						x = _stage.stageWidth / 2 - Math.random() * 10;
					}
					darbeText.x = x;
					darbeText.y = y;
					_gameScene.addChild(darbeText);
					eaze(darbeText).to(2.5, {y: -darbeText.height}).onComplete(onHitScoreFinished, darbeText);
					SoundManager.instance.playTestereHitSound();
				}
				
				if (adamHitBounds.intersects(treeHitBounds)) {
					killAdam();
					break;
				}
			}
			if (_dead) {
				for each (tree in _trees) {
					eaze(tree.clip).killTweens();
				}
				return;
			}
		}
		
		public function killAdam():void {
			_gameScene.removeChild(_adam);
			_gameScene.addChild(_adamPatlama);
			_adamPatlama.y = 80;
			_adamPatlama.play();
			
			if (_adam.scaleX < 0) {
				GraphicsUtil.reverseHorizontal(_adamPatlama);
			}
			
			_dead = true;
			SoundManager.instance.stopAgacWalkSound();
			SoundManager.instance.stopBossSound();
			_finishTimer = new Timer(3000, 1);
			_finishTimer.addEventListener(TimerEvent.TIMER, onFinished);
			_finishTimer.start();
			
			for each (var tree:Tree in _trees) {
				eaze(tree.clip).killTweens();
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
			if (_dead) {
				return;
			}
			
			var touch:Touch = e.getTouch(_gameScene, TouchPhase.BEGAN);
			
			if (!touch) {
				return;
			}
			if (touch.globalX >= _stage.stageWidth / 2) {
				if (_adam.scaleX < 0) {
					GraphicsUtil.reverseHorizontal(_adam);
				}
			} else {
				if (_adam.scaleX > 0) {
					GraphicsUtil.reverseHorizontal(_adam);
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
		
		public static function get instance():GameManager {
			return _instance;
		}
	
	}

}