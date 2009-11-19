package socialfaceicon.model.facebook.threads
{
	import flash.events.Event;
	
	import org.libspark.thread.Thread;
	import org.libspark.thread.utils.EventDispatcherThread;
	
	import socialfaceicon.model.IconStatus;
	import socialfaceicon.model.facebook.FBookFriend;
	import socialfaceicon.model.facebook.FBookStatus;
	import socialfaceicon.model.facebook.FBookUser;

	public class UpdateFBookFriendsThread extends EventDispatcherThread
	{
		public static const FINISH:String = "finish";
		private var fbookFriends:FBookFriendsThread;
		
		public function UpdateFBookFriendsThread()
		{
			super();
		}
		
		protected override function run():void {
			fbookFriends = new FBookFriendsThread();
			fbookFriends.start();
			fbookFriends.join(30 * 1000);
			next(onFBookFriendsLoad);
			error(Error, onFBookFriendsError);
		}
		
		private function onFBookFriendsLoad():void {
			if (!fbookFriends.uid) {
				trace("UpdateFBookFriends: No session");
				// TODO: login ???
				return;
			}
			trace("UpdateFBookFriends: Saving");
			(new FBookUser()).saveAll(fbookFriends.fbookUsers);
			FBookFriend.updateAll(
							fbookFriends.uid,
							fbookFriends.fbookUsers);
			(new FBookStatus()).saveAll(fbookFriends.fbookStatuses);
			
			// update view status
			IconStatus.update();
		}
		
		private function onFBookFriendsError(err:Error, t:Thread):void {
			trace(t + " onFbookFriendsError: " + err.getStackTrace());
			next(null);
		}
		
		protected override function finalize():void {
			trace("UpdateFBookFriends: Finish");
			dispatchEvent(new Event(UpdateFBookFriendsThread.FINISH));
		}
	}
}