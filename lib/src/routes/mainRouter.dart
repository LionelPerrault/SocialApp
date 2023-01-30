import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/views/events/eventsscreen.dart';
import 'package:shnatter/src/views/events/panel/eventView/eventscreen.dart';
import 'package:shnatter/src/views/groups/groupsscreen.dart';
import 'package:shnatter/src/views/groups/panel/groupView/groupscreen.dart';
import 'package:shnatter/src/views/homescreen.dart';
import 'package:shnatter/src/views/marketPlace/marketPlaceScreen.dart';
import 'package:shnatter/src/views/messageBoard/messageScreen.dart';
import 'package:shnatter/src/views/people/peoplescreen.dart';
import 'package:shnatter/src/views/products/panel/productView/productscreen.dart';
import 'package:shnatter/src/views/products/productsScreen.dart';
import 'package:shnatter/src/views/profile/profilescreen.dart';
import 'package:shnatter/src/views/setting/settingsMain.dart';

class MainRouter {
  MainRouter(String mainRouterValue);
  static mainRouter(mainRouterValue, routerChange) {
    switch (mainRouterValue['router']) {
      case RouteNames.profile:
        return UserProfileScreen(
            userName: mainRouterValue['subRouter'], routerChange: routerChange);
      case RouteNames.homePage:
        return HomeScreen(routerChange: routerChange);
      case RouteNames.messages:
        return MessageScreen(routerChange: routerChange);
      case RouteNames.settings:
        return SettingMainScreen(
            settingRouter: mainRouterValue, routerChange: routerChange);
      case RouteNames.people:
        return PeopleScreen(routerChange: routerChange);
      case RouteNames.events:
        if (mainRouterValue['subRouter'] != null &&
            mainRouterValue['subRouter'] != '') {
          return EventEachScreen(
              docId: mainRouterValue['subRouter'], routerChange: routerChange);
        } else {
          return EventsScreen(routerChange: routerChange);
        }
      case RouteNames.products:
        if (mainRouterValue['subRouter'] != null &&
            mainRouterValue['subRouter'] != '') {
          return ProductEachScreen(
              docId: mainRouterValue['subRouter'], routerChange: routerChange);
        } else {
          return ProductsScreen(routerChange: routerChange);
        }
      case RouteNames.groups:
        if (mainRouterValue['subRouter'] != null &&
            mainRouterValue['subRouter'] != '') {
          return GroupEachScreen(
              docId: mainRouterValue['subRouter'], routerChange: routerChange);
        } else {
          return GroupsScreen(routerChange: routerChange);
        }
      case RouteNames.market:
        return MarketPlaceScreen(routerChange: routerChange);
    }
  }
}