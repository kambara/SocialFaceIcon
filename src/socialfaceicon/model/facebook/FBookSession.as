package socialfaceicon.model.facebook
{
	import com.facebook.Facebook;
	import com.facebook.commands.users.GetLoggedInUser;
	import com.facebook.events.FacebookEvent;
	import com.facebook.net.FacebookCall;
	import com.facebook.session.DesktopSession;
	import com.facebook.utils.DesktopSessionHelper;
	
	import flash.net.SharedObject;
	import flash.utils.setTimeout;
	
	import socialfaceicon.config.Config;

	public class FBookSession extends DesktopSessionHelper
	{
		private static var _currentSession:FBookSession;
		
		public function FBookSession()
		{
			//super(api_key, parent);
			super("", null);
			this.apiKey = Config.FACEBOOK_API_KEY;
		}
		
		/*
		public function hasSessionKey():Boolean {
			var sessionSO:SharedObject = SharedObject.getLocal(apiKey);
			return !!sessionSO.data.session_key;
		}
		
		
		public override function login(api_key:String=''):void {
			if (api_key != '') { apiKey = api_key; }
			if (apiKey == '') { throw new Error('Cannot login. No api_key specified.'); }
			//check for existing LSO with sessionData       
			sessionSO = SharedObject.getLocal(apiKey);
			if (sessionSO.data.session_key != null) {
				trace("!!! populate");
				populateSessionData(sessionSO.data);
				facebook = new Facebook();
				facebook.startSession(new DesktopSession(apiKey, sessionData.secret, sessionData.session_key));
				//check that the current session is still active
				var call:FacebookCall = facebook.post(new GetLoggedInUser());
				call.addEventListener(FacebookEvent.COMPLETE, onValidateLoginSession, false, 0, true);
			} else {
				trace("!!! showlogin");
				showLogin();
			}
		}
		
		public override function verifySession():void {
			//check for existing LSO with sessionData       
			sessionSO = SharedObject.getLocal(apiKey);
			if (sessionSO.data.session_key != null) {
				trace("!!! verify populate");
				populateSessionData(sessionSO.data);
				facebook = new Facebook();
				facebook.startSession(new DesktopSession(apiKey, sessionData.secret, sessionData.session_key));
				//check that the current session is still active
				var call:FacebookCall = facebook.post(new GetLoggedInUser());
				call.addEventListener(FacebookEvent.COMPLETE, onValidateLoginSession, false, 0, true);
			} else {
				trace("!!! verifying");
				//setTimeout(function():void {
					dispatchEvent(new FacebookEvent(FacebookEvent.VERIFYING_SESSION));
				//}, 500);
			}
		}
		*/
		
		/*
		public function get uid():Number {
			if (this.sessionData) {
				var i:Number = parseInt(this.sessionData.uid);
				if (!isNaN(i)) {
					return i;
				}
			}
			return NaN;
		}
		*/
	}
}