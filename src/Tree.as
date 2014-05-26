package {
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class Tree {
		
		private var _clip:MovieClip;
		private var _isBoss:Boolean = false;
		private var _dying:Boolean = false;
		private var _facingRight:Boolean = false;
		
		private var _animationNums:Array;
		
		public function Tree(boss:Boolean = false) {
			if (boss) {
				_clip = Assets.getMovieClip("bossagac");
				_isBoss = true;
			} else {
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
			}
		}
		
		public function destroy():void {
			if (_clip) {
				_clip.removeFromParent(true);
				_clip = null;
			}
		}
		
		public function get clip():MovieClip {
			return _clip;
		}
		
		public function set clip(value:MovieClip):void {
			_clip = value;
		}
		
		public function get isBoss():Boolean {
			return _isBoss;
		}
		
		public function get dying():Boolean {
			return _dying;
		}
		
		public function set dying(value:Boolean):void {
			_dying = value;
		}
		
		public function get facingRight():Boolean {
			return _facingRight;
		}
		
		public function set facingRight(value:Boolean):void {
			_facingRight = value;
		}
	
	}

}