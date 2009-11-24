package socialfaceicon.model.friendfeed
{
	import jp.cre8system.framework.airrecord.model.ARModel;

	public class FFeedFriend extends ARModel
	{
		public var userId:String;
		public var friendUserId:String;
		
		public function FFeedFriend(userId:String = null,
									friendUserId:String = null)
		{
			super();
			this.__table = "friendfeed_friends";
			this.userId = userId;
			this.friendUserId = friendUserId;
		}
		
		public static function getUsers(userId:String):Array {
			var users:Array = [];
			var friendObjects:Array = (new FFeedFriend()).find({ userId: userId });

			if (friendObjects) {
				for each (var friendObj:Object in friendObjects) {
					var user:FFeedUser = new FFeedUser();
					if (user.loadById(friendObj.friendUserId)) {
						users.push(user);
					}
				}
			}
			return users;
		}
		
		public static function updateAll(userId:String, friendUsers:Array):void {
			// Delete all friends
			var ffeedFriend:FFeedFriend = new FFeedFriend();
			ffeedFriend.del({
				userId: userId
			});
			if (!friendUsers || friendUsers.length == 0) return;
			// Insert all friends
			try {
				//ffeedFriend.begin();
				for each (var user:FFeedUser in friendUsers) {
					(new FFeedFriend(userId, user.id)).insert();
				}
				//ffeedFriend.commit();
			} catch (err:Error) {
				trace("FFeedFriend: updateAll: " + err.message);
			}
		}
	}
}