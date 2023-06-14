// ignore_for_file: prefer_const_constructors

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/setting/widget/setting_footer.dart';
import 'package:shnatter/src/views/setting/widget/setting_header.dart';
import 'package:shnatter/src/widget/alertYesNoWidget.dart';

class SettingAccountScreen extends StatefulWidget {
  SettingAccountScreen({Key? key, required this.routerChange})
      : con = UserController(),
        super(key: key);
  late UserController con;
  Function routerChange;
  @override
  State createState() => SettingAccountScreenState();
}

// ignore: must_be_immutable
class SettingAccountScreenState extends mvc.StateMVC<SettingAccountScreen> {
  bool showMind = false;
  late bool nearByOptOut = false;
  var userInfo = UserManager.userInfo;
  String userName = '';
  String email = '';
  late UserController con;
  @override
  void initState() {
    email = userInfo['email'];
    userName = userInfo['userName'];
    nearByOptOut = userInfo['nearbyOptOut'] ?? false;
    add(widget.con);
    con = controller as UserController;
    print('$email $userName');
    super.initState();
  }

  handleSubmitAccount() {
    if (userName != UserManager.userInfo['userName']) {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) => AlertDialog(
          title: const SizedBox(),
          content: AlertYesNoWidget(
              yesFunc: () async {
                con.saveAccountSettings(userName, nearByOptOut);
                Navigator.of(context).pop(true);
              },
              noFunc: () {
                Navigator.of(context).pop(true);
              },
              header: 'Change Username',
              text: 'Do you want to change username',
              progress: false),
        ),
      );
    } else {
      con.saveAccountSettings(userName, nearByOptOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Container(
          padding: const EdgeInsets.only(top: 20, left: 30),
          child: Column(
            children: [
              SettingHeader(
                routerChange: widget.routerChange,
                icon: Icon(Icons.settings),
                pagename: 'Account Settings',
                button: const {'flag': false},
              ),
              const SizedBox(height: 20),
              Container(
                  // width: SizeConfig.,
                  padding: EdgeInsets.only(
                      left: 10,
                      right: SizeConfig(context).screenWidth > 900
                          ? SizeConfig(context).screenWidth * 0.15
                          : 0 - SizeConfig(context).screenWidth > 600
                              ? 0
                              : 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'EMAIL ADDRESS',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 20),
                      customInput(
                          title: 'Email Address',
                          onChange: () {},
                          value: UserManager.userInfo['email'],
                          editable: false),
                      const SizedBox(height: 20),
                      Divider(
                        indent: 5,
                      ),
                      const Text(
                        'USERNAME',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 10),
                      customInput(
                          title: 'Username',
                          onChange: (value) {
                            userName = value;
                          },
                          value: userName),
                      const SizedBox(height: 10),
                      const Divider(
                        indent: 5,
                      ),
                      const Text(
                        'SHARE MY CODE',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(padding: EdgeInsets.only(left: 20)),
                          ),
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              width: 80,
                              child: const Text(
                                'INVITE CODE',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(244, 82, 95, 127)),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(left: 30)),
                          Expanded(
                              flex: 7,
                              child: Container(
                                padding: EdgeInsets.only(right: 20),
                                width: 350,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7)),
                                ),
                                child: Row(children: [
                                  Expanded(
                                      child: SizedBox(
                                    width: 350,
                                    height: 40,
                                    child: TextFormField(
                                      readOnly: true,
                                      enabled: false,
                                      initialValue: userInfo['uid'].toString(),
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black),
                                      onSaved: (String? value) {
                                        // This optional block of code can be used to run
                                        // code when the user saves the form.
                                      },
                                      validator: (String? value) {
                                        return (value != null &&
                                                value.contains('@'))
                                            ? 'Do not use the @ char.'
                                            : null;
                                      },
                                    ),
                                  )),
                                  IconButton(
                                      onPressed: () {
                                        FlutterClipboard.copy(userInfo['uid'])
                                            .then((value) => Helper.showToast(
                                                'Invite Code Copied!'));
                                      },
                                      icon: Icon(
                                        Icons.copy,
                                        color: Colors.grey,
                                      ))
                                ]),
                              ))
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(
                        indent: 5,
                      ),
                      const Text(
                        'NearBy Opt Out',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(padding: EdgeInsets.only(left: 20)),
                          ),
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              width: 80,
                              child: const Text(
                                'Enable Opt Out',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(244, 82, 95, 127)),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(left: 20)),
                          Expanded(
                              flex: 7,
                              child: Container(
                                padding: EdgeInsets.only(right: 20),
                                width: 350,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7)),
                                ),
                                child: Row(children: [
                                  Switch(
                                    // This bool value toggles the switch.
                                    value: nearByOptOut,
                                    activeColor: Colors.blue,
                                    onChanged: (bool value) {
                                      // This is called when the user toggles the switch.
                                      setState(() {
                                        nearByOptOut = value;
                                      });
                                    },
                                  ),
                                ]),
                              ))
                        ],
                      ),
                    ],
                  )),
              SettingFooter(
                onClick: () {
                  handleSubmitAccount();
                },
                isChange: con.isSettingAction,
              )
            ],
          )),
    );
  }

  Widget customInput({title, onChange, value, editable = true}) {
    return Row(
      children: [
        Padding(padding: EdgeInsets.only(left: 20)),
        Expanded(
          flex: 1,
          child: SizedBox(
            width: 80,
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(244, 82, 95, 127)),
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(left: 20)),
        Expanded(
            flex: 4,
            child: Container(
              padding: EdgeInsets.only(right: 20),
              width: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(7)),
              ),
              child: Row(children: [
                Expanded(
                    child: SizedBox(
                  height: 35,
                  child: TextFormField(
                    enabled: editable,
                    enableInteractiveSelection: editable,
                    initialValue: value,
                    textInputAction: TextInputAction.done,
                    onChanged: (value) {
                      onChange(value);
                    },
                    style: TextStyle(fontSize: 13),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(top: 10, left: 10),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                    ),
                  ),
                )),
              ]),
            )),
      ],
    );
  }
}
