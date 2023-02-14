// ignore_for_file: prefer_const_constructors

import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PeopleController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/people/discoverScreen.dart';
import 'package:shnatter/src/views/people/friendRequestsScreen.dart';
import 'package:shnatter/src/views/people/sendRequestsScreen.dart';

class PeopleScreen extends StatefulWidget {
  PeopleScreen({Key? key, required this.routerChange})
      : con = PeopleController(),
        super(key: key);
  final PeopleController con;
  Function routerChange;

  @override
  State createState() => PeopleScreenState();
}

class PeopleScreenState extends mvc.StateMVC<PeopleScreen>
    with SingleTickerProviderStateMixin {
  late PeopleController con;
  final ScrollController _scrollController = ScrollController();

  //route variable
  @override
  void initState() {
    add(widget.con);
    con = controller as PeopleController;
    Helper.getJSONPreference(Helper.userField)
        .then((value) async => {await con.getUserList(), setState(() {})});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          right: SizeConfig(context).screenWidth < 700 ? 30 : 70,
          top: 10,
          left: SizeConfig(context).screenWidth < 700 ? 30 : 70),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          mainTabWidget(),
          con.tabName == 'Discover'
              ? PeopleDiscoverScreen(
                  routerChange: widget.routerChange,
                )
              : con.tabName == 'Friend Requests'
                  ? FriendRequestsScreen()
                  : SendRequestsScreen()
        ],
      ),
    );
  }

  Widget mainTabWidget() {
    print(con.sendFriends.length);
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        child: Container(
          height: 67,
          width: SizeConfig(context).screenWidth < 700
              ? SizeConfig(context).screenWidth
              : SizeConfig(context).screenWidth * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Row(children: [
            InkWell(
                onTap: () async {
                  con.tabName = 'Discover';
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.only(top: 19.5),
                  width: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Discover',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      con.tabName == 'Discover'
                          ? Container(
                              margin: EdgeInsets.only(top: 4.5),
                              height: 2,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2))),
                            )
                          : Container(
                              margin: EdgeInsets.only(top: 19),
                            )
                    ],
                  ),
                )),
            InkWell(
                onTap: () async {
                  await con.getReceiveRequestsFriends();
                  con.tabName = 'Friend Requests';
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.only(top: 15),
                  width: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Friend Requests',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          badges.Badge(
                            badgeStyle: badges.BadgeStyle(
                              badgeColor: Colors.blue,
                            ),
                            badgeContent: Text(
                              con.requestFriends.length.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      con.tabName == 'Friend Requests'
                          ? Container(
                              //margin: EdgeInsets.only(top: 17),
                              height: 2,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2))),
                            )
                          : Container(
                              margin: EdgeInsets.only(top: 19),
                            )
                    ],
                  ),
                )),
            InkWell(
                onTap: () async {
                  con.tabName = 'Send Requests';
                  await con.getSendRequestsFriends();
                  setState(() {});
                },
                child: Container(
                  width: 130,
                  padding: EdgeInsets.only(top: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Send Requests',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          badges.Badge(
                            badgeStyle: badges.BadgeStyle(
                              badgeColor: Colors.blue,
                            ),
                            badgeContent: Text(
                              con.sendFriends.length.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      con.tabName == 'Send Requests'
                          ? Container(
                              //margin: EdgeInsets.only(top: 17),
                              height: 2,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2))),
                            )
                          : Container(
                              margin: EdgeInsets.only(top: 19),
                            )
                    ],
                  ),
                ))
          ]),
        ));
  }
}
