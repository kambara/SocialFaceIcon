package socialfaceicon.model.facebook
{
	import com.facebook.utils.DesktopSessionHelper;
	
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