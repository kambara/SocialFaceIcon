////////////////////////////////////////////////////////////////////////////
//
//  AirRecord - SQLite Database Model Access Framework
//  Copyright 2008 CRE8SYSTEM All Rights Reserved.
//
//  NOTICE: CRE8SYSTEM. permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////
package jp.cre8system.framework.airrecord.error
{
	public class ARError extends Error
	{

		public static const SINGLETON_INSTANCE_ERROR:String = "Singleton instance error.";
		
		public function ARError(message:String="", id:int=0)
		{
			super(message, id);
		}
	}
}