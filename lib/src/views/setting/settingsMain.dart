// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/views/navigationbar.dart';
import 'package:shnatter/src/views/panel/leftPanel/settngLeftPanel.dart';
import 'package:shnatter/src/routes/settingRouter.dart';
import '../../controllers/HomeController.dart';
import '../../utils/size_config.dart';
import '../box/notification.dart';

class SettingMainScreen extends StatefulWidget {
  SettingMainScreen(
      {Key? key, required this.settingRouter, required this.routerChange})
      : con = HomeController(),
        super(key: key);
  final HomeController con;
  String settingRouter;
  Function routerChange;

  @override
  State createState() => SettingMainScreenState();
}

class SettingMainScreenState extends mvc.StateMVC<SettingMainScreen>
    with SingleTickerProviderStateMixin {
  String settingPage = '';
  late HomeController con;

  @override
  void initState() {
    add(widget.con);
    settingPage = widget.settingRouter;
    con = controller as HomeController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SettingRouter.settingRouter(settingPage, widget.routerChange));
  }
}
