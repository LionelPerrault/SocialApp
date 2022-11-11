
import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/utils/svg.dart';
import 'package:shnatter/src/views/box/daytimeM.dart';
import 'package:shnatter/src/views/box/mindpost.dart';
import 'package:shnatter/src/views/setting/widget/setting_footer.dart';
import 'package:shnatter/src/views/setting/widget/setting_header.dart';
import 'package:shnatter/src/widget/mindslice.dart';
import 'package:shnatter/src/widget/startedInput.dart';

class SettingMainPanel extends StatefulWidget {
  SettingMainPanel({Key? key}) : super(key: key);
  @override
  State createState() => SettingMainPanelState();
}
// ignore: must_be_immutable
class SettingMainPanelState extends State<SettingMainPanel> {
  var setting_security = {};
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.only(top: 20, left:30),
      child: 
        Column(children: [
          SettingHeader(icon: Icon(Icons.security_outlined, color: Color.fromARGB(255, 139, 195, 74),), pagename: 'Change Password',
            button: {'flag': false},),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Container(
            width: SizeConfig(context).screenWidth * 0.5,
            child: Column(children: [
              Container(
                width: 680,
                height: 65,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 252, 124, 95),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Row(children: const [
                  Padding(padding: EdgeInsets.only(left: 30)),
                  Icon(Icons.warning_rounded, color: Colors.white, size: 30,),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Text('Changing password will log you out from all other sessions',
                  style: TextStyle(color: Colors.white,
                                    fontSize: 11),)
                ],),
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text('Confirm Current Password',
                          style: TextStyle(
                              color: Color.fromARGB(
                                  255, 82, 95, 127),
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                      Container(
                        width: 700,
                        child:
                            input(validator: (value) async {
                          print(value);
                        }, onchange: (value) async {
                          setting_security['currentpass'] = value;
                          setState(() {});
                        }),
                      )
                    ],)
                  ),
                  const Padding(padding: EdgeInsets.only(right: 20))
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text('Your New Password',
                          style: TextStyle(
                              color: Color.fromARGB(
                                  255, 82, 95, 127),
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                      Container(
                        width: 300,
                        child:
                            input(validator: (value) async {
                          print(value);
                        }, onchange: (value) async {
                          setting_security['newpass'] = value;
                          setState(() {});
                        }),
                      )
                    ],)
                  ),
                  const Padding(padding: EdgeInsets.only(left: 25)),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text('Confirm New Password',
                          style: TextStyle(
                              color: Color.fromARGB(
                                  255, 82, 95, 127),
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                      Container(
                        width: 300,
                        child:
                            input(validator: (value) async {
                          print(value);
                        }, onchange: (value) async {
                          setting_security['confirm'] = value;
                          setState(() {});
                        }),
                      )
                    ],)
                  ),
                  const Padding(padding: EdgeInsets.only(right: 20))
                ],
              ),
            ],),
          ),
          const Padding(padding: EdgeInsets.only(top: 20)),
          SettingFooter()
      ],)
      );
  }
  Widget input({label, onchange, obscureText = false, validator}) {
    return Container(
      height: 28,
      child: StartedInput(
        validator: (val) async {
          validator(val);
        },
        obscureText: obscureText,
        onChange: (val) async {
          onchange(val);
        },
      ),
    );
  }
}
