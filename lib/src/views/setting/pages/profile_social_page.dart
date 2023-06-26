import 'package:flutter/material.dart';

import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/views/setting/widget/setting_header.dart';
import 'package:shnatter/src/widget/startedInput.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingSocialScreen extends StatefulWidget {
  SettingSocialScreen({Key? key, required this.routerChange})
      : con = UserController(),
        super(key: key);
  late UserController con;
  Function routerChange;
  @override
  State createState() => SettingSocialScreenState();
}

// ignore: must_be_immutable
class SettingSocialScreenState extends mvc.StateMVC<SettingSocialScreen> {
  var socialProfile = {};
  var userInfo = UserManager.userInfo;
  late UserController con;
  @override
  void initState() {
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
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            SettingHeader(
              routerChange: widget.routerChange,
              icon: const Icon(
                Icons.facebook,
                color: Color.fromARGB(255, 43, 83, 164),
              ),
              pagename: 'Social Links',
              button: const {
                'buttoncolor': Color.fromARGB(255, 17, 205, 239),
                'icon': Icon(Icons.person),
                'text': 'View Profile',
                'flag': true
              },
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  socialWidget(
                      header: 'Twitter Profile URL',
                      initialValue: userInfo['twitter'],
                      icon: FontAwesomeIcons.twitter,
                      onChange: (newIndex) {
                        socialProfile['twitter'] = newIndex;
                        setState(() {});
                      }),
                  socialWidget(
                      header: 'Youtube Profile URL',
                      initialValue: userInfo['youtube'],
                      icon: FontAwesomeIcons.youtube,
                      onChange: (newIndex) {
                        socialProfile['youtube'] = newIndex;
                        setState(() {});
                      }),
                  socialWidget(
                      header: 'Instagram Profile URL',
                      initialValue: userInfo['instagram'],
                      icon: FontAwesomeIcons.instagram,
                      onChange: (newIndex) {
                        socialProfile['instagram'] = newIndex;
                        setState(() {});
                      }),
                  socialWidget(
                      header: 'Twitch Profile URL',
                      initialValue: userInfo['twitch'],
                      icon: FontAwesomeIcons.twitch,
                      onChange: (newIndex) {
                        socialProfile['twitch'] = newIndex;
                        setState(() {});
                      }),
                  socialWidget(
                      header: 'Linkedin Profile URL',
                      initialValue: userInfo['linkedin'],
                      icon: FontAwesomeIcons.linkedin,
                      onChange: (newIndex) {
                        socialProfile['linkedin'] = newIndex;
                        setState(() {});
                      }),
                  socialWidget(
                      header: 'Vokontakte Profile URL',
                      initialValue: userInfo['vokontakete'],
                      icon: FontAwesomeIcons.vk,
                      onChange: (newIndex) {
                        socialProfile['vokontakete'] = newIndex;
                        setState(() {});
                      }),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            footer(),
          ],
        ),
      ),
    );
  }

  Widget input({label, onchange, obscureText = false, validator, text}) {
    return SizedBox(
      height: 28,
      child: StartedInput(
        validator: (val) async {
          validator(val);
        },
        obscureText: obscureText,
        onChange: (val) async {
          onchange(val);
        },
        text: text,
      ),
    );
  }

  Widget socialWidget({header, initialValue = '', icon, onChange}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          header,
          style: const TextStyle(
              color: Color.fromARGB(255, 82, 95, 127),
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                width: 200,
                height: 50,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: initialValue,
                      maxLines: 1,
                      minLines: 1,
                      onChanged: (value) {
                        onChange(value);
                      },
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(top: 10, left: 10),
                        prefixIcon: Align(
                          widthFactor: 1.0,
                          heightFactor: 1.0,
                          child: Icon(
                            icon,
                            color: const Color.fromARGB(255, 59, 87, 157),
                          ),
                        ),
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget footer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.only(top: 20, bottom: 30),
      child: Container(
          height: 65,
          decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(
              color: Color.fromARGB(255, 220, 226, 237),
              width: 1,
            )),
            color: Color.fromARGB(255, 240, 243, 246),
            // borderRadius: BorderRadius.all(Radius.circular(3)),
          ),
          padding: const EdgeInsets.only(top: 5, left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(3),
                    backgroundColor: Colors.white,
                    // elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0)),
                    minimumSize: con.isProfileChange
                        ? const Size(90, 50)
                        : const Size(120, 50),
                    maximumSize: con.isProfileChange
                        ? const Size(90, 50)
                        : const Size(120, 50),
                  ),
                  onPressed: () {
                    con.profileChange(socialProfile);
                  },
                  child: con.isProfileChange
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10,
                              height: 10,
                              child: CircularProgressIndicator(
                                  color: Colors.black),
                            ),
                            Padding(padding: EdgeInsets.only(left: 7)),
                            Text('Loading',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold))
                          ],
                        )
                      : const Text('Save Changes',
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
              const Padding(padding: EdgeInsets.only(right: 30))
            ],
          )),
    );
  }
}
