import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/setting/widget/setting_footer.dart';
import 'package:shnatter/src/views/setting/widget/setting_header.dart';

class SettingAccountScreen extends StatefulWidget {
  SettingAccountScreen({Key? key})
      : con = UserController(),
        super(key: key);
  late UserController con;
  @override
  State createState() => SettingAccountScreenState();
}

// ignore: must_be_immutable
class SettingAccountScreenState extends mvc.StateMVC<SettingAccountScreen> {
  bool showMind = false;
  var user_email = '';
  var user_name = '';
  var password = '';
  var userInfo = UserManager.userInfo;
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late UserController con;
  @override
  void initState() {
    emailController.text = userInfo['email'];
    userNameController.text = userInfo['userName'];
    passwordController.text = userInfo['password'];
    add(widget.con);
    con = controller as UserController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 20, left: 30),
        child: Column(
          children: [
            SettingHeader(
              icon: Icon(Icons.settings),
              pagename: 'Account Settings',
              button: {'flag': false},
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Container(
              // width: SizeConfig.,
              padding: EdgeInsets.only(
                  left: 10,
                  right: SizeConfig(context).screenWidth > 900
                      ? SizeConfig(context).screenWidth * 0.15
                      : 0),
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
                        const Padding(padding: EdgeInsets.only(left: 30)),
                        Container(
                          width: 120,
                          child: const Text(
                            'Email Address',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(244, 82, 95, 127)),
                          ),
                        ),
                        Expanded(
                            child: Container(
                          width: 350,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
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
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color:
                                              Color.fromARGB(255, 54, 54, 54),
                                          width: 1.0),
                                      borderRadius: BorderRadius.circular(0),
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
                    new Divider(
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
                        const Padding(padding: EdgeInsets.only(left: 40)),
                        Container(
                          width: 80,
                          child: const Text(
                            'Username',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(244, 82, 95, 127)),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(left: 30)),
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.only(right: 20),
                          width: 350,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                          ),
                          child: Row(children: [
                            SizeConfig(context).screenWidth > 650
                                ? Container(
                                    padding: EdgeInsets.only(top: 7),
                                    alignment: Alignment.topCenter,
                                    width: 200,
                                    height: 30,
                                    color: Colors.grey,
                                    child: Text('https://test.shnatter.com/'),
                                  )
                                : Container(),
                            Expanded(
                                child: Container(
                              width: 300,
                              height: 30,
                              child: TextFormField(
                                controller: userNameController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 54, 54, 54),
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                                style: const TextStyle(fontSize: 14),
                                onSaved: (String? value) {
                                  // This optional block of code can be used to run
                                  // code when the user saves the form.
                                },
                                validator: (String? value) {
                                  return (value != null && value.contains('@'))
                                      ? 'Do not use the @ char.'
                                      : null;
                                },
                              ),
                            )),
                          ]),
                        )),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 130),
                      child: Text(
                        'Can only contain alphanumeric characters (A–Z, 0–9) and periods (\'.\')',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    new Divider(
                      indent: 5,
                      endIndent: 20,
                    ),
                    const Text(
                      'SECUIRTY CHECK',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    Row(
                      children: [
                        const Padding(padding: EdgeInsets.only(left: 30)),
                        Container(
                          width: 80,
                          child: const Text(
                            'Current Password',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(244, 82, 95, 127)),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(left: 40)),
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.only(right: 20),
                          width: 350,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                          ),
                          child: Row(children: [
                            Expanded(
                                child: Container(
                              width: 350,
                              height: 30,
                              child: TextFormField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 54, 54, 54),
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                                style: const TextStyle(fontSize: 14),
                                onSaved: (String? value) {
                                  // This optional block of code can be used to run
                                  // code when the user saves the form.
                                },
                                validator: (String? value) {
                                  return (value != null && value.contains('@'))
                                      ? 'Do not use the @ char.'
                                      : null;
                                },
                              ),
                            )),
                          ]),
                        ))
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                  ]),
            ),
            SettingFooter(
              onClick: () {
                con.saveAccountSettings(emailController.text,
                    userNameController.text, passwordController.text);
              },
              isChange: con.isSettingAction,
            )
          ],
        ));
  }
}
