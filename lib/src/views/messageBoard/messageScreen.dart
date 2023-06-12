import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/views/messageBoard/widget/chatMessageListScreen.dart';
import 'package:shnatter/src/views/messageBoard/widget/chatUserListScreen.dart';
import 'package:shnatter/src/views/messageBoard/widget/newMessageScreen.dart';
import 'package:shnatter/src/views/messageBoard/widget/writeMessageScreen.dart';
import 'package:shnatter/src/helpers/helper.dart';

import '../../controllers/MessageController.dart';
import '../../utils/size_config.dart';

class MessageScreen extends StatefulWidget {
  MessageScreen({Key? key, required this.routerChange, this.chatUser = ''})
      : con = MessageController(),
        super(key: key);
  MessageController? con;
  Function routerChange;
  String chatUser;

  @override
  State createState() => MessageScreenState();
}

class MessageScreenState extends mvc.StateMVC<MessageScreen>
    with SingleTickerProviderStateMixin {
  bool isShowChatUserList = false;
  bool isCheckConnect = true;
  int verifyAlertToastHeight = 50;
  late MessageController con;
  late dynamic chatHistoryData;
  bool isCheckingChatHistory = true;

  @override
  void initState() {
    add(widget.con);

    con = controller as MessageController;
    if (widget.chatUser != "") {
      checkHistoryChat();
    }
    super.initState();
  }

  Future<void> checkHistoryChat() async {
    if (!mounted) return;

    dynamic value = await ProfileController().getUserInfo(widget.chatUser);
    QuerySnapshot chatHistoryData = await con.chatCollection
        .where("users", arrayContains: UserManager.userInfo['userName'])
        .get();
    List<QueryDocumentSnapshot> documents = chatHistoryData.docs;
    bool exist = false;

    for (QueryDocumentSnapshot document in documents) {
      if ((document.get('users')[0] == UserManager.userInfo['userName'] &&
              document.get('users')[1] == value['userName']) ||
          (document.get('users')[1] == UserManager.userInfo['userName'] &&
              document.get('users')[0] == value['userName'])) {
        exist = true;
        con.docId = document.id;
        con.chatUserFullName = value['firstName'] + ' ' + value['lastName'];
        con.avatar = value['avatar'];
        con.chattingUser = value['userName'];
        con.isMessageTap = "message-list";
        con.setState(() {});
      }
    }
    if (exist == false) {
      con.avatar = value['avatar'];
      con.chattingUser = value['userName'];
      con.newRFirstName = value['firstName'];
      con.newRLastName = value['lastName'];
      con.chatUserFullName = value['firstName'] + ' ' + value['lastName'];
      con.isMessageTap = "new";
      con.setState(() {});
    }
    isCheckingChatHistory = false;
    setState(() {});
  }

  void connectFrom(uidOfTarget) async {
    await con.connectFromMarketPlace(uidOfTarget);
    isCheckConnect = false;
    con.setState(() {});
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (isCheckConnect) {
      final uidOfTarget = ModalRoute.of(context)!.settings.arguments;
      if (uidOfTarget != null) {
        connectFrom(uidOfTarget);
      }
    }

    return MobileScreen();
  }

  Widget MobileScreen() {
    final viewInsets = EdgeInsets.fromWindowPadding(
        WidgetsBinding.instance.window.viewInsets,
        WidgetsBinding.instance.window.devicePixelRatio);
    return SizedBox(
      width: SizeConfig(context).screenWidth < SizeConfig.mediumScreenSize
          ? SizeConfig(context).screenWidth
          : SizeConfig(context).screenWidth - SizeConfig.leftBarWidth,
      // height: UserManager.userInfo['isVerify'] == false ||
      //         UserManager.userInfo['isVerify'].toString().toLowerCase() ==
      //             'null'
      //     ? (SizeConfig(context).screenHeight - SizeConfig.navbarHeight - 68)
      //     : (SizeConfig(context).screenHeight - SizeConfig.navbarHeight - 28),
      child: Container(
        child: widget.chatUser.isEmpty
            ? Column(
                children: [
                  con.isMessageTap == 'all-list'
                      ? NewMessageScreen(onBack: (value) {
                          if (value == true || value == false) {
                            isShowChatUserList = value;
                          } else {
                            con.isMessageTap = value;
                          }
                          con.setState(() {});
                          setState(() {});
                        })
                      : ChatScreenHeader(),
                  con.isMessageTap == 'all-list'
                      ? isShowChatUserList
                          ? const SizedBox()
                          : ChatUserListScreen(onBack: (value) {
                              con.isMessageTap = value;
                              con.setState(() {});
                              setState(() {});
                            })
                      : con.isMessageTap == 'new'
                          ? Padding(
                              padding: EdgeInsets.only(
                                  top: UserManager.userInfo['isVerify']
                                      ? SizeConfig(context).screenHeight -
                                          280 -
                                          viewInsets.bottom
                                      : SizeConfig(context).screenHeight -
                                          280 -
                                          viewInsets.bottom -
                                          verifyAlertToastHeight),
                              child: WriteMessageScreen(
                                type: 'new',
                                goMessage: (value) {
                                  con.isMessageTap = value;
                                  if (value == 'message-list') {
                                    isShowChatUserList = false;
                                  }
                                  setState(() {});
                                  con.setState(() {});
                                },
                              ),
                            )
                          : ChatMessageListScreen(
                              showWriteMessage: true,
                              onBack: (value) {
                                con.isShowEmoticon = value;
                                setState(() {});
                              },
                            ),
                ],
              )
            : isCheckingChatHistory
                ? const SizedBox()
                : Column(children: [
                    ChatScreenHeader(),
                    con.isMessageTap == 'new'
                        ? Padding(
                            padding: EdgeInsets.only(
                                top: UserManager.userInfo['isVerify']
                                    ? SizeConfig(context).screenHeight - 280
                                    : SizeConfig(context).screenHeight -
                                        280 -
                                        verifyAlertToastHeight),
                            child: WriteMessageScreen(
                              type: 'new',
                              goMessage: (value) {
                                con.isMessageTap = value;
                                if (value == 'message-list') {
                                  isShowChatUserList = false;
                                }
                                setState(() {});
                                con.setState(() {});
                              },
                            ),
                          )
                        : ChatMessageListScreen(
                            showWriteMessage: true,
                            onBack: (value) {
                              con.isShowEmoticon = value;
                              setState(() {});
                            },
                          ),
                  ]),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget ChatScreenHeader() {
    return SizedBox(
        width: SizeConfig(context).screenWidth,
        // height: SizeConfig.navbarHeight,
        child: Column(
          children: [
            AppBar(
                toolbarHeight: 60,
                backgroundColor: const Color.fromRGBO(51, 103, 214, 1),
                automaticallyImplyLeading: false,
                title: Row(
                  children: [
                    SizedBox(
                      width: 46,
                      height: 46,
                      child: con.avatar == ''
                          ? CircleAvatar(
                              radius: 23,
                              backgroundColor: Colors.blue,
                              child: SvgPicture.network(Helper.avatar))
                          : CircleAvatar(
                              radius: 23,
                              backgroundColor: Colors.blue,
                              backgroundImage: NetworkImage(con.avatar),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 5),
                      child: Text(
                        con.chatUserFullName,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )
                  ],
                ),
                leading:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () {
                        isShowChatUserList = false;
                        con.isMessageTap = 'all-list';
                        con.setState(() {});
                        setState(() {});
                        widget.routerChange(
                            {'router': RouteNames.messages, 'subRouter': ''});
                      }),
                ]))
          ],
        ));
  }
}
