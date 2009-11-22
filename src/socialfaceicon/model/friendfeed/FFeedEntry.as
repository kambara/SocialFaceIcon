package socialfaceicon.model.friendfeed
{
	import jp.cre8system.framework.airrecord.model.ARModel;

	public class FFeedEntry extends ARModel
	{
		public var id:String
		public var userId:String;
		public var body:String;
		public var url:String;
		public var date:Number;
					
		public function FFeedEntry()
		{
			super();
			this.__table = "friendfeed_entries";
		}
		
	}
}