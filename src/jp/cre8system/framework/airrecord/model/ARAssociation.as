////////////////////////////////////////////////////////////////////////////
//
//  AirRecord - SQLite Database Model Access Framework
//  Copyright 2008 CRE8SYSTEM All Rights Reserved.
//
//  NOTICE: CRE8SYSTEM. permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////
package jp.cre8system.framework.airrecord.model
{
	public class ARAssociation
	{
		
		public var className:String;
		public var joinTable:String;
		public var foreignKey:String;
		public var associationForeignKey:String;
		public var conditions:*;
		public var order:String;
		public var limit:String;
		public var recursiveLast:Boolean;
		
		public function ARAssociation(
						className:String = null,
						foreignKey:String = null,
						conditions:String = null,
						order:String = null,
						limit:String = null,
						joinTable:String = null,
						associationForeignKey:String = null,
						recursiveLast:Boolean = false
						)
		{
			this.className = className;
			this.foreignKey = foreignKey;
			this.conditions = conditions;
			this.order = order;
			this.limit = limit;
			this.joinTable = joinTable;
			this.associationForeignKey = associationForeignKey;
			this.recursiveLast = recursiveLast;
		}

	}
}