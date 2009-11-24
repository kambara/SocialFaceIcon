package socialfaceicon.model.facebook
{
	import jp.cre8system.framework.airrecord.model.ARModel;

	public class FBookFriend extends ARModel
	{
		public var userId:String;
		public var friendUserId:String;
		
		public function FBookFriend(userId:String = null,
									friendUserId:String = null)
		{
			super();
			this.__table = "facebook_friends";
			this.userId = userId;
			this.friendUserId = friendUserId;
		}
		
		public static function updateAll(userId:String, friendUsers:Array):void {
			// Delete all friends
			var fbookFriend:FBookFriend = new FBookFriend();
			fbookFriend.del({
				userId: userId
			});
			if (!friendUsers || friendUsers.length == 0) return;
			
			// Insert all friends
			try {
				fbookFriend.begin();
				for each (var user:FBookUser in friendUsers) {
					(new FBookFriend(userId, user.id)).insert();
				}
				fbookFriend.commit();
			} catch (err:Error) {
				trace("FBookFriend: updateAll: " + err.message);
			}
		}
		
		public static function getUsers(userId:String):Array {
			var users:Array = [];
			var friendObjects:Array = (new FBookFriend()).find({ userId: userId });
			if (friendObjects) {
				for each (var friendObj:Object in friendObjects) {
					var user:FBookUser = new FBookUser();
					if (user.loadById(friendObj.friendUserId)) {
						users.push(user);
					}
				}
			}
			return users;
		}
		
		/*
		private static function getUserIds(userId:String):Array {
			var friends:Array = (new FBookFriend()).find({userId: userId});
			if (!friends) return [];
			return friends.map(
					function(f:Object, index:int, ary:Array):Number {
						return f.friendUserId;
					});
		}
		
		public static function getUsers(userId:String):Array {
			var users:Array = [];
			for each (var id:String in getUserIds(userId)) {
				var user:FBookUser = new FBookUser();
				if (user.loadById(id)) {
					users.push(user);
				}
			}
			return users;
		}
		*/
	}
}