import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/setting.dart';

class Helper {
  static ValueNotifier<Setting> setting = ValueNotifier(Setting());
  //BuildContext context;
  // for mapping data retrieved form json array
  static bool isUuid(String input) {
    return RegExp(
            "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}")
        .hasMatch(input);
  }
  static const String tokenName = "JB-Token";
  static const String tokenIcon = "assets/images/jb.jpg";
  static showToast(String message) {
     Fluttertoast.showToast(
                  msg: message,
                  backgroundColor: Colors.black,
                  toastLength: Toast.LENGTH_LONG,
                  timeInSecForIosWeb: 2,
                  gravity: ToastGravity.CENTER);
  }

  static saveJSONPreference(String field,Map<String,String> data) async
  {
    final prefs = await SharedPreferences.getInstance();
    String saveData  = jsonEncode(data);
    prefs.setString(field, saveData);
  }
  static Future<Map> getJSONPreference(String field) async 
  {
    final prefs = await SharedPreferences.getInstance();
    String k = '{}';
    k = prefs.getString(field)!;
    return jsonDecode(k);
  }  
}
