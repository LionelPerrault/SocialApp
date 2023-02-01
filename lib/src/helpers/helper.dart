import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import '../models/setting.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import '../models/userModel.dart';

class Helper {
  static var systemSnap =
      FirebaseFirestore.instance.collection(Helper.adminPanel);
  static ValueNotifier<Setting> setting = ValueNotifier(Setting());
  //BuildContext context;
  // for mapping data retrieved form json array
  static var authdata = FirebaseFirestore.instance
      .collection(Helper.userField)
      .withConverter<TokenLogin>(
        fromFirestore: (snapshots, _) => TokenLogin.fromJSON(snapshots.data()!),
        toFirestore: (tokenlogin, _) => tokenlogin.toMap(),
      );
  static var userCollection =
      FirebaseFirestore.instance.collection(Helper.userField);
  static var messageCollection =
      FirebaseFirestore.instance.collection(Helper.message);
  static var eventsData =
      FirebaseFirestore.instance.collection(Helper.eventsField);
  static var pagesData =
      FirebaseFirestore.instance.collection(Helper.pagesField);
  static var groupsData =
      FirebaseFirestore.instance.collection(Helper.groupsField);
  static var productsData =
      FirebaseFirestore.instance.collection(Helper.productsField);
  static var postLikeComment =
      FirebaseFirestore.instance.collection(Helper.postLikeCommentField);
  static var allInterests =
      FirebaseFirestore.instance.collection(Helper.interestsField);
  static var notifiCollection =
      FirebaseFirestore.instance.collection(Helper.notificationField);
  static var postCollection =
      FirebaseFirestore.instance.collection(Helper.postField);
  static var systemAvatar =
      'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsystem_avatar.svg?alt=media&token=1b903903-95d8-4826-808d-ddbde4ac55c3';
  static var avatar =
      'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fprofile%2Fblank_profile_male.svg?alt=media&token=eaf0c1c7-5a30-4771-a7b8-9dc312eafe82';
  static var pageAvatar =
      'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fblank_page.jpg?alt=media&token=404c2404-1b87-4760-b6e6-286462a9cd1a';
  static var groupImage =
      'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fblank_group.jpg?alt=media&token=92339ace-99df-41de-84c5-581260ffb6ec';
  static var eventImage =
      'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fblank_event.jpg?alt=media&token=aba15f40-0918-4ce8-965e-82f77ba34800';
  static var productImage =
      'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fblank_product.jpg?alt=media&token=0cd1281e-4dc7-4228-939f-f19b50c3afe1';
  static var adminPanel = 'adminPanel';
  static var adminConfig = 'config';
  static var timeNow = 'timeNow';
  static var userField = 'user';
  static var eventsField = 'events';
  static var pagesField = 'pages';
  static var groupsField = 'groups';
  static var productsField = 'products';
  static var notificationField = 'notifications';
  static var postField = 'posts';
  static var interestsField = 'interests';
  static var friendField = 'friends';
  static var pages = 'staticContent';
  static var terms = 'Terms';
  static var privacy = 'Privacy';
  static var about = 'About';
  static var balance = 0;
  static var message = 'messages';
  static var newMessageSearch = 'userName';
  static var apiKey = 'AIzaSyAtquiA4SXxBhs-lpAdk_xt3_dZtY4PId0';
  static var emoticons = 'emoticons';
  static var onlineStatusField = 'onlineStatus';
  static var postLikeCommentField = 'postLikeComment';
  static var passwordMinLength = 8;

  static var emptySVG =
      'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fnodaa.svg?alt=media&token=ebfb99db-2cf6-4dd4-ba96-2ca150ba1352';
  static var blankGroup =
      'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fblank_group.jpg?alt=media&token=89a979ed-f6ac-431b-bb04-012b4a944f7a';
  static var blankEvent =
      'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fblank_event.jpg?alt=media&token=aba15f40-0918-4ce8-965e-82f77ba34800';
  static var blankPage =
      'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fblank_page.jpg?alt=media&token=404c2404-1b87-4760-b6e6-286462a9cd1a';
  static bool isUuid(String input) {
    return RegExp(
            "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}")
        .hasMatch(input);
  }

