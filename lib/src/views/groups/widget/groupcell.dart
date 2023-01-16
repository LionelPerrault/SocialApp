import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/widget/alertYesNoWidget.dart';

// ignore: must_be_immutable
class GroupCell extends StatefulWidget {
  GroupCell({
    super.key,
    required this.groupData,
    required this.refreshFunc,
  }) : con = PostController();
  var groupData;
  Function refreshFunc;

  late PostController con;
  @override
  State createState() => GroupCellState();
}

class GroupCellState extends mvc.StateMVC<GroupCell> {
  late PostController con;
  var loading = false;
  bool payLoading = false;
  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    // TODO: implement initState
    super.initState();
  }

  groupJoinFunc() async {
    print(widget.groupData['data']['groupAdmin'][0]['uid']);
    var groupAdminInfo = await ProfileController()
        .getUserInfo(widget.groupData['data']['groupAdmin'][0]['uid']);
    print(groupAdminInfo);
    if (groupAdminInfo!['paywall']['joinMyGroup'] == null ||
            groupAdminInfo['paywall']['joinMyGroup'] ==
                '0' /*||
        widget.groupData['data']['groupAdmin'][0]['uid'] ==
            UserManager.userInfo['uid']*/
        ) {
      loading = true;
      setState(() {});
      await con.joinedGroup(widget.groupData['id']).then((value) {
        widget.refreshFunc();
      });
      loading = false;
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
                        groupAdminInfo['paymail'].toString(),
                        groupAdminInfo['paywall']['joinMyGroup'],
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
                            await con
                                .joinedGroup(widget.groupData['id'])
                                .then((value) {
                              widget.refreshFunc();
                            }),
                            loading = false,
                            setState(() {}),
                          }
                      },
                    );
              },
              noFunc: () {
                Navigator.of(context).pop(true);
              },
              header: 'Pay token for join or unjoin this page',
              text:
                  'Admin of this group set price is ${groupAdminInfo['paywall']['joinMyGroup']} for join or unjoin this page',
              progress: payLoading),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          width: 200,
          height: 250,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                width: 200,
                margin: EdgeInsets.only(top: 60),
                padding: EdgeInsets.only(top: 70),
                decoration: BoxDecoration(
                  color: Colors.grey[350],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: widget.groupData['data']['groupName'],
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacementNamed(context,
                                    '/groups/${widget.groupData['data']['groupUserName']}');
                              }),
                      ]),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 5)),
                    Text(
                      '${widget.groupData['data']['groupJoined'].length} Members',
                      style: const TextStyle(color: Colors.black, fontSize: 13),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2.0)),
                            minimumSize: const Size(120, 35),
                            maximumSize: const Size(120, 35)),
                        onPressed: () {
                          groupJoinFunc();
                        },
                        child: loading
                            ? Container(
                                width: 10,
                                height: 10,
                                child: const CircularProgressIndicator(
                                  color: Colors.grey,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  widget.groupData['joined']
                                      ? const Icon(
                                          Icons.star,
                                          color: Colors.black,
                                          size: 18.0,
                                        )
                                      : Icon(
                                          widget.groupData['joined']
                                              ? Icons.check
                                              : Icons.group_add,
                                          color: Colors.black,
                                          size: 18.0,
                                        ),
                                  Text(
                                      widget.groupData['joined']
                                          ? 'Joined'
                                          : 'Join',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold)),
                                ],
                              )),
                    Padding(padding: EdgeInsets.only(top: 30))
                  ],
                ),
              ),
              // Container(
              //   alignment: Alignment.topCenter,
              //   width: 120,
              //   height: 120,
              //   padding: const EdgeInsets.all(2),
              //   decoration: BoxDecoration(
              //       color: Color.fromARGB(255, 150, 99, 99),
              //       borderRadius: BorderRadius.circular(60),
              //       border: Border.all(color: Colors.grey)),
              //   child: SvgPicture.network(Helper.groupImage),
              // ),
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                    radius: 75,
                    backgroundImage: NetworkImage(
                        widget.groupData['data']['groupPicture'] == ''
                            ? Helper.groupImage
                            : widget.groupData['data']['groupPicture'])),
              )
            ],
          ),
        )
      ],
    );
  }
}
