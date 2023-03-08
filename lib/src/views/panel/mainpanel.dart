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
  bool loadingFlag = false;
  bool loadingFlagBottom = false;
  bool postsFlag = false;
  bool isLoading = false; // track if posts fetching
  int documentLimit = 10; // documents to be fetched per request
  late DocumentSnapshot
      lastDocument; // flag for last document from where next 10 records to be fetched
  int postsCount = 0;
  int newPostNum = 0;
  int nextPostNum = 0;
  var lastTime;
  bool hasMore = true; // flag for more posts available or not

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
    loadingFlag = true;
    con.getAllPost(0).then((value) {
      loadingFlag = false;
      setState(() {});
      postStream.listen((event) {
        newPostNum = event.docs
                .where((post) =>
                    (post['postAdmin'] == UserManager.userInfo['uid'] ||
                        post['privacy'] == 'Public'))
                .length -
            con.allposts;

        nextPostNum = event.docs
                .where((post) =>
                    (post['postAdmin'] == UserManager.userInfo['uid'] ||
                        post['privacy'] == 'Public'))
                .length -
            10;
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
          newPostNum <= 0
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
                    setState(() {});
                    loadingFlag = true;
                    setState(() {});
                    await con.addNewPosts(newPostNum);
                    //await con.getAllPost();
                    con.allposts = con.allposts + newPostNum;
                    newPostNum = 0;
                    loadingFlag = false;
                    setState(() {});
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
          SizedBox(
            width: 600,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: con.posts
                        .map((product) => PostCell(
                              postInfo: product,
                              routerChange: widget.routerChange,
                            ))
                        .toList(),
                  ),
                )
              ],
            ),
          ),
          loadingFlagBottom
              ? const SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    color: Colors.grey,
                  ),
                )
              : const SizedBox(),
          nextPostNum <= 0 || loadingFlagBottom
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
                    setState(() {});
                    loadingFlagBottom = true;
                    var newPostNumP = nextPostNum > 10 ? 10 : nextPostNum;
                    await con.loadNextPosts(newPostNumP, 0);
                    //await con.getAllPost();
                    nextPostNum = nextPostNum - newPostNumP;
                    loadingFlagBottom = false;
                    setState(() {});
                  },
                  child: Column(
                    children: [
                      const Padding(padding: EdgeInsets.only(top: 11.0)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Load More...',
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
        ],
      ),
    );
  }
}
