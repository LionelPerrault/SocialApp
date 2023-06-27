import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
import '../../controllers/PeopleController.dart';
import '../../utils/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shnatter/src/views/setting/settingsMain.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as PPath;
import 'dart:io' show File;

import 'model/friends.dart';

class ProfileAvatarandTabScreen extends StatefulWidget {
  Function onClick;
  ProfileAvatarandTabScreen(
      {Key? key, required this.onClick, required this.routerChange})
      : con = ProfileController(),
        super(key: key);
  final ProfileController con;
  Function routerChange;
  @override
  State createState() => ProfileAvatarandTabScreenState();
}

class ProfileAvatarandTabScreenState extends mvc
    .StateMVC<ProfileAvatarandTabScreen> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  double width = 0;
  double itemWidth = 0;
  var tap = 'Timeline';
  var userInfo = UserManager.userInfo;
  double avatarProgress = 0;
  double coverProgress = 0;

  List<Map> mainTabList = [
    {'title': 'Timeline', 'icon': Icons.timeline},
    {'title': 'Friends', 'icon': Icons.people},
    {'title': 'Photos', 'icon': Icons.photo},
    // {'title': 'Videos', 'icon': Icons.video_call},
    // {'title': 'Likes', 'icon': Icons.flag},
    {'title': 'Groups', 'icon': Icons.groups},
    {'title': 'Events', 'icon': Icons.event},
  ];
  bool setPaywallProgress = false;
  String paywallPrice = '';
  var settingMainScreen = SettingMainScreenState();
  Friends friendModel = Friends();
  String friendUserName = '';
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as ProfileController;
    con.addNotifyCallBack(this);
    friendModel
        .getFriends(ProfileController().viewProfileUserName)
        .then((value) {
      setState(() {});
    });

    _gotoHome();
  }

  late ProfileController con;
  var userCon = UserController();
  void _gotoHome() {
    Future.delayed(Duration.zero, () {
      width = SizeConfig(context).screenWidth - 260;
      itemWidth = 100;
      setState(() {});
    });
  }

  modalView() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const SizedBox(),
        content: setPaywallWidget(),
      ),
    );
  }

  setPaywallPrice() async {
    if (paywallPrice == '' || int.tryParse(paywallPrice) == null) {
      Helper.showToast('Please insert price correctly');
      return;
    } else {
      setPaywallProgress = true;
      setState(() {});
      await UserController().profileChange({
        'paywall': {
          ...UserManager.userInfo['paywall'],
          con.viewProfileUid: paywallPrice,
        }
      });
      Helper.showToast('Successfully saved');
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop(true);
      setPaywallProgress = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: SizeConfig(context).screenWidth,
          height: 300,
          decoration: con.profile_cover == ''
              ? const BoxDecoration(
                  color: Color.fromRGBO(66, 66, 66, 1),
                )
              : const BoxDecoration(),
          child: con.profile_cover == ''
              ? Container()
              : Image.network(con.profile_cover, fit: BoxFit.cover),
        ),
        if (UserManager.userInfo['userName'] == con.userData['userName'])
          kIsWeb
              ? Container(
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
                  ))
              : Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(left: 50, top: 30),
                  child: PopupMenuButton(
                      onSelected: (value) {
                        _onMenuItemSelected(value, 'profile_cover');
                      },
                      child: const Icon(Icons.camera_enhance_rounded,
                          color: Colors.black, size: 16.0),
                      itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 1,
                              child: Text(
                                'Camera',
                              ),
                            ),
                            const PopupMenuItem(
                              value: 2,
                              child: Text(
                                "Gallery",
                              ),
                            )
                          ])),
        Container(
          width: SizeConfig(context).screenWidth,
          padding: const EdgeInsets.only(left: 30),
          margin: const EdgeInsets.only(top: 200),
          child: SizeConfig(context).screenWidth < 1015
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
                    padding: const EdgeInsets.only(left: 20),
                    child: userAvatarWidget(),
                  ),
                  Container(
                      width: SizeConfig(context).screenWidth * 0.6,
                      padding: const EdgeInsets.only(left: 10, top: 40),
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
        con.userData['avatar'] != ''
            ? CircleAvatar(
                radius: 78,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                    radius: 75,
                    backgroundImage: NetworkImage(con.userData['avatar'])),
              )
            : CircleAvatar(
                radius: 78,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 75,
                  child: SvgPicture.network(
                    Helper.avatar,
                    width: 150,
                  ),
                ),
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
        con.userData['userName'] == UserManager.userInfo['userName']
            ? Container(
                width: 26,
                height: 26,
                margin: const EdgeInsets.only(top: 120, left: 108),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: Colors.grey[400],
                ),
                child: kIsWeb
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(4),
                          backgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13)),
                          minimumSize: const Size(26, 26),
                          maximumSize: const Size(26, 26),
                        ),
                        onPressed: () {
                          //firestore composite index added.
                          //firestore storage rule edited.
                          uploadImage('avatar');
                        },
                        child: const Icon(Icons.camera_enhance_rounded,
                            color: Colors.black, size: 16.0),
                      )
                    : PopupMenuButton(
                        onSelected: (value) {
                          _onMenuItemSelected(value, 'avatar');
                        },
                        child: const Icon(Icons.camera_enhance_rounded,
                            color: Colors.black, size: 16.0),
                        itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 1,
                                child: Text(
                                  'Camera',
                                ),
                              ),
                              const PopupMenuItem(
                                value: 2,
                                child: Text(
                                  "Gallery",
                                ),
                              )
                            ]),
              )
            : Container(),
      ],
    );
  }

  bool isMyFriend() {
    //profile selected is my friend?

    for (var item in friendModel.friends) {
      friendUserName = item['requester'].toString();
      if (friendUserName == UserManager.userInfo['userName']) {
        print("friend");
        return true;
      }
      if (item['receiver'] == UserManager.userInfo['userName']) {
        print("friend");
        return true;
      }
    }
    print("no friend");
    return false;
  }

  Widget mainTabWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${con.userData['firstName']} ${con.userData['lastName']}',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: SizeConfig(context).screenWidth < 1015
                      ? const Color.fromRGBO(51, 51, 51, 1)
                      : Colors.white),
            ),
            SizeConfig(context).screenWidth < 1015
                ? const Flexible(
                    fit: FlexFit.loose,
                    child: Padding(padding: EdgeInsets.only(right: 10)))
                : const Flexible(fit: FlexFit.tight, child: SizedBox()),
            con.userData['userName'] == UserManager.userInfo['userName']
                ? const SizedBox()
                : PopupMenuButton(
                    onSelected: (value) async {
                      switch (value) {
                        case 'paywall':
                          modalView();
                          break;
                        case 'addfriend':
                          await PeopleController()
                              .cancelFriend({"userName": friendUserName});
                          setState(() {});
                          break;
                        case 'cancelfriend':
                          await PeopleController().cancelFriend(con.userInfo);
                          setState(() {});
                          break;
                        default:
                      }
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(
                          Radius.circular(22),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.settings,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                    itemBuilder: (BuildContext bc) {
                      return [
                        // PopupMenuItem(
                        //   value: 'block',
                        //   child: Text(
                        //     "Manage Blocking",
                        //     style: TextStyle(fontSize: 14),
                        //   ),
                        // ),
                        // PopupMenuItem(
                        //   value: 'privacy',
                        //   child: Text(
                        //     "Privacy Settings",
                        //     style: TextStyle(fontSize: 14),
                        //   ),
                        // ),
                        const PopupMenuItem(
                          value: 'paywall',
                          child: Text(
                            "Paywall",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        if (isMyFriend())
                          const PopupMenuItem(
                            value: 'cancelfriend',
                            child: Text(
                              "Cancel Friend",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        if (!isMyFriend())
                          const PopupMenuItem(
                            value: 'addfriend',
                            child: Text(
                              "Add friend",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                      ];
                    },
                  ),
            con.userData['userName'] == UserManager.userInfo['userName']
                ? const SizedBox()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      elevation: 3,
                      shape: const CircleBorder(
                          side: BorderSide(width: 1, color: Colors.white)),
                      minimumSize: const Size(60, 50),
                    ),
                    onPressed: () => {
                      if (UserManager.userInfo['uid'] != con.viewProfileUid)
                        {
                          widget.routerChange({
                            'router': RouteNames.messages,
                            'subRouter': con.viewProfileUid.toString(),
                          }),
                        }
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
            con.userData['userName'] == UserManager.userInfo['userName']
                ? Container(
                    margin: EdgeInsets.only(
                        right: SizeConfig(context).screenWidth * 0.05),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        elevation: 3,
                        shape: const CircleBorder(
                            side: BorderSide(width: 1, color: Colors.white)),
                        minimumSize: const Size(60, 50),
                      ),
                      onPressed: () async => {
                        setState(() {}),
                        widget.routerChange({
                          'router': RouteNames.settings,
                          'subRouter': RouteNames.settings_profile_basic
                        }),
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: const EdgeInsets.only(top: 15),
              height: 70,
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
                              padding: const EdgeInsets.only(
                                top: 30,
                              ),
                              width: (SizeConfig(context).screenWidth <
                                      SizeConfig.smallScreenSize)
                                  ? 70
                                  : 115,
                              child: Column(
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          e['icon'],
                                          size: (SizeConfig(context)
                                                      .screenWidth <
                                                  SizeConfig.smallScreenSize)
                                              ? 25
                                              : 15,
                                          color: const Color.fromRGBO(
                                              76, 76, 76, 1),
                                        ),
                                        (SizeConfig(context).screenWidth < 750)
                                            ? Container()
                                            : const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5)),
                                        (SizeConfig(context).screenWidth <
                                                SizeConfig.smallScreenSize)
                                            ? Container()
                                            : Text(e['title'],
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Color.fromRGBO(
                                                        76, 76, 76, 1),
                                                    fontWeight:
                                                        FontWeight.bold))
                                      ]),
                                  e['title'] == con.tab
                                      ? Container(
                                          // margin:
                                          //     const EdgeInsets.only(top: 23),
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

  Widget setPaywallWidget() {
    return SizedBox(
      width: 400,
      height: 300,
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      Text(
                        'Set paywall for ${con.userData['firstName']} ${con.userData['lastName']}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      const Text(
                        'Enter the amount of tokens as the paywall value',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 400,
                                    height: 30,
                                    child: TextField(
                                      maxLines: 1,
                                      minLines: 1,
                                      onChanged: (value) {
                                        paywallPrice = value;
                                        setState(() {});
                                      },
                                      decoration: const InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(top: 10, left: 10),
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blue, width: 1.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: const EdgeInsets.only(top: 30),
                  child: Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 10)),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0)),
                            minimumSize: const Size(110, 40),
                            maximumSize: const Size(110, 40),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(padding: EdgeInsets.only(top: 17)),
                              Icon(
                                Icons.arrow_back,
                                color: Colors.grey,
                                size: 14.0,
                              ),
                              Padding(padding: EdgeInsets.only(left: 10)),
                              Text('Cancel',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(left: 10)),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0)),
                            minimumSize: const Size(110, 40),
                            maximumSize: const Size(110, 40),
                          ),
                          onPressed: () {
                            setPaywallPrice();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              setPaywallProgress
                                  ? const SizedBox(
                                      width: 10,
                                      height: 10.0,
                                      child: CircularProgressIndicator(
                                        color: Colors.grey,
                                      ),
                                    )
                                  : const SizedBox(),
                              const Padding(padding: EdgeInsets.only(top: 17)),
                              const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 14.0,
                              ),
                              const Padding(padding: EdgeInsets.only(left: 10)),
                              const Text('Confirm',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(left: 10))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onMenuItemSelected(int value, type) async {
    XFile? pickedFile = await chooseImage(value);

    uploadFile(pickedFile, type);
  }

  Future<XFile> chooseImage(int value) async {
    final imagePicker = ImagePicker();

    if (value == 1 && !kIsWeb) {
      XFile? pickedFile;
      if (kIsWeb) {
        pickedFile = await imagePicker.pickImage(
          source: ImageSource.camera,
        );
      } else {
        pickedFile = await imagePicker.pickImage(
          source: ImageSource.camera,
        );
      }
      return pickedFile!;
    } else {
      XFile? pickedFile;
      if (kIsWeb) {
        pickedFile = await imagePicker.pickImage(
          source: ImageSource.gallery,
        );
      } else {
        pickedFile = await imagePicker.pickImage(
          source: ImageSource.gallery,
        );
      }
      return pickedFile!;
    }
  }

  uploadFile(XFile? pickedFile, type) async {
    final firebaseStorage = FirebaseStorage.instance;
    UploadTask uploadTask;
    Reference reference;
    try {
      if (kIsWeb) {
        //print("read bytes");
        Uint8List bytes = await pickedFile!.readAsBytes();
        //print(bytes);
        reference = firebaseStorage
            .ref()
            .child('images/${PPath.basename(pickedFile.path)}');
        uploadTask = reference.putData(
          bytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      } else {
        var file = File(pickedFile!.path);
        //write a code for android or ios
        reference = firebaseStorage
            .ref()
            .child('images/${PPath.basename(pickedFile.path)}');
        uploadTask = reference.putFile(file);
      }

      uploadTask.whenComplete(() async {
        Map postPayload = {};

        var downloadUrl = await reference.getDownloadURL();
        var postPhoto = [];
        postPhoto.add({'id': 0, 'url': downloadUrl});
        postPayload['photo'] = postPhoto;

        await PostController().savePost(
          'photo', postPayload, 'Public',
          // header:
          //     '${UserManager.userInfo['fullName']} changed ${type == 'profile_cover' ? 'Profile Cover' : 'Avatar'}',
          // message: 'Profile photo added successfully!'
        );
        if (type == 'profile_cover') {
          FirebaseFirestore.instance
              .collection(Helper.userField)
              .doc(UserManager.userInfo['uid'])
              .update({'profile_cover': downloadUrl}).then((e) async {
            con.profile_cover = downloadUrl;
            await Helper.saveJSONPreference(
                Helper.userField, {...userInfo, 'profile_cover': downloadUrl});
            setState(() {});
          });
        } else {
          userCon.userAvatar = downloadUrl;
          await userCon.changeAvatar();
          con.userData['avatar'] = downloadUrl;
          setState(() {});
        }
      });
      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            if (type == 'avatar') {
              avatarProgress = 100.0 *
                  (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
              setState(() {});
            } else {
              coverProgress = 100.0 *
                  (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
              setState(() {});
            }

            break;
          case TaskState.paused:
            break;
          case TaskState.canceled:
            break;
          case TaskState.error:
            // Handle unsuccessful uploads
            break;
          case TaskState.success:
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
    XFile? pickedFile = await chooseImage(2);
    uploadFile(pickedFile, type);
  }
}
