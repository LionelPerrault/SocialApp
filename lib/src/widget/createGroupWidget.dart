// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/widget/alertYesNoWidget.dart';
import 'package:shnatter/src/widget/interests.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class CreateGroupModal extends StatefulWidget {
  BuildContext context;
  late PostController Postcon;
  CreateGroupModal(
      {Key? key, required this.context, required this.routerChange})
      : Postcon = PostController(),
        super(key: key);
  Function routerChange;
  @override
  State createState() => CreateGroupModalState();
}

class CreateGroupModalState extends mvc.StateMVC<CreateGroupModal> {
  bool isSound = false;
  late PostController Postcon;
  Map<String, dynamic> groupInfo = {
    'groupAbout': '',
    'groupPrivacy': 'public',
    'groupInterests': [],
  };
  var privacy = 'public';
  var interest = 'none';
  // ignore: non_constant_identifier_names
  List<Map> GroupsDropDown = [
    {
      'value': 'public',
      'title': 'Public Group',
      'subtitle': 'Anyone can see the group, its members and their posts.',
      'icon': Icons.language
    },
    {
      'value': 'closed',
      'title': 'Closed Group',
      'subtitle': 'Only members can see posts.',
      'icon': Icons.lock_open_rounded
    },
    {
      'value': 'secret',
      'title': 'Secret Group',
      'subtitle': 'Only members can find the group and see posts.',
      'icon': Icons.lock_outline_rounded
    },
  ];
  bool footerBtnState = false;
  List<Suggestion> autoLocationList = [];
  TextEditingController locationTextController = TextEditingController();
  @override
  void initState() {
    add(widget.Postcon);
    Postcon = controller as PostController;
    super.initState();
  }

