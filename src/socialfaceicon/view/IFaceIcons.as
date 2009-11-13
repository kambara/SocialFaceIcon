package socialfaceicon.view
{
	import mx.core.IUIComponent;
	
	import socialfaceicon.model.DesktopGroup;
	import socialfaceicon.model.GroupIcon;
	
	public interface IFaceIcons extends IUIComponent
	{
		function addIcon(groupIcon:GroupIcon):void;
		function removeIcon(groupIcon:GroupIcon):void;
		function updateStatus(desktopGroup:DesktopGroup):void;
	}
}