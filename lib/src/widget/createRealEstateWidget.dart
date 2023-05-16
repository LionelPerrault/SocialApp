// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'dart:io' show File;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as PPath;
import 'package:shnatter/src/widget/alertYesNoWidget.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class CreateRealEstateModal extends StatefulWidget {
  BuildContext context;
  late PostController postCon;
  CreateRealEstateModal({
    Key? key,
    required this.context,
    required this.routerChange,
    this.editData,
  })  : postCon = PostController(),
        super(key: key);
  Function routerChange;
  // ignore: prefer_typing_uninitialized_variables
  var editData;
  @override
  State createState() => CreateRealEstateModalState();
}

class CreateRealEstateModalState extends mvc.StateMVC<CreateRealEstateModal> {
  bool isSound = false;
  late PostController postCon;
  Map<String, dynamic> realEstateInfo = {
    'realEstateStatus': 'New',
    'realEstateOffer': 'Sell',
    'realEstateAbout': '',
    'realEstateName': '',
    'realEstateLocation': '',
    'realEstatePrice': '',
    'realEstatePhoto': [],
    'realEstateFile': [],
  };
  double uploadPhotoProgress = 0;
  List<dynamic> realEstatePhoto = [];
  List<dynamic> realEstateFile = [];
  List<Suggestion> autoLocationList = [];
  TextEditingController locationTextController = TextEditingController();
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
    add(widget.postCon);
    postCon = controller as PostController;
    if (widget.editData == null) {
      widget.editData = {
        'id': '',
        'data': {},
      };
    } else {
      realEstateInfo = widget.editData['data'];
    }
    super.initState();
  }

  getTokenBudget() async {
    var adminSnap = await Helper.systemSnap.doc(Helper.adminConfig).get();
    var price = adminSnap.data()!['priceCreatingRealEstate'];
    var snapshot = await FirebaseFirestore.instance
        .collection(Helper.adminPanel)
        .doc(Helper.backPaymail)
        .get();
    var paymail = snapshot.data()!['address'];
    setState(() {});
    if (price == '0') {
      await postCon.createRealEstate(context, realEstateInfo).then(
            (value) => {
              footerBtnState = false,
              setState(() => {}),
              Helper.showToast(value['msg']),
              if (value['result'])
                {
                  Navigator.of(context).pop(true),
                  widget.routerChange({
                    'router': RouteNames.realEstate,
                    'subRouter': value['value'],
                  }),
                }
            },
          );
      setState(() {});
    } else {
      footerBtnState = false;
      setState(() {});
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) => AlertDialog(
          title: const SizedBox(),
          content: AlertYesNoWidget(
              yesFunc: () async {
                payLoading = true;
                setState(() {});
                await UserController()
                    .payShnToken(paymail, price, 'Pay for creating Real Estate')
                    .then((value) async => {
                          if (value)
                            {
                              payLoading = false,
                              footerBtnState = false,
                              setState(() {}),
                              Navigator.of(dialogContext).pop(true),
                              // loading = true,
                              setState(() {}),
                              await postCon
                                  .createRealEstate(context, realEstateInfo)
                                  .then((value) {
                                footerBtnState = false;
                                setState(() => {});
                                // loading = true;
                                setState(() {});
                                Helper.showToast(value['msg']);
                                if (value['result'] == true) {
                                  Navigator.of(context).pop(true);
                                  widget.routerChange({
                                    'router': RouteNames.realEstate,
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
                  'By paying the fee of $price tokens, the real estate will be published.',
              progress: payLoading),
        ),
      );
    }
  }

  Future<void> fetchSuggestions(
    String input,
  ) async {
    final sessionToken = const Uuid().v4();

    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input &types=address&language=en&key=${Helper.apiKey}&sessiontoken=$sessionToken';
    try {
      final response = await http.get(Uri.parse(request));

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['status'] == 'OK') {
          // compose suggestions in a list
          autoLocationList = result['predictions']
              .map<Suggestion>(
                  (p) => Suggestion(p['place_id'], p['description']))
              .toList();
          setState(() {});
        }
        if (result['status'] == 'ZERO_RESULTS') {
          autoLocationList = [];
          setState(() {});
        }
      } else {
        throw Exception('Failed to fetch suggestion');
      }
    } catch (e) {
      autoLocationList = [];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 60),
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
                children: [
                  Expanded(
                    flex: 285,
                    child: SizedBox(
                      width: 285,
                      child: customInput(
                        title: 'Real Estate Name',
                        onChange: (value) async {
                          realEstateInfo['realEstateName'] = value;
                        },
                        value: widget.editData['data']['realEstateName'] ?? '',
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 15)),
                  Expanded(
                    flex: 100,
                    child: SizedBox(
                      width: 100,
                      child: customInput(
                        title: 'Price',
                        onChange: (value) async {
                          realEstateInfo['realEstatePrice'] =
                              (int.tryParse(value) ?? 0).toString();
                          setState(() {});
                        },
                        value: widget.editData['data']['realEstatePrice'] ??
                            realEstateInfo['realEstatePrice'],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizeConfig(context).screenWidth > SizeConfig.smallScreenSize
                  ? Row(
                      children: [
                        Expanded(
                          flex: 100,
                          child: SizedBox(
                            width: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                    padding: EdgeInsets.only(top: 20)),
                                const Row(
                                  children: [
                                    Text(
                                      'Offer',
                                      style: TextStyle(
                                          color: Color.fromRGBO(82, 95, 127, 1),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                SizedBox(
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
                                                realEstateInfo[
                                                    'realEstateOffer'] = 'Sell';
                                                setState(() {});
                                              },
                                            )),
                                        const Text('Sell')
                                      ],
                                    )),
                                SizedBox(
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
                                                realEstateInfo[
                                                    'realEstateOffer'] = 'Rent';
                                                setState(() {});
                                              },
                                            )),
                                        const Text('Rent')
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 100,
                          child: SizedBox(
                            width: 100,
                            child: customDropDownButton(
                              title: 'Status',
                              width: 100.0,
                              item: [
                                {'value': 'New', 'title': 'New'},
                                {'value': 'Used', 'title': 'Used'}
                              ],
                              onChange: (value) {
                                realEstateInfo['realEstateStatus'] = value;
                                setState(() {});
                              },
                              value: widget.editData['data']
                                      ['realEstateStatus'] ??
                                  'New',
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
                              child: SizedBox(
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
                                            color:
                                                Color.fromRGBO(82, 95, 127, 1),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    SizedBox(
                                        width: 85,
                                        child: Row(
                                          children: [
                                            Transform.scale(
                                                scale: 0.7,
                                                child: Checkbox(
                                                  fillColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.black),
                                                  checkColor: Colors.blue,
                                                  activeColor:
                                                      const Color.fromRGBO(
                                                          0, 123, 255, 1),
                                                  value: offer1,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5.0))),
                                                  onChanged: (value) {
                                                    print(value);
                                                    offer1 = value!;
                                                    offer2 = !offer1;
                                                    realEstateInfo[
                                                            'realEstateOffer'] =
                                                        'Sell';
                                                    setState(() {});
                                                  },
                                                )),
                                            const Text('Sell')
                                          ],
                                        )),
                                    SizedBox(
                                        width: 85,
                                        child: Row(
                                          children: [
                                            Transform.scale(
                                                scale: 0.7,
                                                child: Checkbox(
                                                  fillColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.black),
                                                  checkColor: Colors.blue,
                                                  activeColor:
                                                      const Color.fromRGBO(
                                                          0, 123, 255, 1),
                                                  value: offer2,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5.0))),
                                                  onChanged: (value) {
                                                    offer2 = value!;
                                                    offer1 = !offer2;
                                                    realEstateInfo[
                                                            'realEstateOffer'] =
                                                        'Rent';
                                                    setState(() {});
                                                  },
                                                )),
                                            const Text('Rent')
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
                              child: SizedBox(
                                width: 400,
                                child: customDropDownButton(
                                  title: 'Status',
                                  width: 400.0,
                                  item: [
                                    {'value': 'New', 'title': 'New'},
                                    {'value': 'Used', 'title': 'Used'}
                                  ],
                                  onChange: (value) {
                                    realEstateInfo['realEstateStatus'] = value;
                                    setState(() {});
                                  },
                                  value: widget.editData['data']
                                          ['realEstateStatus'] ??
                                      'New',
                                  context: context,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          width: 400,
                          child: customInput(
                            controller: locationTextController,
                            title: 'Location',
                            onChange: (value) async {
                              realEstateInfo['realEstateLocation'] = value;
                              await fetchSuggestions(value);
                            },
                            value: widget.editData['data']
                                    ['realEstateLocation'] ??
                                '',
                          ),
                        ),
                        if (autoLocationList.isNotEmpty)
                          SizedBox(
                            width: 400,
                            height: autoLocationList.length * 50,
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: autoLocationList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                    onTap: () {
                                      locationTextController.text =
                                          autoLocationList[index].description;
                                      realEstateInfo['realEstateLocation'] =
                                          autoLocationList[index].description;
                                      setState(() {
                                        autoLocationList = [];
                                      });
                                    },
                                    child: Container(
                                      height: 50,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.only(bottom: 3),
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 209, 209, 209))),
                                          color: Color.fromARGB(
                                              255, 224, 224, 224)),
                                      child: Text(
                                        autoLocationList[index].description,
                                        textAlign: TextAlign.center,
                                      ),
                                    ));
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: 400,
                      child: titleAndsubtitleInput('About', 70, 5,
                          (value) async {
                        realEstateInfo['realEstateAbout'] = value;
                        setState(() {});
                      },
                          widget.editData['data']['realEstateAbout'] ??
                              realEstateInfo['realEstateAbout']),
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
                      const Row(
                        children: [
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
                            padding: const EdgeInsets.all(4),
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
                            children: realEstatePhoto
                                .map(((e) =>
                                    realEstatePhotoWidget(e['url'], e['id'])))
                                .toList(),
                          ))
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(left: 15)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
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
                            padding: const EdgeInsets.all(4),
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
                            children: realEstateFile
                                .map(((e) =>
                                    realEstateFileWidget(e['url'], e['id'])))
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
            ],
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          alignment: Alignment.center,
          width: 400,
          margin: const EdgeInsets.only(right: 20),
          child: Column(
            children: [
              Row(
                children: [
                  const Flexible(fit: FlexFit.tight, child: SizedBox()),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      shadowColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0)),
                      minimumSize: const Size(100, 50),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Cancel',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shadowColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0)),
                      minimumSize: const Size(100, 50),
                    ),
                    onPressed: () {
                      footerBtnState = true;
                      setState(() {});
                      if (widget.editData['id'] == '') {
                        getTokenBudget();
                      } else {
                        postCon
                            .editRealEstate(
                                context, widget.editData['id'], realEstateInfo)
                            .then((value) {
                          Helper.showToast(value['msg']);
                          if (value['result']) {
                            Navigator.of(context).pop(true);
                          }
                        });
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
                        : const Text('Publish',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      // if (autoLocationList.isNotEmpty)
      //   Positioned(
      //     top: 250,
      //     left: 0,
      //     right: 0,
      //     child: SizedBox(
      //       height: 230,
      //       child: ListView.builder(
      //         shrinkWrap: true,
      //         itemCount: autoLocationList.length,
      //         itemBuilder: (BuildContext context, int index) {
      //           return InkWell(
      //             onTap: () {
      //               locationTextController.text =
      //                   autoLocationList[index].description;
      //               realEstateInfo['realEstateLocation'] =
      //                   autoLocationList[index].description;
      //               setState(() {
      //                 autoLocationList = [];
      //               });
      //             },
      //             child: Container(
      //               height: 50,
      //               alignment: Alignment.center,
      //               padding: const EdgeInsets.only(bottom: 3),
      //               decoration: const BoxDecoration(
      //                   border: Border(
      //                       bottom: BorderSide(
      //                           color: Color.fromARGB(255, 209, 209, 209))),
      //                   color: Color.fromARGB(255, 224, 224, 224)),
      //               child: Text(
      //                 autoLocationList[index].description,
      //                 textAlign: TextAlign.center,
      //               ),
      //             ),
      //           );
      //         },
      //       ),
      //     ),
      //   )
    ]);
  }

  Widget realEstateFileWidget(file, id) {
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
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.black, size: 13.0),
                        tooltip: 'Delete',
                        onPressed: () {
                          setState(() {
                            realEstateFile
                                .removeWhere((item) => item['id'] == id);
                          });
                        },
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

  Widget realEstatePhotoWidget(photo, id) {
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
                    padding: const EdgeInsets.only(left: 20),
                    tooltip: 'Delete',
                    onPressed: () {
                      setState(() {
                        realEstatePhoto.removeWhere((item) => item['id'] == id);
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
    final imagePicker = ImagePicker();
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

  uploadFile(XFile? pickedFile, type) async {
    if (type == 'photo') {
      realEstatePhoto.add({'id': realEstatePhoto.length, 'url': ''});
      photoLength = realEstatePhoto.length - 1;
      setState(() {});
    } else {
      realEstateFile.add({'id': realEstateFile.length, 'url': ''});
      fileLength = realEstateFile.length - 1;
      setState(() {});
    }
    final firebaseStorage = FirebaseStorage.instance;
    UploadTask uploadTask;
    Reference reference;
    try {
      if (kIsWeb) {
        Uint8List bytes = await pickedFile!.readAsBytes();
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
        if (type == 'photo') {
          for (var i = 0; i < realEstatePhoto.length; i++) {
            if (realEstatePhoto[i]['id'] == photoLength) {
              realEstatePhoto[i]['url'] = downloadUrl;
              realEstateInfo['realEstatePhoto'] = realEstatePhoto;
              setState(() {});
            }
          }
        } else {
          for (var i = 0; i < realEstateFile.length; i++) {
            if (realEstateFile[i]['id'] == fileLength) {
              realEstateFile[i]['url'] = downloadUrl;
              realEstateInfo['realEstateFile'] = realEstateFile;
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
            } else {
              uploadFileProgress = 100.0 *
                  (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
              setState(() {});
            }

            break;
          case TaskState.paused:
            break;
          case TaskState.canceled:
            break;
          case TaskState.error:
            break;
          case TaskState.success:
            uploadFileProgress = 0;
            setState(() {});

            break;
        }
      });
    } catch (e) {}
  }

  uploadImage(type) async {
    XFile? pickedFile = await chooseImage();
    uploadFile(pickedFile, type);
  }

  Widget customInput({title, onChange, controller, value}) {
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
        SizedBox(
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
                child: SizedBox(
                  width: 400,
                  height: height,
                  child: TextField(
                    controller: controller,
                    maxLines: line,
                    minLines: line,
                    onChanged: (value) {
                      realEstateInfo['realEstateAbout'] = value;
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
        style: const TextStyle(
            color: Color.fromRGBO(82, 95, 127, 1),
            fontSize: 13,
            fontWeight: FontWeight.w600),
      ),
      const Padding(padding: EdgeInsets.only(top: 2)),
      SizedBox(
          height: 40,
          width: width,
          child: DropdownButtonFormField(
            value: value,
            items: items
                .map((e) => DropdownMenuItem(
                    value: e['value'], child: Text(e['title'])))
                .toList(),
            onChanged: onChange,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(top: 10, left: 10),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.0),
              ),
            ),
            icon: const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Icon(Icons.arrow_drop_down)),
            iconEnabledColor: Colors.grey,
            style: const TextStyle(
              color: Colors.grey,
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

class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}
