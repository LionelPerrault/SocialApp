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
import '../views/profile/profilescreen.dart';
import '../views/setting/settingsMain.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    var url = settings.name.toString();
    bool islogined = UserManager.isLogined;
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
        Helper.showToast("ok now to admin");
        return MaterialPageRoute(
            builder: (context) => AdminScreen(), settings: settings);
      default:
        return MaterialPageRoute(
            builder: (context) => MainScreen(), settings: settings);
    }
  }
}
