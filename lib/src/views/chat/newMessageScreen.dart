// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/chat/writeMessageScreen.dart';
import 'package:shnatter/src/widget/alertYesNoWidget.dart';
import '../../controllers/ChatController.dart';
import '../../helpers/helper.dart';

class NewMessageScreen extends StatefulWidget {
  Function onBack;
  NewMessageScreen({Key? key, required this.onBack})
      : con = ChatController(),
        super(key: key);
  late ChatController con;
  @override
  State createState() => NewMessageScreenState();
}

class NewMessageScreenState extends mvc.StateMVC<NewMessageScreen> {
  bool check1 = false;
  bool check2 = false;
  late ChatController con;
  var userInfo = UserManager.userInfo;
  var allUsersList = [];
  var searchUser = [];
  bool payLoading = false;

  @override
  void initState() {
    add(widget.con);
    FirebaseFirestore.instance
        .collection(Helper.userField)
        .get()
        .then((value) => {allUsersList = value.docs});
    con = controller as ChatController;
    con.chattingUser = '';
    con.setState(() {});
    setState(() {});
    super.initState();
  }

  bool showUserList = false;

  chatWithOtherUser(chatUserInfo) async {
    showUserList = false;
    setState(() {});
    if (chatUserInfo['paywall'][UserManager.userInfo['uid']] == null ||
        chatUserInfo['paywall'][UserManager.userInfo['uid']] == '0') {
      con.avatar = chatUserInfo['avatar'];
      con.chattingUser = chatUserInfo['userName'];
      con.newRFirstName = chatUserInfo['firstName'];
      con.newRLastName = chatUserInfo['lastName'];
      con.setState(() {});
      setState(() {});
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const SizedBox(),
          content: AlertYesNoWidget(
              yesFunc: () async {
                payLoading = true;
                setState(() {});
                await UserController()
                    .payShnToken(
                        chatUserInfo['paymail'].toString(),
                        chatUserInfo['paywall'][UserManager.userInfo['uid']],
                        'Pay for chat with other user')
                    .then(
                      (value) async => {
                        if (value)
                          {
                            payLoading = false,
                            setState(() {}),
                            con.avatar = chatUserInfo['avatar'],
                            con.chattingUser = chatUserInfo['userName'],
                            con.newRFirstName = chatUserInfo['firstName'],
                            con.newRLastName = chatUserInfo['lastName'],
                            con.setState(() {}),
                            setState(() {}),
                            Navigator.of(context).pop(true),
                          }
                      },
                    );
              },
              noFunc: () {
                Navigator.of(context).pop(true);
              },
              header: 'Pay token for like or unlike this page',
              text:
                  'Admin of this page set paywall price is ${chatUserInfo['paywall'][UserManager.userInfo['uid']]}',
              progress: payLoading),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      TextField(
        onChanged: ((value) async {
          var list = [];
          if (value == '') {
            searchUser = [];
            setState(() {});
            return;
          }
          for (int i = 0; i < allUsersList.length; i++) {
            if (allUsersList[i]['userName'].contains(value)) {
              var flag = 0;

              if (con.chatUserList.isEmpty) {
                if (allUsersList[i]['userName'] != userInfo['userName']) {
                  list.add(allUsersList[i]);
                }
              } else {
                for (int j = 0; j < con.chatUserList.length; j++) {
                  if (allUsersList[i]['userName'] == con.chatUserList[j] ||
                      allUsersList[i]['userName'] == userInfo['userName']) {
                    flag = 1;
                  }
                  if (con.chatUserList.length - 1 == j && flag != 1) {
                    list.add(allUsersList[i]);
                    print(allUsersList[i]['userName']);
                  }
                }
              }
            }
          }
          searchUser = list;
          showUserList = searchUser.isNotEmpty;
          setState(() {});
        }),
        decoration: InputDecoration(
          hintText: 'To :',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
          // Enabled Border
          enabledBorder: const UnderlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 0.1),
          ),
          // Focused Border
          focusedBorder: const UnderlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 0.1),
          ),
          // Error Border
          contentPadding: EdgeInsets.only(left: 15, right: 15),
          // Focused Error Border
          focusedErrorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 0.1),
          ),
        ),
      ),
      SizedBox(
          height: SizeConfig(context).screenHeight - 260,
          child: showUserList ? userList() : Container()),
      con.chattingUser == ''
          ? Container()
          : WriteMessageScreen(
              type: 'new',
              goMessage: (value) {
                widget.onBack(value);
                // con.docId = '';
              },
            )
    ]));
  }

  Widget userList() {
    return SingleChildScrollView(
        child: Column(
      children: searchUser
          .map((e) => ListTile(
                contentPadding: EdgeInsets.all(10),
                enabled: true,
                tileColor: con.chattingUser == e['userName']
                    ? Color.fromRGBO(240, 240, 240, 1)
                    : Colors.white,
                hoverColor: Color.fromRGBO(240, 240, 240, 1),
                onTap: () {
                  chatWithOtherUser(e);
                },
                leading: e['avatar'] == ''
                    ? CircleAvatar(
                        radius: 25,
                        child: SvgPicture.network(Helper.avatar),
                      )
                    : CircleAvatar(
                        radius: 25, backgroundImage: NetworkImage(e['avatar'])),
                title: Text(e['userName']),
              ))
          .toList(),
    ));
  }
}
