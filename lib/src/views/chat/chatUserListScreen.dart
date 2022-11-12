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

import '../../controllers/ChatController.dart';
import '../../managers/user_manager.dart';
import '../../models/chatModel.dart';

class ChatUserListScreen extends StatefulWidget {
  Function onBack;
  ChatUserListScreen({Key? key,required this.onBack})
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
  var isMessageTap = 'all-list';
  var s;
  @override
  void initState() {
    add(widget.con);
    con = controller as ChatController;
    super.initState();
  }

  
  

  String dropdownValue = 'Male';
  @override

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 40,
          backgroundColor: Color.fromRGBO(51, 103, 214, 1),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(
                Icons.edit_calendar_rounded,
                size: 16,
              ),
              onPressed: (() {
                widget.onBack('new');
                  print(UserManager.userInfo['userName']);

                setState(() { });
              }),
              color: Colors.white,
              focusColor: Colors.white,
            ),
            IconButton(
              icon: Icon(Icons.settings, size: 16),
              onPressed: () {
                print(s);
              },
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
              return ListView.builder(
                itemCount: listUsers.length,
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
                  con.chatUserList.add(chatUserName);
                  var chatUserFullName = t.chatInfo[chatUserName];
                  return ListTile(
                            enabled: true,
                            tileColor: con.chattingUser == chatUserName ? Color.fromRGBO(240, 240, 240, 1) : Colors.white,
                            onTap: (){
                              widget.onBack('message-list');
                              con.chattingUser = chatUserName;
                              con.docId = docId;
                              con.chatId = t.chatId;
                              con.setState(() { });
                            },
                            hoverColor: Color.fromRGBO(240, 240, 240, 1),
                            leading: CircleAvatar(
                            radius: 25,
                            child: SvgPicture.network(Helper.avatar),
                          ),
                            title: Text(chatUserFullName),
                            subtitle: Text('Hello',style: TextStyle(fontSize: 12),),
                          );
                },
              );
  }else {
      return const Center(child: CircularProgressIndicator());
    }}));
  }
}
