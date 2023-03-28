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

import '../../../utils/size_config.dart';

// ignore: must_be_immutable
class EventCell extends StatefulWidget {
  EventCell({
    super.key,
    required this.eventData,
    required this.buttonFun,
    required this.routerChange,
  }) : con = PostController();
  Map eventData;
  Function buttonFun;
  Function routerChange;

  late PostController con;
  @override
  State createState() => EventCellState();
}

class EventCellState extends mvc.StateMVC<EventCell> {
  late PostController con;
  bool loading = false;
  bool payLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    add(widget.con);
    con = controller as PostController;
  }

  eventInterestedFunc() async {
    print(widget.eventData['data']['eventAdmin'][0]['uid']);
    var eventAdminInfo = await ProfileController()
        .getUserInfo(widget.eventData['data']['eventAdmin'][0]['uid']);
    if (eventAdminInfo!['paywall'][UserManager.userInfo['uid']] == null ||
        eventAdminInfo['paywall'][UserManager.userInfo['uid']] == '0' ||
        widget.eventData['data']['eventAdmin'][0]['uid'] ==
            UserManager.userInfo['uid']) {
      print(widget.eventData['data']['eventAdmin'][0]['uid']);
      loading = true;
      setState(() {});
      await con.interestedEvent(widget.eventData['id']).then((value) {
        widget.buttonFun();
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
                                .interestedEvent(widget.eventData['id'])
                                .then((value) {
                              widget.buttonFun();
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          width: 288,
          height: 216,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                width: 260,
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
                            text: widget.eventData['data']['eventName'],
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                con.updateEvent();
                                widget.routerChange({
                                  'router': RouteNames.events,
                                  'subRouter': widget.eventData['id'],
                                });
                                setState(() {});
                              }),
                      ]),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 5)),
                    Text(
                      '${widget.eventData['data']['eventInterested'].length} Interested',
                      style: const TextStyle(color: Colors.black, fontSize: 13),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 5)),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2.0)),
                            minimumSize: const Size(120, 35),
                            maximumSize: const Size(120, 35)),
                        onPressed: () async {
                          eventInterestedFunc();
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
                                  !widget.eventData['interested']
                                      ? Icon(
                                          Icons.star,
                                          color: Colors.black,
                                          size: 18.0,
                                        )
                                      : Icon(
                                          Icons.check,
                                          color: Colors.black,
                                          size: 18.0,
                                        ),
                                  Text('Interested',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold)),
                                ],
                              )),
                    const Padding(padding: EdgeInsets.only(top: 5))
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
              //   child: SvgPicture.network(
              //       widget.picture == '' ? Helper.eventImage : widget.picture),
              // ),
              GestureDetector(
                  child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: GestureDetector(
                        onTap: () {
                          widget.routerChange({
                            'router': RouteNames.events,
                            'subRouter': widget.eventData['id'],
                          });
                        },
                        child: CircleAvatar(
                            radius: 75,
                            backgroundImage: NetworkImage(
                                widget.eventData['data']['eventPicture'] == ''
                                    ? Helper.eventImage
                                    : widget.eventData['data']
                                        ['eventPicture'])),
                      )))
            ],
          ),
        )
      ],
    );
  }
}
