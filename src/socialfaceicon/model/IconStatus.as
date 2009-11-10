package socialfaceicon.model
{
	import flash.desktop.DockIcon;
	
	public class IconStatus
	{
		public static function update():void {
			DesktopIcon.updateViewStatus();
			DesktopGroup.updateViewStatus();
			HumanDockIcon.updateViewStatus();
		}
	}
}