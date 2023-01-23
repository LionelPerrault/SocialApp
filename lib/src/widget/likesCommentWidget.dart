import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/widget/startedInput.dart';
import 'dart:io' show File;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as PPath;

class LikesCommentScreen extends StatefulWidget {
  late PostController Postcon;
  String productId;
  LikesCommentScreen({Key? key, required this.productId})
      : Postcon = PostController(),
        super(key: key);
  @override
  State createState() => LikesCommentScreenState();
}

class LikesCommentScreenState extends mvc.StateMVC<LikesCommentScreen> {
  bool isSound = false;
  late PostController con;
  Map<String, dynamic> productInfo = {
    'productStatus': 'New',
    'productOffer': 'Sell'
  };
  var category = 'Choose Category';
  TextEditingController commentController = TextEditingController();
  double uploadPhotoProgress = 0;
  List<dynamic> productPhoto = [];
  List<dynamic> productFile = [];
  String comment = '';
  var userInfo = UserManager.userInfo;
  double uploadFileProgress = 0;
  var photoLength;
  var fileLength;
  var commentHeight = 0.0;
  bool offer1 = true;
  bool offer2 = false;
  var whoComment = '';
  bool isComment = false;
  var whatImage = '';
  var whoHover = '';
  var whatReply = [];
  var reply = {};
  var likesColor = {
    'Like': Colors.blue,
    'Love': const Color.fromRGBO(242, 82, 104, 1),
    'Haha': const Color.fromRGBO(243, 183, 21, 1),
    'Yay': const Color.fromRGBO(243, 183, 21, 1),
    'Wow': const Color.fromRGBO(243, 183, 21, 1),
    'Sad': const Color.fromRGBO(243, 183, 21, 1),
    'Angry': const Color.fromRGBO(247, 128, 108, 1),
  };
  var emoticon = {
    'Like':
        'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2F970279.png?alt=media&token=7775f9c5-bfde-4bf1-a1a2-a9a3a1336c2c',
    'Love':
        'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2F2043845.png?alt=media&token=de00e47a-2467-4d36-92d1-d0318098cf6c',
    'Haha':
        'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fhaha.png?alt=media&token=22f42035-d150-45da-b16a-12bab942e3f9',
    'Yay':
        'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fyay.png?alt=media&token=675a7f1f-a2b0-4321-bc5b-bce582c8afb5',
    'Wow':
        'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fwow.png?alt=media&token=73b978ca-11bc-4d9d-8dda-79f776df6dbb',
    'Sad':
        'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsad.png?alt=media&token=b3b9ee61-23df-498c-943e-fbca291e5e8b',
    'Angry':
        'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fangry.png?alt=media&token=3b77d906-3d7d-4876-9d9f-15c1f7ff1b18',
  };
  late List likesImage = [
    {"image": emoticon['Like'], "value": "Like"},
    {"image": emoticon['Love'], "value": "Love"},
    {'image': emoticon['Haha'], 'value': 'Haha'},
    {'image': emoticon['Yay'], 'value': 'Yay'},
    {'image': emoticon['Wow'], 'value': 'Wow'},
    {'image': emoticon['Sad'], 'value': 'Sad'},
    {'image': emoticon['Angry'], 'value': 'Angry'}
  ];
  @override
  void initState() {
    add(widget.Postcon);
    con = controller as PostController;
    con.getComment(widget.productId);
    print(widget.productId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List list = con.productsComments[widget.productId] ?? [];
    List productLikesCount = con.productLikesCount[widget.productId] ?? [];
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Stack(
              children: [
                Container(
                    height: 50,
                    color: Colors.white,
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(padding: EdgeInsets.only(left: 15)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: productLikesCount
                              .map((val) => Container(
                                  padding: EdgeInsets.only(left: 3),
                                  child: Row(
                                    children: [
                                      Image.network(
                                        emoticon[val['likes']].toString(),
                                        width: 20,
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(left: 3)),
                                      Text(val['count'].toString())
                                    ],
                                  )))
                              .toList(),
                        ),
                        const Flexible(fit: FlexFit.tight, child: SizedBox()),
                        const Icon(
                          FontAwesomeIcons.comment,
                          size: 15,
                        ),
                        const Padding(padding: EdgeInsets.only(left: 5)),
                        Text('${list.length} comments')
                      ],
                    )),
                Container(
                  margin: const EdgeInsets.only(top: 50),
                  height: 45,
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  child: Row(children: [
                    MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (value) {
                          whoHover = 'like';
                          setState(() {});
                        },
                        onExit: (event) {
                          whoHover = '';
                          setState(() {});
                        },
                        child: AnimatedContainer(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: whoHover == 'like'
                                  ? const Color.fromRGBO(240, 240, 245, 1)
                                  : Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(3))),
                          duration: const Duration(milliseconds: 300),
                          width: SizeConfig(context).screenWidth > 600
                              ? (600 - 60) / 3
                              : (SizeConfig(context).screenWidth - 60) / 3,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                con.productLikes[widget.productId] == null
                                    ? const Icon(
                                        FontAwesomeIcons.thumbsUp,
                                        size: 15,
                                      )
                                    : Image.network(
                                        emoticon[con
                                                .productLikes[widget.productId]]
                                            .toString(),
                                        width: 20,
                                      ),
                                const Padding(
                                    padding: EdgeInsets.only(left: 5)),
                                Text(
                                  con.productLikes[widget.productId] ?? 'Like',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color:
                                          con.productLikes[widget.productId] ==
                                                  null
                                              ? Colors.black
                                              : likesColor[con.productLikes[
                                                  widget.productId]]),
                                )
                              ]),
                        )),
                    MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (value) {
                          whoHover = 'comment';
                          setState(() {});
                        },
                        onExit: (event) {
                          whoHover = '';
                          setState(() {});
                        },
                        child: InkWell(
                            onTap: () async {
                              isComment = true;
                              await con.getReply(widget.productId);
                              setState(() {});
                            },
                            child: AnimatedContainer(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: whoHover == 'comment'
                                      ? const Color.fromRGBO(240, 240, 245, 1)
                                      : Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3))),
                              duration: const Duration(milliseconds: 300),
                              width: SizeConfig(context).screenWidth > 600
                                  ? (600 - 60) / 3
                                  : (SizeConfig(context).screenWidth - 60) / 3,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      FontAwesomeIcons.message,
                                      size: 15,
                                    ),
                                    Padding(padding: EdgeInsets.only(left: 5)),
                                    Text(
                                      'Comment',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    )
                                  ]),
                            ))),
                    MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (value) {
                          whoHover = 'share';
                          setState(() {});
                        },
                        onExit: (event) {
                          whoHover = '';
                          setState(() {});
                        },
                        child: AnimatedContainer(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: whoHover == 'share'
                                  ? const Color.fromRGBO(240, 240, 245, 1)
                                  : Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3))),
                          duration: const Duration(milliseconds: 300),
                          width: SizeConfig(context).screenWidth > 600
                              ? (600 - 60) / 3
                              : (SizeConfig(context).screenWidth - 60) / 3,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Icon(
                                  FontAwesomeIcons.share,
                                  size: 15,
                                ),
                                Padding(padding: EdgeInsets.only(left: 5)),
                                Text(
                                  'Share',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                )
                              ]),
                        ))
                  ]),
                ),
                whoHover == 'like'
                    ? Container(
                        margin: const EdgeInsets.only(top: 6),
                        child: likesWidget('product', () async {
                          con.productLikes[widget.productId] = whatImage;
                          con.productLikes[widget.productId] = whatImage;
                          con.saveProductLikes(widget.productId, whatImage);
                          whoHover = '';
                          setState(() {});
                        }),
                      )
                    : Container()
              ],
            )),
        !isComment
            ? Container()
            : Container(
                color: const Color.fromRGBO(245, 245, 245, 1),
                padding: const EdgeInsets.only(left: 20, right: 20),
                width: SizeConfig(context).screenWidth > 600
                    ? 600
                    : SizeConfig(context).screenWidth,
                height: 50,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      userInfo['avatar'] == ''
                          ? CircleAvatar(
                              radius: 18,
                              child: SvgPicture.network(
                                Helper.avatar,
                              ))
                          : CircleAvatar(
                              radius: 18,
                              backgroundImage: NetworkImage(
                                userInfo['avatar'],
                              )),
                      const Padding(padding: EdgeInsets.only(left: 10)),
                      input((value) {
                        comment = value;
                      }, () async {
                        if (comment != '') {
                          await con.saveComment(
                              widget.productId, comment, 'text');
                          setState(() {});
                        }
                      })
                    ])),
        !isComment
            ? Container()
            : Container(
                width: SizeConfig(context).screenWidth > 600
                    ? 600
                    : SizeConfig(context).screenWidth,
                padding: const EdgeInsets.only(left: 20, right: 15, bottom: 10),
                color: const Color.fromRGBO(245, 245, 245, 1),
                child: Column(
                    children: list.isNotEmpty
                        ? list.map((e) => eachComment(e)).toList()
                        : []),
              )
      ],
    ));
  }

  Widget input(onChange, onClick) {
    return Container(
        height: 30,
        width: SizeConfig(context).screenWidth > 600
            ? 500
            : SizeConfig(context).screenWidth - 88,
        decoration: BoxDecoration(
            border:
                Border.all(color: Color.fromRGBO(220, 220, 220, 1), width: 1),
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: Row(
          children: [
            Container(
              height: 30,
              width: SizeConfig(context).screenWidth > 600
                  ? 350
                  : SizeConfig(context).screenWidth - 205,
              child: TextField(
                // controller: commentController,
                cursorWidth: 1,
                onChanged: (value) {
                  onChange(value);
                },
                style: const TextStyle(fontSize: 12),
                decoration: const InputDecoration(
                    hintText: 'Write a comment',
                    hintStyle: TextStyle(fontSize: 12),
                    contentPadding:
                        EdgeInsets.only(top: 0, left: 10, bottom: 22),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none),
              ),
            ),
            const Flexible(fit: FlexFit.tight, child: SizedBox()),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: InkWell(
                onTap: () async {
                  onClick();
                },
                child: const Icon(
                  Icons.send,
                  size: 20,
                  color: Colors.grey,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(right: 5)),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: InkWell(
                onTap: () {},
                child: const Icon(
                  Icons.photo,
                  size: 20,
                  color: Colors.grey,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(right: 5)),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: InkWell(
                onTap: () {},
                child: const Icon(
                  Icons.mic,
                  size: 20,
                  color: Colors.grey,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(right: 5)),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: InkWell(
                onTap: () {},
                child: const Icon(
                  Icons.emoji_emotions,
                  color: Colors.grey,
                  size: 20,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(right: 20))
          ],
        ));
  }

  Widget likesWidget(what, onClick) {
    return MouseRegion(
        onEnter: (event) {
          if (what == 'product') {
            whoHover = 'like';
          } else {
            whoComment = what;
          }
          setState(() {});
        },
        onExit: (event) {
          whoHover = '';
          whoComment = '';
          setState(() {});
        },
        child: Container(
          padding: const EdgeInsets.only(left: 5, right: 5),
          width: SizeConfig(context).screenWidth > 600
              ? 370
              : SizeConfig(context).screenWidth * 3.7 / 6,
          height: 50,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(240, 240, 240, 1),
                blurRadius: 2,
                spreadRadius: 1,
                offset: Offset(
                  1,
                  1,
                ),
              )
            ],
          ),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: likesImage
                  .map((e) => Container(
                        width: SizeConfig(context).screenWidth > 600
                            ? (370 - 10) / 7
                            : (SizeConfig(context).screenWidth * 3.7 / 6 - 10) /
                                7,
                        // padding: const EdgeInsets.only(right: 10),
                        child: MouseRegion(
                          onEnter: (event) {
                            whatImage = e['value'];
                            setState(() {});
                          },
                          onExit: (event) {
                            whatImage = '';
                            setState(() {});
                          },
                          child: InkWell(
                              onTap: () {
                                onClick();
                              },
                              child: AnimatedContainer(
                                height: whatImage == e['value'] ? 50 : 40,
                                duration: const Duration(milliseconds: 200),
                                child: Image.network(
                                  e['image'],
                                ),
                              )),
                        ),
                      ))
                  .toList()),
        ));
  }

  Widget eachComment(e) {
    List replies = con.commentReply[e['id']] ?? [];
    List commentLikesCount = con.commentLikesCount[e['id']] ?? [];
    var key = GlobalKey();
    double width = SizeConfig(context).screenWidth > 600
        ? 500
        : SizeConfig(context).screenWidth - 81;
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            e['avatar'] == ''
                ? CircleAvatar(
                    radius: 18,
                    child: SvgPicture.network(Helper.avatar),
                  )
                : CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(e['avatar']),
                  ),
            const Padding(padding: EdgeInsets.only(left: 10)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Container(
                            key: key,
                            constraints:
                                BoxConstraints(minWidth: 50, maxWidth: width),
                            padding: EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(e['data']['userName']),
                                const Padding(
                                    padding: EdgeInsets.only(top: 10)),
                                Text(e['data']['content']),
                              ],
                            ))),
                    whoComment == e['id']
                        ? Container(
                            margin: EdgeInsets.only(top: commentHeight - 40),
                            child: likesWidget(e['id'], () {
                              whoComment = '';
                              con.commentLikes[e['id']] = whatImage;
                              con.saveLikesComment(
                                  widget.productId, e['id'], whatImage);
                              setState(() {});
                            }),
                          )
                        : Container()
                  ],
                ),
                const Padding(padding: EdgeInsets.only(left: 7)),
                Container(
                    padding: const EdgeInsets.only(left: 7),
                    child: Row(
                      children: [
                        MouseRegion(
                            cursor: SystemMouseCursors.click,
                            onEnter: (event) {
                              whoComment = e['id'];
                              commentHeight = key.currentContext!.size!.height;
                              setState(() {});
                            },
                            onExit: (event) {
                              whoComment = '';
                              setState(() {});
                            },
                            child: Text(
                              con.commentLikes[e['id']] ?? 'Like',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: con.commentLikes[e['id']] == null
                                      ? Colors.black
                                      : likesColor[con.commentLikes[e['id']]]),
                            )),
                        const Padding(padding: EdgeInsets.only(left: 6)),
                        MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: InkWell(
                                onTap: () {
                                  if (!whatReply.contains(e['id'])) {
                                    whatReply.add(e['id']);
                                  }
                                  setState(() {});
                                },
                                child: const Text(
                                  'Reply',
                                  style: TextStyle(fontSize: 13),
                                ))),
                        const Padding(padding: EdgeInsets.only(left: 10)),
                        Row(
                          children: commentLikesCount
                              .map((value) => Container(
                                  padding: const EdgeInsets.only(left: 3),
                                  child: Row(
                                    children: [
                                      Image.network(
                                        emoticon[value['likes']].toString(),
                                        width: 20,
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(left: 3)),
                                      Text(value['count'].toString())
                                    ],
                                  )))
                              .toList(),
                        )
                      ],
                    )),
                whatReply.contains(e['id'])
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            replies.map((val) => replyWidget(val, e)).toList())
                    : Container(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 30, left: 10),
                        child: Row(children: [
                          const Icon(
                            FontAwesomeIcons.comment,
                            size: 12,
                          ),
                          const Padding(padding: EdgeInsets.only(left: 5)),
                          InkWell(
                            onTap: () {
                              if (!whatReply.contains(e['id'])) {
                                whatReply.add(e['id']);
                              }
                              setState(() {});
                            },
                            child: Text(
                              '${replies.length} Replies',
                              style: TextStyle(fontSize: 12),
                            ),
                          )
                        ]),
                      ),
                whatReply.contains(e['id'])
                    ? Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: input((value) {
                          reply[e['id']] = value;
                        }, () async {
                          if (reply[e['id']] != '') {
                            await con.saveReply(widget.productId, e['id'],
                                reply[e['id']], 'text');
                            setState(() {});
                          }
                        }),
                      )
                    : Container()
              ],
            )
          ]),
    );
  }

  Widget replyWidget(val, e) {
    double width = SizeConfig(context).screenWidth > 600
        ? 500
        : SizeConfig(context).screenWidth - 87;
    var key1 = GlobalKey();
    List replyLikesCount = con.replyLikesCount[val['id']] ?? [];
    return Container(
        padding: const EdgeInsets.only(top: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            val['avatar'] == ''
                ? CircleAvatar(
                    radius: 18,
                    child: SvgPicture.network(Helper.avatar),
                  )
                : CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(val['avatar']),
                  ),
            const Padding(padding: EdgeInsets.only(left: 10)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                            key: key1,
                            constraints: BoxConstraints(
                                minWidth: 50, maxWidth: width - 40),
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(val['data']['userName']),
                                const Padding(
                                    padding: EdgeInsets.only(top: 10)),
                                Text(val['data']['content']),
                              ],
                            ))),
                    whoComment == val['id']
                        ? Container(
                            margin: EdgeInsets.only(top: commentHeight - 40),
                            child: likesWidget(val['id'], () {
                              whoComment = '';
                              con.replyLikes[val['id']] = whatImage;
                              con.saveLikesReply(widget.productId, e['id'],
                                  val['id'], whatImage);
                              setState(() {});
                            }),
                          )
                        : Container()
                  ],
                ),
                const Padding(padding: EdgeInsets.only(left: 7)),
                Container(
                    padding: const EdgeInsets.only(left: 7),
                    child: Row(
                      children: [
                        MouseRegion(
                            cursor: SystemMouseCursors.click,
                            onEnter: (event) {
                              whoComment = val['id'];
                              commentHeight = key1.currentContext!.size!.height;
                              setState(() {});
                            },
                            onExit: (event) {
                              whoComment = '';
                              setState(() {});
                            },
                            child: Text(
                              con.replyLikes[val['id']] ?? 'Like',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: con.replyLikes[val['id']] == null
                                      ? Colors.black
                                      : likesColor[con.replyLikes[val['id']]]),
                            )),
                        const Padding(padding: EdgeInsets.only(left: 6)),
                        MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: InkWell(
                                onTap: () {
                                  if (!whatReply.contains(e['id'])) {
                                    whatReply.add(e['id']);
                                  }
                                  setState(() {});
                                },
                                child: const Text(
                                  'Reply',
                                  style: TextStyle(fontSize: 13),
                                ))),
                        const Padding(padding: EdgeInsets.only(left: 10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: replyLikesCount
                              .map((val) => Container(
                                  padding: const EdgeInsets.only(left: 3),
                                  child: Row(
                                    children: [
                                      Image.network(
                                        emoticon[val['likes']].toString(),
                                        width: 20,
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(left: 3)),
                                      Text(val['count'].toString())
                                    ],
                                  )))
                              .toList(),
                        ),
                      ],
                    )),
              ],
            )
          ],
        ));
  }

  Future<XFile> chooseImage() async {
    final _imagePicker = ImagePicker();
    XFile? pickedFile;
    if (kIsWeb) {
      pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
    } else {
      //Check Permissions
      // await Permission.photos.request();
      // var permissionStatus = await Permission.photos.status;

      //if (permissionStatus.isGranted) {
      pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      //} else {
      //  print('Permission not granted. Try Again with permission access');
      //}
    }
    return pickedFile!;
  }

  uploadFile(XFile? pickedFile, type) async {
    if (type == 'photo') {
      productPhoto.add({'id': productPhoto.length, 'url': ''});
      photoLength = productPhoto.length - 1;
      setState(() {});
    } else {
      productFile.add({'id': productFile.length, 'url': ''});
      fileLength = productFile.length - 1;
      setState(() {});
    }
    final _firebaseStorage = FirebaseStorage.instance;
    var uploadTask;
    Reference _reference;
    try {
      if (kIsWeb) {
        //print("read bytes");
        Uint8List bytes = await pickedFile!.readAsBytes();
        //print(bytes);
        _reference = await _firebaseStorage
            .ref()
            .child('images/${PPath.basename(pickedFile.path)}');
        uploadTask = _reference.putData(
          bytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      } else {
        var file = File(pickedFile!.path);
        //write a code for android or ios
        _reference = await _firebaseStorage
            .ref()
            .child('images/${PPath.basename(pickedFile.path)}');
        uploadTask = _reference.putFile(file);
      }

      uploadTask.whenComplete(() async {
        var downloadUrl = await _reference.getDownloadURL();
        if (type == 'photo') {
          for (var i = 0; i < productPhoto.length; i++) {
            if (productPhoto[i]['id'] == photoLength) {
              productPhoto[i]['url'] = downloadUrl;
              productInfo['productPhoto'] = productPhoto;
              setState(() {});
            }
          }
        } else {
          for (var i = 0; i < productFile.length; i++) {
            if (productFile[i]['id'] == fileLength) {
              productFile[i]['url'] = downloadUrl;
              productInfo['productFile'] = productFile;
              setState(() {});
            }
          }
        }
        print(productFile);
      });
      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            if (type == 'photo') {
              uploadPhotoProgress = 100.0 *
                  (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
              setState(() {});
              print("Upload is $uploadPhotoProgress% complete.");
            } else {
              uploadFileProgress = 100.0 *
                  (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
              setState(() {});
              print("Upload is $uploadFileProgress% complete.");
            }

            break;
          case TaskState.paused:
            print("Upload is paused.");
            break;
          case TaskState.canceled:
            print("Upload was canceled");
            break;
          case TaskState.error:
            // Handle unsuccessful uploads
            break;
          case TaskState.success:
            print("Upload is completed");
            uploadFileProgress = 0;
            setState(() {});
            // Handle successful uploads on complete
            // ...
            //  var downloadUrl = await _reference.getDownloadURL();
            break;
        }
      });
    } catch (e) {
      // print("Exception $e");
    }
  }

  uploadImage(type) async {
    XFile? pickedFile = await chooseImage();
    uploadFile(pickedFile, type);
  }
}

Widget input({label, onchange, obscureText = false, validator}) {
  return Container(
    height: 28,
    child: StartedInput(
      validator: (val) async {
        validator(val);
      },
      obscureText: obscureText,
      onChange: (val) async {
        onchange(val);
      },
    ),
  );
}
