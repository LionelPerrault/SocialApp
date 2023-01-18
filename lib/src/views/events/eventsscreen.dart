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
  EventsScreen({Key? key})
      : con = PostController(),
        super(key: key);
  final PostController con;

  @override
  State createState() => EventsScreenState();
}

class EventsScreenState extends mvc.StateMVC<EventsScreen>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  bool showSearch = false;
  late FocusNode searchFocusNode;
  bool showMenu = false;
  late AnimationController _drawerSlideController;
  var suggest = <String, bool>{
    'friends': true,
    'pages': true,
    'groups': true,
    'events': true
  };
  //route variable
  String eventSubRoute = '';

  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    super.initState();
    searchFocusNode = FocusNode();
    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  late PostController con;
  void onSearchBarFocus() {
    searchFocusNode.requestFocus();
    setState(() {
      showSearch = true;
    });
  }

  void clickMenu() {
    //setState(() {
    //  showMenu = !showMenu;
    //});
    //Scaffold.of(context).openDrawer();
    //print("showmenu is {$showMenu}");
    if (_isDrawerOpen() || _isDrawerOpening()) {
      _drawerSlideController.reverse();
    } else {
      _drawerSlideController.forward();
    }
  }

  void onSearchBarDismiss() {
    if (showSearch)
      setState(() {
        showSearch = false;
      });
  }

  bool _isDrawerOpen() {
    return _drawerSlideController.value == 1.0;
  }

  bool _isDrawerOpening() {
    return _drawerSlideController.status == AnimationStatus.forward;
  }

  bool _isDrawerClosed() {
    return _drawerSlideController.value == 0.0;
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    _drawerSlideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawerEnableOpenDragGesture: false,
        drawer: const Drawer(),
        body: Stack(
          fit: StackFit.expand,
          children: [
            ShnatterNavigation(
              searchController: searchController,
              onSearchBarFocus: onSearchBarFocus,
              onSearchBarDismiss: onSearchBarDismiss,
              drawClicked: clickMenu,
            ),
            Padding(
                padding: const EdgeInsets.only(top: SizeConfig.navbarHeight),
                child: SingleChildScrollView(
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizeConfig(context).screenWidth <
                                SizeConfig.mediumScreenSize
                            ? const SizedBox()
                            : LeftPanel(),
                        //    : SizedBox(width: 0),
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Column(
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.only(top: 20, left: 0),
                                  child: Column(
                                    children: [
                                      Container(
                                          width: SizeConfig(context)
                                                      .screenWidth >
                                                  SizeConfig.mediumScreenSize
                                              ? SizeConfig(context)
                                                      .screenWidth *
                                                  0.6
                                              : SizeConfig(context)
                                                      .screenWidth *
                                                  1,
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
                                                width: SizeConfig(context)
                                                            .screenWidth >
                                                        SizeConfig
                                                            .mediumScreenSize
                                                    ? SizeConfig(context)
                                                                .screenWidth *
                                                            0.4 +
                                                        40
                                                    : SizeConfig(context)
                                                                .screenWidth *
                                                            0.9 -
                                                        30,
                                                child: Row(children: [
                                                  const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 30)),
                                                  Expanded(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                          padding: EdgeInsets.only(
                                                              top:
                                                                  eventSubRoute ==
                                                                          ''
                                                                      ? 26
                                                                      : 26)),
                                                      InkWell(
                                                        onTap: () {
                                                          eventSubRoute = '';
                                                          setState(() {});
                                                        },
                                                        child: GestureDetector(
                                                            child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Column(
                                                              children: [
                                                                Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: const Text(
                                                                        'Discover',
                                                                        style: TextStyle(
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                90,
                                                                                90,
                                                                                90),
                                                                            fontSize:
                                                                                14))),
                                                                eventSubRoute ==
                                                                        ''
                                                                    ? Container(
                                                                        margin: const EdgeInsets.only(
                                                                            top:
                                                                                26),
                                                                        height:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      )
                                                                    : Container(
                                                                        margin: const EdgeInsets.only(
                                                                            top:
                                                                                26),
                                                                      )
                                                              ]),
                                                        )),
                                                      ),
                                                    ],
                                                  )),
                                                  const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 5)),
                                                  Expanded(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      Padding(
                                                          padding: EdgeInsets.only(
                                                              top: eventSubRoute ==
                                                                      'going'
                                                                  ? 26
                                                                  : 26)),
                                                      InkWell(
                                                        onTap: () {
                                                          eventSubRoute =
                                                              'going';
                                                          setState(() {});
                                                        },
                                                        child: GestureDetector(
                                                            child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Column(
                                                              children: [
                                                                Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: const Text(
                                                                        'Going',
                                                                        style: TextStyle(
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                90,
                                                                                90,
                                                                                90),
                                                                            fontSize:
                                                                                14))),
                                                                eventSubRoute ==
                                                                        'going'
                                                                    ? Container(
                                                                        margin: const EdgeInsets.only(
                                                                            top:
                                                                                26),
                                                                        height:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      )
                                                                    : Container(
                                                                        margin: const EdgeInsets.only(
                                                                            top:
                                                                                26),
                                                                      )
                                                              ]),
                                                        )),
                                                      ),
                                                    ],
                                                  )),
                                                  const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 5)),
                                                  Expanded(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                          padding: EdgeInsets.only(
                                                              top: eventSubRoute ==
                                                                      'interested'
                                                                  ? 26
                                                                  : 26)),
                                                      InkWell(
                                                        onTap: () {
                                                          eventSubRoute =
                                                              'interested';
                                                          setState(() {});
                                                        },
                                                        child: GestureDetector(
                                                            child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Column(
                                                              children: [
                                                                Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: const Text(
                                                                        'Interested',
                                                                        style: TextStyle(
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                90,
                                                                                90,
                                                                                90),
                                                                            fontSize:
                                                                                14))),
                                                                eventSubRoute ==
                                                                        'interested'
                                                                    ? Container(
                                                                        margin: const EdgeInsets.only(
                                                                            top:
                                                                                26),
                                                                        height:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      )
                                                                    : Container(
                                                                        margin: const EdgeInsets.only(
                                                                            top:
                                                                                26),
                                                                      )
                                                              ]),
                                                        )),
                                                      ),
                                                    ],
                                                  )),
                                                  const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 5)),
                                                  Expanded(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                          padding: EdgeInsets.only(
                                                              top: eventSubRoute ==
                                                                      'invited'
                                                                  ? 26
                                                                  : 26)),
                                                      InkWell(
                                                        onTap: () {
                                                          eventSubRoute =
                                                              'invited';
                                                          setState(() {});
                                                        },
                                                        child: GestureDetector(
                                                            child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Column(
                                                              children: [
                                                                Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: const Text(
                                                                        'Invited',
                                                                        style: TextStyle(
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                90,
                                                                                90,
                                                                                90),
                                                                            fontSize:
                                                                                14))),
                                                                eventSubRoute ==
                                                                        'invited'
                                                                    ? Container(
                                                                        margin: const EdgeInsets.only(
                                                                            top:
                                                                                26),
                                                                        height:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      )
                                                                    : Container(
                                                                        margin: const EdgeInsets.only(
                                                                            top:
                                                                                26),
                                                                      )
                                                              ]),
                                                        )),
                                                      ),
                                                    ],
                                                  )),
                                                  const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 5)),
                                                  Expanded(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                          padding: EdgeInsets.only(
                                                              top: eventSubRoute ==
                                                                      'manage'
                                                                  ? 26
                                                                  : 26)),
                                                      InkWell(
                                                        onTap: () {
                                                          eventSubRoute =
                                                              'manage';
                                                          setState(() {});
                                                        },
                                                        child: GestureDetector(
                                                            child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Column(
                                                              children: [
                                                                Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: const Text(
                                                                        'My Events',
                                                                        style: TextStyle(
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                90,
                                                                                90,
                                                                                90),
                                                                            fontSize:
                                                                                14))),
                                                                eventSubRoute ==
                                                                        'manage'
                                                                    ? Container(
                                                                        margin: const EdgeInsets.only(
                                                                            top:
                                                                                26),
                                                                        height:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      )
                                                                    : Container(
                                                                        margin: const EdgeInsets.only(
                                                                            top:
                                                                                26),
                                                                      )
                                                              ]),
                                                        )),
                                                      ),
                                                      // RichText(
                                                      //   text: TextSpan(
                                                      //       children: <
                                                      //           TextSpan>[
                                                      //         TextSpan(
                                                      //             text:
                                                      //                 'My Events',
                                                      //             style: const TextStyle(
                                                      //                 color: Color.fromARGB(
                                                      //                     255,
                                                      //                     90,
                                                      //                     90,
                                                      //                     90),
                                                      //                 fontSize:
                                                      //                     14),
                                                      //             recognizer:
                                                      //                 TapGestureRecognizer()
                                                      //                   ..onTap =
                                                      //                       () {
                                                      //                     eventSubRoute =
                                                      //                         'manage';
                                                      //                     setState(
                                                      //                         () {});
                                                      //                   }),
                                                      //       ]),
                                                      // ),
                                                      // eventSubRoute == 'manage'
                                                      //     ? Container(
                                                      //         margin:
                                                      //             const EdgeInsets
                                                      //                     .only(
                                                      //                 top: 26),
                                                      //         height: 1,
                                                      //         color:
                                                      //             Colors.black,
                                                      //       )
                                                      //     : const SizedBox()
                                                    ],
                                                  )),
                                                ]),
                                              ),
                                              const Flexible(
                                                  fit: FlexFit.tight,
                                                  child: SizedBox()),
                                              Container(
                                                width: SizeConfig(context)
                                                            .screenWidth >
                                                        900
                                                    ? 120
                                                    : 50,
                                                margin: const EdgeInsets.only(
                                                    right: 20),
                                                child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3),
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              45,
                                                              206,
                                                              137),
                                                      // elevation: 3,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          3.0)),
                                                      minimumSize: Size(
                                                          SizeConfig(context)
                                                                      .screenWidth >
                                                                  900
                                                              ? 120
                                                              : 50,
                                                          50),
                                                      maximumSize: Size(
                                                          SizeConfig(context)
                                                                      .screenWidth >
                                                                  900
                                                              ? 120
                                                              : 50,
                                                          50),
                                                    ),
                                                    onPressed: () {
                                                      (showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                                  context) =>
                                                              AlertDialog(
                                                                  title: Row(
                                                                    children: const [
                                                                      Icon(
                                                                        Icons
                                                                            .event,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            247,
                                                                            159,
                                                                            88),
                                                                      ),
                                                                      Text(
                                                                        'Create New Event',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontStyle:
                                                                                FontStyle.italic),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  content: CreateEventModal(
                                                                      context:
                                                                          context))));
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Icon(
                                                            Icons.add_circle),
                                                        const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 4)),
                                                        SizeConfig(context)
                                                                    .screenWidth >
                                                                900
                                                            ? const Text(
                                                                'Create Event',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold))
                                                            : const SizedBox()
                                                      ],
                                                    )),
                                              )
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(top: 20)),
                                eventSubRoute == ''
                                    ? AllEvents()
                                    : const SizedBox(),
                                eventSubRoute == 'going'
                                    ? GoingEvents()
                                    : const SizedBox(),
                                eventSubRoute == 'interested'
                                    ? InterestedEvents()
                                    : const SizedBox(),
                                eventSubRoute == 'invited'
                                    ? InvitedEvents()
                                    : const SizedBox(),
                                eventSubRoute == 'manage'
                                    ? MyEvents()
                                    : const SizedBox(),
                              ],
                            )),
                          ],
                        )),
                      ]),
                )),
            showSearch
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        showSearch = false;
                      });
                    },
                    child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: const Color.fromARGB(0, 214, 212, 212),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: const SizedBox(
                                      width: 20,
                                      height: 20,
                                    )),
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, right: 9),
                                  width: SizeConfig(context).screenWidth * 0.4,
                                  child: TextField(
                                    focusNode: searchFocusNode,
                                    controller: searchController,
                                    cursorColor: Colors.white,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.search,
                                          color: Color.fromARGB(
                                              150, 170, 212, 255),
                                          size: 20),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0)),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xff202020),
                                      hintText: 'Search',
                                      hintStyle: TextStyle(
                                          fontSize: 15.0, color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            ShnatterSearchBox()
                          ],
                        )),
                  )
                : const SizedBox(),
            ChatScreen(),
          ],
        ));
  }
}
