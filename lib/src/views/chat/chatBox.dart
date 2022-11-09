// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/widget/mprimary_button.dart';
import 'package:shnatter/src/widget/primaryInput.dart';

import '../../controllers/ChatController.dart';
import '../../models/chatModel.dart';

class ChatBoxScreen extends StatefulWidget {
  ChatBoxScreen({Key? key})
      : con = ChatController(),
        super(key: key);
  late ChatController con;
  State createState() => ChatBoxScreenState();
}

class ChatBoxScreenState extends mvc.StateMVC<ChatBoxScreen> {
  bool check1 = false;
  bool check2 = false;
  late ChatController con;
  var userInfo = UserManager.userInfo;
  @override
  void initState() {
    add(widget.con);
    con = controller as ChatController;
    setState(() {});
    super.initState();
  }

  // Stream<QuerySnapshot<ChatModel>> getLoginedUsers() {
  //   return transactionCollection
  //       .where('from-to', arrayContains: con.paymail)
  //       //.orderBy("date")
  //       .snapshots();
  // }
  @override
  Widget build(BuildContext context) {
    print(userInfo);

    return Container(
      margin: EdgeInsets.only(
          top: SizeConfig(context).screenHeight > 370
              ? SizeConfig(context).screenHeight - 370
              : 0),
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            height: 400,
            width: SizeConfig(context).screenWidth - 210,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              // ignore: prefer_is_empty
              // con.chatBoxs.map((e) => ClipRect(

              // )).toList()
              // con.chatBoxs.length != 0
              //     ? con.chatBoxs.map((value) =>
              //       Container()
              //     ).toList()
              //     : Container()
            ]),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child:
                FloatingActionButton(child: Icon(Icons.add), onPressed: () {}),
          )
        ],
      ),
    );
  }

  Widget userChattingBox() {
    return Container(
      width: 260,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
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
      child: Column(children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: Color.fromRGBO(51, 103, 214, 1),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(3), topRight: Radius.circular(3)),
          ),
          height: 45,
          child: Row(children: [
            Text(
              userInfo['userName'] ?? '',
              style: TextStyle(color: Colors.white),
            )
          ]),
        ),
        Container(
          height: 250,
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(
            color: Color.fromRGBO(220, 220, 220, 1),
          ))),
          child: ListView(),
        ),
        Container(
          height: 35,
          child: TextFormField(
            minLines: 1,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            style: TextStyle(fontSize: 12),
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: 'description',
              hintStyle: TextStyle(color: Colors.grey),
              contentPadding:
                  EdgeInsets.only(left: 15, bottom: 11, top: 0, right: 15),
            ),
          ),
        ),
        Container(
          child: Row(children: [
            const Padding(padding: EdgeInsets.only(left: 10)),
            const Icon(
              Icons.photo_size_select_actual_rounded,
              size: 20,
              color: Color.fromRGBO(175, 175, 175, 1),
            ),
            const Padding(padding: EdgeInsets.only(left: 10)),
            const Icon(
              Icons.mic,
              size: 20,
              color: Color.fromRGBO(175, 175, 175, 1),
            ),
            const Padding(padding: EdgeInsets.only(left: 10)),
            const Icon(
              Icons.emoji_emotions,
              size: 20,
              color: Color.fromRGBO(175, 175, 175, 1),
            ),
            Flexible(fit: FlexFit.tight, child: SizedBox()),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(33, 37, 41, 1),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)),
                  minimumSize: Size(60, 38),
                  maximumSize: Size(60, 38)),
              child: Text(
                'Send',
                style: TextStyle(color: Colors.white, fontSize: 11),
              ),
            ),
            const Padding(padding: EdgeInsets.only(right: 10)),
          ]),
        )
      ]),
    );
  }
}
