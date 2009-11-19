package socialfaceicon.model.facebook
{
	import jp.cre8system.framework.airrecord.model.ARModel;

	public class FBookStatus extends ARModel
	{
		public var id:Number;
		public var uid:Number;
		public var message:String;
		public var time:Number;
		
		public function FBookStatus(id:Number = NaN,
									uid:Number = NaN,
									message:String = null,
									time:Number = NaN)
		{
			super();
			this.__table = "facebook_statuses";
			this.id = id;
			this.uid = uid;
			this.message = message;
			this.time = time;
		}
		
	}
}