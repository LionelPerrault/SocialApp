import 'dart:js';

import 'package:flutter/material.dart';
import 'package:my_app/src/routes/route_names.dart';
import 'package:my_app/src/views/homescreen.dart';
import 'package:my_app/src/views/qrscanscreen.dart';

class RouteGenerator {
  
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case RouteNames.splashScreen:
        return MaterialPageRoute(builder: 
          (context) => HomeScreen()
        );
      case '':
        return MaterialPageRoute(builder: 
          (context) => HomeScreen()
        );
      case RouteNames.homePage:
        return MaterialPageRoute(builder: 
          (context) => HomeScreen()
        );
      case RouteNames.qrCodeScan:
        return MaterialPageRoute(builder: 
          (context) => QrCodeScan()
        );
      default:
         return MaterialPageRoute(builder: 
          (context) => HomeScreen()
        );
    }   
  }
}