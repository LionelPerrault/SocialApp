import 'package:flutter/material.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/views/events/eventsscreen.dart';
import 'package:shnatter/src/views/events/panel/eventView/eventscreen.dart';
import 'package:shnatter/src/views/groups/groupsscreen.dart';
import 'package:shnatter/src/views/groups/panel/groupView/groupscreen.dart';
import 'package:shnatter/src/views/homescreen.dart';
import 'package:shnatter/src/views/pages/pagesscreen.dart';
import 'package:shnatter/src/views/pages/panel/pageView/pagescreen.dart';
import 'package:shnatter/src/views/people/peoplescreen.dart';
import 'package:shnatter/src/views/privacy.dart';
import 'package:shnatter/src/views/registerscreen.dart';
import 'package:shnatter/src/views/terms.dart';
import 'package:shnatter/src/views/loginscreen.dart';
import 'package:shnatter/src/views/resetpassword.dart';
import 'package:shnatter/src/views/admin/adminscreen.dart';
import 'package:shnatter/src/views/startedscreen.dart';

import '../managers/user_manager.dart';
import '../views/profile/profilescreen.dart';
import '../views/setting/settings_main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    var url = settings.name;
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
    if (url == RouteNames.userName) {
      return MaterialPageRoute(
          builder: (context) => UserProfileScreen(), settings: settings);
    }
    if (url!.split('/')[1] == RouteNames.eventsName &&
        url.split('/').length > 2) {
      return MaterialPageRoute(
          builder: (context) =>
              EventEachScreen(docId: settings.name.toString()),
          settings: settings);
    }
    if (url.split('/')[1] == RouteNames.pagesName &&
        url.split('/').length > 2) {
      return MaterialPageRoute(
          builder: (context) => PageEachScreen(docId: settings.name.toString()),
          settings: settings);
    }
    if (url.split('/')[1] == RouteNames.groupsName &&
        url.split('/').length > 2) {
      return MaterialPageRoute(
          builder: (context) =>
              GroupEachScreen(docId: settings.name.toString()),
          settings: settings);
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
      case RouteNames.started:
        return MaterialPageRoute(
            builder: (context) => StartedScreen(), settings: settings);

      //settings route generators
      case RouteNames.settings:
        return MaterialPageRoute(
            builder: (context) => SettingMainScreen(), settings: settings);
      //event route generators
      case RouteNames.events:
        return MaterialPageRoute(
            builder: (context) => EventsScreen(), settings: settings);

      //page route generators
      case RouteNames.pages:
        return MaterialPageRoute(
            builder: (context) => PagesScreen(), settings: settings);

      //groups route generators
      case RouteNames.groups:
        return MaterialPageRoute(
            builder: (context) => GroupsScreen(), settings: settings);

      //admin routes generators
      case RouteNames.adp:
        Helper.showToast("ok now to admin");
        return MaterialPageRoute(
            builder: (context) => AdminScreen(), settings: settings);
      case RouteNames.people:
        Helper.showToast("ok now to admin");
        return MaterialPageRoute(
            builder: (context) => PeopleScreen(), settings: settings);
      default:
        return MaterialPageRoute(
            builder: (context) => HomeScreen(), settings: settings);
    }
  }
}
