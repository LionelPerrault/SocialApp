// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/MessageController.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'chatMessageListScreen.dart';
import 'chatUserListScreen.dart';
import 'emoticonScreen.dart';
import 'newMessageScreen.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key})
      : con = MessageController(),
        super(key: key);
  final MessageController con;
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
  late MessageController con;

  @override
  void initState() {
    add(widget.con);
    con = controller as MessageController;

    super.initState();
  }

  String dropdownValue = 'Male';
  @override
  Widget build(BuildContext context) {
    return SizeConfig(context).screenWidth < 700
        ? Container()
        : GestureDetector(
            onTap: () {
              con.isShowEmoticon = false;
              setState(() {});
            },
            child: Stack(children: <Widget>[
              AnimatedContainer(
                  width: 300,
                  duration: const Duration(milliseconds: 500),
                  margin: EdgeInsets.only(
                      top: SizeConfig(context).screenHeight - 40,
                      left: SizeConfig(context).screenWidth - 300),
                  height: 40,
                  curve: Curves.fastOutSlowIn,
                  decoration: BoxDecoration(
                    color: Colors.red,
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
                      body: ListView(children: [
                    Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                          )),
                      child: Row(children: [
                        MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                if (con.isMessageTap == '') {
                                  con.isMessageTap = 'all-list';
                                }
                                setState(() {});
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(left: 5),
                                  width: 50,
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                  )),
                            )),
                        MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                if (con.isMessageTap != 'all-list') {
                                  con.isMessageTap = 'all-list';
                                }
                                con.docId = '';
                                setState(() {});
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(left: 5),
                                  width: 30,
                                  child: con.isMessageTap != 'all-list' &&
                                          con.isMessageTap != ''
                                      ? Icon(Icons.arrow_back,
                                          size: 16, color: Colors.white)
                                      : Container()),
                            )),
                        Text(
                          'Chats',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          child: SizedBox(),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              con.isMessageTap = 'new';
                              con.docId = '';
                              setState(() {});
                            },
                            child: Icon(
                              Icons.add,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        PopupMenuButton(
                          onSelected: (value) {
                            // your logic
                          },
                          icon: Icon(
                            Icons.settings,
                            size: 16,
                            color: Colors.white,
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
                      ]),
                    ),
                    con.isMessageTap == ''
                        ? Container()
                        : con.isMessageTap == 'all-list'
                            ? ChatUserListScreen(onBack: (value) {
                                print(value);
                                con.isMessageTap = value;
                                setState(() {});
                              })
                            : con.isMessageTap == 'new'
                                ? NewMessageScreen(
                                    onBack: (value) {
                                      if (value == true) {
                                        con.isShowEmoticon = value;
                                      } else {
                                        con.isMessageTap = value;
                                      }
                                      setState(() {});
                                    },
                                  )
                                : ChatMessageListScreen(
                                    showWriteMessage: true,
                                    onBack: (value) {
                                      con.isShowEmoticon = value;
                                      setState(() {});
                                    },
                                  )
                  ]))),
              con.isShowEmoticon
                  ? Container(
                      alignment: Alignment.center,
                      child: EmoticonScreen(onBack: (value) {
                        con.isShowEmoticon = value;
                        setState(() {});
                      }),
                    )
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
                con.isMessageTap = 'all-list';
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
