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
 * - Add load() method
 * - Add loadById() method
 * - Add an argument:params to insert() and query() method
 * - Add save() method
 */

package jp.cre8system.framework.airrecord.model
{
	import flash.data.SQLResult;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import jp.cre8system.framework.airrecord.db.ARDatabase;
	
	import mx.collections.ArrayCollection;
	
	public class ARModel
	{
		protected var __primaryKey:String = "id";
		protected var __displayField:String = "name";
		protected var __dbName:String = "";
		protected var __table:String = "";
		protected var __db:ARDatabase = ARDatabase.instance;
		protected var __hasOne:Object = null;
		protected var __belongsTo:Object = null;
		protected var __hasMany:Object = null;
		protected var __hasAndBelongsToMany:Object = null;
		protected var __recursive:int = 1;

		public function ARModel()
		{
		}
		
		public function query(query:String, params:Object = null):SQLResult
		{
			return this.__db.query(query, this.__dbName, params);
		}

		public function find(condition:* = null, order:String = "", limit:String = "", group:String = ""):Array
		{
			var result:SQLResult = this.__db.find(this.__table, condition, order, limit, group, this.__dbName);
			var data:Array = result.data;
			if (this.__recursive == 0) return data;
			this._addHasOne(data);
			this._addHasMany(data);
			this._addBelongsTo(data);
			this._addHasAndBelongsToMany(data);
			return data;
		}

		public function findQuery(query:String, condition:* = null, order:String = "", limit:String = "", group:String = ""):Array
		{
			var result:SQLResult = this.__db.findQuery(query, condition, order, limit, group, this.__dbName);
			var data:Array = result.data;
			return data;
		}

		public function findone(condition:* = null, order:String = ""):Object
		{
			var result:Array = this.find(condition, order, "1");
			if (!result) return null;
			return result[0];
		}
		
		public function load(condition:* = null, order:String = ""):Boolean {
			var result:Object = this.findone(condition, order);
			if (!result) return false;
			for (var key:String in result) {
				if (this.hasOwnProperty(key)) {
					// this[key]がNumberでresult[key]がnullの場合、0が代入されてしまう。
					if (this[key] is Number && result[key] == null) {
						this[key] = NaN;
					} else {
						this[key] = result[key];
					}
				}
			}
			return true;
		}
		
		public function loadById(value:Object):Boolean {
			return load({id: value.toString()});
		}
		
		public function findByARModelIds(models:Array):Array {
			if (!models || models.length == 0) return [];
			var condAry:Array = [];
			for each (var model:Object in models) {
				if (model.hasOwnProperty("id")
					&& model["id"] is Number
					&& !isNaN(model["id"])) {
					condAry.push("id = " + model["id"]);
				}
			}
			if (condAry.length == 0) return [];
			return find( condAry.join(" OR ") );
		}
		
		public function findIdTableByARModelIds(models:Array):Object {
			var existModels:Array = findByARModelIds(models);
			var obj:Object = {};
			for each (var m:Object in existModels) {
				obj[m.id] = m;
			}
			return obj;
		}
		
		public function saveAll(models:Array):void {
			try {
				var existTable:Object = findIdTableByARModelIds( models );
			} catch (err:Error) {
				return;
			}
			try {
				begin();
				for each (var model:ARModel in models) {
					if (existTable[ model["id"] ]) {
						model.update({ id: model["id"] });
					} else {
						model.insert();
					}
				}
				commit();
			} catch (err:Error) {
				trace(this.className + ": saveAll: " + err.message);
			}
		}
		
		public function insertAll(models:Array):void {
			try {
				var existTable:Object = findIdTableByARModelIds( models );
			} catch (err:Error) {
				return;
			}
			try {
				begin();
				for each (var model:ARModel in models) {
					if (!existTable[ model["id"] ]) {
						model.insert();
					}
				}
				commit();
			} catch (err:Error) {
				trace(this.className + ": insertAll: " + err.message);
			}
		}

		public function generateList(condition:* = null, order:String = "", limit:String = ""):Array
		{
			var result:Array = this.find(condition, order, limit);
			if (!result) return null;
			var list:Array = [];
			var data:ArrayCollection = new ArrayCollection(result);
            for each (var record:* in data)
            {
            	list.push(record[this.__displayField]);
            }
			return list;
		}

		public function insert(data:Object = null, params:Object = null):SQLResult
		{
			if (data == null) {
				data = createDynamicObject();
			}
			return this.__db.insert(this.__table, data, this.__dbName, params);
		}

		public function update(condition:* = null, data:Object = null):SQLResult
		{
			if (data == null) {
				data = createDynamicObject();	
			}
			return this.__db.update(this.__table, data, condition, this.__dbName);
		}

		public function del(condition:* = null):SQLResult
		{
			return this.__db.del(this.__table, condition, this.__dbName);
		}

		public function createDynamicObject():Object
		{
			var obj:Object = {};
            var classInfo:XML = describeType(this);
            for each ( var varInfo:XML in classInfo.variable )
            {
                var varName:String = String(varInfo.@name);
                var varType:String = String(varInfo.@type);
				obj[varName] = this[varName];
            }
			return obj;	
		}

		public function cleanDynamicObject(obj:Object):Object
		{
			var newobj:Object = {};
            var classInfo:XML = describeType(this);
            for each ( var varInfo:XML in classInfo.variable )
            {
                var varName:String = String(varInfo.@name);
                var varType:String = String(varInfo.@type);
                if (varName in obj) newobj[varName] = obj[varName];
            }
			return newobj;
		}

		private function _createModel(name:String, recursiveLast:Boolean = false):ARModel
		{
            var packageName:String = this._getThisPackageName();
			var classReference:Class = getDefinitionByName(packageName + "." + name) as Class;
            var model:Object = new classReference();
            model.__db = this.__db;
            if (recursiveLast)
            {
	            model.__recursive = 0;
            } else {
	            model.__recursive = this.__recursive - 1;
            }
			return model as ARModel;
		}
		
		private function _getThisClassName():String
		{
			var className:String = getQualifiedClassName(this);
            var classNameArray:Array = className.split("::");
			return classNameArray[1];			
		}

		private function _getThisPackageName():String
		{
			var className:String = getQualifiedClassName(this);
            var classNameArray:Array = className.split("::");
			return classNameArray[0];
		}

		private function _addConndition(condition:*, add:*):*
		{
			var key:String;
			if (condition is Object)
			{
	            for (key in add)
	            {
	            	condition[key] = add[key];
	            }
	            return condition;
			} else {
				if (!condition) {
					return add;
				}
				var addQueries:Array = [];
				for (key in add) {
					addQueries.push(key + " = '" + add[key] + "'");
				}
				return "(" + condition + ") and (" + addQueries.join(" and") + ")"; 
			}
		}

		private function _addHasMany(result:Array):void
		{
			if (!this.__hasMany) return;
			
			var data:ArrayCollection = new ArrayCollection(result);
            for each (var record:* in data)
            {
				for (var key:String in this.__hasMany)
				{
					var hasMany:ARAssociation = this.__hasMany[key] as ARAssociation;
					if (!hasMany.className) hasMany.className = key;
					if (!hasMany.foreignKey) hasMany.foreignKey = this._getThisClassName().toLocaleLowerCase()+"_id";
					var model:ARModel = this._createModel(hasMany.className, hasMany.recursiveLast);
					var add:Object = {};
					add[hasMany.foreignKey] = record[model.__primaryKey];
					var where:* = this._addConndition(hasMany.conditions, add);
					record[key] = model.find(where, hasMany.order, hasMany.limit);
				}
            }
		}

		private function _addHasOne(result:Array):void
		{
			if (!this.__hasOne) return;
	
			var data:ArrayCollection = new ArrayCollection(result);
            for each (var record:* in data)
            {
				for (var key:String in this.__hasOne)
				{
					var hasOne:ARAssociation = this.__hasOne[key] as ARAssociation;
					if (!hasOne.className) hasOne.className = key;
					if (!hasOne.foreignKey) hasOne.foreignKey = this._getThisClassName().toLocaleLowerCase()+"_id";
					var model:ARModel = this._createModel(hasOne.className, hasOne.recursiveLast);
					var add:Object = {};
					add[hasOne.foreignKey] = record[model.__primaryKey];
					var where:* = this._addConndition(hasOne.conditions, add);
					record[key] = model.findone(where, hasOne.order);
				}
			}
		}

		private function _addBelongsTo(result:Array):void
		{
			if (!this.__belongsTo) return;
	
			var data:ArrayCollection = new ArrayCollection(result);
            for each (var record:* in data)
            {
				for (var key:String in this.__belongsTo)
				{
					var belongsTo:ARAssociation = this.__belongsTo[key] as ARAssociation;
					if (!belongsTo.className) belongsTo.className = key;
					if (!belongsTo.foreignKey) belongsTo.foreignKey = belongsTo.className.toLocaleLowerCase()+"_id";
					var model:ARModel = this._createModel(belongsTo.className, belongsTo.recursiveLast);
					var add:Object = {};
					add[model.__primaryKey] = record[belongsTo.foreignKey];
					var where:* = this._addConndition(belongsTo.conditions, add);
					record[key] = model.findone(where, belongsTo.order);
				}
			}
		}

		private function _addHasAndBelongsToMany(result:Array):void
		{
			if (!this.__hasAndBelongsToMany) return;
	
			var data:ArrayCollection = new ArrayCollection(result);
            for each (var record:* in data)
            {
				for (var key:String in this.__hasAndBelongsToMany)
				{
					var hasAndBelongsToMany:ARAssociation = this.__hasAndBelongsToMany[key] as ARAssociation;
					if (!hasAndBelongsToMany.className) hasAndBelongsToMany.className = key;
					if (!hasAndBelongsToMany.joinTable) hasAndBelongsToMany.joinTable = this._getThisClassName().toLocaleLowerCase()+"_"+hasAndBelongsToMany.className.toLocaleLowerCase();
					if (!hasAndBelongsToMany.foreignKey) hasAndBelongsToMany.foreignKey = this._getThisClassName().toLocaleLowerCase()+"_id";
					if (!hasAndBelongsToMany.associationForeignKey) hasAndBelongsToMany.associationForeignKey = hasAndBelongsToMany.className.toLocaleLowerCase()+"_id";
					var model:ARModel = this._createModel(hasAndBelongsToMany.className, hasAndBelongsToMany.recursiveLast);
					var subQuery:String = "(select " + hasAndBelongsToMany.associationForeignKey + " from " + hasAndBelongsToMany.joinTable + " where " + hasAndBelongsToMany.foreignKey + " = '" + record[this.__primaryKey] + "')";
					var query:String = "select * from " + model.__table;
					var where:Array = [];
					var whereStr:String = "";
					if (hasAndBelongsToMany.conditions is Object) {
						for (var kk:String in hasAndBelongsToMany.conditions) {
							where.push(kk + " = '" + hasAndBelongsToMany.conditions[kk] + "'"); 
						}
						whereStr = where.join(" and ");
					}
					if (whereStr == "") {
						whereStr = model.__primaryKey + " in " + subQuery;
					} else {
						whereStr = "(" + whereStr + ") and " + model.__primaryKey + " in " + subQuery;
					}
					record[key] = model.findQuery(query, whereStr, hasAndBelongsToMany.order, hasAndBelongsToMany.limit);
				}
			}
		}
		
		public function begin():void
		{
			this.__db.begin(this.__dbName);
		}

		public function rollback():void
		{
			this.__db.rollback(this.__dbName);
		}

		public function commit():void
		{
			this.__db.commit(this.__dbName);
		}

	}
}