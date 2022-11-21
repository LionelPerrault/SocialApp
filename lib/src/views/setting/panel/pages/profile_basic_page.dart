
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

class SettingBasicScreen extends StatefulWidget {
  SettingBasicScreen({Key? key}) : super(key: key);
  @override
  State createState() => SettingBasicScreenState();
}
// ignore: must_be_immutable
class SettingBasicScreenState extends State<SettingBasicScreen> {
  var setting_profile = {};
  @override
  Widget build(BuildContext context) {
    var sex = 'Male';
    var relation = 'Select Relationship';
    var country = 'Male';
    var birthm = 'Male';
    var birthd = 'Male';
    var birthy = 'Male';
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
                      Text('First Name',
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
                          setting_profile['first_name'] = value;
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
                      Text('Last Name',
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
                          setting_profile['first_name'] = value;
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
                      Text('I am',
                          style: TextStyle(
                              color: Color.fromARGB(
                                  255, 82, 95, 127),
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(
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
                                value: "Male",
                                child: Text("Male")),
                            DropdownMenuItem(
                              value: "Female",
                              child: Text("Female"),
                            ),
                            DropdownMenuItem(
                              value: "Other",
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
                      Text('Last Name',
                          style: TextStyle(
                              color: Color.fromARGB(
                                  255, 82, 95, 127),
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(
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
                            relation= value!;
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
                      Text('Country',
                          style: TextStyle(
                              color: Color.fromARGB(
                                  255, 82, 95, 127),
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(
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
                                value: "Male",
                                child: Text("Male")),
                            DropdownMenuItem(
                              value: "Female",
                              child: Text("Female"),
                            ),
                            DropdownMenuItem(
                              value: "Other",
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
                      Text('Website',
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
                          setting_profile['website'] = value;
                          setState(() {});
                        }),
                      ),
                      Text('Website link must start with http:// or https://', style: TextStyle(fontSize: 12),)
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
                      Text('Birthday',
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
                          items: const [
                            //add items in the dropdown
                            DropdownMenuItem(
                              value: "Select Sex",
                              child: Text("Select Sex"),
                            ),
                            DropdownMenuItem(
                                value: "Male",
                                child: Text("Male")),
                            DropdownMenuItem(
                              value: "Female",
                              child: Text("Female"),
                            ),
                            DropdownMenuItem(
                              value: "Other",
                              child: Text("Other"),
                            ),
                          ],
                          onChanged: (String? value) {
                            //get value when changed
                            setting_profile['birthm'] = value;
                            birthm= value!;
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
                          items: const [
                            //add items in the dropdown
                            DropdownMenuItem(
                              value: "Select Sex",
                              child: Text("Select Sex"),
                            ),
                            DropdownMenuItem(
                                value: "Male",
                                child: Text("Male")),
                            DropdownMenuItem(
                              value: "Female",
                              child: Text("Female"),
                            ),
                            DropdownMenuItem(
                              value: "Other",
                              child: Text("Other"),
                            ),
                          ],
                          onChanged: (String? value) {
                            //get value when changed
                            setting_profile['birthd'] = value;
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
                          items: const [
                            //add items in the dropdown
                            DropdownMenuItem(
                              value: "Select Sex",
                              child: Text("Select Sex"),
                            ),
                            DropdownMenuItem(
                                value: "Male",
                                child: Text("Male")),
                            DropdownMenuItem(
                              value: "Female",
                              child: Text("Female"),
                            ),
                            DropdownMenuItem(
                              value: "Other",
                              child: Text("Other"),
                            ),
                          ],
                          onChanged: (String? value) {
                            //get value when changed
                            setting_profile['birthy'] = value;
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
                          setting_profile['religion'] = value;
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
