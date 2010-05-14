package socialfaceicon.model.twitter
{
	import com.adobe.serialization.json.JSONDecoder;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import org.iotashan.oauth.OAuthConsumer;
	import org.iotashan.oauth.OAuthRequest;
	import org.iotashan.oauth.OAuthSignatureMethod_HMAC_SHA1;
	import org.iotashan.oauth.OAuthToken;
	import org.iotashan.utils.OAuthUtil;
	
	public class TwitOAuth extends EventDispatcher
	{
		public static const REQUEST_TOKEN_URL:String  = "http://twitter.com/oauth/request_token";
		public static const ACCESS_TOKEN_URL:String   = "http://twitter.com/oauth/access_token";
		public static const AUTHORIZE_URL:String      = "http://twitter.com/oauth/authorize";
		public static const VERIFY_CREDENTIALS:String = "https://twitter.com/account/verify_credentials.json";

		private var signature:OAuthSignatureMethod_HMAC_SHA1 = new OAuthSignatureMethod_HMAC_SHA1();
		private var consumer:OAuthConsumer;
		private var unauthRequestToken:OAuthToken;
		
		private var _accessToken:OAuthToken;
		private var _userId:String;
		private var _screenName:String;
		
		public function TwitOAuth(key:String, secret:String)
		{
			consumer = new OAuthConsumer(key, secret);
		}

		public function authenticate():void {
			// load unauth request token
			var oauthRequest:OAuthRequest = new OAuthRequest("GET", REQUEST_TOKEN_URL, null, consumer, null);
			var request:URLRequest = new URLRequest( oauthRequest.buildRequest(signature) );
			var loader:URLLoader = new URLLoader(request);
			loader.addEventListener(Event.COMPLETE, onRequestTokenLoad);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onRequestTokenError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onRequestTokenError);
		}
		
		public function get userId():String {
			return _userId;
		}
		
		public function get screenName():String {
			return _screenName;
		}
		
		public function get accessToken():OAuthToken {
			return _accessToken;
		}
		
		private function onRequestTokenLoad(event:Event):void {
			unauthRequestToken =
					OAuthUtil.getTokenFromResponse(
						event.currentTarget.data as String);
			var request:URLRequest =
					new URLRequest(
							AUTHORIZE_URL
							+ "?oauth_token="
							+ unauthRequestToken.key);
			navigateToURL(request, "_blank");
			
			dispatchEvent(new TwitOAuthEvent(
					TwitOAuthEvent.REQUEST_TOKEN,
					unauthRequestToken));
		}
		
		private function onRequestTokenError(event:ErrorEvent):void {
			trace("request token error: " + event.text);
			dispatchEvent(new TwitOAuthEvent(
					TwitOAuthEvent.CONSUMER_ERROR,
					null));
		}
		
		public function loadAccessToken(pin:uint):void {
			if (!unauthRequestToken) {
				trace("no request token");
				dispatchEvent(new TwitOAuthEvent(
					TwitOAuthEvent.PIN_ERROR,
					null));
				return;
			}
			var oauthRequest:OAuthRequest =
					new OAuthRequest(
							"GET",
							ACCESS_TOKEN_URL,
							{ oauth_verifier: pin },
							consumer,
							unauthRequestToken);
			 var request:URLRequest = new URLRequest(
			 			oauthRequest.buildRequest(signature));
			 var loader:URLLoader = new URLLoader(request);
			 loader.addEventListener(Event.COMPLETE, onAccessTokenLoad);
			 loader.addEventListener(IOErrorEvent.IO_ERROR, onAccessTokenError);
			 loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onAccessTokenError);
		}
		
		private function onAccessTokenLoad(event:Event):void {
			var response:String = event.currentTarget.data as String;
			_accessToken = OAuthUtil.getTokenFromResponse(response);
			
			var obj:Object = getObjectFromResponse(response);
			_userId = obj["user_id"];
			_screenName = obj["screen_name"];
			
			dispatchEvent(new TwitOAuthEvent(
					TwitOAuthEvent.ACCESS_TOKEN,
					_accessToken));
		}
		
		private function onAccessTokenError(event:ErrorEvent):void {
			trace("access token error: " + event.text);
			dispatchEvent(new TwitOAuthEvent(
					TwitOAuthEvent.PIN_ERROR,
					null));
		}
		
		private function getObjectFromResponse(tokenResponse:String):Object {
			var result:Object = {};
			var params:Array = tokenResponse.split("&");
			for each ( var param: String in params ) {
				var pair:Array = param.split("=");
				if ( pair.length == 2 ) {
					result[pair[0]] = pair[1];
				}
			}
			return result;
		}
		
		public function verifyAccessToken(token:OAuthToken):void {
			trace("TwitOAuth.verifyAccessToken");
			var oauthRequest:OAuthRequest = new OAuthRequest(
					"GET",
					VERIFY_CREDENTIALS,
					null, consumer, token);
			var request:URLRequest = new URLRequest( oauthRequest.buildRequest(signature) );
			var loader:URLLoader = new URLLoader(request);
			loader.addEventListener(Event.COMPLETE, function(event:Event):void {
				onVerifyAccessTokenLoad(
						event.currentTarget.data as String,
						token);
			});
			loader.addEventListener(IOErrorEvent.IO_ERROR, onVerifyAccessTokenError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onVerifyAccessTokenError);
		}
		
		private function onVerifyAccessTokenLoad(jsonStr:String, token:OAuthToken):void {
			var decoder:JSONDecoder = new JSONDecoder(jsonStr);
			var value:Object = decoder.getValue();
			_userId = value["id"];
			_screenName = value["screen_name"];
			_accessToken = token;
			trace("TwitOAuth.onVerifyAccessToken: "
					+ _screenName
					+ ": "
					+ token.key);
			dispatchEvent( new TwitOAuthEvent(TwitOAuthEvent.VERIFY_TOKEN, token) );
		}
		
		private function onVerifyAccessTokenError(event:ErrorEvent):void {
			trace("verify error: " + event.text);
			dispatchEvent( new TwitOAuthEvent(TwitOAuthEvent.VERIFY_ERROR, null) );
		}
		
		public function createGetRequest(baseUrl:String, params:Object=null):URLRequest {
			var oauthRequest:OAuthRequest = new OAuthRequest("GET", baseUrl, params, consumer, _accessToken);
			var reqUrl:String = oauthRequest.buildRequest(
									new OAuthSignatureMethod_HMAC_SHA1(),
									OAuthRequest.RESULT_TYPE_URL_STRING);
			return new URLRequest(reqUrl);
		}
	}
}