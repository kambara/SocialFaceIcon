package socialfaceicon.model
{
	import jp.cre8system.framework.airrecord.model.ARModel;

	public class Setting extends ARModel
	{
		private static var TWITTER_USERNAME:String = "twitter_username";
		private static var TWITTER_PASSWORD:String = "twitter_password";
		
		public function Setting()
		{
			super();
			this.__table = "settings";
		}
		
		public static function getValue(k:String):String {
			var setting:Setting = new Setting();
			var obj:Object = setting.findone({key: k});
			return obj ? obj.value : null;
		}
		
		public static function setValue(k:String, v:String):void {
			var setting:Setting = new Setting();
			if (setting.findone({key: k})) {
				setting.del({key: k});
			}
			setting.insert({key: k, value: v});
		}
		
		//
		// Twitter
		//
		public static function get twitterUsername():String {
			return Setting.getValue(TWITTER_USERNAME);
		}
		
		public static function set twitterUsername(val:String):void {
			Setting.setValue(TWITTER_USERNAME, val);
		}
		
		public static function get twitterPassword():String {
			return Setting.getValue(TWITTER_PASSWORD);
		}
		
		public static function set twitterPassword(val:String):void {
			Setting.setValue(TWITTER_PASSWORD, val);
		}
		
		//
		// Friendfeed
		//
		public static function get friendfeedUsername():String {
			return Setting.getValue("friendfeed_username");
		}
		
		public static function set friendfeedUsername(val:String):void {
			Setting.setValue("friendfeed_username", val);
		}
		
		public static function get friendfeedRemoteKey():String {
			return Setting.getValue("friendfeed_remotekey");
		}
		
		public static function set friendfeedRemoteKey(val:String):void {
			Setting.setValue("friendfeed_remotekey", val);
		}
	}
}