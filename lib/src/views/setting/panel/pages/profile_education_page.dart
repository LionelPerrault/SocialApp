
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

class SettingEducationScreen extends StatefulWidget {
  SettingEducationScreen({Key? key}) : super(key: key);
  @override
  State createState() => SettingEducationScreenState();
}
// ignore: must_be_immutable
class SettingEducationScreenState extends State<SettingEducationScreen> {
  var setting_profile = {};
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.only(top: 20, left:30),
      child: 
        Column(children: [
          SettingHeader(icon: Icon(Icons.school, color: Color.fromARGB(255, 43, 83, 164),), pagename: 'Education',
            button: {'buttoncolor': Color.fromARGB(255, 17, 205, 239),
                      'icon': Icon(Icons.person),
                      'text': 'View Profile',
                      'flag': true},),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Container(
            width: SizeConfig(context).screenWidth > SizeConfig.smallScreenSize ? SizeConfig(context).screenWidth * 0.5 + 40 : SizeConfig(context).screenWidth * 0.9 - 30,
            child: Column(children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text('School',
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
                          setting_profile['school'] = value;
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
                      Text('Major',
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
                          setting_profile['major'] = value;
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
                      Text('Class',
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
                          setting_profile['class'] = value;
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
