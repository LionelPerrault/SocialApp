import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/helper.dart';

class UserManager {
  static var resToken = {};
  static var userInfo = {};
  static bool isLogined = false;

  static Future<void> getUserInfo() async {
    //await removeAllPreference();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString(Helper.userField);
    if (user == null) {
      isLogined = false;
    } else {
      userInfo = await Helper.getJSONPreference(Helper.userField);
      isLogined = true;
      // RouteNames.userName = '/${userInfo['userName']}';
      print(userInfo);
    }
  }
}
