// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/widget/primaryInput.dart';

import '../controllers/ChatController.dart';
import '../models/chatModel.dart';

class ChatBoxScreen extends StatefulWidget {
  ChatBoxScreen({Key? key})
      : con = UserController(),
        super(key: key);
  late UserController con;
  State createState() => ChatBoxScreenState();
}

class ChatBoxScreenState extends mvc.StateMVC<ChatBoxScreen> {
  bool check1 = false;
  bool check2 = false;
  late UserController userCon;
  var userInfo = {};
  @override
  void initState() {
    add(widget.con);
    userCon = controller as UserController;
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
            height: 370,
            width: SizeConfig(context).screenWidth - 210,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Container(
                width: 250,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
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
                    height: 30,
                    color: Colors.blue,
                    child: Row(children: [Text(userInfo['userName'] ?? '')]),
                  ),
                  Container(
                    height: 200,
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      color: Color.fromRGBO(220, 220, 220, 1),
                    ))),
                    child: ListView(),
                  ),
                  Container(
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: 'description',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                      ),
                    ),
                  )
                ]),
              )
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
}
