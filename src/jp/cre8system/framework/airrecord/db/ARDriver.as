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
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	
	public interface ARDriver
	{
		
		function connect(config:ARDatabaseConfig, initialize:Boolean = false):SQLConnection;
		
		function query(connection:SQLConnection, query:String, params:Object = null):SQLResult;
		
		function getFindQuery(query:String, condition:* = null, order:String = "", limit:String = "", group:String = ""):String;

		function escape(query:String):String;

		function field(field:String):String;
		
		function value(value:*, quote:Boolean = true):String;
		
		function createCondition(field:String, value:*):String;
		
		function parseCondition(data:*, query:String = ""):String
		
		function begin(connection:SQLConnection):void;

		function rollback(connection:SQLConnection):void;

		function commit(connection:SQLConnection):void;
										
	}
}