import 'package:shnatter/src/helpers/helper.dart';

List<T> flatten<T>(List<dynamic> list) =>
    [for (var sublist in list) ...sublist];

class Photos {
  Photos();
  var photos = [];
  var albums = [];
  // get my  friends in collection
  Future<void> getPhotos(uid) async {
    var snapshot = await Helper.postCollection
        .where('type', isEqualTo: 'photo')
        .where('postAdmin', isEqualTo: uid)
        .orderBy('postTime', descending: true)
        .get();
    var s = [];
    s = snapshot.docs.map((doc) => doc.data()['value']['photo']).toList();

    photos = flatten(s);

    albums = s;
  }

  Future<void> getPhotosOfEvent(eventId) async {
    var snapshot = await Helper.postCollection
        .where('type', isEqualTo: 'photo')
        .where('eventId', isEqualTo: eventId)
        .orderBy('postTime', descending: true)
        .get();
    var s = [];
    s = snapshot.docs.map((doc) => doc.data()['value']['photo']).toList();

    photos = flatten(s);

    albums = s;
  }

  Future<void> getPhotosOfGroup(groupId) async {
    var snapshot = await Helper.postCollection
        .where('type', isEqualTo: 'photo')
        .where('groupId', isEqualTo: groupId)
        .orderBy('postTime', descending: true)
        .get();
    var s = [];
    s = snapshot.docs.map((doc) => doc.data()['value']['photo']).toList();

    photos = flatten(s);

    albums = s;
  }
}
