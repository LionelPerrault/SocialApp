import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/managers/FileManager.dart';
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
import 'package:shnatter/src/widget/yesNoWidget.dart';
import '../../utils/size_config.dart';

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen({Key? key, this.userName = '', required this.routerChange})
      : con = ProfileController(),
        super(key: key);
  final ProfileController con;
  Function routerChange;
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
      print('now get profile');
      profileImage = con.userData['profileImage'] ?? '';
      print(con.userData['paywall']);
      if (con.userData['paywall'][UserManager.userInfo['uid']] == null ||
          con.userData['paywall'][UserManager.userInfo['uid']] == '0' ||
          con.userData['userName'] == UserManager.userInfo['userName']) {
        isProfileView = true;
      }
      isgetdata = true;
      setState(() {});
    });
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
    setState(() {});
    if (!isProfileView) {
      await UserController()
          .payShnToken(
              con.userData['paymail'].toString(),
              con.userData['paywall'][UserManager.userInfo['uid']],
              'Pay for view profile of user')
          .then(
            (value) => {
              print(value),
              print('this is end'),
              isPayProgressive = false,
              setState(() {}),
              if (value)
                {
                  isProfileView = true,
                  setState(() {}),
                }
            },
          );
    }
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
    return SingleChildScrollView(
      child: !isgetdata
          ? Container()
          : !isProfileView
              ? YesNoWidget(
                  yesFunc: () {
                    payForViewProfile();
                  },
                  noFunc: () {
                    Navigator.pushReplacementNamed(
                        context, RouteNames.homePage);
                  },
                  header: 'Pay for View Profile',
                  text:
                      'This user set paywall price is ${con.userData['paywall'][UserManager.userInfo['uid']]}',
                  progress: isPayProgressive,
                )
              : Container(
                  decoration: profileImage != ''
                      ? BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(profileImage),
                              fit: BoxFit.cover))
                      : const BoxDecoration(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileAvatarandTabScreen(
                        onClick: (value) {
                          print(value);
                          con.tab = value;
                          setState(() {});
                        },
                      ),
                      con.tab == 'Timeline' && isgetdata
                          ? ProfileTimelineScreen(
                              onClick: (value) {
                                con.tab = value;
                                setState(() {});
                              },
                              userName: widget.userName,
                            )
                          : con.tab == 'Friends'
                              ? ProfileFriendScreen(onClick: (value) {
                                  con.tab = value;
                                  setState(() {});
                                })
                              : con.tab == 'Photos'
                                  ? ProfilePhotosScreen(onClick: (value) {
                                      con.tab = value;
                                      setState(() {});
                                    })
                                  : con.tab == 'Videos'
                                      ? ProfileVideosScreen(onClick: (value) {
                                          con.tab = value;
                                          setState(() {});
                                        })
                                      : con.tab == 'Likes'
                                          ? ProfileLikesScreen(
                                              onClick: (value) {
                                              con.tab = value;
                                              setState(() {});
                                            })
                                          : con.tab == 'Groups'
                                              ? ProfileGroupsScreen(
                                                  onClick: (value) {
                                                  con.tab = value;
                                                  setState(() {});
                                                })
                                              : ProfileEventsScreen(
                                                  routerChange:
                                                      widget.routerChange)
                      // ProfileFriendScreen(),
                    ],
                  ),
                ),
    );
  }
}
