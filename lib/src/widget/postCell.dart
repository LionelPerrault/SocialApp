import 'package:dotted_border/dotted_border.dart';
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
import 'package:shnatter/src/views/products/widget/productcell.dart';
import 'package:shnatter/src/widget/alertYesNoWidget.dart';
import 'package:shnatter/src/widget/audioPlayer.dart';
import 'package:shnatter/src/widget/likesCommentWidget.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import '../views/realEstate/widget/realEstateCell.dart';

class PostCell extends StatefulWidget {
  PostCell({
    super.key,
    required this.postInfo,
    required this.routerChange,
    this.isSharedContent = false,
  }) : con = PostController();
  Map postInfo;
  var sharedPost;
  bool isSharedContent = false;

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

  List<Map> popupMenuItem = [
    {
      'icon': Icons.edit,
      'label': 'Edit Post',
      'value': 'edit',
    },
    {
      'icon': Icons.delete,
      'label': 'Delete Post',
      'value': 'delete',
    },
    {
      'icon': Icons.remove_red_eye_sharp,
      'label': 'Hide from Timeline',
      'labelE': 'Allow on Timeline',
      'value': 'timeline',
    },
    {
      'icon': Icons.chat_bubble,
      'label': 'Turn off Commenting',
      'labelE': 'Turn on Commenting',
      'value': 'comment',
    },
    {
      'icon': Icons.link,
      'label': 'Open post in new tab',
      'value': 'open',
    },
  ];

  late PostController con;
  var postTime = '';
  String checkedOption = '';
  List<Map> upUserInfo = [];
  var headerCon = TextEditingController();
  bool editShow = false;
  String editHeader = '';
  bool loadingFlag = false;

  @override
  void initState() {
    add(widget.con);

    con = controller as PostController;
    //con.addNotifyCallBack(this);

    headerCon.text = widget.postInfo['header'] ?? '';

    if (widget.postInfo['type'] == 'poll') {
      if (widget.postInfo['data']['optionUp'][UserManager.userInfo['uid']] !=
          null) {
        checkedOption =
            widget.postInfo['data']['optionUp'][UserManager.userInfo['uid']];
      }
      getUpUserInfo();
    }

    super.initState();
  }

  void checkOption(value) async {
    widget.postInfo['data']['optionUp'][UserManager.userInfo['uid']] = value;

    await Helper.postCollection
        .doc(widget.postInfo['id'])
        .update({'value': widget.postInfo['data']});
    var allSnap = await Helper.postCollection
        .where('value.id', isEqualTo: widget.postInfo['id'])
        .get();

    var posts = allSnap.docs;

    for (int i = 0; i < posts.length; i++) {
      await Helper.postCollection
          .doc(posts[i].id)
          .update({'value': widget.postInfo});
    }

    checkedOption = value;
    setState(() {});
    getUpUserInfo();
  }

  getUpUserInfo() async {
    upUserInfo = [];

    for (var entry in widget.postInfo['data']['optionUp'].entries) {
      var userInfo = await ProfileController().getUserInfo(entry.key);
      upUserInfo.add({...userInfo!, 'value': entry.value});
    }

    setState(() {});
  }

  upDatePostInfo(value) async {
    con.updatePostInfo(widget.postInfo['id'], value);
  }

