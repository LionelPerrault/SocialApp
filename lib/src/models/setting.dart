import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Setting {
  late String appName = ' ';
  late String mainColor;
  late String mainDarkColor;
  late String secondColor;
  late String secondDarkColor;
  late String accentColor;
  late String accentDarkColor;
  late String scaffoldDarkColor;
  late String scaffoldColor;
  late Locale language = const Locale('en', '');
  late String appVersion;
  late bool enableVersion = true;
  late bool isBright = false;
  ValueNotifier<Brightness> brightness = ValueNotifier(Brightness.light);

  Setting();

  Setting.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      appName = jsonMap['app_name'];
      mainColor = jsonMap['main_color'];
      mainDarkColor = jsonMap['main_dark_color'] ?? '';
      secondColor = jsonMap['second_color'] ?? '';
      secondDarkColor = jsonMap['second_dark_color'] ?? '';
      accentColor = jsonMap['accent_color'] ?? '';
      accentDarkColor = jsonMap['accent_dark_color'] ?? '';
      scaffoldDarkColor = jsonMap['scaffold_dark_color'] ?? '';
      scaffoldColor = jsonMap['scaffold_color'] ?? '';
      appVersion = jsonMap['app_version'] ?? '';
      enableVersion =
          jsonMap['enable_version'] == null || jsonMap['enable_version'] == '0'
              ? false
              : true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
  Map toMap() {
    var map = <String, dynamic>{};
    map["app_name"] = appName;
    map["mobile_language"] = language.languageCode;
    return map;
  }
}
