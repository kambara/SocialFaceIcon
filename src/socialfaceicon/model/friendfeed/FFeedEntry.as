package socialfaceicon.model.friendfeed
{
	import jp.cre8system.framework.airrecord.model.ARModel;

	public class FFeedEntry extends ARModel
	{
		public var id:String;
		public var userIdName:String;
		public var body:String;
		public var url:String;
		public var date:Number;
		
		public function FFeedEntry(id:String = null,
								   userIdName:String = null,
								   body:String = null,
								   url:String = null,
								   date:Number = NaN)
		{
			super();
			this.__table = "friendfeed_entries";
			this.id = id;
			this.userIdName = userIdName;
			this.body = body;
			this.url = url;
			this.date = date;
		}
		
		
	}
}