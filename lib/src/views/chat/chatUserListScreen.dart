// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/chat/newMessageScreen.dart';
import 'package:shnatter/src/widget/primaryInput.dart';
import 'package:mime/mime.dart';

import '../../controllers/ChatController.dart';
import '../../managers/user_manager.dart';
import '../../models/chatModel.dart';

class ChatUserListScreen extends StatefulWidget {
  Function onBack;
  ChatUserListScreen({Key? key, required this.onBack})
      : con = ChatController(),
        super(key: key);
  late ChatController con;
  @override
  State createState() => ChatUserListScreenState();
}

class ChatMessage {
  String messageContent;
  String messageType;
  ChatMessage({required this.messageContent, required this.messageType});
}

class ChatUserListScreenState extends mvc.StateMVC<ChatUserListScreen> {
  bool check1 = false;
  bool check2 = false;
  late ChatController con;
  late ScrollController scrollController;
  var isMessageTap = 'all-list';
  var hidden = false;
  @override
  void initState() {
    add(widget.con);
    con = controller as ChatController;
    super.initState();
    scrollController = ScrollController();
  }

  String dropdownValue = 'Male';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 40,
          backgroundColor: Color.fromRGBO(51, 103, 214, 1),
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(
                !hidden ? Icons.remove : Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                hidden = !hidden ? true : false;
                setState(() {});
                widget.onBack('hidden');
              }),
          actions: [
            IconButton(
              icon: Icon(
                Icons.edit_calendar_rounded,
                size: 16,
              ),
              onPressed: (() {
                widget.onBack('new');

                setState(() {});
              }),
              color: Colors.white,
              focusColor: Colors.white,
            ),
            IconButton(
              icon: Icon(Icons.settings, size: 16),
              onPressed: () {},
              color: Colors.white,
              focusColor: Colors.white,
            ),
          ],
          title: Text(
            'Chats',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        body: StreamBuilder(
            stream: con.getChatUsers(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                List<QueryDocumentSnapshot<ChatModel>>? listUsers =
                    snapshot.data!.docs;
                return Scrollbar(
                    controller: scrollController,
                    child: ListView.builder(
                      itemCount: listUsers.length,
                      controller: scrollController,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        ChatModel t = listUsers[index].data();
                        var docId = snapshot.data!.docs[index].id;
                        var chatUserName = '';
                        var me = UserManager.userInfo['userName'];
                        for (int i = 0; i < t.users.length; i++) {
                          if (t.users[i] != me) {
                            chatUserName = t.users[i];
                            break;
                          }
                        }
                        if (con.chatUserList.isEmpty) {
                          con.chatUserList.add(chatUserName);
                        }
                        var lastData = '';
                        if (t.chatInfo['lastData'].length > 18) {
                          for (int i = 0; i < 18; i++) {
                            lastData += t.chatInfo['lastData'][i];
                          }
                          lastData += '...';
                        } else {
                          lastData = t.chatInfo['lastData'];
                        }
                        var chatUserFullName = t.chatInfo[chatUserName]['name'];
                        return ListTile(
                          enabled: true,
                          tileColor: con.chattingUser == chatUserName
                              ? Color.fromRGBO(240, 240, 240, 1)
                              : Colors.white,
                          onTap: () {
                            con.avatar = t.chatInfo[chatUserName]['avatar'];
                            widget.onBack('message-list');
                            con.chattingUser = chatUserName;
                            con.docId = docId;
                            con.chatId = t.chatId;

                            con.setState(() {});
                          },
                          hoverColor: Color.fromRGBO(240, 240, 240, 1),
                          leading: t.chatInfo[chatUserName]['avatar'] == ''
                              ? CircleAvatar(
                                  radius: 25,
                                  child: SvgPicture.network(Helper.avatar),
                                )
                              : CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                      t.chatInfo[chatUserName]['avatar']),
                                ),
                          title: Text(chatUserFullName),
                          subtitle: Text(
                            lastData,
                            style: TextStyle(fontSize: 12),
                          ),
                        );
                      },
                    ));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}
