package socialfaceicon.model.facebook
{
	import jp.cre8system.framework.airrecord.model.ARModel;

	public class FBookStatus extends ARModel
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
			if (id) {
				this.id = id;
			} else if (userId && time) {
				this.id = userId + "-" + time;
			}
			this.userId = userId;
			this.message = message;
			this.time = time;
		}
		
	}
}