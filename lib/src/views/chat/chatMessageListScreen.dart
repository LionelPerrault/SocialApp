// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
  ChatMessageListScreen({Key? key,required this.onBack})
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
    print(con.docId);
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
            'Message',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        body:
        Container(
          child: con.docId == '' ? const Center(child: CircularProgressIndicator())
           :StreamBuilder(
            stream: FirebaseFirestore.instance.collection(Helper.message).doc(con.docId).collection('content')
                    .orderBy('timeStamp', descending: false).snapshots(),
            builder: (context, snapshot) {
              
              if (snapshot.hasData && snapshot.data != null) {
                print(snapshot.data!.docs[0]['data']);
              var messageList = snapshot.data!.docs;
              return Column(children: [
                Container(
                  height: SizeConfig(context).screenHeight - 220,
                  padding: EdgeInsets.only(
                              left: 15, right: 25, top: 15, bottom: 15),
                  child: 
                ListView.builder(
                itemCount: messageList.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 10, bottom: 10),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var list = messageList[index].data();
                  print(list['data']);
                  var chatUserName = '';
                  var me = UserManager.userInfo['userName'];
                  return Container(
                          padding: EdgeInsets.only(
                             top: 5, bottom: 5),
                          child: Align(
                            alignment:
                                (list['sender'] != me
                                    ? Alignment.topLeft
                                    : Alignment.topRight),
                            child:list['sender'] != me ? Row(
                              children: [
                              CircleAvatar(
                                radius: 20,
                                child: SvgPicture.network(Helper.avatar),
                              ),
                              Container(
                              margin: EdgeInsets.only(left: 10,top: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: (list['sender'] == me
                                    ? Colors.grey.shade200
                                    : Colors.blue[200]),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Text(
                                list['data'],
                                style: TextStyle(fontSize: 13),
                              ),
                            )]) : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
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
              WriteMessageScreen(type:'notnew',goMessage: (){},)
              ]);
            }else {
              return const Center(child: CircularProgressIndicator());
          }
        })));
  }
}
