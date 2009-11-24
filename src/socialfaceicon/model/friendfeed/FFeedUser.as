package socialfaceicon.model.friendfeed
{
	import flash.net.URLLoader;
	
	import jp.cre8system.framework.airrecord.model.ARModel;
	
	import socialfaceicon.model.IUser;
	import socialfaceicon.model.IconType;

	public class FFeedUser extends ARModel implements IUser
	{
		public var id:Number;
		public var idName:String;
		public var name:String;
		
		[Embed(source="socialfaceicon/assets/friendfeed-icon.png")]
		private var FriendfeedIconImage:Class;
		
		public function FFeedUser(id:Number = NaN,
								  idName:String = null,
								  name:String = null)
		{
			super();
			this.__table = "friendfeed_users";
			this.id = id;
			this.idName = idName;
			this.name = name;
		}
		
		public function loadByIdName(idName:String):Boolean {
			return this.load({
				idName: idName
			});
		}
		
		public override function saveAll(models:Array, keyName:String, insertOnly:Boolean=false):void {
			try {
				var existTable:Object = makeExistModelsTable( models, "idName" );
			} catch (err:Error) {
				return;
			}
			try {
				begin();
				for each (var user:FFeedUser in models) {
					if (existTable[user.idName]) {
						if (!insertOnly) {
							user.update({
								idName: user.idName
							}, {
								name: user.name
							});
						}
					} else {
						user.insert();
					}
				}
				commit();
			} catch (err:Error) {
				trace("FFeedUser: "
						+ (insertOnly ? "insertAll" : "saveAll")
						+ ": "
						+ err.getStackTrace());
			}
		}
		
		public function updateEntries():void {
			
		}
		
		private function getCurrentEntry():FFeedEntry {
			var ffeedEntry:FFeedEntry = new FFeedEntry();
			if (ffeedEntry.load({userId: this.id},
								"date DESC"))
			{
				return ffeedEntry;
			}
			return null;
		}
		
		//
		// implements IUser
		//
		public function get iconUserId():* {
			return this.id;
		}
		public function get iconType():Number {
			return IconType.FRIENDFEED;
		}
		public function get iconTypeImage():Class {
			return this.FriendfeedIconImage;
		}
		public function getIconCurrentStatus():String {
			var e:FFeedEntry = this.getCurrentEntry();
			return e ? e.body : null;
		}
		public function get iconUserUrl():String {
			return "http://friendfeed.com/" + this.idName;
		}
		
		[Bindable]
		public function set iconName(value:String):void {}
		public function get iconName():String {
			return this.name;
		}
		
		[Bindable]
		public function set iconImageUrl(value:String):void {}
		public function get iconImageUrl():String {
			return "http://friendfeed-api.com/v2/picture/" + this.idName;
		}
	}
}