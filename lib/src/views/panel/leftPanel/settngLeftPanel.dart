import 'package:flutter/material.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/widget/list_text.dart';

// ignore: must_be_immutable
class SettingsLeftPanel extends StatelessWidget {
  SettingsLeftPanel({super.key, required this.routerFunction});
  Function routerFunction;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30),
      width: SizeConfig.leftBarAdminWidth,
      child: Column(
        children: [
          ListText(
              onTap: () => {
                    routerFunction({
                      'router': RouteNames.settings,
                      'subRouter': '',
                    })
                  },
              label: 'Account Settings',
              image: const Icon(
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
                  Icon(
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
                        Container(
                          width: 220,
                          child: ListText(
                              onTap: () => {
                                    routerFunction({
                                      'router': RouteNames.settings,
                                      'subRouter':
                                          RouteNames.settings_profile_basic,
                                    })
                                  },
                              label: 'Basic',
                              image: const SizedBox()),
                        ),
                        Container(
                            width: 220,
                            child: ListText(
                                onTap: () => {
                                      routerFunction({
                                        'router': RouteNames.settings,
                                        'subRouter':
                                            RouteNames.settings_profile_work,
                                      })
                                    },
                                label: 'Work',
                                image: const SizedBox())),
                        Container(
                            width: 220,
                            child: ListText(
                                onTap: () => {
                                      routerFunction({
                                        'router': RouteNames.settings,
                                        'subRouter': RouteNames
                                            .settings_profile_location,
                                      })
                                    },
                                label: 'Location',
                                image: const SizedBox())),
                        Container(
                            width: 220,
                            child: ListText(
                                onTap: () => {
                                      routerFunction({
                                        'router': RouteNames.settings,
                                        'subRouter': RouteNames
                                            .settings_profile_education,
                                      })
                                    },
                                label: 'Education',
                                image: const SizedBox())),
                        Container(
                            width: 220,
                            child: ListText(
                                onTap: () => {
                                      routerFunction({
                                        'router': RouteNames.settings,
                                        'subRouter':
                                            RouteNames.settings_profile_social,
                                      })
                                    },
                                label: 'Social Links',
                                image: const SizedBox())),
                        Container(
                            width: 220,
                            child: ListText(
                                onTap: () => {
                                      routerFunction({
                                        'router': RouteNames.settings,
                                        'subRouter': RouteNames
                                            .settings_profile_interests,
                                      })
                                    },
                                label: 'Interests',
                                image: const SizedBox())),
                        Container(
                            width: 220,
                            child: ListText(
                                onTap: () => {
                                      routerFunction({
                                        'router': RouteNames.settings,
                                        'subRouter':
                                            RouteNames.settings_profile_design,
                                      })
                                    },
                                label: 'Design',
                                image: const SizedBox())),
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
                  Icon(
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
                        Container(
                            width: 220,
                            child: ListText(
                                onTap: () => {
                                      routerFunction({
                                        'router': RouteNames.settings,
                                        'subRouter': RouteNames
                                            .settings_security_password,
                                      })
                                    },
                                label: 'Password',
                                image: const SizedBox())),
                        // ListText(
                        //   onTap: () => {
                        //     routerFunction('security_session')
                        //   },
                        //   label: 'Manage Sessions',
                        //   icon:
                        //       const SizedBox()),
                        Container(
                            width: 220,
                            child: ListText(
                                onTap: () => {
                                      routerFunction({
                                        'router': RouteNames.settings,
                                        'subRouter':
                                            RouteNames.settings_two_factor,
                                      })
                                    },
                                label: 'Two-Factor Auth',
                                image: const SizedBox())),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          ListText(
              onTap: () => {
                    routerFunction({
                      'router': RouteNames.settings,
                      'subRouter': RouteNames.settings_privacy,
                    })
                  },
              label: 'Privacy',
              image: const Icon(
                Icons.privacy_tip_rounded,
                color: Color.fromARGB(255, 255, 179, 7),
              )),
          ListText(
              onTap: () => {
                    routerFunction({
                      'router': RouteNames.settings,
                      'subRouter': RouteNames.settings_notifications,
                    })
                  },
              label: 'Notification',
              image: const Icon(
                Icons.notifications,
                color: Color.fromARGB(255, 103, 58, 183),
              )),
          ListText(
              onTap: () => {
                    routerFunction({
                      'router': RouteNames.settings,
                      'subRouter': RouteNames.settings_token,
                    })
                  },
              label: 'Shnatter Token',
              image: const Icon(Icons.attach_money,
                  color: Color.fromARGB(255, 76, 175, 80))),
          // ListText(
          //     onTap: () => {routerFunction('paywall')},
          //     label: 'Paywall for User',
          //     image: const Icon(Icons.money_sharp,
          //         color: Color.fromARGB(255, 76, 175, 80))),
          // ListText(
          //     onTap: () => {
          //           routerFunction({
          //             'router': RouteNames.settings,
          //             'subRouter': RouteNames.settings_verification,
          //           })
          //         },
          //     label: 'Verification',
          //     image: const Icon(
          //       Icons.check_circle,
          //       color: Color.fromARGB(255, 33, 150, 243),
          //     )),
          // ListText(
          //     onTap: () => {routerFunction('information')},
          //     label: 'Your Information',
          //     image: const Icon(
          //       Icons.file_present,
          //       color: Color.fromARGB(255, 40, 167, 69),
          //     )),
          ListText(
              onTap: () => {
                    routerFunction({
                      'router': RouteNames.settings,
                      'subRouter': RouteNames.settings_delete,
                    })
                  },
              label: 'Delete Account',
              image: const Icon(
                Icons.delete,
                color: Color.fromARGB(255, 244, 67, 54),
              )),
        ],
      ),
    );
  }
}
