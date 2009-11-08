package socialfaceicon.model
{
	import jp.cre8system.framework.airrecord.model.ARModel;

	public class TwitFriend extends ARModel
	{
		public var screenName:String;
		public var friendUserId:Number;
		
		public function TwitFriend(screenName:String = null,
									friendUserId:Number = NaN)
		{
			super();
			this.__table = "twitter_friends";
			
			this.screenName = screenName;
			this.friendUserId = friendUserId;
		}
		
		public static function getUserIds(name:String):Array {
			var friends:Array = (new TwitFriend()).find( {screenName: name} );
			if (!friends || friends.length==0) {
				return [];
			}
			return friends.map(
					function(f:Object, index:int, ary:Array):Number {
						return f.friendUserId;
					});
		}
		
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
	}
}