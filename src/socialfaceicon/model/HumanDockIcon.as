package socialfaceicon.model
{
	import mx.events.FlexEvent;
	
	import socialfaceicon.view.DockWindow;
	
	public class HumanDockIcon extends AbstractIcon
	{
		public var nextId:Number;
		public var isFirst:Number;
		private static var dockWindow:DockWindow;
		
		public function HumanDockIcon(id:Number=NaN,
									  type:Number=NaN,
									  userId:*=null,
									  nextId:Number=NaN,
									  isFirst:Number=NaN)
		{
			super(id, type, userId);
			this.__table = "dock_icons";
			this.nextId = nextId;
			this.isFirst = isFirst;
		}
		
		public static function openAll():void {
			dockWindow = new DockWindow();
			dockWindow.addEventListener(
				FlexEvent.INITIALIZE, function():void {
					for each (var dockIcon:HumanDockIcon in getAllDockIcons()) {
						dockWindow.addIcon( dockIcon );
					}
				});
			dockWindow.open();
		}
		
		public static function updateViewStatus():void {
			dockWindow.updateStatus();
		}
		
		private static function setFirstIcon(iconId:Number):void {
			var dockIcon:HumanDockIcon = new HumanDockIcon();
			dockIcon.update({isFirst: 1}, {isFirst: 0});
			dockIcon.update({id: iconId}, {isFirst: 1});
		}
		
		public function updateNextId(newNextId:Number):void {
			if (this.id == newNextId) {
				throw new Error("nextId can not be equal to icon id.");
				return;
			}
			this.nextId = newNextId;
			update(
				{id: this.id},
				{nextId: newNextId}
			);
		}
		
		//
		// Manage DockIcons
		//
		public static function getAllDockIcons():Array {
			var first:HumanDockIcon = getFirstDockIcon();
			if (first) {
				return first.getDockIconList();
			}
			return [];
		}
		
		private function getDockIconList():Array {
			var nextIcon:HumanDockIcon = getNextDockIcon();
			if (nextIcon) {
				var icons:Array = nextIcon.getDockIconList();
				icons.unshift(this);
				return icons;
			}
			return [this];
		}
		
		private function getNextDockIcon():HumanDockIcon {
			var dockIcon:HumanDockIcon = new HumanDockIcon();
			if (!isNaN(this.nextId)) {
				if ( dockIcon.load({ id: this.nextId }) ) {
					return dockIcon;
				}
			}
			return null;
		}
		
		private function getPrevDockIcon():HumanDockIcon {
			var dockIcon:HumanDockIcon = new HumanDockIcon();
			if (dockIcon.load({ nextId: this.id })) {
				return dockIcon;
			}
			return null;
		}
		
		private static function getFirstDockIcon():HumanDockIcon {
			var dockIcon:HumanDockIcon = new HumanDockIcon();
			if ( dockIcon.load({ isFirst: 1 }) ) {
				return dockIcon;
			}
			return null;
		}
		
		//
		// Add Icon
		//
		public static function addUser(user:IUser,
										x:Number=NaN,
										y:Number=NaN):void
		{
			var newDockIcon:HumanDockIcon =
							new HumanDockIcon(
										NaN,
										user.iconType,
										user.iconUserId,
										NaN,
										NaN);
			try {
				newDockIcon.id = newDockIcon.insert().lastInsertRowID;
			} catch (err:Error) {
				return;
			}
			
			// update nextId or isFirst
			var icons:Array = getAllDockIcons();
			if (icons && icons.length > 0) {
				var lastIcon:HumanDockIcon = icons[icons.length - 1];
				lastIcon.updateNextId( newDockIcon.id );
			} else {
				HumanDockIcon.setFirstIcon( newDockIcon.id );
			}
			
			// update View
			if (dockWindow) {
				dockWindow.addIcon( newDockIcon );
			}
		}
		
		//
		//  Close Icon
		//
		public function closeAndDelete():void {
			// View
			dockWindow.removeIcon( this );
			// Update chain
			if (this.isFirst) {
				HumanDockIcon.setFirstIcon(nextId);
			} else {
				var prevIcon:HumanDockIcon = getPrevDockIcon();
				if (prevIcon) {
					prevIcon.updateNextId(nextId);
				}
			}
			del({id: this.id});
		}
	}
}