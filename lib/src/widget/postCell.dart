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

class PostCell extends StatefulWidget {
  PostCell({
    super.key,
    required this.postInfo,
    required this.routerChange,
    this.isSharedContent = false,
  }) : con = PostController();
  var postInfo;
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
  Map privacy = {};

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
    con.formatDate(widget.postInfo['time']).then((value) {
      postTime = value;

      setState(() {});
    });
    headerCon.text = widget.postInfo['header'];
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
    if (widget.postInfo['adminUid'] != UserManager.userInfo['uid']) {
      privacyMenuItem = [];
      popupMenuItem = [
        {
          'icon': Icons.link,
          'label': 'Open post in new tab',
          'value': 'open',
        },
      ];
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
              yesFunc: () {
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
                      con.deletePost(con.posts[i]['id']);
                      con.deletePostFromTimeline(con.posts[i]['id']);
                    }
                  }
                }
                con.deletePost(widget.postInfo['id']);
                con.deletePostFromTimeline(widget.postInfo['id']);

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
        return feelingPostCell();
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
      case 'share':
        //  for (int i = 0; i < con.posts.length; i++) {
        //    if (con.posts[i]['id'] == widget.postInfo['data']) {
        print('widget.postinfo[value]');
        print(widget.postInfo['data']);
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
                                  RichText(
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
                                                  fontSize: 16),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  widget.routerChange({
                                                    'router':
                                                        RouteNames.profile,
                                                    'subRouter':
                                                        widget.postInfo[
                                                                'adminInfo']
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
                                  Visibility(
                                    visible: !widget.isSharedContent,
                                    child: Container(
                                      padding: EdgeInsets.only(right: 9.0),
                                      child: PopupMenuButton(
                                        onSelected: (value) {
                                          popUpFunction(value);
                                        },
                                        child: const Icon(
                                          Icons.arrow_drop_down,
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
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 30)),
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
                                  RichText(
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
                                                  fontSize: 16),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  widget.routerChange({
                                                    'router':
                                                        RouteNames.profile,
                                                    'subRouter':
                                                        widget.postInfo[
                                                                'adminInfo']
                                                            ['userName'],
                                                  });
                                                })
                                        ]),
                                  ),
                                  Visibility(
                                    visible: !widget.isSharedContent,
                                    child: Container(
                                      padding: EdgeInsets.only(right: 9.0),
                                      child: PopupMenuButton(
                                        onSelected: (value) {
                                          popUpFunction(value);
                                        },
                                        child: const Icon(
                                          Icons.arrow_drop_down,
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
                                  RichText(
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
                                                  fontSize: 16),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  widget.routerChange({
                                                    'router':
                                                        RouteNames.profile,
                                                    'subRouter':
                                                        widget.postInfo[
                                                                'adminInfo']
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
                                      ' shared ${widget.postInfo['data']['adminInfo']['firstName']} ${widget.postInfo['data']['adminInfo']['lastName']} \'s ${widget.postInfo['data']['type'] == 'photo' || widget.postInfo['data']['type'] == 'audio' || widget.postInfo['data']['type'] == 'poll' ? widget.postInfo['data']['type'] : 'Post'}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  Visibility(
                                    visible: !widget.isSharedContent,
                                    child: Container(
                                      padding: EdgeInsets.only(right: 9.0),
                                      child: PopupMenuButton(
                                        onSelected: (value) {
                                          popUpFunction(value);
                                        },
                                        child: const Icon(
                                          Icons.arrow_drop_down,
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
                                  RichText(
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
                                                  fontSize: 16),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  widget.routerChange({
                                                    'router':
                                                        RouteNames.profile,
                                                    'subRouter':
                                                        widget.postInfo[
                                                                'adminInfo']
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
                                      ' added an audio',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  Visibility(
                                    visible: !widget.isSharedContent,
                                    child: Container(
                                      padding: EdgeInsets.only(right: 9.0),
                                      child: PopupMenuButton(
                                        onSelected: (value) {
                                          popUpFunction(value);
                                        },
                                        child: const Icon(
                                          Icons.arrow_drop_down,
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
                            audioURL: widget.postInfo['data']),
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

  Widget feelingPostCell() {
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
                                  RichText(
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
                                                  fontSize: 16),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  widget.routerChange({
                                                    'router':
                                                        RouteNames.profile,
                                                    'subRouter':
                                                        widget.postInfo[
                                                                'adminInfo']
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
                                  Visibility(
                                    visible: !widget.isSharedContent,
                                    child: Container(
                                      padding: EdgeInsets.only(right: 9.0),
                                      child: PopupMenuButton(
                                        onSelected: (value) {
                                          popUpFunction(value);
                                        },
                                        child: const Icon(
                                          Icons.arrow_drop_down,
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

  Widget checkInPostCell() {
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
                                  RichText(
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
                                              fontSize: 16),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              widget.routerChange(
                                                {
                                                  'router': RouteNames.profile,
                                                  'subRouter': widget
                                                          .postInfo['adminInfo']
                                                      ['userName'],
                                                },
                                              );
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: !widget.isSharedContent,
                                    child: Container(
                                      padding: EdgeInsets.only(right: 9.0),
                                      child: PopupMenuButton(
                                        onSelected: (value) {
                                          popUpFunction(value);
                                        },
                                        child: const Icon(
                                          Icons.arrow_drop_down,
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

  Widget pollPostCell() {
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
                                  RichText(
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
                                                  fontSize: 16),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  widget.routerChange({
                                                    'router':
                                                        RouteNames.profile,
                                                    'subRouter':
                                                        widget.postInfo[
                                                                'adminInfo']
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
                                  Visibility(
                                    visible: !widget.isSharedContent,
                                    child: Container(
                                      padding: EdgeInsets.only(right: 9.0),
                                      child: PopupMenuButton(
                                        onSelected: (value) {
                                          popUpFunction(value);
                                        },
                                        child: const Icon(
                                          Icons.arrow_drop_down,
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
                                          widget.postInfo['adminInfo']
                                              ['avatar'],
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
