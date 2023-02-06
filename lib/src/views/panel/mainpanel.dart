import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/box/daytimeM.dart';
import 'package:shnatter/src/views/box/mindpost.dart';
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/widget/postCell.dart';

// ignore: must_be_immutable
class MainPanel extends StatefulWidget {
  MainPanel({
    super.key,
    required this.routerChange,
  }) : con = PostController();

  late PostController con;
  Function routerChange;
  @override
  State createState() => MainPanelState();
}

class MainPanelState extends mvc.StateMVC<MainPanel> {
  List<Map> subFunctionList = [];
  bool showDayTimeM = true;
  int time = 0;
  DateTime nowTime = DateTime.now();
  late PostController con;
  bool loadingFlag = true;
  bool postsFlag = false;
  int postsCount = 0;
  int newPostNum = 0;
  var showTenCountPosts = [];
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      if (maxScroll - currentScroll <= 10) {
        setState(() {
          postsFlag = true;
        });
      }
    });
    super.initState();
    if (nowTime.hour > 12) {
      time = 1;
    } else if (nowTime.hour > 20) {
      time = 2;
    }
    final Stream<QuerySnapshot> postStream =
        Helper.postCollection.orderBy('postTime').snapshots();
    con.getAllPost().then((value) {
      loadingFlag = false;
      setState(() {});
      postStream.listen((event) {
        print('difference');
        newPostNum = event.docs
                .where((post) =>
                    (post['postAdmin'] == UserManager.userInfo['uid'] ||
                        post['privacy'] == 'Public'))
                .length -
            con.posts.length;
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (postsFlag == true) {
      if (con.posts.isNotEmpty) {
        if (postsCount <= con.posts.length) {
          int totalPostsCount = 0;
          int remainderPostsCount = 0;
          remainderPostsCount = con.posts.length - postsCount;
          if (remainderPostsCount < 10) {
            totalPostsCount = postsCount + remainderPostsCount;
          } else {
            totalPostsCount = postsCount + 10;
          }
          for (int i = postsCount; i < totalPostsCount; i++) {
            showTenCountPosts.add(con.posts[i]);
            setState(() {
              postsCount = showTenCountPosts.length;
              postsFlag = false;
            });
          }
        }
      }
    } else {
      if (con.posts.isNotEmpty) {
        if (postsCount <= con.posts.length) {
          int totalPostsCount = 0;
          if (con.posts.length < 10) {
            totalPostsCount = con.posts.length - postsCount;
          } else {
            totalPostsCount = 10;
          }
          for (int i = postsCount; i < totalPostsCount; i++) {
            showTenCountPosts.add(con.posts[i]);
            setState(() {
              postsCount = showTenCountPosts.length;
            });
          }
        }
      }
    }
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MindPost(),
          const Padding(padding: EdgeInsets.only(top: 20)),
          showDayTimeM
              ? DayTimeM(time: time, username: UserManager.userInfo['fullName'])
              : Container(),
          newPostNum == 0
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
                  onPressed: () {
                    loadingFlag = true;
                    newPostNum = 0;
                    setState(() {});
                    con.getAllPost().then((value) {
                      loadingFlag = false;
                      setState(() {});
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
          Container(
              padding: const EdgeInsets.all(6),
              width: SizeConfig(context).screenWidth < 600
                  ? SizeConfig(context).screenWidth
                  : 650,
              height: 760,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    loadingFlag
                        ? const SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              color: Colors.grey,
                            ),
                          )
                        : Expanded(
                            child: Column(
                              children: showTenCountPosts
                                  .map((product) => PostCell(
                                        postInfo: product,
                                        routerChange: widget.routerChange,
                                      ))
                                  .toList(),
                            ),
                          )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
