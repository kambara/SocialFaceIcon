package socialfaceicon.model
{
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	
	import mx.utils.Base64Encoder;
	
	public class TwitSession
	{
		private static var _username:String;
		private static var _password:String;
		private static var _authHeader:URLRequestHeader;
		
		public static function get username():String {
			return TwitSession._username;
		}
		
		public static function get password():String {
			return TwitSession._password;
		}
		
		public static function start(username:String, password:String):void {
			TwitSession._username = username;
			TwitSession._password = password;
			TwitSession._authHeader = createAuthHeader();
		}
		
		private static function createAuthHeader():URLRequestHeader {
			if (!TwitSession.username || !TwitSession.password) {
				return null;
			}
			var encoder:Base64Encoder = new Base64Encoder();
			encoder.encode(TwitSession.username + ":" + TwitSession.password);
			return new URLRequestHeader(
						"Authorization",
						"Basic " + encoder.toString());
		}
		
		public static function createRequest(url:String):URLRequest {
			var r:URLRequest = new URLRequest(url);
			if (TwitSession._authHeader) {
				r.requestHeaders = [TwitSession._authHeader];
			}
			return r;
		}
	}
}