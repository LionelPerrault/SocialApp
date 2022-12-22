import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/FileManager.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/box/searchbox.dart';
import 'package:shnatter/src/views/chat/chatScreen.dart';
import 'package:shnatter/src/views/navigationbar.dart';
import 'package:shnatter/src/views/pages/panel/pageView/pageAvatarandTabscreen.dart';
import 'package:shnatter/src/views/pages/panel/pageView/pageEventsScreen.dart';
import 'package:shnatter/src/views/pages/panel/pageView/pageSettingsScreen.dart';
import 'package:shnatter/src/views/pages/panel/pageView/pageInviteScreen.dart';
import 'package:shnatter/src/views/pages/panel/pageView/pagePhotosScreen.dart';
import 'package:shnatter/src/views/pages/panel/pageView/pageTimelineScreen.dart';
import 'package:shnatter/src/views/pages/panel/pageView/pageVideosScreen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as PPath;
import 'dart:io' show File, Platform;

class PageEachScreen extends StatefulWidget {
  PageEachScreen({Key? key, required this.docId})
      : con = PostController(),
        super(key: key);
  final PostController con;
  String docId;
  @override
  State createState() => PageEachScreenState();
}

class PageEachScreenState extends mvc.StateMVC<PageEachScreen>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  bool showSearch = false;
  late FocusNode searchFocusNode;
  late FileController filecon;
  bool showMenu = false;
  late AnimationController _drawerSlideController;
  double progress = 0;
  //
  var userInfo = UserManager.userInfo;
  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    filecon = FileController();
    setState(() {});
    super.initState();
    searchFocusNode = FocusNode();
    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    getSelectedPage(widget.docId);
  }

  void getSelectedPage(String docId) {
    con.getSelectedPage(docId).then((value) => {
          print('You get selected page info!'),
        });
  }

  late PostController con;
  void onSearchBarFocus() {
    searchFocusNode.requestFocus();
    setState(() {
      showSearch = true;
    });
  }

  void clickMenu() {
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
                padding: const EdgeInsets.only(top: SizeConfig.navbarHeight),
                child: SingleChildScrollView(
                  child: con.page == null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              Container(
                                width: 50,
                                height: 50,
                                margin: EdgeInsets.only(
                                    top: SizeConfig(context).screenHeight *
                                        2 /
                                        5),
                                child: const CircularProgressIndicator(
                                  color: Colors.grey,
                                ),
                              )
                            ])
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              PageAvatarandTabScreen(
                                onClick: (value) {
                                  print(value);
                                  con.pageTab = value;
                                  setState(() {});
                                },
                              ),
                              con.pageTab == 'Timeline'
                                  ? PageTimelineScreen(onClick: (value) {
                                      con.pageTab = value;
                                      setState(() {});
                                    })
                                  : con.pageTab == 'Photos'
                                      ? PagePhotosScreen(onClick: (value) {
                                          con.pageTab = value;
                                          setState(() {});
                                        })
                                      : con.pageTab == 'Videos'
                                          ? PageVideosScreen(onClick: (value) {
                                              con.pageTab = value;
                                              setState(() {});
                                            })
                                          : con.pageTab == 'Invite Friends'
                                              ? PageInviteScreen(
                                                  onClick: (value) {
                                                  con.pageTab = value;
                                                  setState(() {});
                                                })
                                              : con.pageTab == 'Settings'
                                                  ? PageSettingsScreen(
                                                      onClick: (value) {
                                                      con.pageTab = value;
                                                      setState(() {});
                                                    })
                                                  : PageEventsScreen()
                              // PageFriendScreen(),
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
