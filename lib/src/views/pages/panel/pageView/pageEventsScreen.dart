import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PageEventsScreen extends StatefulWidget {
  PageEventsScreen({Key? key})
      : con = PostController(),
        super(key: key);
  final PostController con;
  @override
  State createState() => PageEventsScreenState();
}

class PageEventsScreenState extends mvc.StateMVC<PageEventsScreen> {
  var userInfo = UserManager.userInfo;
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as PostController;
  }

  late PostController con;

  @override
  Widget build(BuildContext context) {
    return Column(children: [mainTabs(), likesData()]);
  }

  Widget mainTabs() {
    return Container(
      width: SizeConfig(context).screenWidth,
      height: 70,
      margin: const EdgeInsets.only(left: 30, right: 30),
      decoration: BoxDecoration(
          color: const Color.fromRGBO(240, 240, 240, 1),
          borderRadius: BorderRadius.circular(3),
          border: const Border(
              bottom: BorderSide(
                  width: 0.5, color: Color.fromRGBO(240, 240, 240, 1)))),
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          Container(
              margin: const EdgeInsets.only(left: 20, top: 30),
              child: Row(
                children: const [
                  Icon(
                    Icons.add_box,
                    size: 17,
                  ),
                  Padding(padding: EdgeInsets.only(left: 5)),
                  Text(
                    'Events',
                    style: TextStyle(fontSize: 15),
                  )
                ],
              )),
        ],
      ),
    );
  }

  Widget likesData() {
    return userInfo['events'] == null
        ? Container(
            padding: const EdgeInsets.only(top: 40),
            alignment: Alignment.center,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                  ))
            ]))
        : Container();
  }
}
