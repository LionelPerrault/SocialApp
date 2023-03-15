import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shnatter/src/helpers/helper.dart';

List<T> flatten<T>(List<dynamic> list) =>
    [for (var sublist in list) ...sublist];

class Photos {
  Photos() {}
  var photos = [];
  var albums = [];
  // get my  friends in collection
  Future<void> getPhotos(uid) async {
    var snapshot = await Helper.postCollection
        .where('type', isEqualTo: 'photo')
        .where('postAdmin', isEqualTo: uid)
        .get();
    var s = [];
    s = snapshot.docs.map((doc) => doc.data()['value']).toList();

    photos = flatten(s);
    print("photos---------------$photos");
    albums = s;
    print("albums---------------$albums");
  }

  Future<void> getPhotosOfEvent(eventId) async {
    var snapshot = await Helper.postCollection
        .where('type', isEqualTo: 'photo')
        .where('eventId', isEqualTo: eventId)
        .get();
    var s = [];
    s = snapshot.docs.map((doc) => doc.data()['value']).toList();

    photos = flatten(s);
    print("photos---------------$photos");
    albums = s;
    print("albums---------------$albums");
  }
}
