import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as PPath;

import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';

import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/widget/mindslice.dart';

import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

class MindPost extends StatefulWidget {
  MindPost({Key? key})
      : con = PostController(),
        super(key: key);
  final PostController con;
  @override
  State createState() => MindPostState();
}

// ignore: must_be_immutable
class MindPostState extends mvc.StateMVC<MindPost> {
  String dropdownValue = 'Public';
  final _focus = FocusNode();
  final ScrollController _scrollController = ScrollController();
  var show = false;
  var postPhoto = [];
  String postAudio = '';
  int photoLength = 0;
  int audioLength = 0;
  double uploadPhotoProgress = 0;
  double uploadAudioProgress = 0;
  String nowPost = '';
  bool postLoading = false;
  String activity = '';
  String subActivityLabel = '';
  String subActivity = '';
  String checkLocation = '';
  String pollQuestion = '';
  List<String> pollOption = [];
  bool emojiShowing = false;

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  late PostController con;
  late List<Map> mindPostCase = [
    {
      'title': 'Upload Photos',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Fcamera.svg?alt=media&token=0b7478a3-c746-47ed-a4fc-7505accf22a5',
      'mindFunc': () {
        uploadPhotoReady();
      }
    },
    // {
    //   'title': 'Create Album',
    //   'image':
    //       'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Falbum.svg?alt=media&token=a24aeb90-c93c-4a92-b116-7d85f2a3acbc',
    //   'mindFunc': (context) {}
    // },
    {
      'title': 'Feelings/Activity',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Femoji.svg?alt=media&token=d8ff786b-c7e0-4922-a260-0627bacab851',
      'mindFunc': () {
        feelingReady();
      }
    },
    {
      'title': 'Check In',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Fcheckin.svg?alt=media&token=6f228dbc-b1a4-4d13-860b-18b686602738',
      'mindFunc': () {
        checkIn();
      }
    },
    // {
    //   'title': 'Colored Posts',
    //   'image':
    //       'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Fcolor.svg?alt=media&token=7d8b7631-2471-4acf-8f34-e0071e7a4600',
    //   'mindFunc': (context) {}
    // },
    // {
    //   'title': 'Voice Notes',
    //   'image':
    //       'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Fvoice.svg?alt=media&token=b49c28b5-3b27-487e-a6c1-ffd978c215fa',
    //   'mindFunc': (context) {}
    // },
    // {
    //   'title': 'Write Aticle',
    //   'image':
    //       'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Farticle.svg?alt=media&token=585f68e4-bc57-4b5f-a55e-0e2f4e686809',
    //   'mindFunc': (context) {}
    // },
    // {
    //   'title': 'Sell Something',
    //   'image':
    //       'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Fsellsomething.svg?alt=media&token=d4de8d00-e075-4e6f-8f65-111616413dda',
    //   'mindFunc': () {}
    // },
    {
      'title': 'Create Poll',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Fpoll.svg?alt=media&token=9a0f6f31-3685-42ce-9a2b-f18a512d3829',
      'mindFunc': () {
        createPoll();
      }
    },
    // {
    //   'title': 'Upload Video',
    //   'image':
    //       'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Fvideo_camera.svg?alt=media&token=89343741-3bfc-4001-87d4-9344e752192d',
    //   'mindFunc': (context) {}
    // },
    {
      'title': 'Upload Audio',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Fmusic_file.svg?alt=media&token=b2d62e94-0c58-487e-b3dc-da02bdfd7ac9',
      'mindFunc': () {
        uploadAudioReady();
      }
    },
    // {
    //   'title': 'Upload File',
    //   'image':
    //       'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Ffolder.svg?alt=media&token=8a62d7d4-95dc-4f0b-8a62-3c9ef26aec81',
    //   'mindFunc': (context) {}
    // },
  ];

