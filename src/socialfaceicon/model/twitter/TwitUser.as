package socialfaceicon.model.twitter
{
	import jp.cre8system.framework.airrecord.model.ARModel;
	
	import socialfaceicon.model.IStatus;
	import socialfaceicon.model.IUser;
	import socialfaceicon.model.IconType;

	public class TwitUser extends ARModel implements IUser
	{
		public var id:String;
		public var screenName:String;
		public var name:String;
		public var location:String;
		public var description:String;
		public var url:String;
		public var profileImageUrl:String;
		
		[Embed(source="socialfaceicon/assets/twitter-icon.png")]
		private var TwitterIconImage:Class;
		
		public function TwitUser(id:String = null,
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
		
		private function getCurrentTwitStatus():TwitStatus {
			var twitStatus:TwitStatus = new TwitStatus();
			if (twitStatus.load({userId: this.id}, "createdAt DESC")) {
				return twitStatus;
			}
			return null;
		}
		
		//
		// implements IUser
		//
		public function get iconUserId():String {
			return this.id;
		}
		public function get iconType():Number {
			return IconType.TWITTER;
		}
		public function get iconTypeImage():Class {
			return this.TwitterIconImage;
		}
		public function getIconCurrentStatus():IStatus {
			return this.getCurrentTwitStatus();
		}
		public function getIconStatuses(max:int):Array {
			var statusObjects:Array = (new TwitStatus()).find(
											{userId: this.id},
											"createdAt DESC",
											max.toString());
			var statuses:Array = [];
			for each (var sObj:Object in statusObjects) {
				statuses.push(
					new TwitStatus(sObj.id,
								   sObj.userId,
								   sObj.text,
								   sObj.createdAt));
			}
			return statuses;
		}
		public function getRecentStatusesCount(minutes:uint = 60):uint {
			var from:Number = (new Date()).getTime() - (minutes * 60 * 1000);
			var cond:String = [
				"userId = " + this.id.toString(),
				"AND",
				"createdAt > " + from
			].join(" ");
			
			var statusObjects:Array = (new TwitStatus()).find(cond);
			return statusObjects ? statusObjects.length : 0;
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