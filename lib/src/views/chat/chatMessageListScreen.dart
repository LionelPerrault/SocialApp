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

class ChatMessageListScreen extends StatefulWidget {
  Function onBack;
  ChatMessageListScreen({Key? key, required this.onBack})
      : con = ChatController(),
        super(key: key);
  late ChatController con;
  @override
  State createState() => ChatMessageListScreenState();
}

class ChatMessage {
  String messageContent;
  String messageType;
  ChatMessage({required this.messageContent, required this.messageType});
}

class ChatMessageListScreenState extends mvc.StateMVC<ChatMessageListScreen> {
  bool check1 = false;
  bool check2 = false;
  late ChatController con;
  late ScrollController _scrollController;
  var isMessageTap = 'all-list';
  var r = 0;
  late Stream stream;
  @override
  void initState() {
    add(widget.con);
    con = controller as ChatController;
    super.initState();
    _scrollController = ScrollController();
    print(con.docId);
    stream = FirebaseFirestore.instance
        .collection(Helper.message)
        .doc(con.docId)
        .collection('content')
        .orderBy('timeStamp', descending: false)
        .snapshots();
    stream.listen((event) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
        );
      });
    });
  }

  String dropdownValue = 'Male';
  @override
  Widget build(BuildContext context) {
    return Container(
        child: con.docId == ''
            ? const Center(child: CircularProgressIndicator())
            : StreamBuilder(
                stream: stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    var messageList = snapshot.data!.docs;
                    return Column(children: [
                      Container(
                          height: SizeConfig(context).screenHeight - 220,
                          padding: EdgeInsets.only(top: 15, bottom: 15),
                          child: ListView.builder(
                            itemCount: messageList.length,
                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              var list = messageList[index].data();
                              var chatUserName = '';
                              var me = UserManager.userInfo['userName'];
                              return Container(
                                padding: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 15, right: 15),
                                child: Align(
                                  alignment: (list['sender'] != me
                                      ? Alignment.topLeft
                                      : Alignment.topRight),
                                  child: list['sender'] != me
                                      ? Row(children: [
                                          con.avatar == ''
                                              ? CircleAvatar(
                                                  radius: 25,
                                                  child: SvgPicture.network(
                                                      Helper.avatar),
                                                )
                                              : CircleAvatar(
                                                  radius: 25,
                                                  backgroundImage:
                                                      NetworkImage(con.avatar),
                                                ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: (list['sender'] == me
                                                  ? Colors.grey.shade200
                                                  : Colors.blue[200]),
                                            ),
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              list['data'],
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          )
                                        ])
                                      : Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: (list['sender'] == me
                                                ? Colors.grey.shade200
                                                : Colors.blue[200]),
                                          ),
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            list['data'],
                                            style: TextStyle(fontSize: 13),
                                          ),
                                        ),
                                ),
                              );
                            },
                          )),
                      WriteMessageScreen(
                        type: 'notnew',
                        goMessage: () {},
                      )
                    ]);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }));
  }
}
