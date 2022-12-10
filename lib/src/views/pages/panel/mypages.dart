// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/pages/widget/pagecell.dart';

import '../../../controllers/PostController.dart';
import '../../../models/chatModel.dart';

class MyPages extends StatefulWidget {
  MyPages({Key? key})
      : con = PostController(),
        super(key: key);
  late PostController con;
  State createState() => MyPagesState();
}

class MyPagesState extends mvc.StateMVC<MyPages> {
  bool check1 = false;
  bool check2 = false;
  late PostController con;
  var userInfo = UserManager.userInfo;
  var myPages = [];
  int arrayLength = 0;
  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    con.setState(() {});
    super.initState();
    getPageNow();
  }

  void getPageNow() {
    con.getPage('manage').then((value) => {
          myPages = value,
          print(myPages),
          setState(() {}),
        });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = SizeConfig(context).screenWidth - SizeConfig.leftBarWidth;
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: GridView.count(
              crossAxisCount: screenWidth > 800
                  ? 4
                  : screenWidth > 600
                      ? 3
                      : screenWidth > 210
                          ? 2
                          : 1,
              childAspectRatio: 2 / 3,
              padding: const EdgeInsets.all(4.0),
              mainAxisSpacing: 4.0,
              shrinkWrap: true,
              crossAxisSpacing: 4.0,
              children: myPages
                  .map((page) => PageCell(
                      pageTap: () {
                        Navigator.pushReplacementNamed(
                            context, '/pages/${page['pageUserName']}');
                      },
                      buttonFun: () {
                        con.likedPage(page['id']).then((value) {
                          getPageNow();
                        });
                      },
                      picture: '',
                      status: false,
                      likes: page['data']['pageLiked'].length,
                      header: page['data']['pageName'],
                      liked: page['liked']))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
