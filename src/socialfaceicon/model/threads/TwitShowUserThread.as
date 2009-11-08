package socialfaceicon.model.threads
{
	import flash.errors.IOError;
	
	import mx.utils.StringUtil;
	
	import org.libspark.thread.Thread;
	import org.libspark.thread.threads.net.URLLoaderThread;
	
	import socialfaceicon.model.TwitSession;
	
	import twitter.api.data.TwitterUser;

	/**
	 * Obsolete
	 */
	public class TwitShowUserThread extends Thread
	{
		private var loader:URLLoaderThread;
		private var _twitterUser:TwitterUser;
		
		public function TwitShowUserThread(username:String)
		{
			super();
			var url:String = StringUtil.substitute(
					"http://twitter.com/users/show/{0}.xml",
					username);
			loader = new URLLoaderThread(TwitSession.createRequest(url));
		}
		
		override protected function run():void {
			loader.start();
			loader.join();
			next(onLoad);
		}
		
		private function onLoad():void {
			var xml:XML = new XML(loader.loader.data);
			_twitterUser = new TwitterUser(xml);
		}
		
		private function onIOError(err:IOError, t:Thread):void {
			trace(t.className+": "+err.message);
		}
		
		public function get twitterUser():TwitterUser {
			return _twitterUser;
		}
	}
}