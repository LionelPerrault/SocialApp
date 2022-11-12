import 'dart:js';

import 'package:flutter/material.dart';
import 'package:shnatter/src/controllers/AppController.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/views/homescreen.dart';
import 'package:shnatter/src/views/privacy.dart';
import 'package:shnatter/src/views/registerscreen.dart';
import 'package:shnatter/src/views/setting/settings_account.dart';
import 'package:shnatter/src/views/setting/settings_profile_basic.dart';
import 'package:shnatter/src/views/setting/settings_profile_design.dart';
import 'package:shnatter/src/views/setting/settings_profile_education.dart';
import 'package:shnatter/src/views/setting/settings_profile_location.dart';
import 'package:shnatter/src/views/setting/settings_profile_social.dart';
import 'package:shnatter/src/views/setting/settings_profile_work.dart';
import 'package:shnatter/src/views/setting/settings_security_password.dart';
import 'package:shnatter/src/views/setting/settings_security_sessions.dart';
import 'package:shnatter/src/views/terms.dart';
import 'package:shnatter/src/views/loginscreen.dart';
import 'package:shnatter/src/views/resetpassword.dart';
import 'package:shnatter/src/views/admin/adminscreen.dart';
import 'package:shnatter/src/views/startedscreen.dart';
import 'package:shnatter/src/views/startedscreen.dart';

import '../managers/user_manager.dart';

class RouteGenerator {
  static Future<void> checkRoute(RouteSettings settings) async {
    generateRoute(settings);
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    var url = settings.name;
    bool islogined = UserManager.isLogined;
    print(islogined);
    if (islogined == true) {
      if (url == '/login' || url == '/register') {
        url = RouteNames.homePage;
      }
    } else {
      if (url != '/register' && url != '/login' && url != '/reset') {
        url = RouteNames.login;
      }
    }
    switch (url) {
      case RouteNames.splashScreen:
        return MaterialPageRoute(
            builder: (context) => HomeScreen(), settings: settings);
      case '':
        return MaterialPageRoute(
            builder: (context) => HomeScreen(), settings: settings);
      case RouteNames.homePage:
        return MaterialPageRoute(
            builder: (context) => HomeScreen(), settings: settings);
      case RouteNames.reset:
        return MaterialPageRoute(
            builder: (context) => ResetScreen(), settings: settings);
      case RouteNames.register:
        return MaterialPageRoute(
            builder: (context) => RegisterScreen(), settings: settings);
      case RouteNames.terms:
        return MaterialPageRoute(
            builder: (context) => TermsScreen(), settings: settings);
      case RouteNames.privacy:
        return MaterialPageRoute(
            builder: (context) => const PrivacyScreen(), settings: settings);
      case RouteNames.login:
        return MaterialPageRoute(
            builder: (context) => LoginScreen(), settings: settings);
      case RouteNames.adp:
        Helper.showToast("ok now to admin");
        return MaterialPageRoute(
            builder: (context) => AdminScreen(), settings: settings);
      case RouteNames.started:
        return MaterialPageRoute(
            builder: (context) => StartedScreen(), settings: settings);
      case RouteNames.settings:
        return MaterialPageRoute(
            builder: (context) => SettingsAccount(), settings: settings);
      case RouteNames.settings_profile_basic:
        return MaterialPageRoute(
            builder: (context) => SettingsProfileBasic(), settings: settings);
      case RouteNames.settings_profile_work:
        return MaterialPageRoute(
            builder: (context) => SettingsProfileWork(), settings: settings);
      case RouteNames.settings_profile_location:
        return MaterialPageRoute(
            builder: (context) => SettingsProfileLocation(), settings: settings);
      case RouteNames.settings_profile_education:
        return MaterialPageRoute(
            builder: (context) => SettingsProfileEducation(), settings: settings);
      case RouteNames.settings_profile_social:
        return MaterialPageRoute(
            builder: (context) => SettingsProfileSocial(), settings: settings);
      case RouteNames.settings_profile_interests:
        return MaterialPageRoute(
            builder: (context) => SettingsAccount(), settings: settings);
      case RouteNames.settings_profile_design:
        return MaterialPageRoute(
            builder: (context) => SettingsProfileDesign(), settings: settings);
      case RouteNames.security_password:
        return MaterialPageRoute(
            builder: (context) => SettingsSecurityPassword(), settings: settings);
      case RouteNames.security_sessions:
        return MaterialPageRoute(
            builder: (context) => SettingsSecuritySessions(), settings: settings);

      default:
        return MaterialPageRoute(
            builder: (context) => HomeScreen(), settings: settings);
    }
  }
}
