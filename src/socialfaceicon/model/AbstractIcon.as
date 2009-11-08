package socialfaceicon.model
{
	import jp.cre8system.framework.airrecord.model.ARModel;
	
	import socialfaceicon.model.IUser;
	import socialfaceicon.model.IconType;
	import socialfaceicon.model.TwitUser;

	public class AbstractIcon extends ARModel
	{
		public var id:Number;
		public var type:Number;
		public var userId:Number;
		
		public function AbstractIcon(id:Number = NaN,
									 type:Number = NaN,
									 userId:Number = NaN)
		{
			super();
			this.id = id;
			this.type = type;
			this.userId = userId;
		}
		
		public function getUser():IUser {
			switch(type) {
				case IconType.TWITTER:
					var twitUser:TwitUser = new TwitUser();
					if (twitUser.loadById( userId ))
						return twitUser;
					break;
				case IconType.FACEBOOK:
					break;
			}
			return null;
		}
	}
}