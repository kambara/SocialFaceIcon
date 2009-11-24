package socialfaceicon.model.friendfeed.threads
{
	import org.libspark.thread.threads.net.URLLoaderThread;
	
	import socialfaceicon.model.friendfeed.FFeedSession;

	public class FFeedHomeEntriesThread extends FFeedAbstractEntriesThread
	{
		public function FFeedHomeEntriesThread()
		{
			super();
			var url:String = "http://friendfeed-api.com/v2/feed/home?format=xml&raw=1&num=100";
			this.loader = new URLLoaderThread(
								FFeedSession.createRequest(url));
		}
	}
}