import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/views/messageBoard/widget/chatMessageListScreen.dart';
import 'package:shnatter/src/views/messageBoard/widget/chatUserListScreen.dart';
import 'package:shnatter/src/views/messageBoard/widget/newMessageScreen.dart';
import 'package:shnatter/src/views/messageBoard/widget/writeMessageScreen.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/views/navigationbar.dart';

import '../../controllers/ChatController.dart';
import '../../utils/size_config.dart';

class MessageScreen extends StatefulWidget {
  MessageScreen({Key? key, required this.routerChange, this.chatUser = ''})
      : con = ChatController(),
        super(key: key);
  ChatController? con;
  Function routerChange;
  String chatUser;

  @override
  State createState() => MessageScreenState();
}

class MessageScreenState extends mvc.StateMVC<MessageScreen>
    with SingleTickerProviderStateMixin {
  bool isShowChatUserList = false;
  bool isCheckConnect = true;
  late ChatController con;

  @override
  void initState() {
    add(widget.con);
    con = controller as ChatController;
    ProfileController().getUserInfo(widget.chatUser).then((value) => {
          if (value != null)
            {
              con.chatUserFullName =
                  '${value['firstName']}' + " " + '${value['lastName']}',
              con.isMessageTap = 'new',
              setState(() {}),
            }
        });

    super.initState();
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
    return Container(
      width: SizeConfig(context).screenWidth < SizeConfig.mediumScreenSize
          ? SizeConfig(context).screenWidth
          : SizeConfig(context).screenWidth - SizeConfig.leftBarWidth,
      height: SizeConfig(context).screenHeight - SizeConfig.navbarHeight,
      child: SingleChildScrollView(
        child: Column(
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
                            top: SizeConfig(context).screenHeight - 220),
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
        ),
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
                leading: Row(children: [
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
                      }),
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
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ]))
          ],
        ));
  }
}