  List<Map> activityCase = [
    {
      'label': 'Feeling',
      'svg':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Ffeeling_post.svg?alt=media',
      'subLabel': 'How are you feeling?'
    },
    {
      'label': 'Listening To',
      'svg':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Fmusic_file.svg?alt=media',
      'subLabel': 'What are you listening to?',
    },
    {
      'label': 'Watching',
      'svg':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fmovies.svg?alt=media',
      'subLabel': 'What are you watching?',
    },
    {
      'label': 'Playing',
      'svg':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fgames.svg?alt=media',
      'subLabel': 'What are you playing?',
    },
    {
      'label': 'Eating',
      'svg':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fcookie.svg?alt=media',
      'subLabel': 'What are you eating?',
    },
    {
      'label': 'Drinking',
      'svg':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2FdayTimeMessage%2Fnight.svg?alt=media',
      'subLabel': 'What are you drinking?',
    },
    {
      'label': 'Traveling To',
      'svg':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fgeolocation.svg?alt=media',
      'subLabel': 'Where are you traveling to?',
    },
    {
      'label': 'Reading',
      'svg':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Farticle.svg?alt=media',
      'subLabel': 'What are you reading?',
    },
    {
      'label': 'Attending',
      'svg':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fsocial.svg?alt=media',
      'subLabel': 'What are you attending?',
    },
    {
      'label': 'Celebrating',
      'svg':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fgifts.svg?alt=media',
      'subLabel': 'What are you celebrating?',
    },
    {
      'label': 'Looking For',
      'svg':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fsearch.svg?alt=media',
      'subLabel': 'What are you looking for?',
    },
  ];

