package socialfaceicon.model
{
	public class GroupIcon extends AbstractIcon
	{
		public var nextId:Number = NaN;
		
		public function GroupIcon(id:Number = NaN,
									type:Number = NaN,
									userId:Number = NaN,
									nextId:Number = NaN)
		{
			super(id, type, userId);
			this.__table = "group_icons";
			this.nextId = nextId;
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
		
		public function getDesktopGroup():DesktopGroup {
			var firstIcon:GroupIcon = getFirstGroupIcon();
			var desktopGroup:DesktopGroup = new DesktopGroup();
			if ( desktopGroup.load({firstIconId: firstIcon.id}) ) {
				return desktopGroup;
			}
			return null;
		}
		
		public function getList():Array {
			var nextIcon:GroupIcon = getNextGroupIcon();
			if (nextIcon) {
				var ary:Array = nextIcon.getList();
				ary.unshift(this);
				return ary;
			}
			return [this];
		}
		
		public function destroy():GroupIcon {
			var newFirstGroupIcon:GroupIcon = null;
			var prevIcon:GroupIcon = getPrevGroupIcon();
			if (prevIcon) {
				newFirstGroupIcon = getFirstGroupIcon();
				prevIcon.updateNextId( this.nextId );
			} else {
				newFirstGroupIcon = getNextGroupIcon();
			}
			this.del({id: this.id});
			return newFirstGroupIcon;
		}
		
		private function getNextGroupIcon():GroupIcon {
			if (!isNaN(nextId)) {
				var icon:GroupIcon = new GroupIcon();
				if (icon.loadById(nextId)) {
					return icon;
				}
			}
			return null;
		}
		
		private function getPrevGroupIcon():GroupIcon {
			var icon:GroupIcon = new GroupIcon();
			if (icon.load({nextId: this.id})) {
				return icon;
			}
			return null;
		}
		
		private function getFirstGroupIcon():GroupIcon {
			var prevIcon:GroupIcon = getPrevGroupIcon();
			if (prevIcon) {
				return prevIcon.getFirstGroupIcon();
			}
			return this;
		}
	}
}