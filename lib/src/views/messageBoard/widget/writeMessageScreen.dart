// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/MessageController.dart';
import 'package:shnatter/src/managers/user_manager.dart';

// ignore: must_be_immutable
class WriteMessageScreen extends StatefulWidget {
  String type;
  Function goMessage;
  WriteMessageScreen({Key? key, required this.type, required this.goMessage})
      : con = MessageController(),
        super(key: key);
  final MessageController con;
  @override
  State createState() => WriteMessageScreenState();
}

class WriteMessageScreenState extends mvc.StateMVC<WriteMessageScreen> {
  bool check1 = false;
  bool check2 = false;
  bool isShift = false;
  bool isEnter = false;
  String data = '';
  late MessageController con;
  var userInfo = UserManager.userInfo;
  var emojiList = <Widget>[];
  late FocusNode _focusNode;
  var t = [];
  TextEditingController content = TextEditingController();
  @override
  void initState() {
    add(widget.con);
    con = controller as MessageController;
    _focusNode = FocusNode(
      onKey: (FocusNode node, RawKeyEvent evt) {
        if (!evt.isShiftPressed && evt.logicalKey.keyLabel == 'Enter') {
          if (evt is RawKeyDownEvent) {
            sendMessage();
          }
          return KeyEventResult.handled;
        } else {
          return KeyEventResult.ignored;
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        con.progress == 0
            ? Container()
            : AnimatedContainer(
                duration: Duration(milliseconds: 500),
                width: double.infinity,
                margin:
                    EdgeInsets.only(right: 300 - (300 * con.progress / 100)),
                height: 2,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(2))),
              ),
        SizedBox(
          height: 35,
          child: TextFormField(
            focusNode: _focusNode,
            controller: con.textController,
            onChanged: ((value) {
              data = value;
            }),
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
            MouseRegion(
              child: GestureDetector(
                onTap: () {
                  con.uploadImage(widget.type, 'image');
                  if (widget.type == 'new') {
                    widget.goMessage('message-list');
                  }
                },
                child: const Icon(
                  Icons.photo_size_select_actual_rounded,
                  size: 20,
                  color: Color.fromRGBO(175, 175, 175, 1),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: 10)),
            const Icon(
              Icons.mic,
              size: 20,
              color: Color.fromRGBO(175, 175, 175, 1),
            ),
            const Padding(padding: EdgeInsets.only(left: 10)),
            MouseRegion(
              child: GestureDetector(
                  onTap: () {
                    widget.goMessage(true);
                  },
                  child: Icon(
                    Icons.emoji_emotions,
                    size: 20,
                    color: Color.fromRGBO(175, 175, 175, 1),
                  )),
            ),
            Flexible(fit: FlexFit.tight, child: SizedBox()),
            ElevatedButton(
              onPressed: () async {
                sendMessage();
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

  sendMessage() async {
    if (con.textController.text.isEmpty) {
      setState(() {});
      return;
    }
    bool success =
        await con.sendMessage(widget.type, 'text', con.textController.text);
    if (widget.type == 'new' && success) {
      widget.goMessage('message-list');
    }
    if (con.chattingUser != '' && con.textController.text != '') {
      con.textController.text = '';
      setState(() {});
    }
    // ignore: empty_catches
  }
}
