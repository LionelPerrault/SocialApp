import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/widget/startedInput.dart';
import 'dart:io' show File;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as PPath;

class CreateProductModal extends StatefulWidget {
  BuildContext context;
  late PostController Postcon;
  CreateProductModal({Key? key, required this.context})
      : Postcon = PostController(),
        super(key: key);
  @override
  State createState() => CreateProductModalState();
}

class CreateProductModalState extends mvc.StateMVC<CreateProductModal> {
  bool isSound = false;
  late PostController Postcon;
  Map<String, dynamic> productInfo = {};
  var category = 'Choose Category';
  double uploadPhotoProgress = 0;
  List<dynamic> productPhoto = [];
  double uploadFileProgress = 0;
  var lateLength;
  late List productFile = [];
  late List productCategory = [
    'Choose Category',
    'Apparel & Accessories',
    'Autos & Vehicles',
    'Baby & Children\'s...',
    'Beauty Products & Services',
    'Computers & Peripherals',
    'Consumer Electronics',
    'Dating Services',
    'Financial Services',
    'Gifts & Occasions',
    'Home & Garden',
    'Other',
  ];
  @override
  void initState() {
    add(widget.Postcon);
    Postcon = controller as PostController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(productPhoto);
    return SingleChildScrollView(
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
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text(
                        'Product Name',
                        style: TextStyle(
                            color: Color.fromARGB(255, 82, 95, 127),
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    width: 285,
                    child: input(validator: (value) async {
                      print(value);
                    }, onchange: (value) async {
                      productInfo['eventName'] = value;
                      // setState(() {});
                    }),
                  )
                ],
              ),
              const Padding(padding: EdgeInsets.only(left: 15)),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text(
                        'Price',
                        style: TextStyle(
                            color: Color.fromARGB(255, 82, 95, 127),
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    width: 100,
                    child: input(validator: (value) async {
                      print(value);
                    }, onchange: (value) async {
                      productInfo['eventName'] = value;
                      // setState(() {});
                    }),
                  )
                ],
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: 15)),
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text(
                        'Product Name',
                        style: TextStyle(
                            color: Color.fromARGB(255, 82, 95, 127),
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    width: 200,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 250, 250, 250),
                        border: Border.all(color: Colors.grey)),
                    padding: const EdgeInsets.only(left: 20),
                    child: DropdownButton(
                      value: category,
                      items: productCategory
                          .map(((e) =>
                              DropdownMenuItem(value: e, child: Text(e))))
                          .toList(),
                      onChanged: (value) {
                        //get value when changed
                        setState(() {});
                      },
                      style: const TextStyle(
                          //te
                          color: Colors.black, //Font color
                          fontSize: 12 //font size on dropdown button
                          ),

                      dropdownColor: Colors.white,
                      underline: Container(), //remove underline
                      isExpanded: true,
                      isDense: true,
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(left: 15)),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text(
                        'Offer',
                        style: TextStyle(
                            color: Color.fromARGB(255, 82, 95, 127),
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                      width: 85,
                      child: Row(
                        children: [
                          Transform.scale(
                              scale: 0.7,
                              child: Checkbox(
                                fillColor: MaterialStateProperty.all<Color>(
                                    Colors.black),
                                checkColor: Colors.blue,
                                activeColor:
                                    const Color.fromRGBO(0, 123, 255, 1),
                                value: true,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0))),
                                onChanged: (value) {},
                              )),
                          Text('Sell')
                        ],
                      )),
                  Container(
                      width: 85,
                      child: Row(
                        children: [
                          Transform.scale(
                              scale: 0.7,
                              child: Checkbox(
                                fillColor: MaterialStateProperty.all<Color>(
                                    Colors.black),
                                checkColor: Colors.blue,
                                activeColor:
                                    const Color.fromRGBO(0, 123, 255, 1),
                                value: true,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0))),
                                onChanged: (value) {},
                              )),
                          Text('Rent')
                        ],
                      )),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text(
                        'Price',
                        style: TextStyle(
                            color: Color.fromARGB(255, 82, 95, 127),
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    width: 100,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 250, 250, 250),
                        border: Border.all(color: Colors.grey)),
                    padding: const EdgeInsets.only(left: 20),
                    child: DropdownButton(
                      value: 'New',
                      items: const [
                        DropdownMenuItem(value: 'New', child: Text('New')),
                        DropdownMenuItem(value: 'Used', child: Text('Used')),
                      ],
                      onChanged: (value) {
                        //get value when changed
                        setState(() {});
                      },
                      style: const TextStyle(
                          //te
                          color: Colors.black, //Font color
                          fontSize: 12 //font size on dropdown button
                          ),

                      dropdownColor: Colors.white,
                      underline: Container(), //remove underline
                      isExpanded: true,
                      isDense: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: 15)),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Text('Location',
                      style: TextStyle(
                          color: Color.fromARGB(255, 82, 95, 127),
                          fontSize: 11,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                width: 400,
                child: input(validator: (value) async {
                  print(value);
                }, onchange: (value) async {
                  productInfo['eventLocation'] = value;
                  // setState(() {});
                }),
              )
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: 15)),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('About',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 82, 95, 127),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold)),
                          Container(
                            width: 400,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 250, 250, 250),
                                border: Border.all(color: Colors.grey)),
                            child: TextFormField(
                              minLines: 1,
                              maxLines: 4,
                              onChanged: (value) async {
                                productInfo['eventAbout'] = value;
                                // setState(() {});
                              },
                              keyboardType: TextInputType.multiline,
                              style: const TextStyle(fontSize: 12),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: '',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text(
                        'Photos',
                        style: TextStyle(
                            color: Color.fromARGB(255, 82, 95, 127),
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 100,
                    height: 100,
                    // padding: const EdgeInsets.only(top: 45, left: 45),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(4),
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13)),
                        minimumSize: const Size(100, 100),
                        maximumSize: const Size(100, 100),
                      ),
                      onPressed: () {
                        uploadImage('photo');
                      },
                      child: const Icon(Icons.camera_enhance_rounded,
                          color: Colors.grey, size: 30.0),
                    ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      width: 100,
                      child: Column(
                        children: productPhoto
                            .map(((e) => productPhotoWidget(e['url'], e['id'])))
                            .toList(),
                      ))
                ],
              ),
              const Padding(padding: EdgeInsets.only(left: 15)),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text(
                        'Files',
                        style: TextStyle(
                            color: Color.fromARGB(255, 82, 95, 127),
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 100,
                    height: 100,
                    // padding: const EdgeInsets.only(top: 45, left: 45),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(4),
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13)),
                        minimumSize: const Size(100, 100),
                        maximumSize: const Size(100, 100),
                      ),
                      onPressed: () {
                        uploadImage('file');
                      },
                      child: const Icon(Icons.file_open,
                          color: Colors.grey, size: 30.0),
                    ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      width: 100,
                      child: Column(
                        children: productFile
                            .map(((e) => productFileWidget(e['url'], e['id'])))
                            .toList(),
                      ))
                ],
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: 15)),
          const Divider(
            thickness: 0.1,
            color: Colors.black,
          ),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Container(
            width: 400,
            margin: const EdgeInsets.only(right: 0),
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
                    Postcon.createEvent(context, productInfo);
                  },
                  child: const Text('Publish',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
        ],
      ),
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
    print(photo);
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
      productPhoto.add({'id': productPhoto.length});
      lateLength = '${productPhoto.length - 1}';
      setState(() {});
    } else {
      productFile.add({'id': productPhoto.length});
      lateLength = '${productPhoto.length - 1}';
      setState(() {});
    }
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
          if (type == 'photo') {
            for (var i = 0; i < productPhoto.length; i++) {
              if (productPhoto[i]['id'] == '${lateLength}') {
                productPhoto[i]['url'] = downloadUrl;
                setState(() {});
              }
            }
          } else {
            for (var i = 0; i < productFile.length; i++) {
              if (productFile[i]['id'] == '${lateLength}') {
                productFile[i]['url'] = downloadUrl;
                setState(() {});
              }
            }
          }
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