  static Map notificationText = {
    'storys': {
      'text': 'added story',
    },
    'news': {
      'text': 'added news',
    },
    'products': {
      'text': 'added product',
    },
    'pages': {'text': 'added page'},
    'groups': {'text': 'added group'},
    'events': {'text': 'added event'},
    'requestFriend': {'text': 'Friend request sent'}
  };

  static Map notificationName = {
    'requestFriend': {'name': 'System Message'}
  };

  static showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: Colors.black,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 2,
        gravity: ToastGravity.CENTER);
  }

  static failAlert(String str) {
    return Container(
        padding:
            const EdgeInsets.only(left: 10.0, right: 10, top: 10, bottom: 10),
        decoration: const BoxDecoration(
            color: Color.fromRGBO(247, 86, 118, 1),
            borderRadius: BorderRadius.all(Radius.circular(3))),
        child: str == 'wrong-password'
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                    Text(
                      'please re-enter password',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      'The password you entered is incorrect. If you forgot your password? Request a new one',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ])
            : Text(
                str,
                style: TextStyle(color: Colors.white, fontSize: 11),
              ));
  }

  static Future<String> getStringPreference(String field) async {
    final prefs = await SharedPreferences.getInstance();
    String? rValue = "";
    rValue = prefs.getString(field);
    return rValue != null ? rValue : "";
  }

  static saveJSONPreference(String field, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    String saveData = jsonEncode(data);
    prefs.setString(field, saveData);
  }

  static Future<Map> getJSONPreference(String field) async {
    final prefs = await SharedPreferences.getInstance();
    String k = '{}';
    k = prefs.getString(field)!;
    return jsonDecode(k);
  }

  static String hashPassword(password) {
    var bytes = utf8.encode(password); // data being hashed
    var digest = sha256.convert(bytes).toString();
    return digest.toString();
  }

  static Future<void> removeAllPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(userField);
  }

  static connectOnlineDatabase() async {
    var snapshot = await FirebaseFirestore.instance
        .collection(onlineStatusField)
        .where('userName', isEqualTo: UserManager.userInfo['userName'])
        .get();
    if (snapshot.docs.isEmpty) {
      await FirebaseFirestore.instance
          .collection(onlineStatusField)
          .add({'userName': UserManager.userInfo['userName'], 'status': 1});
    } else {
      await FirebaseFirestore.instance
          .collection(onlineStatusField)
          .doc(snapshot.docs[0].id)
          .update({'status': 1});
    }
    final Stream<QuerySnapshot> stream =
        FirebaseFirestore.instance.collection(onlineStatusField).snapshots();
    stream.listen((event) {
      event.docs.forEach((e) {});
    });
  }

  static makeOffline() async {
    var userInfo = UserManager.userInfo;
    if (userInfo['userName'] != null) {
      print('offline');
      // HttpsCallable callable =
      //     FirebaseFunctions.instance.httpsCallable('offlineRequest');
      // var res = await callable
      //     .call(<String, dynamic>{'userName': userInfo['userName']});
      var data = {"userName": userInfo['userName']};
      http.post(
        Uri.parse(
            'https://us-central1-shnatter-a69cd.cloudfunctions.net/offlineRequest'),
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(<String, dynamic>{"data": data}),
      );
    }
  }

  static getUserAvatar(userName) async {
    var snapshot = await FirebaseFirestore.instance
        .collection(userField)
        .where('userName', isEqualTo: userName)
        .get();
    var avatar = snapshot.docs[0]['avatar'];
    return avatar;
  }

  static Future<String> getPrivacy() async {
    var str = await FirebaseFirestore.instance
        .collection(Helper.pages)
        .doc(Helper.privacy)
        .get();
    return str['content'] as String;
  }

  static Future<String> getTerms() async {
    var str = await FirebaseFirestore.instance
        .collection(Helper.pages)
        .doc(Helper.terms)
        .get();
    return str['content'] as String;
  }

  static Future<String> getAbout() async {
    var str = await FirebaseFirestore.instance
        .collection(Helper.pages)
        .doc(Helper.about)
        .get();
    return str['content'] as String;
  }
}
