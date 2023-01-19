import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import '../../utils/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as PPath;
import 'dart:io' show File;

class ProfileAvatarandTabScreen extends StatefulWidget {
  Function onClick;
  ProfileAvatarandTabScreen({Key? key, required this.onClick})
      : con = ProfileController(),
        super(key: key);
  final ProfileController con;
  @override
  State createState() => ProfileAvatarandTabScreenState();
}

class ProfileAvatarandTabScreenState extends mvc
    .StateMVC<ProfileAvatarandTabScreen> with SingleTickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  double width = 0;
  double itemWidth = 0;
  var tap = 'Timeline';
  var userInfo = UserManager.userInfo;
  double avatarProgress = 0;
  double coverProgress = 0;
  String avatar = '';
  List<Map> mainTabList = [
    {'title': 'Timeline', 'icon': Icons.tab},
    {'title': 'Friends', 'icon': Icons.group_sharp},
    {'title': 'Photos', 'icon': Icons.photo},
    {'title': 'Videos', 'icon': Icons.video_call},
    {'title': 'Likes', 'icon': Icons.flag},
    {'title': 'Groups', 'icon': Icons.group_sharp},
    {'title': 'Events', 'icon': Icons.gif_box},
  ];
  bool setPaywallProgress = false;
  String paywallPrice = '';

  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as ProfileController;

    avatar = con.userData['avatar'];
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
          margin: const EdgeInsets.only(left: 30, right: 30),
          width: SizeConfig(context).screenWidth,
          height: SizeConfig(context).screenHeight * 0.5,
          decoration: con.profile_cover == ''
              ? const BoxDecoration(
                  color: Color.fromRGBO(66, 66, 66, 1),
                )
              : const BoxDecoration(),
          child: con.profile_cover == ''
              ? Container()
              : Image.network(con.profile_cover, fit: BoxFit.cover),
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
                      width: SizeConfig(context).screenWidth - 260,
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

  Widget userAvatarWidget() {
    return Stack(
      children: [
        avatar != ''
            ? CircleAvatar(
                radius: 78,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                    radius: 75, backgroundImage: NetworkImage(avatar)),
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
        Row(
          children: [
            Text(
              '${con.userData['firstName']} ${con.userData['lastName']}',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: SizeConfig(context).screenWidth < 800
                      ? const Color.fromRGBO(51, 51, 51, 1)
                      : Colors.white),
            ),
            const Flexible(fit: FlexFit.tight, child: SizedBox()),
            con.userData['userName'] == UserManager.userInfo['userName']
                ? const SizedBox()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 45, 205, 137),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0)),
                        minimumSize: const Size(90, 40),
                        maximumSize: const Size(90, 40)),
                    onPressed: () {
                      modalView();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.person_add,
                          size: 20,
                        ),
                        Text(
                          'Paywall',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
            PopupMenuButton(
              onSelected: (value) {
                // your logic
              },
              icon: const Icon(
                Icons.settings,
                size: 16,
                color: Colors.white,
              ),
              itemBuilder: (BuildContext bc) {
                return const [
                  PopupMenuItem(
                    value: 'block',
                    child: Text(
                      "Manage Blocking",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'privacy',
                    child: Text(
                      "Privacy Settings",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'turn_off',
                    child: Text(
                      "Turn Off Chat",
                      style: TextStyle(fontSize: 14),
                    ),
                  )
                ];
              },
            )
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
                                  e['title'] == con.tab
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

  Widget setPaywallWidget() {
    return Container(
      width: 400,
      height: 300,
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  height: 230,
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
                        margin: const EdgeInsets.only(top: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
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
    if (kIsWeb) {
      try {
        //print("read bytes");
        Uint8List bytes = await pickedFile!.readAsBytes();
        //print(bytes);
        Reference _reference = await _firebaseStorage
            .ref()
            .child('images/${PPath.basename(pickedFile.path)}');
        final uploadTask = _reference.putData(
          bytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );
        uploadTask.whenComplete(() async {
          var downloadUrl = await _reference.getDownloadURL();
          if (type == 'profile_cover') {
            FirebaseFirestore.instance
                .collection(Helper.userField)
                .doc(UserManager.userInfo['uid'])
                .update({'profile_cover': downloadUrl}).then((e) async {
              con.profile_cover = downloadUrl;
              await Helper.saveJSONPreference(Helper.userField,
                  {...userInfo, 'profile_cover': downloadUrl});
              setState(() {});
            });
          } else {
            userCon.userAvatar = downloadUrl;
            await userCon.changeAvatar();
            avatar = downloadUrl;
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
    } else {
      var file = File(pickedFile!.path);
      //write a code for android or ios
      Reference _reference = await _firebaseStorage
          .ref()
          .child('images/${PPath.basename(pickedFile.path)}');
      _reference.putFile(file).whenComplete(() async {
        print('value');
        var downloadUrl = await _reference.getDownloadURL();
        await _reference.getDownloadURL().then((value) {
          // userCon.userAvatar = value;
          // userCon.setState(() {});
          // print(value);
        });
      });
    }
  }

  uploadImage(type) async {
    XFile? pickedFile = await chooseImage();
    uploadFile(pickedFile, type);
  }
}
