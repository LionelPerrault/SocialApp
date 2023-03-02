import 'package:badges/badges.dart' as badges;
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
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as PostController;
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
      height: 100,
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
              child: Row(
                children: const [
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
                      width: 100,
                      height: 40,
                      color: tab == 'Going'
                          ? Colors.white
                          : Color.fromRGBO(240, 240, 240, 1),
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
                              style: TextStyle(color: Colors.white),
                            ),
                            badgeStyle: badges.BadgeStyle(
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
                      width: 100,
                      height: 40,
                      color: tab == 'Interested'
                          ? Colors.white
                          : Color.fromRGBO(240, 240, 240, 1),
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
                              style: TextStyle(color: Colors.white),
                            ),
                            badgeStyle: badges.BadgeStyle(
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
                      width: 100,
                      height: 40,
                      color: tab == 'Invited'
                          ? Colors.white
                          : Color.fromRGBO(240, 240, 240, 1),
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
                              style: TextStyle(color: Colors.white),
                            ),
                            badgeStyle: badges.BadgeStyle(
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
                      width: 100,
                      height: 40,
                      color: tab == 'Invites'
                          ? Colors.white
                          : Color.fromRGBO(240, 240, 240, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Invites',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          badges.Badge(
                            badgeContent: Text(
                              '${con.event["eventInvites"].length}',
                              style: TextStyle(color: Colors.white),
                            ),
                            badgeStyle: badges.BadgeStyle(
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
            child: Text('${con.event['eventName']} doesn`t have photos',
                style:
                    const TextStyle(color: Color.fromRGBO(108, 117, 125, 1))),
          )
        : Container(
            child: Row(
            children: [
              Expanded(
                child: GridView.count(
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
                  children: going
                      .map((user) => UserCell(
                          eventTap: () {
                            ProfileController().updateProfile(user["userName"]);
                            widget.routerChange({
                              'router': RouteNames.profile,
                              'subRouter': user["userName"],
                            });
                          },
                          picture: user['userAvatar'] ?? '',
                          header: user['fullName']))
                      .toList(),
                ),
              )
            ],
          ));
  }

  Widget InterestedData() {
    List interested = con.event['eventInterested'];
    return interested.isEmpty
        ? Container(
            padding: const EdgeInsets.only(top: 40),
            alignment: Alignment.center,
            child: Text('${con.event['eventName']} doesn`t have albums',
                style:
                    const TextStyle(color: Color.fromRGBO(108, 117, 125, 1))),
          )
        : Container(
            child: Row(
            children: [
              Expanded(
                child: GridView.count(
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
                          picture: user['userAvatar'] ?? '',
                          header: user['fullName']))
                      .toList(),
                ),
              )
            ],
          ));
  }

  Widget InvitedData() {
    List invited = con.event['eventInvited'];
    return invited.isEmpty
        ? Container(
            padding: const EdgeInsets.only(top: 40),
            alignment: Alignment.center,
            child: Text('${con.event['eventName']} doesn`t have albums',
                style:
                    const TextStyle(color: Color.fromRGBO(108, 117, 125, 1))),
          )
        : Container(
            child: Row(
            children: [
              Expanded(
                child: GridView.count(
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
                          picture: user['userAvatar'] ?? '',
                          header: user['fullName']))
                      .toList(),
                ),
              )
            ],
          ));
  }

  Widget InvitesData() {
    List invites = con.event['eventInvited'];
    return invites.isEmpty
        ? Container(
            padding: const EdgeInsets.only(top: 40),
            alignment: Alignment.center,
            child: Text('${con.event['eventName']} doesn`t have albums',
                style:
                    const TextStyle(color: Color.fromRGBO(108, 117, 125, 1))),
          )
        : Container(
            child: Row(
            children: [
              Expanded(
                child: GridView.count(
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
                          picture: user['userAvatar'] ?? '',
                          header: user['fullName']))
                      .toList(),
                ),
              )
            ],
          ));
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
                margin: EdgeInsets.only(top: 50),
                padding: EdgeInsets.only(top: 50),
                decoration: BoxDecoration(
                  color: Colors.grey[350],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
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
                    Padding(padding: EdgeInsets.only(top: 10))
                  ],
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                width: 100,
                height: 100,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)),
                child: picture != ''
                    ? CircleAvatar(
                        radius: 78,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                            radius: 75,
                            backgroundImage:
                                NetworkImage(con.group['groupPicture'])),
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
