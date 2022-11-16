// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/events/widget/eventcell.dart';
import 'package:shnatter/src/widget/mprimary_button.dart';
import 'package:shnatter/src/widget/primaryInput.dart';

import '../../../controllers/PostController.dart';
import '../../../models/chatModel.dart';

class AllEvents extends StatefulWidget {
  AllEvents({Key? key})
      : con = PostController(),
        super(key: key);
  late PostController con;
  State createState() => AllEventsState();
}

class AllEventsState extends mvc.StateMVC<AllEvents> {
  bool check1 = false;
  bool check2 = false;
  late PostController con;
  var userInfo = UserManager.userInfo;
  var events = [];
  int arrayLength = 0;
  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    setState(() {});
    con.getEvent();
    con.setState(() { });
    super.initState();
  }

  // Stream<QuerySnapshot<ChatModel>> getLoginedUsers() {
  //   return transactionCollection
  //       .where('from-to', arrayContains: con.paymail)
  //       //.orderBy("date")
  //       .snapshots();
  // }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(children: 
        
        con.events.map((event) => EventCell(
              eventTap: (){},
              picture: event['eventAdmin'],
              interests: 1,
              header: event['eventName'],
              interested: false)).toList(),
      ),
    );
  }
}
