package socialfaceicon.model.facebook
{
	import jp.cre8system.framework.airrecord.model.ARModel;
	
	import mx.utils.StringUtil;
	
	import socialfaceicon.model.IStatus;

	public class FBookStatus extends ARModel implements IStatus
	{
		public var id:String;
		public var userId:String;
		public var message:String;
		public var time:Number;
		
		public function FBookStatus(id:String = null,
									userId:String = null,
									message:String = null,
									time:Number = NaN)
		{
			super();
			this.__table = "facebook_statuses";
			this.id = id;
			this.userId = userId;
			this.message = message;
			this.time = time;
		}
		
		//
		// implements IStatus
		//
		public function get statusMessage():String {
			return this.message;
		}
		public function get statusTime():Number {
			return this.time;
		}
		public function get statusUrl():String {
			var user:FBookUser = new FBookUser();
			if (user.loadById(userId)) {
				return user.profileUrl + "?v=feed&story_fbid=" + id;
			}
			return null;
		}
	}
}