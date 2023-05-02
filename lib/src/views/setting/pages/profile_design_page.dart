// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/setting/widget/setting_header.dart';
import 'package:shnatter/src/widget/startedInput.dart';
import 'dart:io' show File, Platform;
import 'package:path/path.dart' as PPath;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;

class SettingDesignScreen extends StatefulWidget {
  SettingDesignScreen({Key? key, required this.routerChange}) : super(key: key);
  Function routerChange;
  @override
  State createState() => SettingDesignScreenState();
}

class SettingDesignScreenState extends State<SettingDesignScreen> {
  var setting_profile = {};
  double progress = 0;
  XFile? selectedImageFile;
  String profileImage = UserManager.userInfo['profileImage'] ?? '';
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 20, left: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SettingHeader(
              routerChange: widget.routerChange,
              icon: const Icon(
                Icons.brush,
                color: Color.fromARGB(255, 43, 83, 164),
              ),
              pagename: 'Design',
              // ignore: prefer_const_literals_to_create_immutables
              button: {
                'buttoncolor': const Color.fromARGB(255, 17, 205, 239),
                'icon': const Icon(Icons.person),
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
                padding: const EdgeInsets.only(left: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Profile Background'),
                    const Padding(padding: EdgeInsets.only(left: 15)),
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(3)))
                              : const BoxDecoration(
                                  color: Color.fromRGBO(240, 240, 240, 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3))),
                          width: 80,
                          height: 100,
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: kIsWeb
                              ? InkWell(
                                  onTap: () async {
                                    selectedImageFile = await chooseImage(0);
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 50, left: 50),
                                      child: const Icon(
                                        Icons.photo_camera,
                                        size: 25,
                                        color: Colors.black87,
                                      )),
                                )
                              : PopupMenuButton(
                                  onSelected: (value) async {
                                    selectedImageFile =
                                        await chooseImage(value);
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 50, left: 50),
                                      child: const Icon(
                                        Icons.photo_camera,
                                        size: 25,
                                        color: Colors.black87,
                                      )),
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
            footer()
          ],
        ));
  }

  Widget footer() {
    return Padding(
      padding: const EdgeInsets.only(right: 20, top: 20),
      child: Container(
          height: 65,
          decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(
              color: Color.fromARGB(255, 220, 226, 237),
              width: 1,
            )),
            color: Color.fromARGB(255, 240, 243, 246),
            // borderRadius: BorderRadius.all(Radius.circular(3)),
          ),
          padding: const EdgeInsets.only(top: 5, left: 15),
          child: Row(
            children: [
              const Flexible(fit: FlexFit.tight, child: SizedBox()),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(3),
                    backgroundColor: Colors.white,
                    // elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0)),
                    minimumSize: const Size(120, 50),
                    maximumSize: const Size(120, 50),
                  ),
                  onPressed: () {
                    uploadFile(selectedImageFile);
                  },
                  child: progress != 0
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator())
                      : const Text('Save Changes',
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
              const Padding(padding: EdgeInsets.only(right: 30))
            ],
          )),
    );
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

  uploadFile(XFile? pickedFile) async {
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
        setState(() {});
        profileImage = downloadUrl;
        progress = 0;
        setState(() {});
      });
      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            setState(() {});

            break;
          case TaskState.paused:
            break;
          case TaskState.canceled:
            break;
          case TaskState.error:
            // Handle unsuccessful uploads
            break;
          case TaskState.success:
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
}
