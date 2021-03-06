package socialfaceicon.model.facebook.threads
{
	import com.facebook.events.FacebookEvent;
	
	import flash.errors.IOError;
	import flash.net.URLRequest;
	
	import org.libspark.thread.Thread;
	import org.libspark.thread.threads.net.URLLoaderThread;
	
	import socialfaceicon.model.facebook.FBookFriend;
	import socialfaceicon.model.facebook.FBookSession;

	public class CrawlFBookFriendsThread extends Thread
	{
		private var fbookFriends:UpdateFBookFriendsThread;
		private var interval:int;
		private var session:FBookSession;
		private var isConnected:Boolean = false;
		
		public function CrawlFBookFriendsThread()
		{
			super();
			interval = 3 * 60 * 1000;
		}
		
		protected override function run():void {
			trace("==== " + this.className + " ====");
			isConnected = false;
			
			var friends:Array = (new FBookFriend()).find();
			if (friends && friends.length > 0) {
				session = new FBookSession();
				event(session, FacebookEvent.CONNECT, onConnect);
				session.verifySession();
				sleep(20 * 1000);
				next(checkTimeout);
			} else {
				// No account
				trace(this.className + ": Never logged in");
				next(restart);
			}
		}
		
		private function checkTimeout():void {
			if (!isConnected) {
				trace(this.className + ": Timeout");
				var loader:URLLoaderThread =
						new URLLoaderThread(
								new URLRequest("http://www.facebook.com/"));
				loader.start();
				loader.join();
				next(onOnline);
				error(Error, onOffline);
			}
		}
		
		private function onOnline():void {
			trace(this.className + ": Online");
			event(session, FacebookEvent.CONNECT, onConnect);
			event(session, FacebookEvent.LOGIN_FAILURE, onLoginFailure);
			session.login();
		}
		
		private function onOffline(err:IOError, t:Thread):void {
			trace(this.className + ": Offline");
			next(restart);
		}
		
		private function onLoginFailure(evt:FacebookEvent):void {
			trace(this.className + ": Login failure");
			next(restart);
		}
		
		private function onConnect(evt:FacebookEvent):void {
			if (evt.success) {
				isConnected = true;
				fbookFriends =
					new UpdateFBookFriendsThread(session);
				fbookFriends.start();
				fbookFriends.join();
				next(onFBookFriendsLoad);
				error(Error, onFBookFriendsError);
			} else {
				trace(this.className + ": Connect failure");
			}
		}
		
		private function onFBookFriendsLoad():void {
			next(restart);
		}
		
		private function onFBookFriendsError(err:Error, t:Thread):void {
			next(restart);
		}
		
		private function restart():void {
			trace(this.className + ": restart");
			sleep(interval);
			next(run);
		}
		
		protected override function finalize():void {
			trace(this.className + ": Finish");
			next(restart);
		}
	}
}