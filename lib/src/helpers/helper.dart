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
          fromFirestore: (snapshots, _) =>
              TokenLogin.fromJSON(snapshots.data()!),
          toFirestore: (tokenlogin, _) => tokenlogin.toMap(),
        );
  static var userField = 'user';
  static var balance = 0;
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

  static showAlert(String message) {
    Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
    );
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
