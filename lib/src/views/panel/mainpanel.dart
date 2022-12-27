import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/utils/svg.dart';
import 'package:shnatter/src/views/box/daytimeM.dart';
import 'package:shnatter/src/views/box/mindpost.dart';
import 'package:shnatter/src/widget/mindslice.dart';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/utils/svg.dart';
import 'package:shnatter/src/widget/createProductWidget.dart';
import 'package:shnatter/src/widget/likesCommentWidget.dart';

// ignore: must_be_immutable
class MainPanel extends StatefulWidget {
  MainPanel({
    super.key,
  }) : con = PostController();

  late PostController con;
  @override
  State createState() => MainPanelState();
}

class MainPanelState extends mvc.StateMVC<MainPanel> {
  List<Map> subFunctionList = [];
  bool showDayTimeM = true;
  int time = 0;
  DateTime nowTime = DateTime.now();
  @override
  void initState() {
    super.initState();
    if (nowTime.hour > 12) {
      time = 1;
    } else if (nowTime.hour > 20) {
      time = 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 20, left: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MindPost(),
            const Padding(padding: EdgeInsets.only(top: 20)),
            showDayTimeM
                ? DayTimeM(
                    time: time, username: UserManager.userInfo['fullName'])
                : Container(),
          ],
        ));
  }
}
