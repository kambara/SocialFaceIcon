package socialfaceicon.model.friendfeed.threads
{
	import mx.utils.StringUtil;
	
	import org.libspark.thread.Thread;
	import org.libspark.thread.threads.net.URLLoaderThread;
	
	import socialfaceicon.model.friendfeed.FFeedSession;
	import socialfaceicon.model.friendfeed.FFeedUser;

	public class FFeedFriendsThread extends Thread
	{
		private var _users:Array;
		private var loader:URLLoaderThread;
		
		public function FFeedFriendsThread(username:String)
		{
			super();
			var url:String = StringUtil.substitute(
								"http://friendfeed-api.com/v2/feedinfo/{0}?format=xml",
								username);
			this.loader = new URLLoaderThread(FFeedSession.createRequest(url));
		}
		
		protected override function run():void {
			loader.start();
			loader.join();
			next(onLoad);
		}
		
		private function onLoad():void {
			_users = [];
			var xml:XML = new XML(loader.loader.data);
			for each (var x:XML in xml.subscription) {
				if (x.type == "user") {
					_users.push(new FFeedUser(x.id, x.name));
				}
			}
		}
		
		public function get ffeedUsers():Array {
			return _users;
		}
	}
}