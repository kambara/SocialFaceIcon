package socialfaceicon.model.twitter.threads
{
	import org.libspark.thread.Thread;
	
	import socialfaceicon.model.IconStatus;
	import socialfaceicon.model.twitter.TwitSession;

	public class CrawlTwitFriendsTimelineThread extends Thread
	{
		private var interval:int;
		private var friendsTimeline:TwitFriendsTimelineThread;
		
		public function CrawlTwitFriendsTimelineThread()
		{
			super();
			interval = 2 * 60 * 1000;
		}
		
		protected override function run():void {
			trace("==== CrawlTwitFriendsTimeline ====");
			if (TwitSession.username) {
				friendsTimeline = new TwitFriendsTimelineThread(200);
				friendsTimeline.start();
				friendsTimeline.join();
				next(onLoad);
				error(Error, onFriendsTimelineError);
			} else {
				next(restart);
			}
		}
		
		private function onLoad():void {
			trace("CrawlTwitFriendsTimeline: Finish");
			IconStatus.update();
			next(restart);
		}
		
		private function onFriendsTimelineError(err:Error, t:Thread):void {
			trace(t+": "+err.message);
			next(restart);
		}
		
		private function restart():void {
			sleep(interval);
			next(run);
		}
	}
}