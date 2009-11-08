package socialfaceicon.model
{
	import jp.cre8system.framework.airrecord.model.ARModel;
	
	import socialfaceicon.view.GroupWindow;

	public class DesktopGroup extends ARModel
	{
		public var id:Number;
		public var firstIconId:Number;
		public var x:Number;
		public var y:Number;
		public var folded:Number;
		
		private static var groupWindowTable:Object = {}; // groups in view
		
		public function DesktopGroup(id:Number = NaN,
										firstIconId:Number = NaN,
										x:Number = 0,
										y:Number = 0,
										folded:Number = 0)
		{
			super();
			this.__table = "desktop_groups";
			
			this.id = id;
			this.firstIconId = firstIconId;
			this.x = x;
			this.y = y;
			this.folded = folded;
		}
		
		private static function create(firstIconId:Number, // not null
										x:Number,
										y:Number,
										folded:Number = 0):DesktopGroup {
			var desktopGroup:DesktopGroup =
					new DesktopGroup(NaN, firstIconId, x, y, folded);
			var id:Number = desktopGroup.insert().lastInsertRowID;
			desktopGroup.id = id;
			return desktopGroup;
		}
		
		public function get groupWindow():GroupWindow {
			return DesktopGroup.groupWindowTable[ this.id ];
		}
		
		public function getGroupIcons():Array {
			var firstIcon:GroupIcon = getFirstGroupIcon();
			if (firstIcon) {
				return firstIcon.getList();
			}
			return [];
		}
		
		private function getFirstGroupIcon():GroupIcon {
			var icon:GroupIcon = new GroupIcon();
			if (icon.loadById( this.firstIconId )) {
				return icon;
			}
			return null;
		}
		
		private function updateFirstIconId(newId:Number):void {
			updateParams({
				firstIconId: newId
			});
		}
		
		private function updateParams(data:Object):void {
			if (data) {
				for (var key:String in data) {
					this[key] = data[key];
				}
			}
			update({id: this.id}, data);
		}
		
		//
		// move
		//
		public function moveTo(_x:Number, _y:Number):void {
			this.x = _x;
			this.y = _y;
			this.update({
				id: this.id
			}, null);
			
			if (groupWindow) {
				groupWindow.moveWindowTo(_x, _y);
			}
		}
		
		//
		// Invalidate status
		//
		public static function updateStatus():void {
			for each (var groupWindow:GroupWindow in groupWindowTable) {
				groupWindow.updateStatus();
			}
		}
		
		//
		// Add
		//
		public function addUser(user:IUser):void {
			var newGroupIcon:GroupIcon = new GroupIcon(
												NaN,
												user.iconType,
												user.iconUserId,
												NaN);
			var newId:Number = newGroupIcon.insert().lastInsertRowID;
			newGroupIcon.id = newId;
			
			// update nextId
			var icons:Array = this.getGroupIcons();
			if (icons && icons.length > 0) {
				var lastGroupIcon:GroupIcon = icons[icons.length - 1];
				lastGroupIcon.updateNextId(newId);
			} else {
				// In case the group has no icon 
				updateFirstIconId( newId );
			}
			
			// update view
			if (groupWindow) {
				groupWindow.addIcon(newGroupIcon);
			}
		}
		
		//
		// Open
		//
		public static function createAndOpen(user1:IUser,
											user2:IUser,
											x:Number,
											y:Number):void {
			// Add 2 GroupIcons
			var groupIcon2:GroupIcon = new GroupIcon(
											NaN,
											user2.iconType,
											user2.iconUserId);
			var nextId:Number = groupIcon2.insert().lastInsertRowID;
			
			var groupIcon1:GroupIcon = new GroupIcon(
											NaN,
											user1.iconType,
											user1.iconUserId,
											nextId);
			var firstIconId:Number = groupIcon1.insert().lastInsertRowID;
			
			// Add DesktopGroup
			var desktopGroup:DesktopGroup = DesktopGroup.create(firstIconId, x, y);
			desktopGroup.open();
		}
		
		public function open():void {
			var groupWindow:GroupWindow = (new GroupWindow()).init(this.id);
			groupWindow.open();
			DesktopGroup.groupWindowTable[ this.id ] = groupWindow;
		}
		
		public static function openAll():void {
			var desktopGroup:DesktopGroup = new DesktopGroup();
			for each (var groupObj:Object in desktopGroup.find()) {
				(new DesktopGroup(
							groupObj.id,
							groupObj.firstIconId,
							groupObj.x,
							groupObj.y,
							groupObj.folded)).open();
			}
		}
		
		//
		// Close
		//
		public function closeAndDelete():void {
			// View
			groupWindow.close();
			// DB
			del({id: this.id});
			// Table
			delete DesktopGroup.groupWindowTable[ this.id ];
		}
		
		public function deleteGroupIconOrDisband(groupIcon:GroupIcon):void {
			var icons:Array = this.getGroupIcons();
			if (icons.length > 2) {
				deleteGroupIcon( groupIcon );
			} else if (icons.length == 2) {
				deleteTwoGroupIconAndDisband(icons[0], icons[1], groupIcon);
			} else if (icons.length == 1) {
				deleteGroupIcon( groupIcon );
				closeAndDelete();
			} else {
				// No such case
			}
		}
		
		private function deleteTwoGroupIconAndDisband(
											icon0:GroupIcon,
											icon1:GroupIcon,
											movedIcon:GroupIcon):void
		{
			var restGroupIcon:GroupIcon = (icon0.id == movedIcon.id)
											? icon1
											: icon0;
			// Add a rest icon to the desktop
			DesktopIcon.addAndOpen(
							restGroupIcon.type,
							restGroupIcon.userId,
							this.x + 12,
							this.y + 50);
			// Delete group and icons
			icon0.del({ id: icon0.id });
			icon1.del({ id: icon1.id });
			closeAndDelete();
		}
		
		private function deleteGroupIcon(groupIcon:GroupIcon):void {
			// View
			groupWindow.removeFaceIcon( groupIcon );
			// DB
			var newFirstGroupIcon:GroupIcon = groupIcon.destroy();
			if (newFirstGroupIcon) {
				if (newFirstGroupIcon.id != firstIconId) {
					updateFirstIconId( newFirstGroupIcon.id );
				}
			}
		}
	}
}