// ignore_for_file: unnecessary_null_comparison

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:flutter/foundation.dart' as foundation;
import 'package:shnatter/src/controllers/PeopleController.dart';
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/widget/startedInput.dart';

import 'package:shnatter/src/widget/sharePostWidget.dart';

import '../helpers/emailverified.dart';

class LikesCommentScreen extends StatefulWidget {
  late PostController con;

  var postInfo;
  var postId;

  LikesCommentScreen(
      {Key? key,
      this.postInfo,
      this.postId = '',
      required this.commentFlag,
      required this.routerChange,
      this.shareFlag = true})
      : con = PostController(),
        super(key: key);
  Function routerChange;
  bool commentFlag;
  bool shareFlag;
  @override
  State createState() => LikesCommentScreenState();
}

class LikesCommentScreenState extends mvc.StateMVC<LikesCommentScreen> {
  bool isSound = false;
  late PostController con;
  late PeopleController peopleCon;

  Map<String, dynamic> productInfo = {
    'productStatus': 'New',
    'productOffer': 'Sell'
  };
  var category = 'Choose Category';
  TextEditingController commentController = TextEditingController();
  double uploadPhotoProgress = 0;
  // List<dynamic> postPhoto = [];
  // List<dynamic> productFile = [];
  String comment = '';

  var userInfo = UserManager.userInfo;
  double uploadFileProgress = 0;
  var photoLength;
  var fileLength;
  var commentHeight = 0.0;
  bool isVerified = true;
  bool offer1 = true;
  bool offer2 = false;
  var whoComment = '';
  bool isComment = false;
  bool isLike = false;
  var whatImage = '';
  var whoHover = '';
  var whatReply = [];
  var reply = {};
  bool emojiShowing = false;
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
  initState() {
    add(widget.con);
    con = controller as PostController;
    //peopleCon = controller as PeopleController;

    super.initState();
    con.addNotifyCallBack(this);
    //LikeCommentController().addNotifyCallBack(this);
    isVerified = EmailVerified.getVerified();

    con.loadPostLikes(widget.postInfo['id']);
    con.loadComments(widget.postInfo['id']);
  }

  // getComment() {
  //   con.getComment(widget.postInfo['id']).then((value) {
  //     allComment = value;
  //     setState(() {});
  //   });
  // }

  // getLikes() {
  //   con.getPostLikes(widget.postInfo['id']).then((value) {
  //     likes = value;
  //     setState(() {});
  //   });
  // }

  viewLikeUser(postlike) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: allLikeUser(postlike),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //setState(() {});
    // getLikes();
    // getComment();

    //setState(() {});
    // var mylikevalue = con.myLike.firstWhere(
    //     (element) => element['postId'] == widget.postInfo['id'],
    //     orElse: () => null);
    var totalLikeImage = [];
    Map myLike = {};
    var likesvalue = con.likes[widget.postInfo['id'].toString()];
    if (likesvalue != null) {
      for (var i = 0; i < likesvalue.length; i++) {
        var flag = true;
        for (var j = 0; j < totalLikeImage.length; j++) {
          if (likesvalue[i]['value'] == totalLikeImage[j]) {
            flag = false;

            continue;
          }
        }
        if (flag) totalLikeImage.add(likesvalue[i]['value']);
      }

      totalLikeImage.sort();

      myLike = likesvalue
              .where((like) =>
                  like['userInfo'] != null &&
                  like['userInfo']['userName'] == userInfo['userName'])
              .toList()
              .isEmpty
          ? {}
          : likesvalue
              .where((like) =>
                  like['userInfo']['userName'] == userInfo['userName'])
              .toList()[0];
    }

