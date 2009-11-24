package socialfaceicon.model
{
	import socialfaceicon.view.IconWindow;

	public class DesktopIcon extends AbstractIcon
	{
		public var x:Number = 0;
		public var y:Number = 0;
		
		private static var iconWindowTable:Object = {}; // icons in view
		
		public function DesktopIcon(id:Number = NaN,
									type:Number = NaN,
									userId:* = null,
									x:Number = 0,
									y:Number = 0)
		{
			super(id, type, userId);
			this.__table = "desktop_icons";
			this.x = x;
			this.y = y;
		}
		
		private function get iconWindow():IconWindow {
			return DesktopIcon.iconWindowTable[ this.id ];
		}
		
		public function moveTo(_x:Number, _y:Number):void {
			this.x = Math.round(_x);
			this.y = Math.round(_y);
			this.update({
				id: this.id
			}, null);
			
			if (iconWindow) {
				iconWindow.moveWindowTo(_x, _y);
			}
		}
		
		//
		// Status
		//
		public static function updateViewStatus():void {
			for each (var icon:IconWindow in DesktopIcon.iconWindowTable) {
				icon.updateStatus();
			}
		}
		
		//
		// Open
		//
		private function open():void {
			var iconWindow:IconWindow = (new IconWindow()).init(this.id);
			iconWindow.open();
			DesktopIcon.iconWindowTable[this.id] = iconWindow;
		}
		
		public static function addAndOpen(type:Number,
									userId:*,
									x:Number,
									y:Number):void
		{
			var icon:DesktopIcon = new DesktopIcon();
			icon.type = type;
			icon.userId = userId;
			icon.x = x;
			icon.y = y;
			try {
				icon.id = icon.insert().lastInsertRowID;
			} catch(err:Error) {
				trace(err.message);
				return;
			}
			icon.open()
		}

		public static function openAll():void {
			var desktopIcon:DesktopIcon = new DesktopIcon();
			for each (var iconObj:Object in desktopIcon.find()) {
				(new DesktopIcon(
						iconObj.id,
						iconObj.type,
						iconObj.userId,
						iconObj.x,
						iconObj.y
						)).open();
			}
		}
		
		//
		// Close
		//
		public function closeAndDelete():void {
			// View
			iconWindow.close();
			// DB
			del({id: this.id});
			// Table
			delete DesktopIcon.iconWindowTable[ this.id ];
		}
		
		public static function closeAll():void {
			for each (var icon:IconWindow in DesktopIcon.iconWindowTable) {
				icon.close();
			}
			DesktopIcon.iconWindowTable = {};
		}
	}
}