  getTokenBudget() async {
    bool payLoading = false;
    var adminSnap = await Helper.systemSnap.doc('config').get();
    var price = adminSnap.data()!['priceCreatingGroup'];
    var snapshot = await FirebaseFirestore.instance
        .collection(Helper.adminPanel)
        .doc(Helper.backPaymail)
        .get();
    var paymail = snapshot.data()!['address'];
    setState(() {});

    if (price == '0') {
      await Postcon.createGroup(context, groupInfo).then((value) => {
            footerBtnState = false,
            setState(
              () => {},
            ),
            Navigator.of(context).pop(true),
            Helper.showToast(value['msg']),
            if (value['result'] == true)
              {
                widget.routerChange({
                  'router': RouteNames.groups,
                  'subRouter': value['value'],
                })
              }
          });
      setState(() {});
    } else {
      footerBtnState = false;
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) => AlertDialog(
          title: const SizedBox(),
          content: AlertYesNoWidget(
              yesFunc: () async {
                payLoading = true;
                setState(() {});
                await UserController()
                    .payShnToken(paymail, price, 'Pay for creating group')
                    .then(
                      (value) async => {
                        if (value)
                          {
                            payLoading = false,
                            setState(() {}),
                            Navigator.of(dialogContext).pop(true),
                            setState(() {}),
                            await Postcon.createGroup(context, groupInfo)
                                .then((value) {
                              footerBtnState = false;
                              setState(() => {});
                              Navigator.of(context).pop(true);
                              setState(() {});
                              Helper.showToast(value['msg']);
                              if (value['result'] == true) {
                                widget.routerChange({
                                  'router': RouteNames.groups,
                                  'subRouter': value['value'],
                                });
                              }
                            }),
                            setState(() {}),
                          }
                      },
                    );
              },
              noFunc: () {
                Navigator.of(context).pop(true);
                footerBtnState = false;
                setState(() {});
              },
              header: 'Costs for creating page',
              text:
                  'By paying the fee of $price tokens, the group will be published.',
              progress: payLoading),
        ),
      );
    }
  }

  Future<void> fetchSuggestions(
    String input,
  ) async {
    final sessionToken = Uuid().v4();

    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input &types=address&language=en&key=${Helper.apiKey}&sessiontoken=$sessionToken';
    try {
      final response = await http.get(
        Uri.parse(request),
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE',
          'Access-Control-Allow-Headers': 'Content-Type',
        },
      );

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
      Column(
        children: [
          SizedBox(
              height: SizeConfig(context).screenHeight - 200,
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: 400,
                            child: customInput(
                                title: 'Name Your Group',
                                onChange: (value) async {
                                  groupInfo['groupName'] = value;
                                  setState(() {});
                                }))
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(top: 15)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: 400,
                            child: customInput(
                                controller: locationTextController,
                                title: 'Location',
                                onChange: (value) async {
                                  groupInfo['groupLocation'] = value;
                                  await fetchSuggestions(value);

                                  setState(() {});
                                }))
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(top: 15)),
                    const Padding(padding: EdgeInsets.only(top: 15)),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            width: 400,
                            margin: EdgeInsets.only(
                                right: SizeConfig(context).screenWidth > 540
                                    ? 15
                                    : 0),
                            height: 40,
                            child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 17, 205, 239),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 17, 205, 239),
                                      width: 0.1),
                                ),
                                child: Padding(
                                    padding:
                                        const EdgeInsets.only(top: 7, left: 15),
                                    child: DropdownButton(
                                      value: privacy,
                                      items: [
                                        DropdownMenuItem(
                                          value: "public",
                                          child: Row(children: const [
                                            Icon(
                                              Icons.language,
                                              color: Colors.black,
                                            ),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5)),
                                            Text(
                                              "Public",
                                              style: TextStyle(fontSize: 13),
                                            )
                                          ]),
                                        ),
                                        DropdownMenuItem(
                                          value: "closed",
                                          child: Row(children: const [
                                            Icon(
                                              Icons.groups,
                                              color: Colors.black,
                                            ),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5)),
                                            Text(
                                              "Closed",
                                              style: TextStyle(fontSize: 13),
                                            )
                                          ]),
                                        ),
                                        DropdownMenuItem(
                                          value: "security",
                                          child: Row(children: const [
                                            Icon(
                                              Icons.lock_outline,
                                              color: Colors.black,
                                            ),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5)),
                                            Text(
                                              "Security",
                                              style: TextStyle(fontSize: 13),
                                            )
                                          ]),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        privacy = value.toString();
                                        groupInfo['groupPrivacy'] = privacy;
                                        setState(() {});
                                      },
                                      icon: const Padding(
                                          padding: EdgeInsets.only(left: 20),
                                          child: Icon(Icons.arrow_drop_down)),
                                      iconEnabledColor:
                                          Colors.white, //Icon color
                                      style: const TextStyle(
                                        color: Colors.black, //Font color
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      dropdownColor: Colors.white,
                                      underline: Container(), //remove underline
                                      isExpanded: true,
                                      isDense: true,
                                    ))),
                          ),
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(top: 15)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 400,
                          child: titleAndsubtitleInput('About', 70, 5,
                              (value) async {
                            groupInfo['groupAbout'] = value;
                            // setState(() {});
                          }),
                        )
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    SizedBox(
                      width: 400,
                      child: InterestsWidget(
                        context: context,
                        sendUpdate: (value) {
                          groupInfo['groupInterests'] = value;
                        },
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                  ],
                ),
              )),
          const SizedBox(
            height: 15,
          ),
          Container(
            width: 400,
            margin: const EdgeInsets.only(
              right: 15,
            ),
            child: Row(
              children: [
                const Flexible(fit: FlexFit.tight, child: SizedBox()),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[400],
                    shadowColor: Colors.grey[400],
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0)),
                    minimumSize: const Size(100, 50),
                  ),
                  onPressed: () {
                    Navigator.of(widget.context).pop(true);
                  },
                  child: const Text('Cancel',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
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
                    if (groupInfo['groupName'] == null ||
                        groupInfo['groupName'] == '') {
                      Helper.showToast('Please add your group name');
                      return;
                    } else if (groupInfo['groupLocation'] == null ||
                        groupInfo['groupLocation'] == '') {
                      Helper.showToast('Please add your group location');
                      return;
                    } else if (groupInfo['groupInterests'].length == 0) {
                      Helper.showToast('Please select interest');
                      return;
                    }
                    footerBtnState = true;
                    setState(() {});
                    getTokenBudget();
                  },
                  child: footerBtnState
                      ? const SizedBox(
                          width: 10,
                          height: 10.0,
                          child: CircularProgressIndicator(
                            color: Colors.grey,
                          ),
                        )
                      : const Text('Create',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
        ],
      ),
      if (autoLocationList.isNotEmpty)
        Positioned(
            top: 150,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 230,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: autoLocationList.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                      onTap: () {
                        locationTextController.text =
                            autoLocationList[index].description;
                        groupInfo['groupLocation'] =
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
                                    color: Color.fromARGB(255, 209, 209, 209))),
                            color: Color.fromARGB(255, 224, 224, 224)),
                        child: Text(
                          autoLocationList[index].description,
                          textAlign: TextAlign.center,
                        ),
                      ));
                },
              ),
            ))
    ]);
  }
}

Widget customInput({title, onChange, controller, hintText}) {
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
          onChanged: onChange,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: const EdgeInsets.only(top: 10, left: 10),
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 1.0),
            ),
          ),
        ),
      )
    ],
  );
}

Widget titleAndsubtitleInput(title, height, line, onChange) {
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
                height: double.parse(height.toString()),
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

class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}
