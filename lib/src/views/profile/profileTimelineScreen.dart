import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/views/box/mindpost.dart';
import 'package:shnatter/src/widget/list_text.dart';
import '../../controllers/PostController.dart';
import '../../helpers/helper.dart';
import '../../utils/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../controllers/ProfileController.dart';
import '../../widget/postCell.dart';
import 'model/friends.dart';

enum Direction {
  normal(1),
  reverse(-1);

  const Direction(this.value);

  final int value;
}

const int defaultSlide = 10;

enum PostType { timeline, profile, event, normal }

class ProfileTimelineScreen extends StatefulWidget {
  Function onClick;
  ProfileTimelineScreen(
      {Key? key,
      required this.onClick,
      required this.userName,
      required this.routerChange})
      : con = ProfileController(),
        super(key: key);
  final ProfileController con;
  late PostController postCon = PostController();
  String userName = '';
  Function routerChange;
  @override
  State createState() => ProfileTimelineScreenState();
}

class ProfileTimelineScreenState extends mvc.StateMVC<ProfileTimelineScreen>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  // ignore: unused_field
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  bool showSearch = false;
  late FocusNode searchFocusNode;
  bool showMenu = false;
  Friends friendModel = Friends();
  // ignore: unused_field
  late AnimationController _drawerSlideController;
  double width = 0;
  double itemWidth = 0;
  bool loadingFlag = false;
  bool loadingFlagBottom = false;
  int newPostNum = 0;
  bool nextPostFlag = true;
  late PostController postCon;

  //
  var userInfo = UserManager.userInfo;
  List<Map> mainInfoList = [];
  var userData = {};
  String userName = '';
  var percent = 20;
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as ProfileController;
    friendModel
        .getFriends(ProfileController().viewProfileUserName)
        .then((value) {
      setState(() {});
    });
    //postCon = controller as PostController;
    userName = widget.userName;
    if (userName == '') {
      userName = UserManager.userInfo['userName'];
    }
    if (userName == '') {
      return;
    }
    userData = con.userData;
    con.profile_cover = con.userData['profile_cover'] ?? '';
    mainInfoList = [
      {
        'title': 'Add your profile picture',
        'add': userData['avatar'] == '' ? false : true
      },
      {
        'title': 'Add your profile cover',
        'add': con.profile_cover == '' ? false : true
      },
      {
        'title': 'Add your biography',
        'add': userData['about'] == null ? false : true,
        'route': RouteNames.settings_profile_basic
      },
      {
        'title': 'Add your birthdate',
        'add': userData['birthY'] == null ? false : true,
        'route': RouteNames.settings_profile_basic
      },
      {
        'title': 'Add your relationship',
        'add': userData['school'] == null ? false : true,
        'route': RouteNames.settings_profile_basic
      },
      {
        'title': 'Add your work info',
        'add': userData['workTitle'] == null ? false : true,
        'route': RouteNames.settings_profile_work
      },
      {
        'title': 'Add your location info',
        'add': userData['current'] == null ? false : true,
        'route': RouteNames.settings_profile_location
      },
      {
        'title': 'Add your education info',
        'add': userData['school'] == null &&
                userData['class'] == null &&
                userData['major'] == null
            ? false
            : true,
        'route': RouteNames.settings_profile_education
      },
    ];
    setState(() {});
    for (int i = 0; i < mainInfoList.length; i++) {
      if (mainInfoList[i]['add'] == true) {
        percent = percent + 10;
      } else {}
    }
    _gotoHome();

    final Stream<QuerySnapshot> postStream =
        Helper.postCollection.orderBy('postTime').snapshots();
    loadingFlag = true;
    //PostController().posts = [];
    PostController()
        .getTimelinePost(
            defaultSlide, 1, PostType.profile.index, con.viewProfileUid)
        .then((value) {
      // profilePosts = value;
      loadingFlag = false;
      if (PostController().postsProfile.length < 10) {
        nextPostFlag = false;
      }
      setState(() {});

      postStream.listen((event) {
        newPostNum = event.docs
            .where((post) =>
                (post['postAdmin'] == UserManager.userInfo['uid']) &&
                (Timestamp(
                        post['postTime'].seconds, post['postTime'].nanoseconds)
                    .toDate()
                    .isAfter(PostController().latestTime)))
            .length;
        print("newPostNum of profile is $newPostNum");
        setState(() {});
      });
    });
  }

  late ProfileController con;
  void _gotoHome() {
    Future.delayed(Duration.zero, () {
      width = SizeConfig(context).screenWidth - 260;
      itemWidth = width / 7.5;
      setState(() {});
    });
  }

  Widget postColumn() {
    return Column(
      children: [
        con.viewProfileUid == UserManager.userInfo['uid']
            ? MindPost(showPrivacy: true)
            : Container(
                width:
                    SizeConfig(context).screenWidth > SizeConfig.smallScreenSize
                        ? 530
                        : 350,
                padding: const EdgeInsets.only(left: 30, right: 30)),
        const Padding(padding: EdgeInsets.only(top: 20)),
        newPostNum <= 0 || con.viewProfileUid != UserManager.userInfo['uid']
            ? const SizedBox()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(21.0)),
                  minimumSize: const Size(240, 42),
                  maximumSize: const Size(240, 42),
                ),
                onPressed: () async {
                  setState(() {
                    loadingFlag = true;
                  });
                  await PostController().getTimelinePost(newPostNum, -1,
                      PostType.profile.index, con.viewProfileUid);

                  setState(() {
                    newPostNum = 0;
                    loadingFlag = false;
                  });
                },
                child: Column(
                  children: [
                    const Padding(padding: EdgeInsets.only(top: 11.0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'View $newPostNum new Post${newPostNum == 1 ? '' : 's'}',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 90, 90, 90),
                              fontFamily: 'var(--body-font-family)',
                              fontWeight: FontWeight.w900,
                              fontSize: 15),
                        )
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(top: 8.0)),
                  ],
                ),
              ),
        loadingFlag
            ? const SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  color: Colors.grey,
                ),
              )
            : const SizedBox(),
        PostController().postsProfile.isNotEmpty
            ? SizedBox(
                width: 600,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: PostController().postsProfile.length,
                        itemBuilder: (BuildContext context, int index) {
                          return PostCell(
                            postInfo: PostController().postsProfile[index],
                            routerChange: widget.routerChange,
                          );
                        },
                      ),
                    )
                  ],
                ),
              )
            : const SizedBox(),
        loadingFlagBottom
            ? const SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  color: Colors.grey,
                ),
              )
            : const SizedBox(),
        loadingFlagBottom || loadingFlag || !nextPostFlag
            ? !nextPostFlag
                ? Text("There is no more data to show")
                : const SizedBox()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(21.0)),
                  minimumSize: const Size(240, 42),
                  maximumSize: const Size(240, 42),
                ),
                onPressed: () async {
                  setState(() {
                    loadingFlagBottom = true;
                  });

                  nextPostFlag = await PostController().getTimelinePost(
                      defaultSlide,
                      0,
                      PostType.profile.index,
                      con.viewProfileUid);

                  setState(() {
                    loadingFlagBottom = false;
                  });
                },
                child: Column(
                  children: [
                    const Padding(padding: EdgeInsets.only(top: 11.0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Load More...',
                          style: TextStyle(
                              color: Color.fromARGB(255, 90, 90, 90),
                              fontFamily: 'var(--body-font-family)',
                              fontWeight: FontWeight.w900,
                              fontSize: 15),
                        )
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(top: 8.0)),
                  ],
                ),
              ),
      ],
    );
  }

  bool isMyFriend() {
    //profile selected is my friend?
    String friendUserName;
    for (var item in friendModel.friends) {
      friendUserName = item['requester'].toString();
      if (friendUserName == UserManager.userInfo['userName']) {
        return true;
      }
      if (item['receiver'] == UserManager.userInfo['userName']) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    print("conprofileid is ${con.viewProfileUid}");
    print("userprofileid is ${UserManager.userInfo['uid']}");
    return Container(
      alignment: Alignment.topLeft,
      child: SizeConfig(context).screenWidth < 800
          ? isMyFriend() ||
                  ProfileController().viewProfileUid ==
                      UserManager.userInfo['uid']
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      ProfileController().viewProfileUid ==
                              UserManager.userInfo['uid']
                          ? Column(
                              children: [
                                const Padding(
                                    padding: EdgeInsets.only(top: 30)),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: LinearPercentIndicator(
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    animation: true,
                                    lineHeight: 20.0,
                                    animationDuration: 1000,
                                    percent: percent / 100,
                                    center:
                                        Text("Profile Completion  $percent %"),
                                    // ignore: deprecated_member_use
                                    linearStrokeCap: LinearStrokeCap.roundAll,
                                    progressColor: Colors.blueAccent,
                                  ),
                                ),
                                profileCompletion(),
                              ],
                            )
                          : const SizedBox(),
                      postColumn(),
                    ])
              : Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Padding(padding: const EdgeInsets.only(top: 115)),
                      Text(
                        "You can see the friends Timeline only if you are friends.",
                        textAlign: TextAlign.center,
                      ),
                      Padding(padding: const EdgeInsets.only(top: 30)),
                    ],
                  ),
                )
          : isMyFriend() ||
                  ProfileController().viewProfileUid ==
                      UserManager.userInfo['uid']
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        ProfileController().viewProfileUid ==
                                UserManager.userInfo['uid']
                            ? Column(children: [
                                const Padding(
                                    padding: EdgeInsets.only(top: 30)),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: LinearPercentIndicator(
                                    width:
                                        MediaQuery.of(context).size.width / 6,
                                    animation: true,
                                    lineHeight: 20.0,
                                    animationDuration: 1000,
                                    percent: percent / 100,
                                    center:
                                        Text("Profile Completion  $percent%"),
                                    // ignore: deprecated_member_use
                                    linearStrokeCap: LinearStrokeCap.roundAll,
                                    progressColor: Colors.blueAccent,
                                  ),
                                ),
                                Container(
                                  height: (SizeConfig(context).screenHeight -
                                          SizeConfig.navbarHeight) /
                                      2,
                                  padding: const EdgeInsets.only(bottom: 60),
                                  child: profileCompletion(),
                                ),
                              ])
                            : const SizedBox(),
                      ],
                    ),
                    postColumn()
                  ],
                )
              : Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Padding(padding: const EdgeInsets.only(top: 115)),
                      Text(
                        "You can see the friends data only if you are friends.",
                        textAlign: TextAlign.center,
                      ),
                      Padding(padding: const EdgeInsets.only(top: 30)),
                    ],
                  ),
                ),
    );
  }

  Widget profileCompletion() {
    return Container(
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
          top: 15,
        ),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // children: <Widget>[
          //     Text('\$', style: TextStyle(decoration: TextDecoration.lineThrough))
          children: mainInfoList
              .map((e) => Container(
                  padding: const EdgeInsets.only(top: 5),
                  child: GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          e['add'] ? Icons.check : Icons.add,
                          size: 15,
                        ),
                        const Padding(padding: EdgeInsets.only(left: 5)),
                        e['add']
                            ? Text(e['title'],
                                style: const TextStyle(
                                    decoration: TextDecoration.lineThrough))
                            : Text(
                                e['title'],
                              ),
                      ],
                    ),
                    onTap: () {
                      e['route'] != null && !e['add']
                          ? widget.routerChange({
                              'router': RouteNames.settings,
                              'subRouter': e['route'],
                            })
                          : () {};
                    },
                  )))
              .toList(),
        ));
  }
}
