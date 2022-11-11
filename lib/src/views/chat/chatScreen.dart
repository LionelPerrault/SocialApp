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
  var s;
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
    return chatCollection.where('users',
        arrayContains: UserManager.userInfo['userName']).snapshots();
  }

  String dropdownValue = 'Male';
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
          width: 300,
          margin: EdgeInsets.only(
              top: 85, left: SizeConfig(context).screenWidth - 300),
          height: SizeConfig(context).screenHeight - 100,
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
          child: isMessageTap == 'all-list' ? ChatUserListScreen(
            onBack:(value){
              isMessageTap = value;
              setState(() { });
            }
          ) : isMessageTap == 'new' ?
           NewMessageScreen(onBack: (value){
            isMessageTap = value;
            setState(() { });
           },) : ChatMessageListScreen(
            onBack: (value){
              isMessageTap = value;
              setState(() { });
            },
           )
          )
    ]);
  }

  Widget userList() {
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
                isMessageTap = 'new';
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
            stream: getChatUsers(),
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
                  var chatUserName = '';
                  var me = UserManager.userInfo['userName'];
                  for (int i = 0; i < t.users.length; i++) {
                    if (t.users[i] != me) {
                      chatUserName = t.users[i];
                      break;
                    }
                  }
                  var chatUserFullName = t.chatInfo[chatUserName];
                  return ListTile(
                            leading: CircleAvatar(
                            radius: 25,
                            child: SvgPicture.network(Helper.avatar),
                          ),
                            title: Text(chatUserFullName),
                            subtitle: Text('Hello',style: TextStyle(fontSize: 12),),
                          );
                  // return Container(
                  //     padding:
                  //         EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                  //     child: Row(
                  //       children: [
                          // CircleAvatar(
                          //   radius: 25,
                          //   backgroundImage: NetworkImage(Helper.avatar),
                          // ),
                  //         ListTile(
                  //           title: Text(chatUserFullName),
                  //           subtitle: Text('Hello'),
                  //         )
                  //       ],
                  //     ));
                },
              );
  }else {
            return const Center(child: CircularProgressIndicator());
          }}));
  }
  // Widget messageList() {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text(
  //         'Message',
  //         style: TextStyle(fontSize: 16),
  //       ),
  //       backgroundColor: Color.fromRGBO(51, 103, 214, 1),
  //       toolbarHeight: 40,
  //       leading: IconButton(
  //           icon: Icon(
  //             Icons.arrow_back,
  //             color: Colors.white,
  //           ),
  //           onPressed: () {
  //             isMessageTap = false;
  //             setState(() {});
  //           }),
  //     ),
  //     body: Row(children: [
  //       Container(
  //         color: Colors.white,
  //         width: 80,
  //       ),
  //       Container(
  //         width: 220,
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           boxShadow: const [
  //             BoxShadow(
  //               color: Color.fromARGB(220, 220, 220, 230),
  //               blurRadius: 2,
  //               spreadRadius: 2,
  //               offset: Offset(
  //                 2,
  //                 2,
  //               ),
  //             )
  //           ],
  //         ),
  //         child: Column(
  //           children: [
  //             Container(
  //                 height: 40,
  //                 child: TextField(
  //                   onChanged: ((value) {
  //                     con.chattingUser = value;
  //                     con.setState(() {});
  //                   }),
  //                   decoration: InputDecoration(
  //                     hintText: 'To :',
  //                     hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
  //                     // Enabled Border
  //                     enabledBorder: const UnderlineInputBorder(
  //                       borderSide: BorderSide(color: Colors.grey, width: 0.1),
  //                     ),
  //                     // Focused Border
  //                     focusedBorder: const UnderlineInputBorder(
  //                       borderSide: BorderSide(color: Colors.grey, width: 0.1),
  //                     ),
  //                     // Error Border
  //                     contentPadding: EdgeInsets.only(left: 15, right: 15),
  //                     // Focused Error Border
  //                     focusedErrorBorder: const UnderlineInputBorder(
  //                       borderSide: BorderSide(color: Colors.red, width: 0.1),
  //                     ),
  //                   ),
  //                 )),
  //             Container(
  //                 height: SizeConfig(context).screenHeight - 250,
  //                 child: StreamBuilder(
  //                     stream: getChatUsers(),
  //                     builder: (context, snapshot) {
  //                       List<QueryDocumentSnapshot<ChatModel>>? listUsers =
  //                           snapshot.data!.docs;
  //                       return ListView.builder(
  //                         itemCount: listUsers.length,
  //                         shrinkWrap: true,
  //                         padding: EdgeInsets.only(top: 10, bottom: 10),
  //                         physics: NeverScrollableScrollPhysics(),
  //                         itemBuilder: (context, index) {
  //                           ChatModel t = listUsers[index].data();
  //                           return Container(
  //                             padding: EdgeInsets.only(
  //                                 left: 14, right: 14, top: 10, bottom: 10),
  //                             child: Align(
  //                               alignment:
  //                                   (listUsers[index].messageType == "receiver"
  //                                       ? Alignment.topLeft
  //                                       : Alignment.topRight),
  //                               child: Container(
  //                                 decoration: BoxDecoration(
  //                                   borderRadius: BorderRadius.circular(20),
  //                                   color: (messages[index].messageType ==
  //                                           "receiver"
  //                                       ? Colors.grey.shade200
  //                                       : Colors.blue[200]),
  //                                 ),
  //                                 padding: EdgeInsets.all(16),
  //                                 child: Text(
  //                                   messages[index].messageContent,
  //                                   style: TextStyle(fontSize: 15),
  //                                 ),
  //                               ),
  //                             ),
  //                           );
  //                         },
  //                       );
  //                     })),
              
  //       ),
  //     ]),
  //   );
  // }
}
