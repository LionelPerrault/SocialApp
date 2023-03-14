// ignore_for_file: non_constant_identifier_names, avoid_unnecessary_containers

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

class GroupMembersScreen extends StatefulWidget {
  Function onClick;
  GroupMembersScreen(
      {Key? key, required this.onClick, required this.routerChange})
      : con = PostController(),
        super(key: key);
  final PostController con;
  Function routerChange;

  @override
  State createState() => GroupMembersScreenState();
}

class GroupMembersScreenState extends mvc.StateMVC<GroupMembersScreen> {
  var userInfo = UserManager.userInfo;
  String tab = 'Members';
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as PostController;
  }

  late PostController con;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      mainTabs(),
      tab == 'Members' ? MembersData() : InvitesData()
    ]);
  }

  Widget mainTabs() {
    return Container(
      width: SizeConfig(context).screenWidth > SizeConfig.mediumScreenSize
          ? SizeConfig(context).screenWidth - SizeConfig.leftBarWidth - 60
          : SizeConfig(context).screenWidth - 60,
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
                    tab = 'Members';
                    setState(() {});
                  },
                  child: Container(
                      alignment: Alignment.center,
                      width: 100,
                      height: 40,
                      color: tab == 'Members'
                          ? Colors.white
                          : const Color.fromRGBO(240, 240, 240, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Members',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          badges.Badge(
                            badgeContent: Text(
                              '${con.group["groupJoined"].length}',
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
                      width: 100,
                      height: 40,
                      color: tab == 'Invites'
                          ? Colors.white
                          : const Color.fromRGBO(240, 240, 240, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Invites',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
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

  Widget MembersData() {
    List members = con.group['groupJoined'];
    return members.isEmpty
        ? Container(
            padding: const EdgeInsets.only(top: 40),
            alignment: Alignment.center,
            child: Text('${con.group['groupName']} doesn`t have photos',
                style:
                    const TextStyle(color: Color.fromRGBO(108, 117, 125, 1))),
          )
        : Container(
            height: 400,
            width: SizeConfig(context).screenWidth > SizeConfig.mediumScreenSize
                ? SizeConfig(context).screenWidth - SizeConfig.leftBarWidth - 60
                : SizeConfig(context).screenWidth - 60,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GridView.count(
                crossAxisCount: SizeConfig(context).screenWidth > 800
                    ? 4
                    : SizeConfig(context).screenWidth > 600
                        ? 3
                        : SizeConfig(context).screenWidth > 410
                            ? 2
                            : 1,
                childAspectRatio: 1 / 1,
                padding: const EdgeInsets.all(4.0),
                mainAxisSpacing: 4.0,
                shrinkWrap: true,
                crossAxisSpacing: 4.0,
                children: members
                    .map((user) => UserCell(
                        groupTap: () {
                          ProfileController().updateProfile(user["userName"]);
                          widget.routerChange({
                            'router': RouteNames.profile,
                            'subRouter': user["userName"],
                          });
                        },
                        picture: user['avatar'] ?? '',
                        header: user['fullName']))
                    .toList()));
  }

  Widget InvitesData() {
    List invites = [];
    return invites.isEmpty
        ? Container(
            padding: const EdgeInsets.only(top: 40),
            alignment: Alignment.center,
            child: Text('${con.group['groupName']} doesn`t have albums',
                style:
                    const TextStyle(color: Color.fromRGBO(108, 117, 125, 1))),
          )
        : Container(
            height: 400,
            width: SizeConfig(context).screenWidth > SizeConfig.mediumScreenSize
                ? SizeConfig(context).screenWidth - SizeConfig.leftBarWidth - 60
                : SizeConfig(context).screenWidth - 60,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GridView.count(
              crossAxisCount: SizeConfig(context).screenWidth > 800
                  ? 4
                  : SizeConfig(context).screenWidth > 600
                      ? 3
                      : SizeConfig(context).screenWidth > 410
                          ? 2
                          : 1,
              childAspectRatio: 1 / 1,
              padding: const EdgeInsets.all(4.0),
              mainAxisSpacing: 4.0,
              shrinkWrap: true,
              crossAxisSpacing: 4.0,
              children: invites
                  .map((user) => UserCell(
                      groupTap: () {
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
          );
  }

  Widget UserCell(
      {required Null Function() groupTap,
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
                                  groupTap();
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
                // picture == ''
                //     ? CircleAvatar(
                //         radius: 100, child: SvgPicture.network(Helper.avatar))
                //     : CircleAvatar(
                //         radius: 100, backgroundImage: NetworkImage(picture)),
              )
            ],
          ),
        )
      ],
    );
  }
}
