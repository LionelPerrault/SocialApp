// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/MessageController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/messageBoard/widget/writeMessageScreen.dart';
import 'package:shnatter/src/widget/messageAudioPlayer.dart';

import 'emoticonScreen.dart';

// ignore: must_be_immutable
class ChatMessageListScreen extends StatefulWidget {
  Function onBack;
  ChatMessageListScreen(
      {Key? key, required this.onBack, required this.showWriteMessage})
      : con = MessageController(),
        super(key: key);
  late MessageController con;
  bool showWriteMessage;
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
  late MessageController con;
  late ScrollController _scrollController;
  var isMessageTap = 'all-list';
  var r = 0;
  int verifyAlertHeight = 50;
  late Stream stream;
  bool showEmojicon = false;

  @override
  void initState() {
    add(widget.con);
    con = controller as MessageController;
    super.initState();
    _scrollController = ScrollController();
    stream = FirebaseFirestore.instance
        .collection(Helper.message)
        .doc(con.docId)
        .collection('content')
        .orderBy('timeStamp', descending: false)
        .snapshots();
    stream.listen((event) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
        );
      });
      if (con.docId != '') {
        FirebaseFirestore.instance
            .collection(Helper.message)
            .doc(con.docId)
            .update({con.chatUserFullName: 0});
      }
    });
  }

  String dropdownValue = 'Male';
  @override
  Widget build(BuildContext context) {
    final viewInsets = EdgeInsets.fromWindowPadding(
        WidgetsBinding.instance.window.viewInsets,
        WidgetsBinding.instance.window.devicePixelRatio);
    return Container(
        color: Colors.white,
        child: con.docId == ''
            ? const Center(child: CircularProgressIndicator())
            : StreamBuilder(
                stream: stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    var messageList = snapshot.data!.docs;
                    return Stack(children: [
                      GestureDetector(
                        onTap: () {
                          showEmojicon = false;
                          con.isShowEmoticon = false;
                          setState(() {});
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: (UserManager.userInfo['isVerify']
                                      ? SizeConfig(context).screenHeight -
                                          SizeConfig.navbarHeight * 2 -
                                          130 -
                                          viewInsets.bottom
                                      : SizeConfig(context).screenHeight -
                                          SizeConfig.navbarHeight * 2 -
                                          130 -
                                          verifyAlertHeight -
                                          viewInsets.bottom) -
                                  (Helper.isIOS ? 10 : 0),
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: messageList.length,
                                itemBuilder: (context, index) {
                                  var list = messageList[index].data();

                                  var me = UserManager.userInfo['userName'];
                                  return Container(
                                    padding: EdgeInsets.only(
                                        top: 5, bottom: 5, left: 15, right: 15),
                                    child: Align(
                                        alignment: (list['sender'] != me
                                            ? Alignment.topLeft
                                            : Alignment.topRight),
                                        child: list['sender'] != me
                                            ? Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                    con.avatar == ''
                                                        ? CircleAvatar(
                                                            radius: 22,
                                                            child: SvgPicture
                                                                .network(Helper
                                                                    .avatar),
                                                          )
                                                        : CircleAvatar(
                                                            radius: 22,
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    con.avatar),
                                                          ),
                                                    list['type'] == 'text'
                                                        ? Container(
                                                            constraints:
                                                                BoxConstraints(
                                                                    minWidth:
                                                                        30,
                                                                    maxWidth:
                                                                        200),
                                                            margin:
                                                                EdgeInsets.only(
                                                              left: 10,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        15),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        15),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            15),
                                                              ),
                                                              color: (list[
                                                                          'sender'] ==
                                                                      me
                                                                  ? Color
                                                                      .fromRGBO(
                                                                          219,
                                                                          241,
                                                                          255,
                                                                          1)
                                                                  : Color
                                                                      .fromRGBO(
                                                                          242,
                                                                          246,
                                                                          249,
                                                                          1)),
                                                            ),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child: Text(
                                                              list['data'],
                                                              style: TextStyle(
                                                                  fontSize: 13),
                                                            ))
                                                        : list['type'] ==
                                                                'image'
                                                            ? Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10,
                                                                        top: 5),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topRight: Radius
                                                                        .circular(
                                                                            15),
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            15),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            15),
                                                                  ),
                                                                  child: Image
                                                                      .network(
                                                                    list[
                                                                        'data'],
                                                                    width: 150,
                                                                  ),
                                                                ),
                                                              )
                                                            : MessageAudioPlayer(
                                                                audioURL: list[
                                                                    'data'])
                                                  ])
                                            : list['type'] == 'text'
                                                ? Container(
                                                    constraints: BoxConstraints(
                                                        minWidth: 30,
                                                        maxWidth: 200),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(15),
                                                        topRight:
                                                            Radius.circular(15),
                                                        bottomLeft:
                                                            Radius.circular(15),
                                                      ),
                                                      color: (list['sender'] ==
                                                              me
                                                          ? Color.fromRGBO(
                                                              219, 241, 255, 1)
                                                          : Color.fromRGBO(242,
                                                              246, 249, 1)),
                                                    ),
                                                    padding: EdgeInsets.all(10),
                                                    child: Text(
                                                      list['data'],
                                                      style: TextStyle(
                                                          fontSize: 13),
                                                    ))
                                                : list['type'] == 'image'
                                                    ? ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  15),
                                                          topRight:
                                                              Radius.circular(
                                                                  15),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  15),
                                                        ),
                                                        child: Image.network(
                                                          list['data'],
                                                          width: 150,
                                                        ),
                                                      )
                                                    : MessageAudioPlayer(
                                                        audioURL:
                                                            list['data'])),
                                  );
                                },
                              ),
                            ),
                            WriteMessageScreen(
                              type: con.isMessageTap == 'new' ? 'new' : 'old',
                              goMessage: (value) {
                                showEmojicon = value;

                                setState(() {});
                                widget.onBack(showEmojicon);
                              },
                            ),
                          ],
                        ),
                      ),
                      showEmojicon
                          ? Positioned(
                              bottom: 60,
                              left: 0,
                              child: EmoticonScreen(onBack: (value) {
                                con.isShowEmoticon = value;
                                showEmojicon = value;
                                setState(() {});
                              }))
                          : Container(),
                    ]);
                  } else {
                    return SizedBox(
                        height: SizeConfig(context).screenHeight - 205,
                        child: Center(child: CircularProgressIndicator()));
                  }
                }));
  }
}
