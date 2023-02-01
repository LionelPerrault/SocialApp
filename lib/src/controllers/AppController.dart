import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
    FirebaseMessaging _firebaseMessaging =
        FirebaseMessaging.instance; // Change here
    if (kIsWeb) {
      String vapidKey = "";
      vapidKey =
          'BMW9GhZJ-RnM9leBak5sKH7EWc_WVgHyGgK2BCt0rm7Gv3SqTZ570eUhSi-og1kQ0XOEOuSd9R8Uleglxr_b4ds';
      FirebaseMessaging.instance.getToken(vapidKey: vapidKey).then((token) {
        //save to firebase
        saveToken(token, "web");
      }).onError((error, stackTrace) => null);
    } else {
      await _firebaseMessaging.requestPermission();
      _firebaseMessaging.getToken().then((token) {
        //save to firebase
        saveToken(token, "mobile");
      }).onError((error, stackTrace) => null);
    }
    //final fcmToken = await FirebaseMessaging.instance
    //    .getToken(vapidKey: "JQK8sPGz8ACuFBQdET1323FwvXlLWEC7E6dlaIzzdWU");
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      // delete old one and add new
      if (kIsWeb)
        saveToken(fcmToken, "web");
      else
        saveToken(fcmToken, "moible");
    }).onError((err) {
      // Error getting token.
    });
    getUserInfo();

    return true;
  }

  void saveToken(token, device) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("fcmtoken", token);
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("FCMToken")
        .where('token', isEqualTo: token)
        .get();
    if (snapshot.docs.isEmpty)
      FirebaseFirestore.instance.collection("FCMToken").add({
        'token': token,
        'device': device,
        'createdAt': FieldValue.serverTimestamp()
      });
  }

  @override
  bool onAsyncError(FlutterErrorDetails details) {
    return false;
  }

  Future<void> getUserInfo() async {
    await UserManager.getUserInfo();
    if (UserManager.userInfo['userName'] != null) {
      var userInfo = UserManager.userInfo;
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userInfo['email'], password: userInfo['password']);
      Helper.connectOnlineDatabase();
    }
  }
}
