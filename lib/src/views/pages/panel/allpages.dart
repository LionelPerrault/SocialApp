// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/pages/widget/pagecell.dart';

import '../../../controllers/PostController.dart';

class AllPages extends StatefulWidget {
  AllPages({Key? key, required this.routerChange})
      : con = PostController(),
        super(key: key);
  late PostController con;
  Function routerChange;
  State createState() => AllPagesState();
}

class AllPagesState extends mvc.StateMVC<AllPages> {
  bool check1 = false;
  bool check2 = false;
  late PostController con;
  var userInfo = UserManager.userInfo;
  var realAllPage = [];
  int arrayLength = 0;
  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    con.setState(() {});
    super.initState();
    getPageNow();
  }

  getPageNow() {
    con.getPage('all', UserManager.userInfo['uid']).then((value) => {
          realAllPage = value,
          realAllPage.where((event) => event['data']['eventPost'] == true),
          print(realAllPage),
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
              children: realAllPage
                  .map(
                    (page) => PageCell(
                      pageInfo: page,
                      refreshFunc: () {
                        getPageNow();
                      },
                      routerChange: widget.routerChange,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
