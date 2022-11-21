
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

class SettingVerificationScreen extends StatefulWidget {
  SettingVerificationScreen({Key? key}) : super(key: key);
  @override
  State createState() => SettingVerificationScreenState();
}
// ignore: must_be_immutable
class SettingVerificationScreenState extends State<SettingVerificationScreen> {
  var setting_security = {};
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.only(top: 20, left:30),
      child: 
        Column(children: [
          SettingHeader(icon: const Icon(Icons.check_circle, color: Color.fromARGB(255, 33, 150, 243),), pagename: 'Verification',
            button: {'flag': false},),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Container(
            width: SizeConfig(context).screenWidth > SizeConfig.smallScreenSize ? SizeConfig(context).screenWidth * 0.5 : SizeConfig(context).screenWidth * 0.9 - 30,
            child: Column(children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 10),
                    width: 100,
                    child: Text('Chat Message Sound', style: TextStyle(
                      color: Color.fromARGB(255, 82, 95, 127),
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                    ),),
                  ),
                  Expanded(
                    child: Container(
                      width: 230,
                      child: Column(children: [
                      Container(
                        width: 230,
                        color: Color.fromARGB(255, 235, 235, 235),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          Icon(Icons.camera_alt),
                          Padding(padding: EdgeInsets.only(left: 20)),
                          Expanded(child: Container(
                            width: 100,
                            child: Text('Your Photo',overflow: TextOverflow.clip, style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),),
                          ))
                          
                          
                        ]),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      Stack(
                        children: [
                          Container(
                            width: 230,
                            height: 200,
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                color:
                                    Colors.grey,
                                border: Border.all(color: Colors.grey)),
                          ),
                          Container(
                            width: 26,
                            height: 26,
                            margin: const EdgeInsets.only(
                                top: 150, left: 180),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13),
                              color: Colors.grey[400],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(4),
                                backgroundColor: Colors.grey[300],
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(13)),
                                minimumSize: const Size(26, 26),
                                maximumSize: const Size(26, 26),
                              ),
                              onPressed: () {
                                ()=>{};
                              },
                              child: const Icon(
                                  Icons.camera_enhance_rounded,
                                  color: Colors.black,
                                  size: 16.0),
                            ),
                          ),
                        ],
                      ),
                    ],),
                    )
                  ),
                  const Padding(padding: EdgeInsets.only(left: 30)),
                  Expanded(
                    child: Container(
                      width: 230,
                      child: Column(children: [
                        Container(
                          width: 230,
                          height: 30,
                          color: Color.fromARGB(255, 235, 235, 235),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                            Icon(Icons.card_membership),
                            Padding(padding: EdgeInsets.only(left: 20)),
                            Expanded(child: 
                            Text('Passport or National ID', style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),)
                            )
                            
                          ]),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 20)),
                        Stack(
                          children: [
                            Container(
                              width: 230,
                              height: 200,
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  color:
                                      Colors.grey,
                                  border: Border.all(color: Colors.grey)),
                            ),
                            Container(
                              width: 26,
                              height: 26,
                              margin: const EdgeInsets.only(
                                  top: 150, left: 180),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.grey[400],
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(4),
                                  backgroundColor: Colors.grey[300],
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(13)),
                                  minimumSize: const Size(26, 26),
                                  maximumSize: const Size(26, 26),
                                ),
                                onPressed: () {
                                  ()=>{};
                                },
                                child: const Icon(
                                    Icons.camera_enhance_rounded,
                                    color: Colors.black,
                                    size: 16.0),
                              ),
                            ),
                          ],
                        ),
                      ],),
                    )
                  )
              ],),
                const Padding(padding: EdgeInsets.only(top: 20)),

              Row(children: [
                Text('Chat Message Sound', style: TextStyle(
                  color: Color.fromARGB(255, 82, 95, 127),
                  fontSize: 12,
                  fontWeight: FontWeight.bold
                ),),
                const Padding(padding: EdgeInsets.only(left: 60)),
                  Expanded(child: 
                    Container(
                      width: 500,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(
                              255, 250, 250, 250),
                          border:
                              Border.all(color: Colors.grey)),
                      child: TextFormField(
                            minLines: 1,
                            maxLines: 4,
                            onChanged: (value) async {
                              // setState(() {});
                            },
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
                            ),
                          ),
                    ),
                  )
                ],)
              ],),
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
