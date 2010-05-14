package socialfaceicon.model
{
	public interface IUser
	{
		function get iconUserId():String;
		function get iconType():Number;
		function get iconTypeImage():Class;
		
		function getIconStatuses(max:int):Array;
		function getIconCurrentStatus():IStatus;
		function getRecentStatusesCount(minutes:uint = 60):uint;
		function get iconUserUrl():String;
		
		// Should be Bindable
		function get iconName():String;
		function set iconName(value:String):void;
		// Should be Bindable
		function get iconImageUrl():String;
		function set iconImageUrl(value:String):void;
	}
}