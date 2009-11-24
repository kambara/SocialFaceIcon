package socialfaceicon.model.friendfeed.threads
{
	import org.libspark.thread.Thread;
	
	import socialfaceicon.model.friendfeed.FFeedSession;

	public class CrawlFFeedHomeEntriesThread extends Thread
	{
		private var interval:int;
		
		public function CrawlFFeedHomeEntriesThread()
		{
			super();
			interval = 2 * 60 * 1000;
		}
		
		protected override function run():void {
			trace("==== " + this.className + " ====");
			if (FFeedSession.username) {
				var t:UpdateFFeedHomeEntriesThread =
						new UpdateFFeedHomeEntriesThread();
				t.start();
				t.join();
				next(restart);
				error(Error, onError);
			} else {
				trace(this.className + ": No username");
				next(restart);
			}
		}
		
		private function onError(err:Error, t:Thread):void {
			trace(this.className + ": " + err.getStackTrace());
			next(restart);
		}
		
		private function restart():void {
			sleep(interval);
			next(run);
		}
	}
}