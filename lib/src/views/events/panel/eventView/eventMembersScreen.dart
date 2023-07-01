import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/profile/model/friends.dart';

// ignore: must_be_immutable
class EventMembersScreen extends StatefulWidget {
  Function onClick;
  EventMembersScreen(
      {Key? key, required this.onClick, required this.routerChange})
      : con = PostController(),
        super(key: key);
  final PostController con;
  Function routerChange;

  @override
  State createState() => EventMembersScreenState();
}

class EventMembersScreenState extends mvc.StateMVC<EventMembersScreen> {
  var userInfo = UserManager.userInfo;
  String tab = 'Going';
  List invites = [];
  Friends friendModel = Friends();

  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as PostController;
    friendModel.getFriends(UserManager.userInfo['uid']).then((value) async {
      for (var index = 0; index < friendModel.friends.length; index++) {
        var friendUserName = friendModel.friends[index]['requester'].toString();
        if (friendUserName == UserManager.userInfo['userName']) {
          friendUserName = friendModel.friends[index]['receiver'].toString();
        }

        var snapshot = await FirebaseFirestore.instance
            .collection('user')
            .where('userName', isEqualTo: friendUserName)
            .get();
        String userid = snapshot.docs[0].id.toString();
        var data = snapshot.docs[0].data();
        if (con.boolInvited(con.event, userid)) {
          friendModel.friends.removeAt(index);
          setState(() {});
          index--;
        } else {
          invites.add({
            'userName': friendUserName,
            'avatar': data['avatar'],
            'fullName': data['firstName'] + data['lastName']
          });
          setState(() {});
        }
      }
    });
  }

  late PostController con;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      mainTabs(),
      tab == 'Going'
          ? GoingData()
          : tab == 'Interested'
              ? InterestedData()
              : tab == 'Invited'
                  ? InvitedData()
                  : InvitesData()
    ]);
  }

  Widget mainTabs() {
    return Container(
      width: SizeConfig(context).screenWidth,
      height: 110,
      margin: const EdgeInsets.only(left: 30, right: 30),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(240, 240, 240, 1),
        borderRadius: BorderRadius.circular(3),
      ),
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          Container(
              margin: const EdgeInsets.only(left: 20, top: 20),
              child: const Row(
                children: [
                  Icon(
                    Icons.groups,
                    size: 15,
                  ),
                  Padding(padding: EdgeInsets.only(left: 5)),
                  Text(
                    'Members',
                    style: TextStyle(fontSize: 15),
                  )
                ],
              )),
          Container(
            margin: const EdgeInsets.only(top: 22),
            child: Row(children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    tab = 'Going';
                    setState(() {});
                  },
                  child: Container(
                      alignment: Alignment.center,
                      width: 80,
                      height: 40,
                      color: tab == 'Going'
                          ? Colors.white
                          : const Color.fromRGBO(240, 240, 240, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Going',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          badges.Badge(
                            badgeContent: Text(
                              '${con.event["eventGoing"].length}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            badgeStyle: const badges.BadgeStyle(
                              badgeColor: Color.fromARGB(255, 23, 162, 184),
                            ),
                          )
                        ],
                      )),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    tab = 'Interested';
                    setState(() {});
                  },
                  child: Container(
                      alignment: Alignment.center,
                      width: 90,
                      height: 40,
                      color: tab == 'Interested'
                          ? Colors.white
                          : const Color.fromRGBO(240, 240, 240, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Interested',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          badges.Badge(
                            badgeContent: Text(
                              '${con.event["eventInterested"].length}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            badgeStyle: const badges.BadgeStyle(
                              badgeColor: Color.fromARGB(255, 23, 162, 184),
                            ),
                          )
                        ],
                      )),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    tab = 'Invited';
                    setState(() {});
                  },
                  child: Container(
                      alignment: Alignment.center,
                      width: 80,
                      height: 40,
                      color: tab == 'Invited'
                          ? Colors.white
                          : const Color.fromRGBO(240, 240, 240, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Invited',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          badges.Badge(
                            badgeContent: Text(
                              '${con.event["eventInvited"].length}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            badgeStyle: const badges.BadgeStyle(
                              badgeColor: Color.fromARGB(255, 23, 162, 184),
                            ),
                          )
                        ],
                      )),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    tab = 'Invites';
                    setState(() {});
                  },
                  child: Container(
                      alignment: Alignment.center,
                      width: 80,
                      height: 40,
                      color: tab == 'Invites'
                          ? Colors.white
                          : const Color.fromRGBO(240, 240, 240, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Invites',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          badges.Badge(
                            badgeContent: Text(
                              '${invites.length}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            badgeStyle: const badges.BadgeStyle(
                              badgeColor: Color.fromARGB(255, 23, 162, 184),
                            ),
                          )
                        ],
                      )),
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }

  Widget GoingData() {
    List going = con.event['eventGoing'];
    return going.isEmpty
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
        : Row(
            children: [
              Expanded(
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: SizeConfig(context).screenWidth > 800
                      ? 4
                      : SizeConfig(context).screenWidth > 600
                          ? 3
                          : SizeConfig(context).screenWidth > 210
                              ? 2
                              : 1,
                  childAspectRatio: 1.25,
                  padding: const EdgeInsets.all(4.0),
                  mainAxisSpacing: 4.0,
                  shrinkWrap: true,
                  crossAxisSpacing: 4.0,
                  children: going
                      .map((user) => UserCell(
                          eventTap: () {
                            ProfileController().updateProfile(user["userName"]);
                            widget.routerChange({
                              'router': RouteNames.profile,
                              'subRouter': user["userName"],
                            });
                          },
                          picture: user['avatar'] ?? '',
                          header: user['fullName']))
                      .toList(),
                ),
              )
            ],
          );
  }

  Widget InterestedData() {
    List interested = con.event['eventInterested'];
    return interested.isEmpty
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
        : Row(
            children: [
              Expanded(
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: SizeConfig(context).screenWidth > 800
                      ? 4
                      : SizeConfig(context).screenWidth > 600
                          ? 3
                          : SizeConfig(context).screenWidth > 210
                              ? 2
                              : 1,
                  childAspectRatio: 1 / 1,
                  padding: const EdgeInsets.all(4.0),
                  mainAxisSpacing: 4.0,
                  shrinkWrap: true,
                  crossAxisSpacing: 4.0,
                  children: interested
                      .map((user) => UserCell(
                          eventTap: () {
                            ProfileController().updateProfile(user["userName"]);
                            widget.routerChange({
                              'router': RouteNames.profile,
                              'subRouter': user["userName"],
                            });
                          },
                          picture: user['avatar'] ?? '',
                          header: user['fullName']))
                      .toList(),
                ),
              )
            ],
          );
  }

  Widget InvitedData() {
    List invited = con.event['eventInvited'];
    return invited.isEmpty
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
        : Row(
            children: [
              Expanded(
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: SizeConfig(context).screenWidth > 800
                      ? 4
                      : SizeConfig(context).screenWidth > 600
                          ? 3
                          : SizeConfig(context).screenWidth > 210
                              ? 2
                              : 1,
                  childAspectRatio: 1 / 1,
                  padding: const EdgeInsets.all(4.0),
                  mainAxisSpacing: 4.0,
                  shrinkWrap: true,
                  crossAxisSpacing: 4.0,
                  children: invited
                      .map((user) => UserCell(
                          eventTap: () {
                            ProfileController().updateProfile(user["userName"]);
                            widget.routerChange({
                              'router': RouteNames.profile,
                              'subRouter': user["userName"],
                            });
                          },
                          picture: user['avatar'] ?? '',
                          header: user['fullName']))
                      .toList(),
                ),
              )
            ],
          );
  }

  Widget InvitesData() {
    return invites.isEmpty
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
        : Row(
            children: [
              Expanded(
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: SizeConfig(context).screenWidth > 800
                      ? 4
                      : SizeConfig(context).screenWidth > 600
                          ? 3
                          : SizeConfig(context).screenWidth > 210
                              ? 2
                              : 1,
                  childAspectRatio: 1 / 1,
                  padding: const EdgeInsets.all(4.0),
                  mainAxisSpacing: 4.0,
                  shrinkWrap: true,
                  crossAxisSpacing: 4.0,
                  children: invites
                      .map((user) => UserCell(
                          eventTap: () {
                            ProfileController().updateProfile(user["userName"]);
                            widget.routerChange({
                              'router': RouteNames.profile,
                              'subRouter': user["userName"],
                            });
                          },
                          picture: user['avatar'] ?? '',
                          header: user['fullName']))
                      .toList(),
                ),
              )
            ],
          );
  }

  Widget UserCell(
      {required Null Function() eventTap,
      required header,
      required String picture}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          width: 160,
          height: 150,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                width: 160,
                margin: const EdgeInsets.only(top: 50),
                padding: const EdgeInsets.only(top: 50),
                decoration: BoxDecoration(
                  color: Colors.grey[350],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Container(
                      alignment: Alignment.center,
                      width: 150,
                      child: RichText(
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: header,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  eventTap();
                                }),
                        ]),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10))
                  ],
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                width: 100,
                height: 100,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)),
                child: picture != ''
                    ? CircleAvatar(
                        radius: 78,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                            radius: 75, backgroundImage: NetworkImage(picture)),
                      )
                    : CircleAvatar(
                        radius: 78,
                        backgroundColor: Colors.white,
                        child: SvgPicture.network(
                          Helper.avatar,
                          width: 96,
                          height: 96,
                        ),
                      ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
