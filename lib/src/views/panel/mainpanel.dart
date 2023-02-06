import 'package:flutter/material.dart';
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
    con.getAllPost().then((value) {
      loadingFlag = false;
      setState(() {});
    });
    print('current time is ${nowTime.hour} , $time');
  }

  @override
  Widget build(BuildContext context) {
    if (postsFlag == true) {
      if (con.posts.isNotEmpty) {
        if (postsCount <= con.posts.length) {
          int totalPostsCount = 0;
          int remainderPostsCount = 0;
          print(con.posts.length);
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
          print(con.posts.length);
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
        print(con.posts.length);
        print(postsCount);
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
