package socialfaceicon.model.friendfeed
{
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	
	import mx.utils.Base64Encoder;
	
	public class FFeedSession
	{
		public static var _username:String;
		public static var _password:String;
		public static var _authHeader:URLRequestHeader;
		
		public function FFeedSession()
		{
		}
		
		public static function get username():String {
			return _username;
		}
		
		public static function get password():String {
			return _password;
		}
		
		public static function start(username:String, password:String):void {
			_username = username;
			_password = password;
			_authHeader = createAuthHeader();
		}
		
		private static function createAuthHeader():URLRequestHeader {
			if (!username || !password) {
				return null;
			}
			var encoder:Base64Encoder = new Base64Encoder();
			encoder.encode(username + ":" + password);
			return new URLRequestHeader(
						"Authorization",
						"Basic " + encoder.toString());
		}
		
		public static function createRequest(url:String):URLRequest {
			var r:URLRequest = new URLRequest(url);
			if (_authHeader) {
				r.requestHeaders = [_authHeader];
			}
			return r;
		}
	}
}