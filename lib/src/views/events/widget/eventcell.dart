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
class EventCell extends StatefulWidget {
  EventCell({
    super.key,
    required this.eventData,
    required this.buttonFun,
  }) : con = PostController();
  Map eventData;
  Function buttonFun;

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
    print(eventAdminInfo);
    if (eventAdminInfo!['paywall']['interestMyEvent'] == null ||
        eventAdminInfo['paywall']['interestMyEvent'] == '0' ||
        widget.eventData['data']['groupAdmin'][0]['uid'] ==
            UserManager.userInfo['uid']) {
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
                        eventAdminInfo['paywall']['interestMyEvent'],
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
              header: 'Pay token for interested or uninterested this page',
              text:
                  'Admin of this event set price is ${eventAdminInfo['paywall']['interestMyEvent']} for interested or uninterested this page',
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
                            text: widget.eventData['data']['eventName'],
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacementNamed(context,
                                    '/events/${widget.eventData['id']}');
                              }),
                      ]),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 5)),
                    Text(
                      '${widget.eventData['data']['eventInterested'].length} Interested',
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
                                  widget.eventData['interested']
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
              //   child: SvgPicture.network(
              //       widget.picture == '' ? Helper.eventImage : widget.picture),
              // ),
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                    radius: 75,
                    backgroundImage: NetworkImage(
                        widget.eventData['data']['eventPicture'] == ''
                            ? Helper.eventImage
                            : widget.eventData['data']['eventPicture'])),
              )
            ],
          ),
        )
      ],
    );
  }
}
