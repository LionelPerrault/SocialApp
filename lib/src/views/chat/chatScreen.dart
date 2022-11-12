// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/chat/chatUserListScreen.dart';
import 'package:shnatter/src/views/chat/newMessageScreen.dart';
import 'package:shnatter/src/widget/primaryInput.dart';

import '../../controllers/ChatController.dart';
import '../../managers/user_manager.dart';
import '../../models/chatModel.dart';
import 'chatMessageListScreen.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key})
      : con = ChatController(),
        super(key: key);
  late ChatController con;
  @override
  State createState() => ChatScreenState();
}

class ChatMessage {
  String messageContent;
  String messageType;
  ChatMessage({required this.messageContent, required this.messageType});
}

class ChatScreenState extends mvc.StateMVC<ChatScreen> {
  bool check1 = false;
  bool check2 = false;
  late ChatController con;
  var isMessageTap = 'all-list';
  var hidden = false;
  @override
  void initState() {
    add(widget.con);
    con = controller as ChatController;
    super.initState();
  }

  final chatCollection = FirebaseFirestore.instance
      .collection(Helper.message)
      .withConverter<ChatModel>(
        fromFirestore: (snapshots, _) => ChatModel.fromJSON(snapshots.data()!),
        toFirestore: (value, _) => value.toMap(),
      );
  Stream<QuerySnapshot<ChatModel>> getChatUsers() {
    return chatCollection
        .where('users', arrayContains: UserManager.userInfo['userName'])
        .snapshots();
  }

  String dropdownValue = 'Male';
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      AnimatedContainer(
          width: 300,
          duration: const Duration(milliseconds: 500),
          margin: EdgeInsets.only(
              top: !hidden ? 85 : SizeConfig(context).screenHeight - 40,
              left: SizeConfig(context).screenWidth - 300),
          height: !hidden ? SizeConfig(context).screenHeight - 85 : 40,
          curve: Curves.fastOutSlowIn,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3),
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
          child: isMessageTap == 'all-list'
              ? ChatUserListScreen(onBack: (value) {
                  print(value);
                  if (value == 'hidden') {
                    hidden = hidden ? false : true;
                  } else {
                    isMessageTap = value;
                  }
                  setState(() {});
                })
              : isMessageTap == 'new'
                  ? NewMessageScreen(
                      onBack: (value) {
                        isMessageTap = value;
                        setState(() {});
                      },
                    )
                  : ChatMessageListScreen(
                      onBack: (value) {
                        isMessageTap = value;
                        setState(() {});
                      },
                    ))
    ]);
  }
}
