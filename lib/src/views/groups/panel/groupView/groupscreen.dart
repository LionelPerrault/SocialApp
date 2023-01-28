import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/managers/FileManager.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/box/searchbox.dart';
import 'package:shnatter/src/views/chat/chatScreen.dart';
import 'package:shnatter/src/views/groups/panel/groupView/groupSettingsScreen.dart';
import 'package:shnatter/src/views/navigationbar.dart';
import 'package:shnatter/src/views/panel/leftpanel.dart';

import 'groupAvatarandTabscreen.dart';
import 'groupMembersScreen.dart';
import 'groupPhotosScreen.dart';
import 'groupTimelineScreen.dart';
import 'groupVideosScreen.dart';

class GroupEachScreen extends StatefulWidget {
  GroupEachScreen({Key? key, required this.docId, required this.routerChange})
      : con = PostController(),
        super(key: key);
  final PostController con;
  String docId = '';
  Function routerChange;

  @override
  State createState() => GroupEachScreenState();
}

class GroupEachScreenState extends mvc.StateMVC<GroupEachScreen>
    with SingleTickerProviderStateMixin {
  double progress = 0;
  //
  var userInfo = UserManager.userInfo;
  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    super.initState();
    getSelectedGroup(widget.docId);
  }

  late PostController con;

  void getSelectedGroup(id) {
    con.getSelectedGroup(id).then((value) => {
          if (value)
            {
              setState(() {}),
              print('Successfully get group you want!!!'),
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizeConfig(context).screenWidth <
            //         SizeConfig.mediumScreenSize
            //     ? const SizedBox()
            //     : LeftPanel(),
            // //    : SizedBox(width: 0),
            Expanded(
                child: Row(
              mainAxisAlignment: con.group == null
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.end,
              crossAxisAlignment: con.group == null
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                con.group == null
                    ? Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.only(
                            top: SizeConfig(context).screenHeight * 2 / 5),
                        child: const CircularProgressIndicator(
                          color: Colors.grey,
                        ),
                      )
                    : Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GroupAvatarandTabScreen(
                                onClick: (value) {
                                  print(value);
                                  con.groupTab = value;
                                  setState(() {});
                                },
                              ),
                              con.groupTab == 'Timeline'
                                  ? GroupTimelineScreen(onClick: (value) {
                                      con.groupTab = value;
                                      setState(() {});
                                    })
                                  : con.groupTab == 'Photos'
                                      ? GroupPhotosScreen(onClick: (value) {
                                          con.groupTab = value;
                                          setState(() {});
                                        })
                                      : con.groupTab == 'Videos'
                                          ? GroupVideosScreen(onClick: (value) {
                                              con.groupTab = value;
                                              setState(() {});
                                            })
                                          : con.groupTab == 'Members'
                                              ? GroupMembersScreen(
                                                  onClick: (value) {
                                                    con.groupTab = value;
                                                    setState(() {});
                                                  },
                                                  routerChange:
                                                      widget.routerChange,
                                                )
                                              : con.groupTab == 'Settings'
                                                  ? GroupSettingsScreen(
                                                      onClick: (value) {
                                                        con.groupTab = value;
                                                        setState(() {});
                                                      },
                                                      routerChange:
                                                          widget.routerChange,
                                                    )
                                                  : const SizedBox()
                              // EventFriendScreen(),
                            ]),
                      ),
              ],
            )),
          ]),
    );
  }
}
