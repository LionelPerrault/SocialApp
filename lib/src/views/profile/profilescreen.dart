import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/views/profile/profileAvatarandTabscreen.dart';
import 'package:shnatter/src/views/profile/profileEventsScreen.dart';
import 'package:shnatter/src/views/profile/profileFriendsScreen.dart';
import 'package:shnatter/src/views/profile/profileGroupsScreen.dart';
import 'package:shnatter/src/views/profile/profilePhotosScreen.dart';
import 'package:shnatter/src/views/profile/profileTimelineScreen.dart';
import 'package:shnatter/src/widget/yesNoWidget.dart';

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen(
      {Key? key, required this.userName, required this.routerChange})
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
  var userInfo = UserManager.userInfo;
  String profileImage = '';
  bool isProfileView = false;
  bool isPayProgressive = false;
  late ProfileController con;
  @override
  void initState() {
    add(widget.con);
    con = controller as ProfileController;
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    if (con.isGetData) {
      profileImage = con.userData['profileImage'] ?? '';
      if (con.userData['paywall'][UserManager.userInfo['uid']] == null ||
          con.userData['paywall'][UserManager.userInfo['uid']] == '0' ||
          con.userData['userName'] == UserManager.userInfo['userName']) {
        isProfileView = true;
      }
    }
    return Expanded(
      child: SingleChildScrollView(
        child: !con.isGetData
            ? Container()
            : !isProfileView
                ? YesNoWidget(
                    yesFunc: () {
                      payForViewProfile();
                    },
                    noFunc: () {
                      widget.routerChange({
                        'router': RouteNames.homePage,
                      });
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
                            con.tab = value;
                            setState(() {});
                          },
                          routerChange: (_) {
                            widget.routerChange(_);
                          },
                        ),
                        con.tab == 'Timeline' && con.isGetData
                            ? ProfileTimelineScreen(
                                onClick: (value) {
                                  con.tab = value;
                                  setState(() {});
                                },
                                userName: widget.userName,
                                routerChange: widget.routerChange,
                              )
                            : con.tab == 'Friends'
                                ? ProfileFriendScreen(
                                    profileName: widget.userName,
                                    onClick: (value) {
                                      con.tab = value;
                                      setState(() {});
                                    },
                                    routerChangeProile: (val) {
                                      widget.routerChange(val);
                                    })
                                : con.tab == 'Photos'
                                    ? ProfilePhotosScreen(onClick: (value) {
                                        con.tab = value;
                                        setState(() {});
                                      })
                                    // : con.tab == 'Videos'
                                    //     ? ProfileVideosScreen(onClick: (value) {
                                    //         con.tab = value;
                                    //         setState(() {});
                                    //       })
                                    // : con.tab == 'Likes'
                                    //     ? ProfileLikesScreen(
                                    //         onClick: (value) {
                                    //           con.tab = value;
                                    //           setState(() {});
                                    //         },
                                    //         routerChange: widget.routerChange,
                                    //       )
                                    : con.tab == 'Groups'
                                        ? ProfileGroupsScreen(
                                            onClick: (value) {
                                              con.tab = value;
                                              setState(() {});
                                            },
                                            routerChange: widget.routerChange,
                                          )
                                        : ProfileEventsScreen(
                                            routerChange: widget.routerChange)
                        // ProfileFriendScreen(),
                      ],
                    ),
                  ),
      ),
    );
  }
}
