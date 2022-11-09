// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/widget/primaryInput.dart';

import '../../controllers/ChatController.dart';
import '../../models/chatModel.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key})
      : con = ChatController(),
        super(key: key);
  late ChatController con;
  State createState() => ChatScreenState();
}

class ChatScreenState extends mvc.StateMVC<ChatScreen> {
  bool check1 = false;
  bool check2 = false;
  late ChatController con;
  @override
  void initState() {
    add(widget.con);
    con = controller as ChatController;
    super.initState();
  }

  // Stream<QuerySnapshot<ChatModel>> getLoginedUsers() {
  //   return transactionCollection
  //       .where('from-to', arrayContains: con.paymail)
  //       //.orderBy("date")
  //       .snapshots();
  // }
  String dropdownValue = 'Male';
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Stack(children: [
      Container(
        width: 200,
        margin: const EdgeInsets.only(top: 25),
        height: SizeConfig(context).screenHeight - 100,
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
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 6, left: 15),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                color: Color.fromRGBO(220, 220, 220, 1),
              ))),
              height: 40,
              width: double.infinity,
              child: Row(children: [
                Text(
                  'Chat',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: SizedBox(),
                ),
                GestureDetector(
                  onTap: (() {
                    con.chatBoxs.add({'type': 'new'});
                    con.setState(() {});
                  }),
                  child: Icon(
                    Icons.edit_calendar_rounded,
                    size: 15,
                  ),
                ),
                GestureDetector(
                  onTap: (() {}),
                  child: Icon(Icons.settings, size: 15),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                )
              ]),
              //       StreamBuilder(
              // // stream: getLoginedUsers(),
              // builder: (context, snapshot) {
              //   if (snapshot.hasData && snapshot.data != null) {
              //     List<QueryDocumentSnapshot<ChatModel>>? datas =
              //         snapshot.data?.docs;
              //     return ListView.builder(
              //         padding: const EdgeInsets.all(8),
              //         itemCount: snapshot.data?.docs.length,
              //         itemBuilder: (BuildContext context, int index) {
              //           TransactionC t = datas![index].data();
              //           return ListTile(
              //             contentPadding:
              //                 const EdgeInsets.only(top: 10, bottom: 10, right: 10),
              //             leading: const CircleAvatar(
              //               backgroundColor: Colors.amber,
              //               child: Text('1'),
              //             ),
              //             title: Text(t.from != con.paymail ? t.from : t.to),
              //             subtitle: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Text(
              //                     t.from != con.paymail ? 'Received' : 'Sent by you'),
              //                 Text(t.date.toString())
              //               ],
              //             ),
              //             trailing: t.from != con.paymail
              //                 ? Text('${t.amount} BNF')
              //                 : Text(
              //                     '-${t.amount} BNF',
              //                     style: const TextStyle(color: Colors.red),
              //                   ),
              //           );
              //         });
              //   } else {
              //     return const Center(child: CircularProgressIndicator());
              //   }
              // });
            )
          ],
        ),
      )
    ]));
  }
}
