/**
 * Some parts of this script derive from TwitterScript library.
 * http://code.google.com/p/twitterscript/
 */

package socialfaceicon.model.twitter
{
	import jp.cre8system.framework.airrecord.model.ARModel;
	
	import mx.utils.StringUtil;
	
	import socialfaceicon.model.IStatus;
	import socialfaceicon.utils.DateUtil;

	public class TwitStatus extends ARModel implements IStatus
	{
		public var id:Number;
		public var userId:String;
		public var text:String;
		public var createdAt:Number;
		
		public function TwitStatus(id:Number = NaN,
								   userId:String = null,
								   text:String = null,
								   createdAt:Number = NaN)
		{
			super();
			this.__table = "twitter_statuses";
			
			this.id = id;
			this.userId = userId;
			this.text = text;
			this.createdAt = createdAt;
		}
		
		public static function newFromStatusXml(xml:XML, userId:String):TwitStatus {
			return new TwitStatus(
						xml.id,
						userId,
						xml.text,
						DateUtil.strToDate(xml.created_at).getTime());
		}
		
		//
		// implements IStatus
		//
		public function get statusMessage():String {
			return this.text;
		}
		public function get statusTime():Number {
			return this.createdAt;
		}
		public function get statusUrl():String {
			var user:TwitUser = new TwitUser();
			if (user.loadById(userId)) {
				return StringUtil.substitute(
							"http://twitter.com/{0}/status/{1}",
							user.screenName,
							id);
			}
			return null;
		}
	}
}