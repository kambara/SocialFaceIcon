package socialfaceicon.model
{
	import flash.display.NativeWindow;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.DragSource;
	
	public class DragMousePoint
	{
		private var dragStartStageMousePoint:Point;
		private var dragStartScreenMousePoint:Point;
		
		public function DragMousePoint(mouse:MouseEvent,
										nativeWindow:NativeWindow)
		{
			dragStartStageMousePoint = new Point(
				mouse.stageX,
				mouse.stageY
			);
			dragStartScreenMousePoint = new Point(
				nativeWindow.x + mouse.stageX,
				nativeWindow.y + mouse.stageY
			);
		}
		
		public static function fromDragSource(dragSource:DragSource):DragMousePoint {
			return DragMousePoint(
						dragSource.dataForFormat(
							DragFormat.DRAG_MOUSE_POINT));
		}

		public function getDiffInStage(destX:Number, destY:Number):Point {
			var destPoint:Point = new Point(destX, destY);
			return destPoint.subtract(
						this.dragStartStageMousePoint);
		}
		
		public function getDiffInScreen(destX:Number, destY:Number):Point {
			var destPoint:Point = new Point(destX, destY);
			return destPoint.subtract(
						this.dragStartScreenMousePoint);
		}
	}
}