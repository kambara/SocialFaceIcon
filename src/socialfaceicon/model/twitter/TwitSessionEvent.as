package socialfaceicon.model.twitter
{
	import flash.events.Event;

	public class TwitSessionEvent extends Event
	{
		public static const START:String = "START";
		public static const VERIFY_ERROR:String = "VERIFY_ERROR";
		
		public function TwitSessionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}