import 'package:flutter/material.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/views/emailverification.dart';
import 'package:shnatter/src/views/mainScreen.dart';
import 'package:shnatter/src/views/privacy.dart';
import 'package:shnatter/src/views/registerscreen.dart';
import 'package:shnatter/src/views/loginscreen.dart';
import 'package:shnatter/src/views/resetPasswordCallback.dart';
import 'package:shnatter/src/views/resetpassword.dart';
import 'package:shnatter/src/views/admin/adminscreen.dart';
import 'package:shnatter/src/views/startedscreen.dart';
import 'package:shnatter/src/views/terms.dart';

import '../managers/user_manager.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var url = settings.name.toString();
    if (url.contains("auth?")) {
      //fetch params;
      Uri uri = Uri.parse(url);
      String mode = uri.queryParameters['mode'] as String;
      if (mode == 'resetPassword') {
        String oobCode = uri.queryParameters['oobCode'] as String;
        String apiKey = uri.queryParameters['apiKey'] as String;
        return MaterialPageRoute(
            builder: (context) => ResetPasswordCallbackScreen(
                  GlobalKey<ScaffoldState>(),
                  oobCode: oobCode,
                  apiKey: apiKey,
                ),
            settings: settings);
      }
      if (mode == 'verifyEmail') {
        Uri uri = Uri.parse(url);
        String oobCode = uri.queryParameters['oobCode'] as String;
        String apiKey = uri.queryParameters['apiKey'] as String;
        String continueUrl = uri.queryParameters['continueUrl'] as String;
        return MaterialPageRoute(
            builder: (context) => EmailVerificationScreen(
                  GlobalKey<ScaffoldState>(),
                  oobCode: oobCode,
                  apiKey: apiKey,
                  continueUrl: continueUrl,
                ),
            settings: settings);
      }
    }
    if (UserManager.isLogined == true) {
      if (!UserManager.userInfo['isStarted']) {
        url = RouteNames.started;
      } else if (url == '/login' || url == '/register' || url == '/reset') {
        url = RouteNames.homePage;
      }
    } else {
      if (url != '/register' && url != '/login' && url != '/reset') {
        url = RouteNames.login;
      }
    }

    switch (url) {
      case '':
        return MaterialPageRoute(
            builder: (context) => MainScreen(), settings: settings);
      case RouteNames.homePage:
        return MaterialPageRoute(
            builder: (context) => MainScreen(), settings: settings);
      case RouteNames.reset:
        return MaterialPageRoute(
            builder: (context) => ResetScreen(), settings: settings);
      case RouteNames.register:
        return MaterialPageRoute(
            builder: (context) => RegisterScreen(), settings: settings);
      case RouteNames.login:
        return MaterialPageRoute(
            builder: (context) => LoginScreen(), settings: settings);
      case RouteNames.started:
        return MaterialPageRoute(
            builder: (context) => StartedScreen(), settings: settings);
      case RouteNames.privacy:
        return MaterialPageRoute(
            builder: (context) => const PrivacyScreen(), settings: settings);
      case RouteNames.terms:
        return MaterialPageRoute(
            builder: (context) => const TermsScreen(), settings: settings);

      //admin routes generators
      case RouteNames.adp:
        if (UserManager.userInfo['admin'] == 'admin') {
          Helper.showToast("ok you are admin");
          return MaterialPageRoute(
              builder: (context) => const AdminScreen(), settings: settings);
        } else {
          Helper.showToast('you don\'t have permission to access this page');
          return MaterialPageRoute(
              builder: (context) => MainScreen(), settings: settings);
        }

      default:
        return MaterialPageRoute(
            builder: (context) => MainScreen(), settings: settings);
    }
  }
}
