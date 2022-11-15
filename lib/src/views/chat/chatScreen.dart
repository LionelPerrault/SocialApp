// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/chat/chatUserListScreen.dart';
import 'package:shnatter/src/views/chat/emoticonScreen.dart';
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
  final ChatController con;
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
  var isMessageTap = '';
  var hidden = true;

  @override
  void initState() {
    add(widget.con);
    con = controller as ChatController;

    super.initState();
  }

  String dropdownValue = 'Male';
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          con.isShowEmoticon = false;
          setState(() {});
        },
        child: Stack(children: <Widget>[
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
              child: Scaffold(
                  appBar: AppBar(
                    toolbarHeight: 40,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      ),
                    ),
                    backgroundColor: Color.fromRGBO(51, 103, 214, 1),
                    automaticallyImplyLeading: false,
                    leading: IconButton(
                        icon: Icon(
                          !hidden
                              ? isMessageTap != 'all-list'
                                  ? Icons.arrow_back
                                  : Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: Colors.white,
                          size: 16,
                        ),
                        onPressed: () {
                          if (isMessageTap == '') {
                            hidden = false;
                            isMessageTap = 'all-list';
                          } else if (isMessageTap == 'all-list') {
                            hidden = !hidden ? true : false;
                          } else {
                            isMessageTap = 'all-list';
                          }
                          setState(() {});
                        }),
                    actions: [
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          size: 16,
                        ),
                        onPressed: (() {
                          if (hidden) hidden = false;
                          isMessageTap = 'new';
                          setState(() {});
                        }),
                        color: Colors.white,
                        focusColor: Colors.white,
                      ),
                      PopupMenuButton(
                        onSelected: (value) {
                          // your logic
                        },
                        icon: Icon(
                          Icons.settings,
                          size: 16,
                        ),
                        itemBuilder: (BuildContext bc) {
                          return const [
                            PopupMenuItem(
                              value: 'block',
                              child: Text(
                                "Manage Blocking",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            PopupMenuItem(
                              value: 'privacy',
                              child: Text(
                                "Privacy Settings",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            PopupMenuItem(
                              value: 'turn_off',
                              child: Text(
                                "Turn Off Chat",
                                style: TextStyle(fontSize: 14),
                              ),
                            )
                          ];
                        },
                      )
                    ],
                    title: Text(
                      'Chats',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  body: isMessageTap == ''
                      ? Container()
                      : isMessageTap == 'all-list'
                          ? ChatUserListScreen(onBack: (value) {
                              print(value);
                              if (value == 'hidden') {
                                hidden = hidden ? false : true;
                              } else {
                                isMessageTap = value;
                                if (hidden == true) hidden = false;
                              }
                              setState(() {});
                            })
                          : isMessageTap == 'new'
                              ? NewMessageScreen(
                                  onBack: (value) {
                                    if (value) {
                                      con.isShowEmoticon = value;
                                    } else {
                                      isMessageTap = value;
                                    }
                                    setState(() {});
                                  },
                                )
                              : ChatMessageListScreen(
                                  onBack: (value) {
                                    con.isShowEmoticon = value;
                                    setState(() {});
                                  },
                                ))),
          !hidden && con.isShowEmoticon
              ? Container(
                  margin: EdgeInsets.only(
                      left: SizeConfig(context).screenWidth - 295,
                      top: SizeConfig(context).screenHeight - 265),
                  child: EmoticonScreen(onBack: (value) {
                    con.isShowEmoticon = value;
                    setState(() {});
                  }))
              : Container()
        ]));
  }

  Widget firstChatComponent() {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 40,
          backgroundColor: Color.fromRGBO(51, 103, 214, 1),
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_upward,
                color: Colors.white,
                size: 16,
              ),
              onPressed: () {
                hidden = false;
                isMessageTap = 'all-list';
                setState(() {});
              }),
          title: Text(
            'Chats',
            style: TextStyle(color: Colors.white, fontSize: 16),
          )),
      body: Container(),
    );
  }
}
