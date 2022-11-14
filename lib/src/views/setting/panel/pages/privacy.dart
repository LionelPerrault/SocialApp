
import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:shnatter/src/utils/colors.dart';
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
  Map<String, String> privacyInfo = {
    'poke' : 'every',
    'postWall' : 'every',
    'gender' : 'every',
    'relation' : 'every',
    'birthday' : 'every',
    'basic' : 'every',
    'work' : 'every',
    'location' : 'every',
    'education' : 'every',
    'other' : 'every',
    'friends' : 'every',
    'photos' : 'every',
    'pages' : 'every',
    'groups' : 'every',
    'events' : 'every',
  };
  var chatEnable = false;
  var mailEnable = false;
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.only(top: 20, left:50),
      child: 
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          SettingHeader(icon: Icon(Icons.privacy_tip_rounded, color: Color.fromARGB(255, 255, 179, 7)), pagename: 'Privacy',
            button: {'flag': false},),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Container(
            width: SizeConfig(context).screenWidth * 0.6,
            child: Column(children: [
              Row(children: [
                Expanded(
                  child: Container(
                    child: Row(children: [
                      Container(
                        width: 35,
                        height: 35,
                        child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fsettings%2Fchat.svg?alt=media&token=7159b8b4-0333-4061-b09f-01688d80a049'),
                      ),
                      const Padding(padding: EdgeInsets.only(left: 10)),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                        Text('Chat Enabled', style: TextStyle(
                          color: Color.fromARGB(255, 82, 95, 127),
                          fontSize: 13,
                          fontWeight: FontWeight.bold
                        ),),
                        Padding(padding: EdgeInsets.only(top: 5)),
                        Text('If chat disabled you will appear offline and will no see who is online too', style: TextStyle(
                          fontSize: 11
                        ),)
                      ],),
                      const Flexible(fit: FlexFit.tight, child: SizedBox()),
                      SizedBox(
                        height: 20,
                        child: Transform.scale(
                          scaleX: 0.55,
                          scaleY: 0.55,
                          child: CupertinoSwitch(
                            //thumbColor: kprimaryColor,
                            activeColor: kprimaryColor,
                            value: chatEnable,
                            onChanged: (value) {
                              setState(() {
                                chatEnable = value;
                              });
                            },
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(left: 15))
                    ],),
                  )
                )
              ],)
            ],),
          ),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Container(
            width: SizeConfig(context).screenWidth * 0.6,
            child: Column(children: [
              Row(children: [
                Expanded(
                  child: Container(
                    child: Row(children: [
                      Container(
                        width: 35,
                        height: 35,
                        child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fsettings%2Fmail.svg?alt=media&token=307c1448-f196-4f96-ad89-2bcaf638f179'),
                      ),
                      const Padding(padding: EdgeInsets.only(left: 10)),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                        Text('Email you with our newsletter', style: TextStyle(
                          color: Color.fromARGB(255, 82, 95, 127),
                          fontSize: 13,
                          fontWeight: FontWeight.bold
                        ),),
                        Padding(padding: EdgeInsets.only(top: 5)),
                        Text('From time to time we send newsletter email to all of our members', style: TextStyle(
                          fontSize: 11
                        ),)
                      ],),
                      const Flexible(fit: FlexFit.tight, child: SizedBox()),
                      SizedBox(
                        height: 20,
                        child: Transform.scale(
                          scaleX: 0.55,
                          scaleY: 0.55,
                          child: CupertinoSwitch(
                            //thumbColor: kprimaryColor,
                            activeColor: kprimaryColor,
                            value: chatEnable,
                            onChanged: (value) {
                              setState(() {
                                chatEnable = value;
                              });
                            },
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(left: 15))
                    ],),
                  )
                )
              ],)
            ],),
          ),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Row(children: [
            select('Who can poke you', const Icon(Icons.clean_hands), privacyInfo['poke']!,
              (value) async {
              privacyInfo['poke'] = value;
              setState(() {});
            }),
            select('Who can post on your wall', const Icon(Icons.newspaper), privacyInfo['postWall']!,
              (value) async {
              privacyInfo['postWall'] = value;
              setState(() {});
            })
          ],),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Row(children: [
            select('Who can see your gender', const Icon(Icons.manage_search_sharp), privacyInfo['gender']!,
              (value) async {
              privacyInfo['gender'] = value;
              setState(() {});
            }),
            select('Who can see your relationship', const Icon(Icons.heart_broken_sharp), privacyInfo['relation']!,
              (value) async {
              privacyInfo['relation'] = value;
              setState(() {});
            })
          ],),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Row(children: [
            select('Who can see your birthdate', const Icon(Icons.cake), privacyInfo['birthday']!,
              (value) async {
              privacyInfo['birthday'] = value;
              setState(() {});
            }),
            select('Who can see your basic info', const Icon(Icons.person), privacyInfo['basic']!,
              (value) async {
              privacyInfo['basic'] = value;
              setState(() {});
            })
          ],),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Row(children: [
            select('Who can see your work info', const Icon(Icons.work), privacyInfo['work']!,
              (value) async {
              privacyInfo['work'] = value;
              setState(() {});
            }),
            select('Who can see your location info', const Icon(Icons.location_on_sharp), privacyInfo['location']!,
              (value) async {
              privacyInfo['location'] = value;
              setState(() {});
            })
          ],),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Row(children: [
            select('Who can see your education info', const Icon(Icons.school), privacyInfo['education']!,
              (value) async {
              privacyInfo['education'] = value;
              setState(() {});
            }),
            select('Who can see your other info', const Icon(Icons.folder_shared), privacyInfo['other']!,
              (value) async {
              privacyInfo['other'] = value;
              setState(() {});
            })
          ],),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Row(children: [
            select('Who can see your friends', const Icon(Icons.group), privacyInfo['friends']!,
              (value) async {
              privacyInfo['friends'] = value;
              setState(() {});
            }),
            select('Who can see your photos', const Icon(Icons.photo), privacyInfo['photos']!,
              (value) async {
              privacyInfo['photos'] = value;
              setState(() {});
            })
          ],),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Row(children: [
            select('Who can see your liked pages', const Icon(Icons.flag_rounded), privacyInfo['pages']!,
              (value) async {
              privacyInfo['pages'] = value;
              setState(() {});
            }),
            select('Who can see your joined groups', const Icon(Icons.groups), privacyInfo['groups']!,
              (value) async {
              privacyInfo['groups'] = value;
              setState(() {});
            })
          ],),
          
          const Padding(padding: EdgeInsets.only(top: 20)),
          Row(children: [
            select('Who can see your joined events', const Icon(Icons.event), privacyInfo['events']!,
              (value) async {
              privacyInfo['events'] = value;
              setState(() {});
            }),
          ],),
          SettingFooter()
      ],)
      );
  }

  @override
  Widget select(text, icon, String info, onchange) {
    return Expanded(
            flex: 1,
            child: 
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(text, style: TextStyle(
                color: Color.fromARGB(255, 82, 95, 127),
                fontSize: 11,
                fontWeight: FontWeight.bold
              ),),
              Row(children: [
                Container(
                  alignment: Alignment.center,
                  color: Colors.grey,
                  width: 30,
                  height: 30,
                  child: icon,
                ),
                Container(
                  width: 300,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(
                          255, 250, 250, 250),
                      border:
                          Border.all(color: Colors.grey)),
                  padding: const EdgeInsets.only(left: 20),
                  child: DropdownButton(
                    value: info,
                    items: const [
                      //add items in the dropdown
                      DropdownMenuItem(
                        value: "every",
                        child: Text("Everyone"),
                      ),
                      DropdownMenuItem(
                          value: "friends",
                          child: Text("Friends")),
                      DropdownMenuItem(
                        value: "noone",
                        child: Text("No One"),
                      )
                    ],
                    onChanged: (String? value) {
                      //get value when changed
                      onchange(value);
                    },
                    style: const TextStyle(
                        //te
                        color: Colors.black, //Font color
                        fontSize:
                            12 //font size on dropdown button
                        ),

                    dropdownColor: Colors.white,
                    underline:
                        Container(), //remove underline
                    isExpanded: true,
                    isDense: true,
                  ),
                ),
              ],)
            ],)
          );
  }
}
