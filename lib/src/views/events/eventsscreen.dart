import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/views/box/searchbox.dart';
import 'package:shnatter/src/views/chat/chatScreen.dart';
import 'package:shnatter/src/views/events/panel/allevents.dart';
import 'package:shnatter/src/views/events/panel/goingevents.dart';
import 'package:shnatter/src/views/events/panel/interestedevents.dart';
import 'package:shnatter/src/views/events/panel/invitedevents.dart';
import 'package:shnatter/src/views/events/panel/myevents.dart';
import 'package:shnatter/src/views/navigationbar.dart';
import 'package:shnatter/src/views/panel/leftpanel.dart';
import 'package:shnatter/src/views/panel/rightpanel.dart';
import 'package:shnatter/src/widget/createEventWidget.dart';
import 'package:shnatter/src/widget/createPageWidget.dart';

import '../../controllers/PostController.dart';
import '../../utils/size_config.dart';
import '../../widget/mprimary_button.dart';
import '../../widget/list_text.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/gestures.dart';
import '../box/notification.dart';

class EventsScreen extends StatefulWidget {
  EventsScreen({Key? key, required this.routerChange})
      : con = PostController(),
        super(key: key);
  final PostController con;
  Function routerChange;

  @override
  State createState() => EventsScreenState();
}

