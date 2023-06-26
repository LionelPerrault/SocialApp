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
class SearchEventCell extends StatefulWidget {
  SearchEventCell({
    super.key,
    required this.eventInfo,
    required this.routerChange,
  }) : con = PostController();
  Map eventInfo;
  Function routerChange;

  late PostController con;
  @override
  State createState() => SearchEventCellState();
}

class SearchEventCellState extends mvc.StateMVC<SearchEventCell> {
  late PostController con;
  bool requestStatus = false;
  bool interested = false;
  bool loading = false;
  bool payLoading = false;
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as PostController;
    interested =
        con.boolInterested(widget.eventInfo, UserManager.userInfo['uid']);
  }

  eventInterestedFunc() async {
    var eventAdminInfo = await ProfileController()
        .getUserInfo(widget.eventInfo['eventAdmin'][0]['uid']);
    if (eventAdminInfo!['paywall'][UserManager.userInfo['uid']] == null ||
        eventAdminInfo['paywall'][UserManager.userInfo['uid']] == '0' ||
        interested ||
        widget.eventInfo['eventAdmin'][0]['uid'] ==
            UserManager.userInfo['uid']) {
      loading = true;
      setState(() {});
      await con.interestedEvent(widget.eventInfo['uid']).then((value) {});
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
                        eventAdminInfo['paymail'].toString(),
                        eventAdminInfo['paywall'][UserManager.userInfo['uid']],
                        'Pay for interested event of user')
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
                                .interestedEvent(widget.eventInfo['uid'])
                                .then((value) {}),
                            interested = !interested,
                            loading = false,
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
                  'Admin of this event set paywall price is ${eventAdminInfo['paywall'][UserManager.userInfo['uid']]}',
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
                  widget.eventInfo['eventPicture'] == ''
                      ? Helper.groupImage
                      : widget.eventInfo['eventPicture'])),
          onTap: () {
            widget.routerChange({
              'router': RouteNames.events,
              'subRouter': widget.eventInfo['uid']
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
                      text: widget.eventInfo['eventName'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          widget.routerChange({
                            'router': RouteNames.events,
                            'subRouter': widget.eventInfo['uid']
                          });
                        })
                ],
              ),
            ),
            Text(
              '${widget.eventInfo['eventInterested'].length} Interested',
              style: const TextStyle(
                fontSize: 13,
              ),
            )
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () async {
            // print(con.isFriendRequest);
            requestStatus = true;
            setState(() {});
            await eventInterestedFunc();
            requestStatus = false;
            interested = !interested;
            setState(() {});
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 33, 37, 41),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.0)),
              minimumSize:
                  requestStatus ? const Size(60, 35) : const Size(110, 35),
              maximumSize:
                  requestStatus ? const Size(60, 35) : const Size(110, 35)),
          child: requestStatus
              ? const SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : interested
                  ? const Row(
                      children: [
                        Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 18.0,
                        ),
                        Text(' Interesting',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w900)),
                      ],
                    )
                  : const Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 18.0,
                        ),
                        Text(' Interested',
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
