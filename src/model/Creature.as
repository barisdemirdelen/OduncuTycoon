package model {
	import aze.motion.eaze;
	import flash.geom.Rectangle;
	import starling.display.DisplayObjectContainer;
	import starling.display.MovieClip;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class Creature {
		
		protected var _clip:MovieClip = null;
		protected var _health:Number = 0;
		protected var _attackDamage:Number = 0;
		protected var _attackSpeed:Number = 0;
		protected var _armor:Number = 0;
		protected var _dying:Boolean = false;
		protected var _dead:Boolean = false;
		protected var _facingRight:Boolean = false;
		
		protected var _speed:Number = 0;
		protected var _x:Number = 0;
		protected var _y:Number = 0;
		
		public function Creature() {
		}
		
		public function takeDamage(damage:Number):void {
			_health = _health - damage;
			if (_health <= 0) {
				die();
			}
		}
		
		public function die():void {
			_dying = true;
		}
		
		public function destroy():void {
			if (_clip) {
				killTweens();
				_clip.removeFromParent(true);
				_clip = null
			}
		}
		
		public function getHitBounds(scene:DisplayObjectContainer, hitbox:Rectangle = null):Rectangle {
			var clipBounds:Rectangle = _clip.getBounds(scene);
			if (!hitbox) {
				hitbox = clipBounds;
			}
			var creatureHitBounds:Rectangle = hitbox.clone();
			if (clip.scaleX < 0) {
				creatureHitBounds.offset(creatureHitBounds.width - creatureHitBounds.x, 0);
			}
			creatureHitBounds.offset(clipBounds.x, clipBounds.y);
			return creatureHitBounds;
		}
		
		public function killTweens():void {
			if (_clip) {
				eaze(_clip).killTweens();
			}
		}
		
		public function get health():Number {
			return _health;
		}
		
		public function set health(value:Number):void {
			_health = value;
		}
		
		public function get attackDamage():Number {
			return _attackDamage;
		}
		
		public function set attackDamage(value:Number):void {
			_attackDamage = value;
		}
		
		public function get attackSpeed():Number {
			return _attackSpeed;
		}
		
		public function set attackSpeed(value:Number):void {
			_attackSpeed = value;
		}
		
		public function get armor():Number {
			return _armor;
		}
		
		public function set armor(value:Number):void {
			_armor = value;
		}
		
		public function get facingRight():Boolean {
			return _facingRight;
		}
		
		public function set facingRight(value:Boolean):void {
			_facingRight = value;
		}
		
		public function get dying():Boolean {
			return _dying;
		}
		
		public function set dying(value:Boolean):void {
			_dying = value;
		}
		
		public function get speed():Number {
			return _speed;
		}
		
		public function set speed(value:Number):void {
			_speed = value;
		}
		
		public function get x():Number {
			return _x;
		}
		
		public function set x(value:Number):void {
			_x = value;
			if (_clip) {
				_clip.x = _x;
			}
		}
		
		public function get y():Number {
			return _y;
		}
		
		public function set y(value:Number):void {
			_y = value;
			if (_clip) {
				_clip.y = _y;
			}
		}
		
		public function get dead():Boolean {
			return _dead;
		}
		
		public function set dead(value:Boolean):void {
			_dead = value;
		}
		
		public function get clip():MovieClip {
			return _clip;
		}
		
		public function set clip(value:MovieClip):void {
			_clip = value;
		}
	
	}

}