import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/controllers/AdminController.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_footer.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_header.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

// ignore: must_be_immutable

class AdminSettingsEmail extends StatefulWidget {
  AdminSettingsEmail({Key? key})
      : con = AdminController(),
        super(key: key);
  final AdminController con;
  @override
  State createState() => AdminSettingsEmailState();
}

class AdminSettingsEmailState extends mvc.StateMVC<AdminSettingsEmail> {
  Color fontColor = const Color.fromRGBO(82, 95, 127, 1);
  String tab = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AdminSettingHeader(
          icon: Icon(Icons.settings),
          pagename: 'Settings › Email',
          button: const {'flag': false},
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2FSMTP.svg?alt=media&token=1429acde-2708-433e-9e3a-dd7b61f1d03a',
            'SMTP',
            'Enable/Disable SMTP email system PHP mail() function will be used in case of disabled'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2FSMTP_require.svg?alt=media&token=c55fe407-4a40-42bb-bdfb-8c6d808f9f44',
            'SMTP Require Authentication',
            'Enable/Disable SMTP authentication'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2FSMTP_ssl.svg?alt=media&token=e8a406e8-8278-46ca-8fdb-7c5a8157b137',
            'SMTP SSL Encryption',
            'Enable/Disable SMTP SSL encryption TLS encryption will be used in case of disabled'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fmemories.svg?alt=media&token=253f45d8-177f-4eba-9ca6-bb2c28cbb7ff',
            'Memories',
            'Turn the memories On and Off Memories are posts from the same day on last year'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        titleAndsubtitleInput('SMTP Server', 30, 1, () {}, ''),
        titleAndsubtitleInput('SMTP Port', 30, 1, () {}, ''),
        titleAndsubtitleInput('SMTP Username', 30, 1, () {}, ''),
        titleAndsubtitleInput('SMTP Password', 30, 1, () {}, ''),
        titleAndsubtitleInput('Set From', 30, 1, () {},
            'Set the From email address, For example: email@domain.com'),
        AdminSettingFooter()
      ]),
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
