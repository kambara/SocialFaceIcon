package socialfaceicon.model.friendfeed
{
	import jp.cre8system.framework.airrecord.model.ARModel;
	
	import socialfaceicon.model.IUser;
	import socialfaceicon.model.IconType;

	public class FFeedUser extends ARModel implements IUser
	{
		public var id:String; // TODO: 数値にしたい。Hash関数？ 名前をASCIIに変換？
								// もしくはtypeIdを文字列にする。
								// もしくはsaveAllするときのキーを指定できるようにして、idはprimaryに。
		public var name:String;
		
		[Embed(source="socialfaceicon/assets/friendfeed-icon.png")]
		private var FriendfeedIconImage:Class;
		
		public function FFeedUser(id:String = null, name:String = null)
		{
			super();
			this.__table = "friendfeed_users";
			this.id = id;
			this.name = name;
		}
		
		//
		// implements IUser
		//
		public function get iconUserId():* {
			return this.id;
		}
		public function get iconType():Number {
			return IconType.FRIENDFEED;
		}
		public function get iconTypeImage():Class {
			return this.FriendfeedIconImage;
		}
		public function getIconCurrentStatus():String {
			/*
			var s:FBookStatus = this.getCurrentStatus();
			return s ? s.message : null;
			*/
			return "????";
		}
		public function get iconUserUrl():String {
			return "http://friendfeed.com/" + this.id;
		}
		
		[Bindable]
		public function set iconName(value:String):void {}
		public function get iconName():String {
			return this.name;
		}
		
		[Bindable]
		public function set iconImageUrl(value:String):void {}
		public function get iconImageUrl():String {
			return "http://friendfeed-api.com/v2/picture/" + this.id;
		}
	}
}