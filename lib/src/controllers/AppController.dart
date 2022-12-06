import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import '../../firebase_options.dart';
import '../helpers/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/userModel.dart';

class AppController extends ControllerMVC {
  factory AppController() => _this ??= AppController._();
  AppController._();
  static AppController? _this;
  var isLogined = false;
  get SharedPreferences => null;

  @override
  Future<bool> initAsync() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    getUserInfo();

    return true;
  }

  @override
  bool onAsyncError(FlutterErrorDetails details) {
    return false;
  }

  Future<void> getUserInfo() async {
    await UserManager.getUserInfo();
    if (UserManager.userInfo['userName'] != null) {
      Helper.connectOnlineDatabase();
    }
  }
}
