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
      width: SizeConfig(context).screenWidth < 700 ? SizeConfig(context).screenWidth : SizeConfig(context).screenWidth / 2,
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
                  .asMap()
                  .entries
                  .map((e) => Container(
                      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                      child: Column(
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(padding: EdgeInsets.only(left: 10)),
                                e.value['avatar'] == ''
                                    ? CircleAvatar(
                                        radius: 20,
                                        child:
                                            SvgPicture.network(Helper.avatar))
                                    : CircleAvatar(
                                        radius: 20,
                                        backgroundImage:
                                            NetworkImage(e.value['avatar'])),
                                Container(
                                  padding: EdgeInsets.only(left: 10, top: 5),
                                  child: Text(
                                    '${e.value['firstName']} ${e.value['lastName']}',
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
                                      onPressed: () async {
                                        await con.requestFriend(
                                            e.value['userName'],
                                            '${e.value['firstName']} ${e.value['lastName']}',e.value['avatar'],e.key);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 33, 37, 41),
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(2.0)),
                                          minimumSize:
                                              con.isFriendRequest[e.key] != null &&
                                                      con.isFriendRequest[e.key]
                                                  ? const Size(90, 35)
                                                  : const Size(110, 35),
                                          maximumSize:
                                              con.isFriendRequest[e.key] != null &&
                                                      con.isFriendRequest[e.key]
                                                  ? const Size(90, 35)
                                                  : const Size(110, 35)),
                                      child: con.isFriendRequest[e.key] != null &&
                                              con.isFriendRequest[e.key]
                                          ? SizedBox(
                                              width: 10,
                                              height: 10,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            )
                                          : Row(
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
                                                        fontWeight:
                                                            FontWeight.w900)),
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
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: InkWell(
              onTap: () async {
                con.pageIndex++;
                con.isShowProgressive = true;
                setState(() {});
                await con.getUserList();
                con.isShowProgressive = false;
                setState(() {});
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(55, 213, 242, 1),
                    borderRadius: BorderRadius.all(Radius.circular(3))),
                alignment: Alignment.center,
                height: 45,
                child: con.isShowProgressive
                    ? const SizedBox(
                        width: 20,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          color: Colors.grey,
                        ),
                      )
                    : Text('See More', style: TextStyle(color: Colors.white)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
