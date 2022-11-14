// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/chat/newMessageScreen.dart';
import 'package:shnatter/src/views/chat/writeMessageScreen.dart';
import 'package:shnatter/src/widget/primaryInput.dart';

import '../../controllers/ChatController.dart';
import '../../managers/user_manager.dart';
import '../../models/chatModel.dart';

class EmoticonScreen extends StatefulWidget {
  Function onBack;
  EmoticonScreen({Key? key, required this.onBack})
      : con = ChatController(),
        super(key: key);
  late ChatController con;
  @override
  State createState() => EmoticonScreenState();
}

class ChatMessage {
  String messageContent;
  String messageType;
  ChatMessage({required this.messageContent, required this.messageType});
}

class EmoticonScreenState extends mvc.StateMVC<EmoticonScreen> {
  bool check1 = false;
  bool check2 = false;
  late ChatController con;
  late ScrollController _scrollController;
  var isMessageTap = 'all-list';
  var r = 0;
  var t = [];
  var emojiList = <Widget>[];
  late Stream stream;
  @override
  void initState() {
    add(widget.con);
    con = controller as ChatController;
    super.initState();
    _scrollController = ScrollController();
    FirebaseFirestore.instance.collection(Helper.emoticons).get().then(
      (value) {
        for (int i = 0; i < value.docs.length; i++) {
          print(value.docs[i]['emoticon']);
          if ((i + 1) % 10 != 0) {
            t.add(value.docs[i]['emoticon']);
          }
          if ((i + 1) % 10 == 0 || i == value.docs.length - 1) {
            emojiList.add(Row(
              children: t
                  .map((value) => Container(
                        width: 30,
                        height: 30,
                        padding: EdgeInsets.all(5),
                        child: SvgPicture.network(value.toString()),
                      ))
                  .toList(),
            ));
            t = [];
          }
        }
        print(emojiList);
        setState(() {});
      },
    );
  }

  String dropdownValue = 'Male';
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(220, 220, 220, 230),
              blurRadius: 2,
              spreadRadius: 2,
              offset: Offset(
                2,
                2,
              ),
            )
          ],
        ),
        margin: EdgeInsets.only(
            left: SizeConfig(context).screenWidth - 290,
            top: SizeConfig(context).screenHeight - 255),
        padding: EdgeInsets.all(5),
        width: 290,
        height: 200,
        child: Column(
          children: emojiList.map((e) => e).toList(),
        ));
  }
}
