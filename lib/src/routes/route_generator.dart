import 'dart:js';

import 'package:flutter/material.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/views/homescreen.dart';
import 'package:shnatter/src/views/qrscanscreen.dart';
import 'package:shnatter/src/views/registerscreen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case RouteNames.splashScreen:
        return MaterialPageRoute(builder: (context) => HomeScreen());
      case '':
        return MaterialPageRoute(builder: (context) => HomeScreen());
      case RouteNames.homePage:
        return MaterialPageRoute(builder: (context) => HomeScreen());
      case RouteNames.qrCodeScan:
        return MaterialPageRoute(builder: (context) => QrCodeScan());
      case RouteNames.register:
        return MaterialPageRoute(builder: (context) => RegisterScreen());
      default:
        return MaterialPageRoute(builder: (context) => HomeScreen());
    }
  }
}
