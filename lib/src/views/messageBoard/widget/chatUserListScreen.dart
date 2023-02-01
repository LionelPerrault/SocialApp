// ignore_for_file: prefer_const_constructors

import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/ChatController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';

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
    if (!mounted) {
      print('mounted');
    }
    final Stream<QuerySnapshot> stream = con.getChatUsers();
    stream.listen((event) {
      con.listUsers = event.docs;
      setState(() {});
    });
    final Stream<QuerySnapshot> onlineStream = FirebaseFirestore.instance
        .collection(Helper.onlineStatusField)
        .snapshots();
    onlineStream.listen((event) {
      var arr = [];
      event.docs.forEach((e) {
        arr.add(e.data());
      });
      con.onlineStatus = arr;
      setState(() {});
    });
  }

  String dropdownValue = 'Male';
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        controller: scrollController,
        child: ListView.builder(
          itemCount: con.listUsers.length,
          controller: scrollController,
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: 10),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            con.takedata = true;
            var t = con.listUsers[index].data();
            var docId = con.listUsers[index].id;
            var chatUserName = '';
            var me = UserManager.userInfo['userName'];
            for (int i = 0; i < t['users'].length; i++) {
              if (t['users'][i] != me) {
                chatUserName = t['users'][i];
                break;
              }
            }
            arr.add(chatUserName);
            if (index == con.listUsers.length - 1) {
              con.chatUserList = arr;
            }
            var lastData = '';
            if (t['lastData'].length > 18) {
              for (int i = 0; i < 18; i++) {
                lastData += t['lastData'][i];
              }
              lastData += '...';
            } else {
              lastData = t['lastData'];
            }
            var chatUserFullName = t[chatUserName]['name'];
            var status = 0;
            con.onlineStatus.forEach((e) {
              if (e['userName'] == chatUserName) {
                status = e['status'];
              }
            });
            //     print(chatUserFullName);
            return Column(children: [
              ListTile(
                enabled: true,
                contentPadding:
                    EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 10),
                tileColor: con.chattingUser == chatUserName
                    ? Color.fromRGBO(240, 240, 240, 1)
                    : Colors.white,
                onTap: () {
                  con.avatar = t[chatUserName]['avatar'];
                  widget.onBack('message-list');
                  con.chattingUser = chatUserName;
                  con.chatUserFullName = chatUserFullName;
                  con.docId = docId;
                  con.setState(() {});
                },
                hoverColor: Color.fromRGBO(240, 240, 240, 1),
                leading: Container(
                  width: 44,
                  height: 44,
                  child: Stack(
                    children: [
                      t[chatUserName]['avatar'] == ''
                          ? CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.blue,
                              child: SvgPicture.network(Helper.avatar))
                          : CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.blue,
                              backgroundImage:
                                  NetworkImage(t[chatUserName]['avatar']),
                            ),
                      Container(
                        margin: EdgeInsets.only(top: 32, left: 32),
                        alignment: Alignment.center,
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: status == 0 ? Colors.grey : Colors.green,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                      )
                    ],
                  ),
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
                trailing:
                    t[chatUserFullName] != 0 && t[chatUserFullName] != null
                        ? badges.Badge(
                            badgeStyle: badges.BadgeStyle(
                              badgeColor: Colors.red,
                            ),
                            badgeContent: Text(
                              t[chatUserFullName].toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : Icon(null),
              ),
              Container(
                width: double.infinity,
                height: 0.5,
                color: Color.fromRGBO(240, 240, 240, 1),
              )
            ]);
          },
        ));
  }
}
