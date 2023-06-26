// ignore_for_file: prefer_const_constructors

import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:provider/provider.dart';
import 'package:shnatter/src/controllers/PeopleController.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/people/tabs/discoverScreen.dart';
import 'package:shnatter/src/views/people/tabs/friendRequestsScreen.dart';
import 'package:shnatter/src/views/people/tabs/friendsScreen.dart';
import 'package:shnatter/src/views/people/tabs/sendRequestsScreen.dart';
import 'package:flutter/widgets.dart';

class PeopleScreen extends StatefulWidget {
  PeopleScreen({
    Key? key,
    required this.routerChange,
    this.subRouter = '',
  })  : con = PeopleController(),
        super(key: key);
  final PeopleController con;
  String subRouter;
  Function routerChange;

  @override
  State createState() => PeopleScreenState();
}

class PeopleScreenState extends mvc.StateMVC<PeopleScreen>
    with SingleTickerProviderStateMixin {
  late PeopleController con;
  //route variable
  @override
  void initState() {
    add(widget.con);
    super.initState();
    con = controller as PeopleController;
    con.tabName = widget.subRouter == '' ? 'Discover' : widget.subRouter;
    con.addNotifyCallBack(this);
    updateBadge();
  }

  Future<void> updateBadge() async {
    await con.getSendRequest();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        mainTabWidget(context),
        con.tabName == 'Discover'
            ? PeopleDiscoverScreen(
                routerChange: widget.routerChange,
              )
            : con.tabName == 'Friend Requests'
                ? FriendRequestsScreen(routerChange: widget.routerChange)
                : con.tabName == 'Requests Sent'
                    ? SendRequestsScreen(routerChange: widget.routerChange)
                    : FriendsScreen(routerChange: widget.routerChange)
      ],
    );
  }

  Widget mainTabWidget(context) {
    return Container(
      alignment: Alignment.center,
      // margin:
      //     EdgeInsets.only(left: MediaQuery.of(context).size.width / 2 - 177),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          height: 67,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  con.tabName = 'Discover';
                  // reload again.

                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.only(top: 19.5),
                  width: 60,
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
                ),
              ),
              InkWell(
                onTap: () async {
                  con.tabName = 'Friends';
                  // reload again.

                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.only(top: 19.5),
                  width: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Friends',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      con.tabName == 'Friends'
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
                ),
              ),
              InkWell(
                onTap: () async {
                  con.tabName = 'Friend Requests';
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.only(top: 15),
                  width: 130,
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
                          Padding(padding: EdgeInsets.only(left: 5)),
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
                ),
              ),
              InkWell(
                onTap: () async {
                  con.tabName = 'Requests Sent';
                  setState(() {});
                },
                child: Container(
                  width: 120,
                  padding: EdgeInsets.only(top: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Requests Sent',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          Padding(padding: EdgeInsets.only(left: 5)),
                          badges.Badge(
                            badgeStyle: badges.BadgeStyle(
                              badgeColor: Colors.blue,
                            ),
                            badgeContent: ChangeNotifierProvider(
                              create: (context) => con.sendBadge,
                              child: Text(
                                con.sendBadge.badgeNumber.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                      con.tabName == 'Requests Sent'
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
