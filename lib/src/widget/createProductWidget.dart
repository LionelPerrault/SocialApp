import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'dart:io' show File;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as PPath;

class CreateProductModal extends StatefulWidget {
  BuildContext context;
  late PostController Postcon;
  CreateProductModal(
      {Key? key, required this.context, required this.routerChange})
      : Postcon = PostController(),
        super(key: key);
  Function routerChange;
  @override
  State createState() => CreateProductModalState();
}

class CreateProductModalState extends mvc.StateMVC<CreateProductModal> {
  bool isSound = false;
  late PostController Postcon;
  Map<String, dynamic> productInfo = {
    'productStatus': 'New',
    'productOffer': 'Sell',
    'productAbout': '',
    'productPhoto': [],
    'productFile': []
  };
  var category = 'Choose Category';
  double uploadPhotoProgress = 0;
  List<dynamic> productPhoto = [];
  List<dynamic> productFile = [];
  double uploadFileProgress = 0;
  var photoLength;
  var fileLength;
  bool offer1 = true;
  bool offer2 = false;
  late List productCategory = [
    {
      'value': 'Choose Category',
      'title': 'Choose Category',
    },
    {
      'value': 'Apparel & Accessories',
      'title': 'Apparel & Accessories',
    },
    {
      'value': 'Autos & Vehicles',
      'title': 'Autos & Vehicles',
    },
    {
      'value': 'Baby & Children\'s',
      'title': 'Baby & Children\'s',
    },
    {
      'value': 'Beauty Products & Services',
      'title': 'Beauty Products & Services',
    },
    {
      'value': 'Computers & Peripherals',
      'title': 'Computers & Peripherals',
    },
    {
      'value': 'Consumer Electronics',
      'title': 'Consumer Electronics',
    },
    {
      'value': 'Dating Services',
      'title': 'Dating Services',
    },
    {
      'value': 'Financial Services',
      'title': 'Financial Services',
    },
    {
      'value': 'Gifts & Occasions',
      'title': 'Gifts & Occasions',
    },
    {
      'value': 'Home & Garden',
      'title': 'Home & Garden',
    },
    {
      'value': 'Other',
      'title': 'Other',
    },
  ];
  bool footerBtnState = false;
  @override
  void initState() {
    add(widget.Postcon);
    Postcon = controller as PostController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                flex: 285,
                child: Container(
                  width: 285,
                  child: customInput(
                    title: 'Product Name',
                    onChange: (value) async {
                      productInfo['productName'] = value;
                      setState(() {});
                    },
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: 15)),
              Expanded(
                flex: 100,
                child: Container(
                  width: 100,
                  child: customInput(
                    title: 'Price',
                    onChange: (value) async {
                      productInfo['productPrice'] = value;
                      setState(() {});
                    },
                  ),
                ),
              ),
            ],
          ),
          SizeConfig(context).screenWidth > SizeConfig.smallScreenSize
              ? Row(
                  children: [
                    Expanded(
                      flex: 200,
                      child: Container(
                        width: 200,
                        child: customDropDownButton(
                          title: 'Category',
                          width: 200.0,
                          item: productCategory,
                          onChange: (value) {
                            productInfo['productCategory'] = value;
                            setState(() {});
                          },
                          context: context,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 100,
                      child: Container(
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(padding: EdgeInsets.only(top: 20)),
                            Row(
                              children: const [
                                Text(
                                  'Offer',
                                  style: TextStyle(
                                      color: Color.fromRGBO(82, 95, 127, 1),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
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
                                          fillColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.black),
                                          checkColor: Colors.blue,
                                          activeColor: const Color.fromRGBO(
                                              0, 123, 255, 1),
                                          value: offer1,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0))),
                                          onChanged: (value) {
                                            print(value);
                                            offer1 = value!;
                                            offer2 = !offer1;
                                            productInfo['productOffer'] =
                                                'Sell';
                                            setState(() {});
                                          },
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
                                          fillColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.black),
                                          checkColor: Colors.blue,
                                          activeColor: const Color.fromRGBO(
                                              0, 123, 255, 1),
                                          value: offer2,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0))),
                                          onChanged: (value) {
                                            offer2 = value!;
                                            offer1 = !offer2;
                                            productInfo['productOffer'] =
                                                'Rent';
                                            setState(() {});
                                          },
                                        )),
                                    Text('Rent')
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 100,
                      child: Container(
                        width: 100,
                        child: customDropDownButton(
                          title: 'Status',
                          width: 100.0,
                          item: [
                            {'value': 'New', 'title': 'New'},
                            {'value': 'Used', 'title': 'Used'}
                          ],
                          onChange: (value) {
                            productInfo['productStatus'] = value;
                            setState(() {});
                          },
                          context: context,
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            width: 400,
                            child: customDropDownButton(
                              title: 'Category',
                              width: 400.0,
                              item: productCategory,
                              onChange: (value) {
                                productInfo['productCategory'] = value;
                                setState(() {});
                              },
                              context: context,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            width: 400,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                    padding: EdgeInsets.only(top: 20)),
                                const Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    'Offer',
                                    style: TextStyle(
                                        color: Color.fromRGBO(82, 95, 127, 1),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Container(
                                    width: 85,
                                    child: Row(
                                      children: [
                                        Transform.scale(
                                            scale: 0.7,
                                            child: Checkbox(
                                              fillColor: MaterialStateProperty
                                                  .all<Color>(Colors.black),
                                              checkColor: Colors.blue,
                                              activeColor: const Color.fromRGBO(
                                                  0, 123, 255, 1),
                                              value: offer1,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5.0))),
                                              onChanged: (value) {
                                                print(value);
                                                offer1 = value!;
                                                offer2 = !offer1;
                                                productInfo['productOffer'] =
                                                    'Sell';
                                                setState(() {});
                                              },
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
                                              fillColor: MaterialStateProperty
                                                  .all<Color>(Colors.black),
                                              checkColor: Colors.blue,
                                              activeColor: const Color.fromRGBO(
                                                  0, 123, 255, 1),
                                              value: offer2,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5.0))),
                                              onChanged: (value) {
                                                offer2 = value!;
                                                offer1 = !offer2;
                                                productInfo['productOffer'] =
                                                    'Rent';
                                                setState(() {});
                                              },
                                            )),
                                        Text('Rent')
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            width: 400,
                            child: customDropDownButton(
                              title: 'Status',
                              width: 400.0,
                              item: [
                                {'value': 'New', 'title': 'New'},
                                {'value': 'Used', 'title': 'Used'}
                              ],
                              onChange: (value) {
                                productInfo['productStatus'] = value;
                                setState(() {});
                              },
                              context: context,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
          Row(
            children: [
              Expanded(
                child: Container(
                  width: 400,
                  child: customInput(
                    title: 'Location',
                    onChange: (value) async {
                      productInfo['productLocation'] = value;
                      setState(() {});
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  width: 400,
                  child: titleAndsubtitleInput(
                    'About',
                    70,
                    5,
                    (value) async {
                      productInfo['productAbout'] = value;
                      setState(() {});
                    },
                  ),
                ),
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
                            color: Color.fromRGBO(82, 95, 127, 1),
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
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
                            color: Color.fromRGBO(82, 95, 127, 1),
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
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
                    footerBtnState = true;
                    setState(() {});
                    Postcon.createProduct(context, productInfo).then(
                      (value) => {
                        footerBtnState = false,
                        setState(() {}),
                        Navigator.of(context).pop(true),
                        Helper.showToast(value['msg']),
                        if (value['result'] == true)
                          {
                            widget.routerChange({
                              'router': RouteNames.products,
                              'subRouter': value['value'],
                            }),
                            print('product page : ${RouteNames.products}')
                          }
                      },
                    );
                  },
                  child: footerBtnState
                      ? const SizedBox(
                          width: 10,
                          height: 10.0,
                          child: CircularProgressIndicator(
                            color: Colors.grey,
                          ),
                        )
                      : const Text('Publish',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
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
}

Widget customInput({title, onChange, controller}) {
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
        child: TextField(
          controller: controller,
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

Widget titleAndsubtitleInput(title, double height, line, onChange) {
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
                  maxLines: line,
                  minLines: line,
                  onChanged: (value) {
                    onChange(value);
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
    {title, double width = 0.0, item = const [], onChange, context}) {
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
          value: items[0]['value'],
          items: items
              .map((e) =>
                  DropdownMenuItem(value: e['value'], child: Text(e['title'])))
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
