package socialfaceicon.model
{
	public interface IUser
	{
		function get iconUserId():Number;
		function get iconType():Number;
		
		function getIconCurrentStatus():String;
		function get iconUserUrl():String;
		
		// Should be Bindable
		function get iconName():String;
		function set iconName(value:String):void;
		// Should be Bindable
		function get iconImageUrl():String;
		function set iconImageUrl(value:String):void;
	}
}