  List<Map> feelingAction = [
    {
      'label': 'Happy',
    },
    {
      'label': 'Loved',
    },
    {
      'label': 'Satisfied',
    },
    {
      'label': 'Strong',
    },
    {
      'label': 'Sad',
    },
    {
      'label': 'Crazy',
    },
    {
      'label': 'Tired',
    },
    {
      'label': 'Sleepy',
    },
    {
      'label': 'Confused',
    },
    {
      'label': 'Worried',
    },
    {
      'label': 'Angry',
    },
    {
      'label': 'Annoyed',
    },
    {
      'label': 'Shocked',
    },
    {
      'label': 'Down',
    },
    {
      'label': 'Confounded',
    },
  ];
  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    super.initState();
  }

  uploadPhotoReady() {
    nowPost = 'Upload Photos';
    setState(() {});
    uploadReady('photo');
  }

  uploadAudioReady() {
    nowPost = 'Upload Audio';
    setState(() {});
    uploadReady('audio');
  }

  feelingReady() {
    if (nowPost == 'Feelings/Activity') {
      nowPost = '';
    } else {
      nowPost = 'Feelings/Activity';
    }
    setState(() {});
  }

  checkIn() {
    if (nowPost == 'Check In') {
      nowPost = '';
    } else {
      nowPost = 'Check In';
    }
    setState(() {});
  }

  createPoll() {
    if (nowPost == 'Create Poll') {
      nowPost = '';
    } else {
      nowPost = 'Create Poll';
      pollOption = ['', ''];
    }
    setState(() {});
  }

  post() async {
    // if (nowPost == '') {

    //   return;
    // }
    setState(() {});
    String postCase = 'normal';

    var postPayload;
    String header = _controller.text;
    switch (nowPost) {
      case 'Upload Photos':
        if (postPhoto.isEmpty) {
          Helper.showToast('Please upload photo');
          return;
        }
        postCase = 'photo';
        postPayload = postPhoto;
        break;
      case 'Feelings/Activity':
        if (activity == '' || subActivity == '') {
          Helper.showToast('Please fill all field');
          return;
        }
        postCase = 'feeling';
        postPayload = {
          'action': activity,
          'subAction': subActivity,
        };
        break;
      case 'Check In':
        if (checkLocation == '') {
          Helper.showToast('Please fill all field');
          return;
        }
        postCase = 'checkIn';
        postPayload = checkLocation;
        break;
      case 'Create Poll':
        List<String> optionValue = [];
        for (int i = 0; i < pollOption.length - 1; i++) {
          optionValue.add(pollOption[i]);
          if (pollOption[i] == '') {
            Helper.showToast('Please fill all field');
            return;
          }
        }
        if (pollQuestion == '') {
          Helper.showToast('Please insert question');
          return;
        }
        postCase = 'poll';
        postPayload = {
          'option': optionValue,
          'optionUp': {},
        };
        header = pollQuestion;
        break;
      case 'Upload Audio':
        postCase = 'audio';
        postPayload = postAudio;
        break;
      default:
        postCase = 'normal';
        postPayload = null;
    }
    postLoading = true;

    await con
        .savePost(postCase, postPayload, dropdownValue, header: header)
        .then((value) {
      print('after');
      postLoading = false;
      nowPost = '';
      postPhoto = [];
      postAudio = '';
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig(context).screenWidth > SizeConfig.smallScreenSize
          ? 530
          : 350,
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 250, 250, 250),
              borderRadius: BorderRadius.circular(2),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(255, 230, 230, 230),
                  blurRadius: 0.1,
                  spreadRadius: 0.1,
                  offset: Offset(
                    -1,
                    1,
                  ),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 35,
                  height: 35,
                  child: UserManager.userInfo['avatar'] != ''
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(
                          UserManager.userInfo['avatar'],
                        ))
                      : CircleAvatar(
                          child: SvgPicture.network(Helper.avatar),
                        ),
                ),
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10, right: 4),
                  child: TextField(
                    controller: _controller,
                    // cursorColor: Colors.white,
                    focusNode: _focus,
                    style: const TextStyle(color: Color.fromARGB(255, 3, 3, 3)),
                    decoration: const InputDecoration(
                      hoverColor: Color.fromARGB(255, 250, 250, 250),
                      filled: true,
                      fillColor: Color.fromARGB(255, 250, 250, 250),
                      hintText:
                          'What is on your mind? #Hashtag.. @Mention.. Link..',
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 17.0, color: Colors.grey),
                    ),
                  ),
                )),
                InkWell(
                    onTap: () {
                      //checkOption(label);
                      setState(() {
                        emojiShowing = !emojiShowing;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 40),
                      child: const Icon(Icons.emoji_emotions_outlined),
                    )),
              ],
            ),
          ),
          Offstage(
            offstage: !emojiShowing,
            child: SizedBox(
                height: 250,
                child: EmojiPicker(
                  textEditingController: _controller,
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
          const Padding(padding: EdgeInsets.only(top: 15)),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: postPhoto
                              .map(((e) => postPhotoWidget(e['url'], e['id'])))
                              .toList(),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      child: nowPost != 'Upload Audio'
                          ? const SizedBox()
                          : Container(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  (uploadAudioProgress != 0 &&
                                          uploadAudioProgress != 100)
                                      ? Container(
                                          width: 90,
                                          height: 90,
                                          margin: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(13),
                                          ),
                                          child: Stack(
                                            children: [
                                              AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                margin: const EdgeInsets.only(
                                                    top: 78, left: 10),
                                                width: 130,
                                                padding: EdgeInsets.only(
                                                    right: 130 -
                                                        (130 *
                                                            uploadAudioProgress /
                                                            100)),
                                                child:
                                                    const LinearProgressIndicator(
                                                  color: Colors.blue,
                                                  value: 10,
                                                  semanticsLabel:
                                                      'Linear progress indicator',
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : postAudio == ''
                                          ? const SizedBox()
                                          : Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                // crossAxisAlignment:
                                                //     CrossAxisAlignment.start,
                                                children: [
                                                  SvgPicture.network(
                                                    'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2FuploadChecked.svg?alt=media&token=4877f3f2-4de4-4e53-9e0e-1054cf2eb5dd',
                                                    width: 20,
                                                  ),
                                                  const Text(
                                                    'Audio uploaded successfully',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                        Icons.close,
                                                        color: Colors.black,
                                                        size: 13.0),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20),
                                                    tooltip: 'Delete',
                                                    onPressed: () {
                                                      postAudio = '';
                                                      nowPost = '';
                                                      setState(() {});
                                                    },
                                                  ),
                                                ],
                                              ),
                                            )
                                ],
                              ),
                            ),
                    ),
                    nowPost == 'Feelings/Activity'
                        ? feelingActivityWidget()
                        : nowPost == 'Check In'
                            ? checkInWidget()
                            : nowPost == 'Create Poll'
                                ? createPollWidget()
                                : const SizedBox(),
                    const Padding(padding: EdgeInsets.only(top: 5)),
                    nowPost == ''
                        ? const SizedBox()
                        : const Divider(
                            thickness: 0.1,
                            color: Colors.black45,
                            height: 1,
                          ),
                  ],
                ),
              ),
              GridView.count(
                crossAxisCount:
                    SizeConfig(context).screenWidth > SizeConfig.smallScreenSize
                        ? 2
                        : 1,
                childAspectRatio:
                    SizeConfig(context).screenWidth > SizeConfig.smallScreenSize
                        ? 240 / 45
                        : 240 / 39,
                padding: const EdgeInsets.all(4.0),
                mainAxisSpacing: 4.0,
                shrinkWrap: true,
                crossAxisSpacing: 4.0,
                children: mindPostCase
                    .map(
                      (mind) => MindSlice(
                        mindFunc: mind['mindFunc'],
                        label: mind['title'],
                        image: mind['image'],
                        disabled: nowPost == ''
                            ? false
                            : nowPost == mind['title']
                                ? false
                                : true,
                      ),
                    )
                    .toList(),
              ),
              Row(
                children: [
                  const Flexible(fit: FlexFit.tight, child: SizedBox()),
                  Expanded(
                    child: SizedBox(
                      width: 100,
                      height: 38,
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 17, 205, 239),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                                color: const Color.fromARGB(255, 17, 205, 239),
                                width:
                                    0.1), //bordrder raiuds of dropdown button
                          ),
                          child: Padding(
                              padding: const EdgeInsets.only(top: 7, left: 15),
                              child: DropdownButton(
                                value: dropdownValue,
                                // hint: Container(
                                //   child: Row(
                                //     children: [
                                //       Icon(
                                //         dropdownValue == 'Public'
                                //             ? Icons.language
                                //             : dropdownValue == 'Friends'
                                //                 ? Icons.groups
                                //                 : Icons.lock_outline,
                                //         color: Colors.white,
                                //       ),
                                //       const Padding(
                                //           padding: EdgeInsets.only(left: 5)),
                                //       Text(
                                //         dropdownValue,
                                //         style: const TextStyle(
                                //           fontSize: 13,
                                //           color: Colors.white,
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                items: [
                                  DropdownMenuItem(
                                    value: "Public",
                                    child: Row(children: const [
                                      Icon(
                                        Icons.language,
                                        color: Colors.black,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 5)),
                                      Text(
                                        "Public",
                                        style: TextStyle(fontSize: 13),
                                      )
                                    ]),
                                  ),
                                  DropdownMenuItem(
                                    value: "Friends",
                                    child: Row(children: const [
                                      Icon(
                                        Icons.groups,
                                        color: Colors.black,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 5)),
                                      Text(
                                        "Friends",
                                        style: TextStyle(fontSize: 13),
                                      )
                                    ]),
                                  ),
                                  DropdownMenuItem(
                                    value: "Only Me",
                                    child: Row(children: const [
                                      Icon(
                                        Icons.lock_outline,
                                        color: Colors.black,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 5)),
                                      Text(
                                        "Only Me",
                                        style: TextStyle(fontSize: 13),
                                      )
                                    ]),
                                  ),
                                ],
                                onChanged: (String? value) {
                                  //get value when changed
                                  dropdownValue = value!;
                                  setState(() {});
                                },
                                icon: const Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Icon(Icons.arrow_drop_down)),
                                iconEnabledColor: Colors.white, //Icon color
                                style: const TextStyle(
                                  color: Colors.black, //Font color
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                                dropdownColor: Colors.white,
                                underline: Container(), //remove underline
                                isExpanded: true,
                                isDense: true,
                              ))),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                      minimumSize: const Size(85, 45),
                      maximumSize: const Size(85, 45),
                    ),
                    onPressed: () {
                      postLoading ? () {} : post();
                    },
                    child: postLoading
                        ? Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(
                              backgroundColor: Colors.transparent,
                            ),
                          )
                        : const Text('Post',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w900)),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget postPhotoWidget(photo, id) {
    return Container(
      width: 90,
      height: 90,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
      ),
      child: Stack(
        children: [
          photo != null
              ? Container(
                  width: 90,
                  height: 90,
                  alignment: Alignment.topRight,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(photo),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close,
                        color: Colors.black, size: 13.0),
                    padding: EdgeInsets.only(left: 20),
                    tooltip: 'Delete',
                    onPressed: () {
                      postPhoto.removeWhere((item) => item['id'] == id);
                      if (postPhoto.isEmpty) {
                        nowPost = '';
                      }
                      setState(() {});
                    },
                  ),
                )
              : const SizedBox(),
          // : const SizedBox(),
          (uploadPhotoProgress != 0 && uploadPhotoProgress != 100)
              ? AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  margin: const EdgeInsets.only(top: 78, left: 10),
                  width: 130,
                  padding: EdgeInsets.only(
                      right: 130 - (130 * uploadPhotoProgress / 100)),
                  child: const LinearProgressIndicator(
                    color: Colors.blue,
                    value: 10,
                    semanticsLabel: 'Linear progress indicator',
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget feelingActivityWidget() {
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(right: 20),
              child: PopupMenuButton(
                onSelected: (value) {
                  print(activity);
                  activity = value['label'].toString();
                  subActivity = '';
                  subActivityLabel = value['subLabel'].toString();
                  setState(() {});
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 238, 238, 238),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 30)),
                      Text(
                        activity == '' ? 'What are you doing?' : activity,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 111, 111, 111),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                itemBuilder: (BuildContext bc) {
                  return activityCase
                      .map(
                        (e) => PopupMenuItem(
                          value: {
                            'label': e['label'],
                            'svg': e['svg'],
                            'subLabel': e['subLabel'],
                          },
                          child: Row(
                            children: [
                              const Padding(
                                  padding: EdgeInsets.only(left: 12.0)),
                              SvgPicture.network(
                                e['svg'],
                                width: 30,
                              ),
                              const Padding(
                                  padding: EdgeInsets.only(left: 12.0)),
                              Text(
                                e['label'],
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 90, 90, 90),
                                    fontFamily: 'var(--body-font-family)',
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15),
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
          activity == ''
              ? const SizedBox()
              : Expanded(
                  flex: (subActivity != '' && activity == 'Feeling') ? 1 : 2,
                  child: activity == 'Feeling'
                      ? Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(right: 20),
                          child: PopupMenuButton(
                            onSelected: (value) {
                              subActivity = value.toString();
                              setState(() {});
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 92, 114, 228),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                      padding: EdgeInsets.only(left: 30)),
                                  Text(
                                    subActivity == ''
                                        ? 'How are you feeling?'
                                        : subActivity,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            itemBuilder: (BuildContext bc) {
                              return feelingAction
                                  .map(
                                    (e) => PopupMenuItem(
                                      value: e['label'],
                                      child: Row(
                                        children: [
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 12.0)),
                                          SvgPicture.network(
                                            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Fsellsomething.svg?alt=media&token=d4de8d00-e075-4e6f-8f65-111616413dda',
                                            width: 30,
                                          ),
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 12.0)),
                                          Text(
                                            e['label'],
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 90, 90, 90),
                                                fontFamily:
                                                    'var(--body-font-family)',
                                                fontWeight: FontWeight.w900,
                                                fontSize: 15),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList();
                            },
                          ),
                        )
                      : Container(
                          height: 40,
                          child: TextField(
                            onChanged: (value) {
                              subActivity = value;
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              hintText: subActivityLabel,
                              hintStyle: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                              contentPadding:
                                  const EdgeInsets.only(top: 10, left: 10),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                            ),
                          ),
                        ),
                ),
          (subActivity != '' && activity == 'Feeling')
              ? const Expanded(flex: 1, child: SizedBox())
              : const SizedBox()
        ],
      ),
    );
  }

  Widget checkInWidget() {
    return postInput(
      'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Fcheckin.svg?alt=media&token=6f228dbc-b1a4-4d13-860b-18b686602738',
      'Where are you?',
      (value) {
        checkLocation = value;
        setState(() {});
      },
    );
  }

  Widget createPollWidget() {
    return Column(
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 30,
                height: 30,
                child: UserManager.userInfo['avatar'] != ''
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(
                        UserManager.userInfo['avatar'],
                      ))
                    : CircleAvatar(
                        child: SvgPicture.network(Helper.avatar),
                      ),
              ),
              Expanded(
                  child: Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10, right: 4),
                child: TextField(
                  onChanged: (value) {
                    pollQuestion = value;
                    setState(() {});
                  },
                  style: const TextStyle(color: Color.fromARGB(255, 3, 3, 3)),
                  decoration: const InputDecoration(
                    hoverColor: Color.fromARGB(255, 250, 250, 250),
                    filled: true,
                    fillColor: Color.fromARGB(255, 250, 250, 250),
                    hintText: 'Ask something...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 17.0, color: Colors.grey),
                  ),
                ),
              )),
              Container(
                padding: const EdgeInsets.only(top: 40),
                child: const Icon(Icons.emoji_emotions_outlined),
              )
            ],
          ),
        ),
        for (int i = 0; i < pollOption.length; i++)
          postInput(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fplus.svg?alt=media&token=236c24bb-6caa-4ffa-9c08-de3748a6b6c4',
            'Add an option...',
            (value) {
              pollOption[i] = value;
              if (pollOption[pollOption.length - 1] != '') {
                pollOption.add('');
              }
              setState(() {});
            },
          )
      ],
    );
  }

  Widget postInput(url, place, onChange) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.only(top: 2)),
        Container(
          height: 40,
          child: TextField(
            onChanged: onChange,
            decoration: InputDecoration(
              prefixIcon: Container(
                  margin: const EdgeInsets.only(left: 10),
                  width: 40,
                  alignment: Alignment.centerLeft,
                  child: SvgPicture.network(
                    url,
                    width: 30,
                    height: 30,
                  )),
              hintText: place,
              hintStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              contentPadding: const EdgeInsets.only(top: 10, left: 10),
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
          ),
        )
      ],
    );
  }

  Future<XFile> chooseImage() async {
    final _imagePicker = ImagePicker();
    XFile? pickedFile;
    if (foundation.kIsWeb) {
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

  Future<XFile> chooseAudio() async {
    //final _audioPicker = ImagePicker();
    XFile pickedFile;
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      if (foundation.kIsWeb) {
        foundation.Uint8List? uploadfile = result.files.single.bytes;
        if (uploadfile != null) {
          pickedFile = XFile.fromData(uploadfile);
        } else {
          pickedFile = XFile('');
        }
      } else {
        pickedFile = result as XFile;
      }
    } else {
      print("cancel upload -0-----------------");
      pickedFile = XFile('');
    }
    return pickedFile;
  }

  uploadFile(XFile? pickedFile, type) async {
    if (type == 'photo') {
      postPhoto.add({'id': postPhoto.length, 'url': ''});
      photoLength = postPhoto.length - 1;
      setState(() {});
    }
    final _firebaseStorage = FirebaseStorage.instance;
    var uploadTask;
    Reference _reference;
    try {
      if (foundation.kIsWeb) {
        //print("read bytes");
        foundation.Uint8List bytes = await pickedFile!.readAsBytes();
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
          for (var i = 0; i < postPhoto.length; i++) {
            if (postPhoto[i]['id'] == photoLength) {
              postPhoto[i]['url'] = downloadUrl;
              setState(() {});
            }
          }
        } else {
          postAudio = downloadUrl;
          setState(() {});
        }
        print(postAudio);
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
              uploadAudioProgress = 100.0 *
                  (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
              setState(() {});
              print("Upload is $uploadAudioProgress% complete.");
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
            uploadAudioProgress = 0;
            uploadPhotoProgress = 0;
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

  uploadReady(type) async {
    XFile? pickedFile;
    if (type == 'photo') {
      pickedFile = await chooseImage();
    } else {
      pickedFile = await chooseAudio();
    }
    if (type != 'photo' && pickedFile.path == '') return;
    uploadFile(pickedFile, type);
  }
}
