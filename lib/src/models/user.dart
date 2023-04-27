import '../models/media.dart';

enum UserState { available, away, busy }

class User {
  String id = '';
  String email = '';
  String password = '';
  String authKey = '';
  String balance = '';
  String payID = '';
  Media image = Media(url: 'test');
  // used for indicate if client logged in or not
  bool auth = false;

  User();

  User.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      email = jsonMap['email'] ?? '';
      password = jsonMap['pasword'] != null ? jsonMap['password'] : '';
      authKey = jsonMap['authKey'];
      balance = jsonMap['balance'];
      payID = jsonMap['payID'];

      //try {
      //phone = jsonMap['custom_fields']['phone']['view'];
      //} catch (e) {
      //phone = "";
      //}
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : Media(url: '');
    } catch (e) {}
  }

  Map toMap() {
    var map = Map<String, dynamic>();
    map["id"] = id;
    map["email"] = email;
    map["password"] = password;
    return map;
  }

  Map toRestrictMap() {
    var map = Map<String, dynamic>();
    map["id"] = id;
    map["email"] = email;
    return map;
  }

  @override
  String toString() {
    var map = toMap();
    map["auth"] = auth;
    return map.toString();
  }
}
