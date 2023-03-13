import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/box/mindpost.dart';

// ignore: must_be_immutable
class GroupTimelineScreen extends StatefulWidget {
  Function onClick;
  GroupTimelineScreen({Key? key, required this.onClick})
      : con = PostController(),
        super(key: key);
  final PostController con;

  @override
  State createState() => GroupTimelineScreenState();
}

class GroupTimelineScreenState extends mvc.StateMVC<GroupTimelineScreen>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  late FocusNode searchFocusNode;
  bool showMenu = false;
  late AnimationController _drawerSlideController;
  var subUrl = '';
  double width = 0;
  double itemWidth = 0;
  List<Map> sampleData = [
    {'avatarImg': '', 'name': 'Adetola', 'icon': Icons.nature},
    {'avatarImg': '', 'name': 'Adetola', 'icon': Icons.nature},
    {'avatarImg': '', 'name': 'Adetola', 'icon': Icons.nature},
    {'avatarImg': '', 'name': 'Adetola', 'icon': Icons.nature},
    {'avatarImg': '', 'name': 'Adetola', 'icon': Icons.nature}
  ];
  get kprimaryColor => null;
  //
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as PostController;
  }

  late PostController con;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(right: 10, left: 10, top: 15),
      width: SizeConfig(context).screenWidth > SizeConfig.mediumScreenSize
          ? SizeConfig(context).screenWidth - SizeConfig.leftBarWidth
          : SizeConfig(context).screenWidth,
      child: SizeConfig(context).screenWidth < SizeConfig.mediumScreenSize
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              con.group['groupAdmin'][0]['userName'] ==
                      UserManager.userInfo['userName']
                  ? MindPost()
                  : Container(),
              Column(
                children: [
                  eventInfo(),
                  friendInvites(),
                ],
              )
            ])
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  con.group['groupAdmin'][0]['userName'] ==
                          UserManager.userInfo['userName']
                      ? MindPost()
                      : Container(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [eventInfo(), friendInvites()],
                    // children: [eventInfo()],
                  )
                ]),
    );
  }

  Widget eventInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            con.group['groupAbout'],
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
        ]),
        const Divider(
          thickness: 0.4,
          color: Colors.black,
        ),
        groupInfoCell(
            icon: Icon(
              con.group['groupPrivacy'] == 'public'
                  ? Icons.language
                  : con.group['groupPrivacy'] == 'security'
                      ? Icons.lock
                      : Icons.lock_open_rounded,
              color: Colors.grey,
            ),
            text: con.group['groupPrivacy'] == 'public'
                ? 'Public Group'
                : con.group['groupPrivacy'] == 'security'
                    ? 'Security Group'
                    : 'Closed Group'),
        groupInfoCell(
            icon: const Icon(
              Icons.groups,
              color: Colors.grey,
            ),
            text: '${con.group["groupJoined"].length} members'),
        groupInfoCell(
            icon: const Icon(
              Icons.tag,
              color: Colors.grey,
            ),
            text: 'N/A'),
        groupInfoCell(
            icon: const Icon(
              Icons.maps_ugc,
              color: Colors.grey,
            ),
            text: '${con.group["groupLocation"]}'),
      ],
    );
  }

  @override
  Widget groupInfoCell({icon, text}) {
    return Container(
      margin: const EdgeInsets.all(3),
      child: Row(children: [
        icon,
        const Padding(padding: EdgeInsets.only(left: 10)),
        Text(
          text,
          style: const TextStyle(fontSize: 13),
        )
      ]),
    );
  }

  @override
  Widget friendInvites() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Container(
          width: SizeConfig.rightPaneWidth,
          // color: Colors.white,
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.person_add_alt_sharp),
                  const Padding(padding: EdgeInsets.only(left: 3)),
                  const Text(
                    "Invite Friends",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const Flexible(fit: FlexFit.tight, child: SizedBox()),
                  Row(children: const [
                    Text(
                      'See All',
                      style: TextStyle(fontSize: 11),
                    ),
                  ])
                ],
              ),
              const Divider(
                height: 1,
                //thickness: 5,
                //indent: 20,
                //endIndent: 0,
                //color: Colors.black,
              ),
              AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  height: 260,
                  curve: Curves.fastOutSlowIn,
                  child: SizedBox(
                    //size: Size(100,100),
                    child: ListView.separated(
                      itemCount: sampleData.length,
                      itemBuilder: (context, index) => Material(
                          child: ListTile(
                              onTap: () {
                                print("tap!");
                              },
                              hoverColor:
                                  const Color.fromARGB(255, 243, 243, 243),
                              // tileColor: Colors.white,
                              enabled: true,
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  Helper.avatar,
                                ),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 80,
                                        child: Text(
                                          sampleData[index]['name'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11),
                                        ),
                                      ),
                                      Container(
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 33, 37, 41),
                                                  elevation: 3,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2.0)),
                                                  minimumSize:
                                                      const Size(65, 30),
                                                  maximumSize:
                                                      const Size(65, 30)),
                                              onPressed: () {
                                                () => {};
                                              },
                                              child: Row(
                                                children: const [
                                                  Icon(
                                                    Icons
                                                        .person_add_alt_rounded,
                                                    color: Colors.white,
                                                    size: 15.0,
                                                  ),
                                                  Text('Add',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ))),
                                    ],
                                  )
                                ],
                              ))),
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(
                        height: 1,
                        endIndent: 10,
                      ),
                    ),
                  ))
            ],
          )),
    );
  }
}
