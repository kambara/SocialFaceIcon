package socialfaceicon.model.friendfeed
{
	import jp.cre8system.framework.airrecord.model.ARModel;
	
	import socialfaceicon.model.IStatus;

	public class FFeedEntry extends ARModel implements IStatus
	{
		public var id:String;
		public var userId:String;
		public var body:String;
		public var url:String;
		public var date:Number;
		
		public function FFeedEntry(id:String = null,
								   userId:String = null,
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
		
		//
		// implements IStatus
		//
		public function get statusMessage():String {
			return this.body;
		}
		public function get statusTime():Number {
			return this.date;
		}
		public function get statusUrl():String {
			return this.url;
		}
	}
}