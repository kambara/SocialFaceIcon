package socialfaceicon.model.friendfeed.threads
{
	import mx.utils.StringUtil;
	
	import org.libspark.thread.threads.net.URLLoaderThread;
	
	import socialfaceicon.model.friendfeed.FFeedEntry;
	import socialfaceicon.model.friendfeed.FFeedSession;
	import socialfaceicon.utils.DateUtil;

	public class FFeedUserEntriesThread extends FFeedAbstractEntriesThread
	{
		public function FFeedUserEntriesThread(userId:String)
		{
			super();
			var url:String = StringUtil.substitute(
								"http://friendfeed-api.com/v2/feed/{0}?format=xml&raw=1",
								userId);
			this.loader = new URLLoaderThread(FFeedSession.createRequest(url));
		}
	}
}