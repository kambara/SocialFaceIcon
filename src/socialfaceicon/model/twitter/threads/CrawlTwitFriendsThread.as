package socialfaceicon.model.twitter.threads
{
	import org.libspark.thread.Thread;
	
	import socialfaceicon.model.Setting;
	import socialfaceicon.model.twitter.TwitSession;

	public class CrawlTwitFriendsThread extends Thread
	{
		private var interval:int;
		
		public function CrawlTwitFriendsThread()
		{
			super();
			interval = 30 * 60 * 1000;
		}
		
		protected override function run():void {
			trace("==== CrawlTwitFriends ====");
			if (TwitSession.username) {
				var t:UpdateTwitFriendsThread =
						new UpdateTwitFriendsThread(
								Setting.twitterUsername );
				t.start();
				t.join();
				next(onLoad);
				error(Error, onError);
			} else {
				trace("CrawlTwitFriends: No username");
				next(restart);
			}
		}
		
		private function onLoad():void {
			next(restart);
		}
		
		private function onError(err:Error, t:Thread):void {
			trace(t+": "+err.getStackTrace());
			next(restart);
		}
		
		private function restart():void {
			sleep(interval);
			next(run);
		}
	}
}