import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/utils/svg.dart';
import 'package:shnatter/src/views/box/daytimeM.dart';
import 'package:shnatter/src/views/box/mindpost.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/views/setting/widget/setting_footer.dart';
import 'package:shnatter/src/views/setting/widget/setting_header.dart';
import 'package:shnatter/src/widget/mindslice.dart';
import 'package:shnatter/src/widget/startedInput.dart';

class SettingInterestsScreen extends StatefulWidget {
  late UserController usercon;
  SettingInterestsScreen({Key? key, required this.routerChange})
      : usercon = UserController(),
        super(key: key);
  Function routerChange;
  @override
  State createState() => SettingInterestsScreenState();
}

// ignore: must_be_immutable
class SettingInterestsScreenState extends mvc.StateMVC<SettingInterestsScreen> {
  var setting_profile = {};
  late UserController usercon;
  var interestsCheck = [];
  List subCategory = [];
  var userInfo = UserManager.userInfo;

  @override
  void initState() {
    add(widget.usercon);
    usercon = controller as UserController;
    setting_profile['interests'] = [];
    usercon.getAllInterests().then((allInterests) => {
          for (int i = 0; i < allInterests.length; i++)
            {
              subCategory.add(allInterests[i]),
              if (userInfo['interests']
                  .where((data) => data == i)
                  .toList()
                  .isNotEmpty)
                {
                  interestsCheck.add(
                      {'title': allInterests[i]['title'], 'interested': true}),
                }
              else
                {
                  interestsCheck.add(
                      {'title': allInterests[i]['title'], 'interested': false}),
                }
            },
          setState(() {})
        });
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
                Icons.school,
                color: Color.fromARGB(255, 43, 83, 164),
              ),
              pagename: 'Education',
              button: const {
                'buttoncolor': Color.fromARGB(255, 17, 205, 239),
                'icon': Icon(Icons.person),
                'text': 'View Profile',
                'flag': true
              },
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            SizedBox(
              width:
                  SizeConfig(context).screenWidth > SizeConfig.smallScreenSize
                      ? SizeConfig(context).screenWidth * 0.5 + 40
                      : SizeConfig(context).screenWidth * 0.9 - 30,
              child: SingleChildScrollView(
                child: Column(children: [
                  Column(children: [
                    const Divider(
                      thickness: 0.1,
                      color: Colors.black,
                    ),
                    Row(
                      children: const [
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Text(
                          'Title',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Flexible(fit: FlexFit.tight, child: SizedBox()),
                        Text(
                          'Check',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Padding(padding: EdgeInsets.only(left: 30))
                      ],
                    ),
                    const Divider(
                      thickness: 0.1,
                      color: Colors.black,
                    )
                  ]),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                        itemCount: subCategory.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(children: [
                            Row(
                              children: [
                                const Padding(
                                    padding: EdgeInsets.only(left: 10)),
                                Text(
                                  subCategory[index]['title'],
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.black),
                                ),
                                const Flexible(
                                    fit: FlexFit.tight, child: SizedBox()),
                                Transform.scale(
                                    scale: 0.7,
                                    child: Checkbox(
                                      fillColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.black),
                                      checkColor: Colors.blue,
                                      activeColor:
                                          const Color.fromRGBO(0, 123, 255, 1),
                                      value: interestsCheck[index]
                                          ['interested'],
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  5.0))), // Rounded Checkbox
                                      onChanged: (value) {
                                        setState(() {
                                          interestsCheck[index]['interested'] =
                                              !interestsCheck[index]
                                                  ['interested'];
                                        });
                                        if (interestsCheck[index]
                                            ['interested']) {
                                          setting_profile['interests']
                                              .add(index);
                                        }
                                        setState(() {});
                                      },
                                    )),
                                const Padding(
                                    padding: EdgeInsets.only(left: 30))
                              ],
                            ),
                            const Divider(
                              thickness: 0.1,
                              color: Colors.black,
                            )
                          ]);
                        }),
                  )
                ]),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            footer()
          ],
        ));
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
                    minimumSize: usercon.isProfileChange
                        ? const Size(90, 50)
                        : const Size(120, 50),
                    maximumSize: usercon.isProfileChange
                        ? const Size(90, 50)
                        : const Size(120, 50),
                  ),
                  onPressed: () {
                    var data = {};
                    data['interests'] = [];
                    for (int i = 0; i < interestsCheck.length; i++) {
                      if (interestsCheck[i]['interested']) {
                        data['interests'].add(i);
                      }
                    }
                    usercon.profileChange(data);
                  },
                  child: usercon.isProfileChange
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
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

  Widget input({label, onchange, obscureText = false, validator}) {
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
      ),
    );
  }
}
