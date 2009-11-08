////////////////////////////////////////////////////////////////////////////
//
//  AirRecord - SQLite Database Model Access Framework
//  Copyright 2008 CRE8SYSTEM All Rights Reserved.
//
//  NOTICE: CRE8SYSTEM. permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////

/**
 * Modified by kambara
 * - Add an argument:params to query() method
 * - Add an argument:quote to value() method for removing quote
 */

package jp.cre8system.framework.airrecord.db
{
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.filesystem.File;
	
	public class ARSQLite implements ARDriver
	{
		
		private static const DBFILE_EXT:String = ".db";
		private static const DEFAULT_DBPATH:String = "app-storage:/";
		
		private var sqlStatement:SQLStatement;
		
		public function ARSQLite()
		{
		}
		
		public function connect(config:ARDatabaseConfig, initialize:Boolean = false):SQLConnection
		{
			//データベースを開きます、存在しない場合は作成されます
			//データベースの場所としてマイドキュメントを指定
			var dbPath:String = config.path;
			if (!dbPath)
			{
				dbPath = DEFAULT_DBPATH;
			}
			var file:File = new File(dbPath + config.db + DBFILE_EXT);
			
			if (initialize && file.exists)
			{
				// 初期化モードの場合は、ファイルを削除
				file.deleteFile();
			}
			
			//SQLConnectionの作成
			//SQLConnectionを使用して、ローカルのデータベースとの接続します。
			var connection:SQLConnection = new SQLConnection();
			
			//open()によってデータベースを開きます、（同期モード）
			//また指定されたデータベースがない場合は作成します。
			connection.open(file);
			
			return connection;
		}
		
		/***
		 * Add params by kambara
		 */
		public function query(connection:SQLConnection, query:String, params:Object = null):SQLResult
		{
			//SQLStatementクラスを使用して接続先と
			//実行するSQL構文を書きます
			if (sqlStatement == null || sqlStatement.sqlConnection !== connection)
			{
				sqlStatement = new SQLStatement();
				sqlStatement.sqlConnection = connection;
			}
			sqlStatement.text = query;
			if (params) {
				for (var key:String in params) {
					sqlStatement.parameters[key] = params[key];
				}
			} else {
				sqlStatement.clearParameters();
			}
			//実行
			sqlStatement.execute();
			
			return sqlStatement.getResult();
		}

		public function escape(query:String):String
		{
			var str:String = query;
			var reg:RegExp = new RegExp("'", "g");
			str = str.replace(reg, "''");
			return str;
		}
		
		public function getFindQuery(query:String, condition:* = null, order:String = "", limit:String = "", group:String = ""):String
		{
			if (condition)	query = query + " WHERE " + this.parseCondition(condition);
			if (group)		query = query +" GROUP BY " + group;
			if (order)		query = query +" ORDER BY " + order;
			if (limit)		query = query +" LIMIT " + limit;
			return query;
		}
		
		public function parseCondition(data:*, query:String = ""):String
		{
			if (data == null) return "";
			if (data is String)
			{
				return data;
			}
			var queries:Array = [];
			var obj:Object = data as Object; 
			for (var key:String in obj)
			{
				queries.push(this.createCondition(key, obj[key]));
			}  
			var ret:String = queries.join(" AND ");
			if (ret)
			{
				ret = query + ret;
			}
			return ret;
		}

		public function field(field:String):String
		{
			return field;
		}
		
		public function value(value:*, quote:Boolean = true):String
		{
			if (value == null || (value is Number && isNaN(value))) return 'NULL';
			value = this.escape(value);
			
			if (quote) {
				value = "'" + value + "'";
			}
			return value;
		}
		
		public function createCondition(field:String, value:*):String
		{
			return this.field(field) + '=' + this.value(value);
		}

		public function begin(connection:SQLConnection):void
		{
			connection.begin();
		}

		public function rollback(connection:SQLConnection):void
		{
			connection.rollback();
		}

		public function commit(connection:SQLConnection):void
		{
			connection.commit();
		}
				
	}
}