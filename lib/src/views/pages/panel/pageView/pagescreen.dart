import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
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
    getSelectedPage(widget.docId);
  }

  void getSelectedPage(String docId) {
    con.getSelectedPage(docId).then((value) => {
          print('You get selected page info!'),
        });
  }

  late PostController con;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawerEnableOpenDragGesture: false,
        drawer: Drawer(),
        body: Stack(
          fit: StackFit.expand,
          children: [
            // ShnatterNavigation(
            //   searchController: searchController,
            //   onSearchBarFocus: onSearchBarFocus,
            //   onSearchBarDismiss: onSearchBarDismiss,
            //   drawClicked: clickMenu,
            // ),
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
          ],
        ));
  }
}
