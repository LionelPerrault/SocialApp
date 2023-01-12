import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/FileManager.dart';
import 'package:shnatter/src/managers/relysiaManager.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
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
import '../../utils/size_config.dart';

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen({Key? key, this.userName = ''})
      : con = ProfileController(),
        super(key: key);
  final ProfileController con;
  String userName;
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
  late FileController filecon;
  bool showMenu = false;
  late AnimationController _drawerSlideController;
  double progress = 0;
  //
  var userInfo = UserManager.userInfo;
  String profileImage = '';
  bool isgetdata = false;
  bool isProfileView = false;
  bool isPayProgressive = false;
  @override
  void initState() {
    add(widget.con);
    con = controller as ProfileController;
    con.viewProfileUserName = widget.userName;
    if (con.viewProfileUserName == '') {
      con.viewProfileUserName = userInfo['userName'];
    }
    print('this is profile username:${widget.userName}');
    con.getProfileInfo().then((value) {
      profileImage = con.userData['profileImage'] ?? '';
      isgetdata = true;
      setState(() {});
    });
    // FirebaseFirestore.instance
    //     .collection(Helper.userField)
    //     .where('userName', isEqualTo: con.viewProfileUserName)
    //     .get()
    //     .then((value) {
    //   con.viewProfileFullName =
    //       '${value.docs[0].data()['firstName']} ${value.docs[0].data()['lastName']}';
    //   con.userData = value.docs[0].data();
    //   con.profile_cover = con.userData['profile_cover'] ?? '';
    // });
    filecon = FileController();
    setState(() {});
    super.initState();
    searchFocusNode = FocusNode();
    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  void payForViewProfile() async {
    isPayProgressive = true;
    await UserController().payShnToken(userInfo['payMail'],
        userInfo['paywall']['visitProfile'], 'Pay for view profile of user');
    isPayProgressive = false;
  }

  late ProfileController con;
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
            // Stack(
            //   children: [
            //     Container(
            //       margin: const EdgeInsets.only(top: SizeConfig.navbarHeight,left: 30,right: 30),
            //       width: SizeConfig(context).screenWidth,
            //       height: SizeConfig(context).screenHeight * 0.5,
            //       decoration: con.profile_cover == '' ? const BoxDecoration(
            //       color: Color.fromRGBO(66, 66, 66, 1),
            //       ) : const BoxDecoration(),
            //       child: con.profile_cover == '' ? Container() : Image.network(con.profile_cover,fit:BoxFit.cover),
            //     )
            //   ],
            // ),
            ShnatterNavigation(
              searchController: searchController,
              onSearchBarFocus: onSearchBarFocus,
              onSearchBarDismiss: onSearchBarDismiss,
              drawClicked: clickMenu,
            ),
            Padding(
              padding: const EdgeInsets.only(top: SizeConfig.navbarHeight),
              child: SingleChildScrollView(
                  child: GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  width: SizeConfig(context).screenWidth,
                  height: SizeConfig(context).screenHeight -
                      SizeConfig.navbarHeight,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                  ),
                  child: Container(
                      width: 400,
                      height: 300,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 4,
                            offset: Offset(0, 0), // Shadow position
                          ),
                        ],
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 30),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Pay for View Profile',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'This user set view profile price is ${userInfo["paywall"]["visitProfile"]}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  margin: const EdgeInsets.only(top: 180),
                                  child: Row(
                                    children: [
                                      const Padding(
                                          padding: EdgeInsets.only(left: 10)),
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4.0)),
                                            minimumSize: const Size(110, 40),
                                            maximumSize: const Size(110, 40),
                                          ),
                                          onPressed: () {
                                            Navigator.pushReplacementNamed(
                                                context, RouteNames.homePage);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: const [
                                              SizedBox(
                                                width: 10,
                                                height: 10,
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 17, left: 10)),
                                              Icon(
                                                Icons.arrow_back,
                                                color: Colors.grey,
                                                size: 14.0,
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10)),
                                              Text('Back to Home',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(left: 10)),
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4.0)),
                                            minimumSize: const Size(110, 40),
                                            maximumSize: const Size(110, 40),
                                          ),
                                          onPressed: () {
                                            payForViewProfile();
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              isPayProgressive
                                                  ? const SizedBox(
                                                      width: 10,
                                                      height: 10.0,
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.grey,
                                                      ),
                                                    )
                                                  : const SizedBox(
                                                      width: 10,
                                                      height: 10,
                                                    ),
                                              const Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 17, left: 10)),
                                              const Icon(
                                                Icons.check_circle,
                                                color: Colors.white,
                                                size: 14.0,
                                              ),
                                              const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10)),
                                              const Text('Finish',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(left: 10))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
              )

                  // Container(
                  //   decoration: profileImage != ''
                  //       ? BoxDecoration(
                  //           image: DecorationImage(
                  //               image: NetworkImage(profileImage),
                  //               fit: BoxFit.cover))
                  //       : const BoxDecoration(),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       !isgetdata
                  //           ? Container()
                  //           : ProfileAvatarandTabScreen(
                  //               onClick: (value) {
                  //                 print(value);
                  //                 con.tab = value;
                  //                 setState(() {});
                  //               },
                  //             ),
                  //       con.tab == 'Timeline' && isgetdata
                  //           ? ProfileTimelineScreen(
                  //               onClick: (value) {
                  //                 con.tab = value;
                  //                 setState(() {});
                  //               },
                  //               userName: widget.userName,
                  //             )
                  //           : con.tab == 'Friends'
                  //               ? ProfileFriendScreen(onClick: (value) {
                  //                   con.tab = value;
                  //                   setState(() {});
                  //                 })
                  //               : con.tab == 'Photos'
                  //                   ? ProfilePhotosScreen(onClick: (value) {
                  //                       con.tab = value;
                  //                       setState(() {});
                  //                     })
                  //                   : con.tab == 'Videos'
                  //                       ? ProfileVideosScreen(onClick: (value) {
                  //                           con.tab = value;
                  //                           setState(() {});
                  //                         })
                  //                       : con.tab == 'Likes'
                  //                           ? ProfileLikesScreen(
                  //                               onClick: (value) {
                  //                               con.tab = value;
                  //                               setState(() {});
                  //                             })
                  //                           : con.tab == 'Groups'
                  //                               ? ProfileGroupsScreen(
                  //                                   onClick: (value) {
                  //                                   con.tab = value;
                  //                                   setState(() {});
                  //                                 })
                  //                               : ProfileEventsScreen()
                  //       // ProfileFriendScreen(),
                  //     ],
                  //   ),
                  // ),
                  ),
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
