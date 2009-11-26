package socialfaceicon.model.facebook.threads
{
	import com.facebook.Facebook;
	import com.facebook.commands.fql.FqlQuery;
	import com.facebook.commands.friends.GetFriends;
	import com.facebook.commands.users.GetInfo;
	import com.facebook.data.FacebookData;
	import com.facebook.data.friends.GetFriendsData;
	import com.facebook.data.users.FacebookUser;
	import com.facebook.data.users.FacebookUserCollection;
	import com.facebook.data.users.GetInfoData;
	import com.facebook.data.users.GetInfoFieldValues;
	import com.facebook.events.FacebookEvent;
	import com.facebook.net.FacebookCall;
	
	import mx.utils.StringUtil;
	
	import org.libspark.thread.Thread;
	
	import socialfaceicon.model.facebook.FBookStatus;
	import socialfaceicon.model.facebook.FBookUser;

	public class FBookFriendsThread extends Thread
	{
		private var facebook:Facebook;
		private var _fbookUsers:Array;
		private var _fbookStatuses:Array;
		
		public function FBookFriendsThread(facebook:Facebook)
		{
			super();
			this.facebook = facebook;
			this._fbookUsers = [];
			this._fbookStatuses = [];
		}
		
		protected override function run():void {
			var call:FacebookCall = facebook.post(new GetFriends());
			event(call, FacebookEvent.COMPLETE, onGetFriendsComplete);
		}
		
		private function onGetFriendsComplete(evt:FacebookEvent):void {
			if (!evt.success) return;
			var friends:FacebookUserCollection = (evt.data as GetFriendsData).friends;
			var uids:Array = friends.source.map(
								function(friend:FacebookUser, index:int, ary:Array):String {
									return friend.uid;
								});
			var call:FacebookCall = facebook.post(
										new GetInfo(
												uids,
												[GetInfoFieldValues.ALL_VALUES]));
			event(call, FacebookEvent.COMPLETE, onGetInfoComplete);
		}
		
		private function onGetInfoComplete(evt:FacebookEvent):void {
			if (!evt.success) return;
			var userCollection:FacebookUserCollection =
					(evt.data as GetInfoData).userCollection;
			
			for (var i:int=0; i < userCollection.length; i++) {
				addFBookUserAndNoIdStatus(userCollection.getItemAt(i) as FacebookUser);
			}
			next(loadStatusIds);
		}
		
		private function loadStatusIds():void {
			if (!_fbookStatuses || fbookStatuses.length == 0) return;
			var cond:String =
					_fbookStatuses.map(
						function(s:FBookStatus, index:int, ary:Array):String {
							return StringUtil.substitute(
										"(uid={0} AND time={1})",
										s.userId,
										Math.round(s.time/1000));
						}).join(" OR ");
			var query:String = "SELECT status_id,uid,time FROM status WHERE " + cond;
			var call:FacebookCall = facebook.post(new FqlQuery(query));
			event(call, FacebookEvent.COMPLETE, onStatusIdComplete);
		}
		
		private function onStatusIdComplete(event:FacebookEvent):void {
			if (!event.success) return;
			/*
			statusTable =
			{
			  <uid>: {<time>: fbookStatus},
			  <uid>: {<time>: , <time>: }
			}
			*/
			var statusTable:Object = {};
			for each (var fbookStatus:FBookStatus in fbookStatuses) {
				if (!statusTable[fbookStatus.userId]) {
					statusTable[fbookStatus.userId] = {};
				}
				var timeKey:String = (fbookStatus.time/1000).toString();
				statusTable[fbookStatus.userId][timeKey] = fbookStatus;
			}
			
			var fb:Namespace = new Namespace("http://api.facebook.com/1.0/");
			var xml:XML = new XML((event.data as FacebookData).rawResult);
			for each (var x:XML in xml..fb::user_status) {
				var sid:String = x.fb::status_id;
				var uid:String = x.fb::uid;
				var time:String = x.fb::time;
				var msg:String = x.fb::message;
				if (sid && uid && time) {
					FBookStatus(statusTable[uid][time]).id = sid;
				}
			}
		}
		
		private function addFBookUserAndNoIdStatus(facebookUser:FacebookUser):void {
			if (!facebookUser) return;
			_fbookUsers.push(
					new FBookUser(
							facebookUser.uid,
							facebookUser.name,
							facebookUser.profile_url,
							facebookUser.pic_square,
							facebookUser.pic,
							facebookUser.pic_big,
							facebookUser.pic_small));
			if (facebookUser.status && facebookUser.status.message) {
				_fbookStatuses.push(
						new FBookStatus(
								null,
								facebookUser.uid,
								facebookUser.status.message,
								facebookUser.status.time.getTime()));
			}
		}
		
		public function get fbookUsers():Array {
			return _fbookUsers;
		}
		
		public function get fbookStatuses():Array {
			return _fbookStatuses;
		}
		
		protected override function finalize():void {
			trace(this.className + ": Finish");
		}
	}
}