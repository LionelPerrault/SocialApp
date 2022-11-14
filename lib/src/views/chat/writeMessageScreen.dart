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
import '../../helpers/helper.dart';
import '../../models/chatModel.dart';

class WriteMessageScreen extends StatefulWidget {
  String type;
  Function goMessage;
  WriteMessageScreen({Key? key, required this.type, required this.goMessage})
      : con = ChatController(),
        super(key: key);
  late ChatController con;
  State createState() => WriteMessageScreenState();
}

class WriteMessageScreenState extends mvc.StateMVC<WriteMessageScreen> {
  bool check1 = false;
  bool check2 = false;
  late ChatController con;
  var userInfo = UserManager.userInfo;
  var emojiList = <Widget>[];
  var t = [];
  TextEditingController content = TextEditingController();
  @override
  void initState() {
    add(widget.con);
    con = controller as ChatController;
    FirebaseFirestore.instance.collection(Helper.emoticons).get().then(
      (value) {
        for (int i = 0; i < value.docs.length; i++) {
          if ((i + 1) % 5 != 0) {
            t.add(value.docs[i]['emoticon']);
          }
          if ((i + 1) % 5 == 0 || i == value.docs.length - 1) {
            emojiList.add(Row(
              children: t
                  .map((value) => Container(
                        child: Image.network(value.toString()),
                      ))
                  .toList(),
            ));
            t = [];
          }
        }
        setState(() {});
      },
    );
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 35,
          child: TextFormField(
            controller: content,
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
              hintText: 'Write message',
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
            GestureDetector(
                onTap: () {
                  // PopupMenuButton(
                  //   onSelected: (value) {
                  //     // your logic
                  //   },
                  //   icon: Icon(
                  //     Icons.settings,
                  //     size: 16,
                  //   ),
                  //   position: PopupMenuPosition.under,
                  //   itemBuilder: (BuildContext bc) {
                  //     return const [
                  //       PopupMenuItem(
                  //         value: 'block',
                  //         child: Text(
                  //           "Manage Blocking",
                  //           style: TextStyle(fontSize: 14),
                  //         ),
                  //       ),
                  //       PopupMenuItem(
                  //         value: 'privacy',
                  //         child: Text(
                  //           "Privacy Settings",
                  //           style: TextStyle(fontSize: 14),
                  //         ),
                  //       ),
                  //       PopupMenuItem(
                  //         value: 'turn_off',
                  //         child: Text(
                  //           "Turn Off Chat",
                  //           style: TextStyle(fontSize: 14),
                  //         ),
                  //       )
                  //     ];
                  //   },
                  // )
                },
                child: Icon(
                  Icons.emoji_emotions,
                  size: 20,
                  color: Color.fromRGBO(175, 175, 175, 1),
                )),
            Flexible(fit: FlexFit.tight, child: SizedBox()),
            ElevatedButton(
              onPressed: () async {
                try {
                  bool success =
                      await con.sendMessage(widget.type, content.text);
                  if (widget.type == 'new' && success) {
                    print(con.docId);
                    widget.goMessage('message-list');
                  }
                  if (con.chattingUser != '' && content.text != '') {
                    content.text = '';
                    setState(() {});
                  }
                  // ignore: empty_catches
                } catch (e) {}
              },
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
      ],
    );
  }

  Widget EmojiList() {
    return Column(
      children: emojiList.map((e) => e).toList(),
    );
  }
}
