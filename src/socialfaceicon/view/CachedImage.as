package socialfaceicon.view
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filters.DropShadowFilter;
	
	import mx.controls.Image;
	import mx.events.FlexEvent;
	
	import socialfaceicon.model.ImageCache;

	public class CachedImage extends Image
	{
		private var _sourceUrl:String = null;
		private var imgCache:ImageCache
		
		public function CachedImage()
		{
			super();
			addEventListener(FlexEvent.INITIALIZE, onInitialize);
		}
		
		private function onInitialize(event:FlexEvent):void {
			this.filters = [new DropShadowFilter(
				1,  // distance
				60, // angle
				0x000000,
				1,  // alpha
				3,  // blurX
				3,  // blurY
				2,  // strength
				2   // quality
			)];
		}
		
		public override function set source(value:Object):void {
			if (value is String && !!value) {
				loadImage(value as String);
			} else {
				super.source = value;
			}
		}
		
		private function loadImage(url:String):void {
			if (_sourceUrl == url) return;
			_sourceUrl = url;
			imgCache = new ImageCache();
			imgCache.addEventListener(
				Event.COMPLETE,
				onImageLoad);
			imgCache.addEventListener(
				IOErrorEvent.IO_ERROR,
				onImageIOError);
			imgCache.loadImage(url);
		}
		
		private function onImageLoad(event:Event):void {
			this.source = imgCache.bitmap;
		}
		
		private function onImageIOError(event:IOErrorEvent):void {
			_sourceUrl = null;
		}
	}
}