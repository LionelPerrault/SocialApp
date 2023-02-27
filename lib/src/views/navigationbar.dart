import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/ChatController.dart';
import 'package:shnatter/src/controllers/PeopleController.dart';
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/controllers/SearchController.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/colors.dart';
import 'package:shnatter/src/utils/svg.dart';
import 'package:shnatter/src/views/box/friendrequestbox.dart';
import 'package:shnatter/src/views/box/messagesbox.dart';
import 'package:shnatter/src/views/box/postsnavbox.dart';
import 'package:shnatter/src/views/box/notification.dart';
import '../helpers/helper.dart';
import '../routes/route_names.dart';
import '../utils/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum Menu {
  itemProfile,
  itemSettings,
  itemPrivacy,
  itemAdminPanel,
  itemLogout,
  itemKeyboardShortcut
}

// ignore: must_be_immutable
class ShnatterNavigation extends StatefulWidget {
  ShnatterNavigation({
    Key? key,
    required this.searchController,
    required this.onSearchBarFocus,
    required this.onSearchBarDismiss,
    required this.drawClicked,
    required this.routerChange,
    required this.textChange,
  })  : postCon = PostController(),
        super(key: key);
  PostController postCon;
  final TextEditingController searchController;
  final VoidCallback onSearchBarFocus;
  final VoidCallback onSearchBarDismiss;
  final VoidCallback drawClicked;
  Function routerChange;
  Function textChange;
  @override
  State createState() => ShnatterNavigationState();
}

