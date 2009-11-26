package socialfaceicon.utils
{
	public class DateUtil
	{
		private static const MONTHS:Array = [
			"Jan", "Feb", "Mar","Apr","May", "Jun",
			"Jul","Aug","Sep","Oct","Nov","Dec"];
		
		public static function strToDate(dateStr:String):Date {
			var time:Date = new Date();
			var year:int;
			var month:int;
			var date:int;
			var hour:int;
			var minutes:int;
			var seconds:int;
			var timezone:int;
			if (dateStr.match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z/g).length==1) {
				// match 2008-12-07T16:24:24Z
				var tp1:Array = dateStr.split(/[-T:Z]/g);
				year = tp1[0];
				month = tp1[1] - 1;
				date = tp1[2];
				hour = tp1[3];
				minutes = tp1[4];
				seconds = tp1[5];
			} else if (dateStr.match(/[a-zA-z]{3} [a-zA-Z]{3} \d{2} \d{2}:\d{2}:\d{2} \+\d{4} \d{4}/g).length==1){
				// match Fri Dec 05 16:40:02 +0000 2008
				var tp2:Array = dateStr.split(/[ :]/g);
				month = MONTHS.lastIndexOf(tp2[1]);
				date = tp2[2];
				hour = tp2[3];
				minutes = tp2[4];
				seconds = tp2[5];
				timezone = tp2[6];
				year = tp2[7];
			} else {
				return null;
			}
			
			time.setUTCFullYear(year, month, date);
			time.setUTCHours(hour, minutes, seconds);
			return time;
		}
		
		public static function ago(time:Number):String {
			var currentMsec:Number = (new Date()).getTime();
			var dMsec:Number = (new Date()).getTime() - time;
			var dSec:Number = Math.round(dMsec/1000);
			if (dSec < 0) {
				return null;
			} else if (dSec < 60) { // ~60sec
				return dSec + " sec";
			} else if (dSec < 60 * 60) { // ~60min
				return pluralize(Math.round(dSec/60),
								 "minute");
			} else if (dSec < 24 * 60 * 60) { // ~24hour
				return pluralize(Math.round(dSec/(60 * 60)),
								 "hour");
			} else {
				return pluralize(Math.round(dSec/(24 * 60 * 60)),
								 "day");
			}
			return null;
		}
		
		private static function pluralize(num:Number, unit:String):String {
			if (num == 1) {
				return num + " " + unit;
			}
			return num + " " + unit + "s";
		}
	}
}