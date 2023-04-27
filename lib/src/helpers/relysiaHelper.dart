import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/setting.dart';
import 'package:http/http.dart' as http;

enum Environment { dev, prod }

class RelysiaHelper {
  static ValueNotifier<Setting> setting = ValueNotifier(Setting());
  //BuildContext context;
  // for mapping data retrieved form json array
  static bool isUuid(String input) {
    return RegExp(
            "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}")
        .hasMatch(input);
  }

  static Environment environment = Environment.dev;
  static bool awardCreate = false;
  static const String tokenName = "JB-Token";
  static const String replace = '@poiintz.app';
  static const String userField = "User";
  static const String defaultClient = 'Client';
  static const String transactionField = 'Transaction';
  static const String titleField = 'title';
  static const String pages = 'Pages';
  static const String logo =
      'https://firebasestorage.googleapis.com/v0/b/poiintz.appspot.com/o/logo%2Ficons8-old-vmware-logo-480.png?alt=media&token=92fe707b-aae1-40c3-b4a4-c2b3548a9e93';
  static String tokenIcon = "";
  static String tokenId = "";
  static String admin = "admin";
  static int balance = 0;
  static var registration;
  static bool isPageShow = false;
  static var suburl = '';
  static var notVerifyMessage;
  static var apiKey = 'AIzaSyCKzSXeYBf3fTxeXaLluQE9qFytyWbYdq8';
  static var receiveTitle = '';
  static var currentSuburl = '';
  static var login;
  static var qrlanding;
  static var myToken = [];
  static var clientsData = [];
  static var authdata = null;
  static var carouselList = [];
  static var logoIcon = '';
  static var logoTitle = '';
  static var description = '';
  static var defaultDescription = '';
  static var tokenname = '';
  static var adminPaymail = '';
  static String docId = '';
  static var titleName = 'Sushi';
  static var firstConnect = false;
  static bool backQrCode = false;
  static var isShareLink = false;
  static List coupons = [];
  static var qrcodeTitle = '';
  static var adminDocId = [];
  static var privacy = 'Privacy';
  static var terms = 'Terms';
  static Color color = const Color.fromRGBO(68, 68, 68, 1);
  static showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: Colors.black,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 2,
        gravity: ToastGravity.CENTER);
  }

  static saveJSONPreference(String field, Map<String, String> data) async {
    final prefs = await SharedPreferences.getInstance();
    String saveData = jsonEncode(data);
    prefs.setString(field, saveData);
  }

  static Future<Map> getJSONPreference(String field) async {
    final prefs = await SharedPreferences.getInstance();
    String? k = '{}';
    k = prefs.getString(field);
    if (k == null) return {};
    return jsonDecode(k);
  }

  static Future<void> clientCarouselData(String router) async {
    for (var elem in clientsData) {
      if (elem['id'] == router) {
        var mapData = elem['data'];
        adminDocId = mapData['adminDocId'];
        carouselList = mapData['carousel'];
        logoIcon = mapData['logo']['icon'];
        logoTitle = mapData['logo']['title'];
        tokenId = mapData['token']['tokenId'];
        tokenIcon = mapData['token']['tokenIcon'];
        defaultDescription = mapData['busDescription'];
        tokenname = mapData['tokenName'];
        qrcodeTitle = mapData['qrcodeTitle'];
        isPageShow = true;
      }
    }
  }

  static translateLanguage(language) async {
    description = await translate(language, defaultDescription);
    var str = await translate(language, notVerifyMessage['title']);
    notVerifyMessage = {...notVerifyMessage, 'title': str};
    tokenname = await translate(language, tokenname);
    logoTitle = await translate(language, logoTitle);
    var arr = [];
    for (int i = 0; i < carouselList.length; i++) {
      str = await translate(language, carouselList[i]['text']);
      var j = {...carouselList[i], 'text': str};
      arr.add(j);
    }
    carouselList = arr;
  }

  static translate(language, value) async {
    var res = await http.get(Uri.parse(
        'https://translation.googleapis.com/language/translate/v2?target=$language&key=$apiKey&q=$value'));
    var data = jsonDecode(res.body);
    var str = data['data']['translations'][0]['translatedText'];
    return str;
  }

  static Future<String> getPrivacy() async {
    var str = await FirebaseFirestore.instance
        .collection(RelysiaHelper.pages)
        .doc(RelysiaHelper.privacy)
        .get();
    return str['content'] as String;
  }

  static Future<String> getTerms() async {
    var str = await FirebaseFirestore.instance
        .collection(RelysiaHelper.pages)
        .doc(RelysiaHelper.terms)
        .get();
    return str['content'] as String;
  }
}
