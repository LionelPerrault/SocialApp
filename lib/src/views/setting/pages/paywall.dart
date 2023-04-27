import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/setting/widget/setting_footer.dart';
import 'package:shnatter/src/views/setting/widget/setting_header.dart';

class SettingPaywallForUser extends StatefulWidget {
  SettingPaywallForUser({Key? key, required this.routerChange})
      : con = UserController(),
        super(key: key);
  late UserController con;
  Function routerChange;
  @override
  State createState() => SettingPaywallForUserState();
}

// ignore: must_be_immutable
class SettingPaywallForUserState extends mvc.StateMVC<SettingPaywallForUser> {
  late UserController con;
  var userInfo = UserManager.userInfo;
  @override
  void initState() {
    add(widget.con);
    con = controller as UserController;
    super.initState();
    print(userInfo['paywall'].runtimeType);
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
                Icons.money_sharp,
                color: Color.fromARGB(255, 43, 83, 164),
              ),
              pagename: 'Paywall',
              button: const {'flag': false},
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            SizedBox(
              width:
                  SizeConfig(context).screenWidth > SizeConfig.smallScreenSize
                      ? SizeConfig(context).screenWidth * 0.5 + 40
                      : SizeConfig(context).screenWidth * 0.9 - 30,
              child: Column(
                children: [
                  titleAndsubtitleInput('Visit Profile', 50, 1, (value) {
                    userInfo['paywall']['visitProfile'] = value;
                  }, userInfo['paywall']['visitProfile'] ?? ''),
                  titleAndsubtitleInput('Chat with Me', 50, 1, (value) {
                    userInfo['paywall']['chatWithMe'] = value;
                  }, userInfo['paywall']['chatWithMe'] ?? ''),
                  titleAndsubtitleInput('Interest my Event', 50, 1, (value) {
                    userInfo['paywall']['interestMyEvent'] = value;
                  }, userInfo['paywall']['interestMyEvent'] ?? ''),
                  titleAndsubtitleInput('Going my Event', 50, 1, (value) {
                    userInfo['paywall']['goingMyEvent'] = value;
                  }, userInfo['paywall']['goingMyEvent'] ?? ''),
                  titleAndsubtitleInput('Like my Page', 50, 1, (value) {
                    userInfo['paywall']['likeMyPage'] = value;
                  }, userInfo['paywall']['likeMyPage'] ?? ''),
                  titleAndsubtitleInput('Join my Group', 50, 1, (value) {
                    userInfo['paywall']['joinMyGroup'] = value;
                  }, userInfo['paywall']['joinMyGroup'] ?? ''),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            SettingFooter(
              onClick: () {
                con.profileChange({'paywall': userInfo['paywall']});
              },
              isChange: con.isProfileChange,
            )
          ],
        ));
  }

  Widget titleAndsubtitleInput(title, height, line, onChange, text) {
    TextEditingController inputController = TextEditingController();
    inputController.text = text;
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
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  width: 400,
                  height: height,
                  child: Column(
                    children: [
                      TextField(
                        maxLines: line,
                        minLines: line,
                        controller: inputController,
                        onChanged: (value) {
                          onChange(value);
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(top: 0, left: 0),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 1.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
