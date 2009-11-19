package socialfaceicon.model.facebook.threads
{
	import org.libspark.thread.Thread;
	
	import socialfaceicon.model.IconStatus;

	public class CrawlFBookFriendsThread extends Thread
	{
		private var fbookFriends:UpdateFBookFriendsThread;
		private var interval:int;
		
		public function CrawlFBookFriendsThread()
		{
			super();
			interval = 1 * 60 * 1000;
		}
		
		protected override function run():void {
			trace("==== CrawlFBookFriends ====");
			fbookFriends =
				new UpdateFBookFriendsThread();
			fbookFriends.start();
			fbookFriends.join();
			next(onFBookFriendsLoad);
			error(Error, onFBookFriendsError);
		}
		
		private function onFBookFriendsLoad():void {
			trace("CrawlFBookFriends: Load");
		}
		
		private function onFBookFriendsError(err:Error, t:Thread):void {
			trace(t+": "+err.getStackTrace());
		}
		
		protected override function finalize():void {
			trace("CrawlFBookFriends: Finish");
			sleep(interval);
			next(run);
		}
	}
}