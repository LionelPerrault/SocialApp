import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/controllers/AdminController.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_footer.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_header.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

// ignore: must_be_immutable
class AdminSettingsChat extends StatefulWidget {
  AdminSettingsChat({Key? key})
      : con = AdminController(),
        super(key: key);
  final AdminController con;
  @override
  State createState() => AdminSettingsChatState();
}

class AdminSettingsChatState extends mvc.StateMVC<AdminSettingsChat> {
  Color fontColor = const Color.fromRGBO(82, 95, 127, 1);
  List<Map> audioCallDropdown = [
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
    return Container(
      padding: const EdgeInsets.only(left: 30, right: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AdminSettingHeader(
          icon: const Icon(Icons.settings),
          pagename: 'Settings › Chat',
          button: const {'flag': false},
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fchat.svg?alt=media&token=efe43532-6cf3-4382-9691-c72ffdf40a70',
            'Chat Enabled',
            'Turn the chat system On and Off'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fvoice_note.svg?alt=media&token=905f72cc-f9ab-4aa1-a44a-33b892b710c7',
            'Voice Notes',
            'Turn the voice notes in chat On and Off'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fuser_status.svg?alt=media&token=558abb2f-da0c-4222-b6b0-ffb3c0a5ff6e',
            'User Status Enabled',
            'Turn the Last Seen On and Off'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Ftyping_status.svg?alt=media&token=b729925b-1cdf-4766-924f-65cb3c25457a',
            'Typing Status Enabled',
            'Turn the Typing Status On and Off (Needs a good server to work fine)'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fseen_status.svg?alt=media&token=e2ba70ad-5d94-40e6-b0f9-5740b900480e',
            'Seen Status Enabled',
            'Turn the Seen Status On and Off (Needs a good server to work fine)'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fdelete_for.svg?alt=media&token=ea100abb-d511-4eda-88fa-2170b59c9a22',
            'Delete For Everyone',
            'Permanently remove the conversation for all chat members when user delete it'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Faudio_call.svg?alt=media&token=3a2ca3be-a739-437b-9184-3b4885f032c7',
            'Audio Call Enabled',
            'Turn the audio call system On and Off'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        moduleDropDown('Who Can Start Audio Call', audioCallDropdown, ''),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fvideo_call.svg?alt=media&token=181da183-967a-48b3-8cba-b554303cc770',
            'Video Call Enabled',
            'Turn the video call system On and Off'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        moduleDropDown('Who Can Start Video Call', audioCallDropdown, ''),
        const Padding(padding: EdgeInsets.only(top: 20)),
        titleAndsubtitleInput('Twilio Account SID', 30, 1, () {}, ''),
        const Padding(padding: EdgeInsets.only(top: 20)),
        titleAndsubtitleInput('Twilio API SID', 30, 1, () {}, ''),
        const Padding(padding: EdgeInsets.only(top: 20)),
        titleAndsubtitleInput('Twilio API SECRET', 30, 1, () {}, ''),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const AdminSettingFooter()
      ]),
    );
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

  Widget moduleDropDown(title, List<Map> dropDownItems, subTitle) {
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
                      SizedBox(
                        width: 400,
                        child: Text(subTitle),
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

  Widget titleAndsubtitleInput(title, height, line, onChange, subTitle) {
    return Container(
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
                  height: height + 34,
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
}
