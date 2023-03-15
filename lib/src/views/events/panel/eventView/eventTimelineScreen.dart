import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/box/mindpost.dart';

import '../../../../widget/postCell.dart';

enum Direction {
  normal(1),
  reverse(-1);

  const Direction(this.value);

  final int value;
}

const int defaultSlide = 10;

enum PostType { timeline, profile, event, normal }

class EventTimelineScreen extends StatefulWidget {
  Function onClick;
  EventTimelineScreen(
      {Key? key, required this.onClick, required this.routerChange})
      : con = PostController(),
        super(key: key);
  final PostController con;
  Function routerChange;
  @override
  State createState() => EventTimelineScreenState();
}

class EventTimelineScreenState extends mvc.StateMVC<EventTimelineScreen>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
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
  bool loadingFlag = false;
  bool loadingFlagBottom = false;
  int newPostNum = 0;
  bool nextPostFlag = true;

  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as PostController;

    final Stream<QuerySnapshot> postStream =
        Helper.postCollection.orderBy('postTime').snapshots();
    loadingFlag = true;
    PostController().posts = [];
    con
        .getTimelinePost(defaultSlide, 1, PostType.event.index, con.viewEventId)
        .then((value) {
      // profilePosts = value;
      loadingFlag = false;
      if (con.postsEvent.length < 10) {
        nextPostFlag = false;
      }
      setState(() {});

      postStream.listen((event) {
        newPostNum = event.docs.where((post) {
          Map data = post.data() as Map;
          var eventId = "";
          if (data.containsKey("eventId")) eventId = data['eventId'];
          print("event id is ====$eventId");
          return (eventId == con.viewEventId) &&
              (Timestamp(post['postTime'].seconds, post['postTime'].nanoseconds)
                  .toDate()
                  .isAfter(con.latestTime));
        }).length;
        print("newPostNum of profile is $newPostNum");
        setState(() {});
      });
    });
  }

  Widget postColumn() {
    var inInterested =
        con.boolInterested(con.event, UserManager.userInfo['uid']);
    var inGoing = con.boolGoing(con.event, UserManager.userInfo['uid']);
    var inInvited = con.boolInvited(con.event, UserManager.userInfo['uid']);

    return Column(children: [
      inInterested ||
              inInvited ||
              inGoing ||
              UserManager.userInfo['uid'] == con.event['eventAdmin'][0]['uid']
          ? MindPost(showPrivacy: false)
          : Container(
              width:
                  SizeConfig(context).screenWidth > SizeConfig.smallScreenSize
                      ? 530
                      : 350,
              padding: const EdgeInsets.only(left: 30, right: 30)),
      const Padding(padding: EdgeInsets.only(top: 20)),
      newPostNum <= 0
          ? const SizedBox()
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(21.0)),
                minimumSize: const Size(240, 42),
                maximumSize: const Size(240, 42),
              ),
              onPressed: () async {
                setState(() {
                  loadingFlag = true;
                });
                await con.getTimelinePost(
                    newPostNum, -1, PostType.event.index, con.viewEventId);

                setState(() {
                  newPostNum = 0;
                  loadingFlag = false;
                });
              },
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.only(top: 11.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'View $newPostNum new Post${newPostNum == 1 ? '' : 's'}',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 90, 90, 90),
                            fontFamily: 'var(--body-font-family)',
                            fontWeight: FontWeight.w900,
                            fontSize: 15),
                      )
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(top: 8.0)),
                ],
              ),
            ),
      loadingFlag
          ? const SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                color: Colors.grey,
              ),
            )
          : const SizedBox(),
      con.postsEvent.isNotEmpty
          ? SizedBox(
              width: 600,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: con.postsEvent
                          .map<Widget>((product) => PostCell(
                                postInfo: product,
                                routerChange: widget.routerChange,
                              ))
                          .toList(),
                    ),
                  )
                ],
              ),
            )
          : const SizedBox(),
      loadingFlagBottom
          ? const SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                color: Colors.grey,
              ),
            )
          : const SizedBox(),
      loadingFlagBottom || loadingFlag || !nextPostFlag
          ? !nextPostFlag && !loadingFlag
              ? const Text("There is no more data to show")
              : const SizedBox()
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(21.0)),
                minimumSize: const Size(240, 42),
                maximumSize: const Size(240, 42),
              ),
              onPressed: () async {
                setState(() {
                  loadingFlagBottom = true;
                });
                var t = await con.getTimelinePost(
                    defaultSlide, 0, PostType.event.index, con.viewEventId);
                setState(() {
                  nextPostFlag = t;
                  loadingFlagBottom = false;
                });
              },
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.only(top: 11.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Load More...',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 90, 90, 90),
                            fontFamily: 'var(--body-font-family)',
                            fontWeight: FontWeight.w900,
                            fontSize: 15),
                      )
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(top: 8.0)),
                ],
              ),
            ),
    ]);
  }

  late PostController con;
  @override
  Widget build(BuildContext context) {
    print("event interested is ${con.event['eventInterested']}");
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(right: 10, left: 10, top: 15),
      child: SizeConfig(context).screenWidth < 800 + 250
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [postColumn(), eventInfo()])
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  postColumn(),
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
