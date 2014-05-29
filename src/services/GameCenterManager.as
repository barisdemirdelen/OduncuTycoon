package services {
	import com.adobe.ane.gameCenter.GameCenterAchievementEvent;
	import com.adobe.ane.gameCenter.GameCenterAuthenticationEvent;
	import com.adobe.ane.gameCenter.GameCenterController;
	import com.adobe.ane.gameCenter.GameCenterLeaderboardEvent;
	import com.milkmangames.nativeextensions.events.GoogleGamesEvent;
	import com.milkmangames.nativeextensions.GoogleGames;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 */
	public class GameCenterManager {
		
		private static var _instance:GameCenterManager;
		private var _controller:GameCenterController;
		private var _googleIdDic:Dictionary;
		
		public function GameCenterManager() {
			if (_instance) {
				return;
			}
			_googleIdDic = new Dictionary();
			_googleIdDic["reach10000"] = "CgkImtX1jeAFEAIQAg";
			_googleIdDic["reach50000"] = "CgkImtX1jeAFEAIQCQ";
			_googleIdDic["reach100000"] = "CgkImtX1jeAFEAIQAw";
			_googleIdDic["reach150000"] = "CgkImtX1jeAFEAIQBA";
			_googleIdDic["reach200000"] = "CgkImtX1jeAFEAIQBQ";
			_googleIdDic["reach300000"] = "CgkImtX1jeAFEAIQBg";
			_googleIdDic["kill10"] = "CgkImtX1jeAFEAIQCg";
			_googleIdDic["kill100"] = "CgkImtX1jeAFEAIQCw";
			_googleIdDic["kill1000"] = "CgkImtX1jeAFEAIQDA";
			_googleIdDic["kill10000"] = "CgkImtX1jeAFEAIQDQ";
			_googleIdDic["dieFirst"] = "CgkImtX1jeAFEAIQDg";
			_googleIdDic["kill10Sec1"] = "CgkImtX1jeAFEAIQDw";
			_googleIdDic["die10"] = "CgkImtX1jeAFEAIQEA";
			_googleIdDic["die100"] = "CgkImtX1jeAFEAIQEQ";
			_googleIdDic["die1000"] = "CgkImtX1jeAFEAIQEg";
			_googleIdDic["highScore"] = "CgkImtX1jeAFEAIQAQ";
		}
		
		public static function get isSupported():Boolean {
			return GameCenterController.isSupported || GoogleGames.isSupported();
		}
		
		public function initialize():void {
			if (GameCenterController.isSupported) {
				trace("gc supported");
				_controller = new GameCenterController();
				
				_controller.addEventListener(GameCenterLeaderboardEvent.SUBMIT_SCORE_SUCCEEDED, onScoreSubmitted);
				_controller.addEventListener(GameCenterLeaderboardEvent.SUBMIT_SCORE_FAILED, onScoreFailed);
				_controller.addEventListener(GameCenterAchievementEvent.SUBMIT_ACHIEVEMENT_SUCCEEDED, onAchievementSubmitted);
				_controller.addEventListener(GameCenterAchievementEvent.SUBMIT_ACHIEVEMENT_FAILED, onAchievementFailed);
				_controller.addEventListener(GameCenterAuthenticationEvent.PLAYER_AUTHENTICATED, onAuthenticated);
				
				_controller.authenticate();
			}
			if (GoogleGames.isSupported()) {
				trace("google play supported");
				GoogleGames.create();
				
				GoogleGames.games.addEventListener(GoogleGamesEvent.SIGN_IN_SUCCEEDED, onGoogleSignInSuccess);
				GoogleGames.games.addEventListener(GoogleGamesEvent.SIGN_IN_FAILED, onGoogleSignInFail);
				GoogleGames.games.addEventListener(GoogleGamesEvent.SIGNED_OUT, onGoogleSignOut);
				GoogleGames.games.addEventListener(GoogleGamesEvent.UNLOCK_ACHIEVEMENT_SUCCEEDED, onAchievementSubmitted);
				GoogleGames.games.addEventListener(GoogleGamesEvent.UNLOCK_ACHIEVEMENT_FAILED, onAchievementFailed);
				GoogleGames.games.addEventListener(GoogleGamesEvent.SUBMIT_SCORE_SUCCEEDED, onScoreSubmitted);
				GoogleGames.games.addEventListener(GoogleGamesEvent.SUBMIT_SCORE_FAILED, onScoreFailed);
				
				GoogleGames.games.signIn();
			}
		}
		
		private function onGoogleSignInSuccess(e:GoogleGamesEvent):void {
			trace("google play authenticated! " + e.toString());
		}
		
		private function onGoogleSignInFail(e:GoogleGamesEvent):void {
			trace("google play failed authenticating! " + e.toString() + " " + e.failureReason);
		}
		
		private function onGoogleSignOut(e:GoogleGamesEvent):void {
			trace("google play signed out! " + e.toString());
		}
		
		private function onAuthenticated(e:GameCenterAuthenticationEvent):void {
			trace("gc authenticated! " + e.toString());
		}
		
		private function onScoreSubmitted(e:Event):void {
			trace("Success : " + e.toString());
		}
		
		private function onScoreFailed(e:Event):void {
			trace("Fail! : " + e.toString());
		}
		
		private function onAchievementSubmitted(e:Event):void {
			trace("Success : " + e.toString());
		}
		
		private function onAchievementFailed(e:Event):void {
			trace("Fail! : " + e.toString());
		}
		
		public static function get instance():GameCenterManager {
			if (!_instance) {
				_instance = new GameCenterManager();
			}
			return _instance;
		}
		
		public function showLeaderboardView():void {
			var leaderboardName:String = "highScore";
			if (GameCenterController.isSupported) {
				_controller.showLeaderboardView(leaderboardName);
			}
			if (GoogleGames.isSupported()) {
				GoogleGames.games.showLeaderboard(_googleIdDic[leaderboardName]);
			}
		}
		
		public function showAchievementsView():void {
			if (GameCenterController.isSupported) {
				_controller.showAchievementsView();
			}
			if (GoogleGames.isSupported()) {
				GoogleGames.games.showAchievements();
			}
		}
		
		public function submitScore(score:int):void {
			var leaderboardName:String = "highScore";
			if (GameCenterController.isSupported) {
				if (!_controller.authenticated) {
					_controller.authenticate();
				}
				trace("submitting gc score");
				_controller.submitScore(score, leaderboardName);
			}
			if (GoogleGames.isSupported()) {
				trace("submitting google play score: " + score);
				GoogleGames.games.submitScore(_googleIdDic[leaderboardName], score);
			}
		}
		
		public function unlockAchievement(achievementName:String):void {
			if (GameCenterController.isSupported) {
				if (!_controller.authenticated) {
					_controller.authenticate();
				}
				trace("submitting gc achievement: " + achievementName);
				_controller.submitAchievement(achievementName, 100);
			}
			if (GoogleGames.isSupported()) {
				trace("senging google achievement: " + achievementName);
				GoogleGames.games.unlockAchievement(_googleIdDic[achievementName]);
			}
		}
		
		public function incrementAchievement(achievementName:String, count:int = 1):void {
			if (GameCenterController.isSupported) {
				if (!_controller.authenticated) {
					_controller.authenticate();
				}
				trace("submitting gc achievement: " + achievementName);
				_controller.submitAchievement(achievementName, count);
			}
			if (GoogleGames.isSupported()) {
				trace("senging google achievement: " + achievementName);
				GoogleGames.games.incrementAchievement(_googleIdDic[achievementName], count);
			}
		}
	
	}

}