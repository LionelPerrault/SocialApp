
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

class SettingSocialScreen extends StatefulWidget {
  SettingSocialScreen({Key? key}) : super(key: key);
  @override
  State createState() => SettingSocialScreenState();
}
// ignore: must_be_immutable
class SettingSocialScreenState extends State<SettingSocialScreen> {
  var setting_profile = {};
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.only(top: 20, left:30),
      child: 
        Column(children: [
          SettingHeader(icon: Icon(Icons.facebook, color: Color.fromARGB(255, 43, 83, 164),), pagename: 'Social Links',
            button: {'buttoncolor': Color.fromARGB(255, 17, 205, 239),
                      'icon': Icon(Icons.person),
                      'text': 'View Profile',
                      'flag': true},),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Container(
            width: SizeConfig(context).screenWidth > SizeConfig.smallScreenSize ? SizeConfig(context).screenWidth * 0.5 + 40 : SizeConfig(context).screenWidth * 0.9 - 30,
            child: Column(children: [
              GridView.count(
                crossAxisCount: SizeConfig(context).screenWidth > SizeConfig.smallScreenSize ? 2 : 1,
                childAspectRatio: 4 / 1,
                padding: const EdgeInsets.all(4.0),
                mainAxisSpacing: 4.0,
                shrinkWrap: true,
                crossAxisSpacing: 4.0,
                children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text('Facebook Profile URL',
                      style: TextStyle(
                          color: Color.fromARGB(
                              255, 82, 95, 127),
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                  Row(children: [
                  Container(
                    width: 40,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 0.1)
                    ),
                    child: Icon(Icons.facebook, color: Color.fromARGB(255, 59, 87, 157),),
                  ),
                  Container(
                    width: 195,
                    height: 30,
                    child: TextFormField(
                            onChanged: (newIndex) {
                              setting_profile['facebook'] = newIndex;
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 54, 54, 54), width: 1.0),
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            style: const TextStyle(fontSize: 14),
                            onSaved: (String? value) {
                              // This optional block of code can be used to run
                              // code when the user saves the form.
                            },
                            validator: (String? value) {
                              return (value != null && value.contains('@'))
                                  ? 'Do not use the @ char.'
                                  : null;
                            },
                          ),
                  ),
                ]),
                ],),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text('Twitter Profile URL',
                      style: TextStyle(
                          color: Color.fromARGB(
                              255, 82, 95, 127),
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                  Row(children: [
                  Container(
                    width: 40,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 0.1)
                    ),
                    child: Icon(Icons.new_releases_sharp, color: Color.fromARGB(255, 59, 87, 157),),
                  ),
                  Container(
                    width: 195,
                    height: 30,
                    child: TextFormField(
                            onChanged: (newIndex) {
                              setting_profile['twitter'] = newIndex;
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 54, 54, 54), width: 1.0),
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            style: const TextStyle(fontSize: 14),
                            onSaved: (String? value) {
                              // This optional block of code can be used to run
                              // code when the user saves the form.
                            },
                            validator: (String? value) {
                              return (value != null && value.contains('@'))
                                  ? 'Do not use the @ char.'
                                  : null;
                            },
                          ),
                  ),
                ]),
                ],),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text('Youtube Profile URL',
                      style: TextStyle(
                          color: Color.fromARGB(
                              255, 82, 95, 127),
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                  Row(children: [
                  Container(
                    width: 40,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 0.1)
                    ),
                    child: Icon(Icons.facebook, color: Color.fromARGB(255, 59, 87, 157),),
                  ),
                  Container(
                    width: 195,
                    height: 30,
                    child: TextFormField(
                            onChanged: (newIndex) {
                              setting_profile['facebook'] = newIndex;
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 54, 54, 54), width: 1.0),
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            style: const TextStyle(fontSize: 14),
                            onSaved: (String? value) {
                              // This optional block of code can be used to run
                              // code when the user saves the form.
                            },
                            validator: (String? value) {
                              return (value != null && value.contains('@'))
                                  ? 'Do not use the @ char.'
                                  : null;
                            },
                          ),
                  ),
                ]),
                ],),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text('Instagram Profile URL',
                      style: TextStyle(
                          color: Color.fromARGB(
                              255, 82, 95, 127),
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                  Row(children: [
                  Container(
                    width: 40,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 0.1)
                    ),
                    child: Icon(Icons.new_releases_sharp, color: Color.fromARGB(255, 59, 87, 157),),
                  ),
                  Container(
                    width: 195,
                    height: 30,
                    child: TextFormField(
                            onChanged: (newIndex) {
                              setting_profile['twitter'] = newIndex;
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 54, 54, 54), width: 1.0),
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            style: const TextStyle(fontSize: 14),
                            onSaved: (String? value) {
                              // This optional block of code can be used to run
                              // code when the user saves the form.
                            },
                            validator: (String? value) {
                              return (value != null && value.contains('@'))
                                  ? 'Do not use the @ char.'
                                  : null;
                            },
                          ),
                  ),
                ]),
                ],),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text('Twitch Profile URL',
                      style: TextStyle(
                          color: Color.fromARGB(
                              255, 82, 95, 127),
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                  Row(children: [
                  Container(
                    width: 40,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 0.1)
                    ),
                    child: Icon(Icons.youtube_searched_for_sharp, color: Color.fromARGB(255, 59, 87, 157),),
                  ),
                  Container(
                    width: 195,
                    height: 30,
                    child: TextFormField(
                            onChanged: (newIndex) {
                              setting_profile['youtube'] = newIndex;
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 54, 54, 54), width: 1.0),
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            style: const TextStyle(fontSize: 14),
                            onSaved: (String? value) {
                              // This optional block of code can be used to run
                              // code when the user saves the form.
                            },
                            validator: (String? value) {
                              return (value != null && value.contains('@'))
                                  ? 'Do not use the @ char.'
                                  : null;
                            },
                          ),
                  ),
                ]),
                ],),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text('Linkedin Profile URL',
                      style: TextStyle(
                          color: Color.fromARGB(
                              255, 82, 95, 127),
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                  Row(children: [
                  Container(
                    width: 40,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 0.1)
                    ),
                    child: Icon(Icons.new_releases_sharp, color: Color.fromARGB(255, 59, 87, 157),),
                  ),
                  Container(
                    width: 195,
                    height: 30,
                    child: TextFormField(
                            onChanged: (newIndex) {
                              setting_profile['twitter'] = newIndex;
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 54, 54, 54), width: 1.0),
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            style: const TextStyle(fontSize: 14),
                            onSaved: (String? value) {
                              // This optional block of code can be used to run
                              // code when the user saves the form.
                            },
                            validator: (String? value) {
                              return (value != null && value.contains('@'))
                                  ? 'Do not use the @ char.'
                                  : null;
                            },
                          ),
                  ),
                ]),
                ],),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text('Vokontakte Profile URL',
                        style: TextStyle(
                            color: Color.fromARGB(
                                255, 82, 95, 127),
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                    Row(children: [
                    Container(
                      width: 40,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 0.1)
                      ),
                      child: Icon(Icons.facebook, color: Color.fromARGB(255, 59, 87, 157),),
                    ),
                    Container(
                      width: 195,
                      height: 30,
                      child: TextFormField(
                              onChanged: (newIndex) {
                                setting_profile['facebook'] = newIndex;
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 54, 54, 54), width: 1.0),
                                  borderRadius: BorderRadius.circular(0),
                                ),
                              ),
                              style: const TextStyle(fontSize: 14),
                              onSaved: (String? value) {
                                // This optional block of code can be used to run
                                // code when the user saves the form.
                              },
                              validator: (String? value) {
                                return (value != null && value.contains('@'))
                                    ? 'Do not use the @ char.'
                                    : null;
                              },
                            ),
                    ),
                  ]),
                  ],)
              ]),
            ],
            ),
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
