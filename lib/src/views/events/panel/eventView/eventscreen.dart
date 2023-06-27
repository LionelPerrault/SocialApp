// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/managers/FileManager.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/events/panel/eventView/eventSettingsScreen.dart';
import 'eventAvatarandTabscreen.dart';
import 'eventMembersScreen.dart';
import 'eventPhotosScreen.dart';
import 'eventTimelineScreen.dart';
import 'eventVideosScreen.dart';

// ignore: must_be_immutable
class EventEachScreen extends StatefulWidget {
  EventEachScreen({Key? key, required this.docId, required this.routerChange})
      : con = PostController(),
        super(key: key);
  final PostController con;
  String docId = '';
  Function routerChange;

  @override
  State createState() => EventEachScreenState();
}

class EventEachScreenState extends mvc.StateMVC<EventEachScreen>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  late FocusNode searchFocusNode;
  late FileController filecon;
  bool showMenu = false;
  late AnimationController _drawerSlideController;
  double progress = 0;
  //
  var userInfo = UserManager.userInfo;
  List<Map> mainTabList = [
    {'title': 'Timeline', 'icon': Icons.tab},
    {'title': 'Photos', 'icon': Icons.photo},
    // {'title': 'Videos', 'icon': Icons.video_call},
    {'title': 'Members', 'icon': Icons.groups},
  ];
  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    filecon = FileController();
    con.addNotifyCallBack(this);
    setState(() {});
    super.initState();
    searchFocusNode = FocusNode();
    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    getSelectedEvent(widget.docId);
  }

  late PostController con;

  void getSelectedEvent(id) async {
    await con.getSelectedEvent(id).then((value) {
      if (UserManager.userInfo['uid'] == con.event['eventAdmin'][0]['uid']) {
        mainTabList.add({'title': 'Settings', 'icon': Icons.settings});
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: con.event == null
            ? MainAxisAlignment.center
            : MainAxisAlignment.end,
        crossAxisAlignment: con.event == null
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          con.event == null
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
                        EventAvatarandTabScreen(
                          eventData: con.event,
                          mainTabList: mainTabList,
                          onClick: (value) {
                            con.eventTab = value;
                            setState(() {});
                          },
                        ),
                        con.eventTab == 'Timeline'
                            ? EventTimelineScreen(
                                onClick: (value) {
                                  con.eventTab = value;
                                  setState(() {});
                                },
                                routerChange: widget.routerChange)
                            : con.eventTab == 'Photos'
                                ? EventPhotosScreen(onClick: (value) {
                                    con.eventTab = value;
                                    setState(() {});
                                  })
                                : con.eventTab == 'Videos'
                                    ? EventVideosScreen(onClick: (value) {
                                        con.eventTab = value;
                                        setState(() {});
                                      })
                                    : con.eventTab == 'Members'
                                        ? EventMembersScreen(
                                            onClick: (value) {
                                              con.eventTab = value;
                                              setState(() {});
                                            },
                                            routerChange: widget.routerChange,
                                          )
                                        : con.eventTab == 'Settings'
                                            ? EventSettingsScreen(
                                                onClick: (value) {
                                                  con.eventTab = value;
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
      ),
    );
  }
}
