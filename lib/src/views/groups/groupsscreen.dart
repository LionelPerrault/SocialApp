import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/views/box/searchbox.dart';
import 'package:shnatter/src/views/chat/chatScreen.dart';
import 'package:shnatter/src/views/groups/panel/allgroups.dart';
import 'package:shnatter/src/views/groups/panel/joinedgroups.dart';
import 'package:shnatter/src/views/groups/panel/mygroups.dart';
import 'package:shnatter/src/views/navigationbar.dart';
import 'package:shnatter/src/views/panel/leftpanel.dart';
import 'package:shnatter/src/views/panel/rightpanel.dart';
import 'package:shnatter/src/widget/createGroupWidget.dart';

import '../../controllers/PostController.dart';
import '../../utils/size_config.dart';
import '../../widget/mprimary_button.dart';
import '../../widget/list_text.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/gestures.dart';
import '../box/notification.dart';

class GroupsScreen extends StatefulWidget {
  GroupsScreen({Key? key, required this.routerChange})
      : con = PostController(),
        super(key: key);
  final PostController con;
  Function routerChange;

  @override
  State createState() => GroupsScreenState();
}

class GroupsScreenState extends mvc.StateMVC<GroupsScreen>
    with SingleTickerProviderStateMixin {
  //route variable
  String groupSubRoute = 'Discover';
  late PostController con;

  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    super.initState();
  }

  Widget button() {
    return Container(
      width: SizeConfig(context).screenWidth > SizeConfig.mediumScreenSize
          ? 120
          : 50,
      margin: const EdgeInsets.only(right: 20),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(3),
            backgroundColor: Color.fromARGB(255, 45, 206, 137),
            // elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0)),
            minimumSize: Size(
                SizeConfig(context).screenWidth > SizeConfig.mediumScreenSize
                    ? 120
                    : 50,
                50),
            maximumSize: Size(
                SizeConfig(context).screenWidth > SizeConfig.mediumScreenSize
                    ? 120
                    : 50,
                50),
          ),
          onPressed: () {
            (showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) => AlertDialog(
                    title: Row(
                      children: const [
                        Icon(
                          Icons.groups,
                          color: Color.fromARGB(255, 247, 159, 88),
                        ),
                        Text(
                          'Create New Group',
                          style: TextStyle(
                              fontSize: 15, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    content: CreateGroupModal(
                      context: context,
                      routerChange: widget.routerChange,
                    ))));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.add_circle),
              const Padding(padding: EdgeInsets.only(left: 4)),
              SizeConfig(context).screenWidth > SizeConfig.mediumScreenSize
                  ? const Text('Create Group',
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.bold))
                  : SizedBox()
            ],
          )),
    );
  }

  Widget makePane(String paneName) {
    return Column(children: [
      MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
              onTap: () {
                groupSubRoute = paneName;
                setState(() {});
              },
              child:
                  Padding(padding: EdgeInsets.all(10), child: Text(paneName)))),
      groupSubRoute == paneName
          ? Container(
              width: 50,
              margin: EdgeInsets.only(top: 2),
              height: 2,
              color: Colors.black,
            )
          : SizedBox()
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig(context).screenWidth > SizeConfig.mediumScreenSize
          ? SizeConfig(context).screenWidth - SizeConfig.leftBarWidth
          : SizeConfig(context).screenWidth,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      makePane("Discover"),
                      makePane("Joined Group"),
                      makePane("My Groups")
                    ],
                  ),
                  button()
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            groupSubRoute == 'Discover'
                ? AllGroup(routerChange: widget.routerChange)
                : const SizedBox(),
            groupSubRoute == 'Joined Group'
                ? JoinedGroups(routerChange: widget.routerChange)
                : const SizedBox(),
            groupSubRoute == 'My Groups'
                ? MyGroups(routerChange: widget.routerChange)
                : const SizedBox(),
          ]),
    );
  }
}
