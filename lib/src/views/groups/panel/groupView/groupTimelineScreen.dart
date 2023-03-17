import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/box/mindpost.dart';

import '../../../../widget/postCell.dart';
import '../../../profile/model/friends.dart';

// ignore: must_be_immutable
class GroupTimelineScreen extends StatefulWidget {
  Function onClick;
  GroupTimelineScreen(
      {Key? key, required this.onClick, required this.routerChange})
      : con = PostController(),
        super(key: key);
  final PostController con;
  Function routerChange;
  @override
  State createState() => GroupTimelineScreenState();
}

const int defaultSlide = 10;

class GroupTimelineScreenState extends mvc.StateMVC<GroupTimelineScreen>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  late FocusNode searchFocusNode;
  bool showMenu = false;
  late AnimationController _drawerSlideController;
  var subUrl = '';
  Friends friendModel = Friends();
  double width = 0;
  bool loadingFlag = false;
  bool loadingFlagBottom = false;
  int newPostNum = 0;
  bool nextPostFlag = true;
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
    final Stream<QuerySnapshot> postStream =
        Helper.postCollection.orderBy('postTime').snapshots();
    friendModel.getFriends(UserManager.userInfo['userName']).then((value) {
      setState(() {});
    });
    loadingFlag = true;
    PostController().posts = [];
    con
        .getTimelinePost(defaultSlide, 1, PostType.group.index, con.viewGroupId)
        .then((value) {
      // profilePosts = value;
      loadingFlag = false;
      if (con.postsGroup.length < 10) {
        nextPostFlag = false;
      }
      setState(() {});

      postStream.listen((group) {
        newPostNum = group.docs.where((post) {
          Map data = post.data() as Map;
          var groupId = "";
          if (data.containsKey("groupId")) groupId = data['groupId'];
          print("groupId is ====$groupId");
          return (groupId == con.viewGroupId) &&
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
    var inJoined = con.boolJoined(con.group, UserManager.userInfo['uid']);

    return Column(children: [
      (con.group['groupCanPub'] && inJoined) ||
              UserManager.userInfo['uid'] == con.group['groupAdmin'][0]['uid']
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
                    newPostNum, -1, PostType.group.index, con.viewGroupId);

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
      con.postsGroup.isNotEmpty
          ? SizedBox(
              width: 600,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: con.postsGroup
                          .map<Widget>((post) => PostCell(
                                postInfo: post,
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
                    defaultSlide, 0, PostType.group.index, con.viewGroupId);
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
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(right: 10, left: 10, top: 15),
      width: SizeConfig(context).screenWidth > SizeConfig.mediumScreenSize
          ? SizeConfig(context).screenWidth - SizeConfig.leftBarWidth
          : SizeConfig(context).screenWidth,
      child: SizeConfig(context).screenWidth < SizeConfig.mediumScreenSize
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              postColumn(),
              Column(
                children: [
                  eventInfo(),
                  UserManager.userInfo['uid'] ==
                          con.event['eventAdmin'][0]['uid']
                      ? friendInvites()
                      : const SizedBox(),
                ],
              )
            ])
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  postColumn(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      eventInfo(),
                      UserManager.userInfo['uid'] ==
                              con.group['groupAdmin'][0]['uid']
                          ? friendInvites()
                          : const SizedBox(),
                    ],
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
                      itemCount: friendModel.friends.length,
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
                                          friendModel.friends[index]
                                                      ['requester'] ==
                                                  UserManager
                                                      .userInfo['userName']
                                              ? friendModel.friends[index]
                                                  ['receiver']
                                              : friendModel.friends[index]
                                                  ['requester'],
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
