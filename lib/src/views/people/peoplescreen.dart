// ignore_for_file: prefer_const_constructors

import 'package:badges/badges.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PeopleController.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/models/user.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/box/searchbox.dart';
import 'package:shnatter/src/views/chat/chatScreen.dart';
import 'package:shnatter/src/views/chat/chatUserListScreen.dart';
import 'package:shnatter/src/views/chat/emoticonScreen.dart';
import 'package:shnatter/src/views/chat/newMessageScreen.dart';
import 'package:shnatter/src/views/navigationbar.dart';
import 'package:shnatter/src/views/panel/leftpanel.dart';
import 'package:shnatter/src/views/people/discoverScreen.dart';
import 'package:shnatter/src/views/people/friendRequestsScreen.dart';
import 'package:shnatter/src/views/people/sendRequestsScreen.dart';

import '../../controllers/ChatController.dart';

class PeopleScreen extends StatefulWidget {
  PeopleScreen({Key? key})
      : con = PeopleController(),
        super(key: key);
  final PeopleController con;
  @override
  State createState() => PeopleScreenState();
}

class PeopleScreenState extends mvc.StateMVC<PeopleScreen>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  bool showSearch = false;
  late FocusNode searchFocusNode;
  bool showMenu = false;
  late AnimationController _drawerSlideController;
  late PeopleController con;
  final ScrollController _scrollController = ScrollController();
  //route variable
  String tabName = 'Discover';
  @override
  void initState() {
    add(widget.con);
    con = controller as PeopleController;
    Helper.getJSONPreference(Helper.userField)
        .then((value) async => {await con.getUserList(), setState(() {})});
    super.initState();

    searchFocusNode = FocusNode();
    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

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
        drawer: Drawer(),
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
                padding: EdgeInsets.only(top: SizeConfig.navbarHeight),
                child:
                    //AnimatedPositioned(
                    //top: showMenu ? 0 : -150.0,
                    //duration: const Duration(seconds: 2),
                    //curve: Curves.fastOutSlowIn,
                    //child:
                    SingleChildScrollView(
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizeConfig(context).screenWidth < 700
                            ? const SizedBox()
                            : LeftPanel(),
                        //    : SizedBox(width: 0),
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Container(
                                    padding: EdgeInsets.only(
                                        right: SizeConfig(context).screenWidth <
                                                700
                                            ? 30
                                            : 70,
                                        top: 10,
                                        left: SizeConfig(context).screenWidth <
                                                700
                                            ? 30
                                            : 70),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        mainTabWidget(),
                                        tabName == 'Discover'
                                            ? PeopleDiscoverScreen()
                                            : tabName == 'Friend Requests'
                                                ? FriendRequestsScreen()
                                                : SendRequestsScreen()
                                      ],
                                    ))),
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
          ],
        ));
  }

  Widget mainTabWidget() {
    print(con.sendFriends.length);
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        child: Container(
          height: 60,
          width: SizeConfig(context).screenWidth < 700
              ? SizeConfig(context).screenWidth
              : SizeConfig(context).screenWidth * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Row(children: [
            InkWell(
                onTap: () async {
                  tabName = 'Discover';
                  print(con.ind);
                  setState(() {});
                  await con.getUserList();
                },
                child: Container(
                  padding: EdgeInsets.only(top: 19.5),
                  width: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Discover',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      tabName == 'Discover'
                          ? Container(
                              margin: EdgeInsets.only(top: 22.5),
                              height: 2,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2))),
                            )
                          : Container(
                              margin: EdgeInsets.only(top: 19),
                            )
                    ],
                  ),
                )),
            InkWell(
                onTap: () async {
                  await con.getReceiveRequestsFriends();
                  tabName = 'Friend Requests';
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.only(top: 15),
                  width: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Friend Requests',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Badge(
                            badgeColor: Colors.blue,
                            badgeContent: Text(
                              con.requestFriends.length.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      tabName == 'Friend Requests'
                          ? Container(
                              margin: EdgeInsets.only(top: 17),
                              height: 2,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2))),
                            )
                          : Container(
                              margin: EdgeInsets.only(top: 19),
                            )
                    ],
                  ),
                )),
            InkWell(
                onTap: () async {
                  tabName = 'Send Requests';
                  await con.getSendRequestsFriends();
                  setState(() {});
                },
                child: Expanded(
                    child: Container(
                  width: 130,
                  padding: EdgeInsets.only(top: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Send Requests',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Badge(
                            badgeColor: Colors.blue,
                            badgeContent: Text(
                              con.sendFriends.length.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      tabName == 'Send Requests'
                          ? Container(
                              margin: EdgeInsets.only(top: 17),
                              height: 2,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2))),
                            )
                          : Container(
                              margin: EdgeInsets.only(top: 19),
                            )
                    ],
                  ),
                )))
          ]),
        ));
  }
}
