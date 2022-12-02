import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/setting.dart';
import 'package:crypto/crypto.dart';

import '../models/userModel.dart';

class Helper {
  static ValueNotifier<Setting> setting = ValueNotifier(Setting());
  //BuildContext context;
  // for mapping data retrieved form json array
  static var authdata = FirebaseFirestore.instance
      .collection(Helper.userField)
      .withConverter<TokenLogin>(
        fromFirestore: (snapshots, _) => TokenLogin.fromJSON(snapshots.data()!),
        toFirestore: (tokenlogin, _) => tokenlogin.toMap(),
      );
  static var eventsData = FirebaseFirestore.instance
      .collection(Helper.eventsField)
      .withConverter<TokenLogin>(
        fromFirestore: (snapshots, _) => TokenLogin.fromJSON(snapshots.data()!),
        toFirestore: (tokenlogin, _) => tokenlogin.toMap(),
      );
  static var pagesData = FirebaseFirestore.instance
      .collection(Helper.pagesField)
      .withConverter<TokenLogin>(
        fromFirestore: (snapshots, _) => TokenLogin.fromJSON(snapshots.data()!),
        toFirestore: (tokenlogin, _) => tokenlogin.toMap(),
      );
  static var groupsData = FirebaseFirestore.instance
      .collection(Helper.groupsField)
      .withConverter<TokenLogin>(
        fromFirestore: (snapshots, _) => TokenLogin.fromJSON(snapshots.data()!),
        toFirestore: (tokenlogin, _) => tokenlogin.toMap(),
      );
  static var allInterests = FirebaseFirestore.instance
      .collection(Helper.interestsField)
      .withConverter<TokenLogin>(
        fromFirestore: (snapshots, _) => TokenLogin.fromJSON(snapshots.data()!),
        toFirestore: (tokenlogin, _) => tokenlogin.toMap(),
      );
  static var avatar =
      'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fprofile%2Fblank_profile_male.svg?alt=media&token=eaf0c1c7-5a30-4771-a7b8-9dc312eafe82';
  static var userField = 'user';
  static var eventsField = 'events';
  static var pagesField = 'pages';
  static var groupsField = 'groups';
  static var interestsField = 'interests';
  static var friendField = 'friends';
  static var balance = 0;
  static var message = 'messages';
  static var newMessageSearch = 'userName';
  static var emoticons = 'emoticons';
  static var passwordMinLength = 9;
  static var emptySVG =
      'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fnodaa.svg?alt=media&token=ebfb99db-2cf6-4dd4-ba96-2ca150ba1352';
  static bool isUuid(String input) {
    return RegExp(
            "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}")
        .hasMatch(input);
  }

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

  static saveJSONPreference(String field, Map<String, String> data) async {
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
}
