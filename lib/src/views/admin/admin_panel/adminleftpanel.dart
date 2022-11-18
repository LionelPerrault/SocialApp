
import 'package:flutter/material.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';

import '../../../widget/admin_list_text.dart';

// ignore: must_be_immutable
class AdminLeftPanel extends StatelessWidget {
  AdminLeftPanel(
      {super.key,required this.onClick});
  Function onClick;
  @override
  Widget build(BuildContext context) {
    return 
    Container(
      width: SizeConfig.leftBarAdminWidth,
      child: 
       Padding(padding: const EdgeInsets.only(top: 5.0),
            child: 
            Column(
            children: [
              Row(children: const [
                Padding(padding: EdgeInsets.only(left: 30.0)),
                Text('SYSTEM',
                    style: TextStyle(
                        color: Color.fromARGB(255, 150, 150, 150),
                        fontSize: 10)),
              ]),
              ListText(
                  onTap: () => {},
                  label: 'Dashboard',
                  icon:
                      const Icon(Icons.dashboard)),
              ExpansionTileTheme(
                data:const ExpansionTileThemeData(),
                child: ExpansionTile(
                tilePadding: const EdgeInsets.all(0),
                title: 
                Row(children: const [
                  Padding(padding: EdgeInsets.only(left: 43)),
                  Icon(Icons.settings, size: 28,),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Text('Settings', style: TextStyle(
                    fontSize: 13,
                  ),)
                ],),
                children: <Widget>[
                  Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 15.0),),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListText(
                            onTap: () => {},
                            label: 'System Settings',
                            icon:
                                const Icon(Icons.settings_suggest_outlined)),
                          ListText(
                            onTap: () => {},
                            label: 'Posts Settings',
                            icon:
                                const Icon(Icons.message_rounded)),
                          ListText(
                            onTap: () => {},
                            label: 'Registration Settings',
                            icon:
                                const Icon(Icons.input_outlined)),
                          ListText(
                            onTap: () => {},
                            label: 'Accounts Settings',
                            icon:
                                const Icon(Icons.manage_accounts)),
                          ListText(
                            onTap: () => {},
                            label: 'Email Settings',
                            icon:
                                const Icon(Icons.mail)),
                          ListText(
                            onTap: () => {},
                            label: 'SMS Settings',
                            icon:
                                const Icon(Icons.sms)),
                          ListText(
                            onTap: () => {},
                            label: 'Notification Settings',
                            icon:
                                const Icon(Icons.notifications)),
                          ListText(
                            onTap: () => {
                              onClick('/settings/chat')
                            },
                            label: 'Chat Settings',
                            icon:
                                const Icon(Icons.message_rounded)),
                          ListText(
                            onTap: () => {
                              onClick('/settings/live')
                            },
                            label: 'Live Stream Settings',
                            icon:
                                const Icon(Icons.network_cell_rounded)),
                          ListText(
                            onTap: () => {},
                            label: 'Uploads Settings',
                            icon:
                                const Icon(Icons.file_upload_rounded)),
                          ListText(
                            onTap: () => {},
                            label: 'Payments Settings',
                            icon:
                                const Icon(Icons.credit_card)),
                          ListText(
                            onTap: () => {
                              onClick('/settings/security')
                            },
                            label: 'Security Settings',
                            icon:
                                const Icon(Icons.security_rounded)),
                          ListText(
                            onTap: () => {
                              onClick('/settings/limits')
                            },
                            label: 'Limits Settings',
                            icon:
                                const Icon(Icons.iso_rounded)),
                          ListText(
                            onTap: () => {
                              onClick('/settings/analystics')
                            },
                            label: 'Analytics Settings',
                            icon:
                                const Icon(Icons.pie_chart)),
                            
                        ],
                      )
                    ],
                  )
                ],
                ),
              ),
              
              ListText(
                  onTap: () => {},
                  label: 'Themes',
                  icon:
                      const Icon(Icons.display_settings)),
              ListText(
                  onTap: () => {},
                  label: 'Design',
                  icon:
                      const Icon(Icons.display_settings_rounded)),
              ListText(
                onTap: () => {},
                label: 'Languages',
                icon:
                    const Icon(Icons.brush)),
              ListText(
                onTap: () => {},
                label: 'Countries',
                icon:
                    const Icon(Icons.abc)),
              ListText(
                onTap: () => {},
                label: 'Currencies',
                icon:
                    const Icon(Icons.language)),
              ListText(
                onTap: () => {},
                label: 'Shnatter token',
                icon:
                    const Icon(Icons.money_rounded)),
              ListText(
                onTap: () => {},
                label: 'Manage prices',
                icon:
                    const Icon(Icons.money_rounded)),
              ListText(
                onTap: () => {},
                label: 'Genders',
                icon:
                    const Icon(Icons.roundabout_left_sharp)),
              ListText(
                onTap: () => {},
                label: 'Webmail',
                icon:
                    const Icon(Icons.roundabout_left)),
              Row(children: const [
                Padding(padding: EdgeInsets.only(left: 30.0)),
                Text('MODELS',
                    style: TextStyle(
                        color: Color.fromARGB(255, 150, 150, 150),
                        fontSize: 10)),
              ]),
              ExpansionTileTheme(
                data:const ExpansionTileThemeData(),
                child: ExpansionTile(
                tilePadding: const EdgeInsets.all(0),
                title: ListText(
                  onTap: () => {},
                  label: 'Users',
                  icon:
                      const Icon(Icons.person)),
            
                children: <Widget>[
                  Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 15.0),),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListText(
                            onTap: () => {},
                            label: 'List Users',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {},
                            label: 'List Admins',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {},
                            label: 'List Moderators',
                            icon:
                                const Icon(null)),
                            ListText(
                            onTap: () => {},
                            label: 'List online',
                            icon:
                                const Icon(null)),
                            ListText(
                            onTap: () => {},
                            label: 'List Banned',
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
                  label: 'Posts',
                  icon:
                      const Icon(Icons.post_add)),
              ExpansionTileTheme(
                data:const ExpansionTileThemeData(),
                child: ExpansionTile(
                tilePadding: const EdgeInsets.all(0),
                title: ListText(
                  onTap: () => {},
                  label: 'Pages',
                  icon:
                      const Icon(Icons.flag)),
            
                children: <Widget>[
                  Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 15.0),),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListText(
                            onTap: () => {},
                            label: 'List Pages',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {},
                            label: 'List Categories',
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
                  label: 'Groups',
                  icon:
                      const Icon(Icons.groups)),
            
                children: <Widget>[
                  Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 15.0),),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListText(
                            onTap: () => {},
                            label: 'List Groups',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {},
                            label: 'List Categories',
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
                  label: 'Events',
                  icon:
                      const Icon(Icons.event)),
            
                children: <Widget>[
                  Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 15.0),),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListText(
                            onTap: () => {},
                            label: 'List Events',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {},
                            label: 'List Categories',
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
                  label: 'Blogs',
                  icon:
                      const Icon(Icons.article)),
            
                children: <Widget>[
                  Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 15.0),),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListText(
                            onTap: () => {},
                            label: 'List Articles',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {},
                            label: 'List Categories',
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
                  label: 'Marketplace',
                  icon:
                      const Icon(Icons.card_travel)),
            
                children: <Widget>[
                  Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 15.0),),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListText(
                            onTap: () => {},
                            label: 'List Categories',
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
                  label: 'Offers',
                  icon:
                      const Icon(Icons.forward)),
            
                children: <Widget>[
                  Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 15.0),),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListText(
                            onTap: () => {},
                            label: 'List Offers',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {},
                            label: 'List Categories',
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
                  label: 'Jobs',
                  icon:
                      const Icon(Icons.card_travel)),
            
                children: <Widget>[
                  Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 15.0),),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListText(
                            onTap: () => {},
                            label: 'List Jobs',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {},
                            label: 'List Categories',
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
                  label: 'Forums',
                  icon:
                      const Icon(Icons.comment_bank)),
            
                children: <Widget>[
                  Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 15.0),),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListText(
                            onTap: () => {},
                            label: 'List Forums',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {},
                            label: 'List Threads',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {},
                            label: 'List Replies',
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
                  label: 'Movies',
                  icon:
                      const Icon(Icons.movie_filter_outlined)),
            
                children: <Widget>[
                  Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 15.0),),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListText(
                            onTap: () => {},
                            label: 'List Movies',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {},
                            label: 'List Genres',
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
                  label: 'Games',
                  icon:
                      const Icon(Icons.games_rounded)),
              Row(children: const [
                Padding(padding: EdgeInsets.only(left: 30.0)),
                Text('MONEY',
                    style: TextStyle(
                        color: Color.fromARGB(255, 150, 150, 150),
                        fontSize: 10)),
              ]),
              ExpansionTileTheme(
                data:const ExpansionTileThemeData(),
                child: ExpansionTile(
                tilePadding: const EdgeInsets.all(0),
                title: ListText(
                  onTap: () => {},
                  label: 'Ads',
                  icon:
                      const Icon(Icons.attach_money)),
            
                children: <Widget>[
                  Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 15.0),),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListText(
                            onTap: () => {},
                            label: 'Ads Settings',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {},
                            label: 'List Users Ads',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {},
                            label: 'List System Ads',
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
                  label: 'Wallet',
                  icon:
                      const Icon(Icons.wallet)),
            
                children: <Widget>[
                  Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 15.0),),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListText(
                            onTap: () => {},
                            label: 'Wallet Settings',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {},
                            label: 'Payment Requests',
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
                  label: 'Pro System',
                  icon:
                      const Icon(Icons.square)),
            
                children: <Widget>[
                  Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 15.0),),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListText(
                            onTap: () => {},
                            label: 'Pro Settings',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {},
                            label: 'List Packages',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {},
                            label: 'List Subscribers',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {},
                            label: 'Earnings',
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
                  label: 'Affiliates',
                  icon:
                      const Icon(Icons.currency_exchange)),
            
                children: <Widget>[
                  Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 15.0),),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListText(
                            onTap: () => {},
                            label: 'Affiliates Settings',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {},
                            label: 'Payment Requests',
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
                  label: 'Points System',
                  icon:
                      const Icon(Icons.system_security_update_outlined)),
            
                children: <Widget>[
                  Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 15.0),),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListText(
                            onTap: () => {},
                            label: 'Points Settings',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {},
                            label: 'Payment Requests',
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
                  label: 'Fundings',
                  icon:
                      const Icon(Icons.attach_money)),
            
                children: <Widget>[
                  Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 15.0),),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListText(
                            onTap: () => {},
                            label: 'Funding Settings',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {},
                            label: 'Payment Requests',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {},
                            label: 'Funding Requests',
                            icon:
                                const Icon(null)),
                          
                        ],
                      )
                    ],
                  )
                ],
                ),
              ),
              Row(children: const [
                Padding(padding: EdgeInsets.only(left: 30.0)),
                Text('PAYMENTS',
                    style: TextStyle(
                        color: Color.fromARGB(255, 150, 150, 150),
                        fontSize: 10)),
              ]),
              ListText(
                  onTap: () => {},
                  label: 'CoinPayments',
                  icon:
                      const Icon(Icons.currency_bitcoin)),
              ListText(
                  onTap: () => {},
                  label: 'Bank Receipts',
                  icon:
                      const Icon(Icons.vertical_shades_closed_sharp)),
              Row(children: const [
                Padding(padding: EdgeInsets.only(left: 30.0)),
                Text('DEVELOPERS',
                    style: TextStyle(
                        color: Color.fromARGB(255, 150, 150, 150),
                        fontSize: 10)),
              ]),
              
              ExpansionTileTheme(
                data:const ExpansionTileThemeData(),
                child: ExpansionTile(
                tilePadding: const EdgeInsets.all(0),
                title: ListText(
                  onTap: () => {},
                  label: 'Developers',
                  icon:
                      const Icon(Icons.square_foot)),
            
                children: <Widget>[
                  Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 15.0),),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListText(
                            onTap: () => {},
                            label: 'Developers Settings',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {},
                            label: 'List Apps',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {},
                            label: 'List Categories',
                            icon:
                                const Icon(null)),
                          
                        ],
                      )
                    ],
                  )
                ],
                ),
              ),
              Row(children: const [
                Padding(padding: EdgeInsets.only(left: 30.0)),
                Text('TOOLS',
                    style: TextStyle(
                        color: Color.fromARGB(255, 150, 150, 150),
                        fontSize: 10)),
              ]),
              ListText(
                  onTap: () => {},
                  label: 'Reports',
                  icon:
                      const Icon(Icons.warning)),
              ListText(
                  onTap: () => {},
                  label: 'Blacklist',
                  icon:
                      const Icon(Icons.remove_circle)),
              ExpansionTileTheme(
                data:const ExpansionTileThemeData(),
                child: ExpansionTile(
                tilePadding: const EdgeInsets.all(0),
                title: ListText(
                  onTap: () => {},
                  label: 'Verification',
                  icon:
                      const Icon(Icons.check_circle)),
            
                children: <Widget>[
                  Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 15.0),),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListText(
                            onTap: () => {},
                            label: 'List Requests',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {},
                            label: 'List Verified Users',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {},
                            label: 'List Verified Pages',
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
                  label: 'Tools',
                  icon:
                      const Icon(Icons.badge_rounded)),
            
                children: <Widget>[
                  Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 15.0),),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListText(
                            onTap: () => {},
                            label: 'Fake Generator',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {},
                            label: 'Auto Connect',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {},
                            label: 'Garbage Collector',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {},
                            label: 'Backup Database & Files',
                            icon:
                                const Icon(null)),
                          ListText(
                            onTap: () => {},
                            label: 'Factory Reset',
                            icon:
                                const Icon(null)),
                        ],
                      )
                    ],
                  )
                ],
                ),
              ),
              Row(children: const [
                Padding(padding: EdgeInsets.only(left: 30.0)),
                Text('CUSTOMIZATION',
                    style: TextStyle(
                        color: Color.fromARGB(255, 150, 150, 150),
                        fontSize: 10)),
              ]),
              ListText(
                  onTap: () => {},
                  label: 'Custom Fields',
                  icon:
                      const Icon(Icons.line_weight)),
              ListText(
                  onTap: () => {},
                  label: 'Static Pages',
                  icon:
                      const Icon(Icons.find_in_page_rounded)),
              ListText(
                  onTap: () => {},
                  label: 'Colored Posts',
                  icon:
                      const Icon(Icons.color_lens)),
              ListText(
                  onTap: () => {},
                  label: 'Widgets',
                  icon:
                      const Icon(Icons.widgets)),
              ListText(
                  onTap: () => {},
                  label: 'Emojis',
                  icon:
                      const Icon(Icons.emoji_emotions)),
              ListText(
                  onTap: () => {},
                  label: 'Stickers',
                  icon:
                      const Icon(Icons.back_hand)),
              ListText(
                  onTap: () => {},
                  label: 'Gifts',
                  icon:
                      const Icon(Icons.card_giftcard)),
              Row(children: const [
                Padding(padding: EdgeInsets.only(left: 30.0)),
                Text('REACH',
                    style: TextStyle(
                        color: Color.fromARGB(255, 150, 150, 150),
                        fontSize: 10)),
              ]),
              ListText(
                  onTap: () => {},
                  label: 'Announcements',
                  icon:
                      const Icon(Icons.announcement)),
              ListText(
                  onTap: () => {},
                  label: 'Mass Notifications',
                  icon:
                      const Icon(Icons.notification_important_rounded)),
              ListText(
                  onTap: () => {},
                  label: 'Newsletter',
                  icon:
                      const Icon(Icons.arrow_right_alt_sharp)),
              Row(children: const [
                Padding(padding: EdgeInsets.only(left: 30.0)),
                Text('SINGLE',
                    style: TextStyle(
                        color: Color.fromARGB(255, 150, 150, 150),
                        fontSize: 10)),
              ]),
              ListText(
                  onTap: () => {},
                  label: 'Changelog',
                  icon:
                      const Icon(Icons.lock_clock)),
              ListText(
                  onTap: () => {},
                  label: 'Build v3.4',
                  icon:
                      const Icon(Icons.copyright)),
            ],
          ),
           
        ),
    );
   
  }
}