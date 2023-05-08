// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as PPath;
import 'dart:io' show File;

import 'package:shnatter/src/widget/alertYesNoWidget.dart';

class EventAvatarandTabScreen extends StatefulWidget {
  Function onClick;
  EventAvatarandTabScreen({Key? key, required this.onClick})
      : con = PostController(),
        super(key: key);
  final PostController con;
  @override
  State createState() => EventAvatarandTabScreenState();
}

class EventAvatarandTabScreenState extends mvc.StateMVC<EventAvatarandTabScreen>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  double itemWidth = 0;
  var tap = 'Timeline';
  var userInfo = UserManager.userInfo;
  late String avatar;
  double avatarProgress = 0;
  double coverProgress = 0;
  List<Map> mainTabList = [
    {'title': 'Timeline', 'icon': Icons.tab},
    {'title': 'Photos', 'icon': Icons.photo},
    // {'title': 'Videos', 'icon': Icons.video_call},
    {'title': 'Members', 'icon': Icons.groups},
  ];
  var interestedStatus = false;
  var goingStatus = false;
  var selectedEvent = {};
  var date;
  bool payLoading = false;
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as PostController;
    _gotoHome();
    if (UserManager.userInfo['uid'] == con.event['eventAdmin'][0]['uid']) {
      mainTabList.add({'title': 'Settings', 'icon': Icons.settings});
    }
    date = con.event['eventStartDate'].split('-');
  }

  late PostController con;
  var userCon = UserController();
  void _gotoHome() {
    Future.delayed(Duration.zero, () {
      itemWidth = 100;
      setState(() {});
    });
  }

  eventInterestedFunc() async {
    var eventAdminInfo = await ProfileController()
        .getUserInfo(con.event['eventAdmin'][0]['uid']);
    if (eventAdminInfo!['paywall'][UserManager.userInfo['uid']] == null ||
        eventAdminInfo['paywall'][UserManager.userInfo['uid']] == '0' ||
        con.event['groupAdmin'][0]['uid'] == UserManager.userInfo['uid']) {
      interestedStatus = true;
      setState(() {});
      await con.interestedEvent(con.viewEventId).then((value) {
        con.getSelectedEvent(con.viewEventId).then((value) => {
              interestedStatus = false,
              setState(() {}),
            });
      });
      interestedStatus = false;
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
                        eventAdminInfo['paymail'].toString(),
                        eventAdminInfo['paywall'][UserManager.userInfo['uid']],
                        'Pay for interested event of user')
                    .then(
                      (value) async => {
                        if (value)
                          {
                            payLoading = false,
                            setState(() {}),
                            Navigator.of(context).pop(true),
                            interestedStatus = true,
                            setState(() {}),
                            await con.interestedEvent(con.viewEventId).then(
                              (value) {
                                con
                                    .getSelectedEvent(con.viewEventId)
                                    .then((value) => {
                                          interestedStatus = false,
                                          setState(() {}),
                                        });
                              },
                            ),
                            interestedStatus = false,
                            setState(() {}),
                          }
                      },
                    );
              },
              noFunc: () {
                Navigator.of(context).pop(true);
              },
              header: 'Pay token for paywall',
              text:
                  'Admin of this event set paywall price is ${eventAdminInfo['paywall'][UserManager.userInfo['uid']]}',
              progress: payLoading),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 0, right: 0),
          width: SizeConfig(context).screenWidth > SizeConfig.mediumScreenSize
              ? SizeConfig(context).screenWidth - SizeConfig.leftBarAdminWidth
              : SizeConfig(context).screenWidth,
          height: SizeConfig(context).screenHeight * 0.5,
          decoration: con.event['eventPicture'] == ''
              ? const BoxDecoration(
                  color: Color.fromRGBO(66, 66, 66, 1),
                )
              : const BoxDecoration(),
          child: con.event['eventPicture'] == ''
              ? Container()
              : Image.network(con.event['eventPicture'], fit: BoxFit.cover),
        ),
        con.event['eventAdmin'][0]['uid'] == UserManager.userInfo['uid']
            ? Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 50, top: 30),
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
                          uploadImage('profile_cover');
                        },
                        child: const Icon(Icons.camera_enhance_rounded,
                            color: Colors.black, size: 16.0),
                      )
                    : PopupMenuButton(
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
                            ]),
              )
            : Container(),
        Container(
            width: SizeConfig(context).screenWidth > SizeConfig.mediumScreenSize
                ? SizeConfig(context).screenWidth - SizeConfig.leftBarAdminWidth
                : SizeConfig(context).screenWidth - 20,
            margin: const EdgeInsets.only(top: 200),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                child: mainTabWidget(),
              )
            ])),
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

  Widget mainTabWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 45, left: 40),
          child: Row(children: [
            Container(
                width: 57,
                height: 75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      date[1],
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      date[2],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ],
                )),
            const Padding(
              padding: EdgeInsets.only(left: 10),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${con.event['eventName']}',
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      // color: SizeConfig(context).screenWidth < 800
                      //     ? const Color.fromRGBO(51, 51, 51, 1)
                      //     : Colors.white),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 6)),
                    Icon(
                      con.event['eventPrivacy'] == 'public'
                          ? Icons.language
                          : con.event['eventPrivacy'] == 'security'
                              ? Icons.lock
                              : Icons.lock_open_rounded,
                      color: Colors.white,
                    )
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.punch_clock,
                      color: Colors.white,
                    ),
                    Text(
                      '${con.event['eventStartDate']} to',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      '${con.event['eventEndDate']}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                )
              ],
            ),
            const Flexible(fit: FlexFit.tight, child: SizedBox()),
            if (SizeConfig(context).screenWidth > 600)
              Row(
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 45, 205, 137),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.0)),
                          minimumSize: const Size(120, 45),
                          maximumSize: const Size(120, 45)),
                      onPressed: () {
                        goingStatus = true;
                        setState(() {});
                        con.goingEvent(con.viewEventId).then((value) => {
                              con
                                  .getSelectedEvent(con.viewEventId)
                                  .then((value) => {
                                        goingStatus = false,
                                        setState(() {}),
                                      }),
                            });
                      },
                      child: goingStatus
                          ? const SizedBox(
                              width: 10,
                              height: 10,
                              child: CircularProgressIndicator(
                                color: Colors.grey,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                !con.viewEventGoing
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
                                const Text('Going',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold)),
                              ],
                            )),
                  const Padding(padding: EdgeInsets.only(left: 5)),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.0)),
                          minimumSize: const Size(120, 45),
                          maximumSize: const Size(120, 45)),
                      onPressed: () {
                        eventInterestedFunc();
                      },
                      child: interestedStatus
                          ? const SizedBox(
                              width: 10,
                              height: 10,
                              child: CircularProgressIndicator(
                                color: Colors.grey,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                !con.viewEventInterested
                                    ? const Icon(
                                        Icons.star,
                                        color: Colors.black,
                                        size: 18.0,
                                      )
                                    : const Icon(
                                        Icons.check,
                                        color: Colors.black,
                                        size: 18.0,
                                      ),
                                const Text('Interested',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold)),
                              ],
                            )),
                  const Padding(padding: EdgeInsets.only(left: 30))
                ],
              )
          ]),
        ),
        if (SizeConfig(context).screenWidth < 600)
          const SizedBox(
            height: 10,
          ),
        if (SizeConfig(context).screenWidth < 600)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 45, 205, 137),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0)),
                      minimumSize: const Size(120, 45),
                      maximumSize: const Size(120, 45)),
                  onPressed: () {
                    goingStatus = true;
                    setState(() {});
                    con.goingEvent(con.viewEventId).then((value) => {
                          con
                              .getSelectedEvent(con.viewEventId)
                              .then((value) => {
                                    goingStatus = false,
                                    setState(() {}),
                                  }),
                        });
                  },
                  child: goingStatus
                      ? const SizedBox(
                          width: 10,
                          height: 10,
                          child: CircularProgressIndicator(
                            color: Colors.grey,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            con.viewEventGoing
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
                            const Text('Going',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold)),
                          ],
                        )),
              const Padding(padding: EdgeInsets.only(left: 5)),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0)),
                      minimumSize: const Size(120, 45),
                      maximumSize: const Size(120, 45)),
                  onPressed: () {
                    eventInterestedFunc();
                  },
                  child: interestedStatus
                      ? const SizedBox(
                          width: 10,
                          height: 10,
                          child: CircularProgressIndicator(
                            color: Colors.grey,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            con.viewEventInterested
                                ? const Icon(
                                    Icons.star,
                                    color: Colors.black,
                                    size: 18.0,
                                  )
                                : const Icon(
                                    Icons.check,
                                    color: Colors.black,
                                    size: 18.0,
                                  ),
                            const Text('Interested',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold)),
                          ],
                        )),
              const Padding(padding: EdgeInsets.only(left: 5))
            ],
          ),
        SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Container(
              width:
                  SizeConfig(context).screenWidth > SizeConfig.mediumScreenSize
                      ? SizeConfig(context).screenWidth -
                          SizeConfig.leftBarAdminWidth -
                          60
                      : SizeConfig(context).screenWidth - 40,
              margin: const EdgeInsets.only(top: 10, left: 20),
              height: 80,
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
                                                color: const Color.fromRGBO(
                                                    76, 76, 76, 1),
                                              ),
                                              const Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 5)),
                                              Text(
                                                  SizeConfig(context)
                                                              .screenWidth >
                                                          SizeConfig
                                                              .mediumScreenSize
                                                      ? e['title']
                                                      : '',
                                                  style: const TextStyle(
                                                      fontSize: 13,
                                                      color: Color.fromRGBO(
                                                          76, 76, 76, 1),
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ]),
                                        e['title'] == con.eventTab
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
        var downloadUrl = await reference.getDownloadURL();
        if (type == 'profile_cover') {
          con.updateEventInfo({
            'eventPicture': downloadUrl,
          }).then(
            (value) => {
              con
                  .getSelectedEvent(con.viewEventId)
                  .then((value) => {setState(() {})}),
              Helper.showToast(value),
            },
          );
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

  Future<void> _onMenuItemSelected(int value, type) async {
    XFile? pickedFile = await chooseImage(value);

    uploadFile(pickedFile, type);
  }
}
