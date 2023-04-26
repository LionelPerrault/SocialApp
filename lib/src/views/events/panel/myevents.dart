// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/events/widget/eventcell.dart';

import '../../../controllers/PostController.dart';
import '../../../models/chatModel.dart';

class MyEvents extends StatefulWidget {
  MyEvents({Key? key, required this.routerChange})
      : con = PostController(),
        super(key: key);
  late PostController con;
  Function routerChange;

  State createState() => MyEventsState();
}

class MyEventsState extends mvc.StateMVC<MyEvents> {
  bool check1 = false;
  bool check2 = false;
  late PostController con;
  var userInfo = UserManager.userInfo;
  var myEvents = [];
  int arrayLength = 0;
  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    getEventNow();
  }

  void getEventNow() {
    con.getEvent('manage', UserManager.userInfo['uid']).then((value) => {
          myEvents = [...value],
          myEvents.where((event) =>
              event['data']['eventAdmin'] == UserManager.userInfo['id']),
          setState(() {})
        });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = SizeConfig(context).screenWidth - SizeConfig.leftBarWidth;
    if (screenWidth <= 600) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: myEvents
            .map(
              (event) => EventCell(
                routerChange: widget.routerChange,
                eventData: event,
                buttonFun: () {
                  // con.interestedEvent(event['id']).then((value) {
                  getEventNow();
                  // });
                },
              ),
            )
            .toList(),
      );
    }
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: GridView.count(
              crossAxisCount: screenWidth > 900
                  ? 3
                  : screenWidth > 600
                      ? 2
                      : 1,
              // childAspectRatio: 2 / 3,
              padding: const EdgeInsets.all(4.0),
              mainAxisSpacing: 4.0,
              shrinkWrap: true,
              crossAxisSpacing: 4.0,
              children: myEvents
                  .map(
                    (event) => EventCell(
                      routerChange: widget.routerChange,
                      eventData: event,
                      buttonFun: () {
                        getEventNow();
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
