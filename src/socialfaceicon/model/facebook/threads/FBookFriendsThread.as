package socialfaceicon.model.facebook.threads
{
	import com.facebook.Facebook;
	import com.facebook.commands.friends.GetFriends;
	import com.facebook.commands.users.GetInfo;
	import com.facebook.data.friends.GetFriendsData;
	import com.facebook.data.users.FacebookUser;
	import com.facebook.data.users.FacebookUserCollection;
	import com.facebook.data.users.GetInfoData;
	import com.facebook.data.users.GetInfoFieldValues;
	import com.facebook.events.FacebookEvent;
	import com.facebook.net.FacebookCall;
	
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
				addFBookUser(userCollection.getItemAt(i) as FacebookUser);
			}
		}
		
		private function addFBookUser(facebookUser:FacebookUser):void {
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
			trace("FBookFriendsThread: Finish");
		}
	}
}