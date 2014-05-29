package model {
	import aze.motion.eaze;
	import flash.geom.Rectangle;
	import model.Creature;
	import sound.SoundManager;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	import util.Assets;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class Tree extends Creature {
		
		protected const TREE_HITBOX:Rectangle = new Rectangle(65, 28, 42, 276);
		protected var _animationNums:Array;
		
		public function Tree() {
			_clip = Assets.getMovieClip("sagdan");
			
			_animationNums = [1, 2, 3, 4];
			
			_animationNums.splice(Math.floor(Math.random() * _animationNums.length), 1);
			
			var twoAnim:Boolean = Math.random() < 0.5;
			if (twoAnim) {
				_animationNums.splice(Math.floor(Math.random() * _animationNums.length), 1);
			}
			var shuffledNumbers:Array = new Array(_animationNums.length);
			var randomPos:int = 0;
			for (var i:int = 0; i < shuffledNumbers.length; i++) {
				randomPos = int(Math.random() * _animationNums.length);
				shuffledNumbers[i] = _animationNums.splice(randomPos, 1)[0]; //since splice() returns an Array, we have to specify that we want the first (only) element
			}
			var textures:Vector.<Texture> = new Vector.<Texture>();
			for each (var j:int in shuffledNumbers) {
				textures.push(Assets.assetManager.getTexture("sagdan" + j + "new"));
			}
			_clip = new MovieClip(textures, 30);
			
			if (_clip.numFrames > 1) {
				Starling.juggler.add(_clip);
				_clip.play();
			}
			
			if (!SoundManager.instance.isAgacPlaying()) {
				SoundManager.instance.playAgacWalkSound();
			}
		}
		
		override public function die():void {
			super.die();
			if (_clip) {
				if (_facingRight) {
					eaze(_clip).to(2.5, {y: Starling.current.stage.stageHeight + _clip.height, x: _x - _clip.height, rotation: -Math.PI / 2}).onComplete(destroy);
				} else {
					eaze(_clip).to(2.5, {y: Starling.current.stage.stageHeight + _clip.height, x: _x + _clip.height, rotation: Math.PI / 2}).onComplete(destroy);
				}
			} else {
				destroy();
			}
		}
		
		public function deathDance():void {
			_clip.scaleX *= -1;
			if (_clip.scaleX < 0) {
				_clip.x += _clip.width
			} else {
				_clip.x -= _clip.width
			}
		}
		
		override public function getHitBounds(scene:DisplayObjectContainer, hitbox:Rectangle = null):Rectangle {
			var treeHitBounds:Rectangle = super.getHitBounds(scene, hitbox ? hitbox : TREE_HITBOX);
			return treeHitBounds;
		}
	}
}