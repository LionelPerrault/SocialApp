import 'dart:js';

import 'package:flutter/material.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/views/homescreen.dart';
import 'package:shnatter/src/views/loginscreen.dart';
import 'package:shnatter/src/views/resetpassword.dart';

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
      case RouteNames.reset:
        return MaterialPageRoute(builder: 
          (context) => ResetScreen()
        );
      default:
         return MaterialPageRoute(builder: 
          (context) => LoginScreen()
        );
    }   
  }
}