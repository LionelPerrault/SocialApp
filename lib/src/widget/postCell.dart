import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/widget/likesCommentWidget.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

class PostCell extends StatefulWidget {
  PostCell({
    super.key,
    required this.postInfo,
    required this.routerChange,
  }) : con = PostController();
  var postInfo;
  Function routerChange;
  late PostController con;
  @override
  State createState() => PostCellState();
}

class PostCellState extends mvc.StateMVC<PostCell> {
  List<Map> privacyMenuItem = [
    {
      'icon': Icons.language,
      'label': 'Public',
    },
    {
      'icon': Icons.groups,
      'label': 'Friends',
    },
    {
      'icon': Icons.lock,
      'label': 'Only Me',
    },
  ];
  Map privacy = {};

  late PostController con;
  bool payLoading = false;
  bool loading = false;
  var postTime = '';
  String checkedOption = '';
  List<Map> upUserInfo = [];

  @override
  void initState() {
    print('widget.postInfo${widget.postInfo}');
    add(widget.con);
    con = controller as PostController;
    con.formatDate(widget.postInfo['time']).then((value) {
      postTime = value;
      setState(() {});
    });
    privacy = privacyMenuItem
        .where((element) => element['label'] == widget.postInfo['privacy'])
        .toList()[0];
    if (widget.postInfo['type'] == 'poll') {
      if (widget.postInfo['data']['optionUp'][UserManager.userInfo['uid']] !=
          null) {
        checkedOption =
            widget.postInfo['data']['optionUp'][UserManager.userInfo['uid']];
      }
      getUpUserInfo();
    }
    if (widget.postInfo['adminUid'] != UserManager.userInfo['uid'])
      privacyMenuItem = [];

    super.initState();
  }

  void checkOption(value) async {
    widget.postInfo['data']['optionUp'][UserManager.userInfo['uid']] = value;
    await Helper.postCollection
        .doc(widget.postInfo['id'])
        .update({'value': widget.postInfo['data']});
    checkedOption = value;
    setState(() {});
    getUpUserInfo();
  }

  getUpUserInfo() async {
    widget.postInfo['data']['optionUp'].forEach((key, value) async {
      var userInfo = await ProfileController().getUserInfo(key);
      upUserInfo.add({...userInfo!, 'value': value});
    });
    setState(() {});
  }

