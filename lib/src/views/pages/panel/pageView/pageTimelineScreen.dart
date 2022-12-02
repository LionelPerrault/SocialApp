import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/box/mindpost.dart';
import 'package:shnatter/src/views/box/searchbox.dart';
import 'package:shnatter/src/views/chat/chatScreen.dart';
import 'package:shnatter/src/views/navigationbar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PageTimelineScreen extends StatefulWidget {
  Function onClick;
  PageTimelineScreen({Key? key, required this.onClick})
      : con = PostController(),
        super(key: key);
  final PostController con;

  @override
  State createState() => PageTimelineScreenState();
}

class PageTimelineScreenState extends mvc.StateMVC<PageTimelineScreen>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  bool showSearch = false;
  late FocusNode searchFocusNode;
  bool showMenu = false;
  late AnimationController _drawerSlideController;
  double width = 0;
  double itemWidth = 0;
  //
  var userInfo = UserManager.userInfo;
  List<Map> mainInfoList = [];
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as PostController;
    mainInfoList = [
      {
        'icon': Icons.thumb_up,
        'text': '${con.page["pageLiked"].length} people like this'
      },
      {'icon': Icons.tag, 'text': 'N/A'},
      {'icon': Icons.location_history, 'text': '${con.page["pageLocation"]}'},
    ];
    _gotoHome();
  }

  late PostController con;
  void _gotoHome() {
    Future.delayed(Duration.zero, () {
      width = SizeConfig(context).screenWidth - 260;
      itemWidth = width / 7.5;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(right: 10, left: 70, top: 15),
      child: SizeConfig(context).screenWidth < 800
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [pageInfowidget(), MindPost()])
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  pageInfowidget(),
                  con.page['pageAdmin']['userName'] ==
                          UserManager.userInfo['userName']
                      ? MindPost()
                      : Container()
                ]),
    );
  }

  Widget pageInfowidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // children: <Widget>[
      //     Text('\$', style: TextStyle(decoration: TextDecoration.lineThrough))
      children: mainInfoList
          .map((e) => Container(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    e['icon'],
                    size: 15,
                    color: Colors.grey,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 5),
                  ),
                  Text(
                    e['text'],
                  )
                ],
              )))
          .toList(),
    );
  }
}
