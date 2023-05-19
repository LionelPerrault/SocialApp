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
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  late UserController con;
  @override
  void initState() {
    emailController.text = userInfo['email'];
    userNameController.text = userInfo['userName'];
    nearByOptOut = userInfo['nearbyOptOut'] ?? false;
    add(widget.con);
    con = controller as UserController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
              const Padding(padding: EdgeInsets.only(top: 20)),
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
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(padding: EdgeInsets.only(left: 30)),
                          ),
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              width: 120,
                              child: const Text(
                                'Email Address',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(244, 82, 95, 127)),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 7,
                              child: Container(
                                width: 350,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7)),
                                ),
                                child: Row(children: [
                                  Container(
                                    width: 40,
                                    height: 30,
                                    color: Colors.grey,
                                    child: Icon(Icons.mail),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(right: 20),
                                      width: 300,
                                      height: 30,
                                      child: TextFormField(
                                        enabled: false,
                                        controller: emailController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 54, 54, 54),
                                                width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                        ),
                                        style: const TextStyle(fontSize: 14),
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
                                    ),
                                  )
                                ]),
                              ))
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      Divider(
                        indent: 5,
                        endIndent: 20,
                      ),
                      const Text(
                        'USERNAME',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(padding: EdgeInsets.only(left: 30)),
                          ),
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              width: 80,
                              child: const Text(
                                'Username',
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
                                  SizeConfig(context).screenWidth > 650
                                      ? Container(
                                          padding: EdgeInsets.only(top: 7),
                                          alignment: Alignment.topCenter,
                                          width: 200,
                                          height: 30,
                                          color: Colors.grey,
                                          child: Text(
                                              'https://test.shnatter.com/'),
                                        )
                                      : Container(),
                                  Expanded(
                                      child: SizedBox(
                                    width: 300,
                                    height: 30,
                                    child: TextFormField(
                                      readOnly: true,
                                      controller: userNameController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 54, 54, 54),
                                              width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(0),
                                        ),
                                      ),
                                      style: const TextStyle(fontSize: 14),
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
                                ]),
                              )),
                        ],
                      ),
                      // Row(
                      //   // ignore: prefer_const_literals_to_create_immutables
                      //   children: [
                      //     Expanded(
                      //       flex: 3,
                      //       child: Padding(
                      //         padding: EdgeInsets.only(left: 130),
                      //       ),
                      //     ),
                      //     Expanded(
                      //         flex: 7,
                      //         child: Container(
                      //           width: 350,
                      //           // ignore: sort_child_properties_last
                      //           padding: EdgeInsets.only(
                      //               top: 10, left: 20, right: 20),
                      //           child: Text(
                      //             'Can only contain alphanumeric characters (A–Z, 0–9) and periods (\'.\')',
                      //             style: TextStyle(fontSize: 12),
                      //           ),
                      //         )),
                      //   ],
                      // ),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      const Divider(
                        indent: 5,
                        endIndent: 20,
                      ),
                      const Text(
                        'SHARE MY CODE',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(padding: EdgeInsets.only(left: 30)),
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
                                    height: 30,
                                    child: TextFormField(
                                      readOnly: true,
                                      initialValue: userInfo['uid'].toString(),
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 54, 54, 54),
                                              width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(0),
                                        ),
                                      ),
                                      style: const TextStyle(fontSize: 14),
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
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      const Divider(
                        indent: 5,
                        endIndent: 20,
                      ),
                      const Text(
                        'NearBy Opt Out',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(padding: EdgeInsets.only(left: 30)),
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
                      const Padding(padding: EdgeInsets.only(top: 20)),
                    ],
                  )),
              SettingFooter(
                onClick: () {
                  con.saveAccountSettings(emailController.text,
                      userNameController.text, nearByOptOut);
                },
                isChange: con.isSettingAction,
              )
            ],
          )),
    );
  }
}
