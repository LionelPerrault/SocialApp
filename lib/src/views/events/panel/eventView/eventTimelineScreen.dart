import 'dart:html';

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/box/mindpost.dart';

class EventTimelineScreen extends StatefulWidget {
  Function onClick;
  EventTimelineScreen({Key? key,required this.onClick})
      : con = PostController(),
        super(key: key);
  final PostController con;

  @override
  State createState() => EventTimelineScreenState();
}

class EventTimelineScreenState extends mvc.StateMVC<EventTimelineScreen>
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
            padding: const EdgeInsets.only(right: 10,left: 70,top: 15),
            child:SizeConfig(context).screenWidth < 800 ? 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                MindPost()
            ]
              )
            : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                MindPost()
            ]),
        );
  }
}
