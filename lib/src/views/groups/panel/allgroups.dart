// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/groups/widget/groupcell.dart';

import '../../../controllers/PostController.dart';
import '../../../models/chatModel.dart';

class AllGroup extends StatefulWidget {
  AllGroup({Key? key})
      : con = PostController(),
        super(key: key);
  late PostController con;
  State createState() => AllGroupState();
}

class AllGroupState extends mvc.StateMVC<AllGroup> {
  bool check1 = false;
  bool check2 = false;
  late PostController con;
  var userInfo = UserManager.userInfo;
  var realAllGroups = [];
  int arrayLength = 0;
  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    con.setState(() {});
    super.initState();
    getGroupNow();
  }

  void getGroupNow() {
    con.getGroup('all', UserManager.userInfo['uid']).then((value) => {
          realAllGroups = value,
          realAllGroups.where((group) => group['data']['groupPost'] == true),
          print(realAllGroups),
          setState(() {}),
        });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = SizeConfig(context).screenWidth - SizeConfig.leftBarWidth;
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: GridView.count(
              crossAxisCount: screenWidth > 800
                  ? 4
                  : screenWidth > 600
                      ? 3
                      : screenWidth > 210
                          ? 2
                          : 1,
              childAspectRatio: 2 / 3,
              padding: const EdgeInsets.all(4.0),
              mainAxisSpacing: 4.0,
              shrinkWrap: true,
              crossAxisSpacing: 4.0,
              children: realAllGroups
                  .map(
                    (group) => GroupCell(
                      groupData: group,
                      refreshFunc: () {
                        getGroupNow();
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
