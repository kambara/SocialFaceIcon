package socialfaceicon.model
{
	import jp.cre8system.framework.airrecord.db.ARDatabase;
	
	public class DB
	{
		private static const VERSION:String = "alpha2";
		
		private static const TEXT:String     = "TEXT";
		private static const INTEGER:String  = "INTEGER";
		private static const BLOB:String     = "BLOB";
		private static const PRIMARY:String  = "PRIMARY KEY";
		private static const UNIQUE:String   = "UNIQUE";
		private static const NOT_NULL:String = "NOT NULL";
		
		public static function createTables():void {
			var db:ARDatabase = ARDatabase.instance;
			db.add(null, null, "faceicon-" + VERSION, tables);
			db.connect();
		}
		
		private static function get tables():Array {
			return [
				table( "settings", {
					key:   [TEXT, NOT_NULL, UNIQUE],
					value: [TEXT]
					}),
				
				// Twitter API
				// - http://apiwiki.twitter.com/
				// - http://watcher.moe-nifty.com/memo/2007/04/twitter_api.html
				// TwitterScript Reference
				// - http://sappari.org/misc/twitterscript-r19-asdoc/
				table("twitter_friends", {
					screenName:   [TEXT,    NOT_NULL],
					friendUserId: [INTEGER, NOT_NULL]
					}),
				index("twitter_friends", ["screenName"]),
				
				table("twitter_users", {
					id:          [INTEGER, NOT_NULL, UNIQUE], // Twitter User ID
					screenName:  [TEXT,    NOT_NULL, UNIQUE],
					name:        [TEXT],
					location:    [TEXT],
					description: [TEXT],
					url:         [TEXT],
					profileImageUrl: [TEXT, NOT_NULL]
					}),
				index("twitter_users", ["id"]),
				
				table("twitter_statuses", {
					id:        [INTEGER, NOT_NULL, UNIQUE], // Twitter Status ID
					twitterUserId: [INTEGER, NOT_NULL],
					text:      [TEXT,    NOT_NULL],
					createdAt: [INTEGER, NOT_NULL]
					}),
				index("twitter_statuses", ["id"]),
				index("twitter_statuses", ["twitterUserId"]),
				
				//
				// Facebook API
				// http://wiki.developers.facebook.com/index.php/API
				// AS3 Library
				// http://facebook-actionscript-api.googlecode.com/svn/release/current/docs/index.html
				//
				table("facebook_friends", {
					uid:          [INTEGER, NOT_NULL],
					friendUserId: [INTEGER, NOT_NULL]
					}),
				index("facebook_friends", ["uid"] ),
				// Users.getInfo
				// http://wiki.developers.facebook.com/index.php/Users.getInfo
				table("facebook_users", {
					id:         [INTEGER, NOT_NULL, UNIQUE], // Facebook User ID (uid)
					name:       [TEXT, NOT_NULL],
					profileUrl: [TEXT, NOT_NULL],
					picSquare:  [TEXT], // 50x50
					pic:        [TEXT], // 100x300
					picBig:     [TEXT], // 200x600
					picSmall:   [TEXT]  // 50x150
					}),
				index("facebook_users", ["id"]),
				// Status.get
				// http://wiki.developers.facebook.com/index.php/Status.get
				table("facebook_statuses", {
					id:      [TEXT, UNIQUE], // NOT Facebook Status ID (status_id) -> uid-time 
					uid:     [INTEGER, NOT_NULL],
					message: [TEXT,    NOT_NULL],
					time:    [INTEGER, NOT_NULL]
					}),
				index("facebook_statuses", ["id"]),
				index("facebook_statuses", ["uid"]),
				
				// Friendfeed API
				// - http://friendfeed.com/api/documentation
				// - http://friendfeed.com/api/documentation#types
				// - http://code.google.com/p/friendfeed-as3/
				table("friendfeed_friends", {
					userId:       [TEXT, NOT_NULL],
					friendUserId: [TEXT, NOT_NULL]
					}),
				index("friendfeed_friends", ["userId"]),
				// feedinfo -> subscriptions
				// http://friendfeed.com/api/documentation#read_feedinfo
				// http://friendfeed.com/api/documentation#read_picture
				table("friendfeed_users", {
					id:   [TEXT, NOT_NULL, UNIQUE], // friendfeed user id
					name: [TEXT, NOT_NULL]
					}),
				index("friendfeed_users", ["id"]),
				// entry
				// http://friendfeed.com/api/documentation#read_entry
				table("friendfeed_entries", {
					id:     [TEXT, NOT_NULL, UNIQUE], // friendfeed entry id
					userId: [TEXT, NOT_NULL],
					body:   [TEXT],
					url:    [TEXT],
					date:   [INTEGER, NOT_NULL]
					}),
				index("friendfeed_entries", ["id"]),
				index("friendfeed_entries", ["userId"]),
				
				// Icons
				table("desktop_icons", {
					id:     [INTEGER, PRIMARY],
					type:   [INTEGER, NOT_NULL],
					userId: [INTEGER, NOT_NULL],
					x:      [INTEGER, NOT_NULL],
					y:      [INTEGER, NOT_NULL]
					}),
					
				// Groups
				table("desktop_groups", {
					id:     [INTEGER, PRIMARY],
					firstIconId: [INTEGER, NOT_NULL],
					x:      [INTEGER, NOT_NULL],
					y:      [INTEGER, NOT_NULL],
					piled:  [INTEGER, NOT_NULL]
					}),
				table("group_icons", {
					id:      [INTEGER, PRIMARY],
					type:    [INTEGER, NOT_NULL],
					userId:  [INTEGER, NOT_NULL],
					nextId:  [INTEGER]
					}),
				
				// Dock
				table("dock_icons", {
					id:      [INTEGER, PRIMARY],
					type:    [INTEGER, NOT_NULL],
					userId:  [INTEGER, NOT_NULL],
					nextId:  [INTEGER],
					isFirst: [INTEGER]
					}),
				
				// Image Cache
				table("image_caches", {
					id:        [INTEGER, PRIMARY],
					url:       [TEXT,    NOT_NULL, UNIQUE],
					bytes:     [BLOB,    NOT_NULL],
					width:     [INTEGER, NOT_NULL],
					height:    [INTEGER, NOT_NULL],
					updatedAt: [INTEGER, NOT_NULL]
					}),
				index("image_caches", ["url"], true)
			];
		}
		
		private static function index(table:String, fields:Array, unique:Boolean = false):String {
			var name:String = table + "_" + fields.join("_");
			return [
				"CREATE",
				unique
					? "UNIQUE"
					: "",
				"INDEX IF NOT EXISTS",
				name,
				"ON",
				table,
				"(",
				fields.join(", "),
				")"
			].join(" ");
		}
		
		private static function table(table:String, params:Object):String {
			var array:Array = [];
			for (var key:String in params) {
				array.push( key + " " + params[key].join(' ') ); 
			}
			return [
				"CREATE TABLE IF NOT EXISTS",
				table,
				"(",
				array.join(", "),
				")"
			].join(" ");
		}
	}
}