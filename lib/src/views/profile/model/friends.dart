import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';

class Friends {
  Friends();
  var friends = [];
  // get my  friends in collection
  Future<List> getFriends(uid) async {
    var snapshot = await FirebaseFirestore.instance
        .collection(Helper.friendCollection)
        .where('state', isEqualTo: true)
        .where('users', arrayContains: uid)
        .get();
    var box = [];
    Map cell;
    for (var element in snapshot.docs) {
      var friendUid = element.data()['requester'] == uid
          ? element.data()['receiver']
          : element.data()['requester'];
      cell = Helper.userUidToInfo[friendUid] ?? {};
      cell['uid'] = friendUid;
      if (cell != {}) box.add(cell);
    }
    friends = box;
    return friends;
  }
}
