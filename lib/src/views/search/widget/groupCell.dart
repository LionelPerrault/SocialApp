// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/widget/alertYesNoWidget.dart';

// ignore: must_be_immutable
class SearchGroupCell extends StatefulWidget {
  SearchGroupCell({
    super.key,
    required this.groupInfo,
    required this.routerChange,
  }) : con = PostController();
  Map groupInfo;
  Function routerChange;

  late PostController con;
  @override
  State createState() => SearchGroupCellState();
}

class SearchGroupCellState extends mvc.StateMVC<SearchGroupCell> {
  late PostController con;
  bool joined = false;
  bool loading = false;
  bool payLoading = false;
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as PostController;
    joined = con.boolJoined(widget.groupInfo, UserManager.userInfo['uid']);
  }

  groupJoinFunc() async {
    var groupAdminInfo = await ProfileController()
        .getUserInfo(widget.groupInfo['groupAdmin'][0]['uid']);
    if (groupAdminInfo!['paywall'][UserManager.userInfo['uid']] == null ||
        groupAdminInfo['paywall'][UserManager.userInfo['uid']] == '0' ||
        joined ||
        widget.groupInfo['groupAdmin'][0]['uid'] ==
            UserManager.userInfo['uid']) {
      loading = true;
      joined = !joined;
      setState(() {});
      await con.joinedGroup(widget.groupInfo['uid']);
      loading = false;
      setState(() {});
      print("joined function1");
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
                        groupAdminInfo['paymail'].toString(),
                        groupAdminInfo['paywall'][UserManager.userInfo['uid']],
                        'Pay for view profile of user')
                    .then(
                      (value) async => {
                        if (value)
                          {
                            payLoading = false,
                            setState(() {}),
                            Navigator.of(context).pop(true),
                            loading = true,
                            setState(() {}),
                            await con.joinedGroup(widget.groupInfo['uid']),
                            loading = false,
                            joined = !joined,
                            setState(() {}),
                          }
                      },
                    );
              },
              noFunc: () {
                Navigator.of(context).pop(true);
              },
              header: 'Pay token for paywall',
              text:
                  'Admin of this group set paywall price is ${groupAdminInfo['paywall'][UserManager.userInfo['uid']]}',
              progress: payLoading),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 10, right: 10),
        leading: GestureDetector(
          child: CircleAvatar(
              radius: 17,
              backgroundImage: NetworkImage(
                  widget.groupInfo['groupPicture'] == ''
                      ? Helper.groupImage
                      : widget.groupInfo['groupPicture'])),
          onTap: () {
            widget.routerChange({
              'router': RouteNames.groups,
              'subRouter': widget.groupInfo['uid']
            });
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                children: <TextSpan>[
                  TextSpan(
                      text: widget.groupInfo['groupName'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          widget.routerChange({
                            'router': RouteNames.groups,
                            'subRouter': widget.groupInfo['uid']
                          });
                        })
                ],
              ),
            ),
            Text(
              '${widget.groupInfo['groupJoined'].length} Members',
              style: const TextStyle(
                fontSize: 13,
              ),
            )
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () async {
            groupJoinFunc();
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 33, 37, 41),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.0)),
              minimumSize: loading ? const Size(60, 35) : const Size(87, 35),
              maximumSize: loading ? const Size(60, 35) : const Size(87, 35)),
          child: loading
              ? const SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : joined
                  ? const Row(
                      children: [
                        Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 18.0,
                        ),
                        Text(' Joined',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w900)),
                      ],
                    )
                  : const Row(
                      children: [
                        Icon(
                          Icons.person_add,
                          color: Colors.white,
                          size: 18.0,
                        ),
                        Text(' Join',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w900)),
                      ],
                    ),
        ),
      ),
    );
  }
}
