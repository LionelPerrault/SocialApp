import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/utils/size_config.dart';

import 'package:shnatter/src/views/admin/admin_panel/widget/setting_header.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

// ignore: must_be_immutable
class AdminSettingsSystem extends StatefulWidget {
  const AdminSettingsSystem({super.key});

  @override
  State createState() => AdminSettingsSystemState();
}

class AdminSettingsSystemState extends mvc.StateMVC<AdminSettingsSystem> {
  @override
  void initState() {
    super.initState();
    headerTab = [
      {
        'icon': Icons.safety_check,
        'title': 'General',
        'onClick': (value) {
          tabTitle = value;
          setState(() {});
        }
      },
      {
        'icon': Icons.map,
        'title': 'SEO',
        'onClick': (value) {
          tabTitle = value;
          setState(() {});
        }
      },
      {
        'icon': Icons.mode,
        'title': 'Modules',
        'onClick': (value) {
          tabTitle = value;
          setState(() {});
        }
      },
      {
        'icon': Icons.featured_play_list,
        'title': 'Features',
        'onClick': (value) {
          tabTitle = value;
          setState(() {});
        }
      }
    ];
  }

  bool check1 = false;
  Color fontColor = const Color.fromRGBO(82, 95, 127, 1);
  double fontSize = 14;
  String tabTitle = 'General';
  late var headerTab;
  List<Map> dateTimeArr = [
    {'value': 'd/m/y', 'title': 'd/m/Y H:i (Example: 30/05/2019 17:30)'},
    {'value': 'm/d/y', 'title': 'm/d/Y H:i (Example: 05/30/2019 17:30)'}
  ];
  List<Map> distanceArr = [
    {'value': 'Kilometer', 'title': 'Kilometer'},
    {'value': 'Mile', 'title': 'Mile'},
  ];
  List<Map> currency = [
    {'value': 'Australia Dollar', 'title': 'Australia Dollar'},
    {'value': 'Brazil Real (BRL)', 'title': 'Brazil Real (BRL)'},
    {'value': 'Canada Dollar (CAD)', 'title': 'Canada Dollar (CAD)'},
    {
      'value': 'Czech Republic Koruna (CZK)',
      'title': 'Czech Republic Koruna (CZK)'
    },
    {'value': 'Denmark Krone (DKK)', 'title': 'Denmark Krone (DKK)'},
    {'value': 'Euro (EUR)', 'title': 'Euro (EUR)'},
    {'value': 'Hong Kong Dollar (HKD)', 'title': 'Hong Kong Dollar (HKD)'},
    {'value': 'Hungary Forint (HUF)', 'title': 'Hungary Forint (HUF)'},
    {'value': 'Israel Shekel (ILS)', 'title': 'Israel Shekel (ILS)'},
    {'value': 'Japan Yen (JPY)', 'title': 'Japan Yen (JPY)'},
    {'value': 'Malaysia Ringgit (MYR)', 'title': 'Malaysia Ringgit (MYR)'},
    {'value': 'Mexico Peso (MXN)', 'title': 'Mexico Peso (MXN)'},
    {'value': 'Norway Krone (NOK)', 'title': 'Norway Krone (NOK)'},
    {'value': 'New Zealand Dollar (NZD)', 'title': 'New Zealand Dollar (NZD)'},
    {'value': 'Philippines Peso (PHP)', 'title': 'Philippines Peso (PHP)'},
    {'value': 'Poland Zloty (PLN)', 'title': 'Poland Zloty (PLN)'},
    {
      'value': 'United Kingdom Pound (GBP)',
      'title': 'United Kingdom Pound (GBP)'
    },
    {'value': 'Russia Ruble (RUB)', 'title': 'Russia Ruble (RUB)'},
    {'value': 'Singapore Dollar (SGD)', 'title': 'Singapore Dollar (SGD)'},
    {'value': 'Sweden Krona (SEK)', 'title': 'Sweden Krona (SEK)'},
    {'value': 'Switzerland Franc (CHF)', 'title': 'Switzerland Franc (CHF)'},
    {'value': 'Thailand Baht (THB)', 'title': 'Thailand Baht (THB)'},
    {'value': 'Turkey Lira (TRY)', 'title': 'Turkey Lira (TRY)'},
    {
      'value': 'United States Dollar (USD)',
      'title': 'United States Dollar (USD)'
    },
    {'value': 'Shnatter token (SHN)', 'title': 'Shnatter token (SHN)'},
  ];
  List<Map> directionCurrency = [
    {'value': 'left', 'title': 'left'},
    {'value': 'right', 'title': 'right'},
  ];
  List<Map> pagesDropDown = [
    {
      'value': 'everyone',
      'title': 'Everyone',
      'subtitle': 'Any user in the system can',
      'icon': Icons.language
    },
    {
      'value': 'Verified Users',
      'title': 'Verified Users',
      'subtitle': 'Only Admins, Moderators, Pro and Verified Users',
      'icon': Icons.check_circle
    },
    {
      'value': 'Pro Users',
      'title': 'Pro Users',
      'subtitle': 'Any user in the system can',
      'icon': Icons.rocket
    },
    {
      'value': 'Admin',
      'title': 'Admin',
      'subtitle': 'Only Admins and Moderators',
      'icon': Icons.lock
    },
  ];
  List<Map> groupsDropDown = [
    {
      'value': 'everyone',
      'title': 'Everyone',
      'subtitle': 'Any user in the system can',
      'icon': Icons.language
    },
    {
      'value': 'Verified Users',
      'title': 'Verified Users',
      'subtitle': 'Only Admins, Moderators, Pro and Verified Users',
      'icon': Icons.check_circle
    },
    {
      'value': 'Pro Users',
      'title': 'Pro Users',
      'subtitle': 'Any user in the system can',
      'icon': Icons.rocket
    },
    {
      'value': 'Admin',
      'title': 'Admin',
      'subtitle': 'Only Admins and Moderators',
      'icon': Icons.lock
    },
  ];
  List<Map> eventsDropDown = [
    {
      'value': 'everyone',
      'title': 'Everyone',
      'subtitle': 'Any user in the system can',
      'icon': Icons.language
    },
    {
      'value': 'Verified Users',
      'title': 'Verified Users',
      'subtitle': 'Only Admins, Moderators, Pro and Verified Users',
      'icon': Icons.check_circle
    },
    {
      'value': 'Pro Users',
      'title': 'Pro Users',
      'subtitle': 'Any user in the system can',
      'icon': Icons.rocket
    },
    {
      'value': 'Admin',
      'title': 'Admin',
      'subtitle': 'Only Admins and Moderators',
      'icon': Icons.lock
    },
  ];
  List<Map> peopleDropDown = [
    {
      'value': 'everyone',
      'title': 'Everyone',
      'subtitle': 'Any user in the system can',
      'icon': Icons.language
    },
    {
      'value': 'Verified Users',
      'title': 'Verified Users',
      'subtitle': 'Only Admins, Moderators, Pro and Verified Users',
      'icon': Icons.check_circle
    },
    {
      'value': 'Pro Users',
      'title': 'Pro Users',
      'subtitle': 'Any user in the system can',
      'icon': Icons.rocket
    },
    {
      'value': 'Admin',
      'title': 'Admin',
      'subtitle': 'Only Admins and Moderators',
      'icon': Icons.lock
    },
  ];
  List<Map> blogsDropDown = [
    {
      'value': 'everyone',
      'title': 'Everyone',
      'subtitle': 'Any user in the system can',
      'icon': Icons.language
    },
    {
      'value': 'Verified Users',
      'title': 'Verified Users',
      'subtitle': 'Only Admins, Moderators, Pro and Verified Users',
      'icon': Icons.check_circle
    },
    {
      'value': 'Pro Users',
      'title': 'Pro Users',
      'subtitle': 'Any user in the system can',
      'icon': Icons.rocket
    },
    {
      'value': 'Admin',
      'title': 'Admin',
      'subtitle': 'Only Admins and Moderators',
      'icon': Icons.lock
    },
  ];
  List<Map> marketPlaceDropDown = [
    {
      'value': 'everyone',
      'title': 'Everyone',
      'subtitle': 'Any user in the system can',
      'icon': Icons.language
    },
    {
      'value': 'Verified Users',
      'title': 'Verified Users',
      'subtitle': 'Only Admins, Moderators, Pro and Verified Users',
      'icon': Icons.check_circle
    },
    {
      'value': 'Pro Users',
      'title': 'Pro Users',
      'subtitle': 'Any user in the system can',
      'icon': Icons.rocket
    },
    {
      'value': 'Admin',
      'title': 'Admin',
      'subtitle': 'Only Admins and Moderators',
      'icon': Icons.lock
    },
  ];
  List<Map> statisticsDropDown = [
    {
      'value': 'everyone',
      'title': 'Everyone',
      'subtitle': 'Any user in the system can',
      'icon': Icons.language
    },
    {
      'value': 'Verified Users',
      'title': 'Verified Users',
      'subtitle': 'Only Admins, Moderators, Pro and Verified Users',
      'icon': Icons.check_circle
    },
    {
      'value': 'Pro Users',
      'title': 'Pro Users',
      'subtitle': 'Any user in the system can',
      'icon': Icons.rocket
    },
    {
      'value': 'Admin',
      'title': 'Admin',
      'subtitle': 'Only Admins and Moderators',
      'icon': Icons.lock
    },
  ];
  List<Map> moviesDropDown = [
    {
      'value': 'everyone',
      'title': 'Everyone',
      'subtitle': 'Any user in the system can',
      'icon': Icons.language
    },
    {
      'value': 'Verified Users',
      'title': 'Verified Users',
      'subtitle': 'Only Admins, Moderators, Pro and Verified Users',
      'icon': Icons.check_circle
    },
    {
      'value': 'Pro Users',
      'title': 'Pro Users',
      'subtitle': 'Any user in the system can',
      'icon': Icons.rocket
    },
    {
      'value': 'Admin',
      'title': 'Admin',
      'subtitle': 'Only Admins and Moderators',
      'icon': Icons.lock
    },
  ];
  List<Map> gamesDropDown = [
    {
      'value': 'everyone',
      'title': 'Everyone',
      'subtitle': 'Any user in the system can',
      'icon': Icons.language
    },
    {
      'value': 'Verified Users',
      'title': 'Verified Users',
      'subtitle': 'Only Admins, Moderators, Pro and Verified Users',
      'icon': Icons.check_circle
    },
    {
      'value': 'Pro Users',
      'title': 'Pro Users',
      'subtitle': 'Any user in the system can',
      'icon': Icons.rocket
    },
    {
      'value': 'Admin',
      'title': 'Admin',
      'subtitle': 'Only Admins and Moderators',
      'icon': Icons.lock
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AdminSettingHeader(
          icon: const Icon(Icons.settings),
          pagename: 'Settings',
          button: const {'flag': false},
          headerTab: headerTab,
        ),
        Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            width: SizeConfig(context).screenWidth > 800
                ? SizeConfig(context).screenWidth * 0.75
                : SizeConfig(context).screenWidth,
            child: tabTitle == 'General'
                ? generalWidget()
                : tabTitle == 'SEO'
                    ? seoWidget()
                    : tabTitle == 'Modules'
                        ? modulesWidget()
                        : featuresWidget())
      ],
    );
  }

  Widget featuresWidget() {
    return Column(children: [
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Flocation.svg?alt=media&token=fd492349-fb79-4570-9850-6619411cb4c2',
          'Fliter by Location',
          'If enabled user will able to filter people, products, jobs & offers by location'),
      const Padding(
        padding: EdgeInsets.only(top: 25),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 25),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fcontact.svg?alt=media&token=c8379618-d119-4a37-907c-b4f226650d44',
          'Contact Us',
          'Turn the contact us page On and Off'),
      const Padding(
        padding: EdgeInsets.only(top: 25),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 25),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fdaytime.svg?alt=media&token=a325548b-fa6d-4bdf-94e9-07b33005812a',
          'DayTime Messages',
          'Turn the DayTime Messages (Good Morning, Afternoon, Evening) On and Off'),
      const Padding(
        padding: EdgeInsets.only(top: 25),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 25),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fpokes.svg?alt=media&token=2c7acee3-c22b-472e-a40e-af0a60db7868',
          'Pokes',
          'Enable users to poke each others'),
      const Padding(
        padding: EdgeInsets.only(top: 25),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 25),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fgifts.svg?alt=media&token=835c53b1-94a2-432b-ae48-2c930abd67d6',
          'Gifts',
          'Enable users to send gifts to each others Make sure you have configured Gifts'),
      const Padding(
        padding: EdgeInsets.only(top: 25),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 25),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fcookie.svg?alt=media&token=4f2c0fd0-d92c-48be-9d3e-155e639ed97f',
          'Cookie Consent (GDPR)',
          'Turn the cookie consent notification On and Off'),
      const Padding(
        padding: EdgeInsets.only(top: 25),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 25),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fadblock.svg?alt=media&token=983847bb-7157-4338-bc65-b3fbfbbe8aff',
          'Adblock Detector',
          'Turn the Adblock auto detector notification On and Off, (Note: Admin is exception) Red block message will appear to make user disable adblock from his browser'),
      const Padding(
        padding: EdgeInsets.only(top: 25),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 25),
      ),
      footer()
    ]);
  }

  Widget seoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.network(
              'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fwebsite.svg?alt=media&token=d55ae5de-546a-453f-8590-ddb48b77dccf',
              width: 40,
            ),
            Flexible(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Website Public',
                        style: TextStyle(
                            color: fontColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const Padding(padding: EdgeInsets.only(left: 20)),
                      const Text(
                        'Make the website public to allow non logged users to view website content',
                        style: TextStyle(fontSize: 13),
                      )
                    ],
                  ),
                )),
            const Flexible(fit: FlexFit.tight, child: SizedBox()),
            SizedBox(
              height: 20,
              child: Transform.scale(
                scaleX: 1,
                scaleY: 1,
                child: CupertinoSwitch(
                  thumbColor: Colors.white,
                  activeColor: Colors.black,
                  value: true,
                  onChanged: (value) {},
                ),
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 30),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.network(
              'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fnews.svg?alt=media&token=e9f948f7-edbf-4b5e-9781-3bc6b6a27342',
              width: 40,
            ),
            Flexible(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.only(left: 10, right: 30),
                  width: SizeConfig(context).screenWidth * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Newsfeed Public',
                        style: TextStyle(
                            color: fontColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text(
                          overflow: TextOverflow.clip,
                          'Make the newsfeed available for visitors in landing pageEnable this will make your website public and list only public posts',
                          style: TextStyle(fontSize: 13)),
                    ],
                  ),
                )),
            const Flexible(fit: FlexFit.tight, child: SizedBox()),
            SizedBox(
              height: 20,
              child: Transform.scale(
                scaleX: 1,
                scaleY: 1,
                child: CupertinoSwitch(
                  thumbColor: Colors.white,
                  activeColor: Colors.black,
                  value: true,
                  onChanged: (value) {},
                ),
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 30),
        ),
        Row(
          children: [
            SvgPicture.network(
              'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fdirectory.svg?alt=media&token=0fb7c552-4372-483a-8467-81f4c155993a',
              width: 40,
            ),
            Flexible(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Directory',
                        style: TextStyle(
                            color: fontColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const Padding(padding: EdgeInsets.only(left: 20)),
                      const Text(
                        'Enable the directory for better SEO resultsMake the website public to allow non logged users to view website content',
                        style: TextStyle(fontSize: 13),
                      )
                    ],
                  ),
                )),
            const Flexible(fit: FlexFit.tight, child: SizedBox()),
            SizedBox(
              height: 20,
              child: Transform.scale(
                scaleX: 1,
                scaleY: 1,
                child: CupertinoSwitch(
                  thumbColor: Colors.white,
                  activeColor: Colors.black,
                  value: true,
                  onChanged: (value) {},
                ),
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 15),
        ),
        titleAndsubtitleInput('Website Title', 40, 1, 'Title of your website'),
        const Padding(
          padding: EdgeInsets.only(top: 15),
        ),
        titleAndsubtitleInput(
            'Website Description', 100, 7, 'Description of your website'),
        const Padding(
          padding: EdgeInsets.only(top: 15),
        ),
        titleAndsubtitleInput(
            'Website Keywords', 100, 7, 'Example: social, sngine, social site'),
        const Padding(
          padding: EdgeInsets.only(top: 15),
        ),
        titleAndsubtitleInput(
            'Directory Description', 100, 7, 'Description of your Directory'),
        const Padding(
          padding: EdgeInsets.only(top: 15),
        ),
        titleAndsubtitleInput(
            'News Description', 100, 1, 'Description of your news module'),
        const Padding(
          padding: EdgeInsets.only(top: 15),
        ),
        titleAndsubtitleInput('Marketplace Description', 100, 1,
            'Description of your marketplace module'),
        const Padding(
          padding: EdgeInsets.only(top: 15),
        ),
        titleAndsubtitleInput('Funding Description', 100, 1,
            'Description of your funding module'),
        const Padding(
          padding: EdgeInsets.only(top: 15),
        ),
        titleAndsubtitleInput(
            'Offers Description', 100, 1, 'Description of your offer module'),
        const Padding(
          padding: EdgeInsets.only(top: 15),
        ),
        titleAndsubtitleInput(
            'Jobs Description', 100, 1, 'Description of your jobs module'),
        const Padding(
          padding: EdgeInsets.only(top: 15),
        ),
        titleAndsubtitleInput(
            'Forums Description', 100, 1, 'Description of your forums module'),
        const Padding(
          padding: EdgeInsets.only(top: 15),
        ),
        titleAndsubtitleInput(
            'Movies Description', 100, 1, 'Description of your movies module'),
        const Padding(padding: EdgeInsets.only(top: 15)),
        Container(
            height: 80,
            decoration: const BoxDecoration(
                color: Color.fromRGBO(240, 240, 240, 1),
                border:
                    Border(top: BorderSide(width: 0.5, color: Colors.grey))),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 15),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0)),
                minimumSize: const Size(150, 50),
                maximumSize: const Size(150, 50),
              ),
              onPressed: () {
                () => {};
              },
              child: const Text('Save Changes',
                  style: TextStyle(
                      color: Color.fromARGB(255, 33, 37, 41),
                      fontSize: 11.0,
                      fontWeight: FontWeight.bold)),
            )),
      ],
    );
  }

  Widget modulesWidget() {
    return Column(children: [
      const Padding(
        padding: EdgeInsets.only(top: 15),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fflag.svg?alt=media&token=76c17503-436c-410c-9162-7acae10bad2c',
          'Pages',
          'Turn the pages On and Off'),
      const Padding(
        padding: EdgeInsets.only(top: 15),
      ),
      moduleDropDown('Who Can Create Pages', pagesDropDown),
      const Padding(
        padding: EdgeInsets.only(top: 10),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 10),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fgroups.svg?alt=media&token=d7cbc632-b7d0-44f9-abfd-3dac56316899',
          'Groups',
          'Turn the groups On and Off'),
      const Padding(
        padding: EdgeInsets.only(top: 15),
      ),
      moduleDropDown('Who Can Create Pages', groupsDropDown),
      const Padding(
        padding: EdgeInsets.only(top: 10),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 10),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fevents.svg?alt=media&token=c11b765b-8ac7-4aab-af62-ffeef9aa74d4',
          'Events',
          'Turn the events On and Off'),
      const Padding(
        padding: EdgeInsets.only(top: 15),
      ),
      moduleDropDown('Who Can Create Events', eventsDropDown),
      const Padding(
        padding: EdgeInsets.only(top: 10),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 10),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fgroups.svg?alt=media&token=d7cbc632-b7d0-44f9-abfd-3dac56316899',
          'People',
          'Turn the people On and Off'),
      const Padding(
        padding: EdgeInsets.only(top: 15),
      ),
      moduleDropDown('Who Can Find People', groupsDropDown),
      const Padding(
        padding: EdgeInsets.only(top: 10),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 10),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fblogs.svg?alt=media&token=b3d93493-295f-4672-ad28-e9605aca3f5d',
          'Blogs',
          'Turn the blogs On and Off'),
      const Padding(
        padding: EdgeInsets.only(top: 15),
      ),
      moduleDropDown('Who Can Write Articles', blogsDropDown),
      const Padding(
        padding: EdgeInsets.only(top: 10),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 10),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fmarketplace.svg?alt=media&token=60d5ed49-9158-4b02-a3fb-0235dd48a55c',
          'Marketplace',
          'Turn the marketplace On and Off'),
      const Padding(
        padding: EdgeInsets.only(top: 15),
      ),
      moduleDropDown('Who Can Sell Products', marketPlaceDropDown),
      const Padding(
        padding: EdgeInsets.only(top: 10),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 10),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Foffers.svg?alt=media&token=0bbc0a52-b16f-4eea-963a-0f895fb2b2f3',
          'Offers',
          'Turn the offers On and Off Only pages can publish offers (Pages must be enabled too)'),
      const Padding(
        padding: EdgeInsets.only(top: 10),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 10),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fforums.svg?alt=media&token=c93542ac-9562-424b-a071-8551a2a7ba4d',
          'Jobs',
          'Turn the jobs On and Off Only pages can publish jobs (Pages must be enabled too)'),
      const Padding(
        padding: EdgeInsets.only(top: 10),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 10),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Foffers.svg?alt=media&token=0bbc0a52-b16f-4eea-963a-0f895fb2b2f3',
          'Forums',
          'Turn the forums On and Off'),
      const Padding(
        padding: EdgeInsets.only(top: 10),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 10),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fonline_user.svg?alt=media&token=dc5f4f98-16fd-4010-84d1-bdecac1982a6',
          'Online Users',
          'Show forums online users'),
      const Padding(
        padding: EdgeInsets.only(top: 10),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 10),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fstatistics.svg?alt=media&token=b9b43bc0-27cd-4929-80d8-2ea563dcb48a',
          'Statistics',
          'Show forums statistics'),
      const Padding(
        padding: EdgeInsets.only(top: 15),
      ),
      moduleDropDown('Who Can Add Threads/Replies', statisticsDropDown),
      const Padding(
        padding: EdgeInsets.only(top: 10),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 10),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fmovies.svg?alt=media&token=8cda0645-e9fd-4d05-8456-7c299de0a8a1',
          'Movies',
          'Turn the movies On and Off'),
      const Padding(
        padding: EdgeInsets.only(top: 15),
      ),
      moduleDropDown('Who Can Watch Movies', moviesDropDown),
      const Padding(
        padding: EdgeInsets.only(top: 10),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 10),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fgames.svg?alt=media&token=a4c021e4-a2a9-43e7-ae5e-c189f4fc56eb',
          'Games',
          'Turn the games On and Off'),
      const Padding(
        padding: EdgeInsets.only(top: 15),
      ),
      moduleDropDown('Who Can Play Games', gamesDropDown),
      const Padding(
        padding: EdgeInsets.only(top: 15),
      ),
      footer()
    ]);
  }

  Widget generalWidget() {
    return Container(
        child: Column(
      children: [
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fglobal.svg?alt=media&token=a643b225-ed3a-4d0a-9bfd-8b70518f6424',
            'Website Live',
            'Turn the entire website On and Off'),
        const Padding(
          padding: EdgeInsets.only(top: 30),
        ),
        titleAndsubtitleInput('Shutdown Message', 150, 7,
            'The text that is presented when the site is closed'),
        const Padding(padding: EdgeInsets.only(top: 15)),
        titleAndsubtitleInput('System Email', 40, 1,
            'The contact email that all messages send to'),
        const Padding(padding: EdgeInsets.only(top: 15)),
        titleAndsubtitleDropdown('System Datetime Format', dateTimeArr,
            'Select the datetime format of the datetime picker'),
        const Padding(padding: EdgeInsets.only(top: 15)),
        titleAndsubtitleDropdown('System Distance Unit', distanceArr,
            'Select the distance measure unit of your website'),
        const Padding(padding: EdgeInsets.only(top: 15)),
        titleAndsubtitleDropdown('System Currency', currency,
            'You can add, edit or delete currencies from Currencies'),
        const Padding(padding: EdgeInsets.only(top: 15)),
        titleAndsubtitleDropdown('System Currency Direction', directionCurrency,
            'Where to add the currency symbol relative to the money value'),
        const Padding(padding: EdgeInsets.only(top: 15)),
        footer()
      ],
    ));
  }

  Widget footer() {
    return Container(
        height: 80,
        decoration: const BoxDecoration(
            color: Color.fromRGBO(240, 240, 240, 1),
            border: Border(top: BorderSide(width: 0.5, color: Colors.grey))),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 15),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.0)),
            minimumSize: const Size(150, 50),
            maximumSize: const Size(150, 50),
          ),
          onPressed: () {
            () => {};
          },
          child: const Text('Save Changes',
              style: TextStyle(
                  color: Color.fromARGB(255, 33, 37, 41),
                  fontSize: 11.0,
                  fontWeight: FontWeight.bold)),
        ));
  }

  Widget titleAndsubtitleDropdown(title, List<Map> dropDownItems, subtitle) {
    List items = dropDownItems;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        title,
        style: const TextStyle(
            color: Color.fromRGBO(82, 95, 127, 1),
            fontSize: 13,
            fontWeight: FontWeight.w600),
      ),
      const Padding(padding: EdgeInsets.only(top: 2)),
      SizedBox(
          height: 40,
          width: SizeConfig(context).screenWidth < 900
              ? SizeConfig(context).screenWidth - 60
              : SizeConfig(context).screenWidth * 0.3 - 90,
          child: DropdownButtonFormField(
            value: items[0]['value'],
            items: items
                .map((e) => DropdownMenuItem(
                    value: e['value'], child: Text(e['title'])))
                .toList(),
            onChanged: (value) {},
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(top: 10, left: 10),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.0),
              ),
            ),
            icon: const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Icon(Icons.arrow_drop_down)),
            iconEnabledColor: Colors.grey, //Icon color

            style: const TextStyle(
              color: Colors.grey, //Font color
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            dropdownColor: Colors.white,
            isExpanded: true,
            isDense: true,
          ))
    ]);
  }

  Widget moduleDropDown(title, List<Map> dropDownItems) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 100,
          alignment: Alignment.topLeft,
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 85, 95, 127)),
          ),
        ),
        Expanded(
            flex: 2,
            child: SizedBox(
              width: 500,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                  width: 400,
                  height: 70,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 250, 250, 250),
                      border: Border.all(color: Colors.grey)),
                  child: DropdownButton(
                    value: dropDownItems[0]['value'],
                    itemHeight: 70,
                    items: dropDownItems
                        .map((e) => DropdownMenuItem(
                            value: e['value'],
                            child: SizedBox(
                                height: 70,
                                child: ListTile(
                                  leading: Icon(e['icon']),
                                  title: Text(e['title']),
                                  subtitle: Text(e['subtitle']),
                                ))))
                        .toList(),
                    onChanged: (value) {
                      //get value when changed
                      // dropdownValue = value!;
                      setState(() {});
                    },
                    icon: const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Icon(Icons.arrow_drop_down)),
                    iconEnabledColor: Colors.white, //Icon color
                    style: const TextStyle(
                      color: Colors.black, //Font color
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                    dropdownColor: Colors.white,
                    underline: Container(), //remove underline
                    isExpanded: true,
                    isDense: true,
                  ),
                ),
              ]),
            ))
      ],
    );
  }

  Widget pictureAndSelect(svgSource, title, content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.network(
          svgSource,
          width: 40,
        ),
        Flexible(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 30),
              width: SizeConfig(context).screenWidth * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        color: fontColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(content,
                      overflow: TextOverflow.clip,
                      style: const TextStyle(fontSize: 13)),
                ],
              ),
            )),
        const Flexible(fit: FlexFit.tight, child: SizedBox()),
        SizedBox(
          height: 20,
          child: Transform.scale(
            scaleX: 1,
            scaleY: 1,
            child: CupertinoSwitch(
              thumbColor: Colors.white,
              activeColor: Colors.black,
              value: true,
              onChanged: (value) {},
            ),
          ),
        ),
      ],
    );
  }

  Widget titleAndsubtitleInput(title, height, line, onChange) {
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
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 85, 95, 127)),
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  width: 400,
                  height: height,
                  child: TextField(
                    maxLines: line,
                    minLines: line,
                    onChanged: (value) {
                      onChange(value);
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(top: 10, left: 10),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                    ),
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
