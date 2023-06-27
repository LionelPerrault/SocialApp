import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/groups/panel/groupView/groupSettingsScreen.dart';
import 'groupAvatarandTabscreen.dart';
import 'groupMembersScreen.dart';
import 'groupPhotosScreen.dart';
import 'groupTimelineScreen.dart';
import 'groupVideosScreen.dart';

// ignore: must_be_immutable
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
  bool loadingGroup = true;
  late PostController con;
  var groupData;

  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    con.addNotifyCallBack(this);
    setState(() {});
    super.initState();
    getSelectedGroup(widget.docId);
  }

  void getSelectedGroup(id) {
    con.getSelectedGroup(id).then((value) => {
          if (value)
            {
              groupData = con.group,
              loadingGroup = false,
              setState(() {}),
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: con.group == null
            ? MainAxisAlignment.center
            : MainAxisAlignment.end,
        crossAxisAlignment: con.group == null
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          loadingGroup
              ? Container(
                  alignment: Alignment.center,
                  height: SizeConfig(context).screenHeight,
                  width: SizeConfig(context).screenWidth -
                      (SizeConfig(context).screenWidth >
                              SizeConfig.mediumScreenSize
                          ? SizeConfig.leftBarWidth
                          : 0),
                  child: const CircularProgressIndicator(
                    color: Colors.grey,
                  ),
                )
              : con.group == null
                  ? const SizedBox(
                      width: 30,
                      height: 30,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          GroupAvatarandTabScreen(
                            groupData: groupData,
                            onClick: (value) {
                              con.groupTab = value;
                              setState(() {});
                            },
                          ),
                          con.groupTab == 'Timeline'
                              ? GroupTimelineScreen(
                                  onClick: (value) {
                                    con.groupTab = value;
                                    setState(() {});
                                  },
                                  routerChange: widget.routerChange)
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
                                              routerChange: widget.routerChange,
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
                        ]),
        ],
      ),
    );
  }
}
