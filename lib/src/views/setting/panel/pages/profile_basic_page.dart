
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/utils/svg.dart';
import 'package:shnatter/src/views/box/daytimeM.dart';
import 'package:shnatter/src/views/box/mindpost.dart';
import 'package:shnatter/src/views/setting/widget/setting_footer.dart';
import 'package:shnatter/src/views/setting/widget/setting_header.dart';
import 'package:shnatter/src/widget/mindslice.dart';
import 'package:shnatter/src/widget/startedInput.dart';

class SettingBasicScreen extends StatefulWidget {
  SettingBasicScreen({Key? key}) :
    con = UserController(),
   super(key: key);
  late UserController con;
  @override
  State createState() => SettingBasicScreenState();
}
// ignore: must_be_immutable
class SettingBasicScreenState extends mvc.StateMVC<SettingBasicScreen> {
  var setting_profile = {};
  var sex = 'male';
    var relation = 'Select Relationship';
    var country = 'male';
    var birthm = '1';
    var birthd = '1';
    var birthy = '1910';
  var userInfo = UserManager.userInfo;
  List month = [{'value':'1','data':'Jan'},{'value':'2','data':'Feb'},{'value':'3','data':'Mar'},
      {'value':'4','data':'Apr'},{'value':'5','data':'May'},{'value':'6','data':'Jun'},{'value':'7','data':'Jul'},
      {'value':'8','data':'Aug'},{'value':'9','data':'Sep'},{'value':'10','data':'Oct'},{'value':'11','data':'Nov'},{'value':'12','data':'Dec'}];
  late Map day = {};
  late List year = [];
  TextEditingController aboutController = TextEditingController();
  TextEditingController religionController = TextEditingController();
  late UserController con;
  @override
  void initState(){
    add(widget.con);
    con = controller as UserController;
    // sex = userInfo['sex'] ?? 'male';
    aboutController.text = userInfo['about'] ?? '';
    religionController.text = userInfo['current'] ?? '';
    for(int i = 1; i < 13; i++){
      var d = [];
      for(int j = 1; j < 32; j++){
        if(i == 2 && j == 29){
          break;
        }
        else if(i == 4 || i == 6 || i == 9 || i == 11){
          if(j == 31){
            break;
          }
        }
        d.add(j.toString());
      }
      day = {...day,i.toString():d};
    }
    for(int i = 1910; i < 2022; i++){
      year.add(i.toString());
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    List bDay = day[birthm];
    return Container(padding: const EdgeInsets.only(top: 20, left:30),
      child: 
        Column(children: [
          SettingHeader(icon: Icon(Icons.person, color: Color.fromARGB(255, 43, 83, 164),), pagename: 'Basic',
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
                      const Text('First Name',
                          style: TextStyle(
                              color: Color.fromARGB(
                                  255, 82, 95, 127),
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 300,
                        child:
                            input(validator: (value) async {
                          print(value);
                        }, onchange: (value) async {
                          setting_profile['firstName'] = value;
                        },text:userInfo['firstName']),
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
                      const Text('Last Name',
                          style: TextStyle(
                              color: Color.fromARGB(
                                  255, 82, 95, 127),
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 300,
                        child:
                            input(validator: (value) async {
                          print(value);
                        }, onchange: (value) async {
                          setting_profile['lastName'] = value;
                        },text:userInfo['lastName']),
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
                      const Text('I am',
                          style: TextStyle(
                              color: Color.fromARGB(
                                  255, 82, 95, 127),
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(
                                255, 250, 250, 250),
                            border:
                                Border.all(color: Colors.grey)),
                        padding: const EdgeInsets.only(left: 20),
                        child: DropdownButton(
                          value: sex,
                          items: const [
                            //add items in the dropdown
                            DropdownMenuItem(
                              value: "Select Sex",
                              child: Text("Select Sex"),
                            ),
                            DropdownMenuItem(
                                value: "male",
                                child: Text("Male")),
                            DropdownMenuItem(
                              value: "female",
                              child: Text("Female"),
                            ),
                            DropdownMenuItem(
                              value: "other",
                              child: Text("Other"),
                            ),
                          ],
                          onChanged: (String? value) {
                            //get value when changed
                            setting_profile['sex'] = value;
                            sex = value!;
                            setState(() {});
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
                  ),
                  const Padding(padding: EdgeInsets.only(left: 25)),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Relationship Status',
                          style: TextStyle(
                              color: Color.fromARGB(
                                  255, 82, 95, 127),
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(
                                255, 250, 250, 250),
                            border:
                                Border.all(color: Colors.grey)),
                        padding: const EdgeInsets.only(left: 20),
                        child: DropdownButton(
                          value: relation,
                          items: const [
                            //add items in the dropdown
                            DropdownMenuItem(
                              value: "Select Relationship",
                              child: Text("Select Relationship"),
                            ),
                            DropdownMenuItem(
                                value: "Single",
                                child: Text("Single")),
                            DropdownMenuItem(
                              value: "In a relationship",
                              child: Text("In a relationship"),
                            ),
                            DropdownMenuItem(
                              value: "Married",
                              child: Text("Married"),
                            ),
                            DropdownMenuItem(
                              value: "It's a complicated",
                              child: Text("It's a complicated"),
                            ),
                            DropdownMenuItem(
                              value: "Seperated",
                              child: Text("Seperated"),
                            ),
                            DropdownMenuItem(
                              value: "Divorced",
                              child: Text("Divorced"),
                            ),
                            DropdownMenuItem(
                              value: "Widowed",
                              child: Text("Widowed"),
                            ),
                          ],
                          onChanged: (String? value) {
                            //get value when changed
                            setting_profile['relation'] = value;
                            relation = value!;
                            setState(() {});
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
                      const Text('Country',
                          style: TextStyle(
                              color: Color.fromARGB(
                                  255, 82, 95, 127),
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(
                                255, 250, 250, 250),
                            border:
                                Border.all(color: Colors.grey)),
                        padding: const EdgeInsets.only(left: 20),
                        child: DropdownButton(
                          value: country,
                          items: const [
                            //add items in the dropdown
                            DropdownMenuItem(
                              value: "Select Sex",
                              child: Text("Select Sex"),
                            ),
                            DropdownMenuItem(
                                value: "male",
                                child: Text("Male")),
                            DropdownMenuItem(
                              value: "female",
                              child: Text("Female"),
                            ),
                            DropdownMenuItem(
                              value: "other",
                              child: Text("Other"),
                            ),
                          ],
                          onChanged: (String? value) {
                            //get value when changed
                            setting_profile['country'] = value;
                            country= value!;
                            setState(() {});
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
                  ),
                  const Padding(padding: EdgeInsets.only(left: 25)),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Website',
                          style: TextStyle(
                              color: Color.fromARGB(
                                  255, 82, 95, 127),
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 300,
                        child:
                            input(validator: (value) async {
                          print(value);
                        }, onchange: (value) async {
                          setting_profile['workWebsite'] = value;
                        },text:userInfo['workWebsite'] ?? ''),
                      ),
                      const Text('Website link must start with http:// or https://', style: TextStyle(fontSize: 12),)
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
                      const Text('Birthday',
                          style: TextStyle(
                              color: Color.fromARGB(
                                  255, 82, 95, 127),
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                      Container(
                        width: 200,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(
                                255, 250, 250, 250),
                            border:
                                Border.all(color: Colors.grey)),
                        padding: const EdgeInsets.only(left: 20),
                        child: DropdownButton(
                          value: birthm,
                          items: month.map((e) => 
                            DropdownMenuItem(
                              value: e['value'],
                              child: Text(e['data']))
                          ).toList(),
                          onChanged: (value) {
                            //get value when changed
                            birthm = value.toString();
                            setting_profile['birthM'] = birthm;
                            setState(() {});
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
                  ),
                  const Padding(padding: EdgeInsets.only(left: 25)),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text('',
                          style: TextStyle(
                              color: Color.fromARGB(
                                  255, 82, 95, 127),
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                      Container(
                        width: 200,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(
                                255, 250, 250, 250),
                            border:
                                Border.all(color: Colors.grey)),
                        padding: const EdgeInsets.only(left: 20),
                        child: DropdownButton(
                          value: birthd,
                          items: bDay.map((e) => 
                            DropdownMenuItem(
                              value: e,
                              child: Text(e)
                            )
                          ).toList(),
                          onChanged: (value) {
                            //get value when changed
                            birthd = value.toString();
                            setting_profile['birthD'] = birthd;
                            setState(() {});
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
                  ),
                  const Padding(padding: EdgeInsets.only(left: 25)),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text('',
                          style: TextStyle(
                              color: Color.fromARGB(
                                  255, 82, 95, 127),
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                      Container(
                        width: 200,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(
                                255, 250, 250, 250),
                            border:
                                Border.all(color: Colors.grey)),
                        padding: const EdgeInsets.only(left: 20),
                        child: DropdownButton(
                          value: birthy,
                          items: year.map(((e) => 
                            DropdownMenuItem(
                              value: e,
                              child: Text(e))
                          )).toList(),
                          onChanged: (value) {
                            //get value when changed
                            setting_profile['birthY'] = value.toString();
                            birthy = value.toString();
                            setState(() {});
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
                      Text('About Me',
                          style: TextStyle(
                              color: Color.fromARGB(
                                  255, 82, 95, 127),
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                      Container(
                        width: 700,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(
                                255, 250, 250, 250),
                            border:
                                Border.all(color: Colors.grey)),
                        padding: const EdgeInsets.only(left: 20),
                        child: TextFormField(
                          controller: aboutController,
                          onChanged: (value){
                            setting_profile['about'] = value;
                          },
                              minLines: 1,
                              maxLines: 5,
                              keyboardType: TextInputType.multiline,
                              style: TextStyle(fontSize: 12),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: '',
                                hintStyle: TextStyle(color: Colors.grey),
                                contentPadding:
                                    EdgeInsets.only(left: 15, bottom: 11, top: 0, right: 15),
                              ),
                            ),
                      ),
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
                      Text('Religion',
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
                          setting_profile['current'] = value;
                          setState(() {});
                        },text: userInfo['current'] ?? ''),
                      )
                    ],)
                  ),
                  const Padding(padding: EdgeInsets.only(right: 20))
                ],
              ),
              
            ],),
          ),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Padding(
      padding: EdgeInsets.only(right: 20, top: 20),
      child: Container(
        height: 65,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color.fromARGB(255, 220, 226, 237),
              width: 1,
            )
          ),
          color: Color.fromARGB(255, 240, 243, 246),
          // borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        padding: const EdgeInsets.only(top: 5, left: 15),
        child: Row(children: [
          const Flexible(fit: FlexFit.tight, child: SizedBox()),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(3),
              backgroundColor: Colors.white,
              // elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              minimumSize: con.isProfileChange ? const Size(90, 50) : const Size(120, 50),
              maximumSize: con.isProfileChange ? const Size(90, 50) : const Size(120, 50),
            ),
            onPressed: () {
              con.profileChange(setting_profile);
            },
            child: con.isProfileChange ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                  SizedBox(
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(color: Colors.black),
                  ),
                  Padding(padding: EdgeInsets.only(left: 7)),
                  Text('Loading', style: TextStyle(fontSize: 11, color: Colors.black, fontWeight: FontWeight.bold))
                ],) : const Text('Save Changes', style: TextStyle(fontSize: 11, color: Colors.black, fontWeight: FontWeight.bold))),
            const Padding(padding: EdgeInsets.only(right: 30))
        ],)
        ),
    )
      ],)
      );
  }
  Widget input({label, onchange, obscureText = false, validator,text = ''}) {
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
        text:text
      ),
    );
  }
}
