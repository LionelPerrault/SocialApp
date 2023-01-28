import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/utils/svg.dart';
import 'package:shnatter/src/views/box/daytimeM.dart';
import 'package:shnatter/src/views/box/mindpost.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/views/setting/widget/setting_footer.dart';
import 'package:shnatter/src/views/setting/widget/setting_header.dart';
import 'package:shnatter/src/widget/mindslice.dart';
import 'package:shnatter/src/widget/startedInput.dart';

class SettingInterestsScreen extends StatefulWidget {
  late PostController Postcon;
  SettingInterestsScreen({Key? key})
      : Postcon = PostController(),
        super(key: key);
  @override
  State createState() => SettingInterestsScreenState();
}

// ignore: must_be_immutable
class SettingInterestsScreenState extends mvc.StateMVC<SettingInterestsScreen> {
  var setting_profile = {};
  late PostController Postcon;
  var interestsCheck = [];
  List subCategory = [];

  @override
  void initState() {
    add(widget.Postcon);
    Postcon = controller as PostController;
    Postcon.getAllInterests().then((allInterests) => {
          for (int i = 0; i < allInterests.length; i++)
            {
              subCategory.add(allInterests[i]),
              interestsCheck
                  .add({'title': allInterests[i]['title'], 'interested': false})
            },
          setState(() {})
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 20, left: 30),
        child: Column(
          children: [
            SettingHeader(
              icon: Icon(
                Icons.school,
                color: Color.fromARGB(255, 43, 83, 164),
              ),
              pagename: 'Education',
              button: {
                'buttoncolor': Color.fromARGB(255, 17, 205, 239),
                'icon': Icon(Icons.person),
                'text': 'View Profile',
                'flag': true
              },
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Container(
              width:
                  SizeConfig(context).screenWidth > SizeConfig.smallScreenSize
                      ? SizeConfig(context).screenWidth * 0.5 + 40
                      : SizeConfig(context).screenWidth * 0.9 - 30,
              child: Container(
                child: SingleChildScrollView(
                  child: Column(children: [
                    Column(children: [
                      const Divider(
                        thickness: 0.1,
                        color: Colors.black,
                      ),
                      Row(
                        children: const [
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Text(
                            'Title',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Flexible(fit: FlexFit.tight, child: SizedBox()),
                          Text(
                            'Check',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Padding(padding: EdgeInsets.only(left: 30))
                        ],
                      ),
                      const Divider(
                        thickness: 0.1,
                        color: Colors.black,
                      )
                    ]),
                    Container(
                      height: 300,
                      child: ListView.builder(
                          itemCount: subCategory.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(children: [
                              Row(
                                children: [
                                  const Padding(
                                      padding: EdgeInsets.only(left: 10)),
                                  Text(
                                    subCategory[index]['title'],
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.black),
                                  ),
                                  const Flexible(
                                      fit: FlexFit.tight, child: SizedBox()),
                                  Transform.scale(
                                      scale: 0.7,
                                      child: Checkbox(
                                        fillColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.black),
                                        checkColor: Colors.blue,
                                        activeColor: const Color.fromRGBO(
                                            0, 123, 255, 1),
                                        value: interestsCheck[index]
                                            ['interested'],
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    5.0))), // Rounded Checkbox
                                        onChanged: (value) {
                                          setState(() {
                                            interestsCheck[index]
                                                    ['interested'] =
                                                !interestsCheck[index]
                                                    ['interested'];
                                          });
                                        },
                                      )),
                                  const Padding(
                                      padding: EdgeInsets.only(left: 30))
                                ],
                              ),
                              Divider(
                                thickness: 0.1,
                                color: Colors.black,
                              )
                            ]);
                          }),
                    )
                  ]),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            SettingFooter(
              onClick: () {},
            )
          ],
        ));
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
