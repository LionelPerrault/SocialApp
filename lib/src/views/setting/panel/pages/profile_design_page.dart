
import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/utils/svg.dart';
import 'package:shnatter/src/views/box/daytimeM.dart';
import 'package:shnatter/src/views/box/mindpost.dart';
import 'package:shnatter/src/views/setting/widget/setting_footer.dart';
import 'package:shnatter/src/views/setting/widget/setting_header.dart';
import 'package:shnatter/src/widget/mindslice.dart';
import 'package:shnatter/src/widget/startedInput.dart';

class SettingDesignScreen extends StatefulWidget {
  SettingDesignScreen({Key? key}) : super(key: key);
  @override
  State createState() => SettingDesignScreenState();
}
// ignore: must_be_immutable
class SettingDesignScreenState extends State<SettingDesignScreen> {
  var setting_profile = {};
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.only(top: 20, left:30),
      child: 
        Column(children: [
          SettingHeader(icon: Icon(Icons.brush, color: Color.fromARGB(255, 43, 83, 164),), pagename: 'Design',
            button: {'buttoncolor': Color.fromARGB(255, 17, 205, 239),
                      'icon': Icon(Icons.person),
                      'text': 'View Profile',
                      'flag': true},),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Container(
            width: SizeConfig(context).screenWidth > SizeConfig.smallScreenSize ? SizeConfig(context).screenWidth * 0.5 + 40 : SizeConfig(context).screenWidth * 0.9 - 30,
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Profile Background'),
                Padding(padding: EdgeInsets.only(left: 15)),
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              UserManager.userInfo['avatar']),
                          fit: BoxFit.cover,
                        ),
                        color: Color.fromRGBO(240, 240, 240, 1),
                        borderRadius: BorderRadius.all(Radius.circular(3))
                      ),
                      width: 80,
                      height: 100,
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: InkWell(
                        onTap: () {
                          
                        },
                        child: Container(
                            margin: const EdgeInsets.only(top: 50,left: 50),
                            child: const Icon(Icons.photo_camera,size: 25,color: Colors.black87,)
                          ),
                        ),
                    )
                    
                    
                  ],
                )
            ],)
          ),
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
