import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_footer.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_header.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

// ignore: must_be_immutable
class AdminSettingsRegistration extends StatefulWidget {
  AdminSettingsRegistration({super.key});
  @override
  State createState() => AdminSettingsRegistrationState();
}

class AdminSettingsRegistrationState
    extends mvc.StateMVC<AdminSettingsRegistration> {
  @override
  void initState() {
    super.initState();
    headerTab = [
      {
        'icon': Icons.open_in_browser,
        'title': 'General',
        'onClick': (value) {
          tabTitle = value;
          setState(() {});
        }
      },
      {
        'icon': Icons.facebook,
        'title': 'Social Login',
        'onClick': (value) {
          tabTitle = value;
          setState(() {});
        }
      },
    ];
  }

  bool check1 = true;
  Color fontColor = const Color.fromRGBO(82, 95, 127, 1);
  double fontSize = 14;
  String tabTitle = 'General';
  late var headerTab;
  List<Map> invitaionDropDown = [
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
  List<Map> invitationDropDowns = [
    {
      'value': 'Month',
      'title': 'Month',
    },
    {
      'value': 'Year',
      'title': 'Year',
    },
    {
      'value': 'Week',
      'title': 'Week',
    },
    {
      'value': 'Day',
      'title': 'Day',
    },
    {
      'value': 'Hour',
      'title': 'Hour',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          AdminSettingHeader(
            icon: const Icon(Icons.settings),
            pagename: 'Settings › Registration',
            button: const {'flag': false},
            headerTab: headerTab,
          ),
          Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              width: SizeConfig(context).screenWidth > 700
                  ? SizeConfig(context).screenWidth * 0.75
                  : SizeConfig(context).screenWidth,
              child:
                  tabTitle == 'General' ? generalWidget() : socialLoginWidget())
        ],
      ),
    );
  }

  Widget socialLoginWidget() {
    return Container(
        child: Column(children: [
      const Padding(padding: EdgeInsets.only(top: 30)),
      pictureAndSelect(
          svgSource:
              'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fsocial.svg?alt=media&token=bc248830-258f-4252-8db1-6987db1219d4',
          title: 'Social Logins',
          content:
              'Turn registration/login via social media (Facebook, Twitter and etc) On and Off'),
      const Padding(padding: EdgeInsets.only(top: 30)),
      Container(
        color: const Color.fromRGBO(240, 240, 240, 1),
        height: 1,
      ),
      const Padding(padding: EdgeInsets.only(top: 30)),
      pictureAndSelect(
          title: 'Social Logins',
          content:
              'Turn registration/login via social media (Facebook, Twitter and etc) On and Off',
          icon: {
            'icon': Icons.facebook,
            'color': const Color.fromRGBO(59, 87, 157, 1)
          }),
      const Padding(padding: EdgeInsets.only(top: 30)),
      titleAndsubtitleInput('Facebook App ID', 30, 1, ''),
      const Padding(padding: EdgeInsets.only(top: 30)),
      titleAndsubtitleInput('Facebook App Secret', 30, 1, ''),
      const Padding(padding: EdgeInsets.only(top: 30)),
      Container(
        color: const Color.fromRGBO(240, 240, 240, 1),
        height: 1,
      ),
      const Padding(padding: EdgeInsets.only(top: 30)),
      pictureAndSelect(
          title: 'Google',
          content: 'Turn registration/login via Google On and Off',
          icon: {'icon': Icons.g_mobiledata_rounded, 'color': Colors.red}),
      const Padding(padding: EdgeInsets.only(top: 30)),
      titleAndsubtitleInput('Google App ID', 30, 1, ''),
      const Padding(padding: EdgeInsets.only(top: 30)),
      titleAndsubtitleInput('Google App Secret', 30, 1, ''),
      const Padding(padding: EdgeInsets.only(top: 30)),
      Container(
        color: const Color.fromRGBO(240, 240, 240, 1),
        height: 1,
      ),
      const Padding(padding: EdgeInsets.only(top: 30)),
      pictureAndSelect(
          title: 'Twitter',
          content: 'Turn registration/login via Twitter On and Off',
          icon: {
            'icon': FontAwesomeIcons.twitter,
            'color': const Color.fromRGBO(59, 87, 157, 1)
          }),
      const Padding(padding: EdgeInsets.only(top: 30)),
      titleAndsubtitleInput('Twitter App ID', 30, 1, ''),
      const Padding(padding: EdgeInsets.only(top: 30)),
      titleAndsubtitleInput('Twitter App Secret', 30, 1, ''),
      const Padding(padding: EdgeInsets.only(top: 30)),
      Container(
        color: const Color.fromRGBO(240, 240, 240, 1),
        height: 1,
      ),
      const Padding(padding: EdgeInsets.only(top: 30)),
      pictureAndSelect(
          title: 'Linkedin',
          content: 'Turn registration/login via Linkedin On and Off',
          icon: {
            'icon': FontAwesomeIcons.linkedin,
            'color': const Color.fromRGBO(59, 87, 157, 1)
          }),
      const Padding(padding: EdgeInsets.only(top: 30)),
      titleAndsubtitleInput('Linkedin App ID', 30, 1, ''),
      const Padding(padding: EdgeInsets.only(top: 30)),
      titleAndsubtitleInput('Linkedin App Secret', 30, 1, ''),
      const Padding(padding: EdgeInsets.only(top: 30)),
      Container(
        color: const Color.fromRGBO(240, 240, 240, 1),
        height: 1,
      ),
      const Padding(padding: EdgeInsets.only(top: 30)),
      pictureAndSelect(
          title: 'Vkontakte',
          content: 'Turn registration/login via Vkontakte On and Off',
          icon: {
            'icon': FontAwesomeIcons.vk,
            'color': const Color.fromRGBO(59, 87, 157, 1)
          }),
      const Padding(padding: EdgeInsets.only(top: 30)),
      titleAndsubtitleInput('Vkontakte App ID', 30, 1, ''),
      const Padding(padding: EdgeInsets.only(top: 30)),
      titleAndsubtitleInput('Vkontakte App Secret', 30, 1, ''),
      const Padding(padding: EdgeInsets.only(top: 30)),
      Container(
        color: const Color.fromRGBO(240, 240, 240, 1),
        height: 1,
      ),
      footer()
    ]));
  }

  Widget generalWidget() {
    return Container(
        width: SizeConfig(context).screenWidth > 700
            ? SizeConfig(context).screenWidth * 0.75
            : SizeConfig(context).screenWidth,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 30, bottom: 30),
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(55, 213, 242, 1),
                  borderRadius: BorderRadius.all(Radius.circular(3))),
              child: Container(
                  child: Row(children: [
                const Icon(
                  Icons.info_rounded,
                  color: Colors.white,
                ),
                const Padding(padding: EdgeInsets.only(left: 15)),
                SizedBox(
                    width: SizeConfig(context).screenWidth * 0.5,
                    child: Text(
                      'If Registration is Free and Pro Packages enabled they will be used as optional upgrading plans.',
                      overflow: TextOverflow.clip,
                      style: TextStyle(color: Colors.white, fontSize: fontSize),
                    ))
              ])),
            ),
            const Padding(padding: EdgeInsets.only(top: 30)),
            pictureAndSelect(
                svgSource:
                    'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fregistration.svg?alt=media&token=c0c198ab-04a1-4176-8b1f-28988d24a35a',
                title: 'Registration',
                content: 'Allow users to create accounts'),
            const Padding(padding: EdgeInsets.only(top: 30)),
            Container(
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        'Registration Type',
                        style: TextStyle(
                            color: fontColor,
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Transform.scale(
                                scale: 1,
                                child: Checkbox(
                                  fillColor: MaterialStateProperty.all<Color>(
                                      Colors.blue),
                                  checkColor: Colors.white,
                                  activeColor:
                                      const Color.fromRGBO(0, 123, 255, 1),
                                  value: check1,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              5.0))), // Rounded Checkbox
                                  onChanged: (value) {
                                    setState(() {
                                      check1 = check1 ? false : true;
                                    });
                                  },
                                )),
                            const Text('Free'),
                            Transform.scale(
                                scale: 1,
                                child: Checkbox(
                                  fillColor: MaterialStateProperty.all<Color>(
                                      Colors.blue),
                                  checkColor: Colors.white,
                                  activeColor:
                                      const Color.fromRGBO(0, 123, 255, 1),
                                  value: check1,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              5.0))), // Rounded Checkbox
                                  onChanged: (value) {
                                    setState(() {
                                      check1 = check1 ? false : true;
                                    });
                                  },
                                )),
                            const Text('Subscriptions Only'),
                          ],
                        ),
                        SizedBox(
                          width: SizeConfig(context).screenWidth * 0.45,
                          child: const Text(
                            'Allow users to create accounts Free or via Subscriptions onlyMake sure you have configured Pro System',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    )
                  ]),
            ),
            const Padding(padding: EdgeInsets.only(top: 30)),
            Container(
              color: const Color.fromRGBO(240, 240, 240, 1),
              height: 1,
            ),
            const Padding(padding: EdgeInsets.only(top: 30)),
            pictureAndSelect(
                svgSource:
                    'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Finvitaion.svg?alt=media&token=e561be22-1924-4e82-9aeb-d3c68ad0ddea',
                title: 'Invitation System',
                content:
                    'This option is used to register the users by invitation codes only'),
            Container(
              color: const Color.fromRGBO(240, 240, 240, 1),
              height: 1,
            ),
            const Padding(padding: EdgeInsets.only(top: 30)),
            moduleDropDown(
                'Who Can Generate Invitation Codes', invitaionDropDown),
            const Padding(padding: EdgeInsets.only(top: 30)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  child: Text(
                    'Invitations/User',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: fontColor),
                  ),
                ),
                const Flexible(fit: FlexFit.tight, child: SizedBox()),
                Container(
                  width: SizeConfig(context).screenWidth * 0.3,
                  height: 30,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 250, 250, 250),
                      border: Border.all(color: Colors.grey)),
                  child: TextFormField(
                    minLines: 1,
                    maxLines: 1,
                    onChanged: (value) async {},
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: '',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 10)),
                Container(
                    width: SizeConfig(context).screenWidth * 0.2 - 10,
                    height: 30,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 250, 250, 250),
                        border: Border.all(color: Colors.grey)),
                    child: DropdownButton(
                      value: invitationDropDowns[0]['value'],
                      items: invitationDropDowns
                          .map(
                            (e) => DropdownMenuItem(
                                value: e['value'],
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    e['title'],
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.grey),
                                  ),
                                )),
                          )
                          .toList(),
                      onChanged: (value) {
                        //get value when changed
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
                    )),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            Row(
              children: [
                const Flexible(fit: FlexFit.tight, child: SizedBox()),
                SizedBox(
                  width: SizeConfig(context).screenWidth * 0.5,
                  child: const Text(
                    'Number of invitation codes allowed to each user (0 for unlimited) For example 1 code per day, 5 codes per month',
                    style: TextStyle(fontSize: 13),
                  ),
                )
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Container(
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        'Registration Type',
                        style: TextStyle(
                            color: fontColor,
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Transform.scale(
                                scale: 1,
                                child: Checkbox(
                                  fillColor: MaterialStateProperty.all<Color>(
                                      Colors.blue),
                                  checkColor: Colors.white,
                                  activeColor:
                                      const Color.fromRGBO(0, 123, 255, 1),
                                  value: check1,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              5.0))), // Rounded Checkbox
                                  onChanged: (value) {
                                    setState(() {
                                      check1 = check1 ? false : true;
                                    });
                                  },
                                )),
                            const Text('Email'),
                            Transform.scale(
                                scale: 1,
                                child: Checkbox(
                                  fillColor: MaterialStateProperty.all<Color>(
                                      Colors.blue),
                                  checkColor: Colors.white,
                                  activeColor:
                                      const Color.fromRGBO(0, 123, 255, 1),
                                  value: check1,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              5.0))), // Rounded Checkbox
                                  onChanged: (value) {
                                    setState(() {
                                      check1 = check1 ? false : true;
                                    });
                                  },
                                )),
                            const Text('SMS'),
                            Transform.scale(
                                scale: 1,
                                child: Checkbox(
                                  fillColor: MaterialStateProperty.all<Color>(
                                      Colors.blue),
                                  checkColor: Colors.white,
                                  activeColor:
                                      const Color.fromRGBO(0, 123, 255, 1),
                                  value: check1,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              5.0))), // Rounded Checkbox
                                  onChanged: (value) {
                                    setState(() {
                                      check1 = check1 ? false : true;
                                    });
                                  },
                                )),
                            const Text('Both'),
                          ],
                        ),
                        SizedBox(
                          width: SizeConfig(context).screenWidth * 0.45,
                          child: const Text(
                            'Select Email or SMS to send invitation link to new user`s email/phone Make sure you have configured SMS Settings',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    )
                  ]),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Container(
              color: const Color.fromRGBO(240, 240, 240, 1),
              height: 1,
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            pictureAndSelect(
                svgSource:
                    'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Factivation.svg?alt=media&token=e914df53-eefc-4c2f-a861-17109e7d97f2',
                title: 'Activation Enabled',
                content:
                    'Enable account activation to send activation code to user`s email/phone'),
            const Padding(padding: EdgeInsets.only(top: 30)),
            Container(
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        'Activation Type',
                        style: TextStyle(
                            color: fontColor,
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Transform.scale(
                                scale: 1,
                                child: Checkbox(
                                  fillColor: MaterialStateProperty.all<Color>(
                                      Colors.blue),
                                  checkColor: Colors.white,
                                  activeColor:
                                      const Color.fromRGBO(0, 123, 255, 1),
                                  value: check1,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              5.0))), // Rounded Checkbox
                                  onChanged: (value) {
                                    setState(() {
                                      check1 = check1 ? false : true;
                                    });
                                  },
                                )),
                            const Text('Email'),
                            Transform.scale(
                                scale: 1,
                                child: Checkbox(
                                  fillColor: MaterialStateProperty.all<Color>(
                                      Colors.blue),
                                  checkColor: Colors.white,
                                  activeColor:
                                      const Color.fromRGBO(0, 123, 255, 1),
                                  value: check1,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              5.0))), // Rounded Checkbox
                                  onChanged: (value) {
                                    setState(() {
                                      check1 = check1 ? false : true;
                                    });
                                  },
                                )),
                            const Text('SMS'),
                          ],
                        ),
                        SizedBox(
                          width: SizeConfig(context).screenWidth * 0.45,
                          child: const Text(
                            'Select Email or SMS activation to send activation code to user`s email/phone Make sure you have configured SMS Settings',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    )
                  ]),
            ),
            const Padding(padding: EdgeInsets.only(top: 30)),
            Container(
              color: const Color.fromRGBO(240, 240, 240, 1),
              height: 1,
            ),
            const Padding(padding: EdgeInsets.only(top: 30)),
            pictureAndSelect(
                svgSource:
                    'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fgetting.svg?alt=media&token=a96a46e6-d6e3-4714-8748-1adde58929fa',
                title: 'Getting Started',
                content:
                    'Enable/Disable getting started page after registration'),
            const Padding(padding: EdgeInsets.only(top: 30)),
            pictureAndSelect(
                svgSource:
                    'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fnewsletter.svg?alt=media&token=b66cb6f9-de06-4ef2-856a-6f1d7c6a8e1b',
                title: 'Newsletter Consent (GDPR)',
                content:
                    'Enable/Disable newsletter consent during the registration'),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Container(
              color: const Color.fromRGBO(240, 240, 240, 1),
              height: 1,
            ),
            const Padding(padding: EdgeInsets.only(top: 30)),
            titleAndsubtitleInput('Max Accounts/IP', 30, 1,
                'The Maximum number of accounts allowed to register per IP (0 for unlimited)'),
            const Padding(padding: EdgeInsets.only(top: 30)),
            titleAndsubtitleInput('Name Minimum Length', 30, 1,
                'The First and Last name minimum length'),
            const Padding(padding: EdgeInsets.only(top: 30)),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Container(
          width: 200,
          child: Text(
            title,
            style: TextStyle(
                color: fontColor,
                fontSize: fontSize,
                fontWeight: FontWeight.bold),
          ),
        )),
        const Flexible(fit: FlexFit.tight, child: SizedBox()),
        Container(
          width: SizeConfig(context).screenWidth * 0.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 30,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 250, 250, 250),
                      border: Border.all(color: Colors.grey)),
                  child: DropdownButton(
                    value: dropDownItems[0]['value'],
                    items: dropDownItems
                        .map(
                          (e) => DropdownMenuItem(
                              value: e['value'],
                              child: Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  e['title'],
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                ),
                              )),
                        )
                        .toList(),
                    onChanged: (value) {
                      //get value when changed
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
                  )),
              const Padding(padding: EdgeInsets.only(top: 5)),
              Text(
                subtitle,
                style: TextStyle(fontSize: fontSize),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget titleAndsubtitleInput(title, height, line, subtitle) {
    return Container(
      child: Row(
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
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 400,
                        height: height,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 250, 250, 250),
                            border: Border.all(color: Colors.grey)),
                        child: TextFormField(
                          minLines: 1,
                          maxLines: line,
                          onChanged: (value) async {},
                          keyboardType: TextInputType.multiline,
                          style: const TextStyle(fontSize: 12),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: '',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      )
                    ]),
              ))
        ],
      ),
    );
  }

  Widget pictureAndSelect({svgSource = '', title, content, icon}) {
    return Container(
        width: SizeConfig(context).screenWidth > 700
            ? SizeConfig(context).screenWidth * 0.75
            : SizeConfig(context).screenWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            icon != null
                ? Icon(
                    icon['icon'],
                    size: 40,
                    color: icon['color'],
                  )
                : SvgPicture.network(
                    svgSource,
                    width: 40,
                  ),
            Flexible(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 30),
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
        ));
  }

  Widget moduleDropDown(title, List<Map> dropDownItems) {
    return Container(
      child: Row(
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
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
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
                                  child: Container(
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
      ),
    );
  }
}
