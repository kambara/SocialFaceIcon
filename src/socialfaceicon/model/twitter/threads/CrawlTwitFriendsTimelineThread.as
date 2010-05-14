package socialfaceicon.model.twitter.threads
{
	import org.libspark.thread.Thread;
	
	import socialfaceicon.model.IconStatus;
	import socialfaceicon.model.twitter.TwitSession;
	import socialfaceicon.model.twitter.TwitStatus;

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
			trace("==== " + this.className + " ====");
			if (TwitSession.getInstance().started) {
				friendsTimeline = new TwitFriendsTimelineThread(200);
				friendsTimeline.start();
				friendsTimeline.join();
				next(onLoad);
				error(Error, onError);
			} else {
				trace(this.className + ": Session closed");
				next(restart);
			}
		}
		
		private function onLoad():void {
			trace(this.className + ": Saving");
			(new TwitStatus()).insertAll( friendsTimeline.statuses );
			IconStatus.update();
			next(restart);
		}
		
		private function onError(err:Error, t:Thread):void {
			trace(this.className + ": " + err.message);
			next(restart);
		}
		
		private function restart():void {
			trace(this.className + ": Restart");
			sleep(interval);
			next(run);
		}
	}
}