package socialfaceicon.model.twitter.threads
{
	import mx.utils.StringUtil;
	
	import org.libspark.thread.Thread;
	import org.libspark.thread.threads.net.URLLoaderThread;
	
	import socialfaceicon.model.twitter.TwitSession;
	import socialfaceicon.model.twitter.TwitStatus;
	import socialfaceicon.model.twitter.TwitUser;

	/**
	 * Twitter API: statuses/friends
	 * http://apiwiki.twitter.com/Twitter-REST-API-Method:-statuses friends
	 */
	public class TwitFriendsThread extends Thread
	{
		private var loader:URLLoaderThread;
		private var _users:Array;
		private var _statuses:Array;
		private var _nextCursor:String;
		
		public function TwitFriendsThread(username:String, cursor:String)
		{
			super();
			var url:String = StringUtil.substitute(
					"http://twitter.com/statuses/friends/{0}.xml?cursor={1}",
					username,
					cursor.toString());
			this.loader = new URLLoaderThread(TwitSession.createRequest(url));
		}
		
		override protected function run():void {
			loader.start();
			loader.join();
			next(onLoad);
		}
		
		private function onLoad():void {
			_users = [];
			_statuses = [];
			//trace(loader.loader.data);
			var xml:XML = new XML(loader.loader.data);
			for each (var x:XML in xml..user) {
				setUserAndStatus(x);
			}
			if (xml.next_cursor) {
				this._nextCursor = xml.next_cursor;
				trace("nextCursor:" + _nextCursor);
			}
		}
		
		private function setUserAndStatus(xml:XML):void {
			var user:TwitUser = TwitUser.newFromUserXml(xml)
			_users.push( user );
			
			if (xml.status
				&& xml.status[0]
				&& xml.status[0].text)
			{
				_statuses.push(
						TwitStatus.newFromStatusXml(
								xml.status[0],
								user.id));
			}
		}
		
		public function get users():Array {
			return _users || [];
		}
		
		public function get statuses():Array {
			return _statuses || [];
		}
		
		public function get nextCursor():String {
			return this._nextCursor || null;
		}
	}
}