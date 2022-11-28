// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PeopleController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/box/searchbox.dart';
import 'package:shnatter/src/views/chat/chatScreen.dart';
import 'package:shnatter/src/views/chat/chatUserListScreen.dart';
import 'package:shnatter/src/views/chat/emoticonScreen.dart';
import 'package:shnatter/src/views/chat/newMessageScreen.dart';
import 'package:shnatter/src/views/navigationbar.dart';
import 'package:shnatter/src/views/panel/leftpanel.dart';

import '../../controllers/ChatController.dart';

class PeopleDiscoverScreen extends StatefulWidget {
  PeopleDiscoverScreen({Key? key})
      : con = PeopleController(),
        super(key: key);
  final PeopleController con;
  @override
  State createState() => PeopleDiscoverScreenState();
}

class PeopleDiscoverScreenState extends mvc.StateMVC<PeopleDiscoverScreen> {
  bool showMenu = false;
  late PeopleController con;
  //route variable
  String tabName = 'Discover';
  Color color = Color.fromRGBO(230, 236, 245, 1);
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    add(widget.con);
    con = controller as PeopleController;
    con.getUserList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(top: 20),
      color: Colors.white,
      width: SizeConfig(context).screenWidth / 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(top: 15)),
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'People You May Know',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 15)),
          Container(
            height: 1,
            color: color,
          ),
          Column(
              children: con.userList
                  .map((e) => Container(
                      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                      child: Column(
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(padding: EdgeInsets.only(left: 10)),
                                e['avatar'] == ''
                                    ? CircleAvatar(
                                        radius: 20,
                                        child:
                                            SvgPicture.network(Helper.avatar))
                                    : CircleAvatar(
                                        radius: 20,
                                        backgroundImage:
                                            NetworkImage(e['avatar'])),
                                Container(
                                  padding: EdgeInsets.only(left: 10, top: 5),
                                  child: Text(
                                    '${e['firstName']} ${e['lastName']}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 11),
                                  ),
                                ),
                                Flexible(fit: FlexFit.tight, child: SizedBox()),
                                Container(
                                  padding: EdgeInsets.only(top: 6),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 33, 37, 41),
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(2.0)),
                                          minimumSize: const Size(110, 35),
                                          maximumSize: const Size(110, 35)),
                                      onPressed: () {
                                        () => {};
                                      },
                                      child: Row(
                                        children: const [
                                          Icon(
                                            Icons.person_add_alt_rounded,
                                            color: Colors.white,
                                            size: 18.0,
                                          ),
                                          Text(' Add Friend',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w900)),
                                        ],
                                      )),
                                )
                              ]),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          Container(
                            height: 1,
                            color: color,
                          ),
                        ],
                      )))
                  .toList()),
          InkWell(
            child: Container(color: Color.fromRGBO(55, 213, 242, 1)),
          )
        ],
      ),
    );
  }
}
