package socialfaceicon.model.twitter.threads
{
	import mx.utils.StringUtil;
	
	import org.libspark.thread.Thread;
	import org.libspark.thread.threads.net.URLLoaderThread;
	
	import socialfaceicon.model.twitter.TwitSession;
	import socialfaceicon.model.twitter.TwitStatus;

	/**
	 * Twitter API: statuses/friends_timeline
	 * http://apiwiki.twitter.com/Twitter-REST-API-Method:-statuses-friends_timeline
	 */
	public class TwitFriendsTimelineThread extends Thread
	{
		private var loader:URLLoaderThread;
		private var _statuses:Array;
		
		public function TwitFriendsTimelineThread(count:uint = 20)
		{
			super();
			var url:String = StringUtil.substitute(
					"http://twitter.com/statuses/friends_timeline.xml?count={0}",
					count.toString());
			loader = new URLLoaderThread(TwitSession.createRequest(url));
		}
		
		override protected function run():void {
			loader.start();
			loader.join();
			next(onLoad);
		}
		
		private function onLoad():void {
			trace(this.className + ": Saving");
			_statuses = [];
			var xml:XML = new XML(loader.loader.data);
			for each (var x:XML in xml.children()) {
				_statuses.push(
					TwitStatus.newFromStatusXml(x, x.user[0].id) );
			}
		}
		
		public function get statuses():Array {
			return _statuses || [];
		}
	}
}