class EventsScreenState extends mvc.StateMVC<EventsScreen>
    with SingleTickerProviderStateMixin {
  //route variable
  String eventSubRoute = '';
  late PostController con;

  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 20, left: 0),
                  child: Column(
                    children: [
                      Container(
                          width: SizeConfig(context).screenWidth >
                                  SizeConfig.mediumScreenSize
                              ? SizeConfig(context).screenWidth * 0.6
                              : SizeConfig(context).screenWidth * 1,
                          height: 70,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 1.0,
                                spreadRadius: 0.1,
                                offset: Offset(
                                  0.1,
                                  0.11,
                                ),
                              )
                            ],
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: SizeConfig(context).screenWidth >
                                        SizeConfig.mediumScreenSize
                                    ? SizeConfig(context).screenWidth * 0.4 + 40
                                    : SizeConfig(context).screenWidth * 0.9 -
                                        30,
                                child: Row(children: [
                                  const Padding(
                                      padding: EdgeInsets.only(left: 30)),
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          eventSubRoute = '';
                                          setState(() {});
                                        },
                                        child: GestureDetector(
                                            child: Container(
                                          alignment: Alignment.center,
                                          child: Column(children: [
                                            // Padding(
                                            //     padding: EdgeInsets.only(
                                            //         top: eventSubRoute == ''
                                            //             ? 26
                                            //             : 26)),
                                            Container(
                                                alignment: Alignment.center,
                                                child: const Text('Discover',
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 90, 90, 90),
                                                        fontSize: 14))),
                                            eventSubRoute == ''
                                                ? Container(
                                                    // margin:
                                                    //     const EdgeInsets.only(
                                                    //         top: 15),
                                                    width: 60,
                                                    height: 1,
                                                    color: Colors.black,
                                                  )
                                                : Container(
                                                    // margin:
                                                    //     const EdgeInsets.only(
                                                    //         top: 15),
                                                    )
                                          ]),
                                        )),
                                      ),
                                    ],
                                  )),
                                  const Padding(
                                      padding: EdgeInsets.only(left: 5)),
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          eventSubRoute = 'going';
                                          setState(() {});
                                        },
                                        child: GestureDetector(
                                            child: Container(
                                          alignment: Alignment.center,
                                          child: Column(children: [
                                            // Padding(
                                            //     padding: EdgeInsets.only(
                                            //         top:
                                            //             eventSubRoute == 'going'
                                            //                 ? 26
                                            //                 : 26)),
                                            Container(
                                                alignment: Alignment.center,
                                                child: const Text('Going',
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 90, 90, 90),
                                                        fontSize: 14))),
                                            eventSubRoute == 'going'
                                                ? Container(
                                                    // margin:
                                                    //     const EdgeInsets.only(
                                                    //         top: 26),
                                                    width: 60,
                                                    height: 1,
                                                    color: Colors.black,
                                                  )
                                                : Container(
                                                    // margin:
                                                    //     const EdgeInsets.only(
                                                    //         top: 26),
                                                    )
                                          ]),
                                        )),
                                      ),
                                    ],
                                  )),
                                  const Padding(
                                      padding: EdgeInsets.only(left: 5)),
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          eventSubRoute = 'interested';
                                          setState(() {});
                                        },
                                        child: GestureDetector(
                                            child: Container(
                                          alignment: Alignment.center,
                                          child: Column(children: [
                                            // Padding(
                                            //     padding: EdgeInsets.only(
                                            //         top: eventSubRoute ==
                                            //                 'interested'
                                            //             ? 26
                                            //             : 26)),
                                            Container(
                                                alignment: Alignment.center,
                                                child: const Text('Interested',
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 90, 90, 90),
                                                        fontSize: 14))),
                                            eventSubRoute == 'interested'
                                                ? Container(
                                                    // margin:
                                                    //     const EdgeInsets.only(
                                                    //         top: 26),
                                                    height: 1,
                                                    width: 70,
                                                    color: Colors.black,
                                                  )
                                                : Container(
                                                    // margin:
                                                    //     const EdgeInsets.only(
                                                    //         top: 26),
                                                    )
                                          ]),
                                        )),
                                      ),
                                    ],
                                  )),
                                  const Padding(
                                      padding: EdgeInsets.only(left: 5)),
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          eventSubRoute = 'invited';
                                          setState(() {});
                                        },
                                        child: GestureDetector(
                                            child: Container(
                                          alignment: Alignment.center,
                                          child: Column(children: [
                                            // Padding(
                                            //     padding: EdgeInsets.only(
                                            //         top: eventSubRoute ==
                                            //                 'invited'
                                            //             ? 26
                                            //             : 26)),
                                            Container(
                                                alignment: Alignment.center,
                                                child: const Text('Invited',
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 90, 90, 90),
                                                        fontSize: 14))),
                                            eventSubRoute == 'invited'
                                                ? Container(
                                                    // margin:
                                                    //     const EdgeInsets.only(
                                                    //         top: 26),
                                                    height: 1,
                                                    width: 60,
                                                    color: Colors.black,
                                                  )
                                                : Container(
                                                    // margin:
                                                    //     const EdgeInsets.only(
                                                    //         top: 26),
                                                    )
                                          ]),
                                        )),
                                      ),
                                    ],
                                  )),
                                  const Padding(
                                      padding: EdgeInsets.only(left: 5)),
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          eventSubRoute = 'manage';
                                          setState(() {});
                                        },
                                        child: GestureDetector(
                                            child: Container(
                                          alignment: Alignment.center,
                                          child: Column(children: [
                                            // Padding(
                                            //     padding: EdgeInsets.only(
                                            //         top: eventSubRoute ==
                                            //                 'manage'
                                            //             ? 26
                                            //             : 26)),
                                            Container(
                                                alignment: Alignment.center,
                                                child: const Text('My Events',
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 90, 90, 90),
                                                        fontSize: 14))),
                                            eventSubRoute == 'manage'
                                                ? Container(
                                                    // margin:
                                                    //     const EdgeInsets.only(
                                                    //         top: 26),
                                                    height: 1,
                                                    width: 75,
                                                    color: Colors.black,
                                                  )
                                                : Container(
                                                    // margin:
                                                    //     const EdgeInsets.only(
                                                    //         top: 26),
                                                    )
                                          ]),
                                        )),
                                      ),
                                    ],
                                  )),
                                ]),
                              ),
                              const Flexible(
                                  fit: FlexFit.tight, child: SizedBox()),
                              Container(
                                width: SizeConfig(context).screenWidth > 900
                                    ? 120
                                    : 50,
                                margin: const EdgeInsets.only(right: 20),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(3),
                                      backgroundColor: const Color.fromARGB(
                                          255, 45, 206, 137),
                                      // elevation: 3,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(3.0)),
                                      minimumSize: Size(
                                          SizeConfig(context).screenWidth > 900
                                              ? 120
                                              : 50,
                                          50),
                                      maximumSize: Size(
                                          SizeConfig(context).screenWidth > 900
                                              ? 120
                                              : 50,
                                          50),
                                    ),
                                    onPressed: () {
                                      (showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                  title: Row(
                                                    children: const [
                                                      Icon(
                                                        Icons.event,
                                                        color: Color.fromARGB(
                                                            255, 247, 159, 88),
                                                      ),
                                                      Text(
                                                        'Create New Event',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      ),
                                                    ],
                                                  ),
                                                  content: CreateEventModal(
                                                    context: context,
                                                    routerChange:
                                                        widget.routerChange,
                                                  ))));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.add_circle),
                                        const Padding(
                                            padding: EdgeInsets.only(left: 4)),
                                        SizeConfig(context).screenWidth > 900
                                            ? const Text('Create Event',
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold))
                                            : const SizedBox()
                                      ],
                                    )),
                              )
                            ],
                          ))
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
                eventSubRoute == ''
                    ? AllEvents(routerChange: widget.routerChange)
                    : const SizedBox(),
                eventSubRoute == 'going'
                    ? GoingEvents(routerChange: widget.routerChange)
                    : const SizedBox(),
                eventSubRoute == 'interested'
                    ? InterestedEvents(routerChange: widget.routerChange)
                    : const SizedBox(),
                eventSubRoute == 'invited'
                    ? InvitedEvents(routerChange: widget.routerChange)
                    : const SizedBox(),
                eventSubRoute == 'manage'
                    ? MyEvents(routerChange: widget.routerChange)
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
