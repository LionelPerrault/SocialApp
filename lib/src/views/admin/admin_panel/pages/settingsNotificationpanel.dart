import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_header.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

// ignore: must_be_immutable
class AdminSettingsNotification extends StatefulWidget {
  const AdminSettingsNotification({super.key});

  @override
  State createState() => AdminSettingsNotificationState();
}

class AdminSettingsNotificationState
    extends mvc.StateMVC<AdminSettingsNotification> {
  @override
  void initState() {
    super.initState();
    headerTab = [
      {
        'icon': Icons.notification_add,
        'title': 'Website Notifications',
        'onClick': (value) {
          tabTitle = value;
          setState(() {});
        }
      },
      {
        'icon': Icons.email,
        'title': 'Email Notifications',
        'onClick': (value) {
          tabTitle = value;
          setState(() {});
        }
      },
      {
        'icon': Icons.cell_tower,
        'title': 'Push Notifications',
        'onClick': (value) {
          tabTitle = value;
          setState(() {});
        }
      },
    ];
  }

  bool check1 = false;
  Color fontColor = const Color.fromRGBO(82, 95, 127, 1);
  double fontSize = 14;
  String tabTitle = 'Website Notifications';
  late var headerTab;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AdminSettingHeader(
          icon: const Icon(Icons.settings),
          pagename: 'Settings › Notifications',
          button: const {'flag': false},
          headerTab: headerTab,
        ),
        Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            width: SizeConfig(context).screenWidth > 700
                ? SizeConfig(context).screenWidth * 0.75
                : SizeConfig(context).screenWidth,
            child: tabTitle == 'Website Notifications'
                ? websiteNotificationWidget()
                : tabTitle == 'Email Notifications'
                    ? emailNotificationWidget()
                    : pushNotificationWidget())
      ],
    );
  }

  Widget pushNotificationWidget() {
    return Column(children: [
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2FsignalNotification.svg?alt=media&token=f93da041-d5e1-4df7-9e2e-73d0757f34ff',
          'OneSignal Push Notifications',
          'Turn the OneSignal push notification On and Off'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleInput('OneSignal APP ID', 30, 1, () {}, ''),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleInput('OneSignal REST API Key', 30, 1, () {}, ''),
      const Padding(
        padding: EdgeInsets.only(top: 50),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      footer()
    ]);
  }

  Widget websiteNotificationWidget() {
    return Column(children: [
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fprofile_visit.svg?alt=media&token=e9db87b2-5cb7-4dc4-b2d2-13541af59083',
          'Profile Visit Notification',
          'Turn the profile visit notification On and Off'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fbrowser_notification.svg?alt=media&token=16940a1f-c7d6-488d-a55d-6d7c84de0db5',
          'Browser Notifications',
          'Turn the browser notifications On and Off'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fnoty_notification.svg?alt=media&token=ae717745-b1c5-45ff-95b7-2a780c3e0b81',
          'Noty Notifications',
          'Turn the noty notifications On and Off (preview)'),
      const Padding(
        padding: EdgeInsets.only(top: 50),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      footer()
    ]);
  }

  Widget selectAndText(content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Transform.scale(
            scale: 0.7,
            child: Checkbox(
              fillColor: MaterialStateProperty.all<Color>(Colors.blue),
              checkColor: Colors.white,
              activeColor: const Color.fromRGBO(0, 123, 255, 1),
              value: check1,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(5.0))), // Rounded Checkbox
              onChanged: (value) {
                setState(() {
                  check1 = check1 ? false : true;
                });
              },
            )),
        SizedBox(
          width: SizeConfig(context).screenWidth * 0.25,
          child: Text(
            content,
            style: const TextStyle(fontSize: 13),
          ),
        )
      ],
    );
  }

  Widget emailNotificationWidget() {
    return Column(children: [
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Femail_notification.svg?alt=media&token=feb354c9-e070-4f8d-9fc3-4d8861b38235',
          'Email Notifications',
          'Enable/Disable email notifications system'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10),
            width: 100,
            child: Text(
              'Email User When',
              style: TextStyle(color: fontColor, fontSize: 13),
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 30)),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                selectAndText('Someone liked his post'),
                selectAndText('Someone commented on his post'),
                selectAndText('Someone shared his post'),
                selectAndText('Someone posted on his timeline'),
                selectAndText('Someone mentioned him'),
                selectAndText('Someone visited his profile'),
                selectAndText('Someone sent him or accepted his friend requset')
              ])
        ],
      ),
      const Padding(
        padding: EdgeInsets.only(top: 50),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      footer()
    ]);
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
            child: SizedBox(
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
        SizedBox(
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
                                padding: const EdgeInsets.only(left: 10),
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

  Widget titleAndsubtitleInput(title, height, line, onChange, subTitle) {
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
                  child: Column(children: [
                    TextField(
                      maxLines: line,
                      minLines: line,
                      onChanged: (value) {
                        onChange(value);
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(top: 10, left: 10),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 1.0),
                        ),
                      ),
                    ),
                    Text(subTitle)
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
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

  Widget moduleDropDown(title, List<Map> dropDownItems) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              child: SizedBox(
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
            decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: Colors.grey)),
            height: 70,
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
          )
        ]);
  }
}
