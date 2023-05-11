// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/SearcherController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/widget/postCell.dart';

class PostSearch extends StatefulWidget {
  PostSearch({Key? key, required this.routerChange, required this.searchValue})
      : con = SearcherController(),
        super(key: key);
  late SearcherController con;
  Function routerChange;
  String searchValue;
  State createState() => PostSearchState();
}

class PostSearchState extends mvc.StateMVC<PostSearch> {
  late SearcherController searchCon;
  var userInfo = UserManager.userInfo;
  var resultPosts = [];
  @override
  void initState() {
    add(widget.con);
    searchCon = controller as SearcherController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.searchValue != '') {
      resultPosts = searchCon.posts
          .where((post) => (post['header'].contains(widget.searchValue)))
          .toList();

      // resultPosts = searchCon.posts;
      setState(() {});
    } else {
      resultPosts = [];
    }
    return !searchCon.isGetPosts
        ? SizedBox(
            width: 10,
            height: 10,
            child: const CircularProgressIndicator(
              color: Colors.grey,
            ),
          )
        : resultPosts.isEmpty
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
                          borderRadius: BorderRadius.all(Radius.circular(20))),
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
            : SizedBox(
                width: SizeConfig(context).screenWidth,
                height: SizeConfig(context).screenHeight -
                    SizeConfig.navbarHeight -
                    150 -
                    (UserManager.userInfo['isVerify'] ? 0 : 50),
                child: SingleChildScrollView(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            for (int i = 0; i < resultPosts.length; i++)
                              PostCell(
                                postInfo: resultPosts[i],
                                routerChange: widget.routerChange,
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
  }
}
