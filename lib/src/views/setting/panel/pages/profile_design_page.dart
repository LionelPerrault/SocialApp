import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/utils/svg.dart';
import 'package:shnatter/src/views/box/daytimeM.dart';
import 'package:shnatter/src/views/box/mindpost.dart';
import 'package:shnatter/src/views/setting/widget/setting_footer.dart';
import 'package:shnatter/src/views/setting/widget/setting_header.dart';
import 'package:shnatter/src/widget/mindslice.dart';
import 'package:shnatter/src/widget/startedInput.dart';
import 'dart:io' show File, Platform;
import 'package:path/path.dart' as PPath;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;

class SettingDesignScreen extends StatefulWidget {
  SettingDesignScreen({Key? key}) : super(key: key);
  @override
  State createState() => SettingDesignScreenState();
}

// ignore: must_be_immutable
class SettingDesignScreenState extends State<SettingDesignScreen> {
  var setting_profile = {};
  double progress = 0;
  String profileImage = UserManager.userInfo['profileImage'] ?? '';
  @override
  Widget build(BuildContext context) {
    print(progress);
    return Container(
        padding: const EdgeInsets.only(top: 20, left: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SettingHeader(
              icon: Icon(
                Icons.brush,
                color: Color.fromARGB(255, 43, 83, 164),
              ),
              pagename: 'Design',
              // ignore: prefer_const_literals_to_create_immutables
              button: {
                'buttoncolor': Color.fromARGB(255, 17, 205, 239),
                'icon': Icon(Icons.person),
                'text': 'View Profile',
                'flag': true
              },
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Container(
                width:
                    SizeConfig(context).screenWidth > SizeConfig.smallScreenSize
                        ? SizeConfig(context).screenWidth * 0.5 + 40
                        : SizeConfig(context).screenWidth * 0.9 - 30,
                height: 80,
                padding: EdgeInsets.only(left: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Profile Background'),
                    Padding(padding: EdgeInsets.only(left: 15)),
                    Stack(
                      children: [
                        Container(
                          decoration: profileImage != ''
                              ? BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(profileImage),
                                    fit: BoxFit.cover,
                                  ),
                                  color: const Color.fromRGBO(240, 240, 240, 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3)))
                              : const BoxDecoration(
                                  color: Color.fromRGBO(240, 240, 240, 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3))),
                          width: 80,
                          height: 100,
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: InkWell(
                            onTap: () {
                              uploadImage();
                            },
                            child: Container(
                                margin:
                                    const EdgeInsets.only(top: 50, left: 50),
                                child: const Icon(
                                  Icons.photo_camera,
                                  size: 25,
                                  color: Colors.black87,
                                )),
                          ),
                        ),
                        progress != 0
                            ? Container(
                                margin:
                                    const EdgeInsets.only(left: 10, top: 38),
                                height: 4,
                                width: 60,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3))),
                                child: AnimatedContainer(
                                  color: Colors.blue,
                                  duration: const Duration(milliseconds: 500),
                                  margin: EdgeInsets.only(
                                      right: 60 - 60 * progress / 100),
                                ),
                              )
                            : Container()
                      ],
                    )
                  ],
                )),
            SettingFooter(
              onClick: () {},
            )
          ],
        ));
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

  uploadFile(XFile? pickedFile) async {
    final _firebaseStorage = FirebaseStorage.instance;
    if (kIsWeb) {
      try {
        //print("read bytes");
        Uint8List bytes = await pickedFile!.readAsBytes();
        //print(bytes);
        Reference _reference = await _firebaseStorage
            .ref()
            .child('images/${PPath.basename(pickedFile!.path)}');
        final uploadTask = _reference.putData(
          bytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );
        uploadTask.whenComplete(() async {
          var downloadUrl = await _reference.getDownloadURL();
          var snapshot = await FirebaseFirestore.instance
              .collection(Helper.userField)
              .where('userName', isEqualTo: UserManager.userInfo['userName'])
              .get();
          await FirebaseFirestore.instance
              .collection(Helper.userField)
              .doc(snapshot.docs[0].id)
              .update({'profileImage': downloadUrl});
          await Helper.saveJSONPreference(Helper.userField,
              {...UserManager.userInfo, 'profileImage': downloadUrl});
          await UserManager.getUserInfo();
          profileImage = downloadUrl;
          progress = 0;
          setState(() {});
          //await _reference.getDownloadURL().then((value) {
          //  uploadedPhotoUrl = value;
          //});
        });
        uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
          switch (taskSnapshot.state) {
            case TaskState.running:
              progress = 100.0 *
                  (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
              setState(() {});
              print("Upload is $progress% complete.");

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
          .child('images/${PPath.basename(pickedFile!.path)}');
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

  uploadImage() async {
    XFile? pickedFile = await chooseImage();
    uploadFile(pickedFile);
  }
}
