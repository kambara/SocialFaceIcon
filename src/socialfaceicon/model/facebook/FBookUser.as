package socialfaceicon.model.facebook
{
	import jp.cre8system.framework.airrecord.model.ARModel;
	
	import socialfaceicon.model.IUser;
	import socialfaceicon.model.IconType;

	public class FBookUser extends ARModel implements IUser
	{
		public var id:Number;
		public var name:String;
		public var profileUrl:String;
		public var picSquare:String;
		public var pic:String;
		public var picBig:String
		public var picSmall:String;
		
		[Embed(source="socialfaceicon/assets/facebook-icon.png")]
		private var FacebookIconImage:Class;
		
		public function FBookUser(id:Number = NaN,
									name:String = null,
									profileUrl:String = null,
									picSquare:String = null,
									pic:String = null,
									picBig:String = null,
									picSmall:String = null)
		{
			super();
			this.__table = "facebook_users";
			
			this.id = id;
			this.name = name;
			this.profileUrl = profileUrl;
			this.picSquare = picSquare;
			this.pic = pic;
			this.picBig = picBig;
			this.picSmall = picSmall;
		}
		
		private function getCurrentStatus():FBookStatus {
			var fbookStatus:FBookStatus = new FBookStatus();
			if (fbookStatus.load(
						{uid: this.id},
						"time DESC"))
			{
				return fbookStatus;
			}
			return null;
		}
		
		//
		// implements IUser
		//
		public function get iconUserId():Number {
			return this.id;
		}
		public function get iconType():Number {
			return IconType.FACEBOOK;
		}
		public function get iconTypeImage():Class {
			return this.FacebookIconImage;
		}
		public function getIconCurrentStatus():String {
			var s:FBookStatus = this.getCurrentStatus();
			return s ? s.message : null;
		}
		public function get iconUserUrl():String {
			return this.profileUrl;
		}
		
		[Bindable]
		public function set iconName(value:String):void {}
		public function get iconName():String {
			return this.name;
		}
		
		[Bindable]
		public function set iconImageUrl(value:String):void {}
		public function get iconImageUrl():String {
			return this.picSquare;
		}
	}
}