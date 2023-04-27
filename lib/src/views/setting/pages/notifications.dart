import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

import 'package:flutter/cupertino.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/setting/widget/setting_footer.dart';
import 'package:shnatter/src/views/setting/widget/setting_header.dart';

class SettingNotificationScreen extends StatefulWidget {
  SettingNotificationScreen({Key? key, required this.routerChange})
      : con = UserController(),
        super(key: key);
  late UserController con;
  Function routerChange;
  @override
  State createState() => SettingNotificationScreenState();
}

// ignore: must_be_immutable
class SettingNotificationScreenState
    extends mvc.StateMVC<SettingNotificationScreen> {
  Map<String, String> privacyInfo = {
    'poke': 'every',
    'postWall': 'every',
    'gender': 'every',
    'relation': 'every',
    'birthday': 'every',
    'basic': 'every',
    'work': 'every',
    'location': 'every',
    'education': 'every',
    'other': 'every',
    'friends': 'every',
    'photos': 'every',
    'pages': 'every',
    'groups': 'every',
    'events': 'every',
  };
  var chatEnable = false;
  var notificationEnable = false;
  var mailEnable = false;
  late UserController con;
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as UserController;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 20, left: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingHeader(
              routerChange: widget.routerChange,
              icon: const Icon(
                Icons.notifications,
                color: Color.fromARGB(255, 103, 58, 183),
              ),
              pagename: 'Notification',
              button: {'flag': false},
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Row(
              children: const [
                Padding(padding: EdgeInsets.only(left: 20)),
                Text('SYSTEM NOTIFICATIONS'),
                Flexible(fit: FlexFit.tight, child: SizedBox()),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(left: 20),
              width:
                  SizeConfig(context).screenWidth > SizeConfig.smallScreenSize
                      ? SizeConfig(context).screenWidth * 0.5
                      : SizeConfig(context).screenWidth * 0.9 - 30,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        child: Row(
                          children: [
                            Container(
                              width: 35,
                              height: 35,
                              child: SvgPicture.network(
                                  'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fsettings%2FmessageSound.svg?alt=media&token=35c1c371-9fa0-44f0-bc57-55aa6a9023e5'),
                            ),
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Chat Message Sound',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 82, 95, 127),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Padding(padding: EdgeInsets.only(top: 5)),
                                SizedBox(
                                  width: SizeConfig(context).screenWidth >
                                          SizeConfig.smallScreenSize
                                      ? SizeConfig(context).screenWidth * 0.3
                                      : SizeConfig(context).screenWidth * 0.5 -
                                          20,
                                  child: const Text(
                                    'A sound will be played each time you receive a new message on an inactive chat window',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                )
                              ],
                            ),
                            const Flexible(
                                fit: FlexFit.tight, child: SizedBox()),
                            SizedBox(
                              height: 20,
                              child: Transform.scale(
                                scaleX: 0.55,
                                scaleY: 0.55,
                                child: CupertinoSwitch(
                                  //thumbColor: kprimaryColor,
                                  activeColor: kprimaryColor,
                                  value: chatEnable,
                                  onChanged: (value) {
                                    setState(() {
                                      chatEnable = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(left: 15))
                          ],
                        ),
                      ))
                    ],
                  )
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Container(
              padding: const EdgeInsets.only(left: 20),
              width:
                  SizeConfig(context).screenWidth > SizeConfig.smallScreenSize
                      ? SizeConfig(context).screenWidth * 0.5
                      : SizeConfig(context).screenWidth * 0.9 - 30,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        child: Row(
                          children: [
                            Container(
                              width: 35,
                              height: 35,
                              child: SvgPicture.network(
                                  'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fsettings%2FnotifiSound.svg?alt=media&token=dc7cf2df-4229-448b-a313-b1e56ca4db97'),
                            ),
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Notifications Sound',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 82, 95, 127),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Padding(padding: EdgeInsets.only(top: 5)),
                                SizedBox(
                                  width: SizeConfig(context).screenWidth >
                                          SizeConfig.smallScreenSize
                                      ? SizeConfig(context).screenWidth * 0.3
                                      : SizeConfig(context).screenWidth * 0.5 -
                                          20,
                                  child: const Text(
                                    'A sound will be played each time you receive a new activity notification',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                )
                              ],
                            ),
                            const Flexible(
                                fit: FlexFit.tight, child: SizedBox()),
                            SizedBox(
                              height: 20,
                              child: Transform.scale(
                                scaleX: 0.55,
                                scaleY: 0.55,
                                child: CupertinoSwitch(
                                  //thumbColor: kprimaryColor,
                                  activeColor: kprimaryColor,
                                  value: notificationEnable,
                                  onChanged: (value) {
                                    setState(() {
                                      chatEnable = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(left: 15))
                          ],
                        ),
                      ))
                    ],
                  )
                ],
              ),
            ),
            SettingFooter(
              onClick: () {
                var value = {
                  'notification': {
                    'chat': chatEnable,
                    'notification': notificationEnable
                  }
                };

                con.profileChange(value);
              },
              isChange: con.isProfileChange,
            )
          ],
        ));
  }

  @override
  Widget select(text, icon, String info, onchange) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
              color: Color.fromARGB(255, 82, 95, 127),
              fontSize: 11,
              fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Container(
              alignment: Alignment.center,
              color: Colors.grey,
              width: 30,
              height: 30,
              child: icon,
            ),
            Container(
              width: 250,
              height: 30,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 250, 250, 250),
                  border: Border.all(color: Colors.grey)),
              padding: const EdgeInsets.only(left: 20),
              child: DropdownButton(
                value: info,
                items: const [
                  //add items in the dropdown
                  DropdownMenuItem(
                    value: "every",
                    child: Text("Everyone"),
                  ),
                  DropdownMenuItem(value: "friends", child: Text("Friends")),
                  DropdownMenuItem(
                    value: "noone",
                    child: Text("No One"),
                  )
                ],
                onChanged: (String? value) {
                  //get value when changed
                  onchange(value);
                },
                style: const TextStyle(
                    //te
                    color: Colors.black, //Font color
                    fontSize: 12 //font size on dropdown button
                    ),

                dropdownColor: Colors.white,
                underline: Container(), //remove underline
                isExpanded: true,
                isDense: true,
              ),
            ),
          ],
        )
      ],
    );
  }
}
