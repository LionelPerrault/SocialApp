// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/date_symbols.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'dart:io' show File;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as PPath;
import 'package:shnatter/src/widget/alertYesNoWidget.dart';

class SharePostModal extends StatefulWidget {
  BuildContext context;
  late PostController Postcon;
  SharePostModal({
    Key? key,
    required this.context,
    required this.routerChange,
    this.editData,
  })  : Postcon = PostController(),
        super(key: key);
  Function routerChange;
  var editData;
  @override
  State createState() => SharePostModalState();
}

class SharePostModalState extends mvc.StateMVC<SharePostModal> {
  bool isSound = false;
  late PostController Postcon;
  Color _color = Color.fromRGBO(0, 0, 0, 0.2);
  Color _color2 = Color.fromRGBO(0, 0, 0, 0.2);
  double _width = 1;
  double _width2 = 1;

  Map<String, dynamic> productInfo = {
    'productStatus': 'New',
    'productOffer': 'Sell',
    'productAbout': '',
    'productPhoto': [],
    'productFile': [],
  };
  GlobalKey key = GlobalKey();
  double uploadPhotoProgress = 0;
  List<dynamic> productPhoto = [];
  List<dynamic> productFile = [];
  double uploadFileProgress = 0;
  var photoLength;
  var fileLength;
  bool offer1 = true;
  bool offer2 = false;
  bool footerBtnState = false;
  bool payLoading = false;
  // bool loading = false;
  @override
  void initState() {
    add(widget.Postcon);
    Postcon = controller as PostController;
    if (widget.editData == null) {
      widget.editData = {
        'id': '',
        'data': {},
      };
    } else {
      productInfo = widget.editData['data'];
    }
    super.initState();
  }

