package socialfaceicon.model.friendfeed.threads
{
	import flash.events.Event;
	
	import org.libspark.thread.Thread;
	import org.libspark.thread.utils.EventDispatcherThread;
	
	import socialfaceicon.model.friendfeed.FFeedEntry;

	public class UpdateFFeedUserEntriesThread extends UpdateFFeedAbstractEntriesThread
	{
		public function UpdateFFeedUserEntriesThread(userId:String)
		{
			super();
			ffeedEntries = new FFeedUserEntriesThread(userId);
		}
	}
}