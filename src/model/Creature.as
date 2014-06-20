package model {
	import aze.motion.eaze;
	import feathers.controls.ProgressBar;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import org.osflash.signals.Signal;
	import starling.display.DisplayObjectContainer;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	public class Creature {
		
		private var _creatureDyingSignal:Signal;
		private var _creatureDeadSignal:Signal;
		private var _creatureTookDamageSignal:Signal;
		
		protected var _container:Sprite;
		protected var _clip:MovieClip = null;
		protected var _maxHealth:Number = 3;
		protected var _health:Number = 3;
		protected var _attackDamage:Number = 1;
		protected var _attackSpeed:Number = 1;
		protected var _armor:Number = 0;
		protected var _dying:Boolean = false;
		protected var _dead:Boolean = false;
		protected var _facingRight:Boolean = false;
		
		protected var _speed:Number = 0;
		protected var _x:Number = 0;
		protected var _y:Number = 0;
		
		protected var _lastTakenDamage:Number;
		
		protected var _hitTimer:Timer;
		protected var _hitTargets:Array;
		
		protected var _lifeBar:ProgressBar;
		
		public function Creature() {
			_container = new Sprite();
			_hitTargets = new Array();
			_creatureDyingSignal = new Signal();
			_creatureDeadSignal = new Signal();
			_creatureTookDamageSignal = new Signal();
		}
		
		public function startHitting():void {
			if (isHitting()) {
				return;
			}
			_hitTimer = new Timer(1000 / _attackSpeed);
			_hitTimer.addEventListener(TimerEvent.TIMER, onHit);
			_hitTimer.start();
		}
		
		public function stopHitting():void {
			if (_hitTimer) {
				_hitTimer.removeEventListener(TimerEvent.TIMER, onHit);
				_hitTimer = null;
			}
		}
		
		public function isHitting():Boolean {
			return _hitTimer != null;
		}
		
		protected function onHit(e:TimerEvent = null):void {
			for each (var creature:Creature in _hitTargets) {
				creature.takeDamage(_attackDamage);
			}
		}
		
		public function addHitTarget(creature:Creature):void {
			if (_hitTargets.indexOf(creature) < 0) {
				_hitTargets.push(creature);
			}
		}
		
		public function removeHitTarget(creature:Creature):void {
			if (_hitTargets.indexOf(creature) >= 0) {
				_hitTargets.splice(_hitTargets.indexOf(creature), 1);
			}
		}
		
		public function removeAllHitTargets():void {
			_hitTargets = new Array();
		}
		
		public function takeDamage(damage:Number):void {
			_health = Math.max(_health - damage, 0);
			_lastTakenDamage = damage;
			creatureTookDamageSignal.dispatch(this);
			
			if (!_lifeBar) {
				createLifeBar();
			}
			_lifeBar.value = _health;
			if (_health <= 0) {
				die();
			}
		}
		
		private function createLifeBar():void {
			_lifeBar = new ProgressBar();
			_lifeBar.minimum = 0;
			_lifeBar.maximum = _maxHealth;
			_lifeBar.value = _health;
			_lifeBar.setSize(75, 10);
			_lifeBar.x = _container.width / 2 - _lifeBar.width / 2;
			_lifeBar.y = -_lifeBar.height - 5;
			_container.addChild(_lifeBar);
		}
		
		public function die():void {
			_dying = true;
			stopHitting();
			creatureDyingSignal.dispatch(this);
		}
		
		public function destroy(e:Event = null):void {
			stopHitting();
			if (_clip) {
				_clip.removeFromParent(true);
				_clip = null
			}
			if (_lifeBar) {
				_lifeBar.removeFromParent(true);
				_lifeBar = null;
			}
			if (_container) {
				killTweens();
				_container.removeFromParent(true);
				_container = null;
			}
			creatureDeadSignal.dispatch(this);
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
			if (_container) {
				eaze(_container).killTweens();
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
			if (_container) {
				_container.x = _x;
			}
		}
		
		public function get y():Number {
			return _y;
		}
		
		public function set y(value:Number):void {
			_y = value;
			if (_container) {
				_container.y = _y;
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
		
		public function get lastTakenDamage():Number {
			return _lastTakenDamage;
		}
		
		public function get maxHealth():Number {
			return _maxHealth;
		}
		
		public function set maxHealth(value:Number):void {
			_maxHealth = value;
		}
		
		public function get container():Sprite {
			return _container;
		}
		
		public function get creatureDyingSignal():Signal {
			return _creatureDyingSignal;
		}
		
		public function get creatureDeadSignal():Signal {
			return _creatureDeadSignal;
		}
		
		public function get creatureTookDamageSignal():Signal {
			return _creatureTookDamageSignal;
		}
	
	}

}