class ShnatterNavigationState extends mvc.StateMVC<ShnatterNavigation> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController searchCon;
  late FocusNode searchFocusNode;
  var userInfo = UserManager.userInfo;
  bool onHover = false;
  var chatCon = ChatController();
  var peopleCon = PeopleController();
  late PostController postCon;
  var badgeCount = [];
  final CustomPopupMenuController _navController = CustomPopupMenuController();
  String userAvatar = '';
  //
  @override
  void initState() {
    add(widget.postCon);
    postCon = controller as PostController;
    searchCon = widget.searchController;
    searchFocusNode = FocusNode();
    userAvatar = UserManager.userInfo['avatar'];
    searchFocusNode.addListener(() {
      widget.textChange(searchCon.text);
      widget.onSearchBarFocus();
    });
    PeopleController().listenData();
    final Stream<QuerySnapshot> messageStrem = FirebaseFirestore.instance
        .collection(Helper.message)
        .where('users', arrayContains: userInfo['userName'])
        .snapshots();
    messageStrem.listen(
      (value) {
        var message = [];
        var count = 0;
        for (int i = 0; i < value.docs.length; i++) {
          var docs = value.docs[i].data() as Map;
          var s = docs['users']
              .where((val) => val != userInfo['userName'])
              .toList();
          if (docs[docs[s[0]]['name']] != null &&
              docs[docs[s[0]]['name']] != 0) {
            count += int.parse(docs[docs[s[0]]['name']].toString());
            message.add({
              'avatar': docs[s[0]]['avatar'],
              'name': docs[s[0]]['name'],
              'userName': s[0],
              'lastData': docs['lastData'],
              'id': value.docs[i].id
            });
          }
        }
        chatCon.notifyCount = count;
        chatCon.newMessage = message;
        setState(
          () {},
        );
      },
    );

    final Stream<QuerySnapshot> streamBadge =
        Helper.notifiCollection.snapshots();
    streamBadge.listen((event) async {
      var allNotifi = event.docs;
      var userSnap = await FirebaseFirestore.instance
          .collection(Helper.userField)
          .doc(UserManager.userInfo['uid'])
          .get();
      // print('userSnap----------: ${userSnap.data()}');
      var userInfo = userSnap.data();

      var changeData = [];
      var tsNT;
      for (var i = 0; i < allNotifi.length; i++) {
        // ignore: unused_local_variable
        tsNT = allNotifi[i]['timeStamp'].toDate().millisecondsSinceEpoch;
        // print('timestamp notification time: $tsNT');
        var usercheckTime = userInfo!['checkNotifyTime'];
        setState(() {});
        // print('userCheckTime------ ${userInfo['checkNotifyTime']}');

        // var tsNT = allNotifi[i]['tsNT'];
        if (usercheckTime == null) {
          usercheckTime = 0;
          setState(() {});
        }
        var adminUid = allNotifi[i]['postAdminId'];
        var postType = allNotifi[i]['postType'];
        if (tsNT > usercheckTime) {
          print('user check time: $usercheckTime');
          var addData;
          if (adminUid != UserManager.userInfo['uid'] &&
              postType != 'requestFriend') {
            // userInfo['checkNotifyTime'];
            usercheckTime;
            await FirebaseFirestore.instance
                .collection(Helper.userField)
                .doc(allNotifi[i]['postAdminId'])
                .get()
                .then((userV) => {
                      addData = {
                        // ...allNotifi[i],
                        'uid': allNotifi[i].id,
                      },
                      changeData.add(addData),
                    });
          }
          if (postType == 'requestFriend' &&
              adminUid == UserManager.userInfo['uid']) {
            await FirebaseFirestore.instance
                .collection(Helper.userField)
                .doc(allNotifi[i]['postAdminId'])
                .get()
                .then((userV) => {
                      addData = {
                        // ...allNotifi[i],
                        'uid': allNotifi[i].id,
                        'avatar': Helper.systemAvatar,
                        'userName': Helper
                            .notificationName[allNotifi[i]['postType']]['name'],
                        'text': Helper
                            .notificationText[allNotifi[i]['postType']]['text'],
                      },
                      changeData.add(addData),
                    });
          }
        }
      }
      postCon.realNotifi = changeData;
      setState(() {});
    });

    final Stream<QuerySnapshot> streamContent =
        Helper.notifiCollection.snapshots();
    streamContent.listen((event) async {
      var notiSnap = await Helper.notifiCollection
          .orderBy('timeStamp', descending: true)
          .get();
      var allNotifi = notiSnap.docs;
      var userSnap = await FirebaseFirestore.instance
          .collection(Helper.userField)
          .doc(UserManager.userInfo['uid'])
          .get();
      // ignore: unused_local_variable
      var userInfo = userSnap.data();
      var changeData = [];
      for (var i = 0; i < allNotifi.length; i++) {
        var adminUid = allNotifi[i]['postAdminId'];
        var postType = allNotifi[i]['postType'];
        var viewFlag = true;
        setState(() {});

        for (var j = 0; j < allNotifi[i]['userList'].length; j++) {
          if (allNotifi[i]['userList'][j] == UserManager.userInfo['uid']) {
            viewFlag = false;
          }
        }
        setState(() {});
        postCon.allNotification = [];
        if (viewFlag) {
          var addData;
          if (adminUid != UserManager.userInfo['uid'] &&
              postType != 'requestFriend') {
            await FirebaseFirestore.instance
                .collection(Helper.userField)
                .doc(allNotifi[i]['postAdminId'])
                .get()
                .then((userV) async => {
                      addData = {
                        ...allNotifi[i].data(),
                        'uid': allNotifi[i].id,
                        'avatar': userV.data()!['avatar'],
                        'userName': userV.data()!['userName'],
                        'text': Helper
                            .notificationText[allNotifi[i]['postType']]['text'],
                        'date':
                            await postCon.formatDate(allNotifi[i]['timeStamp']),
                      },
                      changeData.add(addData),
                    });
          }
          if (postType == 'requestFriend' &&
              adminUid == UserManager.userInfo['uid']) {
            await FirebaseFirestore.instance
                .collection(Helper.userField)
                .doc(allNotifi[i]['postAdminId'])
                .get()
                .then((userV) async => {
                      addData = {
                        'uid': allNotifi[i].id,
                        'avatar': '',
                        'userName': Helper
                            .notificationName[allNotifi[i]['postType']]['name'],
                        'text': Helper
                            .notificationText[allNotifi[i]['postType']]['text'],
                        'date':
                            await postCon.formatDate(allNotifi[i]['timeStamp']),
                      },
                      changeData.add(addData),
                    });
          }
        }
      }
      postCon.allNotification = changeData;

      setState(() {});
      // print('notification content ------${postCon.allNotification}');
    });

    SearchController().getAllSearchResult();
    super.initState();
  }

  Future<void> onAdminClicked() async {
    //Helper.showToast("go to admin");
    //print("go to login");
    await Navigator.pushReplacementNamed(context, RouteNames.adp);
  }

  Future<void> onLogOut() async {
    await UserController().signOutUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizeConfig(context).screenWidth > SizeConfig.mediumScreenSize
          ? buildLargeSize()
          : buildSmallSize(),
    );
  }

  Widget buildSmallSize() {
    //Future.delayed(
    // const Duration(microseconds: 300), () => {widget.onSearchBarDismiss()});
    return Stack(
      children: [
        Container(
            decoration: BoxDecoration(
              color: kprimaryColor,
            ),
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                        padding: const EdgeInsets.only(right: 0, left: 10),
                        child: ElevatedButton(
                            onPressed: () {
                              widget.drawClicked();
                            },
                            style: ButtonStyle(
                              minimumSize:
                                  MaterialStateProperty.all(const Size(30, 30)),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(2)),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.black),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),
                            child: const Icon(CupertinoIcons.line_horizontal_3,
                                size: 30, color: Colors.white))
                        //Icon(Icons.home_outlined, size: 30, color: Colors.white),
                        ),
                  ],
                ),
                Row(children: [
                  Container(
                      padding: const EdgeInsets.only(right: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          widget.routerChange({
                            'router': RouteNames.homePage,
                          });
                        },
                        style: ButtonStyle(
                          minimumSize:
                              MaterialStateProperty.all(const Size(30, 30)),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(2)),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.black),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        child: SvgPicture.network(
                          placeholderBuilder: (context) => const Icon(
                              Icons.logo_dev,
                              size: 30,
                              color: Colors.white),
                          SVGPath.home,
                          color: Colors.white,
                          width: 20,
                          height: 20,
                        ),
                      )
                      //Icon(Icons.home_outlined, size: 30, color: Colors.white),
                      ),
                  Container(
                    padding: const EdgeInsets.only(right: 9.0),
                    child: CustomPopupMenu(
                        controller: _navController,
                        menuBuilder: () => PostsNavBox(
                              routerChange: widget.routerChange,
                              hideNavBox: () {
                                _navController.hideMenu();
                              },
                            ),
                        pressType: PressType.singleClick,
                        verticalMargin: -10,
                        child: SvgPicture.network(
                          placeholderBuilder: (context) => const Icon(
                              Icons.logo_dev,
                              size: 30,
                              color: Colors.white),
                          SVGPath.posts,
                          color: Colors.white,
                          width: 20,
                          height: 20,
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 9.0),
                    child: CustomPopupMenu(
                      menuBuilder: () => ShnatterFriendRequest(
                        onClick: () {
                          setState(() {});
                        },
                        routerChange: widget.routerChange,
                      ),
                      pressType: PressType.singleClick,
                      verticalMargin: -10,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 3),
                            child: badges.Badge(
                              showBadge: peopleCon.requestFriends.isEmpty
                                  ? false
                                  : true,
                              position: badges.BadgePosition.topEnd(top: -10),
                              badgeStyle: badges.BadgeStyle(
                                badgeColor: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              badgeContent: Text(
                                  peopleCon.requestFriends.length.toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 13)),
                              child: SvgPicture.network(
                                placeholderBuilder: (context) => const Icon(
                                    Icons.logo_dev,
                                    size: 30,
                                    color: Colors.white),
                                SVGPath.group,
                                color: Colors.white,
                                width: 24,
                                height: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(9.0),
                    child: CustomPopupMenu(
                      controller: _navController,
                      menuBuilder: () => ShnatterMessage(
                        routerChange: widget.routerChange,
                        hideNavBox: () {
                          _navController.hideMenu();
                        },
                      ),
                      pressType: PressType.singleClick,
                      verticalMargin: -10,
                      child: Row(
                        children: [
                          badges.Badge(
                            showBadge: chatCon.notifyCount == 0 ? false : true,
                            position: badges.BadgePosition.topEnd(top: -10),
                            badgeStyle: badges.BadgeStyle(
                              badgeColor: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            badgeContent: Text(chatCon.notifyCount.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 13)),
                            child: SvgPicture.network(
                              placeholderBuilder: (context) => const Icon(
                                  Icons.logo_dev,
                                  size: 30,
                                  color: Colors.white),
                              SVGPath.message,
                              color: Colors.white,
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(9.0),
                    child: CustomPopupMenu(
                      menuBuilder: () => ShnatterNotification(),
                      pressType: PressType.singleClick,
                      verticalMargin: -10,
                      child: Row(
                        children: [
                          badges.Badge(
                            showBadge:
                                postCon.realNotifi.isEmpty ? false : true,
                            position: badges.BadgePosition.topEnd(top: -10),
                            badgeStyle: badges.BadgeStyle(
                              badgeColor: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            badgeContent: Text(
                                postCon.realNotifi.length.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 13)),
                            child: SvgPicture.network(
                              placeholderBuilder: (context) => const Icon(
                                  Icons.logo_dev,
                                  size: 30,
                                  color: Colors.white),
                              SVGPath.notification,
                              color: Colors.white,
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.only(right: 1),
                      child: ButtonTheme(
                        minWidth: 30,
                        child: ElevatedButton(
                          onPressed: () {
                            widget.routerChange({
                              'router': RouteNames.search,
                            });
                          },
                          style: ButtonStyle(
                            minimumSize:
                                MaterialStateProperty.all(const Size(30, 30)),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.all(2)),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.black),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          child: SvgPicture.network(
                            placeholderBuilder: (context) => const Icon(
                                Icons.logo_dev,
                                size: 30,
                                color: Colors.white),
                            SVGPath.search,
                            color: Colors.white,
                            width: 20,
                            height: 20,
                          ),
                        ),
                      )

                      //Icon(Icons.home_outlined, size: 30, color: Colors.white),
                      ),
                  Container(
                      padding: const EdgeInsets.all(9.0),
                      child: PopupMenuButton(
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<Menu>>[
                          const PopupMenuItem<Menu>(
                              value: Menu.itemProfile, child: Text('Profile')),
                          PopupMenuItem<Menu>(
                            value: Menu.itemSettings,
                            child: GestureDetector(
                              child: const Text('Settings'),
                            ),
                          ),
                          PopupMenuItem<Menu>(
                            value: Menu.itemPrivacy,
                            child:
                                GestureDetector(child: const Text('Privacy')),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem<Menu>(
                            value: Menu.itemAdminPanel,
                            child: GestureDetector(
                                child: const Text('AdminPanel')),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem<Menu>(
                              onTap: () => {onLogOut()},
                              value: Menu.itemLogout,
                              child: Row(children: const [
                                Icon(Icons.logout),
                                SizedBox(width: 8),
                                Text('Log Out'),
                              ])),
                        ],
                        onSelected: (Menu item) {
                          switch (item) {
                            case Menu.itemProfile:
                              {
                                widget.routerChange({
                                  'router': RouteNames.profile,
                                  'subRouter': UserManager.userInfo['userName']
                                });
                                break;
                              }
                            case Menu.itemSettings:
                              {
                                widget.routerChange({
                                  'router': RouteNames.settings,
                                  'subRouter': ''
                                });
                                break;
                              }
                            case Menu.itemPrivacy:
                              {
                                widget.routerChange({
                                  'router': RouteNames.settings,
                                  'subRouter': RouteNames.settings_privacy
                                });
                                break;
                              }
                            case Menu.itemAdminPanel:
                              {
                                Navigator.pushReplacementNamed(
                                    context, RouteNames.adp);
                                break;
                              }
                            default:
                          }
                        },
                        child: Row(
                          children: [
                            userAvatar != ''
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(
                                    userAvatar,
                                  ))
                                : CircleAvatar(
                                    child: SvgPicture.network(Helper.avatar),
                                  ),
                            //Icon(Icons.arrow_downward,
                            //    size: 15, color: Colors.white)
                          ],
                        ),
                      )),
                ])
              ],
            )),
      ],
    );
  }

  Widget buildLargeSize() {
    return Stack(
      children: [
        Container(
            decoration: BoxDecoration(
              color: kprimaryColor,
            ),
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 58.0),
                    child: TextButton(
                      onPressed: () {},
                      onHover: (hover) {
                        setState(() {
                          onHover = hover;
                        });
                      },
                      child: AnimatedOpacity(
                        duration: const Duration(microseconds: 1000),
                        curve: Curves.easeIn,
                        opacity: onHover ? 0.5 : 1,
                        child: SvgPicture.network(
                            placeholderBuilder: (context) => const Icon(
                                Icons.logo_dev,
                                size: 30,
                                color: Colors.white),
                            SVGPath.logo,
                            width: 40,
                            height: 40,
                            semanticsLabel: 'Logo'),
                      ),
                    )),
                Row(
                  children: [
                    Container(
                        padding: const EdgeInsets.only(right: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            widget.routerChange({
                              'router': RouteNames.homePage,
                            });
                          },
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all(Colors.black),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          child: SvgPicture.network(
                            placeholderBuilder: (context) => const Icon(
                                Icons.logo_dev,
                                size: 30,
                                color: Colors.white),
                            SVGPath.home,
                            color: Colors.white,
                            width: 20,
                            height: 20,
                          ),
                        )
                        //Icon(Icons.home_outlined, size: 30, color: Colors.white),
                        ),
                    SizedBox(
                      width: SizeConfig(context).screenWidth * 0.35,
                    )
                  ],
                ),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.only(right: 9.0),
                    child: CustomPopupMenu(
                        controller: _navController,
                        menuBuilder: () => PostsNavBox(
                              routerChange: widget.routerChange,
                              hideNavBox: () {
                                _navController.hideMenu();
                              },
                            ),
                        pressType: PressType.singleClick,
                        verticalMargin: -10,
                        child: SvgPicture.network(
                          placeholderBuilder: (context) => const Icon(
                              Icons.logo_dev,
                              size: 30,
                              color: Colors.white),
                          SVGPath.posts,
                          color: Colors.white,
                          width: 20,
                          height: 20,
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 9.0),
                    child: CustomPopupMenu(
                      menuBuilder: () => ShnatterFriendRequest(
                        onClick: () {
                          setState(() {});
                        },
                        routerChange: widget.routerChange,
                      ),
                      pressType: PressType.singleClick,
                      verticalMargin: -10,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 3),
                            child: badges.Badge(
                              showBadge: peopleCon.requestFriends.isEmpty
                                  ? false
                                  : true,
                              position: badges.BadgePosition.topEnd(top: -13),
                              badgeStyle: badges.BadgeStyle(
                                badgeColor: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              badgeContent: Text(
                                  peopleCon.requestFriends.length.toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 13)),
                              child: SvgPicture.network(
                                placeholderBuilder: (context) => const Icon(
                                    Icons.logo_dev,
                                    size: 30,
                                    color: Colors.white),
                                SVGPath.group,
                                color: Colors.white,
                                width: 24.5,
                                height: 24.5,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(9.0),
                    child: CustomPopupMenu(
                      menuBuilder: () => ShnatterMessage(
                        routerChange: widget.routerChange,
                        hideNavBox: () {
                          _navController.hideMenu();
                        },
                      ),
                      pressType: PressType.singleClick,
                      verticalMargin: -10,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 3),
                            child: badges.Badge(
                              // toAnimate: true,
                              showBadge:
                                  chatCon.notifyCount == 0 ? false : true,
                              position: badges.BadgePosition.topEnd(top: -13),
                              badgeStyle: badges.BadgeStyle(
                                badgeColor: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              badgeContent: Text(chatCon.notifyCount.toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 13)),
                              child: SvgPicture.network(
                                placeholderBuilder: (context) => const Icon(
                                    Icons.logo_dev,
                                    size: 30,
                                    color: Colors.white),
                                SVGPath.message,
                                color: Colors.white,
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(9.0),
                    child: CustomPopupMenu(
                      menuBuilder: () => ShnatterNotification(),
                      pressType: PressType.singleClick,
                      verticalMargin: -10,
                      child: Row(
                        children: [
                          badges.Badge(
                            showBadge:
                                postCon.realNotifi.isEmpty ? false : true,
                            badgeStyle: badges.BadgeStyle(
                              badgeColor: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            position: badges.BadgePosition.topEnd(top: -11),
                            badgeContent: Text(
                                postCon.realNotifi.length.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 13)),
                            child: SvgPicture.network(
                              placeholderBuilder: (context) => const Icon(
                                  Icons.logo_dev,
                                  size: 30,
                                  color: Color.fromARGB(255, 201, 61, 61)),
                              SVGPath.notification,
                              color: Colors.white,
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.all(9.0),
                      child: PopupMenuButton(
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<Menu>>[
                          const PopupMenuItem<Menu>(
                              value: Menu.itemProfile, child: Text('Profile')),
                          PopupMenuItem<Menu>(
                            value: Menu.itemSettings,
                            child:
                                GestureDetector(child: const Text('Settings')),
                          ),
                          PopupMenuItem<Menu>(
                            value: Menu.itemPrivacy,
                            child:
                                GestureDetector(child: const Text('Privacy')),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem<Menu>(
                            value: Menu.itemAdminPanel,
                            child: GestureDetector(
                                child: const Text('AdminPanel')),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem<Menu>(
                              onTap: () {
                                onLogOut();
                              },
                              value: Menu.itemLogout,
                              child: Row(children: const [
                                Icon(Icons.logout),
                                SizedBox(width: 8),
                                Text('Log Out'),
                              ])),
                        ],
                        onSelected: (Menu item) {
                          switch (item) {
                            case Menu.itemProfile:
                              {
                                widget.routerChange({
                                  'router': RouteNames.profile,
                                  'subRouter': UserManager.userInfo['userName']
                                });
                                break;
                              }

                            case Menu.itemSettings:
                              {
                                widget.routerChange({
                                  'router': RouteNames.settings,
                                  'subRouter': ''
                                });
                                break;
                              }
                            case Menu.itemPrivacy:
                              {
                                widget.routerChange({
                                  'router': RouteNames.settings,
                                  'subRouter': RouteNames.settings_privacy
                                });
                                break;
                              }
                            case Menu.itemAdminPanel:
                              {
                                Navigator.pushReplacementNamed(
                                    context, RouteNames.adp);
                                break;
                              }
                            default:
                          }
                        },
                        child: Row(
                          children: [
                            userAvatar != ''
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(
                                    userAvatar,
                                  ))
                                : CircleAvatar(
                                    child: SvgPicture.network(Helper.avatar),
                                  ),
                            //Icon(Icons.arrow_downward,
                            //    size: 15, color: Colors.white)
                          ],
                        ),
                      )),
                ])
              ],
            )),
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
              padding: const EdgeInsets.only(top: 10, bottom: 10, right: 9),
              width: SizeConfig(context).screenWidth * 0.4,
              child: TextField(
                controller: searchCon,
                cursorColor: Colors.white,
                focusNode: searchFocusNode,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search,
                      color: Color.fromARGB(150, 170, 212, 255), size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  filled: true,
                  fillColor: Color(0xff202020),
                  hintText: 'Search',
                  hintStyle: TextStyle(fontSize: 15.0, color: Colors.white),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
