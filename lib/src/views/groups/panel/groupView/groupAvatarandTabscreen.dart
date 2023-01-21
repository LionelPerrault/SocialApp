import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as PPath;
import 'dart:io' show File;

import 'package:shnatter/src/widget/alertYesNoWidget.dart';

class GroupAvatarandTabScreen extends StatefulWidget {
  Function onClick;
  GroupAvatarandTabScreen({Key? key, required this.onClick})
      : con = PostController(),
        super(key: key);
  final PostController con;
  @override
  State createState() => GroupAvatarandTabScreenState();
}

class GroupAvatarandTabScreenState extends mvc.StateMVC<GroupAvatarandTabScreen>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  double width = 0;
  double itemWidth = 0;
  var tap = 'Timeline';
  var userInfo = UserManager.userInfo;
  double avatarProgress = 0;
  double coverProgress = 0;
  List<Map> mainTabList = [
    {'title': 'Timeline', 'icon': Icons.tab},
    {'title': 'Photos', 'icon': Icons.photo},
    {'title': 'Videos', 'icon': Icons.video_call},
    {'title': 'Members', 'icon': Icons.groups},
  ];
  var interestedStatus = false;
  var joinStatus = false;
  var selectedGroup = {};
  bool payLoading = false;

  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as PostController;
    _gotoHome();
    if (userInfo['uid'] == con.group['groupAdmin'][0]['uid']) {
      mainTabList.add({'title': 'Settings', 'icon': Icons.settings});
    }
  }

  groupJoinFunc() async {
    print(con.group['groupAdmin'][0]['uid']);
    var groupAdminInfo = await ProfileController()
        .getUserInfo(con.group['groupAdmin'][0]['uid']);
    print(groupAdminInfo);
    if (groupAdminInfo!['paywall']['joinMyGroup'] == null ||
        groupAdminInfo['paywall']['joinMyGroup'] == '0' ||
        con.group['groupAdmin'][0]['uid'] == UserManager.userInfo['uid']) {
      joinStatus = true;
      setState(() {});
      await con.joinedGroup(con.viewGroupId).then((value) {
        con.getSelectedGroup(con.viewGroupName);
      });
      joinStatus = false;
      setState(() {});
    } else {
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
                        groupAdminInfo['paymail'].toString(),
                        groupAdminInfo['paywall']['joinMyGroup'],
                        'Pay for join or unjoin group')
                    .then(
                      (value) async => {
                        if (value)
                          {
                            payLoading = false,
                            setState(() {}),
                            Navigator.of(context).pop(true),
                            joinStatus = true,
                            setState(() {}),
                            await con.joinedGroup(con.viewGroupId).then(
                              (value) {
                                con.getSelectedGroup(con.viewGroupName);
                              },
                            ),
                            joinStatus = false,
                            setState(() {}),
                          }
                      },
                    );
              },
              noFunc: () {
                Navigator.of(context).pop(true);
              },
              header: 'Pay token for join or unjoin this page',
              text:
                  'Admin of this group set price is ${groupAdminInfo['paywall']['joinMyGroup']} for join or unjoin this page',
              progress: payLoading),
        ),
      );
    }
  }

  late PostController con;
  void _gotoHome() {
    Future.delayed(Duration.zero, () {
      width = SizeConfig(context).screenWidth - 260;
      itemWidth = 100;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 30, right: 30),
          width: SizeConfig(context).screenWidth > SizeConfig.mediumScreenSize
              ? SizeConfig(context).screenWidth - SizeConfig.leftBarAdminWidth
              : SizeConfig(context).screenWidth,
          height: SizeConfig(context).screenHeight * 0.5,
          decoration: con.group['groupCover'] == ''
              ? const BoxDecoration(
                  color: Color.fromRGBO(66, 66, 66, 1),
                )
              : const BoxDecoration(),
          child: con.group['groupCover'] == ''
              ? Container()
              : Image.network(con.group['groupCover'], fit: BoxFit.cover),
        ),
        Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(left: 50, top: 30),
            child: GestureDetector(
              onTap: () {
                uploadImage('cover');
              },
              child: const Icon(
                Icons.photo_camera,
                size: 25,
              ),
            )),
        Container(
          width: SizeConfig(context).screenWidth > SizeConfig.mediumScreenSize
              ? SizeConfig(context).screenWidth - SizeConfig.leftBarAdminWidth
              : SizeConfig(context).screenWidth - 20,
          margin: const EdgeInsets.only(top: 200),
          child: SizeConfig(context).screenWidth < SizeConfig.mediumScreenSize
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      userAvatarWidget(),
                      Container(
                        child: mainTabWidget(),
                      )
                    ])
              : Row(children: [
                  Container(
                    padding: const EdgeInsets.only(left: 30),
                    child: userAvatarWidget(),
                  ),
                  Container(
                      width: SizeConfig(context).screenWidth -
                          SizeConfig.leftBarAdminWidth -
                          186,
                      padding: const EdgeInsets.only(left: 40, top: 40),
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

  Widget userAvatarWidget() {
    return Stack(
      children: [
        con.group['groupPicture'] != ''
            ? CircleAvatar(
                radius: 78,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                    radius: 75,
                    backgroundImage: NetworkImage(con.group['groupPicture'])),
              )
            : CircleAvatar(
                radius: 78,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                    radius: 75,
                    backgroundImage: NetworkImage(Helper.groupImage)),
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
        Container(
          margin: const EdgeInsets.only(left: 20),
          child: Row(children: [
            Row(
              children: [
                Text(
                  '${con.group['groupName']}',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: SizeConfig(context).screenWidth < 800
                          ? const Color.fromRGBO(51, 51, 51, 1)
                          : Colors.white),
                ),
                const Padding(padding: EdgeInsets.only(left: 6)),
                Icon(
                  con.group['groupPrivacy'] == 'public'
                      ? Icons.language
                      : con.group['groupPrivacy'] == 'security'
                          ? Icons.lock
                          : Icons.lock_open_rounded,
                  color: Colors.white,
                )
              ],
            ),
            const Flexible(fit: FlexFit.tight, child: SizedBox()),
            Row(
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 45, 205, 137),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0)),
                        minimumSize: const Size(120, 45),
                        maximumSize: const Size(120, 45)),
                    onPressed: () {
                      groupJoinFunc();
                    },
                    child: joinStatus
                        ? Container(
                            width: 10,
                            height: 10,
                            child: const CircularProgressIndicator(
                              color: Colors.grey,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              con.viewGroupJoined
                                  ? const Icon(
                                      Icons.edit_calendar,
                                      color: Colors.white,
                                      size: 18.0,
                                    )
                                  : const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 18.0,
                                    ),
                              const Text('Join',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold)),
                            ],
                          )),
              ],
            )
          ]),
        ),
        SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Container(
              width:
                  SizeConfig(context).screenWidth > SizeConfig.mediumScreenSize
                      ? SizeConfig(context).screenWidth -
                          SizeConfig.leftBarAdminWidth -
                          250
                      : SizeConfig(context).screenWidth - 20,
              margin: const EdgeInsets.only(top: 10, left: 20),
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: mainTabList
                      .map((e) => Expanded(
                              child: MouseRegion(
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
                                                color: Color.fromRGBO(
                                                    76, 76, 76, 1),
                                              ),
                                              const Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 5)),
                                              Text(
                                                  SizeConfig(context)
                                                              .screenWidth >
                                                          SizeConfig
                                                                  .mediumScreenSize +
                                                              200
                                                      ? e['title']
                                                      : SizeConfig(context)
                                                                  .screenWidth >
                                                              SizeConfig
                                                                  .mediumScreenSize
                                                          ? ''
                                                          : SizeConfig(context)
                                                                      .screenWidth >
                                                                  600
                                                              ? e['title']
                                                              : '',
                                                  style:
                                                      const TextStyle(
                                                          fontSize: 13,
                                                          color: Color.fromRGBO(
                                                              76, 76, 76, 1),
                                                          fontWeight:
                                                              FontWeight.bold))
                                            ]),
                                        e['title'] == con.groupTab
                                            ? Container(
                                                margin: const EdgeInsets.only(
                                                    top: 23),
                                                height: 2,
                                                color: Colors.grey,
                                              )
                                            : Container()
                                      ],
                                    ))),
                          )))
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
      await Permission.photos.request();

      var permissionStatus = await Permission.photos.status;

      if (permissionStatus.isGranted) {
      } else {
        print('Permission not granted. Try Again with permission access');
      }
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
        if (type == 'cover') {
          await con
              .updateGroupInfo({'groupCover': downloadUrl}).then((value) => {
                    con
                        .getSelectedGroup(con.viewGroupName)
                        .then((value) => {setState((() {}))})
                  });
        } else {
          await con
              .updateGroupInfo({'groupPicture': downloadUrl}).then((value) => {
                    con
                        .getSelectedGroup(con.viewGroupName)
                        .then((value) => {setState((() {}))})
                  });
        }
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
