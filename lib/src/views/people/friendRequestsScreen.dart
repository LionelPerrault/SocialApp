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
import 'package:shnatter/src/views/people/searchScreen.dart';

import '../../controllers/ChatController.dart';

class FriendRequestsScreen extends StatefulWidget {
  FriendRequestsScreen({Key? key})
      : con = PeopleController(),
        super(key: key);
  final PeopleController con;
  @override
  State createState() => FriendRequestsScreenState();
}

class FriendRequestsScreenState extends mvc.StateMVC<FriendRequestsScreen> {
  bool showMenu = false;
  late PeopleController con;
  var isConfirmRequest = {};
  var isDeclineRequest = {};
  var isDeleteRequest = {};
  //route variable
  String tabName = 'Discover';
  Color color = Color.fromRGBO(230, 236, 245, 1);
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    add(widget.con);

    con = controller as PeopleController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizeConfig(context).screenWidth > 900
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              requestFriendWidget(),
              Padding(padding: EdgeInsets.only(left: 20)),
              SearchScreen(
                onClick: (value) {
                  con.fieldSearch(value);

                  setState(() {});
                },
              )
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SearchScreen(
                onClick: (value) {
                  con.fieldSearch(value);
                  setState(() {});
                },
              ),
              requestFriendWidget(),
            ],
          );
  }

  Widget requestFriendWidget() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(top: 20),
      color: Colors.white,
      width: SizeConfig(context).screenWidth < 900
          ? SizeConfig(context).screenWidth - 60
          : SizeConfig(context).screenWidth * 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(top: 15)),
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              con.isSearch
                  ? 'Search Results'
                  : 'Respond to Your Friend Request',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 13),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 15)),
          Container(
            height: 1,
            color: color,
          ),
          con.isSearch && con.requestFriends.isEmpty
              ? Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(top: 20, bottom: 50),
                  child: Text('No people available for your search',
                      style: TextStyle(fontSize: 14)))
              :con.requestFriends.isEmpty ?
              Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(top: 20, bottom: 50),
                  child: Text('No new requests',
                      style: TextStyle(fontSize: 14)))
              : Column(
                  children: con.requestFriends
                      .asMap()
                      .entries
                      .map((e) => Container(
                          padding:
                              EdgeInsets.only(top: 10, left: 20, right: 20),
                          child: Column(
                            children: [
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(padding: EdgeInsets.only(left: 10)),
                                    e.value[e.value['requester']]['avatar'] ==
                                            ''
                                        ? CircleAvatar(
                                            radius: 20,
                                            child: SvgPicture.network(
                                                Helper.avatar))
                                        : CircleAvatar(
                                            radius: 20,
                                            backgroundImage: NetworkImage(
                                                e.value[e.value['requester']]
                                                    ['avatar'])),
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 10, top: 5),
                                      child: Text(
                                        e.value[e.value['requester']]['name'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 11),
                                      ),
                                    ),
                                    Flexible(
                                        fit: FlexFit.tight, child: SizedBox()),
                                    Container(
                                      padding: EdgeInsets.only(top: 6),
                                      child: e.value['state'] == 0
                                          ? Row(children: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  isConfirmRequest[e.key] =
                                                      true;
                                                  setState(() {});
                                                  await con.confirmFriend(
                                                      e.value['id'], e.key);
                                                  isConfirmRequest[e.key] =
                                                      false;
                                                  setState(() {});
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.white,
                                                    elevation: 3,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(2.0)),
                                                    minimumSize:
                                                        isConfirmRequest[e.key] !=
                                                                    null &&
                                                                isConfirmRequest[
                                                                    e.key]
                                                            ? const Size(60, 35)
                                                            : const Size(
                                                                80, 35),
                                                    maximumSize:
                                                        isConfirmRequest[e.key] !=
                                                                    null &&
                                                                isConfirmRequest[e.key]
                                                            ? const Size(60, 35)
                                                            : const Size(80, 35)),
                                                child: isConfirmRequest[
                                                                e.key] !=
                                                            null &&
                                                        isConfirmRequest[e.key]
                                                    ? SizedBox(
                                                        width: 10,
                                                        height: 10,
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Colors.black,
                                                        ),
                                                      )
                                                    : Text('Confirm',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900)),
                                              ),
                                              const Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 5)),
                                              ElevatedButton(
                                                onHover: (value) {},
                                                onPressed: () async {
                                                  isDeclineRequest[e.key] =
                                                      true;
                                                  setState(() {});
                                                  await con.deleteFriend(
                                                      e.value['id']);
                                                  await con
                                                      .getReceiveRequestsFriends();
                                                  isDeclineRequest[e.key] =
                                                      false;
                                                  con.getList();
                                                  setState(() {});
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: Color.fromRGBO(
                                                        245, 54, 92, 1),
                                                    elevation: 3,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                2.0)),
                                                    minimumSize: isDeclineRequest[e.key] != null &&
                                                            isDeclineRequest[
                                                                e.key]
                                                        ? const Size(60, 35)
                                                        : const Size(80, 35),
                                                    maximumSize:
                                                        isDeclineRequest[e.key] !=
                                                                    null &&
                                                                isDeclineRequest[e.key]
                                                            ? const Size(60, 35)
                                                            : const Size(80, 35)),
                                                child: isDeclineRequest[
                                                                e.key] !=
                                                            null &&
                                                        isDeclineRequest[e.key]
                                                    ? SizedBox(
                                                        width: 10,
                                                        height: 10,
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    : Text('Decline',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900)),
                                              )
                                            ])
                                          : ElevatedButton(
                                              onPressed: () async {
                                                isDeleteRequest[e.key] = true;
                                                setState(() {});
                                                await con.deleteFriend(
                                                    e.value['id']);
                                                isDeleteRequest[e.key] = false;
                                                setState(() {});
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  elevation: 3,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2.0)),
                                                  minimumSize: isDeleteRequest[
                                                                  e.key] !=
                                                              null &&
                                                          isDeleteRequest[e.key]
                                                      ? const Size(50, 35)
                                                      : const Size(80, 35),
                                                  maximumSize: isDeleteRequest[
                                                                  e.key] !=
                                                              null &&
                                                          isDeleteRequest[e.key]
                                                      ? const Size(50, 35)
                                                      : const Size(80, 35)),
                                              child: isDeleteRequest[e.key] !=
                                                          null &&
                                                      isDeleteRequest[e.key]
                                                  ? SizedBox(
                                                      width: 10,
                                                      height: 10,
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: const [
                                                        Icon(
                                                          Icons.check_circle,
                                                          color: Colors.white,
                                                          size: 13,
                                                        ),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 3)),
                                                        Text('Friend',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900))
                                                      ],
                                                    ),
                                            ),
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
        ],
      ),
    );
  }
}
