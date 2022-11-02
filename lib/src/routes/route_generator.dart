import 'dart:js';

import 'package:flutter/material.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/views/homescreen.dart';
import 'package:shnatter/src/views/privacy.dart';
import 'package:shnatter/src/views/registerscreen.dart';
import 'package:shnatter/src/views/terms.dart';
import 'package:shnatter/src/views/loginscreen.dart';
import 'package:shnatter/src/views/resetpassword.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case RouteNames.splashScreen:
        return MaterialPageRoute(
            builder: (context) => HomeScreen(), settings: settings);
      case '':
        return MaterialPageRoute(
            builder: (context) => HomeScreen(), settings: settings);
      case RouteNames.homePage:
        return MaterialPageRoute(builder: 
          (context) => HomeScreen()
        );
      case RouteNames.reset:
        return MaterialPageRoute(builder: 
          (context) => ResetScreen()
        );
      case RouteNames.register:
        return MaterialPageRoute(
            builder: (context) => RegisterScreen(), settings: settings);
      case RouteNames.terms:
        return MaterialPageRoute(
            builder: (context) => TermsScreen(), settings: settings);
      case RouteNames.privacy:
        return MaterialPageRoute(
            builder: (context) => PrivacyScreen(), settings: settings);
      case RouteNames.login:
        return MaterialPageRoute(
            builder: (context) => LoginScreen(), settings: settings);
      default:
        return MaterialPageRoute(
            builder: (context) => HomeScreen(), settings: settings);
    }
  }
}
