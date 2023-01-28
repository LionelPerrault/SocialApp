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
  String groupSubRoute = '';
  late PostController con;

  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 20, left: 0),
                  child: Column(
                    children: [
                      Container(
                          width: SizeConfig(context).screenWidth >
                                  SizeConfig.smallScreenSize
                              ? SizeConfig(context).screenWidth * 0.6
                              : SizeConfig(context).screenWidth * 1,
                          height: 70,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 1.0,
                                spreadRadius: 0.1,
                                offset: Offset(
                                  0.1,
                                  0.11,
                                ),
                              )
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: SizeConfig(context).screenWidth >
                                        SizeConfig.smallScreenSize
                                    ? SizeConfig(context).screenWidth * 0.4 + 40
                                    : SizeConfig(context).screenWidth * 0.9 -
                                        30,
                                child: Row(children: [
                                  const Padding(
                                      padding: EdgeInsets.only(left: 30)),
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(
                                              top: groupSubRoute == ''
                                                  ? 26
                                                  : 0)),
                                      RichText(
                                        text: TextSpan(children: <TextSpan>[
                                          TextSpan(
                                              text: 'Discover',
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 90, 90, 90),
                                                  fontSize: 14),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  groupSubRoute = '';
                                                  setState(() {});
                                                }),
                                        ]),
                                      ),
                                      groupSubRoute == ''
                                          ? Container(
                                              margin: EdgeInsets.only(top: 26),
                                              height: 1,
                                              color: Colors.black,
                                            )
                                          : SizedBox()
                                    ],
                                  )),
                                  const Padding(
                                      padding: EdgeInsets.only(left: 5)),
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(
                                              top: groupSubRoute == 'joined'
                                                  ? 26
                                                  : 0)),
                                      RichText(
                                        text: TextSpan(children: <TextSpan>[
                                          TextSpan(
                                              text: 'Joined Groups',
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 90, 90, 90),
                                                  fontSize: 14),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  groupSubRoute = 'joined';
                                                  setState(() {});
                                                }),
                                        ]),
                                      ),
                                      groupSubRoute == 'joined'
                                          ? Container(
                                              margin: EdgeInsets.only(top: 26),
                                              height: 1,
                                              color: Colors.black,
                                            )
                                          : SizedBox()
                                    ],
                                  )),
                                  const Padding(
                                      padding: EdgeInsets.only(left: 5)),
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(
                                              top: groupSubRoute == 'manage'
                                                  ? 26
                                                  : 0)),
                                      RichText(
                                        text: TextSpan(children: <TextSpan>[
                                          TextSpan(
                                              text: 'My Groups',
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 90, 90, 90),
                                                  fontSize: 14),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  groupSubRoute = 'manage';
                                                  setState(() {});
                                                }),
                                        ]),
                                      ),
                                      groupSubRoute == 'manage'
                                          ? Container(
                                              margin: EdgeInsets.only(top: 26),
                                              height: 1,
                                              color: Colors.black,
                                            )
                                          : SizedBox()
                                    ],
                                  )),
                                ]),
                              ),
                              const Flexible(
                                  fit: FlexFit.tight, child: SizedBox()),
                              Container(
                                width: SizeConfig(context).screenWidth >
                                        SizeConfig.mediumScreenSize
                                    ? 120
                                    : 50,
                                margin: const EdgeInsets.only(right: 20),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(3),
                                      backgroundColor:
                                          Color.fromARGB(255, 45, 206, 137),
                                      // elevation: 3,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(3.0)),
                                      minimumSize: Size(
                                          SizeConfig(context).screenWidth >
                                                  SizeConfig.mediumScreenSize
                                              ? 120
                                              : 50,
                                          50),
                                      maximumSize: Size(
                                          SizeConfig(context).screenWidth >
                                                  SizeConfig.mediumScreenSize
                                              ? 120
                                              : 50,
                                          50),
                                    ),
                                    onPressed: () {
                                      (showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                  title: Row(
                                                    children: const [
                                                      Icon(
                                                        Icons.groups,
                                                        color: Color.fromARGB(
                                                            255, 247, 159, 88),
                                                      ),
                                                      Text(
                                                        'Create New Group',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      ),
                                                    ],
                                                  ),
                                                  content: CreateGroupModal(
                                                      context: context))));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.add_circle),
                                        const Padding(
                                            padding: EdgeInsets.only(left: 4)),
                                        SizeConfig(context).screenWidth >
                                                SizeConfig.mediumScreenSize
                                            ? const Text('Create Group',
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold))
                                            : SizedBox()
                                      ],
                                    )),
                              )
                            ],
                          ))
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
                groupSubRoute == ''
                    ? AllGroup(routerChange: widget.routerChange)
                    : const SizedBox(),
                groupSubRoute == 'joined'
                    ? JoinedGroups(routerChange: widget.routerChange)
                    : const SizedBox(),
                groupSubRoute == 'manage'
                    ? MyGroups(routerChange: widget.routerChange)
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
