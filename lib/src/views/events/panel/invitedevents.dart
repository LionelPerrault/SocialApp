// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/events/widget/eventcell.dart';

import '../../../controllers/PostController.dart';
import '../../../models/chatModel.dart';

class InvitedEvents extends StatefulWidget {
  InvitedEvents({Key? key})
      : con = PostController(),
        super(key: key);
  late PostController con;
  State createState() => InvitedEventsState();
}

class InvitedEventsState extends mvc.StateMVC<InvitedEvents> {
  bool check1 = false;
  bool check2 = false;
  late PostController con;
  var userInfo = UserManager.userInfo;
  var invitedEvents = [];
  var returnValue= [];
  int arrayLength = 0;
  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    con.setState(() { });
    super.initState();
    getEventNow();
  }

  void getEventNow() {
    con.getEvent('invited').then((value) => {
      returnValue = value,
      invitedEvents = value,
      print(invitedEvents),
    });
  }
  @override
  Widget build(BuildContext context) {
    var  screenWidth = SizeConfig(context).screenWidth - SizeConfig.leftBarWidth;
    return Container(
      child: 
      Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: GridView.count(
                crossAxisCount: screenWidth > 800 ? 4 : screenWidth > 600 ? 3 : screenWidth > 210 ? 2 : 1  ,
                childAspectRatio: 2/ 3,
                padding: const EdgeInsets.all(4.0),
                mainAxisSpacing: 4.0,
                shrinkWrap: true,
                crossAxisSpacing: 4.0,
                children: 
                  invitedEvents.map((event) => 
                    EventCell(
                      eventTap: (){},
                      buttonFun: (){con.interestedEvent(event['id']).then((value){getEventNow();});},
                      picture: 'null',
                      status: false,
                      interests: event['data']['eventInterested'].length,
                      header: event['data']['eventName'],
                      interested: event['interested'])).toList(),),
          ),
        ],
      ),
    );
  }
}
