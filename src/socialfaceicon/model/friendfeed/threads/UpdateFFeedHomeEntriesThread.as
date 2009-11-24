package socialfaceicon.model.friendfeed.threads
{
	import org.libspark.thread.utils.EventDispatcherThread;

	public class UpdateFFeedHomeEntriesThread extends UpdateFFeedAbstractEntriesThread
	{
		public function UpdateFFeedHomeEntriesThread()
		{
			super();
			ffeedEntries = new FFeedHomeEntriesThread();
		}
	}
}