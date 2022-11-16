// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';
import '../../controllers/ChatController.dart';

class EmoticonScreen extends StatefulWidget {
  Function onBack;
  EmoticonScreen({Key? key, required this.onBack})
      : con = ChatController(),
        super(key: key);
  late ChatController con;
  @override
  State createState() => EmoticonScreenState();
}

class ChatMessage {
  String messageContent;
  String messageType;
  ChatMessage({required this.messageContent, required this.messageType});
}

class EmoticonScreenState extends mvc.StateMVC<EmoticonScreen> {
  bool check1 = false;
  bool check2 = false;
  late ChatController con;
  late ScrollController _scrollController;
  var isMessageTap = 'all-list';
  var r = 0;
  var t = [];

  late Stream stream;
  @override
  void initState() {
    add(widget.con);
    con = controller as ChatController;
    super.initState();
    _scrollController = ScrollController();
    if (con.emojiList.isEmpty) {
      FirebaseFirestore.instance.collection(Helper.emoticons).get().then(
        (value) {
          for (int i = 0; i < value.docs.length; i++) {
            print(value.docs[i]['emoticon']);
            if ((i + 1) % 10 != 0) {
              t.add(value.docs[i]['emoticon']);
            }
            if ((i + 1) % 10 == 0 || i == value.docs.length - 1) {
              con.emojiList.add(Row(
                children: t
                    .map((value) => MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                  width: 30,
                                  height: 30,
                                  padding: EdgeInsets.all(5),
                                  child: SvgPicture.network(value.toString()))),
                        ))
                    .toList(),
              ));
              t = [];
            }
          }
          setState(() {});
        },
      );
    }
  }

  String dropdownValue = 'Male';
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(220, 220, 220, 230),
            blurRadius: 1,
            spreadRadius: 1,
            offset: Offset(
              1,
              1,
            ),
          )
        ],
      ),
      padding: EdgeInsets.all(5),
      width: 290,
      height: 200,
      child: EmojiPicker(
          onEmojiSelected: (category, emoji) {
            widget.onBack(false);
          },
          textEditingController: con.textController,
          config: Config(
            columns: 7,
            // Issue: https://github.com/flutter/flutter/issues/28894
            emojiSizeMax: 16,
            verticalSpacing: 0,
            horizontalSpacing: 0,
            gridPadding: EdgeInsets.zero,
            initCategory: Category.SMILEYS,
            bgColor: Colors.white,
            indicatorColor: Colors.blue,
            iconColor: Colors.grey,
            iconColorSelected: Colors.blue,
            backspaceColor: Colors.blue,
            skinToneDialogBgColor: Colors.white,
            skinToneIndicatorColor: Colors.white,
            enableSkinTones: true,
            showRecentsTab: true,
            recentsLimit: 28,
            replaceEmojiOnLimitExceed: false,
            noRecents: const Text(
              'No Recents',
              style: TextStyle(fontSize: 20, color: Colors.black26),
              textAlign: TextAlign.center,
            ),
            loadingIndicator: const SizedBox.shrink(),
            tabIndicatorAnimDuration: kTabScrollDuration,
            categoryIcons: const CategoryIcons(),
            buttonMode: ButtonMode.MATERIAL,
            checkPlatformCompatibility: true,
          )),
    );
  }
}
