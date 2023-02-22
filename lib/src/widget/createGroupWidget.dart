import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/helpers/helper.dart';

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/widget/alertYesNoWidget.dart';
import 'package:shnatter/src/widget/interests.dart';

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
  bool payLoading = false;
  @override
  void initState() {
    add(widget.Postcon);
    Postcon = controller as PostController;
    super.initState();
  }

  getTokenBudget() async {
    var adminSnap = await Helper.systemSnap.doc('config').get();
    var price = adminSnap.data()!['priceCreatingGroup'];
    var userSnap =
        await Helper.userCollection.doc(UserManager.userInfo['uid']).get();
    var paymail = userSnap.data()!['paymail'];
    setState(() {});
    print('price:$price');
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
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) => AlertDialog(
          title: const SizedBox(),
          content: AlertYesNoWidget(
              yesFunc: () async {
                payLoading = true;
                setState(() {});
                print('adminPrice---$paymail,$price');
                await UserController()
                    .payShnToken(paymail, price, 'Pay for creating group')
                    .then(
                      (value) async => {
                        if (value)
                          {
                            payLoading = false,
                            setState(() {}),
                            Navigator.of(dialogContext).pop(true),
                            // loading = true,
                            setState(() {}),
                            await Postcon.createEvent(context, groupInfo)
                                .then((value) {
                              footerBtnState = false;
                              setState(() => {});
                              Navigator.of(context).pop(true);
                              // loading = true;
                              setState(() {});
                              print('to create group page');
                              Helper.showToast(value['msg']);
                              if (value['result'] == true) {
                                widget.routerChange({
                                  'router': RouteNames.groups,
                                  'subRouter': value['value'],
                                });
                              }
                            }),
                            setState(() {}),
                            // loading = false,
                            // setState(() {}),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
                    Container(
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
                    Container(
                        width: 400,
                        child: customInput(
                            title: 'Location',
                            onChange: (value) async {
                              groupInfo['groupLocation'] = value;
                              setState(() {});
                            }))
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 400,
                      child: customInput(
                          title: 'Group Username',
                          onChange: (value) {
                            groupInfo['groupUserName'] = value;
                            setState(() {});
                          },
                          hintText: 'https://test.shnatter.com/groups/'),
                    )
                  ],
                ),
                Container(
                  width: 380,
                  child: const Text(
                    'Can only contain alphanumeric characters (A–Z, 0–9) and periods (\'.\')',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: 400,
                        margin: EdgeInsets.only(
                            right:
                                SizeConfig(context).screenWidth > 540 ? 15 : 0),
                        height: 40,
                        child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 17, 205, 239),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 17, 205, 239),
                                  width:
                                      0.1), //bordrder raiuds of dropdown button
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
                                            padding: EdgeInsets.only(left: 5)),
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
                                            padding: EdgeInsets.only(left: 5)),
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
                                            padding: EdgeInsets.only(left: 5)),
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
                                  iconEnabledColor: Colors.white, //Icon color
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
                    Container(
                      width: 400,
                      child:
                          titleAndsubtitleInput('About', 70, 5, (value) async {
                        groupInfo['groupAbout'] = value;
                        // setState(() {});
                      }),
                    )
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
                Container(
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
          ),
        ),
        Container(
          width: 400,
          margin: const EdgeInsets.only(right: 15, bottom: 10),
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
                  minimumSize: Size(100, 50),
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
                  minimumSize: Size(100, 50),
                ),
                onPressed: () {
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
                            color: Colors.black, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ],
    );
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
      Container(
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
              child: Container(
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
