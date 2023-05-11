import 'package:flutter/material.dart';

import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/setting/widget/setting_header.dart';
import 'package:shnatter/src/widget/startedInput.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

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
  TextEditingController facebookController = TextEditingController();
  TextEditingController twitterController = TextEditingController();
  TextEditingController youtubeController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  TextEditingController twitchController = TextEditingController();
  TextEditingController linkedinController = TextEditingController();
  TextEditingController vokontaketeController = TextEditingController();
  @override
  void initState() {
    facebookController.text = userInfo['facebook'] ?? '';
    twitterController.text = userInfo['twitter'] ?? '';
    youtubeController.text = userInfo['youtube'] ?? '';
    instagramController.text = userInfo['instagram'] ?? '';
    twitchController.text = userInfo['twitch'] ?? '';
    linkedinController.text = userInfo['linkedin'] ?? '';
    vokontaketeController.text = userInfo['vokontakete'] ?? '';
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
              width:
                  SizeConfig(context).screenWidth > SizeConfig.smallScreenSize
                      ? SizeConfig(context).screenWidth * 0.5 + 40
                      : SizeConfig(context).screenWidth * 0.9 - 30,
              height: SizeConfig(context).screenHeight - 400,
              child: GridView.count(
                crossAxisCount: SizeConfig(context).screenWidth >
                        SizeConfig.mediumScreenSize
                    ? 2
                    : 1,
                childAspectRatio: 4 / 1,
                padding: const EdgeInsets.all(4.0),
                mainAxisSpacing: 4.0,
                shrinkWrap: true,
                crossAxisSpacing: 4.0,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Facebook Profile URL',
                          style: TextStyle(
                              color: Color.fromARGB(255, 82, 95, 127),
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                      Row(children: [
                        Container(
                          width: 40,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.black, width: 0.1)),
                          child: const Icon(
                            Icons.facebook,
                            color: Color.fromARGB(255, 59, 87, 157),
                          ),
                        ),
                        SizedBox(
                          width: 195,
                          height: 30,
                          child: TextFormField(
                            controller: facebookController,
                            onChanged: (newIndex) {
                              socialProfile['facebook'] = newIndex;
                              setState(() {});
                            },
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
                        ),
                      ]),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Twitter Profile URL',
                          style: TextStyle(
                              color: Color.fromARGB(255, 82, 95, 127),
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                      Row(children: [
                        Container(
                          width: 40,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.black, width: 0.1)),
                          child: const Icon(
                            Icons.new_releases_sharp,
                            color: Color.fromARGB(255, 59, 87, 157),
                          ),
                        ),
                        SizedBox(
                          width: 195,
                          height: 30,
                          child: TextFormField(
                            controller: twitterController,
                            onChanged: (newIndex) {
                              socialProfile['twitter'] = newIndex;
                              setState(() {});
                            },
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
                        ),
                      ]),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Youtube Profile URL',
                          style: TextStyle(
                              color: Color.fromARGB(255, 82, 95, 127),
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                      Row(children: [
                        Container(
                          width: 40,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.black, width: 0.1)),
                          child: const Icon(
                            Icons.facebook,
                            color: Color.fromARGB(255, 59, 87, 157),
                          ),
                        ),
                        SizedBox(
                          width: 195,
                          height: 30,
                          child: TextFormField(
                            controller: youtubeController,
                            onChanged: (newIndex) {
                              socialProfile['youtube'] = newIndex;
                              setState(() {});
                            },
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
                        ),
                      ]),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Instagram Profile URL',
                          style: TextStyle(
                              color: Color.fromARGB(255, 82, 95, 127),
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                      Row(children: [
                        Container(
                          width: 40,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.black, width: 0.1)),
                          child: const Icon(
                            Icons.new_releases_sharp,
                            color: Color.fromARGB(255, 59, 87, 157),
                          ),
                        ),
                        SizedBox(
                          width: 195,
                          height: 30,
                          child: TextFormField(
                            controller: instagramController,
                            onChanged: (newIndex) {
                              socialProfile['instagram'] = newIndex;
                              setState(() {});
                            },
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
                        ),
                      ]),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Twitch Profile URL',
                          style: TextStyle(
                              color: Color.fromARGB(255, 82, 95, 127),
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                      Row(children: [
                        Container(
                          width: 40,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.black, width: 0.1)),
                          child: const Icon(
                            Icons.youtube_searched_for_sharp,
                            color: Color.fromARGB(255, 59, 87, 157),
                          ),
                        ),
                        SizedBox(
                          width: 195,
                          height: 30,
                          child: TextFormField(
                            controller: twitchController,
                            onChanged: (newIndex) {
                              socialProfile['twitch'] = newIndex;
                              setState(() {});
                            },
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
                        ),
                      ]),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Linkedin Profile URL',
                          style: TextStyle(
                              color: Color.fromARGB(255, 82, 95, 127),
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                      Row(children: [
                        Container(
                          width: 40,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.black, width: 0.1)),
                          child: const Icon(
                            Icons.new_releases_sharp,
                            color: Color.fromARGB(255, 59, 87, 157),
                          ),
                        ),
                        SizedBox(
                          width: 195,
                          height: 30,
                          child: TextFormField(
                            controller: linkedinController,
                            onChanged: (newIndex) {
                              socialProfile['linkedin'] = newIndex;
                              setState(() {});
                            },
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
                        ),
                      ]),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Vokontakte Profile URL',
                          style: TextStyle(
                              color: Color.fromARGB(255, 82, 95, 127),
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                      Row(children: [
                        Container(
                          width: 40,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.black, width: 0.1)),
                          child: const Icon(
                            Icons.facebook,
                            color: Color.fromARGB(255, 59, 87, 157),
                          ),
                        ),
                        SizedBox(
                          width: 195,
                          height: 30,
                          child: TextFormField(
                            controller: vokontaketeController,
                            onChanged: (newIndex) {
                              socialProfile['vokontakete'] = newIndex;
                              setState(() {});
                            },
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
                        ),
                      ]),
                    ],
                  )
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            footer()
          ],
        ));
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

  Widget footer() {
    return Padding(
      padding: const EdgeInsets.only(right: 20, top: 20),
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
            children: [
              const Flexible(fit: FlexFit.tight, child: SizedBox()),
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
