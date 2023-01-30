import 'package:flutter/material.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/views/events/eventsscreen.dart';
import 'package:shnatter/src/views/events/panel/eventView/eventscreen.dart';
import 'package:shnatter/src/views/groups/groupsscreen.dart';
import 'package:shnatter/src/views/groups/panel/groupView/groupscreen.dart';
import 'package:shnatter/src/views/mainScreen.dart';
import 'package:shnatter/src/views/marketPlace/marketPlaceScreen.dart';
import 'package:shnatter/src/views/messageBoard/messageScreen.dart';
import 'package:shnatter/src/views/pages/pagesscreen.dart';
import 'package:shnatter/src/views/pages/panel/pageView/pagescreen.dart';
import 'package:shnatter/src/views/people/peoplescreen.dart';
import 'package:shnatter/src/views/products/panel/productView/productscreen.dart';
import 'package:shnatter/src/views/products/productsScreen.dart';
import 'package:shnatter/src/views/registerscreen.dart';
import 'package:shnatter/src/views/loginscreen.dart';
import 'package:shnatter/src/views/resetpassword.dart';
import 'package:shnatter/src/views/admin/adminscreen.dart';
import 'package:shnatter/src/views/startedscreen.dart';

import '../managers/user_manager.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    var url = settings.name.toString();
    if (UserManager.isLogined == true) {
      if (!UserManager.userInfo['isStarted']) {
        url = RouteNames.started;
      } else if (url == '/login' || url == '/register' || url != '/reset') {
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

      //admin routes generators
      case RouteNames.adp:
        if (UserManager.userInfo['admin'] == 'admin') {
          Helper.showToast("ok you are admin");
          return MaterialPageRoute(
              builder: (context) => AdminScreen(), settings: settings);
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