  deletePostInfo() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const SizedBox(),
        content: Stack(children: [
          AlertYesNoWidget(
              yesFunc: () async {
                setState(() {
                  loadingFlag = true;
                });

                for (int i = 0; i < con.posts.length; i++) {
                  if (con.posts[i]['type'] == 'share') {
                    print("con.posts[i]['data'][id]");

                    print(con.posts[i]['data']['id']);
                    print("widget.postInfo['id']");

                    print(widget.postInfo['id']);
                    if (con.posts[i]['data']['id'] == widget.postInfo['id']) {
                      await con.deletePost(con.posts[i]['id']);

                      con.deletePostFromTimeline(con.posts[i]);
                    }
                  }
                }
                await con.deletePost(widget.postInfo['id']);

                await con.deletePostFromTimeline(widget.postInfo);

                setState(() {
                  loadingFlag = false;
                });
                Navigator.of(context).pop(true);
              },
              noFunc: () {
                Navigator.of(context).pop(true);
              },
              header: 'Delete Post',
              text: 'Are you sure you want to delete this post?',
              progress: loadingFlag),
          loadingFlag
              ? Container(
                  width: 10,
                  height: 10,
                  child: const CircularProgressIndicator(
                    color: Colors.grey,
                  ),
                )
              : const SizedBox(
                  width: 0,
                  height: 0,
                )
        ]),
      ),
    );
  }

  hideFromTimeline() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const SizedBox(),
        content: AlertYesNoWidget(
            yesFunc: () async {
              upDatePostInfo({'timeline': !widget.postInfo['timeline']});
              widget.postInfo['timeline'] = !widget.postInfo['timeline'];
              setState(() {});
              Navigator.of(context).pop(true);
            },
            noFunc: () {
              Navigator.of(context).pop(true);
            },
            header: 'Hide from Timeline',
            text:
                'Are you sure you want to hide this post from your profile timeline? It may still appear in other places like newsfeed and search results',
            progress: false),
      ),
    );
  }

  popUpFunction(value) async {
    switch (value) {
      case 'edit':
        editShow = true;
        setState(() {});
        break;
      case 'delete':
        setState(() {});
        deletePostInfo();
        setState(() {});
        break;
      case 'timeline':
        hideFromTimeline();
        break;
      case 'comment':
        upDatePostInfo({'comment': !widget.postInfo['comment']});
        widget.postInfo['comment'] = !widget.postInfo['comment'];
        setState(() {});
        break;
      case 'open':
        widget.routerChange({
          'router': RouteNames.posts,
          'subRouter': widget.postInfo['id'],
        });
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.postInfo.containsKey('time')) {
      postTime = con.timeAgo(widget.postInfo['time']);
    } else {
      postTime = '';
    }

    if (!widget.isSharedContent) {
      if (widget.postInfo['adminUid'] != UserManager.userInfo['uid']) {
        //  privacyMenuItem = [];
        popupMenuItem = [
          {
            'icon': Icons.link,
            'label': 'Open post in new tab',
            'value': 'open',
          },
        ];
      } else {
        popupMenuItem = [
          {
            'icon': Icons.edit,
            'label': 'Edit Post',
            'value': 'edit',
          },
          {
            'icon': Icons.delete,
            'label': 'Delete Post',
            'value': 'delete',
          },
          {
            'icon': Icons.remove_red_eye_sharp,
            'label': 'Hide from Timeline',
            'labelE': 'Allow on Timeline',
            'value': 'timeline',
          },
          {
            'icon': Icons.chat_bubble,
            'label': 'Turn off Commenting',
            'labelE': 'Turn on Commenting',
            'value': 'comment',
          },
          {
            'icon': Icons.link,
            'label': 'Open post in new tab',
            'value': 'open',
          },
        ];
      }
    }

    return widget.postInfo['timeline'] == false
        ? DottedBorder(
            borderType: BorderType.RRect,
            radius: Radius.circular(20),
            dashPattern: [10, 10],
            color: Colors.grey,
            strokeWidth: 2,
            child: total(),
          )
        : total();
  }

  Widget total() {
    switch (widget.postInfo['type']) {
      case 'photo':
        return picturePostCell();
      case 'feeling':
        return picturePostCell();
      case 'checkIn':
        return checkInPostCell();
      case 'poll':
        return pollPostCell();
      case 'audio':
        return audioPostCell();
      case 'product':
        return ProductCell(
            data: widget.postInfo,
            isShared: widget.isSharedContent,
            routerChange: widget.routerChange);
      case 'realestate':
        return RealEstateCell(
            data: widget.postInfo,
            isShared: widget.isSharedContent,
            routerChange: widget.routerChange);
      case 'share':
        //  for (int i = 0; i < con.posts.length; i++) {
        //    if (con.posts[i]['id'] == widget.postInfo['data']) {

        widget.sharedPost = widget.postInfo['data'];
        //    }
        //  }
        return sharePostCell();
      case 'normal':
        return normalPostCell();
      default:
        return const SizedBox();
    }
  }

  Widget picturePostCell() {
    Map privacy = {};
    if (widget.postInfo.containsKey('privacy')) {
      privacy = privacyMenuItem
          .where((element) => element['label'] == widget.postInfo['privacy'])
          .toList()[0];
    } else if (widget.postInfo['data'].containsKey('privacy')) {
      privacy = privacyMenuItem
          .where((element) =>
              element['label'] == widget.postInfo['data']['privacy'])
          .toList()[0];
    } else {
      privacy = privacyMenuItem[0];
    }

    var verbSentence = '';

    if (widget.postInfo['data']?.containsKey('feeling')) {
      verbSentence =
          ' is ${widget.postInfo['data']['feeling']['action']} ${widget.postInfo['data']['feeling']['subAction']}';
    }

    if (widget.postInfo['data']?.containsKey('photo') &&
        widget.postInfo['data']['photo'].isNotEmpty) {
      if (verbSentence != '') {
        verbSentence = '$verbSentence & ';
      }
      verbSentence =
          '$verbSentence added ${widget.postInfo['data'].length == 1 ? 'a' : widget.postInfo['data']['photo'].length} photo${widget.postInfo['data']['photo'].length == 1 ? '' : 's'}';
    }

    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 30, bottom: 30),
            width: widget.isSharedContent ? 400 : 600,
            padding: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: widget.isSharedContent
                  ? Border.all(color: Colors.blueAccent)
                  : Border.all(color: Colors.white),
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Row(
                        children: [
                          widget.postInfo['adminInfo']['avatar'] != ''
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                  widget.postInfo['adminInfo']['avatar'],
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
                                  SizedBox(
                                      width: SizeConfig(context).screenWidth <
                                              600
                                          ? SizeConfig(context).screenWidth -
                                              150
                                          : 450, // 1st set height
                                      child: RichText(
                                          text: TextSpan(
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10),
                                              children: <TextSpan>[
                                            TextSpan(
                                                text:
                                                    '${widget.postInfo['adminInfo']['firstName']} ${widget.postInfo['adminInfo']['lastName']}',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        ProfileController()
                                                            .updateProfile(widget
                                                                        .postInfo[
                                                                    'adminInfo']
                                                                ['userName']);
                                                        widget.routerChange({
                                                          'router': RouteNames
                                                              .profile,
                                                          'subRouter': widget
                                                                      .postInfo[
                                                                  'adminInfo']
                                                              ['userName'],
                                                        });
                                                      }),
                                            TextSpan(
                                                text: verbSentence,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    overflow:
                                                        TextOverflow.ellipsis))
                                          ]))),
                                  Visibility(
                                    visible: !widget.isSharedContent,
                                    child: Container(
                                      child: PopupMenuButton(
                                        onSelected: (value) {
                                          popUpFunction(value);
                                        },
                                        child: const Icon(
                                          Icons.expand_more,
                                          size: 18,
                                        ),
                                        itemBuilder: (BuildContext bc) {
                                          return popupMenuItem
                                              .map(
                                                (e) => PopupMenuItem(
                                                  value: e['value'],
                                                  child: Row(
                                                    children: [
                                                      const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5.0)),
                                                      Icon(e['icon']),
                                                      const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 12.0)),
                                                      Text(
                                                        e['value'] == 'timeline'
                                                            ? widget.postInfo[
                                                                    'timeline']
                                                                ? e['label']
                                                                : e['labelE']
                                                            : e['value'] ==
                                                                    'comment'
                                                                ? widget.postInfo[
                                                                        'comment']
                                                                    ? e['label']
                                                                    : e['labelE']
                                                                : e['label'],
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    90,
                                                                    90,
                                                                    90),
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
                                                  color: Colors.grey,
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
                                  IgnorePointer(
                                      ignoring: (widget.postInfo['adminUid'] !=
                                          UserManager.userInfo['uid']),
                                      child: PopupMenuButton(
                                        onSelected: (value) {
                                          upDatePostInfo(
                                              {'privacy': value['label']});

                                          if (widget.postInfo
                                              .containsKey('privacy')) {
                                            widget.postInfo['privacy'] =
                                                value['label'];
                                          } else if (widget.postInfo['data']
                                              .containsKey('privacy')) {
                                            widget.postInfo['data']['privacy'] =
                                                value['label'];
                                          }
                                          setState(() {
                                            privacy = value;
                                          });
                                        },
                                        child: Icon(
                                          privacy['icon'],
                                          color: Colors.grey,
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
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5.0)),
                                                      Icon(e['icon']),
                                                      const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 12.0)),
                                                      Text(
                                                        e['label'],
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    90,
                                                                    90,
                                                                    90),
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
                                      )),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: editShow
                          ? editPost()
                          : widget.postInfo['header'].isNotEmpty
                              ? Text(
                                  widget.postInfo['header'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                  overflow: TextOverflow.clip,
                                )
                              : const SizedBox(),
                    ),
                    widget.postInfo['data'].containsKey('photo')
                        ? Row(
                            children: [
                              for (var item in widget.postInfo['data']['photo'])
                                Expanded(
                                  child: Container(
                                    height: 350,
                                    color: const Color(0xfff5f5f5),
                                    child: Image.network(item['url'],
                                        fit: BoxFit.fitHeight),
                                  ),
                                )
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
                Visibility(
                  visible: !widget.isSharedContent,
                  child: LikesCommentScreen(
                    postInfo: widget.postInfo,
                    commentFlag: widget.postInfo['comment'],
                    routerChange: widget.routerChange,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget normalPostCell() {
    Map privacy = {};
    if (widget.postInfo.containsKey('privacy')) {
      privacy = privacyMenuItem
          .where((element) => element['label'] == widget.postInfo['privacy'])
          .toList()[0];
    } else if (widget.postInfo['data'].containsKey('privacy')) {
      privacy = privacyMenuItem
          .where((element) =>
              element['label'] == widget.postInfo['data']['privacy'])
          .toList()[0];
    } else {
      privacy = privacyMenuItem[0];
    }
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 30, bottom: 30),
            width: 600,
            padding: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: widget.isSharedContent
                  ? Border.all(color: Colors.blueAccent)
                  : Border.all(color: Colors.white),
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
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
                          widget.postInfo['adminInfo']['avatar'] != ''
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                  widget.postInfo['adminInfo']['avatar'],
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
                                  SizedBox(
                                    width: SizeConfig(context).screenWidth < 600
                                        ? SizeConfig(context).screenWidth - 150
                                        : 450,
                                    child: RichText(
                                      text: TextSpan(
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 10),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text:
                                                    '${widget.postInfo['adminInfo']['firstName']} ${widget.postInfo['adminInfo']['lastName']}',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        widget.routerChange({
                                                          'router': RouteNames
                                                              .profile,
                                                          'subRouter': widget
                                                                      .postInfo[
                                                                  'adminInfo']
                                                              ['userName'],
                                                        });
                                                      })
                                          ]),
                                    ),
                                  ),
                                  Visibility(
                                    visible: !widget.isSharedContent,
                                    child: Container(
                                      child: PopupMenuButton(
                                        onSelected: (value) {
                                          popUpFunction(value);
                                        },
                                        child: const Icon(
                                          Icons.expand_more,
                                          size: 18,
                                        ),
                                        itemBuilder: (BuildContext bc) {
                                          return popupMenuItem
                                              .map(
                                                (e) => PopupMenuItem(
                                                  value: e['value'],
                                                  child: Row(
                                                    children: [
                                                      const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5.0)),
                                                      Icon(e['icon']),
                                                      const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 12.0)),
                                                      Text(
                                                        e['value'] == 'timeline'
                                                            ? widget.postInfo[
                                                                    'timeline']
                                                                ? e['label']
                                                                : e['labelE']
                                                            : e['value'] ==
                                                                    'comment'
                                                                ? widget.postInfo[
                                                                        'comment']
                                                                    ? e['label']
                                                                    : e['labelE']
                                                                : e['label'],
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    90,
                                                                    90,
                                                                    90),
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
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(padding: EdgeInsets.only(top: 3)),
                              Row(
                                children: [
                                  RichText(
                                    text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                          // text: Helper.formatDate(
                                          //     widget.postInfo['time']),
                                          text: postTime,
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 10),
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
                                  IgnorePointer(
                                    ignoring: (widget.postInfo['adminUid'] !=
                                        UserManager.userInfo['uid']),
                                    child: PopupMenuButton(
                                      onSelected: (value) {
                                        upDatePostInfo(
                                            {'privacy': value['label']});
                                        if (widget.postInfo
                                            .containsKey('privacy')) {
                                          widget.postInfo['privacy'] =
                                              value['label'];
                                        } else if (widget.postInfo['data']
                                            .containsKey('privacy')) {
                                          widget.postInfo['data']['privacy'] =
                                              value['label'];
                                        }
                                        setState(() {
                                          privacy = value;
                                        });
                                      },
                                      child: Icon(
                                        privacy['icon'],
                                        color: Colors.grey,
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
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5.0)),
                                                    Icon(e['icon']),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.only(
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
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      editShow
                          ? editPost()
                          : Text(
                              widget.postInfo['header'],
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              overflow: TextOverflow.clip,
                            ),
                    ],
                  ),
                ),
                Visibility(
                  visible: !widget.isSharedContent,
                  child: LikesCommentScreen(
                    postInfo: widget.postInfo,
                    commentFlag: widget.postInfo['comment'],
                    routerChange: widget.routerChange,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget sharePostCell() {
    print("share =============${widget.sharedPost}");
    print("pstInfo =============${widget.postInfo}");
    Map privacy = {};
    if (widget.postInfo.containsKey('privacy')) {
      privacy = privacyMenuItem
          .where((element) => element['label'] == widget.postInfo['privacy'])
          .toList()[0];
    } else if (widget.postInfo['data'].containsKey('privacy')) {
      privacy = privacyMenuItem
          .where((element) =>
              element['label'] == widget.postInfo['data']['privacy'])
          .toList()[0];
    } else {
      privacy = privacyMenuItem[0];
    }
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 30, bottom: 30),
            width: 600,
            padding: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: widget.isSharedContent
                  ? Border.all(color: Colors.blueAccent)
                  : Border.all(color: Colors.white),
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
                          widget.postInfo['adminInfo']!['avatar'] != ''
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                  widget.postInfo['adminInfo']['avatar'],
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
                                  SizedBox(
                                      width: SizeConfig(context).screenWidth <
                                              600
                                          ? SizeConfig(context).screenWidth -
                                              150
                                          : 450, // 1st set height
                                      child: RichText(
                                          text: TextSpan(
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10),
                                              children: <TextSpan>[
                                            TextSpan(
                                                text:
                                                    '${widget.postInfo['adminInfo']!['firstName']!} ${widget.postInfo['adminInfo']!['lastName']!} ',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        ProfileController()
                                                            .updateProfile(widget
                                                                        .postInfo[
                                                                    'adminInfo']![
                                                                'userName']!);
                                                        widget.routerChange({
                                                          'router': RouteNames
                                                              .profile,
                                                          'subRouter': widget
                                                                      .postInfo[
                                                                  'adminInfo']![
                                                              'userName']!,
                                                        });
                                                      }),
                                            TextSpan(
                                                text:
                                                    'shared ${widget.sharedPost!['adminInfo']!['firstName']} ${widget.sharedPost!['adminInfo']!['lastName']} \'s ${widget.sharedPost['type'] == 'photo' || widget.sharedPost['type'] == 'audio' || widget.sharedPost['type'] == 'poll' || widget.sharedPost['type'] == 'product' || widget.sharedPost['type'] == 'realestate' ? widget.sharedPost['type'] : 'Post'}',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    overflow:
                                                        TextOverflow.ellipsis))
                                          ]))),
                                  Visibility(
                                    visible: !widget.isSharedContent,
                                    child: Container(
                                      child: PopupMenuButton(
                                        onSelected: (value) {
                                          popUpFunction(value);
                                        },
                                        child: const Icon(
                                          Icons.expand_more,
                                          size: 18,
                                        ),
                                        itemBuilder: (BuildContext bc) {
                                          return popupMenuItem
                                              .map(
                                                (e) => PopupMenuItem(
                                                  value: e['value'],
                                                  child: Row(
                                                    children: [
                                                      const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5.0)),
                                                      Icon(e['icon']),
                                                      const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 12.0)),
                                                      Text(
                                                        e['value'] == 'timeline'
                                                            ? widget.postInfo[
                                                                    'timeline']
                                                                ? e['label']
                                                                : e['labelE']
                                                            : e['value'] ==
                                                                    'comment'
                                                                ? widget.postInfo[
                                                                        'comment']
                                                                    ? e['label']
                                                                    : e['labelE']
                                                                : e['label'],
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    90,
                                                                    90,
                                                                    90),
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
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(padding: EdgeInsets.only(top: 3)),
                              Row(
                                children: [
                                  RichText(
                                    text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                          // text: Helper.formatDate(
                                          //     widget.postInfo['time']),
                                          text: postTime,
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 10),
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
                                  IgnorePointer(
                                    ignoring: (widget.postInfo['adminUid'] !=
                                        UserManager.userInfo['uid']),
                                    child: PopupMenuButton(
                                      onSelected: (value) {
                                        upDatePostInfo(
                                            {'privacy': value['label']});
                                        if (widget.postInfo
                                            .containsKey('privacy')) {
                                          widget.postInfo['privacy'] =
                                              value['label'];
                                        } else if (widget.postInfo['data']
                                            .containsKey('privacy')) {
                                          widget.postInfo['data']['privacy'] =
                                              value['label'];
                                        }
                                        setState(() {
                                          privacy = value;
                                        });
                                      },
                                      child: Icon(
                                        privacy['icon'],
                                        color: Colors.grey,
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
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5.0)),
                                                    Icon(e['icon']),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.only(
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
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      editShow
                          ? editPost()
                          : Text(
                              widget.postInfo['header'],
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              overflow: TextOverflow.clip,
                            ),
                      PostCell(
                        postInfo: widget.sharedPost,
                        routerChange: widget.routerChange,
                        isSharedContent: true,
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: !widget.isSharedContent,
                  child: LikesCommentScreen(
                    postInfo: widget.postInfo,
                    commentFlag: widget.postInfo['comment'],
                    shareFlag: false,
                    routerChange: widget.routerChange,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget audioPostCell() {
    Map privacy = {};
    if (widget.postInfo.containsKey('privacy')) {
      privacy = privacyMenuItem
          .where((element) => element['label'] == widget.postInfo['privacy'])
          .toList()[0];
    } else if (widget.postInfo['data'].containsKey('privacy')) {
      privacy = privacyMenuItem
          .where((element) =>
              element['label'] == widget.postInfo['data']['privacy'])
          .toList()[0];
    } else {
      privacy = privacyMenuItem[0];
    }
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 30, bottom: 30),
            width: widget.isSharedContent ? 400 : 600,
            padding: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: widget.isSharedContent
                  ? Border.all(color: Colors.blueAccent)
                  : Border.all(color: Colors.white),
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
                          widget.postInfo['adminInfo']['avatar'] != ''
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                  widget.postInfo['adminInfo']['avatar'],
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
                                  SizedBox(
                                      width: SizeConfig(context).screenWidth <
                                              600
                                          ? SizeConfig(context).screenWidth -
                                              150
                                          : 450, // 1st set height
                                      child: RichText(
                                          text: TextSpan(
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10),
                                              children: <TextSpan>[
                                            TextSpan(
                                                text:
                                                    '${widget.postInfo['adminInfo']['firstName']} ${widget.postInfo['adminInfo']['lastName']}',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        ProfileController()
                                                            .updateProfile(widget
                                                                        .postInfo[
                                                                    'adminInfo']
                                                                ['userName']);
                                                        widget.routerChange({
                                                          'router': RouteNames
                                                              .profile,
                                                          'subRouter': widget
                                                                      .postInfo[
                                                                  'adminInfo']
                                                              ['userName'],
                                                        });
                                                      }),
                                            const TextSpan(
                                                text: ' added an audio',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    overflow:
                                                        TextOverflow.ellipsis))
                                          ]))),
                                  Visibility(
                                    visible: !widget.isSharedContent,
                                    child: Container(
                                      child: PopupMenuButton(
                                        onSelected: (value) {
                                          popUpFunction(value);
                                        },
                                        child: const Icon(
                                          Icons.expand_more,
                                          size: 18,
                                        ),
                                        itemBuilder: (BuildContext bc) {
                                          return popupMenuItem
                                              .map(
                                                (e) => PopupMenuItem(
                                                  value: e['value'],
                                                  child: Row(
                                                    children: [
                                                      const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5.0)),
                                                      Icon(e['icon']),
                                                      const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 12.0)),
                                                      Text(
                                                        e['value'] == 'timeline'
                                                            ? widget.postInfo[
                                                                    'timeline']
                                                                ? e['label']
                                                                : e['labelE']
                                                            : e['value'] ==
                                                                    'comment'
                                                                ? widget.postInfo[
                                                                        'comment']
                                                                    ? e['label']
                                                                    : e['labelE']
                                                                : e['label'],
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    90,
                                                                    90,
                                                                    90),
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
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(padding: EdgeInsets.only(top: 3)),
                              Row(
                                children: [
                                  RichText(
                                    text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                          // text: Helper.formatDate(
                                          //     widget.postInfo['time']),
                                          text: postTime,
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 10),
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
                                  IgnorePointer(
                                    ignoring: (widget.postInfo['adminUid'] !=
                                        UserManager.userInfo['uid']),
                                    child: PopupMenuButton(
                                      onSelected: (value) {
                                        upDatePostInfo(
                                            {'privacy': value['label']});
                                        if (widget.postInfo
                                            .containsKey('privacy')) {
                                          widget.postInfo['privacy'] =
                                              value['label'];
                                        } else if (widget.postInfo['data']
                                            .containsKey('privacy')) {
                                          widget.postInfo['data']['privacy'] =
                                              value['label'];
                                        }
                                        setState(() {
                                          privacy = value;
                                        });
                                      },
                                      child: Icon(
                                        privacy['icon'],
                                        color: Colors.grey,
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
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5.0)),
                                                    Icon(e['icon']),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.only(
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
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      editShow
                          ? editPost()
                          : Text(
                              widget.postInfo['header'],
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              overflow: TextOverflow.clip,
                            ),
                      const Padding(padding: EdgeInsets.only(top: 30)),
                      Container(
                        child: AudioPlayerWidget(
                            audioURL: widget.postInfo['data']['audio']),
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: !widget.isSharedContent,
                  child: LikesCommentScreen(
                    postInfo: widget.postInfo,
                    commentFlag: widget.postInfo['comment'],
                    routerChange: widget.routerChange,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
              ],
            ),
          ),
        )
      ],
    );
  }

  // Widget feelingPostCell() {
  //   Map privacy = {};
  //   if (widget.postInfo.containsKey('privacy')) {
  //     privacy = privacyMenuItem
  //         .where((element) => element['label'] == widget.postInfo['privacy'])
  //         .toList()[0];
  //   } else if (widget.postInfo['data'].containsKey('privacy')) {
  //     privacy = privacyMenuItem
  //         .where((element) =>
  //             element['label'] == widget.postInfo['data']['privacy'])
  //         .toList()[0];
  //   } else {s
  //     privacy = privacyMenuItem[0];
  //   }
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: Container(
  //           margin: const EdgeInsets.only(top: 30, bottom: 30),
  //           width: widget.isSharedContent ? 400 : 600,
  //           padding: const EdgeInsets.only(top: 20),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             border: widget.isSharedContent
  //                 ? Border.all(color: Colors.blueAccent)
  //                 : Border.all(color: Colors.white),
  //             borderRadius: BorderRadius.all(Radius.circular(5.0)),
  //           ),
  //           child: Column(
  //             children: [
  //               Container(
  //                 padding: EdgeInsets.only(left: 20, right: 20),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Row(
  //                       children: [
  //                         widget.postInfo['adminInfo']['avatar'] != ''
  //                             ? CircleAvatar(
  //                                 backgroundImage: NetworkImage(
  //                                 widget.postInfo['adminInfo']['avatar'],
  //                               ))
  //                             : CircleAvatar(
  //                                 child: SvgPicture.network(Helper.avatar),
  //                               ),
  //                         const Padding(padding: EdgeInsets.only(left: 10)),
  //                         Column(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Row(
  //                               children: [
  //                                 SizedBox(
  //                                     width: SizeConfig(context).screenWidth <
  //                                             600
  //                                         ? SizeConfig(context).screenWidth -
  //                                             150
  //                                         : 450, // 1st set height
  //                                     child: RichText(
  //                                         text: TextSpan(
  //                                             style: const TextStyle(
  //                                                 color: Colors.grey,
  //                                                 fontSize: 10),
  //                                             children: <TextSpan>[
  //                                           TextSpan(
  //                                               text:
  //                                                   '${widget.postInfo['adminInfo']['firstName']} ${widget.postInfo['adminInfo']['lastName']}',
  //                                               style: const TextStyle(
  //                                                   color: Colors.black,
  //                                                   fontWeight: FontWeight.bold,
  //                                                   fontSize: 15),
  //                                               recognizer:
  //                                                   TapGestureRecognizer()
  //                                                     ..onTap = () {
  //                                                       ProfileController()
  //                                                           .updateProfile(widget
  //                                                                       .postInfo[
  //                                                                   'adminInfo']
  //                                                               ['userName']);
  //                                                       widget.routerChange({
  //                                                         'router': RouteNames
  //                                                             .profile,
  //                                                         'subRouter': widget
  //                                                                     .postInfo[
  //                                                                 'adminInfo']
  //                                                             ['userName'],
  //                                                       });
  //                                                     }),
  //                                           TextSpan(
  //                                               text: widget.postInfo['data']!
  //                                                       .hasContainKey(
  //                                                           'feeling')
  //                                                   ? ' is ${widget.postInfo['data']['feeling']['action']} ${widget.postInfo['data']['feeling']['subAction']}'
  //                                                   : '',
  //                                               style: const TextStyle(
  //                                                   color: Colors.black,
  //                                                   fontSize: 14,
  //                                                   overflow:
  //                                                       TextOverflow.ellipsis))
  //                                         ]))),
  //                                 Visibility(
  //                                   visible: !widget.isSharedContent,
  //                                   child: Container(
  //                                     child: PopupMenuButton(
  //                                       onSelected: (value) {
  //                                         popUpFunction(value);
  //                                       },
  //                                       child: const Icon(
  //                                         Icons.expand_more,
  //                                         size: 18,
  //                                       ),
  //                                       itemBuilder: (BuildContext bc) {
  //                                         return popupMenuItem
  //                                             .map(
  //                                               (e) => PopupMenuItem(
  //                                                 value: e['value'],
  //                                                 child: Row(
  //                                                   children: [
  //                                                     const Padding(
  //                                                         padding:
  //                                                             EdgeInsets.only(
  //                                                                 left: 5.0)),
  //                                                     Icon(e['icon']),
  //                                                     const Padding(
  //                                                         padding:
  //                                                             EdgeInsets.only(
  //                                                                 left: 12.0)),
  //                                                     Text(
  //                                                       e['value'] == 'timeline'
  //                                                           ? widget.postInfo[
  //                                                                   'timeline']
  //                                                               ? e['label']
  //                                                               : e['labelE']
  //                                                           : e['value'] ==
  //                                                                   'comment'
  //                                                               ? widget.postInfo[
  //                                                                       'comment']
  //                                                                   ? e['label']
  //                                                                   : e['labelE']
  //                                                               : e['label'],
  //                                                       style: const TextStyle(
  //                                                           color:
  //                                                               Color.fromARGB(
  //                                                                   255,
  //                                                                   90,
  //                                                                   90,
  //                                                                   90),
  //                                                           fontWeight:
  //                                                               FontWeight.w900,
  //                                                           fontSize: 12),
  //                                                     )
  //                                                   ],
  //                                                 ),
  //                                               ),
  //                                             )
  //                                             .toList();
  //                                       },
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                             const Padding(padding: EdgeInsets.only(top: 3)),
  //                             Row(
  //                               children: [
  //                                 RichText(
  //                                   text: TextSpan(
  //                                       style: const TextStyle(
  //                                           color: Colors.grey, fontSize: 10),
  //                                       children: <TextSpan>[
  //                                         TextSpan(
  //                                             // text: Helper.formatDate(
  //                                             //     widget.postInfo['time']),
  //                                             text: postTime,
  //                                             style: const TextStyle(
  //                                                 color: Colors.grey,
  //                                                 fontSize: 10),
  //                                             recognizer: TapGestureRecognizer()
  //                                               ..onTap = () {
  //                                                 widget.routerChange({
  //                                                   'router': RouteNames.posts,
  //                                                   'subRouter':
  //                                                       widget.postInfo['id'],
  //                                                 });
  //                                               })
  //                                       ]),
  //                                 ),
  //                                 const Text(' - '),
  //                                 IgnorePointer(
  //                                   ignoring: (widget.postInfo['adminUid'] !=
  //                                       UserManager.userInfo['uid']),
  //                                   child: PopupMenuButton(
  //                                     onSelected: (value) {
  //                                       upDatePostInfo(
  //                                           {'privacy': value['label']});
  //                                       if (widget.postInfo
  //                                           .containsKey('privacy')) {
  //                                         widget.postInfo['privacy'] =
  //                                             value['label'];
  //                                       } else if (widget.postInfo['data']
  //                                           .containsKey('privacy')) {
  //                                         widget.postInfo['data']['privacy'] =
  //                                             value['label'];
  //                                       }
  //                                       setState(() {
  //                                         privacy = value;
  //                                       });
  //                                     },
  //                                     child: Icon(
  //                                       privacy['icon'],
  //                                       color: Colors.grey,
  //                                       size: 18,
  //                                     ),
  //                                     itemBuilder: (BuildContext bc) {
  //                                       return privacyMenuItem
  //                                           .map(
  //                                             (e) => PopupMenuItem(
  //                                               value: {
  //                                                 'label': e['label'],
  //                                                 'icon': e['icon'],
  //                                               },
  //                                               child: Row(
  //                                                 children: [
  //                                                   const Padding(
  //                                                       padding:
  //                                                           EdgeInsets.only(
  //                                                               left: 5.0)),
  //                                                   Icon(e['icon']),
  //                                                   const Padding(
  //                                                       padding:
  //                                                           EdgeInsets.only(
  //                                                               left: 12.0)),
  //                                                   Text(
  //                                                     e['label'],
  //                                                     style: const TextStyle(
  //                                                         color: Color.fromARGB(
  //                                                             255, 90, 90, 90),
  //                                                         fontWeight:
  //                                                             FontWeight.w900,
  //                                                         fontSize: 12),
  //                                                   )
  //                                                 ],
  //                                               ),
  //                                             ),
  //                                           )
  //                                           .toList();
  //                                     },
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ],
  //                         )
  //                       ],
  //                     ),
  //                     const Padding(padding: EdgeInsets.only(top: 20)),
  //                     editShow
  //                         ? editPost()
  //                         : Text(
  //                             widget.postInfo['header'],
  //                             style: const TextStyle(
  //                               fontSize: 20,
  //                             ),
  //                             overflow: TextOverflow.clip,
  //                           ),
  //                   ],
  //                 ),
  //               ),
  //               Visibility(
  //                 visible: !widget.isSharedContent,
  //                 child: LikesCommentScreen(
  //                   postInfo: widget.postInfo,
  //                   commentFlag: widget.postInfo['comment'],
  //                   routerChange: widget.routerChange,
  //                 ),
  //               ),
  //               const Padding(padding: EdgeInsets.only(top: 10)),
  //             ],
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }

  Widget checkInPostCell() {
    Map privacy = {};
    if (widget.postInfo.containsKey('privacy')) {
      privacy = privacyMenuItem
          .where((element) => element['label'] == widget.postInfo['privacy'])
          .toList()[0];
    } else if (widget.postInfo['data'].containsKey('privacy')) {
      privacy = privacyMenuItem
          .where((element) =>
              element['label'] == widget.postInfo['data']['privacy'])
          .toList()[0];
    } else {
      privacy = privacyMenuItem[0];
    }
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 30, bottom: 30),
            width: widget.isSharedContent ? 400 : 600,
            padding: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: widget.isSharedContent
                  ? Border.all(color: Colors.blueAccent)
                  : Border.all(color: Colors.white),
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
                          widget.postInfo['adminInfo']['avatar'] != ''
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                  widget.postInfo['adminInfo']['avatar'],
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
                                  SizedBox(
                                    width: SizeConfig(context).screenWidth < 600
                                        ? SizeConfig(context).screenWidth - 150
                                        : 450, // 1st set height
                                    child: RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 10),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                                '${widget.postInfo['adminInfo']['firstName']} ${widget.postInfo['adminInfo']['lastName']}',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                ProfileController()
                                                    .updateProfile(
                                                        widget.postInfo[
                                                                'adminInfo']
                                                            ['userName']);
                                                widget.routerChange(
                                                  {
                                                    'router':
                                                        RouteNames.profile,
                                                    'subRouter':
                                                        widget.postInfo[
                                                                'adminInfo']
                                                            ['userName'],
                                                  },
                                                );
                                              },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: !widget.isSharedContent,
                                    child: Container(
                                      child: PopupMenuButton(
                                        onSelected: (value) {
                                          popUpFunction(value);
                                        },
                                        child: const Icon(
                                          Icons.expand_more,
                                          size: 18,
                                        ),
                                        itemBuilder: (BuildContext bc) {
                                          return popupMenuItem
                                              .map(
                                                (e) => PopupMenuItem(
                                                  value: e['value'],
                                                  child: Row(
                                                    children: [
                                                      const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5.0)),
                                                      Icon(e['icon']),
                                                      const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 12.0)),
                                                      Text(
                                                        e['value'] == 'timeline'
                                                            ? widget.postInfo[
                                                                    'timeline']
                                                                ? e['label']
                                                                : e['labelE']
                                                            : e['value'] ==
                                                                    'comment'
                                                                ? widget.postInfo[
                                                                        'comment']
                                                                    ? e['label']
                                                                    : e['labelE']
                                                                : e['label'],
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    90,
                                                                    90,
                                                                    90),
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
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(padding: EdgeInsets.only(top: 3)),
                              Row(
                                children: [
                                  RichText(
                                    text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                          text: postTime,
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 10),
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
                                    color: Colors.grey,
                                    size: 12,
                                  ),
                                  Text(
                                    widget.postInfo['data']['checkIn'],
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 10),
                                  ),
                                  const Text(' - '),
                                  IgnorePointer(
                                    ignoring: (widget.postInfo['adminUid'] !=
                                        UserManager.userInfo['uid']),
                                    child: PopupMenuButton(
                                      onSelected: (value) {
                                        upDatePostInfo(
                                            {'privacy': value['label']});
                                        if (widget.postInfo
                                            .containsKey('privacy')) {
                                          widget.postInfo['privacy'] =
                                              value['label'];
                                        } else if (widget.postInfo['data']
                                            .containsKey('privacy')) {
                                          widget.postInfo['data']['privacy'] =
                                              value['label'];
                                        }
                                        setState(() {
                                          privacy = value;
                                        });
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
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5.0)),
                                                    Icon(e['icon']),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.only(
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
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      editShow
                          ? editPost()
                          : Text(
                              widget.postInfo['header'],
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              overflow: TextOverflow.clip,
                            ),
                    ],
                  ),
                ),
                Visibility(
                  visible: !widget.isSharedContent,
                  child: LikesCommentScreen(
                    postInfo: {...widget.postInfo},
                    commentFlag: widget.postInfo['comment'],
                    routerChange: widget.routerChange,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget pollPostCell() {
    Map privacy = {};
    if (widget.postInfo.containsKey('privacy')) {
      privacy = privacyMenuItem
          .where((element) => element['label'] == widget.postInfo['privacy'])
          .toList()[0];
    } else if (widget.postInfo['data'].containsKey('privacy')) {
      privacy = privacyMenuItem
          .where((element) =>
              element['label'] == widget.postInfo['data']['privacy'])
          .toList()[0];
    } else {
      privacy = privacyMenuItem[0];
    }
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 30, bottom: 30),
            width: widget.isSharedContent ? 400 : 600,
            padding: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: widget.isSharedContent
                  ? Border.all(color: Colors.blueAccent)
                  : Border.all(color: Colors.white),
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
                          widget.postInfo['adminInfo']['avatar'] != ''
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                  widget.postInfo['adminInfo']['avatar'],
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
                                  SizedBox(
                                      width: SizeConfig(context).screenWidth <
                                              600
                                          ? SizeConfig(context).screenWidth -
                                              150
                                          : 450, // 1st set height
                                      child: RichText(
                                          text: TextSpan(
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10),
                                              children: <TextSpan>[
                                            TextSpan(
                                                text:
                                                    '${widget.postInfo['adminInfo']['firstName']} ${widget.postInfo['adminInfo']['lastName']}',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        ProfileController()
                                                            .updateProfile(widget
                                                                        .postInfo[
                                                                    'adminInfo']
                                                                ['userName']);
                                                        widget.routerChange({
                                                          'router': RouteNames
                                                              .profile,
                                                          'subRouter': widget
                                                                      .postInfo[
                                                                  'adminInfo']
                                                              ['userName'],
                                                        });
                                                      }),
                                            const TextSpan(
                                                text: ' added a poll',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    overflow:
                                                        TextOverflow.ellipsis))
                                          ]))),
                                  Visibility(
                                    visible: !widget.isSharedContent,
                                    child: Container(
                                      child: PopupMenuButton(
                                        onSelected: (value) {
                                          popUpFunction(value);
                                        },
                                        child: const Icon(
                                          Icons.expand_more,
                                          size: 18,
                                        ),
                                        itemBuilder: (BuildContext bc) {
                                          return popupMenuItem
                                              .map(
                                                (e) => PopupMenuItem(
                                                  value: e['value'],
                                                  child: Row(
                                                    children: [
                                                      const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5.0)),
                                                      Icon(e['icon']),
                                                      const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 12.0)),
                                                      Text(
                                                        e['value'] == 'timeline'
                                                            ? widget.postInfo[
                                                                    'timeline']
                                                                ? e['label']
                                                                : e['labelE']
                                                            : e['value'] ==
                                                                    'comment'
                                                                ? widget.postInfo[
                                                                        'comment']
                                                                    ? e['label']
                                                                    : e['labelE']
                                                                : e['label'],
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    90,
                                                                    90,
                                                                    90),
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
                                                  color: Colors.grey,
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
                                  IgnorePointer(
                                    ignoring: (widget.postInfo['adminUid'] !=
                                        UserManager.userInfo['uid']),
                                    child: PopupMenuButton(
                                      onSelected: (value) {
                                        upDatePostInfo(
                                            {'privacy': value['label']});
                                        if (widget.postInfo
                                            .containsKey('privacy')) {
                                          widget.postInfo['privacy'] =
                                              value['label'];
                                        } else if (widget.postInfo['data']
                                            .containsKey('privacy')) {
                                          widget.postInfo['data']['privacy'] =
                                              value['label'];
                                        }
                                        setState(() {
                                          privacy = value;
                                        });
                                      },
                                      child: Icon(
                                        privacy['icon'],
                                        color: Colors.grey,
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
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5.0)),
                                                    Icon(e['icon']),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.only(
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
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      editShow
                          ? editPost()
                          : Text(
                              widget.postInfo['header'],
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
                Visibility(
                  visible: !widget.isSharedContent,
                  child: LikesCommentScreen(
                    postInfo: widget.postInfo,
                    commentFlag: widget.postInfo['comment'],
                    routerChange: widget.routerChange,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
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
                print("checked1");
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
                        print("checked");
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
                                          user['avatar'],
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

  Widget editPost() {
    return Container(
      child: Column(
        children: [
          Container(
            height: 40,
            child: TextField(
              onChanged: (value) {
                editHeader = value;
                setState(() {});
              },
              controller: headerCon,
              decoration: const InputDecoration(
                hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                contentPadding: EdgeInsets.only(top: 10, left: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.5)),
                  minimumSize: const Size(85, 45),
                  maximumSize: const Size(85, 45),
                ),
                onPressed: () {
                  editShow = false;
                  setState(() {});
                },
                child: const Text('Cancel',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w900)),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.5)),
                  minimumSize: const Size(75, 45),
                  maximumSize: const Size(75, 45),
                ),
                onPressed: () {
                  editShow = false;
                  widget.postInfo['header'] = editHeader;
                  setState(() {});
                  upDatePostInfo({'header': widget.postInfo['header']});
                },
                child: const Text('Post',
                    style: TextStyle(
                        color: Color.fromARGB(255, 94, 114, 228),
                        fontSize: 13,
                        fontWeight: FontWeight.w900)),
              ),
              const SizedBox(width: 20)
            ],
          )
        ],
      ),
    );
  }
}
