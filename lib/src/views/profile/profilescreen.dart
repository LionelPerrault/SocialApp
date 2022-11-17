import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/FileManager.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/views/box/searchbox.dart';
import 'package:shnatter/src/views/chat/chatScreen.dart';
import 'package:shnatter/src/views/navigationbar.dart';
import 'package:shnatter/src/views/profile/profileAvatarandTabscreen.dart';
import 'package:shnatter/src/views/profile/profileEventsScreen.dart';
import 'package:shnatter/src/views/profile/profileFriendsScreen.dart';
import 'package:shnatter/src/views/profile/profileGroupsScreen.dart';
import 'package:shnatter/src/views/profile/profileLikesScreen.dart';
import 'package:shnatter/src/views/profile/profilePhotosScreen.dart';
import 'package:shnatter/src/views/profile/profileTimelineScreen.dart';
import 'package:shnatter/src/views/profile/profileVideosScreen.dart';
import '../../controllers/HomeController.dart';
import '../../utils/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen({Key? key})
      : con = ProfileController(),
        super(key: key);
  final ProfileController con;

  @override
  State createState() => UserProfileScreenState();
}

class UserProfileScreenState extends mvc.StateMVC<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  bool showSearch = false;
  late FocusNode searchFocusNode;
  bool showMenu = false;
  late AnimationController _drawerSlideController;
  var url = window.location.href;
  var subUrl = '';
  var suggest = <String, bool>{
    'friends': true,
    'pages': true,
    'groups': true,
    'events': true
  };
  //
  var userInfo = UserManager.userInfo;
  @override
  void initState() {
    subUrl = url.split('/')[url.split('/').length - 1];
    add(widget.con);
    con = controller as ProfileController;
    con.profile_cover = UserManager.userInfo['profile_cover'] ?? '';
    setState(() { });
    super.initState();
    print(userInfo);
    searchFocusNode = FocusNode();
    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  late ProfileController con;
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
            Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: SizeConfig.navbarHeight,left: 30,right: 30),
                  width: SizeConfig(context).screenWidth,
                  height: SizeConfig(context).screenHeight * 0.5,
                  decoration: con.profile_cover == '' ? const BoxDecoration(
                  color: Color.fromRGBO(66, 66, 66, 1),
                  ) : const BoxDecoration(),
                  child: con.profile_cover == '' ? Container() : Image.network(con.profile_cover,fit:BoxFit.cover),
                )
              ],
            ),
            ShnatterNavigation(
              searchController: searchController,
              onSearchBarFocus: onSearchBarFocus,
              onSearchBarDismiss: onSearchBarDismiss,
              drawClicked: clickMenu,
            ),
            Padding(
                padding: const EdgeInsets.only(top: SizeConfig.navbarHeight),
                child:
                    //AnimatedPositioned(
                    //top: showMenu ? 0 : -150.0,
                    //duration: const Duration(seconds: 2),
                    //curve: Curves.fastOutSlowIn,
                    //child:
                    SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileAvatarandTabScreen(onClick: (value) {
                          print(value);
                          con.tab = value;
                          setState(() { });
                        },),
                        con.tab == 'Timeline' ? ProfielTimelineScreen(onClick:(value){
                          con.tab = value;
                          setState(() { });
                        }) :
                        con.tab == 'Friends' ? ProfileFriendScreen(onClick:(value){
                          con.tab = value;
                          setState(() { });
                        }) :
                        con.tab == 'Photos' ? ProfilePhotosScreen(onClick:(value){
                          con.tab = value;
                          setState(() { });
                        }) :
                        con.tab == 'Videos' ? ProfileVideosScreen(onClick:(value){
                          con.tab = value;
                          setState(() { });
                        }) :
                        con.tab == 'Likes' ? ProfileLikesScreen(onClick:(value){
                          con.tab = value;
                          setState(() { });
                        }) :
                        con.tab == 'Groups' ? ProfileGroupsScreen(onClick:(value){
                          con.tab = value;
                          setState(() { });
                        }) :
                        ProfileEventsScreen()
                        // ProfileFriendScreen(),
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
                Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(left: 50,top: SizeConfig.navbarHeight + 30),
                    child: GestureDetector(
                      onTap: () {
                        print(123);

                        FileManager.uploadImage().then((value) {
                          print(value['success']);
                          if(value['success']){
                            FirebaseFirestore.instance.collection(Helper.userField).doc(userInfo['uid']).update({
                              'profile_cover': value['url']
                            }).then((e) async {
                                con.profile_cover = value['url'];
                                await Helper.saveJSONPreference(Helper.userField,
                                  {...userInfo, 'profile_cover': value['url']});
                            setState(() { });
                            con.setState(() { });

                            } );
                          }
                        });
                      },
                      child: const Icon(Icons.photo_camera,size: 25,),)
                  ),
            ChatScreen(),
            
          ],
        ));
  }
}
