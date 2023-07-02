import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/setting/widget/setting_footer.dart';
import 'package:shnatter/src/views/setting/widget/setting_header.dart';

class SettingSecurityPasswordScreen extends StatefulWidget {
  SettingSecurityPasswordScreen({Key? key, required this.routerChange})
      : con = UserController(),
        super(key: key);
  late UserController con;
  Function routerChange;
  @override
  State createState() => SettingSecurityPasswordScreenState();
}

// ignore: must_be_immutable
class SettingSecurityPasswordScreenState
    extends mvc.StateMVC<SettingSecurityPasswordScreen> {
  late UserController con;
  var userInfo = UserManager.userInfo;
  late String currentPassword = '';
  String newPassword = '';
  String confirmPassword = '';
  bool obsboolOld = true;
  bool obsboolNew = true;
  bool obsboolConfirm = true;
  @override
  void initState() {
    super.initState();
    add(widget.con);
    currentPassword = '';
    con = controller as UserController;
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
        alignment: Alignment.topCenter,
        height: SizeConfig(context).screenHeight - SizeConfig.navbarHeight - 30,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                SettingHeader(
                  routerChange: widget.routerChange,
                  icon: const Icon(
                    Icons.security_outlined,
                    color: Color.fromARGB(255, 139, 195, 74),
                  ),
                  pagename: 'Change Password',
                  button: const {'flag': false},
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  constraints: const BoxConstraints(
                    maxWidth: 700,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: 680,
                              height: 65,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 252, 124, 95),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Row(
                                children: [
                                  const Padding(
                                      padding: EdgeInsets.only(left: 30)),
                                  const Icon(
                                    Icons.warning_rounded,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(left: 10)),
                                  SizedBox(
                                      width: SizeConfig(context).screenWidth >
                                              SizeConfig.smallScreenSize
                                          ? SizeConfig(context).screenWidth *
                                              0.3
                                          : SizeConfig(context).screenWidth *
                                                  0.5 -
                                              20,
                                      child: const Text(
                                        'Changing password will log you out from all other sessions',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 11),
                                      ))
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: titleAndsubtitleInput(
                                'Your Old Password',
                                50,
                                1,
                                (value) async {
                                  currentPassword = value;
                                },
                                obsboolOld,
                                () {
                                  obsboolOld = !obsboolOld;
                                  setState(() {});
                                }),
                          ),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: titleAndsubtitleInput(
                                'Your New Password',
                                50,
                                1,
                                (value) async {
                                  newPassword = value;
                                },
                                obsboolNew,
                                () {
                                  obsboolNew = !obsboolNew;
                                  setState(() {});
                                }),
                          ),
                          const Padding(padding: EdgeInsets.only(left: 25)),
                          Expanded(
                            flex: 1,
                            child: titleAndsubtitleInput(
                                'Confirm New Password',
                                50,
                                1,
                                (value) async {
                                  confirmPassword = value;
                                },
                                obsboolConfirm,
                                () {
                                  obsboolConfirm = !obsboolConfirm;
                                  setState(() {});
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
                SettingFooter(
                    onClick: () {
                      saveAccountSettings();
                    },
                    isChange: con.isSettingAction)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget titleAndsubtitleInput(
      title, double height, line, onChange, obsecure, changeOb) {
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
            Row(children: [
              Expanded(
                  flex: 2,
                  child: SizedBox(
                      width: 400,
                      height: height,
                      child: Column(children: [
                        TextField(
                          maxLines: line,
                          minLines: line,
                          obscureText: obsecure,
                          onChanged: (value) {
                            onChange(value);
                          },
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.only(top: 10, left: 10),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1),
                            ),
                            border: const OutlineInputBorder(),
                            suffixIcon: InkWell(
                              onTap: () {
                                changeOb();
                              },
                              child: Icon(obsecure
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                          ),
                        )
                      ])))
            ])
          ]),
    );
  }

  void saveAccountSettings() {
    if (currentPassword == "") {
      Helper.showToast("Please input current password!");
      return;
    }
    if (newPassword == "") {
      Helper.showToast("Please input new password");
      return;
    }
    if (confirmPassword == "") {
      Helper.showToast("Please input confirm password");
      return;
    }
    if (newPassword == currentPassword) {
      Helper.showToast("New password cannot be the same as the old password.");
    } else if (currentPassword == userInfo['password']) {
      if (newPassword == confirmPassword) {
        if (newPassword.length < 8) {
          Helper.showToast("Password should be at least 8 characters");
        } else {
          con.changePassword(userInfo['email'], newPassword);
        }
      } else {
        Helper.showToast("Passwords do not match. Please check again!");
      }
    } else {
      Helper.showToast("You inputted wrong current password.");
    }
  }
}
