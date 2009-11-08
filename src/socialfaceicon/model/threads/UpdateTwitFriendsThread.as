package socialfaceicon.model.threads
{
	import flash.events.Event;
	
	import org.libspark.thread.Thread;
	import org.libspark.thread.utils.EventDispatcherThread;
	
	import socialfaceicon.model.DesktopIcon;
	import socialfaceicon.model.IconStatus;
	import socialfaceicon.model.TwitFriend;
	import socialfaceicon.model.TwitStatus;
	import socialfaceicon.model.TwitUser;

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
			error(Error, onFriendsStatusError);
		}
		
		//
		// FriendStatus
		//
		private function loadFriendsStatus():void {
			trace("UpdateTwitFriends: Loading page " + this.page);
			twitFriends = new TwitFriendsThread(username, page);
			twitFriends.start();
			twitFriends.join();
			next(onFriendsStatusLoad);
			error(Error, onFriendsStatusError);
		}
		
		private function onFriendsStatusLoad():void {
			if (twitFriends.users.length == 0) {
				trace("UpdateTwitFriends: Saving");
				saveAllFriends();
				IconStatus.update();
				return;
			}
			allUsers = allUsers.concat(twitFriends.users);
			allStatuses = allStatuses.concat(twitFriends.statuses);
			page++;
			sleep(10 * 1000);
			next(loadFriendsStatus);
		}
		
		//
		// Save friends
		//
		private function saveAllFriends():void {
			// delete all friends
			(new TwitFriend()).del({
								screenName: username
								});
			for each (var user:TwitUser in allUsers) {
				saveUserAndFriend(user);
			}
			for each (var status:TwitStatus in allStatuses) {
				saveStatus(status);
			}
		}
		
		private function saveUserAndFriend(user:TwitUser):void {
			// save user
			// TODO: I/O is too heavy...
			try {
				user.save();
			} catch (err:Error) {
				trace([
					this.className,
					"save user",
					err.message
				].join(": "));
				return;
			}
			
			// save friend
			try {
				(new TwitFriend(username, user.id)).insert();
			} catch (err:Error) {}
		}
		
		private function saveStatus(status:TwitStatus):void {
			try {
				status.insert();
			} catch (err:Error) {}
		}
		
		private function onFriendsStatusError(err:Error, t:Thread):void {
			trace(t + " onFriendsStatusError: " + err.message);
			chance--;
			if (chance <= 0) {
				next(null);
			} else {
				sleep(10 * 1000);
				next(loadFriendsStatus);
			}
		}
		
		protected override function finalize():void {
			trace("UpdateTwitFriends: Finish:"
					+ " user: "
					+ allUsers.length
					+ ", status: "
					+ allStatuses.length);
			dispatchEvent(new Event(UpdateTwitFriendsThread.FINISH));
		}
	}
}