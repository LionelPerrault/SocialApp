// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/groups/widget/groupcell.dart';

import '../../../controllers/PostController.dart';
import '../../../models/chatModel.dart';

class JoinedGroups extends StatefulWidget {
  JoinedGroups({Key? key})
      : con = PostController(),
        super(key: key);
  late PostController con;
  State createState() => JoinedGroupsState();
}

class JoinedGroupsState extends mvc.StateMVC<JoinedGroups> {
  bool check1 = false;
  bool check2 = false;
  late PostController con;
  var userInfo = UserManager.userInfo;
  var returnValue = [];
  var joinedGroups = [];
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
    con.getGroup('joined', UserManager.userInfo['uid']).then((value) => {
          returnValue = value,
          joinedGroups = value,
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
              children: joinedGroups
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
