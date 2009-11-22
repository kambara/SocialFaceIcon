package socialfaceicon.view.friendslist
{
	import mx.containers.Canvas;
	
	import socialfaceicon.view.DesktopWindow;

	public class AbstractFriendsList extends Canvas
	{
		public function AbstractFriendsList()
		{
			super();
		}
		
		//
		// Drag & Drop
		//
		protected function onDragStart():void {
			DesktopWindow.instance.show();
		}
			
		protected function onDragComplete():void {
			DesktopWindow.instance.hide();
		}
	}
}