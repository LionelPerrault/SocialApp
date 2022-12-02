import 'dart:html';

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/box/mindpost.dart';

class GroupTimelineScreen extends StatefulWidget {
  Function onClick;
  GroupTimelineScreen({Key? key, required this.onClick})
      : con = PostController(),
        super(key: key);
  final PostController con;

  @override
  State createState() => GroupTimelineScreenState();
}

class GroupTimelineScreenState extends mvc.StateMVC<GroupTimelineScreen>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  bool showSearch = false;
  late FocusNode searchFocusNode;
  bool showMenu = false;
  late AnimationController _drawerSlideController;
  var url = window.location.href;
  var subUrl = '';
  double width = 0;
  double itemWidth = 0;
  //
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as PostController;
  }

  late PostController con;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(right: 10, left: 10, top: 15),
      child: SizeConfig(context).screenWidth < 800
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              con.group['groupAdmin']['userName'] ==
                      UserManager.userInfo['userName']
                  ? MindPost()
                  : Container(),
              eventInfo()
            ])
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  con.group['groupAdmin']['userName'] ==
                          UserManager.userInfo['userName']
                      ? MindPost()
                      : Container(),
                  eventInfo()
                ]),
    );
  }

  @override
  Widget eventInfo() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              con.group['groupAbout'],
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
          ]),
          const Divider(
            thickness: 0.4,
            color: Colors.black,
          ),
          groupInfoCell(
              icon: Icon(
                con.group['groupPrivacy'] == 'public'
                    ? Icons.language
                    : con.group['groupPrivacy'] == 'security'
                        ? Icons.lock
                        : Icons.lock_open_rounded,
                color: Colors.grey,
              ),
              text: con.group['groupPrivacy'] == 'public'
                  ? 'Public Group'
                  : con.group['groupPrivacy'] == 'security'
                      ? 'Security Group'
                      : 'Closed Group'),
          groupInfoCell(
              icon: const Icon(
                Icons.groups,
                color: Colors.grey,
              ),
              text: '${con.group["groupJoined"].length} members'),
          groupInfoCell(
              icon: const Icon(
                Icons.tag,
                color: Colors.grey,
              ),
              text: 'N/A'),
          groupInfoCell(
              icon: const Icon(
                Icons.maps_ugc,
                color: Colors.grey,
              ),
              text: '${con.group["groupLocation"]}'),
        ],
      ),
    );
  }

  @override
  Widget groupInfoCell({icon, text}) {
    return Container(
      margin: const EdgeInsets.all(3),
      child: Row(children: [
        icon,
        const Padding(padding: EdgeInsets.only(left: 10)),
        Text(
          text,
          style: const TextStyle(fontSize: 13),
        )
      ]),
    );
  }
}
