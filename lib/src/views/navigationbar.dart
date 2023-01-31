import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/ChatController.dart';
import 'package:shnatter/src/controllers/PeopleController.dart';
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/colors.dart';
import 'package:shnatter/src/utils/svg.dart';
import 'package:shnatter/src/views/box/friendrequestbox.dart';
import 'package:shnatter/src/views/box/messagesbox.dart';
import 'package:shnatter/src/views/box/postsnavbox.dart';
import 'package:shnatter/src/views/box/notification.dart';
import 'package:shnatter/src/views/setting/settingsMain.dart';
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
  })  : postCon = PostController(),
        super(key: key);
  PostController postCon;
  final TextEditingController searchController;
  final VoidCallback onSearchBarFocus;
  final VoidCallback onSearchBarDismiss;
  final VoidCallback drawClicked;
  Function routerChange;
  @override
  State createState() => ShnatterNavigationState();
}

class ShnatterNavigationState extends mvc.StateMVC<ShnatterNavigation> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController searhCon;
  late FocusNode searchFocusNode;
  var userInfo = UserManager.userInfo;
  bool onHover = false;
  var chatCon = ChatController();
  var peopleCon = PeopleController();
  late PostController postCon;
  var noti = ShnatterNotificationState();
  var settingMainScreen = SettingMainScreenState();
  var badgeCount = [];
  String userAvatar = '';
  //
  @override
  void initState() {
    add(widget.postCon);
    postCon = controller as PostController;
    searhCon = widget.searchController;
    searchFocusNode = FocusNode();
    userAvatar = UserManager.userInfo['avatar'];
    searchFocusNode.addListener(() {
      widget.onSearchBarFocus();
    });
    Future.delayed(const Duration(milliseconds: 5), () async {
      await PeopleController().getReceiveRequests(userInfo['userName']);
      setState(() {});
    });
    final Stream<QuerySnapshot> friendStrem = FirebaseFirestore.instance
        .collection(Helper.friendField)
        .where('receiver', isEqualTo: userInfo['userName'])
        .snapshots();
    friendStrem.listen((event) {
      var arr = [];
      for (int i = 0; i < event.docs.length; i++) {
        var data = event.docs[i].data() as Map;
        if (data['state'] == 0) {
          var j = {...data, 'id': event.docs[i].id};
          arr.add(j);
        }
      }
      peopleCon.allRequestFriends = arr;
      peopleCon.requestFriends = arr;
      setState(() {});
    });

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
      print('Stream Start');
      var userSnap = await FirebaseFirestore.instance
          .collection(Helper.userField)
          .doc(UserManager.userInfo['uid'])
          .get();
      var userInfo = userSnap.data();
      var changeData = [];
      var tsNT;
      for (var i = 0; i < allNotifi.length; i++) {
        // ignore: unused_local_variable
        tsNT = allNotifi[i]['timeStamp'].toDate().millisecondsSinceEpoch;
        print('timestamp notification time: $tsNT');
        var usercheckTime =
            userInfo!['checkNotifyTime'].toDate().millisecondsSinceEpoch;

        // var tsNT = allNotifi[i]['tsNT'];
        if (userInfo['checkNotifyTime'] == null) {
          userInfo['checkNotifyTime'] = 0;
          setState(() {});
        }
        var adminUid = allNotifi[i]['postAdminId'];
        var postType = allNotifi[i]['postType'];
        if (tsNT > usercheckTime) {
          print('user check time: $usercheckTime');
          var addData;
          if (adminUid != UserManager.userInfo['uid']) {
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
                        // 'avatar': userV.data()!['avatar'],
                        // 'userName': userV.data()!['userName'],
                        //'text': Helper
                        //    .notificationText[allNotifi[i]['postType']]['text'],
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
      print('notification Stream');
      var notiSnap = await Helper.notifiCollection.orderBy('tsNT').get();
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
          if (adminUid != UserManager.userInfo['uid']) {
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
    });

    super.initState();
  }

  Future<void> onAdminClicked() async {
    Helper.showToast("go to admin");
    await Navigator.pushReplacementNamed(context, RouteNames.adp);
  }

  Future<void> onLogOut() async {
    UserManager.isLogined = false;
    Helper.makeOffline();

    UserManager.userInfo = {};
    setState(() {});

    await Helper.removeAllPreference();
    // ignore: use_build_context_synchronously
    await Navigator.pushReplacementNamed(context, RouteNames.login);
    setState(() {});
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
                        menuBuilder: () => PostsNavBox(
                              routerChange: widget.routerChange,
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
                        child: Row(children: [
                          SvgPicture.network(
                            placeholderBuilder: (context) => const Icon(
                                Icons.logo_dev,
                                size: 30,
                                color: Colors.white),
                            SVGPath.group,
                            color: Colors.white,
                            width: 20,
                            height: 20,
                          ),
                          peopleCon.requestFriends.isEmpty
                              ? const SizedBox()
                              : badges.Badge(
                                  toAnimate: false,
                                  shape: badges.BadgeShape.square,
                                  badgeColor: Colors.deepPurple,
                                  borderRadius: BorderRadius.circular(8),
                                  badgeContent: Text(
                                      peopleCon.requestFriends.length
                                          .toString(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 13)),
                                ),
                        ])),
                  ),
                  Container(
                    padding: const EdgeInsets.all(9.0),
                    child: CustomPopupMenu(
                        menuBuilder: () => ShnatterMessage(),
                        pressType: PressType.singleClick,
                        verticalMargin: -10,
                        child: Row(children: [
                          SvgPicture.network(
                            placeholderBuilder: (context) => const Icon(
                                Icons.logo_dev,
                                size: 30,
                                color: Colors.white),
                            SVGPath.message,
                            color: Colors.white,
                            width: 20,
                            height: 20,
                          ),
                          chatCon.notifyCount == 0
                              ? const SizedBox()
                              : badges.Badge(
                                  toAnimate: false,
                                  shape: badges.BadgeShape.square,
                                  badgeColor: Colors.deepPurple,
                                  borderRadius: BorderRadius.circular(8),
                                  badgeContent: Text(
                                      chatCon.notifyCount.toString(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 13)),
                                ),
                        ])),
                  ),
                  Container(
                    padding: const EdgeInsets.all(9.0),
                    child: CustomPopupMenu(
                      menuBuilder: () => ShnatterNotification(),
                      pressType: PressType.singleClick,
                      verticalMargin: -10,
                      child: Row(
                        children: [
                          SvgPicture.network(
                            placeholderBuilder: (context) => const Icon(
                                Icons.logo_dev,
                                size: 30,
                                color: Colors.white),
                            SVGPath.notification,
                            color: Colors.white,
                            width: 20,
                            height: 20,
                          ),
                          postCon.realNotifi.isEmpty
                              ? const SizedBox()
                              : badges.Badge(
                                  toAnimate: false,
                                  shape: badges.BadgeShape.square,
                                  badgeColor: Colors.deepPurple,
                                  borderRadius: BorderRadius.circular(20),
                                  badgeContent: Text(
                                      postCon.realNotifi.length.toString(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 13)),
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
                          onPressed: () {},
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
                          const PopupMenuDivider(),
                          const PopupMenuItem<Menu>(
                            value: Menu.itemKeyboardShortcut,
                            child: Text('Keyboard Shortcuts'),
                          ),
                          const PopupMenuDivider(),
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
                        menuBuilder: () => PostsNavBox(
                              routerChange: widget.routerChange,
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
                        child: Row(children: [
                          SvgPicture.network(
                            placeholderBuilder: (context) => const Icon(
                                Icons.logo_dev,
                                size: 30,
                                color: Colors.white),
                            SVGPath.group,
                            color: Colors.white,
                            width: 20,
                            height: 20,
                          ),
                          peopleCon.requestFriends.isEmpty
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.only(left: 3),
                                  child: badges.Badge(
                                    toAnimate: false,
                                    shape: badges.BadgeShape.square,
                                    badgeColor: Colors.deepPurple,
                                    borderRadius: BorderRadius.circular(8),
                                    badgeContent: Text(
                                        peopleCon.requestFriends.length
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 13)),
                                  ),
                                )
                        ])),
                  ),
                  Container(
                    padding: const EdgeInsets.all(9.0),
                    child: CustomPopupMenu(
                        menuBuilder: () => ShnatterMessage(),
                        pressType: PressType.singleClick,
                        verticalMargin: -10,
                        child: Row(children: [
                          SvgPicture.network(
                            placeholderBuilder: (context) => const Icon(
                                Icons.logo_dev,
                                size: 30,
                                color: Colors.white),
                            SVGPath.message,
                            color: Colors.white,
                            width: 20,
                            height: 20,
                          ),
                          const Padding(padding: EdgeInsets.only(left: 3)),
                          chatCon.notifyCount == 0
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.only(left: 3),
                                  child: badges.Badge(
                                    toAnimate: true,
                                    shape: badges.BadgeShape.square,
                                    badgeColor: Colors.deepPurple,
                                    borderRadius: BorderRadius.circular(8),
                                    badgeContent: Text(
                                        chatCon.notifyCount.toString(),
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 13)),
                                  )),
                        ])),
                  ),
                  Container(
                    padding: const EdgeInsets.all(9.0),
                    child: CustomPopupMenu(
                      menuBuilder: () => ShnatterNotification(),
                      pressType: PressType.singleClick,
                      verticalMargin: -10,
                      child: Row(
                        children: [
                          SvgPicture.network(
                            placeholderBuilder: (context) => const Icon(
                                Icons.logo_dev,
                                size: 30,
                                color: Colors.white),
                            SVGPath.notification,
                            color: Colors.white,
                            width: 20,
                            height: 20,
                          ),
                          postCon.realNotifi.isEmpty
                              ? const SizedBox()
                              : badges.Badge(
                                  toAnimate: false,
                                  shape: badges.BadgeShape.square,
                                  badgeColor: Colors.deepPurple,
                                  borderRadius: BorderRadius.circular(20),
                                  badgeContent: Text(
                                      postCon.realNotifi.length.toString(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 13)),
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
                          const PopupMenuDivider(),
                          const PopupMenuItem<Menu>(
                            value: Menu.itemKeyboardShortcut,
                            child: Text('Keyboard Shortcuts'),
                          ),
                          const PopupMenuDivider(),
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
                controller: searhCon,
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