  getTokenBudget() async {
    var adminSnap = await Helper.systemSnap.doc(Helper.adminConfig).get();
    var price = adminSnap.data()!['priceCreatingProduct'];
    var userSnap =
        await Helper.userCollection.doc(UserManager.userInfo['uid']).get();
    var paymail = userSnap.data()!['paymail'];
    setState(() {});
    print('price:$price');
    if (price == '0') {
      await Postcon.createProduct(context, productInfo).then(
        (value) => {
          footerBtnState = false,
          setState(() => {}),
          Navigator.of(context).pop(true),
          Helper.showToast(value['msg']),
          if (value['result'] == true)
            {
              widget.routerChange({
                'router': RouteNames.products,
                'subRouter': value['value'],
              }),
            }
        },
      );
      setState(() {});
    } else {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) => AlertDialog(
          title: const SizedBox(),
          content: AlertYesNoWidget(
              yesFunc: () async {
                payLoading = true;
                setState(() {});
                await UserController()
                    .payShnToken(paymail, price, 'Pay for creating product')
                    .then((value) async => {
                          if (value)
                            {
                              payLoading = false,
                              setState(() {}),
                              Navigator.of(dialogContext).pop(true),
                              // loading = true,
                              setState(() {}),
                              await Postcon.createProduct(context, productInfo)
                                  .then((value) {
                                footerBtnState = false;
                                setState(() => {});
                                Navigator.of(context).pop(true);
                                // loading = true;
                                setState(() {});
                                print('to create product page');
                                Helper.showToast(value['msg']);
                                if (value['result'] == true) {
                                  widget.routerChange({
                                    'router': RouteNames.products,
                                    'subRouter': value['value'],
                                  });
                                }
                              }),
                              setState(() {}),
                              // loading = false,
                              setState(() {}),
                            }
                        });
              },
              noFunc: () {
                Navigator.of(context).pop(true);
                footerBtnState = false;
                setState(() {});
              },
              header: 'Costs for creating page',
              text:
                  'By paying the fee of $price tokens, the product will be published.',
              progress: payLoading),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: SizeConfig(context).screenHeight - 300,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Divider(
                  height: 0,
                  indent: 0,
                  endIndent: 0,
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Share the post to',
                        style: TextStyle(
                            color: Color.fromRGBO(82, 95, 127, 1),
                            fontSize: 23,
                            fontWeight: FontWeight.w600),
                      ),
                    ]),
                const Padding(padding: EdgeInsets.only(top: 25)),
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          print("Container clicked");
                          setState(() {
                            _color = Color.fromRGBO(51, 103, 214, 0.65);
                            _color2 = Color.fromRGBO(0, 0, 0, 0.2);
                            _width = 2;
                            _width2 = 1;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            border: Border.all(color: _color, width: _width),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 100,
                                height: 70,
                                child: const Icon(Icons.camera_enhance_rounded,
                                    color: Colors.grey, size: 30.0),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Timeline',
                                    style: TextStyle(
                                        color: Color.fromRGBO(82, 95, 127, 1),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const Padding(padding: EdgeInsets.only(top: 15)),
                            ],
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(left: 15)),
                      GestureDetector(
                        onTap: () {
                          print("Container clicked");
                          setState(() {
                            _color2 = Color.fromRGBO(51, 103, 214, 0.65);
                            _color = Color.fromRGBO(0, 0, 0, 0.2);
                            _width2 = 2;
                            _width = 1;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            border: Border.all(color: _color2, width: _width2),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 100,
                                height: 70,
                                child: const Icon(Icons.camera_enhance_rounded,
                                    color: Colors.grey, size: 30.0),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Groups',
                                    style: TextStyle(
                                        color: Color.fromRGBO(82, 95, 127, 1),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const Padding(padding: EdgeInsets.only(top: 15)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: 400,
                        child: titleAndsubtitleInput('Message', 70, 5,
                            (value) async {
                          productInfo['productAbout'] = value;
                          setState(() {});
                        }, widget.editData['data']['productAbout'] ?? ''),
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
                const Divider(
                  thickness: 0.1,
                  color: Colors.black,
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
              ],
            ),
          ),
        ),
        Container(
          width: 400,
          margin: const EdgeInsets.only(right: 20, bottom: 10),
          child: Row(
            children: [
              const Flexible(fit: FlexFit.tight, child: SizedBox()),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shadowColor: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)),
                  minimumSize: Size(100, 50),
                ),
                onPressed: () {
                  post() async {
                    setState(() {});
                    String postCase = 'share';
                    var postPayload;
                    String header = '';

                    postPayload = {
                      // 'value': optionValue,
                      // 'optionUp': {},
                    };

                    // postLoading = true;
                    // await con
                    //     .savePost(postCase, postPayload, dropdownValue,
                    //         header: header)
                    //     .then((value) {
                    //   print('after');
                    //   postLoading = false;

                    setState(() {});
                  }
                },
                child: footerBtnState
                    ? const SizedBox(
                        width: 10,
                        height: 10.0,
                        child: CircularProgressIndicator(
                          color: Colors.grey,
                        ),
                      )
                    : const Text('Share',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget productFileWidget(file, id) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: Colors.grey),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Stack(
        children: [
          file != null
              ? Container(
                  alignment: Alignment.topRight,
                  child: Column(
                    children: [
                      Container(
                        child: IconButton(
                          icon: const Icon(Icons.close,
                              color: Colors.black, size: 13.0),
                          tooltip: 'Delete',
                          onPressed: () {
                            setState(() {
                              productFile
                                  .removeWhere((item) => item['id'] == id);
                            });
                          },
                        ),
                      ),
                      const Icon(
                        Icons.file_copy,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ],
                  ))
              : const SizedBox(),
          // : const SizedBox(),
          (uploadPhotoProgress != 0 &&
                  uploadPhotoProgress != 100 &&
                  file == null)
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

  Widget productPhotoWidget(photo, id) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
      ),
      child: Stack(
        children: [
          // (uploadPhotoProgress != 0 && uploadPhotoProgress != 100)
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
                      setState(() {
                        productPhoto.removeWhere((item) => item['id'] == id);
                      });
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
  }

  uploadImage(type) async {
    XFile? pickedFile = await chooseImage();
    uploadFile(pickedFile, type);
  }

  Widget customInput({title, onChange, value}) {
    print(value);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              color: Color.fromRGBO(82, 95, 127, 1),
              fontSize: 13,
              fontWeight: FontWeight.w600),
        ),
        const Padding(padding: EdgeInsets.only(top: 2)),
        Container(
          height: 40,
          child: TextFormField(
            initialValue: value,
            onChanged: (value) {
              onChange(value);
            },
            keyboardType:
                title == 'Price' ? TextInputType.number : TextInputType.text,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(top: 10, left: 10),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.0),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget titleAndsubtitleInput(title, double height, line, onChange, value) {
    TextEditingController controller = TextEditingController();
    controller.text = value;
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 85, 95, 127)),
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  width: 400,
                  height: height,
                  child: TextField(
                    controller: controller,
                    maxLines: line,
                    minLines: line,
                    onChanged: (value) {
                      //controller.text = controller.text + value;
                      //onChange(value);
                      //print(controller.text);
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(top: 10, left: 10),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget customDropDownButton(
      {title, double width = 0.0, item = const [], onChange, context, value}) {
    List items = item;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        title,
        style: TextStyle(
            color: Color.fromRGBO(82, 95, 127, 1),
            fontSize: 13,
            fontWeight: FontWeight.w600),
      ),
      Padding(padding: EdgeInsets.only(top: 2)),
      Container(
          height: 40,
          width: width,
          child: DropdownButtonFormField(
            value: value,
            items: items
                .map((e) => DropdownMenuItem(
                    value: e['value'], child: Text(e['title'])))
                .toList(),
            onChanged: onChange,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 10, left: 10),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue, width: 1.0),
              ),
            ),
            icon: const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Icon(Icons.arrow_drop_down)),
            iconEnabledColor: Colors.grey, //Icon color

            style: const TextStyle(
              color: Colors.grey, //Font color
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            dropdownColor: Colors.white,
            isExpanded: true,
            isDense: true,
          ))
    ]);
  }
}