    List allComment = [];
    if (con.comments != {}) {
      if (con.comments[widget.postInfo['id']] != null) {
        allComment = con.comments[widget.postInfo['id']];
      }
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
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
                    InkWell(
                      onTap: () {
                        viewLikeUser(con.likes[widget.postInfo['id']]);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: totalLikeImage
                            .map(
                              (val) => Container(
                                padding: const EdgeInsets.only(left: 3),
                                child: Row(
                                  children: [
                                    Image.network(
                                      emoticon[val].toString(),
                                      width: 20,
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    Text(
                        '${likesvalue == null || likesvalue.length == 0 ? '' : likesvalue.length}'),
                    const Flexible(fit: FlexFit.tight, child: SizedBox()),
                    const Icon(
                      FontAwesomeIcons.solidComment,
                      color: Colors.grey,
                      size: 13,
                    ),
                    const Padding(padding: EdgeInsets.only(left: 5)),
                    InkWell(
                        onTap: () async {
                          isComment = !isComment;
                          setState(() {});
                        },
                        child: Text(
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            '${allComment != null ? allComment.length : 0} comments')),
                    const Padding(padding: EdgeInsets.only(right: 15)),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 40),
                child: const Divider(
                    color: Color.fromARGB(69, 83, 79, 79), thickness: 0.1),
              ),
              Container(
                margin: const EdgeInsets.only(top: 50),
                height: 45,
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 5, bottom: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: IgnorePointer(
                        ignoring: !EmailVerified.getVerified(),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (value) {
                            whoHover = 'like';

                            setState(() {});
                          },
                          onExit: (event) {
                            whoHover = '';
                            setState(() {});
                          },
                          child: Container(
                            foregroundDecoration: EmailVerified.getVerified()
                                ? null
                                : const BoxDecoration(
                                    //this can make disabled effect
                                    color: Colors.grey,
                                    backgroundBlendMode: BlendMode.lighten),
                            child: InkWell(
                              onTap: () {
                                isLike = !isLike;
                                setState(() {});
                              },
                              child: AnimatedContainer(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: whoHover == 'like'
                                        ? const Color.fromRGBO(240, 240, 245, 1)
                                        : Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(3))),
                                duration: const Duration(milliseconds: 300),
                                width: SizeConfig(context).screenWidth > 600
                                    ? (600 - 60) / 3
                                    : (SizeConfig(context).screenWidth - 60) /
                                        3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    myLike['value'] == null
                                        ? const Icon(
                                            FontAwesomeIcons.thumbsUp,
                                            color: Color(0xff505050),
                                            size: 15,
                                          )
                                        : Image.network(
                                            emoticon[myLike['value']]
                                                .toString(),
                                            width: 20,
                                          ),
                                    const Padding(
                                        padding: EdgeInsets.only(left: 5)),
                                    Text(
                                      myLike['value'] ?? 'Like',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: myLike['value'] == null
                                            ? const Color(0xff505050)
                                            : likesColor[myLike['value']],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    widget.commentFlag
                        ? Expanded(
                            child: MouseRegion(
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
                                  setState(() {});
                                },
                                child: AnimatedContainer(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: whoHover == 'comment'
                                          ? const Color.fromRGBO(
                                              240, 240, 245, 1)
                                          : Colors.white,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(3))),
                                  duration: const Duration(milliseconds: 300),
                                  width: SizeConfig(context).screenWidth > 600
                                      ? (600 - 60) / 3
                                      : (SizeConfig(context).screenWidth - 60) /
                                          3,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        FontAwesomeIcons.message,
                                        color: Color(0xff505050),
                                        size: 15,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 5)),
                                      Text(
                                        'Comment',
                                        style: TextStyle(
                                            color: Color(0xff505050),
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    Expanded(
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (value) {
                          whoHover = 'share';

                          setState(() {});
                        },
                        onExit: (event) {
                          whoHover = '';
                          setState(() {});
                        },
                        child: InkWell(
                          onTap: () async {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: AlertDialog(
                                        title: Row(
                                          children: const [
                                            Icon(
                                              FontAwesomeIcons.share,
                                              size: 15,
                                              color: Color(0xff505050),
                                            ),
                                            Text(
                                              'Share',
                                              style: TextStyle(
                                                  color: Color(0xff505050),
                                                  fontSize: 15,
                                                  fontStyle: FontStyle.normal),
                                            ),
                                          ],
                                        ),
                                        insetPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 1),
                                        content: SharePostModal(
                                          context: context,
                                          routerChange: widget.routerChange,
                                          postInfo: widget.shareFlag
                                              ? widget.postInfo
                                              : widget.postInfo['data'],
                                        ))));
                          },
                          child: AnimatedContainer(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: whoHover == 'share'
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
                              children: const [
                                Icon(
                                  FontAwesomeIcons.share,
                                  color: Color(0xff505050),
                                  size: 15,
                                ),
                                Padding(padding: EdgeInsets.only(left: 5)),
                                Text(
                                  'Share',
                                  style: TextStyle(
                                      color: Color(0xff505050),
                                      fontWeight: FontWeight.w700),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              isLike
                  ? Container(
                      margin: const EdgeInsets.only(top: 6),
                      child: likesWidget('product', (value) async {
                        isLike = false;
                        await con.savePostLikes(widget.postInfo['id'], value);

                        // myLike['value'] = value;

                        whoHover = '';
                      }),
                    )
                  : Container()
            ],
          ),
          // SingleChildScrollView(
          //   controller: _scrollController,
          //   scrollDirection: Axis.horizontal,
          //   child: Container(
          //     alignment: Alignment.centerLeft,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: postPhoto
          //           .map(((e) => postPhotoWidget(e['url'], e['id'])))
          //           .toList(),
          //     ),
          //   ),
          // ),
          !isComment || !widget.commentFlag
              ? const SizedBox()
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
                      input(
                        (value) {
                          comment = value;
                        },
                        () async {
                          if (comment != '') {
                            await con
                                .saveComment(
                                    widget.postInfo['id'], comment, 'text')
                                .then((value1) {
                              commentController.text = '';
                            });

                            setState(() {});
                          }
                        },
                      ),
                    ],
                  ),
                ),
          Offstage(
            offstage: !emojiShowing,
            child: SizedBox(
                height: 250,
                child: EmojiPicker(
                  onEmojiSelected: (category, Emoji emoji) {
                    comment = comment + emoji.emoji;
                  },
                  textEditingController: commentController,
                  config: Config(
                    columns: 7,
                    // Issue: https://github.com/flutter/flutter/issues/28894
                    emojiSizeMax: 32 *
                        (foundation.defaultTargetPlatform == TargetPlatform.iOS
                            ? 1.30
                            : 1.0),
                    verticalSpacing: 0,
                    horizontalSpacing: 0,
                    gridPadding: EdgeInsets.zero,
                    initCategory: Category.RECENT,
                    bgColor: const Color(0xFFF2F2F2),
                    indicatorColor: Colors.blue,
                    iconColor: Colors.grey,
                    iconColorSelected: Colors.blue,
                    backspaceColor: Colors.blue,
                    skinToneDialogBgColor: Colors.white,
                    skinToneIndicatorColor: Colors.grey,
                    enableSkinTones: true,
                    showRecentsTab: true,
                    recentsLimit: 28,
                    replaceEmojiOnLimitExceed: false,
                    noRecents: const Text(
                      'No Recents',
                      style: TextStyle(fontSize: 20, color: Colors.black26),
                      textAlign: TextAlign.center,
                    ),
                    loadingIndicator: const SizedBox.shrink(),
                    tabIndicatorAnimDuration: kTabScrollDuration,
                    categoryIcons: const CategoryIcons(),
                    buttonMode: ButtonMode.MATERIAL,
                    checkPlatformCompatibility: true,
                  ),
                )),
          ),
          Container(
            width: SizeConfig(context).screenWidth > 600
                ? 600
                : SizeConfig(context).screenWidth,
            padding: const EdgeInsets.only(left: 20, right: 15, bottom: 10),
            color: const Color.fromRGBO(245, 245, 245, 1),
            child: isComment && allComment != null && allComment.isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: allComment.length,
                    itemBuilder: (BuildContext context, int index) {
                      return eachComment(
                        allComment[index],
                      );
                    },
                  )
                : Container(),
          )
        ],
      ),
    );
  }

  Widget input(onChange, onClick) {
    return Container(
        height: 30,
        width: SizeConfig(context).screenWidth > 600
            ? 500
            : SizeConfig(context).screenWidth - 148,
        decoration: BoxDecoration(
            border: Border.all(
                color: const Color.fromRGBO(220, 220, 220, 1), width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(30))),
        child: Row(
          children: [
            SizedBox(
              height: 30,
              width: SizeConfig(context).screenWidth > 600
                  ? 350
                  : SizeConfig(context).screenWidth - 225,
              child: TextField(
                controller: null,
                cursorWidth: 1,
                onChanged: (value) {
                  onChange(value);
                },
                style: const TextStyle(fontSize: 12, fontFamily: 'Hind'),
                decoration: const InputDecoration(
                    hintText: 'Write a comment',
                    hintStyle: TextStyle(fontSize: 12, fontFamily: 'Hind'),
                    contentPadding: foundation.kIsWeb
                        ? EdgeInsets.only(top: 20, left: 10, bottom: 12)
                        : EdgeInsets.only(top: 20, left: 10, bottom: 7),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none),
              ),
            ),
            const Flexible(fit: FlexFit.tight, child: SizedBox()),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: InkWell(
                onTap: () async {
                  print("onclick ");
                  onClick();
                  setState(() {
                    emojiShowing = false;
                  });
                },
                child: const Icon(
                  Icons.send,
                  size: 20,
                  color: Colors.lightBlue,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(right: 5)),
            // MouseRegion(
            //   cursor: SystemMouseCursors.click,
            //   child: InkWell(
            //     onTap: () {
            //       // uploadImage('photo');
            //     },
            //     child: const Icon(
            //       Icons.photo,
            //       size: 20,
            //       color: Colors.grey,
            //     ),
            //   ),
            // ),
            // const Padding(padding: EdgeInsets.only(right: 5)),
            // MouseRegion(
            //   cursor: SystemMouseCursors.click,
            //   child: InkWell(
            //     onTap: () {},
            //     child: const Icon(
            //       Icons.mic,
            //       size: 20,
            //       color: Colors.grey,
            //     ),
            //   ),
            // ),
            // const Padding(padding: EdgeInsets.only(right: 5)),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: InkWell(
                onTap: () {
                  setState(() {
                    emojiShowing = !emojiShowing;
                  });
                },
                child: const Icon(
                  Icons.emoji_emotions,
                  color: Colors.yellow,
                  size: 20,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(right: 20)),
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
                .map(
                  (e) => SizedBox(
                    width: SizeConfig(context).screenWidth > 600
                        ? (370 - 10) / 7
                        : (SizeConfig(context).screenWidth * 3.7 / 6 - 10) / 7,
                    // padding: const EdgeInsets.only(right: 10),
                    child: MouseRegion(
                      child: InkWell(
                          onTap: () {
                            onClick(e['value']);
                          },
                          child: AnimatedContainer(
                            height: whatImage == e['value'] ? 50 : 40,
                            duration: const Duration(milliseconds: 200),
                            child: Image.network(
                              e['image'],
                            ),
                          )),
                    ),
                  ),
                )
                .toList()),
      ),
    );
  }

  Widget eachComment(e) {
    List replies = con.commentReply[e['id']] ?? [];
    //List commentLikesCount = con.commentLikesCount[e['id']] ?? [];
    var totalLikeImage = [];
    Map myLike = {};
    var likesvalue = con.commentLikes[e['id']] ?? [];
    if (likesvalue != null) {
      //  for (var key in likesvalue.values) {
      for (var i = 0; i < likesvalue.length; i++) {
        var flag = true;
        for (var j = 0; j < totalLikeImage.length; j++) {
          if (likesvalue[i]['value'] == totalLikeImage[j]) {
            flag = false;

            continue;
          }
        }
        if (flag) {
          totalLikeImage.add(likesvalue[i]['value']);
        }
      }
    }

    var commentLikesCount = totalLikeImage;
    Map myCommentLike = {};

    myCommentLike = likesvalue
            .where((like) => like['uid'] == userInfo['uid'])
            .toList()
            .isEmpty
        ? {}
        : likesvalue
            .where((like) => like['uid'] == userInfo['uid'])
            .toList()[0];
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
          //Avatar
          e['userInfo']['avatar'] == ''
              ? CircleAvatar(
                  radius: 18,
                  child: SvgPicture.network(Helper.avatar),
                )
              : CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(e['userInfo']['avatar']),
                ),
          const Padding(padding: EdgeInsets.only(left: 10)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    //User and Comment
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      key: key,
                      constraints:
                          BoxConstraints(minWidth: 50, maxWidth: width),
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                              '${e['userInfo']['firstName']} ${e['userInfo']['lastName']}'),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          e['data']['type'] == 'text'
                              ? Text(e['data']['content'])
                              //     : e['data']['type'] == 'photo'
                              //         ? Image.network(
                              //             e['data']['content'].toString(),
                              //             width: 20)
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                  whoComment == e['id']
                      ? Container(
                          margin: EdgeInsets.only(top: commentHeight - 40),
                          child: likesWidget(e['id'], (value) {
                            whoComment = '';
                            // con.commentLikes[e['id']] = whatImage;
                            setState(() {});
                            con.saveLikesComment(
                                widget.postInfo['id'], e['id'], value);
                            setState(() {});
                          }),
                        )
                      : Container()
                ],
              ),
              const Padding(padding: EdgeInsets.only(left: 7)),
              Container(
                //Like & reply button
                padding: const EdgeInsets.only(left: 7),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (whoComment == '') {
                          whoComment = e['id'];
                          commentHeight = key.currentContext!.size!.height;

                          setState(() {});
                        } else {
                          whoComment = '';

                          setState(() {});
                        }
                      },
                      child: Text(
                        myCommentLike['value'] ?? 'Like',
                        style: TextStyle(
                            fontSize: 13,
                            color: myCommentLike['value'] == null
                                ? Colors.black
                                : likesColor[myCommentLike['value']]),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 6)),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: InkWell(
                        onTap: () {
                          if (whatReply.isNotEmpty) whatReply.removeLast();
                          if (!whatReply.contains(e['id'])) {
                            whatReply.add(e['id']);
                          } else {
                            whatReply.remove(e['id']);
                          }
                          setState(() {});
                        },
                        child: const Text(
                          'Reply',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    InkWell(
                      onTap: () {
                        viewLikeUser(con.commentLikes[e['id']]);
                      },
                      child: Row(
                        children: commentLikesCount
                            .map(
                              (value) => Container(
                                padding: const EdgeInsets.only(left: 3),
                                child: Row(
                                  children: [
                                    Image.network(
                                      emoticon[value].toString(),
                                      width: 20,
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 3)),
                    //${likesvalue == null || likesvalue.length == 0 ? '' : likesvalue.length}'
                    likesvalue.length > 1
                        ? Text(likesvalue.length.toString())
                        : const SizedBox()
                  ],
                ),
              ),
              whatReply.contains(e['id']) //reply comment list
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < e['reply'].length; i++)
                          replyWidget(e['reply'][i], e['id'])
                      ],
                    )
                  : Container(
                      padding:
                          const EdgeInsets.only(top: 10, bottom: 30, left: 10),
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
                            '${e['reply'].length} Replies',
                            style: const TextStyle(fontSize: 12),
                          ),
                        )
                      ]),
                    ),
              whatReply.contains(e['id']) &&
                      widget.commentFlag &&
                      (reply[e['id']] == null ||
                          reply[e['id']] == '') //reply comment textedit
                  ? Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: input((value) {
                        reply[e['id']] = value;
                      }, () async {
                        print("reply[e['id']]  is ${reply[e['id']]}");
                        if (reply[e['id']] != null && reply[e['id']] != '') {
                          print("reply[e['id']]  is ${reply[e['id']]}");
                          await con.saveReply(widget.postInfo['id'], e['id'],
                              reply[e['id']], 'text');
                          reply[e['id']] = '';
                          //   whatReply.remove(e['id']);
                          setState(() {});
                        }
                      }),
                    )
                  : Container()
            ],
          )
        ],
      ),
    );
  }

  var replyLikesCount;
  Widget replyWidget(val, e) {
    double width = SizeConfig(context).screenWidth > 600
        ? 500
        : SizeConfig(context).screenWidth - 87;
    var key1 = GlobalKey();

    //  List replies = con.commentReply[e['id']] ?? [];
    //List commentLikesCount = con.commentLikesCount[e['id']] ?? [];
    var totalLikeImage = [];
    if (con.replyLikesCount != null) {
      var likesvalue = con.replyLikesCount[val['id']] ?? [];
      if (likesvalue != null) {
        //  for (var key in likesvalue.values) {
        for (var i = 0; i < likesvalue.length; i++) {
          var flag = true;
          for (var j = 0; j < totalLikeImage.length; j++) {
            if (likesvalue[i]['likes'] == totalLikeImage[j]) {
              flag = false;

              continue;
            }
          }
          if (flag) {
            totalLikeImage.add(likesvalue[i]['likes']);
          }
        }
      }
      replyLikesCount = totalLikeImage;
    }

    return Container(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          val['userInfo']['avatar'] == ''
              ? CircleAvatar(
                  radius: 18,
                  child: SvgPicture.network(Helper.avatar),
                )
              : CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(val['userInfo']['avatar']),
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
                              Text(val['userInfo']['firstName'] +
                                  " " +
                                  val['userInfo']['lastName']),
                              const Padding(padding: EdgeInsets.only(top: 10)),
                              Text(val['data']['content']),
                            ],
                          ))),
                  whoComment == val['id']
                      ? Container(
                          margin: EdgeInsets.only(top: commentHeight - 40),
                          child: likesWidget(val['id'], (value) {
                            whoComment = '';
                            con.replyLikes[val['id']] = value;
                            setState(() {});
                            con.saveLikesReply(
                                widget.postInfo['id'], e, val['id'], value);
                            setState(() {});
                          }),
                        )
                      : Container()
                ],
              ),
              const Padding(padding: EdgeInsets.only(left: 7)),
              // Container(
              //   padding: const EdgeInsets.only(left: 7),
              //   child: Row(
              //     children: [
              //       // Like button of Reply Comment
              //       // InkWell(
              //       //   onTap: () {
              //       //     if (whoComment == '') {
              //       //       whoComment = val['id'];
              //       //       commentHeight = key1.currentContext!.size!.height;

              //       //       setState(() {});
              //       //     } else {
              //       //       whoComment = '';

              //       //       setState(() {});
              //       //     }
              //       //   },
              //       //   child: Text(
              //       //     con.replyLikes[val['id']] ?? 'Like',
              //       //     style: TextStyle(
              //       //         fontSize: 13,
              //       //         color: con.replyLikes[val['id']] == null
              //       //             ? Colors.black
              //       //             : likesColor[con.replyLikes[val['id']]]),
              //       //   ),
              //       // ),
              //       // const Padding(padding: EdgeInsets.only(left: 6)),
              //       //Reply button of Reply Comment
              //       // MouseRegion(
              //       //   cursor: SystemMouseCursors.click,
              //       //   child: InkWell(
              //       //     onTap: () {
              //       //       if (!whatReply.contains(val['id'])) {
              //       //         whatReply.add(val['id']);
              //       //       }
              //       //       setState(() {});
              //       //     },
              //       //     child: const Text(
              //       //       'Reply',
              //       //       style: TextStyle(fontSize: 13),
              //       //     ),
              //       //   ),
              //       // ),
              //       // const Padding(padding: EdgeInsets.only(left: 10)),
              //       // InkWell(
              //       //   onTap: () {
              //       //     //  viewLikeUser(con.replyLikesCount[val['id']]);
              //       //   },
              //       //   child: Row(
              //       //     //children: con.replyLikesCount[val['id']]
              //       //     children: totalLikeImage
              //       //         .map<Widget>(
              //       //           (value) => Container(
              //       //             padding: const EdgeInsets.only(left: 3),
              //       //             child: Row(
              //       //               children: [
              //       //                 Image.network(
              //       //                   emoticon[value].toString(),
              //       //                   width: 20,
              //       //                 ),
              //       //               ],
              //       //             ),
              //       //           ),
              //       //         )
              //       //         .toList(),
              //       //   ),
              //       // ),
              //       // const Padding(padding: EdgeInsets.only(left: 3)),
              //       // Text(totalLikeImage.length.toString())
              //     ],
              //   ),
              // ),
            ],
          )
        ],
      ),
    );
  }

  Widget allLikeUser(postlike) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            width: 400,
            height: 300,
            child: DefaultTabController(
              length: 8,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.grey,
                  bottom: TabBar(
                    isScrollable: true,
                    tabs: [
                      const Tab(
                        height: 30,
                        child: Text('All'),
                      ),
                      for (int i = 0; i < likesImage.length; i++)
                        Tab(
                          height: 30,
                          child: Image.network(
                            likesImage[i]['image'],
                            width: 40,
                          ),
                        ),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    userCell(postlike),
                    for (int i = 0; i < likesImage.length; i++)
                      userCell(postlike
                          .where((element) =>
                              element['value'] == likesImage[i]['value'])
                          .toList()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget userCell(likeUsers) {
    return likeUsers.isEmpty
        ? Container(
            alignment: Alignment.center,
            child: const Text(
              'No reactions yet',
              style: TextStyle(fontSize: 15),
            ),
          )
        : Container(
            margin: const EdgeInsets.only(top: 10),
            child: ListView.separated(
              itemCount: likeUsers.length,
              itemBuilder: (context, index) => Material(
                child: ListTile(
                  contentPadding: const EdgeInsets.only(left: 10, right: 10),
                  leading: likeUsers[index]['userInfo']['avatar'] == ''
                      ? Stack(
                          children: [
                            CircleAvatar(
                                radius: 17,
                                child: SvgPicture.network(Helper.avatar)),
                            Container(
                              margin: const EdgeInsets.only(top: 20, left: 20),
                              child: Image.network(
                                emoticon[likeUsers[index]['value']]!,
                                width: 20,
                              ),
                            )
                          ],
                        )
                      : Stack(
                          children: [
                            CircleAvatar(
                                radius: 17,
                                backgroundImage: NetworkImage(
                                    likeUsers[index]['userInfo']['avatar'])),
                            Container(
                              margin: const EdgeInsets.only(top: 20, left: 20),
                              child: Image.network(
                                emoticon[likeUsers[index]['value']]!,
                                width: 20,
                              ),
                            )
                          ],
                        ),
                  title: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 11),
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                '${likeUsers[index]['userInfo']['firstName']} ${likeUsers[index]['userInfo']['lastName']}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: Colors.black),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                ProfileController().updateProfile(
                                    likeUsers[index]['userInfo']['userName']);
                                widget.routerChange({
                                  'router': RouteNames.profile,
                                  'subRouter': likeUsers[index]['userInfo']
                                      ['userName']
                                });
                              })
                      ],
                    ),
                  ),
                  trailing: likeUsers[index]['userInfo']['userName'] ==
                          userInfo['userName']
                      ? const SizedBox()
                      : ElevatedButton(
                          onPressed: () async {
                            PeopleController().requestFriendAsData(
                              likeUsers[index]['userInfo']['userName'],
                              '${likeUsers[index]['userInfo']['firstName']} ${likeUsers[index]['userInfo']['lastName']}',
                              likeUsers[index]['userInfo']['avatar'],
                            );
                            //   setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 33, 37, 41),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2.0)),
                            minimumSize: const Size(80, 35),
                            maximumSize: const Size(80, 35),
                          ),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.person_add_alt_rounded,
                                color: Colors.white,
                                size: 18.0,
                              ),
                              Text(' Add',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900)),
                            ],
                          ),
                        ),
                ),
              ),
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                height: 1,
                endIndent: 10,
              ),
            ),
          );
  }

  // Widget postPhotoWidget(photo, id) {
  //   return Container(
  //     width: 90,
  //     height: 90,
  //     margin: const EdgeInsets.all(5),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(13),
  //     ),
  //     child: Stack(
  //       children: [
  //         photo != null
  //             ? Container(
  //                 width: 90,
  //                 height: 90,
  //                 alignment: Alignment.topRight,
  //                 decoration: BoxDecoration(
  //                   image: DecorationImage(
  //                     image: NetworkImage(photo),
  //                     fit: BoxFit.cover,
  //                   ),
  //                 ),
  //                 child: IconButton(
  //                   icon: const Icon(Icons.close,
  //                       color: Colors.black, size: 13.0),
  //                   padding: EdgeInsets.only(left: 20),
  //                   tooltip: 'Delete',
  //                   onPressed: () {
  //                     postPhoto.removeWhere((item) => item['id'] == id);
  //                     if (postPhoto.isEmpty) {
  //                       //  nowPost = '';
  //                     }
  //                     setState(() {});
  //                   },
  //                 ),
  //               )
  //             : const SizedBox(),
  //         // : const SizedBox(),
  //         (uploadPhotoProgress != 0 && uploadPhotoProgress != 100)
  //             ? AnimatedContainer(
  //                 duration: const Duration(milliseconds: 500),
  //                 margin: const EdgeInsets.only(top: 78, left: 10),
  //                 width: 130,
  //                 padding: EdgeInsets.only(
  //                     right: 130 - (130 * uploadPhotoProgress / 100)),
  //                 child: const LinearProgressIndicator(
  //                   color: Colors.blue,
  //                   value: 10,
  //                   semanticsLabel: 'Linear progress indicator',
  //                 ),
  //               )
  //             : const SizedBox(),
  //       ],
  //     ),
  //   );
  // }

  // Future<XFile> chooseImage() async {
  //   final _imagePicker = ImagePicker();
  //   XFile? pickedFile;
  //   if (kIsWeb) {
  //     pickedFile = await _imagePicker.pickImage(
  //       source: ImageSource.gallery,
  //     );
  //   } else {
  //     //Check Permissions
  //     // await Permission.photos.request();
  //     // var permissionStatus = await Permission.photos.status;

  //     //if (permissionStatus.isGranted) {
  //     pickedFile = await _imagePicker.pickImage(
  //       source: ImageSource.gallery,
  //     );
  //     //} else {
  //     //  print('Permission not granted. Try Again with permission access');
  //     //}
  //   }
  //   return pickedFile!;
  // }

  // uploadFile(XFile? pickedFile, type) async {
  //   if (type == 'photo') {
  //     postPhoto.add({'id': postPhoto.length, 'url': ''});
  //     photoLength = postPhoto.length - 1;
  //     setState(() {});
  //   } else {
  //     productFile.add({'id': productFile.length, 'url': ''});
  //     fileLength = productFile.length - 1;
  //     setState(() {});
  //   }
  //   final _firebaseStorage = FirebaseStorage.instance;
  //   var uploadTask;
  //   Reference _reference;
  //   try {
  //     if (kIsWeb) {
  //       //print("read bytes");
  //       Uint8List bytes = await pickedFile!.readAsBytes();
  //       //print(bytes);
  //       _reference = await _firebaseStorage
  //           .ref()
  //           .child('images/${PPath.basename(pickedFile.path)}');
  //       uploadTask = _reference.putData(
  //         bytes,
  //         SettableMetadata(contentType: 'image/jpeg'),
  //       );
  //     } else {
  //       var file = File(pickedFile!.path);
  //       //write a code for android or ios
  //       _reference = await _firebaseStorage
  //           .ref()
  //           .child('images/${PPath.basename(pickedFile.path)}');
  //       uploadTask = _reference.putFile(file);
  //     }

  //     uploadTask.whenComplete(() async {
  //       var downloadUrl = await _reference.getDownloadURL();
  //       print(downloadUrl);
  //       if (type == 'photo') {
  //         for (var i = 0; i < postPhoto.length; i++) {
  //           if (postPhoto[i]['id'] == photoLength) {
  //             postPhoto[i]['url'] = downloadUrl;

  //             setState(() {});
  //           }
  //         }
  //       } else {
  //         // for (var i = 0; i < productFile.length; i++) {
  //         //   if (productFile[i]['id'] == fileLength) {
  //         //     productFile[i]['url'] = downloadUrl;
  //         //     productInfo['productFile'] = productFile;
  //         //     setState(() {});
  //         //   }
  //         // }
  //       }
  //       print(productFile);
  //     });
  //     uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
  //       switch (taskSnapshot.state) {
  //         case TaskState.running:
  //           if (type == 'photo') {
  //             uploadPhotoProgress = 100.0 *
  //                 (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
  //             setState(() {});
  //             print("Upload is $uploadPhotoProgress% complete.");
  //           } else {
  //             uploadFileProgress = 100.0 *
  //                 (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
  //             setState(() {});
  //             print("Upload is $uploadFileProgress% complete.");
  //           }

  //           break;
  //         case TaskState.paused:
  //           print("Upload is paused.");
  //           break;
  //         case TaskState.canceled:
  //           print("Upload was canceled");
  //           break;
  //         case TaskState.error:
  //           // Handle unsuccessful uploads
  //           break;
  //         case TaskState.success:
  //           print("Upload is completed");
  //           uploadFileProgress = 0;
  //           setState(() {});
  //           // Handle successful uploads on complete
  //           // ...
  //           //  var downloadUrl = await _reference.getDownloadURL();
  //           break;
  //       }
  //     });
  //   } catch (e) {
  //     // print("Exception $e");
  //   }
  // }

  // uploadImage(type) async {
  //   XFile? pickedFile = await chooseImage();
  //   uploadFile(pickedFile, type);
  // }
}

Widget input({label, onchange, obscureText = false, validator}) {
  return SizedBox(
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
