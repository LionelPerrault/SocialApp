import '../helpers/helper.dart';
import '../models/media.dart';

enum UserState { available, away, busy }

class User {
  String id = '';
  String email = '';
  String password = '';
  String authKey = '';
  String balance = '';
  String payID = '';
  Media image = new Media(url: 'test');
  // used for indicate if client logged in or not
  bool auth = false;


  User();

  User.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      email = jsonMap['email'] != null ? jsonMap['email'] : '';
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
          : new Media(url: '');
    } catch (e) {
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["email"] = email;
    map["password"] = password;
    return map;
  }

  Map toRestrictMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["email"] = email;
    return map;
  }

  @override
  String toString() {
    var map = this.toMap();
    map["auth"] = this.auth;
    return map.toString();
  }

}
