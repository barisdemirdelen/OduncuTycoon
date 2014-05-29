package model {
	import flash.geom.Rectangle;
	import starling.display.DisplayObjectContainer;
	import util.Assets;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class Boss extends Creature {
		
		protected const BOSS_HITBOX:Rectangle = new Rectangle(11, 149, 532, 400);
		
		public function Boss() {
			_clip = Assets.getMovieClip("bossagac");
		}
		
		override public function getHitBounds(scene:DisplayObjectContainer, hitbox:Rectangle = null):Rectangle {
			var treeHitBounds:Rectangle = super.getHitBounds(scene, hitbox ? hitbox : BOSS_HITBOX);
			return treeHitBounds;
		}
	
	}
}