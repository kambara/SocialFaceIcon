package socialfaceicon.model.twitter
{
	import flash.events.Event;
	
	import org.iotashan.oauth.OAuthToken;

	public class TwitOAuthEvent extends Event
	{
		public static const REQUEST_TOKEN:String  = "REQUEST_TOKEN";
		public static const CONSUMER_ERROR:String = "CONSUMER_ERROR";
		public static const ACCESS_TOKEN:String = "ACCESS_TOKEN";
		public static const PIN_ERROR:String    = "PIN_ERROR";
		public static const VERIFY_TOKEN:String = "VERIFY_TOKEN";
		public static const VERIFY_ERROR:String = "VERIFY_ERROR";
		
		private var _token:OAuthToken;
		
		public function TwitOAuthEvent(type:String, token:OAuthToken, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_token = token;
		}
		
		public function get token():OAuthToken {
			return _token;
		}
	}
}