package socialfaceicon.model
{
	public class IconStatus
	{
		public static function update():void {
			DesktopIcon.updateStatus();
			DesktopGroup.updateStatus();
			// TODO: Dock
		}
	}
}