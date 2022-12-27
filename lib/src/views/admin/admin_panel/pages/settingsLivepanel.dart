import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/controllers/AdminController.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_footer.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_header.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

// ignore: must_be_immutable
class AdminSettingsLive extends StatefulWidget {
  AdminSettingsLive({Key? key})
      : con = AdminController(),
        super(key: key);
  final AdminController con;
  @override
  State createState() => AdminSettingsLiveState();
}

class AdminSettingsLiveState extends mvc.StateMVC<AdminSettingsLive> {
  Color fontColor = const Color.fromRGBO(82, 95, 127, 1);
  List<Map> liveDropdown = [
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
      padding: EdgeInsets.only(left: 30, right: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AdminSettingHeader(
          icon: Icon(Icons.settings),
          pagename: 'Settings › Live Stream',
          button: const {'flag': false},
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Flive_stream.svg?alt=media&token=f0e2cc42-6d54-4338-9229-3b7806ff0c5f',
            'Live Stream Enabled',
            'Turn the live stream system On and Off'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        moduleDropDown('Who Can Go Live', liveDropdown, ''),
        titleAndsubtitleInput('Agora App ID', 30, 1, () {}, ''),
        titleAndsubtitleInput('Agora App Certificate', 30, 1, () {}, ''),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Flive_video.svg?alt=media&token=f96aa11f-ce2c-46f9-83eb-96021f31c369',
            'Save Live Videos',
            'Turn the save live stream videos On and Off'),
        titleAndsubtitleInput('Agora Customer ID', 30, 1, () {}, ''),
        titleAndsubtitleInput('Agora Customer Secret', 30, 1, () {}, ''),
        titleAndsubtitleInput(
            'S3 Bucket Name', 30, 1, () {}, 'Your Amazon S3 bucket name'),
        AdminSettingFooter()
      ]),
    );
  }

  Widget titleAndsubtitleDropdown(title, List<Map> dropDownItems, subtitle) {
    List items = dropDownItems;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        title,
        style: TextStyle(
            color: Color.fromRGBO(82, 95, 127, 1),
            fontSize: 13,
            fontWeight: FontWeight.w600),
      ),
      Padding(padding: EdgeInsets.only(top: 2)),
      Container(
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
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 10, left: 10),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue, width: 1.0),
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
                      Container(
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
                child: Container(
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
}
