import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shnatter/src/helpers/helper.dart';

class Friends {
  Friends();
  var friends = [];
  // get my  friends in collection
  Future<List> getFriends(name) async {
    var snapshot = await FirebaseFirestore.instance
        .collection(Helper.friendCollection)
        .where('state', isEqualTo: 1)
        .where('users.' + name, isEqualTo: true)
        .get();
    var s = [];
    s = snapshot.docs.map((doc) => doc.data()).toList();
    friends = s;
    return friends;
  }
}
