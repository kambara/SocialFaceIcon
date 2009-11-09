package socialfaceicon.events
{
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;

	public class MouseDragStartEvent extends MouseEvent
	{
		public static const MOUSE_DRAG_START:String = "mouseDragStart";
		
		private var _stageX:Number;
		private var _stageY:Number;
		
		public function MouseDragStartEvent(type:String, stageX:Number, stageY:Number, bubbles:Boolean=true, cancelable:Boolean=false, localX:Number=NaN, localY:Number=NaN, relatedObject:InteractiveObject=null, ctrlKey:Boolean=false, altKey:Boolean=false, shiftKey:Boolean=false, buttonDown:Boolean=false, delta:int=0, commandKey:Boolean=false, controlKey:Boolean=false, clickCount:int=0)
		{
			super(type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta, commandKey, controlKey, clickCount);
			this._stageX = stageX;
			this._stageY = stageY;
		}
		
		public override function get stageX():Number {
			return _stageX;
		}
		
		public override function get stageY():Number {
			return _stageY;
		}
	}
}