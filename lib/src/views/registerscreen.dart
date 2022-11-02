import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/widget/primaryInput.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widget/mprimary_button.dart';
import './footerbar.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);
  State createState() => RegisterScreenState();
}

class RegisterScreenState extends mvc.StateMVC<RegisterScreen> {
  bool check1 = false;
  bool check2 = false;
  @override
  void initState() {}
  String dropdownValue = 'Male';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        "https://test.shnatter.com/content/themes/default/images/main-background-min.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 170),
                      height: 670,
                      child: SizedBox(
                          width: 300,
                          height: 670,
                          child: Container(
                              height: 670,
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                              margin: const EdgeInsets.only(bottom: 50),
                              child: ListView(children: [
                                Container(
                                    margin: const EdgeInsets.only(top: 40),
                                    padding: const EdgeInsets.only(
                                        left: 30, top: 15),
                                    width: double.infinity,
                                    height: 60,
                                    color: const Color.fromRGBO(11, 35, 45, 1),
                                    child: const Text(
                                      'Register',
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                      ),
                                    )),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 25, right: 25),
                                  child: Column(
                                    children: [
                                      const Padding(
                                          padding: EdgeInsets.only(top: 20)),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: SvgPicture.network(
                                            'https://test.shnatter.com/content/themes/default/images/shnatter-logo-login.svg'),
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(top: 20)),
                                      input(
                                          'First Name',
                                          const Icon(
                                            Icons.person,
                                            color: Colors.white,
                                          )),
                                      input(
                                          'Last Name',
                                          const Icon(
                                            Icons.person,
                                            color: Colors.white,
                                          )),
                                      input(
                                          'User Name',
                                          const Icon(
                                            Icons.ev_station_sharp,
                                            color: Colors.white,
                                          )),
                                      input(
                                          'Email',
                                          const Icon(
                                            Icons.email,
                                            color: Colors.white,
                                          )),
                                      input(
                                          'Password',
                                          const Icon(
                                            Icons.key,
                                            color: Colors.white,
                                          )),
                                      Container(
                                          width: double.infinity - 50,
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          decoration: const ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  width: 0.5,
                                                  style: BorderStyle.solid),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0)),
                                            ),
                                          ),
                                          child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                color: const Color.fromRGBO(
                                                    35,
                                                    35,
                                                    35,
                                                    1), //background color of dropdown button
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width:
                                                        0.1), //border of dropdown button
                                                borderRadius: BorderRadius.circular(
                                                    20), //border raiuds of dropdown button
                                              ),
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 30, right: 10),
                                                  child: DropdownButton(
                                                    value: dropdownValue,
                                                    items: const [
                                                      //add items in the dropdown
                                                      DropdownMenuItem(
                                                        value: "Male",
                                                        child: Text("Male"),
                                                      ),
                                                      DropdownMenuItem(
                                                          value: "Female",
                                                          child:
                                                              Text("Female")),
                                                      DropdownMenuItem(
                                                        value: "Other",
                                                        child: Text("Other"),
                                                      )
                                                    ],
                                                    onChanged: (String? value) {
                                                      //get value when changed
                                                      dropdownValue = value!;
                                                      setState(() {});
                                                    },
                                                    icon: const Padding(
                                                        //Icon at tail, arrow bottom is default icon
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 20),
                                                        child: Icon(Icons
                                                            .arrow_drop_down)),
                                                    iconEnabledColor: Colors
                                                        .white, //Icon color
                                                    style: const TextStyle(
                                                        //te
                                                        color: Colors
                                                            .white, //Font color
                                                        fontSize:
                                                            12 //font size on dropdown button
                                                        ),

                                                    dropdownColor: const Color
                                                            .fromRGBO(
                                                        35,
                                                        35,
                                                        35,
                                                        1), //dropdown background color
                                                    underline:
                                                        Container(), //remove underline
                                                    isExpanded: true,
                                                    isDense: true,
                                                  )))),
                                      Row(
                                        children: [
                                          Transform.scale(
                                              scale: 0.7,
                                              child: Checkbox(
                                                fillColor: MaterialStateProperty
                                                    .all<Color>(Colors.white),
                                                checkColor: Colors.greenAccent,
                                                activeColor:
                                                    const Color.fromRGBO(
                                                        0, 123, 255, 1),
                                                value: check1,
                                                shape: const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .all(Radius.circular(
                                                            5.0))), // Rounded Checkbox
                                                onChanged: (value) {
                                                  setState(() {
                                                    check1 =
                                                        check1 ? false : true;
                                                  });
                                                },
                                              )),
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 1)),
                                          const Text(
                                            'I expressly agree to receive the newsletter',
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Color.fromRGBO(
                                                    150, 150, 150, 1)),
                                          ),
                                        ],
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(top: 0)),
                                      Row(
                                        children: [
                                          Transform.scale(
                                              scale: 0.7,
                                              child: Checkbox(
                                                fillColor: MaterialStateProperty
                                                    .all<Color>(Colors.white),
                                                checkColor: Colors.greenAccent,
                                                activeColor:
                                                    const Color.fromRGBO(
                                                        0, 123, 255, 1),
                                                value: check2,
                                                shape: const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .all(Radius.circular(
                                                            5.0))), // Rounded Checkbox
                                                onChanged: (value) {
                                                  setState(() {
                                                    check2 =
                                                        check2 ? false : true;
                                                  });
                                                },
                                              )),
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 1)),
                                          Flexible(
                                            child: RichText(
                                              text: TextSpan(
                                                  text:
                                                      'By creating your account, you agree to our',
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 10),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text: ' Terms',
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10),
                                                        recognizer:
                                                            TapGestureRecognizer()
                                                              ..onTap = () {
                                                                Navigator.pushReplacementNamed(
                                                                    context,
                                                                    RouteNames
                                                                        .terms);
                                                              }),
                                                    const TextSpan(
                                                      text: ' &',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 11),
                                                    ),
                                                    TextSpan(
                                                        text: ' Privacy Policy',
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10),
                                                        recognizer:
                                                            TapGestureRecognizer()
                                                              ..onTap = () {
                                                                Navigator.pushReplacementNamed(
                                                                    context,
                                                                    RouteNames
                                                                        .privacy);
                                                              })
                                                  ]),
                                            ),
                                          )
                                        ],
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(top: 5)),
                                      Container(
                                        width: double.infinity - 50,
                                        padding: const EdgeInsets.only(top: 10),
                                        child: MyPrimaryButton(
                                          color: Colors.white,
                                          buttonName: "Sign up",
                                          onPressed: () => {
                                            Navigator.pushReplacementNamed(
                                                context, RouteNames.homePage)
                                          },
                                        ),
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(top: 20)),
                                      RichText(
                                        text: TextSpan(
                                            text: 'Have an account?',
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: 'Login Now',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          Navigator
                                                              .pushReplacementNamed(
                                                                  context,
                                                                  RouteNames
                                                                      .homePage);
                                                        })
                                            ]),
                                      ),
                                    ],
                                  ),
                                ),
                              ]))),
                    ),
                    footbar(context)
                  ],
                ))));
  }
}

Widget input(String label, Icon icon) {
  return Container(
    height: 38,
    padding: const EdgeInsets.only(top: 10),
    child: PrimaryInput(
      onChange: () {},
      icon: icon,
      label: label,
    ),
  );
}
