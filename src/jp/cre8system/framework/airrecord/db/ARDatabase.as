////////////////////////////////////////////////////////////////////////////
//
//  AirRecord - SQLite Database Model Access Framework
//  Copyright 2008 CRE8SYSTEM All Rights Reserved.
//
//  NOTICE: CRE8SYSTEM. permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////
package jp.cre8system.framework.airrecord.db
{
	import flash.data.SQLResult;
	import flash.utils.Dictionary;
	
	import jp.cre8system.framework.airrecord.error.ARError;
	
	public class ARDatabase
	{
		private var _config:Dictionary;
		private var _connection:Dictionary;
		private var _driver:Dictionary;
		private static var _arDatabase:ARDatabase;

		public function ARDatabase(singleton:ARDatabaseInternal):void
		{
			super();
			
			if (!singleton) 
			{
				throw new ARError(ARError.SINGLETON_INSTANCE_ERROR);
			}
			
			_config = new Dictionary();
			_connection = new Dictionary();
			_driver = new Dictionary();
		}

		public static function get instance():ARDatabase
		{
			return ARDatabaseInternal.instance;
		}

		public function add(user:String, password:String, db:String, ddl:*, name:String = "", path:String = ""):void
		{
			var config:ARDatabaseConfig = new ARDatabaseConfig();
			config.user = user;
			config.password = password;
			config.db = db;
			config.ddl = ddl;
			config.path = path;
			
			this._config[name] = config;
		}
		
		public function connect(name:String = "", initialize:Boolean = false):void
		{
			var config:ARDatabaseConfig = this._config[name];
			if (!this._driver[name])
			{
				this._driver[name] = new ARSQLite();
			}
			if (!this._connection[name])
			{
				var driver:ARDriver = this._driver[name];
				this._connection[name] = this._driver[name].connect(config, initialize);

				var ddl:Array = []
				if (config.ddl is String)
				{
					ddl.push(config.ddl);
				} else {
					ddl = config.ddl as Array;
				}
				for each (var query:String in ddl)
				{
					driver.query(this._connection[name], query);
				}

			}
		}
		
		public function find(table:String, condition:* = null, order:String = "", limit:String = "", group:String = "", name:String = ""):SQLResult
		{
			var query:String = "SELECT * FROM " + table;
			var driver:ARDriver = this._driver[name];
			query = driver.getFindQuery(query, condition, order, limit, group);
			return this.query(query, name);
		}

		public function findQuery(query:String, condition:* = null, order:String = "", limit:String = "", group:String = "", name:String = ""):SQLResult
		{
			var driver:ARDriver = this._driver[name];
			query = driver.getFindQuery(query, condition, order, limit, group);
			return this.query(query, name);
		}

		public function insert(table:String, data:Object, name:String = "", params:Object = null):SQLResult
		{
			var driver:ARDriver = this._driver[name];
			var query:String = "INSERT INTO " + table + "(";
			var fields:Array = [];
			var key:String;
			for (key in data)
			{
				fields.push(driver.field(key));
			}
			query = query + fields.join(",") + ") VALUES(";
			var values:Array = [];
			for (key in data)
			{
				// Do not quote if param exists
				//   data   = {"bytes": ":bytes"}
				//   params = {":bytes": xxxxxxx}
				var quote:Boolean = true;
				if (params
					&& data
					&& data[key]
					&& params.hasOwnProperty(data[key])) {
					quote = false;
				}
				values.push(driver.value(data[key], quote));
			}
			query = query + values.join(",") + ")";
			return this.query(query, name, params);
		}

		public function update(table:String, data:Object, condition:* = null, name:String = ""):SQLResult
		{
			var driver:ARDriver = this._driver[name];
			var query:String = "UPDATE " + table + " SET ";
			var fields:Array = [];
			var key:String;
			for (key in data)
			{
				fields.push(driver.createCondition(key, data[key]));
			}
			query = query + fields.join(",") + driver.parseCondition(condition, " WHERE ");
			return this.query(query, name);
		}

		public function del(table:String, condition:* = null, name:String = ""):SQLResult
		{
			var driver:ARDriver = this._driver[name];
			var query:String = "DELETE FROM " + table + driver.parseCondition(condition, " WHERE ");
			return this.query(query, name);
		}
	
		/**
		 * Add params by kamara
		 */
		public function query(query:String, name:String = "", params:Object = null):SQLResult
		{
			var config:ARDatabaseConfig = this._config[name];
			var driver:ARDriver = this._driver[name];
			return driver.query(this._connection[name], query, params);
		}

		public function begin(name:String = ""):void
		{
			var config:ARDatabaseConfig = this._config[name];
			var driver:ARDriver = this._driver[name];
			return driver.begin(this._connection[name]);
		}

		public function rollback(name:String = ""):void
		{
			var config:ARDatabaseConfig = this._config[name];
			var driver:ARDriver = this._driver[name];
			return driver.rollback(this._connection[name]);
		}

		public function commit(name:String = ""):void
		{
			var config:ARDatabaseConfig = this._config[name];
			var driver:ARDriver = this._driver[name];
			return driver.commit(this._connection[name]);
		}
		
	}
}

import jp.cre8system.framework.airrecord.db.ARDatabase;
class ARDatabaseInternal
{
    public static var instance:ARDatabase
        = new ARDatabase(new ARDatabaseInternal());
}