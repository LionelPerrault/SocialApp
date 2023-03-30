// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/views/setting/widget/setting_header.dart';
import 'package:shnatter/src/widget/startedInput.dart';
import 'package:shnatter/src/widget/interests.dart';

class SettingInterestsScreen extends StatefulWidget {
  late UserController usercon;
  SettingInterestsScreen({Key? key, required this.routerChange})
      : usercon = UserController(),
        super(key: key);
  Function routerChange;
  @override
  State createState() => SettingInterestsScreenState();
}

class SettingInterestsScreenState extends mvc.StateMVC<SettingInterestsScreen> {
  late UserController usercon;
  var userInfo = UserManager.userInfo;

  @override
  void initState() {
    add(widget.usercon);
    usercon = controller as UserController;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map settingProfile = {};
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
              pagename: 'Interests',
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
              child: SizedBox(
                width: 400,
                child: InterestsWidget(
                  context: context,
                  data: UserManager.userInfo['interests'],
                  sendUpdate: (value) {
                    settingProfile['interests'] = value;
                  },
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            footer(settingProfile)
          ],
        ));
  }

  Widget footer(updatedData) {
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
                    usercon.profileChange(updatedData);
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
}
