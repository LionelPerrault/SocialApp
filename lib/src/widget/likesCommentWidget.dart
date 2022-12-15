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
  double uploadPhotoProgress = 0;
  List<dynamic> productPhoto = [];
  List<dynamic> productFile = [];
  var userInfo = UserManager.userInfo;
  double uploadFileProgress = 0;
  var photoLength;
  var fileLength;
  bool offer1 = true;
  bool offer2 = false;
  bool isComment = false;
  var whatImage = '';
  var whoHover = '';
  late List likesImage = [
    {
      "image":
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2F970279.png?alt=media&token=7775f9c5-bfde-4bf1-a1a2-a9a3a1336c2c',
      "value": "like"
    },
    {
      "image":
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2F2043845.png?alt=media&token=de00e47a-2467-4d36-92d1-d0318098cf6c',
      "value": "love"
    },
    {
      'image':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fhaha.png?alt=media&token=22f42035-d150-45da-b16a-12bab942e3f9',
      'value': 'haha'
    },
    {
      'image':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fyay.png?alt=media&token=675a7f1f-a2b0-4321-bc5b-bce582c8afb5',
      'value': 'yay'
    },
    {
      'image':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fwow.png?alt=media&token=73b978ca-11bc-4d9d-8dda-79f776df6dbb',
      'value': 'wow'
    },
    {
      'image':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsad.png?alt=media&token=b3b9ee61-23df-498c-943e-fbca291e5e8b',
      'value': 'sad'
    },
    {
      'image':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fangry.png?alt=media&token=3b77d906-3d7d-4876-9d9f-15c1f7ff1b18',
      'value': 'angry'
    }
  ];
  @override
  void initState() {
    add(widget.Postcon);
    con = controller as PostController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          FontAwesomeIcons.comment,
                          size: 15,
                        ),
                        Padding(padding: EdgeInsets.only(left: 5)),
                        Text('0 comments')
                      ],
                    )),
                Container(
                  margin: EdgeInsets.only(top: 50),
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
                                  FontAwesomeIcons.thumbsUp,
                                  size: 15,
                                ),
                                Padding(padding: EdgeInsets.only(left: 5)),
                                Text(
                                  'Like',
                                  style: TextStyle(fontWeight: FontWeight.w700),
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
                            onTap: () {
                              isComment = true;
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
                    ? MouseRegion(
                        onEnter: (event) {
                          whoHover = 'like';
                          setState(() {});
                        },
                        onExit: (event) {
                          whoHover = '';
                          setState(() {});
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 6),
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
                                        width: SizeConfig(context).screenWidth >
                                                600
                                            ? (370 - 10) / 7
                                            : (SizeConfig(context).screenWidth *
                                                        3.7 /
                                                        6 -
                                                    10) /
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
                                              onTap: () {},
                                              child: AnimatedContainer(
                                                height: whatImage == e['value']
                                                    ? 50
                                                    : 40,
                                                duration: const Duration(
                                                    milliseconds: 200),
                                                child: Image.network(
                                                  e['image'],
                                                ),
                                              )),
                                        ),
                                      ))
                                  .toList()),
                        ))
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
                            radius: 15,
                            child: SvgPicture.network(
                              Helper.avatar,
                            ))
                        : CircleAvatar(
                            radius: 15,
                            backgroundImage: NetworkImage(
                              userInfo['avatar'],
                            )),
                    Container(
                        margin: const EdgeInsets.only(left: 20),
                        padding: const EdgeInsets.only(left: 15),
                        height: 30,
                        width: SizeConfig(context).screenWidth > 600
                            ? 500
                            : SizeConfig(context).screenWidth - 20,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromRGBO(220, 220, 220, 1),
                                width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: Row(
                          children: [
                            Container(
                              height: 30,
                              width: SizeConfig(context).screenWidth > 600
                                  ? 350
                                  : SizeConfig(context).screenWidth * 0.7,
                              child: TextField(
                                cursorWidth: 1,
                                onChanged: (value) {},
                                decoration: const InputDecoration(
                                    hintText: 'Write a comment',
                                    hintStyle: TextStyle(fontSize: 12),
                                    contentPadding: EdgeInsets.only(
                                        top: 0, left: 10, bottom: 22),
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none),
                              ),
                            ),
                            Flexible(fit: FlexFit.tight, child: SizedBox()),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: InkWell(
                                onTap: () {
                                  // con.hashCode
                                  con.saveComment(widget.productId);
                                  print(widget.productId);
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
                        ))
                  ],
                ),
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
    if (kIsWeb) {
      try {
        Uint8List bytes = await pickedFile!.readAsBytes();
        Reference _reference = await _firebaseStorage
            .ref()
            .child('images/${PPath.basename(pickedFile!.path)}');
        final uploadTask = _reference.putData(
          bytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );
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
