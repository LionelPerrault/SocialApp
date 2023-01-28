import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/setting/widget/setting_footer.dart';
import 'package:shnatter/src/views/setting/widget/setting_header.dart';
import 'package:shnatter/src/widget/startedInput.dart';

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
  late String currentPassword;
  String newPassword = '';
  String confirmPassword = '';
  @override
  void initState() {
    super.initState();
    add(widget.con);
    currentPassword = '';
    con = controller as UserController;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 20, left: 30),
        child: Column(
          children: [
            SettingHeader(
              routerChange: widget.routerChange,
              icon: Icon(
                Icons.security_outlined,
                color: Color.fromARGB(255, 139, 195, 74),
              ),
              pagename: 'Change Password',
              button: {'flag': false},
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Container(
              width:
                  SizeConfig(context).screenWidth > SizeConfig.smallScreenSize
                      ? SizeConfig(context).screenWidth * 0.5 + 40
                      : SizeConfig(context).screenWidth * 0.9 - 30,
              child: Column(
                children: [
                  Container(
                    width: 680,
                    height: 65,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 252, 124, 95),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Row(
                      children: [
                        const Padding(padding: EdgeInsets.only(left: 30)),
                        const Icon(
                          Icons.warning_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                        const Padding(padding: EdgeInsets.only(left: 10)),
                        SizedBox(
                            width: SizeConfig(context).screenWidth >
                                    SizeConfig.smallScreenSize
                                ? SizeConfig(context).screenWidth * 0.3
                                : SizeConfig(context).screenWidth * 0.5 - 20,
                            child: const Text(
                              'Changing password will log you out from all other sessions',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 11),
                            ))
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Confirm Current Password',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 82, 95, 127),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                width: 700,
                                child: input(
                                    validator: (value) async {
                                      print(value);
                                    },
                                    onchange: (value) async {
                                      currentPassword = value;
                                    },
                                    obscureText: true),
                              )
                            ],
                          )),
                      const Padding(padding: EdgeInsets.only(right: 20))
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Your New Password',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 82, 95, 127),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                width: 300,
                                child: input(
                                    validator: (value) async {
                                      print(value);
                                    },
                                    onchange: (value) async {
                                      newPassword = value;
                                    },
                                    obscureText: true),
                              )
                            ],
                          )),
                      const Padding(padding: EdgeInsets.only(left: 25)),
                      Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Confirm New Password',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 82, 95, 127),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                width: 300,
                                child: input(
                                    validator: (value) async {
                                      print(value);
                                    },
                                    onchange: (value) async {
                                      confirmPassword = value;
                                    },
                                    obscureText: true),
                              )
                            ],
                          )),
                      const Padding(padding: EdgeInsets.only(right: 20))
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
        ));
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

  void saveAccountSettings() {
    print(userInfo['password']);
    if (currentPassword == userInfo['password']) {
      print(newPassword);
      print(confirmPassword);
      if (newPassword == confirmPassword) {
        con.changePassword(userInfo['email'], newPassword);
      }
    }
  }
}
