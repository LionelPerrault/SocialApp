import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_footer.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_header.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

// ignore: must_be_immutable
class AdminSettingsAccount extends StatefulWidget {
  AdminSettingsAccount({super.key});

  @override
  State createState() => AdminSettingsAccountState();
}

class AdminSettingsAccountState extends mvc.StateMVC<AdminSettingsAccount> {
  @override
  void initState() {
    super.initState();
    headerTab = [
      {
        'icon': FontAwesomeIcons.person,
        'title': 'General',
        'onClick': (value) {
          tabTitle = value;
          setState(() {});
        }
      },
      {
        'icon': FontAwesomeIcons.idCard,
        'title': 'Profile',
        'onClick': (value) {
          tabTitle = value;
          setState(() {});
        }
      },
    ];
  }

  bool check1 = false;
  Color fontColor = const Color.fromRGBO(82, 95, 127, 1);
  double fontSize = 13;
  String tabTitle = 'General';
  late var headerTab;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          AdminSettingHeader(
            icon: const Icon(Icons.settings),
            pagename: 'Settings › Account',
            button: const {'flag': false},
            headerTab: headerTab,
          ),
          Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              width: SizeConfig(context).screenWidth > 700
                  ? SizeConfig(context).screenWidth * 0.75
                  : SizeConfig(context).screenWidth,
              child: tabTitle == 'General' ? generalWidget() : ProfileWidget())
        ],
      ),
    );
  }

  Widget generalWidget() {
    return Container(
      child: Column(children: [
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fshow_username.svg?alt=media&token=5a47447e-9c39-4465-9403-d3136c240f19',
            'Show Usernames Only',
            'If disabled full names will be displayed instead'),
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
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fdelete_account.svg?alt=media&token=def05e10-6e49-4704-a815-f6b6273c1a14',
            'Delete Account (GDPR)',
            'Allow users to delete their account'),
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
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fdownload.svg?alt=media&token=4c0ad296-bd2d-46dc-b46d-babff026c6f5',
            'Download User Information (GDPR)',
            'Allow users to download their account information from settings page'),
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
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fverification.svg?alt=media&token=abd89942-54ac-4130-99bc-6b09b21e8a32',
            'Verification Requests',
            'Turn the verification requests from users & pages On and Off'),
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
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fdisable_friend.svg?alt=media&token=d696c49e-4a0b-4048-8d46-c19b939f1c37',
            'Disable Friend Request After Decline',
            'If enabled user A will be able to send friendship request to user B again'),
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
          padding: EdgeInsets.only(top: 30),
        ),
        titleAndsubtitleInput('Max Friends/User', 30, 1,
            'The Maximum number of friends allowed per User (0 for unlimited)'),
        const Padding(
          padding: EdgeInsets.only(top: 50),
        ),
        Container(
          height: 1,
          color: const Color.fromRGBO(240, 240, 240, 1),
        ),
        footer()
      ]),
    );
  }

  Widget ProfileWidget() {
    return Container(
      child: Column(children: [
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Frelationship.svg?alt=media&token=244f5d2e-250f-4f69-8957-9bfed24b82d5',
            'Relationship Status',
            'Turn the Relationship Status On/Off'),
        const Padding(
          padding: EdgeInsets.only(top: 30),
        ),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fwebsite.svg?alt=media&token=22e86aa8-514d-4991-ae0c-1b6ac192e780',
            'Website',
            'Turn the Website On/Off'),
        const Padding(
          padding: EdgeInsets.only(top: 30),
        ),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fabout_me.svg?alt=media&token=5099fbec-a252-412a-ac6f-7801d4f924aa',
            'About Me',
            'Turn the About Me On/Off'),
        const Padding(
          padding: EdgeInsets.only(top: 30),
        ),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fwork_info.svg?alt=media&token=2fc36355-2dd3-4c98-9248-6ab26d9c62da',
            'Work Info',
            'Turn the Work info On/Off'),
        const Padding(
          padding: EdgeInsets.only(top: 30),
        ),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Flocation_info.svg?alt=media&token=d8976b06-7e99-46b9-a3dd-dd0d6ad95680',
            'Location Info',
            'Turn the Location info On/Off'),
        const Padding(
          padding: EdgeInsets.only(top: 30),
        ),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Feducation_info.svg?alt=media&token=4bc81127-a161-4ebb-8e7b-9af1fae3c2cc',
            'Education Info',
            'Turn the Education info On/Off'),
        const Padding(
          padding: EdgeInsets.only(top: 30),
        ),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fsocial.svg?alt=media&token=bc248830-258f-4252-8db1-6987db1219d4',
            'Social Links',
            'Turn the Social Links On/Off'),
        const Padding(
          padding: EdgeInsets.only(top: 30),
        ),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Finterests.svg?alt=media&token=f4470f89-d0ed-460a-bf9e-7fabb1102fe4',
            'Interests',
            'Turn the Interests On/Off'),
        const Padding(
          padding: EdgeInsets.only(top: 30),
        ),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fprofile_design.svg?alt=media&token=71e53bf9-a73d-42b4-b35a-015d6051813a',
            'Profile Design',
            'Allow users to upload background image to their profiles'),
        const Padding(
          padding: EdgeInsets.only(top: 50),
        ),
        Container(
          height: 1,
          color: const Color.fromRGBO(240, 240, 240, 1),
        ),
        footer()
      ]),
    );
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
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      )
                    ]),
              ))
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
