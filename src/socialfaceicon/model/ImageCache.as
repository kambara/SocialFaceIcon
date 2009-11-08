package socialfaceicon.model
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import jp.cre8system.framework.airrecord.model.ARModel;

	public class ImageCache extends ARModel implements IEventDispatcher
	{
		public var id:Number;
		public var url:String;
		public var bytes:ByteArray;
		public var width:Number;
		public var height:Number;
		public var updatedAt:Number;
		
		private var _bitmap:Bitmap;
		private var imgLoader:Loader;
		private var dispatcher:EventDispatcher;
		
		public function ImageCache()
		{
			super();
			this.__table = "image_caches"
			dispatcher = new EventDispatcher(this);
		}
		
		public function get bitmap():Bitmap {
			if (_bitmap)
				return _bitmap;
			if (bitmapData)
				return new Bitmap(bitmapData);
			return null;
		}
		
		public function loadImage(url:String):void {
			url = encodeURI(url);
			if ( load({url: url}) ) {
				dispatchEvent(new Event(Event.COMPLETE));
			} else {
				downloadImage(url);
			}
		}
		
		public function get bitmapData():BitmapData {
			if (!bytes || !width || !height) return null;
			var bmd:BitmapData = new BitmapData(width, height);
			bytes.position = 0;
			bmd.setPixels(
				new Rectangle(0, 0, width, height),
				bytes);
			return bmd;
		}
		
		private function downloadImage(url:String):void {
			if (url.slice(-4).toLowerCase() == ".bmp") {
				dispatchEvent(
					new IOErrorEvent(IOErrorEvent.IO_ERROR));
				return;
			}
			imgLoader = new Loader();
			imgLoader.contentLoaderInfo.addEventListener(
				Event.COMPLETE,
				onImageLoaderComplete);
			imgLoader.contentLoaderInfo.addEventListener(
				IOErrorEvent.IO_ERROR,
				onImageLoaderIOError);
			imgLoader.load(new URLRequest(url));
		}
		
		private function onImageLoaderComplete(event:Event):void {
			_bitmap = Bitmap(imgLoader.content);
			var byteArray:ByteArray =
					_bitmap.bitmapData.getPixels(
						new Rectangle(
								0, 0,
								_bitmap.width,
								_bitmap.height));
			this.url    = imgLoader.contentLoaderInfo.url;
			this.width  = _bitmap.width;
			this.height = _bitmap.height;
			this.bytes  = byteArray;
			this.updatedAt = (new Date()).getTime();
			try {
				insert({
						url:    this.url,
						width:  this.width,
						height: this.height,
						bytes:  ":bytes",
						updatedAt: this.updatedAt
					}, {
						":bytes": byteArray
					});
			} catch (err:Error) {
				trace(([
					"ImageCache",
					"insert",
					err.message
				]).join(": "));
			}
			dispatchEvent(event);
		}
		
		private function onImageLoaderIOError(event:IOErrorEvent):void {
			dispatchEvent(event);
		}
		
		//
		// implements IEventDispatcher
		//
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
			dispatcher.addEventListener(type, listener, useCapture, priority);
		}
		public function dispatchEvent(evt:Event):Boolean{
			return dispatcher.dispatchEvent(evt);
		}
		public function hasEventListener(type:String):Boolean{
			return dispatcher.hasEventListener(type);
		}
		    
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		                   
		public function willTrigger(type:String):Boolean {
			return dispatcher.willTrigger(type);
		}
	}
}