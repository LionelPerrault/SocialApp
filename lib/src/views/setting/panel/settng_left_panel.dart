import 'package:flutter/material.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';

import '../../../widget/admin_list_text.dart';

// ignore: must_be_immutable
class SettingsLeftPanel extends StatelessWidget {
  SettingsLeftPanel({super.key, required this.onClick});
  Function onClick;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30),
      width: SizeConfig.leftBarAdminWidth,
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Column(
          children: [
            ListText(
                onTap: () => {onClick('account_page')},
                label: 'Account Settings',
                icon: const Icon(
                  Icons.settings,
                  color: Color.fromARGB(255, 94, 114, 228),
                )),
            ExpansionTileTheme(
              data: const ExpansionTileThemeData(),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.all(0),
                title: Row(
                  children: const [
                    Padding(padding: EdgeInsets.only(left: 43)),
                    const Icon(
                      Icons.person,
                      color: Color.fromARGB(255, 43, 83, 164),
                    ),
                    Padding(padding: EdgeInsets.only(left: 10)),
                    Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    )
                  ],
                ),
                children: <Widget>[
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 15.0),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListText(
                              onTap: () => {onClick('basic')},
                              label: 'Basic',
                              icon: const Icon(null)),
                          ListText(
                              onTap: () => {onClick('work')},
                              label: 'Work',
                              icon: const Icon(null)),
                          ListText(
                              onTap: () => {onClick('location')},
                              label: 'Location',
                              icon: const Icon(null)),
                          ListText(
                              onTap: () => {onClick('education')},
                              label: 'Education',
                              icon: const Icon(null)),
                          ListText(
                              onTap: () => {onClick('social')},
                              label: 'Social Links',
                              icon: const Icon(null)),
                          ListText(
                              onTap: () => {onClick('interests')},
                              label: 'Interests',
                              icon: const Icon(null)),
                          ListText(
                              onTap: () => {onClick('design')},
                              label: 'Design',
                              icon: const Icon(null)),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            ExpansionTileTheme(
              data: const ExpansionTileThemeData(),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.all(0),
                title: Row(
                  children: const [
                    Padding(padding: EdgeInsets.only(left: 43)),
                    const Icon(
                      Icons.security,
                      color: Color.fromARGB(255, 139, 195, 74),
                    ),
                    Padding(padding: EdgeInsets.only(left: 10)),
                    Text(
                      'Security Settings',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    )
                  ],
                ),
                children: <Widget>[
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 15.0),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListText(
                              onTap: () => {onClick('security_password')},
                              label: 'Password',
                              icon: const Icon(null)),
                          // ListText(
                          //   onTap: () => {
                          //     onClick('security_session')
                          //   },
                          //   label: 'Manage Sessions',
                          //   icon:
                          //       const Icon(null)),
                          // ListText(
                          //   onTap: () => {},
                          //   label: 'Two-Factor Authentication',
                          //   icon:
                          //       const Icon(null)),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            ListText(
                onTap: () => {onClick('privacy')},
                label: 'Privacy',
                icon: const Icon(
                  Icons.privacy_tip_rounded,
                  color: Color.fromARGB(255, 255, 179, 7),
                )),
            ListText(
                onTap: () => {
                      // Navigator.of(context).pop(true),
                      onClick('notification')
                    },
                label: 'Notification',
                icon: const Icon(
                  Icons.notifications,
                  color: Color.fromARGB(255, 103, 58, 183),
                )),
            ListText(
                onTap: () => {onClick('shnatter_token')},
                label: 'Shnatter Token',
                icon: const Icon(Icons.attach_money,
                    color: Color.fromARGB(255, 76, 175, 80))),
            // ListText(
            //     onTap: () => {onClick('paywall')},
            //     label: 'Paywall for User',
            //     icon: const Icon(Icons.money_sharp,
            //         color: Color.fromARGB(255, 76, 175, 80))),
            ListText(
                onTap: () => {onClick('verification')},
                label: 'Verification',
                icon: const Icon(
                  Icons.check_circle,
                  color: Color.fromARGB(255, 33, 150, 243),
                )),
            // ListText(
            //     onTap: () => {onClick('information')},
            //     label: 'Your Information',
            //     icon: const Icon(
            //       Icons.file_present,
            //       color: Color.fromARGB(255, 40, 167, 69),
            //     )),
            ListText(
                onTap: () => {onClick('delete')},
                label: 'Delete Account',
                icon: const Icon(
                  Icons.delete,
                  color: Color.fromARGB(255, 244, 67, 54),
                )),
          ],
        ),
      ),
    );
  }
}
