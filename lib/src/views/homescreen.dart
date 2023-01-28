import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/routes/mainRouter.dart';
import 'package:shnatter/src/views/box/searchbox.dart';
import 'package:shnatter/src/views/chat/chatScreen.dart';
import 'package:shnatter/src/views/navigationbar.dart';
import 'package:shnatter/src/views/panel/leftpanel.dart';
import 'package:shnatter/src/views/panel/mainpanel.dart';
import 'package:shnatter/src/views/panel/rightpanel.dart';

import '../utils/size_config.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, required this.routerChange})
      : con = UserController(),
        super(key: key);
  final UserController con;
  Function routerChange;

  @override
  State createState() => HomeScreenState();
}

class HomeScreenState extends mvc.StateMVC<HomeScreen>
    with SingleTickerProviderStateMixin {
  late UserController con;
  @override
  void initState() {
    add(widget.con);
    con = controller as UserController;
    // print(UserManager.userInfo);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizeConfig(context).screenWidth > SizeConfig.mediumScreenSize + 300
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: MainPanel(),
                ),
                RightPanel(),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MainPanel(),
                RightPanel(),
              ],
            ),
    );
  }
}
