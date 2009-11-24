package socialfaceicon.model.twitter
{
	import jp.cre8system.framework.airrecord.model.ARModel;

	public class TwitFriend extends ARModel
	{
		public var screenName:String;
		public var friendUserId:String;
		
		public function TwitFriend(screenName:String = null,
								   friendUserId:String = null)
		{
			super();
			this.__table = "twitter_friends";
			
			this.screenName = screenName;
			this.friendUserId = friendUserId;
		}
		
		
		
		/*
		public static function getUsers(name:String):Array {
			var users:Array = [];
			for each (var id:Number in TwitFriend.getUserIds(name)) {
				var user:TwitUser = new TwitUser();
				if (user.loadById(id)) {
					users.push(user);
				}
			}
			return users;
		}
		*/
		
		public static function getUsers(screenName:String):Array {
			var users:Array = [];
			var friendObjects:Array = (new TwitFriend()).find({ screenName: screenName });
			if (friendObjects) {
				for each (var friendObj:Object in friendObjects) {
					var user:TwitUser = new TwitUser();
					if (user.loadById(friendObj.friendUserId)) {
						users.push(user);
					}
				}
			}
			return users;
		}
		
		public static function updateAll(screenName:String, users:Array):void {
			// Delete all friends
			var twitFriend:TwitFriend = new TwitFriend();
			twitFriend.del({
				screenName: screenName
			});
			if (!users || users.length == 0) return;
			
			// Insert all friends
			try {
				twitFriend.begin();
				for each (var user:TwitUser in users) {
					(new TwitFriend(screenName, user.id)).insert();
				}
				twitFriend.commit();
			} catch (err:Error) {
				trace("TwitFriend: updateAll: " + err.message);
			}
		}
	}
}