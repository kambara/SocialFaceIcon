package socialfaceicon.model.friendfeed
{
	import jp.cre8system.framework.airrecord.model.ARModel;

	public class FFeedEntry extends ARModel
	{
		public var id:Number;
		public var userId:Number;
		public var body:String;
		public var url:String;
		public var date:Number;
					
		public function FFeedEntry(id:Number = NaN,
								   userId:Number = NaN,
								   body:String = null,
								   url:String = null,
								   date:Number = NaN)
		{
			super();
			this.__table = "friendfeed_entries";
			this.id = id;
			this.userId = userId;
			this.body = body;
			this.url = url;
			this.date = date;
		}
		
	}
}