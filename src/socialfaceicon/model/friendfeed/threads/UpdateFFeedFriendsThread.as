package socialfaceicon.model.friendfeed.threads
{
	import org.libspark.thread.Thread;
	import org.libspark.thread.utils.EventDispatcherThread;
	
	import socialfaceicon.model.IconStatus;
	import socialfaceicon.model.friendfeed.FFeedEntry;
	import socialfaceicon.model.friendfeed.FFeedFriend;
	import socialfaceicon.model.friendfeed.FFeedUser;

	public class UpdateFFeedFriendsThread extends EventDispatcherThread
	{
		public static const FINISH:String = "finish";
		private var username:String;
		private var ffeedFriends:FFeedFriendsThread;
		
		public function UpdateFFeedFriendsThread(username:String)
		{
			super();
			this.username = username;
		}
		
		protected override function run():void {
			ffeedFriends = new FFeedFriendsThread(this.username)
			ffeedFriends.start();
			ffeedFriends.join();
			next(onFFeedFriendsLoad);
			error(Error, onFFeedFriendsError);
		}
		
		private function onFFeedFriendsLoad():void {
			trace("UpdateFFeedFriends: Saving");
			(new FFeedUser()).saveAll(ffeedFriends.ffeedUsers);
			FFeedFriend.updateAll(
							this.username,
							ffeedFriends.ffeedUsers);
			//(new FFeedEntry()).saveAll(.fbookStatuses);
			// TODO: entry
			
			// update view status
			IconStatus.update();
		}
		
		private function onFFeedFriendsError(err:Error, t:Thread):void {
			trace(t + " onFFeedFriendsError: " + err.getStackTrace());
			next(null);
		}
	}
}