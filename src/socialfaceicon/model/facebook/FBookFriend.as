package socialfaceicon.model.facebook
{
	import jp.cre8system.framework.airrecord.model.ARModel;

	public class FBookFriend extends ARModel
	{
		public var uid:Number;
		public var friendUserId:Number;
		
		public function FBookFriend(uid:Number = NaN,
									friendUserId:Number = NaN)
		{
			super();
			this.__table = "facebook_friends";
			this.uid = uid;
			this.friendUserId = friendUserId;
		}
		
		public static function updateAll(uid:Number, friendUsers:Array):void {
			// Delete all friends
			var fbookFriend:FBookFriend = new FBookFriend();
			fbookFriend.del({
				uid: uid
			});
			if (!friendUsers || friendUsers.length == 0) return;
			
			// Insert all friends
			try {
				fbookFriend.begin();
				for each (var user:FBookUser in friendUsers) {
					(new FBookFriend(uid, user.id)).insert();
				}
				fbookFriend.commit();
			} catch (err:Error) {
				trace("TwitFriend: updateAll: " + err.message);
			}
		}
		
		private static function getUserIds(uid:Number):Array {
			var friends:Array = (new FBookFriend()).find( {uid: uid} );
			if (!friends) return [];
			return friends.map(
					function(f:Object, index:int, ary:Array):Number {
						return f.friendUserId;
					});
		}
		
		public static function getUsers(uid:Number):Array {
			var users:Array = [];
			for each (var id:Number in getUserIds(uid)) {
				var user:FBookUser = new FBookUser();
				if (user.loadById(id)) {
					users.push(user);
				}
			}
			return users;
		}
	}
}