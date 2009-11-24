package socialfaceicon.model.friendfeed
{
	import jp.cre8system.framework.airrecord.model.ARModel;

	public class FFeedFriend extends ARModel
	{
		public var idName:String;
		public var friendIdName:String;
					
		public function FFeedFriend(idName:String = null,
									friendIdName:String = null)
		{
			super();
			this.__table = "friendfeed_friends";
			this.idName = idName;
			this.friendIdName = friendIdName;
		}
		
		private static function getUserIdNames(idName:String):Array {
			var friends:Array = (new FFeedFriend()).find( {idName: idName} );
			if (!friends || friends.length==0) {
				return [];
			}
			return friends.map(
					function(f:Object, index:int, ary:Array):String {
						return f.friendIdName;
					})
			/*
			var cond:String = friends.map(
					function(f:Object, index:int, ary:Array):String {
						return "idName = '" + f.friendIdName + "'";
					}).join(" OR ");
			return (new FFeedUser()).find(cond).map(
					function(u:Object, index:int, ary:Array):Number {
						return u.id
					});
					*/
		}
		
		public static function getUsers(idName:String):Array {
			var users:Array = [];
			for each (var idName:String in getUserIdNames(idName)) {
				var user:FFeedUser = new FFeedUser();
				if (user.load({idName: idName})) {
					users.push(user);
				}
			}
			return users;
		}
		
		public static function updateAll(idName:String, friendUsers:Array):void {
			// Delete all friends
			var ffeedFriend:FFeedFriend = new FFeedFriend();
			ffeedFriend.del({
				idName: idName
			});
			if (!friendUsers || friendUsers.length == 0) return;
			// Insert all friends
			try {
				//ffeedFriend.begin();
				for each (var user:FFeedUser in friendUsers) {
					(new FFeedFriend(idName, user.idName)).insert();
				}
				//ffeedFriend.commit();
			} catch (err:Error) {
				trace("FFeedFriend: updateAll: " + err.message);
			}
		}
	}
}