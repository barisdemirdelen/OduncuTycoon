package model {
	import flash.geom.Rectangle;
	import starling.display.DisplayObjectContainer;
	import starling.display.MovieClip;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class Adam extends Creature {
		
		protected const ADAM_EXPLODE:Rectangle = new Rectangle(-319, -30, 551, -148);
		protected const ADAM_HITBOX:Rectangle = new Rectangle(28, 10, 29, 87);
		protected const SAW_HITBOX:Rectangle = new Rectangle(57, 53, 38, 20);
		
		protected var _explodeClip:MovieClip;
		
		public function Adam() {
			_clip = Assets.getMovieClip("sagadogru");
			_explodeClip = Assets.getMovieClip("adamSprite");
			_explodeClip.loop = false;
			_explodeClip.stop();
		}
		
		override public function die():void {
			super.die();
			
			var parent:DisplayObjectContainer = _clip.parent;
			_clip.removeFromParent(true);
			parent.addChild(_explodeClip);
			_explodeClip.y = 80;
			_explodeClip.play();
			
			if (_clip.scaleX < 0) {
				GraphicsUtil.reverseHorizontal(_explodeClip);
			}
			
			_dead = true;
		}
		
		override public function getHitBounds(scene:DisplayObjectContainer, hitbox:Rectangle = null):Rectangle {
			var adamHitBounds:Rectangle = super.getHitBounds(scene, hitbox ? hitbox : ADAM_HITBOX);
			if (_clip.scaleX < 0) {
				adamHitBounds.offset(ADAM_HITBOX.x / 2, 0);
			}
			return adamHitBounds;
		}
		
		public function getSawHitBounds(scene:DisplayObjectContainer):Rectangle {
			var clipBounds:Rectangle = _clip.getBounds(scene);
			var sawHitBounds:Rectangle = SAW_HITBOX.clone();
			if (_clip.scaleX < 0) {
				sawHitBounds.offset(-ADAM_HITBOX.width - SAW_HITBOX.x / 2 + 5, 0);
			}
			sawHitBounds.offset(clipBounds.x, clipBounds.y);
			return sawHitBounds;
		}
		
		public function get explodeClip():MovieClip {
			return _explodeClip;
		}
		
		public function set explodeClip(value:MovieClip):void {
			_explodeClip = value;
		}
	
	}

}