package socialfaceicon.model.facebook
{
	import jp.cre8system.framework.airrecord.model.ARModel;
	
	import socialfaceicon.model.IStatus;
	import socialfaceicon.model.IUser;
	import socialfaceicon.model.IconType;

	public class FBookUser extends ARModel implements IUser
	{
		public var id:String;
		public var name:String;
		public var profileUrl:String;
		public var picSquare:String;
		public var pic:String;
		public var picBig:String
		public var picSmall:String;
		
		[Embed(source="socialfaceicon/assets/facebook-icon.png")]
		private var FacebookIconImage:Class;
		
		public function FBookUser(id:String = null,
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
			if (fbookStatus.load({userId: this.id}, "time DESC")) {
				return fbookStatus;
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
			return IconType.FACEBOOK;
		}
		public function get iconTypeImage():Class {
			return this.FacebookIconImage;
		}
		public function getIconCurrentStatus():IStatus {
			return this.getCurrentStatus();
		}
		public function getIconStatuses(max:int):Array {
			var statusObjects:Array = (new FBookStatus()).find(
											{userId: this.id},
											"time DESC",
											max.toString());
			var statuses:Array = [];
			for each (var sObj:Object in statusObjects) {
				statuses.push(
					new FBookStatus(sObj.id,
									sObj.userId,
									sObj.message,
									sObj.time));
			}
			return statuses;
		}
		public function getRecentStatusesCount(minutes:uint = 60):uint {
			var from:Number = (new Date()).getTime() - (minutes * 60 * 1000);
			var cond:String = [
				"userId = " + this.id.toString(),
				"AND",
				"time > " + from
			].join(" ");
			var statusObjects:Array = (new FBookStatus()).find(cond);
			return statusObjects ? statusObjects.length : 0;
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