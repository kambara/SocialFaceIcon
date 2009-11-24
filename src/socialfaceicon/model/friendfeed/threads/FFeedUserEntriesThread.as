package socialfaceicon.model.friendfeed.threads
{
	import mx.utils.StringUtil;
	
	import org.libspark.thread.Thread;
	import org.libspark.thread.threads.net.URLLoaderThread;
	
	import socialfaceicon.model.friendfeed.FFeedEntry;
	import socialfaceicon.model.friendfeed.FFeedSession;
	import socialfaceicon.utils.DateUtil;

	public class FFeedUserEntriesThread extends Thread
	{
		private var _entries:Array;
		private var loader:URLLoaderThread;
		
		public function FFeedUserEntriesThread(userId:String)
		{
			super();
			var url:String = StringUtil.substitute(
								"http://friendfeed-api.com/v2/feed/{0}?format=xml&raw=1",
								userId);
			this.loader = new URLLoaderThread(FFeedSession.createRequest(url));
		}
		
		protected override function run():void {
			loader.start();
			loader.join();
			next(onLoad);
		}
		
		private function onLoad():void {
			_entries = [];
			var xml:XML = new XML(loader.loader.data);
			for each (var x:XML in xml.entry) {
				_entries.push(
					new FFeedEntry(
							x.id,
							x.from.id,
							x.rawBody,
							x.url,
							DateUtil.strToDate(x.date).getTime()));
			}
		}
		
		public function get ffeedEntries():Array {
			return _entries;
		}
	}
}