import 'package:flutter/material.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/views/panel/leftPanel/mainLeftPanel.dart';
import 'package:shnatter/src/views/panel/leftPanel/settngLeftPanel.dart';

class LeftPanel extends StatelessWidget {
  LeftPanel(
      {super.key,
      required this.routerFunction,
      required this.router,
      required this.removeLeftPanel});
  Function routerFunction;
  Function removeLeftPanel;
  Map router;
  @override
  Widget build(BuildContext context) {
    switch (router['router']) {
      case RouteNames.settings:
        return SettingsLeftPanel(
            routerFunction: routerFunction, removeLeftPanel: removeLeftPanel);
      default:
        return MainLeftPanel(routerFunction: routerFunction);
    }
  }
}
