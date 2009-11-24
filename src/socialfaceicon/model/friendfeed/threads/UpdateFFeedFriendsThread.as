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
		private var userId:String;
		private var ffeedFriends:FFeedFriendsThread;
		
		public function UpdateFFeedFriendsThread(userId:String)
		{
			super();
			this.userId = userId;
		}
		
		protected override function run():void {
			ffeedFriends = new FFeedFriendsThread(this.userId);
			ffeedFriends.start();
			ffeedFriends.join();
			next(onLoad);
			error(Error, onError);
		}
		
		private function onLoad():void {
			trace(this.className + ": Saving");
			(new FFeedUser()).saveAll( ffeedFriends.ffeedUsers );
			FFeedFriend.updateAll(
							this.userId,
							ffeedFriends.ffeedUsers);
			// TODO: load all friends' entry, then save entry.
			
			// update view status
			IconStatus.update();
		}
		
		private function onError(err:Error, t:Thread):void {
			trace([
				t,
				this.className,
				"onError",
				err.getStackTrace()
				].join(": "));
			next(null);
		}
		
		protected override function finalize():void {
			trace(this.className + ": Finish");
			dispatchEvent(new Event(UpdateFFeedFriendsThread.FINISH));
		}
	}
}