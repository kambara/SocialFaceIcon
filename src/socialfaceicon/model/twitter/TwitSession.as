package socialfaceicon.model.twitter
{
	import flash.events.EventDispatcher;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	
	import org.iotashan.oauth.OAuthToken;
	
	import socialfaceicon.config.Config;
	
	public class TwitSession extends EventDispatcher
	{
		private var twitOAuth:TwitOAuth;
		private static var instance:TwitSession;
		
		public function TwitSession():void {
			twitOAuth = new TwitOAuth(
							Config.TWITTER_CONSUMER_KEY,
							Config.TWITTER_CONSUMER_SECRET);
			twitOAuth.addEventListener(TwitOAuthEvent.VERIFY_TOKEN,
				function(event:TwitOAuthEvent):void {
					saveToken(event.token);
					dispatchEvent( new TwitSessionEvent(TwitSessionEvent.START) );
				});
			twitOAuth.addEventListener(TwitOAuthEvent.VERIFY_ERROR, function(event:TwitOAuthEvent):void {
				dispatchEvent( new TwitSessionEvent(TwitSessionEvent.VERIFY_ERROR) );
			});
		}
		
		public static function getInstance():TwitSession {
			if (!instance) {
				instance = new TwitSession();
			}
			return instance;
		}
		
		public function get started():Boolean {
			return (twitOAuth.accessToken
					&& twitOAuth.userId
					&& twitOAuth.screenName);
		}
		
		public function get username():String {
			return twitOAuth.screenName;
		}
		
		public function get userId():String {
			return twitOAuth.userId;
		}
		
		public function start(accessToken:OAuthToken):void {
			twitOAuth.verifyAccessToken(accessToken);
		}
		
		public function restart():void {
			var token:Object = loadToken();
			if (token != null) {
				trace("TwitSession: exist token: " + token.key);
				twitOAuth.verifyAccessToken(
						new OAuthToken(token.key, token.secret));
			}
		}
		
		private function loadToken():Object {
			var so:SharedObject = SharedObject.getLocal("twitter");
			var key:String = "accessToken";
			return so.data[key];
		}
		
		private function saveToken(token:OAuthToken):void {
			trace("TwitSession.saveToken");
			var so:SharedObject = SharedObject.getLocal("twitter");
			var key:String = "accessToken";
			so.data[key] = {
				key:    token.key,
				secret: token.secret
			};
			so.flush();
		}
		
		public function createGetRequest(baseUrl:String, params:Object=null):URLRequest {
			return twitOAuth.createGetRequest(baseUrl, params);
		}
	}
}