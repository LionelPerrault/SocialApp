
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
          SettingHeader(icon: const Icon(Icons.delete,color: Color.fromARGB(255, 244, 67, 54),), pagename: 'Delete Account',
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
                  Text('Once you delete your account you will no longer can access it again',
                  style: TextStyle(color: Colors.white,
                                    fontSize: 11),)
                ],),
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: 145,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(3),
                          backgroundColor: Color.fromARGB(255, 245, 54, 92),
                          // elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0)),
                          minimumSize: const Size(140, 50),
                          maximumSize: const Size(140, 50),
                        ),
                        onPressed: () {
                          (()=>{});
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                          Icon(Icons.delete),
                          Text('Delete My Account', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold))
                        ],))
                    ),
                    )
                ],
              ),
            ],),
          ),
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
