package socialfaceicon.model.threads
{
	import org.libspark.thread.Thread;
	
	import socialfaceicon.model.IconStatus;

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
			friendsTimeline = new TwitFriendsTimelineThread(200);
			friendsTimeline.start();
			friendsTimeline.join();
			next(onLoad);
			error(Error, onFriendsTimelineError);
		}
		
		private function onLoad():void {
			trace("CrawlTwitFriendsTimeline: Finish");
			IconStatus.update();
			sleep(interval);
			next(run);
		}
		
		private function onFriendsTimelineError(err:Error, t:Thread):void {
			trace(t+": "+err.message);
			sleep(interval);
			next(run);
		}
	}
}