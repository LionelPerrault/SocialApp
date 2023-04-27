import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as PPath;
import 'dart:io' show File;

import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/widget/alertYesNoWidget.dart';

class PageAvatarandTabScreen extends StatefulWidget {
  Function onClick;
  PageAvatarandTabScreen({Key? key, required this.onClick})
      : con = PostController(),
        super(key: key);
  final PostController con;
  @override
  State createState() => PageAvatarandTabScreenState();
}

class PageAvatarandTabScreenState extends mvc.StateMVC<PageAvatarandTabScreen>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  double width = 0;
  double itemWidth = 0;
  var tap = 'Timeline';
  var pageInfo;
  late String avatar;
  late String cover;
  double avatarProgress = 0;
  double coverProgress = 0;
  List<Map> mainTabList = [
    {'title': 'Timeline', 'icon': Icons.tab},
    // {'title': 'Friends', 'icon': Icons.group_sharp},
    {'title': 'Photos', 'icon': Icons.photo},
    {'title': 'Videos', 'icon': Icons.video_call},
    {'title': 'Invite Friends', 'icon': Icons.person_add_alt_rounded},
    {'title': 'Settings', 'icon': Icons.settings},
  ];
  bool payLoading = false;
  bool likeStatus = false;

  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as PostController;
    var pageInfo = con.page;
    avatar = con.page['pagePicture'];
    cover = con.page['pageCover'];
    _gotoHome();
  }

  pageLikeFunc() async {
    var pageAdminInfo =
        await ProfileController().getUserInfo(con.page['pageAdmin'][0]['uid']);

    if (pageAdminInfo!['paywall']['likeMyPage'] == null ||
        pageAdminInfo['paywall']['likeMyPage'] == '0' ||
        con.page['pageAdmin'][0]['uid'] == UserManager.userInfo['uid']) {
      likeStatus = true;
      setState(() {});
      await con.likedPage(con.viewPageId).then((value) {
        con.getSelectedPage(con.viewPageName);
      });
      likeStatus = false;
      setState(() {});
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const SizedBox(),
          content: AlertYesNoWidget(
              yesFunc: () async {
                payLoading = true;
                setState(() {});
                await UserController()
                    .payShnToken(
                        pageAdminInfo['paymail'].toString(),
                        pageAdminInfo['paywall']['likeMyPage'],
                        'Pay for view profile of user')
                    .then(
                      (value) async => {
                        if (value)
                          {
                            payLoading = false,
                            setState(() {}),
                            Navigator.of(context).pop(true),
                            likeStatus = true,
                            setState(() {}),
                            await con.likedPage(con.viewPageId).then((value) {
                              con.getSelectedPage(con.viewPageName);
                            }),
                            likeStatus = false,
                            setState(() {}),
                          }
                      },
                    );
              },
              noFunc: () {
                Navigator.of(context).pop(true);
              },
              header: 'Pay token for like or unlike this page',
              text:
                  'Admin of this page set price is ${pageAdminInfo['paywall']['likeMyPage']} for like or unlike this page',
              progress: payLoading),
        ),
      );
    }
  }

  late PostController con;
  var userCon = UserController();
  void _gotoHome() {
    Future.delayed(Duration.zero, () {
      width = SizeConfig(context).screenWidth - 260;
      itemWidth = 120;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 30, right: 30),
          width: SizeConfig(context).screenWidth,
          height: SizeConfig(context).screenHeight * 0.5,
          decoration: con.page['pageCover'] == ''
              ? const BoxDecoration(
                  color: Color.fromRGBO(66, 66, 66, 1),
                )
              : const BoxDecoration(),
          child: con.page['pageCover'] == ''
              ? Container()
              : Image.network(con.page['pageCover'], fit: BoxFit.cover),
        ),
        Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(left: 50, top: 30),
            child: GestureDetector(
              onTap: () {
                uploadImage('profile_cover');
              },
              child: const Icon(
                Icons.photo_camera,
                size: 25,
              ),
            )),
        Container(
          width: SizeConfig(context).screenWidth,
          padding: const EdgeInsets.only(left: 30, right: 30),
          margin: const EdgeInsets.only(top: 200),
          child: SizeConfig(context).screenWidth < 800
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      pageAvatarWidget(),
                      Container(
                        child: mainTabWidget(),
                      )
                    ])
              : Row(children: [
                  Container(
                    padding: const EdgeInsets.only(left: 30),
                    child: pageAvatarWidget(),
                  ),
                  Container(
                      width: SizeConfig(context).screenWidth - 246,
                      padding: const EdgeInsets.only(left: 50, top: 40),
                      child: mainTabWidget())
                ]),
        ),
        coverProgress == 0
            ? Container()
            : AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                margin: const EdgeInsets.only(left: 30, right: 30),
                width: SizeConfig(context).screenWidth - 60,
                padding: EdgeInsets.only(
                    right: (SizeConfig(context).screenWidth - 60) -
                        ((SizeConfig(context).screenWidth - 60) *
                            coverProgress /
                            100)),
                child: Container(
                  color: Colors.blue,
                  width: SizeConfig(context).screenWidth - 60,
                  height: 3,
                ),
              ),
      ],
    );
  }

  Widget pageAvatarWidget() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 78,
          backgroundColor: Colors.white,
          child: CircleAvatar(
              radius: 75,
              backgroundImage:
                  NetworkImage(avatar != '' ? avatar : Helper.pageAvatar)),
        ),
        (avatarProgress != 0 && avatarProgress != 100)
            ? AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                margin: const EdgeInsets.only(top: 78, left: 10),
                width: 130,
                padding:
                    EdgeInsets.only(right: 130 - (130 * avatarProgress / 100)),
                child: const LinearProgressIndicator(
                  color: Colors.blue,
                  value: 10,
                  semanticsLabel: 'Linear progress indicator',
                ),
              )
            : const SizedBox(),
        Container(
          width: 26,
          height: 26,
          margin: const EdgeInsets.only(top: 120, left: 108),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            color: Colors.grey[400],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(4),
              backgroundColor: Colors.grey[300],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13)),
              minimumSize: const Size(26, 26),
              maximumSize: const Size(26, 26),
            ),
            onPressed: () {
              uploadImage('avatar');
            },
            child: const Icon(Icons.camera_enhance_rounded,
                color: Colors.black, size: 16.0),
          ),
        ),
      ],
    );
  }

  Widget mainTabWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${con.page['pageName']}',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: SizeConfig(context).screenWidth < 800
                  ? const Color.fromRGBO(51, 51, 51, 1)
                  : Colors.white),
        ),
        SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: const EdgeInsets.only(top: 15),
              width:
                  SizeConfig(context).screenWidth > SizeConfig.mediumScreenSize
                      ? SizeConfig(context).screenWidth -
                          SizeConfig.leftBarAdminWidth
                      : null,
              height: 70,
              // padding: const EdgeInsets.only(right: 50),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: mainTabList
                      .map(
                        (e) => MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: InkWell(
                            onTap: () {
                              widget.onClick(e['title']);
                              setState(() {});
                            },
                            child: Container(
                              padding: const EdgeInsets.only(top: 30),
                              width: itemWidth,
                              child: Column(
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          e['icon'],
                                          size: 15,
                                          color: Color.fromRGBO(76, 76, 76, 1),
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.only(left: 5)),
                                        Text(e['title'],
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: Color.fromRGBO(
                                                    76, 76, 76, 1),
                                                fontWeight: FontWeight.bold))
                                      ]),
                                  e['title'] == con.pageTab
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(top: 23),
                                          height: 2,
                                          color: Colors.grey,
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList()),
            ))
      ],
    );
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
        if (type == 'avatar') {
          con.updatePageInfo({
            'pageUserName': con.page['pageUserName'],
            'pagePicture': downloadUrl
          });
        } else {
          con.updatePageInfo({
            'pageUserName': con.page['pageUserName'],
            'pageCover': downloadUrl
          });
          print(downloadUrl);
        }
        print(type);
      });
      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            if (type == 'avatar') {
              avatarProgress = 100.0 *
                  (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
              setState(() {});
              print("Upload is $avatarProgress% complete.");
            } else {
              coverProgress = 100.0 *
                  (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
              setState(() {});
              print("Upload is $coverProgress% complete.");
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
            coverProgress = 0;
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
