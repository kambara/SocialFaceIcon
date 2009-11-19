package socialfaceicon.model.threads
{
	import org.libspark.thread.Thread;
	
	import socialfaceicon.model.DesktopIcon;
	import socialfaceicon.model.IconStatus;
	import socialfaceicon.model.Setting;

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
			if (Setting.twitterUsername) {
				var t:UpdateTwitFriendsThread =
						new UpdateTwitFriendsThread(
								Setting.twitterUsername );
				t.start();
				t.join();
				next(onLoad);
				error(Error, onError);
			} else {
				sleep(interval);
				next(run);
			}
		}
		
		private function onLoad():void {
			sleep(interval);
			next(run);
		}
		
		private function onError(err:Error, t:Thread):void {
			trace(t+": "+err.getStackTrace());
			sleep(interval);
			next(run);
		}
	}
}