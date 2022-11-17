// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';
import '../../controllers/ChatController.dart';
import '../../managers/user_manager.dart';
import '../../models/chatModel.dart';
import '../../utils/size_config.dart';

class ChatUserListScreen extends StatefulWidget {
  Function onBack;
  ChatUserListScreen({Key? key, required this.onBack})
      : con = ChatController(),
        super(key: key);
  late ChatController con;
  @override
  State createState() => ChatUserListScreenState();
}

class ChatUserListScreenState extends mvc.StateMVC<ChatUserListScreen> {
  bool check1 = false;
  bool check2 = false;
  late ChatController con;
  late ScrollController scrollController;
  var isMessageTap = 'all-list';
  var hidden = false;
  var arr = [];

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
    return StreamBuilder(
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
                  padding: EdgeInsets.only(bottom: 10),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    con.takedata = true;
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
                    arr.add(chatUserName);
                    if (index == listUsers.length - 1) {
                      con.chatUserList = arr;
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
                    return Column(children: [
                      ListTile(
                        enabled: true,
                        contentPadding: EdgeInsets.only(
                            top: 5, bottom: 5, left: 20, right: 10),
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
                                radius: 22,
                                backgroundColor: Colors.blue,
                                child: SvgPicture.network(Helper.avatar))
                            : CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.blue,
                                backgroundImage: NetworkImage(
                                    t.chatInfo[chatUserName]['avatar']),
                              ),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            chatUserFullName,
                            style: TextStyle(color: Colors.blue, fontSize: 14),
                          ),
                        ),
                        subtitle: Text(
                          lastData,
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 0.5,
                        color: Color.fromRGBO(240, 240, 240, 1),
                      )
                    ]);
                  },
                ));
          } else {
            return con.takedata ? Container() : SizedBox(
              height:SizeConfig(context).screenHeight - 220,
              child:Center(child:CircularProgressIndicator()));
          }
        });
  }
}
