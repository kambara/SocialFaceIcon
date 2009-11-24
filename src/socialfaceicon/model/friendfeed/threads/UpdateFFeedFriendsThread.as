package socialfaceicon.model.friendfeed.threads
{
	import flash.events.Event;
	
	import org.libspark.thread.Thread;
	import org.libspark.thread.utils.EventDispatcherThread;
	
	import socialfaceicon.model.IconStatus;
	import socialfaceicon.model.friendfeed.FFeedFriend;
	import socialfaceicon.model.friendfeed.FFeedUser;

	public class UpdateFFeedFriendsThread extends EventDispatcherThread
	{
		public static const FINISH:String = "finish";
		private var idName:String;
		private var ffeedFriends:FFeedFriendsThread;
		
		public function UpdateFFeedFriendsThread(idName:String)
		{
			super();
			this.idName = idName;
		}
		
		protected override function run():void {
			ffeedFriends = new FFeedFriendsThread(this.idName);
			ffeedFriends.start();
			ffeedFriends.join();
			next(onFFeedFriendsLoad);
			error(Error, onFFeedFriendsError);
		}
		
		private function onFFeedFriendsLoad():void {
			trace("UpdateFFeedFriends: Saving");
			(new FFeedUser()).saveAll(ffeedFriends.ffeedUsers, "idName");
			FFeedFriend.updateAll(
							idName,
							ffeedFriends.ffeedUsers);
			// TODO: load all friends' entry, then save entry.
			//(new FFeedEntry()).saveAll(.fbookStatuses);
			
			// update view status
			IconStatus.update();
		}
		
		private function onFFeedFriendsError(err:Error, t:Thread):void {
			trace(t + " onFFeedFriendsError: " + err.getStackTrace());
			next(null);
		}
		
		protected override function finalize():void {
			trace("UpdateFFeedFriends: Finish");
			dispatchEvent(new Event(UpdateFFeedFriendsThread.FINISH));
		}
	}
}