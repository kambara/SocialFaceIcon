package socialfaceicon.model.twitter.threads
{
	import org.libspark.thread.Thread;
	
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
			trace("==== " + this.className + " ====");
			if (TwitSession.getInstance().started) {
				var t:UpdateTwitFriendsThread =
						new UpdateTwitFriendsThread(
								TwitSession.getInstance().username );
				t.start();
				t.join();
				next(restart);
				error(Error, onError);
			} else {
				trace(this.className + ": Session closed");
				next(restart);
			}
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