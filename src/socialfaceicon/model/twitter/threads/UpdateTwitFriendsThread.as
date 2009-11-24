package socialfaceicon.model.twitter.threads
{
	import flash.events.Event;
	
	import org.libspark.thread.Thread;
	import org.libspark.thread.utils.EventDispatcherThread;
	
	import socialfaceicon.model.IconStatus;
	import socialfaceicon.model.twitter.TwitFriend;
	import socialfaceicon.model.twitter.TwitStatus;
	import socialfaceicon.model.twitter.TwitUser;

	public class UpdateTwitFriendsThread extends EventDispatcherThread
	{
		public static const FINISH:String = "finish";
		
		private var username:String;
		private var twitFriends:TwitFriendsThread;
		private var page:uint = 1;
		private var chance:int = 3;
		private var allUsers:Array;
		private var allStatuses:Array;
		
		public function UpdateTwitFriendsThread(username:String)
		{
			super();
			this.username = username;
		}
		
		//
		// ShowUser
		//
		protected override function run():void {
			allUsers = [];
			allStatuses = [];
			page = 1;
			next(loadFriendsStatus);
		}
		
		//
		// FriendStatus
		//
		private function loadFriendsStatus():void {
			trace(this.className + ": Loading: page " + this.page);
			twitFriends = new TwitFriendsThread(username, page);
			twitFriends.start();
			twitFriends.join();
			next(onLoad);
			error(Error, onError);
		}
		
		private function onLoad():void {
			if (twitFriends.users.length == 0) {
				saveAllFriends();
				IconStatus.update();
			} else {
				allUsers = allUsers.concat(twitFriends.users);
				allStatuses = allStatuses.concat(twitFriends.statuses);
				page++;
				sleep(10 * 1000);
				next(loadFriendsStatus);
			}
		}
		
		//
		// Save friends
		//
		private function saveAllFriends():void {
			trace(this.className + ": Saving");
			(new TwitUser()).saveAll( allUsers );
			TwitFriend.updateAll(username, allUsers);
			(new TwitStatus()).insertAll( allStatuses );
		}
		
		private function onError(err:Error, t:Thread):void {
			trace(this.className + ": " + err.message);
			chance--;
			if (chance <= 0) {
				next(null);
			} else {
				sleep(10 * 1000);
				next(loadFriendsStatus);
			}
		}
		
		protected override function finalize():void {
			trace(this.className
					+ ": Finish: user: "
					+ allUsers.length
					+ ", status: "
					+ allStatuses.length);
			dispatchEvent(new Event(UpdateTwitFriendsThread.FINISH));
		}
	}
}