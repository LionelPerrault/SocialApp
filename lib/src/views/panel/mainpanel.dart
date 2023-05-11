import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
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

const int defaultSlide = 10;

enum PostType { timeline, profile, event }

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
  bool nextPostFlag = true;

  bool hasMore = true; // flag for more posts available or not

  var showTenCountPosts = [];

  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;

    super.initState();
    if (nowTime.hour > 12) {
      time = 1;
    } else if (nowTime.hour > 20) {
      time = 2;
    }
    final Stream<QuerySnapshot> postStream =
        Helper.postCollection.orderBy('postTime').snapshots();
    loadingFlag = true;

    con
        .getTimelinePost(defaultSlide, 1, PostType.timeline.index, '')
        .then((value) {
      setState(() {
        nextPostFlag = value;
        loadingFlag = false;
        newPostNum = 0;
      });
    });

    postStream.listen((event) {
      newPostNum = event.docs.where((post) {
        Map data = post.data() as Map;

        var followers = [];
        if (data.containsKey("followers")) followers = [...data['followers']];

        bool newPostFlag = false;
        if (con.postsTimeline.isEmpty) {
          newPostFlag = true;
        } else {
          newPostFlag =
              Timestamp(post['postTime'].seconds, post['postTime'].nanoseconds)
                  .toDate()
                  .isAfter(con.postsTimeline[0]['time'].toDate());
        }
        return (post['postAdmin'] == UserManager.userInfo['uid'] ||
                ((post['privacy'] == 'Public' ||
                        post['privacy'] == 'Friends') &&
                    followers.contains(UserManager.userInfo['userName']))) &&
            newPostFlag;
      }).length;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 20,
        left: 0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MindPost(showPrivacy: true),
          const Padding(padding: EdgeInsets.only(top: 20)),
          showDayTimeM
              ? DayTimeM(time: time, username: UserManager.userInfo['fullName'])
              : Container(),
          const Padding(padding: EdgeInsets.only(bottom: 30)),
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
                    setState(() {
                      loadingFlag = true;
                    });

                    await con.getTimelinePost(
                        newPostNum, -1, PostType.timeline.index, '');

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
          SizedBox(
            width: 600,
            child: con.postsTimeline.isEmpty
                ? const SizedBox() // Return an empty SizedBox widget when the list is empty
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: con.postsTimeline.length,
                          itemBuilder: (BuildContext context, int index) {
                            return PostCell(
                              postInfo: con.postsTimeline[index],
                              routerChange: widget.routerChange,
                            );
                          },
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
          loadingFlagBottom || loadingFlag || !nextPostFlag
              ? !nextPostFlag && !loadingFlag
                  ? Container(
                      padding: const EdgeInsets.only(top: 40),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.network(Helper.emptySVG, width: 90),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            width: 140,
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(240, 240, 240, 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: const Text(
                              'No data to show',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(108, 117, 125, 1)),
                            ),
                          ),
                        ],
                      ),
                    )
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
                    var t = await con.getTimelinePost(
                        defaultSlide, 0, PostType.timeline.index, '');
                    setState(() {
                      nextPostFlag = t;
                      loadingFlagBottom = false;
                    });
                  },
                  child: const Column(
                    children: [
                      Padding(padding: EdgeInsets.only(top: 11.0)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Load More...',
                            style: TextStyle(
                                color: Color.fromARGB(255, 90, 90, 90),
                                fontFamily: 'var(--body-font-family)',
                                fontWeight: FontWeight.w900,
                                fontSize: 15),
                          )
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 8.0)),
                    ],
                  ),
                ),
          const Padding(padding: EdgeInsets.only(top: 18.0)),
        ],
      ),
    );
  }
}
