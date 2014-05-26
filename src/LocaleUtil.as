package {
	import flash.system.Capabilities;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	/**
	 * ...
	 * @author Barış Demirdelen
	 */
	
	[ResourceBundle("strings")]
	public class LocaleUtil {
		
		private static var _locale:String;
		
		public static function initialize():void {
			var resourceManager:IResourceManager = ResourceManager.getInstance();
			_locale = 'en_US';
			var langs:Array = Capabilities.languages;
			
			for each (var lang:String in langs) {
				lang = lang.toUpperCase();
				if (lang.indexOf("EN") > -1) {
					_locale = 'en_US';
					break;
				} else if (lang.indexOf("TR") > -1) {
					_locale = 'tr_TR';
					break;
				}
			}
			
			resourceManager.localeChain = [_locale];
		}
		
		public static function localize(text:String):String {
			var resourceManager:IResourceManager = ResourceManager.getInstance();
			var localizedString:String = resourceManager.getString("strings", text, null, _locale);
			return  localizedString != "undefined" && localizedString!= null ? localizedString : text;
		}
	
	}

}