  upDatePostInfo(value) async {
    con.updatePostInfo(widget.postInfo['id'], value);
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.postInfo['type']) {
      case 'photo':
        return picturePostCell();
      case 'feeling':
        return feelingPostCell();
      case 'checkIn':
        return checkInPostCell();
      case 'poll':
        return pollPostCell();
      default:
        return const SizedBox();
    }
  }

  Widget picturePostCell() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 30, bottom: 30),
            width: 600,
            padding: const EdgeInsets.only(top: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          widget.postInfo['admin']['avatar'] != ''
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                  widget.postInfo['admin']['avatar'],
                                ))
                              : CircleAvatar(
                                  child: SvgPicture.network(Helper.avatar),
                                ),
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 10),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  '${widget.postInfo['admin']['firstName']} ${widget.postInfo['admin']['lastName']}',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  widget.routerChange({
                                                    'router':
                                                        RouteNames.profile,
                                                    'subRouter':
                                                        widget.postInfo['admin']
                                                            ['userName'],
                                                  });
                                                })
                                        ]),
                                  ),
                                  Container(
                                    width: SizeConfig(context).screenWidth < 600
                                        ? SizeConfig(context).screenWidth - 240
                                        : 350,
                                    child: Text(
                                      ' added ${widget.postInfo['data'].length == 1 ? 'a' : widget.postInfo['data'].length} photo${widget.postInfo['data'].length == 1 ? '' : 's'}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  // Container(
                                  //   padding: EdgeInsets.only(right: 9.0),
                                  //   child: CustomPopupMenu(
                                  //       menuBuilder: () => SubFunction(),
                                  //       pressType: PressType.singleClick,
                                  //       verticalMargin: -10,
                                  //       child:
                                  //           const Icon(Icons.arrow_drop_down)),
                                  // ),
                                ],
                              ),
                              const Padding(padding: EdgeInsets.only(top: 3)),
                              Row(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 10),
                                        children: <TextSpan>[
                                          TextSpan(
                                              // text: Helper.formatDate(
                                              //     widget.postInfo['time']),
                                              text: postTime,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  widget.routerChange({
                                                    'router': RouteNames.posts,
                                                    'subRouter':
                                                        widget.postInfo['id'],
                                                  });
                                                })
                                        ]),
                                  ),
                                  const Text(' - '),
                                  PopupMenuButton(
                                    onSelected: (value) {
                                      privacy = value;
                                      setState(() {});
                                      upDatePostInfo(
                                          {'privacy': value['label']});
                                    },
                                    child: Icon(
                                      privacy['icon'],
                                      size: 18,
                                    ),
                                    itemBuilder: (BuildContext bc) {
                                      return privacyMenuItem
                                          .map(
                                            (e) => PopupMenuItem(
                                              value: {
                                                'label': e['label'],
                                                'icon': e['icon'],
                                              },
                                              child: Row(
                                                children: [
                                                  const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 5.0)),
                                                  Icon(e['icon']),
                                                  const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 12.0)),
                                                  Text(
                                                    e['label'],
                                                    style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 90, 90, 90),
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 12),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                          .toList();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(top: 30)),
                      Row(
                        children: [
                          for (var item in widget.postInfo['data'])
                            Expanded(
                              child: Container(
                                height: 250,
                                child: Image.network(item['url'],
                                    fit: BoxFit.cover),
                              ),
                            )
                        ],
                      )
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 30)),
                LikesCommentScreen(productId: widget.postInfo['id'])
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget feelingPostCell() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 30, bottom: 30),
            width: 600,
            padding: const EdgeInsets.only(top: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          widget.postInfo['admin']['avatar'] != ''
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                  widget.postInfo['admin']['avatar'],
                                ))
                              : CircleAvatar(
                                  child: SvgPicture.network(Helper.avatar),
                                ),
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 10),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  '${widget.postInfo['admin']['firstName']} ${widget.postInfo['admin']['lastName']}',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  widget.routerChange({
                                                    'router':
                                                        RouteNames.profile,
                                                    'subRouter':
                                                        widget.postInfo['admin']
                                                            ['userName'],
                                                  });
                                                })
                                        ]),
                                  ),
                                  Container(
                                    width: SizeConfig(context).screenWidth < 600
                                        ? SizeConfig(context).screenWidth - 240
                                        : 350,
                                    child: Text(
                                      ' is ${widget.postInfo['data']['action']} ${widget.postInfo['data']['subAction']}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(padding: EdgeInsets.only(top: 3)),
                              Row(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 10),
                                        children: <TextSpan>[
                                          TextSpan(
                                              // text: Helper.formatDate(
                                              //     widget.postInfo['time']),
                                              text: postTime,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  widget.routerChange({
                                                    'router': RouteNames.posts,
                                                    'subRouter':
                                                        widget.postInfo['id'],
                                                  });
                                                })
                                        ]),
                                  ),
                                  const Text(' - '),
                                  PopupMenuButton(
                                    onSelected: (value) {
                                      privacy = value;
                                      setState(() {});
                                      upDatePostInfo(
                                          {'privacy': value['label']});
                                    },
                                    child: Icon(
                                      privacy['icon'],
                                      size: 18,
                                    ),
                                    itemBuilder: (BuildContext bc) {
                                      return privacyMenuItem
                                          .map(
                                            (e) => PopupMenuItem(
                                              value: {
                                                'label': e['label'],
                                                'icon': e['icon'],
                                              },
                                              child: Row(
                                                children: [
                                                  const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 5.0)),
                                                  Icon(e['icon']),
                                                  const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 12.0)),
                                                  Text(
                                                    e['label'],
                                                    style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 90, 90, 90),
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 12),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                          .toList();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                LikesCommentScreen(productId: widget.postInfo['id'])
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget checkInPostCell() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 30, bottom: 30),
            width: 600,
            padding: const EdgeInsets.only(top: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          widget.postInfo['admin']['avatar'] != ''
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                  widget.postInfo['admin']['avatar'],
                                ))
                              : CircleAvatar(
                                  child: SvgPicture.network(Helper.avatar),
                                ),
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 10),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  '${widget.postInfo['admin']['firstName']} ${widget.postInfo['admin']['lastName']}',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  widget.routerChange({
                                                    'router':
                                                        RouteNames.profile,
                                                    'subRouter':
                                                        widget.postInfo['admin']
                                                            ['userName'],
                                                  });
                                                })
                                        ]),
                                  ),
                                ],
                              ),
                              const Padding(padding: EdgeInsets.only(top: 3)),
                              Row(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 10),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: postTime,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  widget.routerChange({
                                                    'router': RouteNames.posts,
                                                    'subRouter':
                                                        widget.postInfo['id'],
                                                  });
                                                })
                                        ]),
                                  ),
                                  const Text(' - '),
                                  const Icon(
                                    Icons.location_on,
                                    size: 12,
                                  ),
                                  Text(
                                    widget.postInfo['data'],
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 10),
                                  ),
                                  const Text(' - '),
                                  PopupMenuButton(
                                    onSelected: (value) {
                                      privacy = value;
                                      setState(() {});
                                      upDatePostInfo(
                                          {'privacy': value['label']});
                                    },
                                    child: Icon(
                                      privacy['icon'],
                                      size: 18,
                                    ),
                                    itemBuilder: (BuildContext bc) {
                                      return privacyMenuItem
                                          .map(
                                            (e) => PopupMenuItem(
                                              value: {
                                                'label': e['label'],
                                                'icon': e['icon'],
                                              },
                                              child: Row(
                                                children: [
                                                  const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 5.0)),
                                                  Icon(e['icon']),
                                                  const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 12.0)),
                                                  Text(
                                                    e['label'],
                                                    style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 90, 90, 90),
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 12),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                          .toList();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                LikesCommentScreen(productId: widget.postInfo['id'])
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget pollPostCell() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 30, bottom: 30),
            width: 600,
            padding: const EdgeInsets.only(top: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          widget.postInfo['admin']['avatar'] != ''
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                  widget.postInfo['admin']['avatar'],
                                ))
                              : CircleAvatar(
                                  child: SvgPicture.network(Helper.avatar),
                                ),
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 10),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  '${widget.postInfo['admin']['firstName']} ${widget.postInfo['admin']['lastName']}',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  widget.routerChange({
                                                    'router':
                                                        RouteNames.profile,
                                                    'subRouter':
                                                        widget.postInfo['admin']
                                                            ['userName'],
                                                  });
                                                })
                                        ]),
                                  ),
                                  Container(
                                    width: SizeConfig(context).screenWidth < 600
                                        ? SizeConfig(context).screenWidth - 240
                                        : 350,
                                    child: const Text(
                                      ' added a poll',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  // Container(
                                  //   padding: EdgeInsets.only(right: 9.0),
                                  //   child: CustomPopupMenu(
                                  //       menuBuilder: () => SubFunction(),
                                  //       pressType: PressType.singleClick,
                                  //       verticalMargin: -10,
                                  //       child:
                                  //           const Icon(Icons.arrow_drop_down)),
                                  // ),
                                ],
                              ),
                              const Padding(padding: EdgeInsets.only(top: 3)),
                              Row(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 10),
                                        children: <TextSpan>[
                                          TextSpan(
                                              // text: Helper.formatDate(
                                              //     widget.postInfo['time']),
                                              text: postTime,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  widget.routerChange({
                                                    'router': RouteNames.posts,
                                                    'subRouter':
                                                        widget.postInfo['id'],
                                                  });
                                                })
                                        ]),
                                  ),
                                  const Text(' - '),
                                  PopupMenuButton(
                                    onSelected: (value) {
                                      privacy = value;
                                      setState(() {});
                                      upDatePostInfo(
                                          {'privacy': value['label']});
                                    },
                                    child: Icon(
                                      privacy['icon'],
                                      size: 18,
                                    ),
                                    itemBuilder: (BuildContext bc) {
                                      return privacyMenuItem
                                          .map(
                                            (e) => PopupMenuItem(
                                              value: {
                                                'label': e['label'],
                                                'icon': e['icon'],
                                              },
                                              child: Row(
                                                children: [
                                                  const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 5.0)),
                                                  Icon(e['icon']),
                                                  const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 12.0)),
                                                  Text(
                                                    e['label'],
                                                    style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 90, 90, 90),
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 12),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                          .toList();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      Text(
                        widget.postInfo['data']['question'],
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                        overflow: TextOverflow.clip,
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      for (var option in widget.postInfo['data']['option'])
                        optionWidget(option,
                            widget.postInfo['data']['optionUp'], upUserInfo)
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 30)),
                LikesCommentScreen(productId: widget.postInfo['id'])
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget optionWidget(label, upData, upUsers) {
    int upNum = 0;
    List<Map> eachUpUsers = [];
    upData.forEach((key, value) {
      if (value == label) {
        upNum++;
      }
    });
    eachUpUsers = upUsers.where((info) => info['value'] == label).toList();
    return Container(
      margin: const EdgeInsets.all(5),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                checkOption(label);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 235, 235, 235),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Row(
                  children: [
                    RoundCheckBox(
                      onTap: (selected) {
                        checkOption(label);
                      },
                      checkedWidget: const Icon(
                        Icons.mood,
                        color: Colors.white,
                        size: 24,
                      ),
                      uncheckedWidget: const Icon(
                        Icons.mood_bad,
                        size: 24,
                      ),
                      animationDuration: const Duration(
                        milliseconds: 300,
                      ),
                      isChecked: (checkedOption == label),
                      size: 30,
                    ),
                    const SizedBox(width: 015),
                    Text(
                      label,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17),
                    )
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Column(
                    children: const [
                      Text(
                        'People Who Voted For This Option',
                        style: TextStyle(fontSize: 17),
                      ),
                      Divider(thickness: 1, color: Colors.grey),
                    ],
                  ),
                  content: SingleChildScrollView(
                    child: Container(
                      height: eachUpUsers.isEmpty
                          ? 80
                          : eachUpUsers.length * 80 > 400
                              ? 400
                              : eachUpUsers.length * 80,
                      child: Column(
                        children: [
                          eachUpUsers.isEmpty
                              ? const Text('No people voted for this')
                              : const SizedBox(),
                          for (var user in eachUpUsers)
                            Container(
                              height: 80,
                              child: Row(
                                children: [
                                  user['avatar'] != ''
                                      ? CircleAvatar(
                                          backgroundImage: NetworkImage(
                                          widget.postInfo['admin']['avatar'],
                                        ))
                                      : CircleAvatar(
                                          child:
                                              SvgPicture.network(Helper.avatar),
                                        ),
                                  const SizedBox(width: 20),
                                  Text(
                                      '${user['firstName']} ${user['lastName']}')
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 10),
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 235, 235, 235),
                  borderRadius: BorderRadius.all(Radius.circular(23))),
              child: Text(
                upNum.toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
