import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/managers/FileManager.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/box/searchbox.dart';
import 'package:shnatter/src/views/chat/chatScreen.dart';
import 'package:shnatter/src/views/events/panel/eventView/eventSettingsScreen.dart';
import 'package:shnatter/src/views/navigationbar.dart';
import 'package:shnatter/src/views/panel/leftpanel.dart';

import 'eventAvatarandTabscreen.dart';
import 'eventMembersScreen.dart';
import 'eventPhotosScreen.dart';
import 'eventTimelineScreen.dart';
import 'eventVideosScreen.dart';

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
  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    filecon = FileController();
    setState(() {});
    super.initState();
    searchFocusNode = FocusNode();
    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    con = controller as PostController;
    getSelectedEvent(widget.docId);
  }

  late PostController con;

  void getSelectedEvent(id) {
    con.getSelectedEvent(id).then((value) => {
          if (value)
            {
              print('Successfully get event you want!!!'),
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
                          onClick: (value) {
                            print(value);
                            con.eventTab = value;
                            setState(() {});
                          },
                        ),
                        con.eventTab == 'Timeline'
                            ? EventTimelineScreen(onClick: (value) {
                                con.eventTab = value;
                                setState(() {});
                              })
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
                                              })
                                            : const SizedBox()
                        // EventFriendScreen(),
                      ]),
                ),
        ],
      ),
    );
  }
}
