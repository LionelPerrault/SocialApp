import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/box/mindpost.dart';

class EventTimelineScreen extends StatefulWidget {
  Function onClick;
  EventTimelineScreen({Key? key, required this.onClick})
      : con = PostController(),
        super(key: key);
  final PostController con;

  @override
  State createState() => EventTimelineScreenState();
}

class EventTimelineScreenState extends mvc.StateMVC<EventTimelineScreen>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  bool showSearch = false;
  late FocusNode searchFocusNode;
  bool showMenu = false;
  late AnimationController _drawerSlideController;
  double width = 0;
  double itemWidth = 0;
  List<Map> sampleData = [
    {'avatarImg': '', 'name': 'Adetola', 'icon': Icons.nature},
    {'avatarImg': '', 'name': 'Adetola', 'icon': Icons.nature},
    {'avatarImg': '', 'name': 'Adetola', 'icon': Icons.nature},
    {'avatarImg': '', 'name': 'Adetola', 'icon': Icons.nature},
    {'avatarImg': '', 'name': 'Adetola', 'icon': Icons.nature}
  ];
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
      child: SizeConfig(context).screenWidth < 800 + 250
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [MindPost(), eventInfo()])
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  MindPost(),
                  const Flexible(fit: FlexFit.tight, child: SizedBox()),
                  eventInfo(),
                  const Padding(padding: EdgeInsets.only(left: 40))
                ]),
    );
  }

  @override
  Widget eventInfo() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            con.event['eventAbout'],
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
          const Divider(
            thickness: 0.4,
            color: Colors.black,
          ),
          eventInfoCell(
              icon: Icon(
                con.event['eventPrivacy'] == 'public'
                    ? Icons.language
                    : con.event['eventPrivacy'] == 'security'
                        ? Icons.lock
                        : Icons.lock_open_rounded,
                color: Colors.black,
              ),
              text: con.event['eventPrivacy'] == 'public'
                  ? 'Public Event'
                  : con.event['eventPrivacy'] == 'security'
                      ? 'Security Event'
                      : 'Closed Event'),
          eventInfoCell(
              icon: Icon(Icons.punch_clock),
              text:
                  '${con.event["eventStartDate"]} to ${con.event["eventEndDate"]}'),
          eventInfoCell(
              icon: Icon(Icons.person),
              text: 'Hosted by ${con.event["eventAdmin"][0]["fullName"]}'),
          eventInfoCell(icon: Icon(Icons.sell), text: 'B/N'),
          eventInfoCell(
              icon: Icon(Icons.maps_ugc),
              text: '${con.event["eventLocation"]}'),
          const Divider(
            thickness: 0.1,
            color: Colors.black,
          ),
          eventInfoCell(
              icon: Icon(Icons.event),
              text: '${con.event["eventGoing"].length} Going'),
          eventInfoCell(
              icon: Icon(Icons.event),
              text: '${con.event["eventInterested"].length} Interested'),
          eventInfoCell(
              icon: Icon(Icons.event),
              text: '${con.event["eventInvited"].length} Invited'),
          const Padding(padding: EdgeInsets.only(top: 30)),
          friendInvites(),
        ],
      ),
    );
  }

  @override
  Widget eventInfoCell({icon, text}) {
    return Container(
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
                  Row(children: [
                    const Text(
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
