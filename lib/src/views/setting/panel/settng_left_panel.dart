
import 'package:flutter/material.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';

import '../../../widget/admin_list_text.dart';

// ignore: must_be_immutable
class SettingsLeftPanel extends StatelessWidget {
  const SettingsLeftPanel(
      {super.key});
  @override
  Widget build(BuildContext context) {
    return 
    Container(
      padding: const EdgeInsets.only(top: 30),
      width: SizeConfig.leftBarAdminWidth,
      child: 
       Padding(padding: const EdgeInsets.only(top: 5.0),
            child: 
            Column(
            children: [
              ListText(
                  onTap: () => {Navigator
                    .pushReplacementNamed(
                        context,
                        RouteNames
                            .settings)},
                  label: 'Account Settings',
                  icon:
                      const Icon(Icons.settings, color: Color.fromARGB(255, 94, 114, 228),)),
              ExpansionTileTheme(
                data:const ExpansionTileThemeData(),
                child: ExpansionTile(
                tilePadding: const EdgeInsets.all(0),
                title: ListText(
                  onTap: () => {},
                  label: 'Edit Profile',
                  icon:
                      const Icon(Icons.person, color: Color.fromARGB(255, 43, 83, 164),)),
            
                children: <Widget>[
                  Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 15.0),),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListText(
                            onTap: () => {Navigator
                                          .pushReplacementNamed(
                                              context,
                                              RouteNames
                                                  .settings_profile_basic)},
                            label: 'Basic',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {Navigator
                                          .pushReplacementNamed(
                                              context,
                                              RouteNames
                                                  .settings_profile_work)},
                            label: 'Work',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {Navigator
                                          .pushReplacementNamed(
                                              context,
                                              RouteNames
                                                  .settings_profile_location)},
                            label: 'Location',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {Navigator
                                          .pushReplacementNamed(
                                              context,
                                              RouteNames
                                                  .settings_profile_education)},
                            label: 'Education',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {Navigator
                                          .pushReplacementNamed(
                                              context,
                                              RouteNames
                                                  .settings_profile_social)},
                            label: 'Social Links',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {Navigator
                                          .pushReplacementNamed(
                                              context,
                                              RouteNames
                                                  .settings_profile_interests)},
                            label: 'Interests',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {Navigator
                                          .pushReplacementNamed(
                                              context,
                                              RouteNames
                                                  .settings_profile_design)},
                            label: 'Design',
                            icon:
                                const Icon(null)),
                        ],
                      )
                    ],
                  )
                ],
                ),
              ),
              
              ExpansionTileTheme(
                data:const ExpansionTileThemeData(),
                child: ExpansionTile(
                tilePadding: const EdgeInsets.all(0),
                title: ListText(
                  onTap: () => {},
                  label: 'Security Settings',
                  icon:
                      const Icon(Icons.security, color: Color.fromARGB(255, 139, 195, 74),)),
            
                children: <Widget>[
                  Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 15.0),),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListText(
                            onTap: () => {Navigator
                                          .pushReplacementNamed(
                                              context,
                                              RouteNames
                                                  .security_password)},
                            label: 'Password',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {Navigator
                                          .pushReplacementNamed(
                                              context,
                                              RouteNames
                                                  .security_sessions)},
                            label: 'Manage Sessions',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {},
                            label: 'Two-Factor Authentication',
                            icon:
                                const Icon(null)),
                        ],
                      )
                    ],
                  )
                ],
                ),
              ),
              ListText(
                  onTap: () => {},
                  label: 'Privacy',
                  icon:
                      const Icon(Icons.privacy_tip_rounded, color: Color.fromARGB(255, 255, 179, 7),)),
              ListText(
                  onTap: () => {},
                  label: 'Notification',
                  icon:
                      const Icon(Icons.notifications, color: Color.fromARGB(255, 103, 58, 183),)),
              ListText(
                onTap: () => {},
                label: 'Shnatter Token',
                icon:
                    const Icon(Icons.money, color: Color.fromARGB(255, 76, 175, 80))),
              ListText(
                onTap: () => {},
                label: 'Verification',
                icon:
                    const Icon(Icons.check_circle, color: Color.fromARGB(255, 33, 150, 243),)),
              ListText(
                onTap: () => {},
                label: 'Your Information',
                icon:
                    const Icon(Icons.file_present, color: Color.fromARGB(255, 40, 167, 69),)),
              ListText(
                onTap: () => {},
                label: 'Delete Account',
                icon:
                    const Icon(Icons.delete,color: Color.fromARGB(255, 244, 67, 54),)),
            ],
          ),
           
        ),
    );
   
  }
}