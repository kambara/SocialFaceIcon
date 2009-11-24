package socialfaceicon.model.friendfeed.threads
{
	import org.libspark.thread.Thread;
	import org.libspark.thread.threads.net.URLLoaderThread;
	
	import socialfaceicon.model.friendfeed.FFeedEntry;
	import socialfaceicon.utils.DateUtil;

	public class FFeedAbstractEntriesThread extends Thread
	{
		protected var _entries:Array;
		protected var loader:URLLoaderThread;
		
		public function FFeedAbstractEntriesThread()
		{
			super();
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
					new FFeedEntry(x.id,
								   x.from.id,
								   x.rawBody,
								   x.url,
								   DateUtil.strToDate(x.date).getTime()));
			}
		}
		
		public function get ffeedEntries():Array {
			return _entries || [];
		}
	}
}