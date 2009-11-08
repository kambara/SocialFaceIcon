package socialfaceicon.model
{
	import jp.cre8system.framework.airrecord.model.ARModel;

	public class TwitUser extends ARModel implements IUser
	{
		public var id:Number;
		public var screenName:String;
		public var name:String;
		public var location:String;
		public var description:String;
		public var url:String;
		public var profileImageUrl:String;
		
		public function TwitUser(id:Number = NaN,
									screenName:String = null,
									name:String = null,
									location:String = null,
									description:String = null,
									url:String = null,
									profileImageUrl:String = null)
		{
			super();
			this.__table = "twitter_users";
			
			this.id = id;
			this.screenName = screenName;
			this.name = name;
			this.location = location;
			this.description = description;
			this.url = url;
			this.profileImageUrl = profileImageUrl;
		}
		
		public static function newFromUserXml(xml:XML):TwitUser {
			var user:TwitUser = new TwitUser(
					xml.id,
					xml.screen_name,
					xml.name,
					xml.location,
					xml.description,
					xml.url,
					xml.profile_image_url);
			return user;
		}
		
		public function save():void {
			if ( (new TwitUser()).load({id: id}) ) {
				update({id: id}, null);
			} else {
				insert();
			}
			/*
			try {
				insert();
			} catch (err:Error) {
				trace(err.name +" "+err.message);
				update({id: id}, null);
			}
			*/
		}
		
		private function getCurrentTwitStatus():TwitStatus {
			var twitStatus:TwitStatus = new TwitStatus();
			if (twitStatus.load(
					{twitterUserId: this.id},
					"createdAt DESC"))
			{
				return twitStatus;
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
			return IconType.TWITTER;
		}
		public function getIconCurrentStatus():String {
			var s:TwitStatus = this.getCurrentTwitStatus();
			return s ? s.text : null;
		}
		public function get iconUserUrl():String {
			return "http://twitter.com/" + this.screenName;
		}
		
		[Bindable]
		public function set iconName(value:String):void {}
		public function get iconName():String {
			return name;
		}
		
		[Bindable]
		public function set iconImageUrl(value:String):void {}
		public function get iconImageUrl():String {
			return profileImageUrl;
		}
		
	}
}