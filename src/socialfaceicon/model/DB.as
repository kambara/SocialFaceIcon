package socialfaceicon.model
{
	import jp.cre8system.framework.airrecord.db.ARDatabase;
	
	public class DB
	{
		private static const VERSION:String = "alpha1-1";
		
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
				
				table( "twitter_friends", {
					screenName:   [TEXT,    NOT_NULL],
					friendUserId: [INTEGER, NOT_NULL]
					}),
				table( "twitter_users", {
					id:          [INTEGER, NOT_NULL, UNIQUE], // Twitter User ID
					screenName:  [TEXT,    NOT_NULL, UNIQUE],
					name:        [TEXT],
					location:    [TEXT],
					description: [TEXT],
					url:         [TEXT],
					profileImageUrl: [TEXT, NOT_NULL]
					}),
				table( "twitter_statuses", {
					id:        [INTEGER, NOT_NULL, UNIQUE], // Twitter Status ID
					twitterUserId: [INTEGER, NOT_NULL],
					text:      [TEXT,    NOT_NULL],
					createdAt: [INTEGER, NOT_NULL]
					}),
				index( "twitter_statuses", ["twitterUserId"] ),
				
				// Friendfeed API
				// - http://friendfeed.com/api/documentation
				// - http://friendfeed.com/api/documentation#read_feedinfo
				// - http://code.google.com/p/friendfeed-as3/
				/*
				createTableQuery(
					"friendfeed_subscriptions", {
						id:       [INTEGER, PRIMARY],
						nickname: [TEXT, NOT_NULL, UNIQUE],
						name:     [TEXT, NOT_NULL]
					}),
				// http://friendfeed.com/api/documentation#types
				createTableQuery(
					"friendfeed_entries", {
						id:      [INTEGER, PRIMARY],
						entryId: [TEXT, NOT_NULL, UNIQUE],
						friendfeedSubscriptionId: [INTEGER, NOT_NULL],
						body:    [TEXT],
						url:     [TEXT],
						date:    [INTEGER, NOT_NULL]
					}),
				*/
				
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
					folded: [INTEGER, NOT_NULL]
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