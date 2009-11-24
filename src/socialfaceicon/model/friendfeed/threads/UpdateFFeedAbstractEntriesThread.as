package socialfaceicon.model.friendfeed.threads
{
	import flash.events.Event;
	
	import org.libspark.thread.Thread;
	import org.libspark.thread.utils.EventDispatcherThread;
	
	import socialfaceicon.model.friendfeed.FFeedEntry;

	public class UpdateFFeedAbstractEntriesThread extends EventDispatcherThread
	{
		public static const FINISH:String = "finish";
		protected var ffeedEntries:FFeedAbstractEntriesThread;
		
		public function UpdateFFeedAbstractEntriesThread()
		{
			super();
		}
		
		protected override function run():void {
			ffeedEntries.start();
			ffeedEntries.join();
			next(onLoad);
			error(Error, onError);
		}
		
		private function onLoad():void {
			trace(this.className + ": Saving");
			(new FFeedEntry()).saveAll( ffeedEntries.ffeedEntries );
		}
		
		private function onError(err:Error, t:Thread):void {
			trace(this.className + ": " + err.message);
			next(null);
		}
		
		protected override function finalize():void {
			trace(this.className + ": Finish");
			dispatchEvent(new Event(UpdateFFeedAbstractEntriesThread.FINISH));
		}
	}
}