import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/SearcherController.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/GeolocationManager.dart';
import 'package:shnatter/src/routes/mainRouter.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/views/box/searchbox.dart';
import 'package:shnatter/src/views/chat/chatScreen.dart';
import 'package:shnatter/src/views/navigationbar.dart';
import 'package:shnatter/src/views/panel/leftpanel.dart';

import '../helpers/emailverified.dart';
import '../utils/size_config.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key})
      : con = UserController(),
        super(key: key);
  final UserController con;

  @override
  State createState() => MainScreenState();
}

class MainScreenState extends mvc.StateMVC<MainScreen>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  bool showSearch = false;
  late FocusNode searchFocusNode;
  bool showMenu = false;
  bool showSideBar = false;
  bool isEmailVerify = true;
  late AnimationController _drawerSlideController;
  String searchText = '';
  List searchResult = [];
  Map mainRouterValue = {
    'router': RouteNames.homePage,
  };
  late UserController con;

  @override
  void initState() {
    GeolocationManager.startGeoTimer();

    add(widget.con);
    con = controller as UserController;

    // print(UserManager.userInfo);
    super.initState();
    () async {
      var user = FirebaseAuth.instance.currentUser!;
      EmailVerified.setVerified(user.emailVerified);
    }();

    triggerEmailVerify();
    searchFocusNode = FocusNode();
    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    searchController.addListener(() {
      searchText = searchController.text;

      setState(() {});
    });
  }

  void onSearchBarFocus() {
    searchFocusNode.requestFocus();
    setState(() {
      showSearch = true;
    });
  }

  void clickMenu() {
    if (_isDrawerOpen() || _isDrawerOpening()) {
      _drawerSlideController.reverse();
      setState(() {
        showSideBar = false;
      });
    } else {
      _drawerSlideController.forward();
      setState(() {
        showSideBar = true;
      });
    }
  }

  void onSearchBarDismiss() {
    if (showSearch) {
      setState(() {
        showSearch = false;
      });
    }
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

  routerChange(value) {
    print("call route change now $value");
    showSideBar = false;
    mainRouterValue = value;
    _drawerSlideController.reverse();

    setState(() {});
  }

  textChange(value) {
    searchText = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      drawerEnableOpenDragGesture: false,
      drawer: const Drawer(),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            ShnatterNavigation(
              searchController: searchController,
              onSearchBarFocus: onSearchBarFocus,
              onSearchBarDismiss: onSearchBarDismiss,
              drawClicked: clickMenu,
              routerChange: routerChange,
              textChange: textChange,
            ),
            Padding(
              padding: const EdgeInsets.only(top: SizeConfig.navbarHeight),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    isEmailVerify ? const SizedBox() : emailVerificationNoify(),
                    Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizeConfig(context).screenWidth <
                                        SizeConfig.mediumScreenSize ||
                                    mainRouterValue['router'] ==
                                        'RouteNames.photos'
                                ? const SizedBox()
                                : LeftPanel(
                                    routerFunction: routerChange,
                                    router: mainRouterValue,
                                  ),
                            MainRouter.mainRouter(
                                mainRouterValue, routerChange),
                          ],
                        ),
                      ],
                    ),
                    // kIsWeb ? Container(height: 35) : Container(),
                  ],
                ),
              ),
            ),
            if (showSideBar == true)
              GestureDetector(
                onTap: () {
                  _drawerSlideController.reverse();
                  setState(() {
                    showSideBar = false;
                  });
                },
                child:
                    Container(color: const Color.fromARGB(41, 236, 236, 236)),
              ),
            AnimatedBuilder(
              animation: _drawerSlideController,
              builder: (context, child) {
                return FractionalTranslation(
                    translation: SizeConfig(context).screenWidth >
                            SizeConfig.mediumScreenSize
                        ? const Offset(0, 0)
                        : Offset(_drawerSlideController.value * 0.001, 0.0),
                    child: SizeConfig(context).screenWidth >
                                SizeConfig.mediumScreenSize ||
                            _isDrawerClosed()
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(
                                top: SizeConfig.navbarHeight),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  color: Colors.white,
                                  width: SizeConfig.leftToggleBar,
                                  child: SingleChildScrollView(
                                    child: LeftPanel(
                                      routerFunction: routerChange,
                                      router: mainRouterValue,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ));
              },
            ),
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
                                  onChanged: (value) async {
                                    searchText = value;

                                    await SearcherController()
                                        .updateSearchText(value);
                                    await SearcherController()
                                        .getEvents(searchText);
                                    await SearcherController()
                                        .getGroups(searchText);
                                    await SearcherController()
                                        .getUsers(searchText);
                                    if (value != '') {
                                      // SearcherController().users = [
                                      //   ...SearcherController().usersByFirstName,
                                      //   ...SearcherController()
                                      //       .usersByFirstNameCaps,
                                      //   ...SearcherController().usersByLastName,
                                      //   ...SearcherController()
                                      //       .usersByLastNameCaps,
                                      //   ...SearcherController().usersByWholeName,
                                      //   ...SearcherController()
                                      //       .usersByWholeNameCaps,
                                      // ];

                                      SearcherController().users = [
                                        ...{...SearcherController().users}
                                      ];
                                      searchResult = [
                                        ...SearcherController().users,
                                        ...SearcherController().events,
                                        ...SearcherController().groups
                                      ];
                                    } else {
                                      searchResult = [];
                                    }
                                    setState(() {});
                                  },
                                  controller: searchController,
                                  cursorColor: Colors.white,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.search,
                                        color:
                                            Color.fromARGB(150, 170, 212, 255),
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
                          ShnatterSearchBox(
                            routerChange: routerChange,
                            hideSearch: () {
                              setState(() {
                                showSearch = false;
                              });
                            },
                            searchText: searchText,
                            searchResult: searchResult,
                          )
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
            ChatScreen(),
          ],
        ),
      ),
    );
  }

  Widget emailVerificationNoify() {
    return Container(
      width: SizeConfig(context).screenWidth,
      height: 50,
      color: Colors.redAccent,
      padding: const EdgeInsets.only(left: 30, top: 3),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                alignment: Alignment.center,
                width: SizeConfig(context).screenWidth * 0.7 - 30,
                child: const Text(
                  'You have not completed the email verification',
                  style: TextStyle(color: Colors.white),
                )),
            const Flexible(fit: FlexFit.tight, child: SizedBox()),
            Container(
              alignment: Alignment.center,
              width: SizeConfig(context).screenWidth * 0.3,
              child: TextButton(
                  onPressed: () async {
                    con.reSendEmailVeryfication();
                    Helper.showToast('Email sent');
                  },
                  child: const Text(
                    '> Resend email',
                    style: TextStyle(color: Colors.white),
                  )),
            )
          ]),
    );
  }

  triggerEmailVerify() async {
    con.timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await FirebaseAuth.instance.currentUser!.reload();
      // ignore: await_only_futures
      var user = await FirebaseAuth.instance.currentUser!;

      if (user.emailVerified) {
        setState(() {
          isEmailVerify = true;
        });
        timer.cancel();
      } else {
        setState(() {
          isEmailVerify = false;
        });
      }
    });
  }
}
