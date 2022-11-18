
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_footer.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_header.dart';

// ignore: must_be_immutable
class AdminBodyPanel extends StatelessWidget {
  const AdminBodyPanel(
      {super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        AdminSettingHeader(icon: Icon(Icons.settings), pagename: 'Settings › Limits', button: const {'flag': false},),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          margin: EdgeInsets.only(left: 50),
          width: SizeConfig(context).screenWidth * 0.6,
          child: Column(children: [
            Row(children: [
              Expanded(
                child: Container(
                  child: Row(children: [
                    Container(
                      width: 35,
                      height: 35,
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Funusual_login.svg?alt=media&token=68f1271b-3325-4cd0-94ac-96b18a810132'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Unusual Login Detection', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Enable unusual login detection, System will not allow user to login with same session from different device or location', style: TextStyle(
                          fontSize: 11
                        ),),
                      )
                    ],),
                    const Flexible(fit: FlexFit.tight, child: SizedBox()),
                    SizedBox(
                      height: 20,
                      child: Transform.scale(
                        scaleX: 0.55,
                        scaleY: 0.55,
                        child: CupertinoSwitch(
                          //thumbColor: kprimaryColor,
                          // activeColor: kprimaryColor,
                          value: true,
                          onChanged: (value) {
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
          margin: EdgeInsets.only(left: 50),
          width: SizeConfig(context).screenWidth * 0.6,
          child: Column(children: [
            Row(children: [
              Expanded(
                child: Container(
                  child: Row(children: [
                    Container(
                      width: 35,
                      height: 35,
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fbrute_force.svg?alt=media&token=1e15dce7-f2d7-42de-bc7a-966e0a979baf'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Brute Force Detection', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Enable brute force attack detection, System will block the user account if hacker try to login with invalid password too many times to guess the correct account password', style: TextStyle(
                          fontSize: 11
                        ),),
                      )
                      
                    ],),
                    const Flexible(fit: FlexFit.tight, child: SizedBox()),
                    SizedBox(
                      height: 20,
                      child: Transform.scale(
                        scaleX: 0.55,
                        scaleY: 0.55,
                        child: CupertinoSwitch(
                          //thumbColor: kprimaryColor,
                          // activeColor: kprimaryColor,
                          value: true,
                          onChanged: (value) {
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
          margin: EdgeInsets.only(left: 30),
          width: SizeConfig(context).screenWidth*0.5,
          child: Row(
            children: [
            const Padding(padding: EdgeInsets.only(left: 20)),
            Container(
              width: 100,
              child:   const Text('Bad Login Limit', style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 85, 95, 127)
              ),),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: 500,
                child: Column(children: [
                Container(
                  width: 400,
                  height: 30,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(
                          255, 250, 250, 250),
                      border:
                          Border.all(color: Colors.grey)),
                  child: TextFormField(
                        minLines: 1,
                        maxLines: 7,
                        onChanged: (value) async {
                        },
                        keyboardType: TextInputType.multiline,
                        style: const TextStyle(fontSize: 12),
                        decoration: const InputDecoration(
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
                const Text('Number of bad login attempts till account get blocked', style: TextStyle(
                  fontSize: 12,
                ),)
              ]),)
                
            )
          ],),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          margin: EdgeInsets.only(left: 30),
          width: SizeConfig(context).screenWidth*0.5,
          child: Row(
            children: [
            const Padding(padding: EdgeInsets.only(left: 20)),
            Container(
              width: 100,
              child:   const Text('Lockout Time', style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 85, 95, 127)
              ),),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: 500,
                child: Column(children: [
                Container(
                  width: 400,
                  height: 30,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(
                          255, 250, 250, 250),
                      border:
                          Border.all(color: Colors.grey)),
                  child: TextFormField(
                        minLines: 1,
                        maxLines: 7,
                        onChanged: (value) async {
                        },
                        keyboardType: TextInputType.multiline,
                        style: const TextStyle(fontSize: 12),
                        decoration: const InputDecoration(
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
                const Text('Number of minutes the account will still locked out', style: TextStyle(
                  fontSize: 12,
                ),)
              ]),)
                
            )
          ],),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          margin: EdgeInsets.only(left: 50),
          width: SizeConfig(context).screenWidth * 0.6,
          child: Column(children: [
            Row(children: [
              Expanded(
                child: Container(
                  child: Row(children: [
                    Container(
                      width: 35,
                      height: 35,
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Ftwo_factor.svg?alt=media&token=b33b8efa-8098-4844-a978-3e9fc5f8db27'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Two-Factor Authentication', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Enable two-factor authentication to log in with a code from your email/phone as well as a password', style: TextStyle(
                          fontSize: 11
                        ),),
                      )
                      
                    ],),
                    const Flexible(fit: FlexFit.tight, child: SizedBox()),
                    SizedBox(
                      height: 20,
                      child: Transform.scale(
                        scaleX: 0.55,
                        scaleY: 0.55,
                        child: CupertinoSwitch(
                          //thumbColor: kprimaryColor,
                          // activeColor: kprimaryColor,
                          value: true,
                          onChanged: (value) {
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
          margin: EdgeInsets.only(left: 30),
          width: SizeConfig(context).screenWidth*0.5,
          child: Row(
            children: [
            const Padding(padding: EdgeInsets.only(left: 20)),
            Container(
              width: 100,
              child:   const Text('Two-Factor Authentication Via', style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 85, 95, 127)
              ),),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: 500,
                child: Column(children: [
                Container(
                  width: 400,
                  height: 30,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(
                          255, 250, 250, 250),),
                  child: Row(children: [
                    Row(
                      children: [
                        Transform.scale(
                            scale: 0.7,
                            child: Checkbox(
                              fillColor:
                                  MaterialStateProperty.all<Color>(
                                      Colors.black),
                              checkColor: Colors.blue,
                              activeColor: const Color.fromRGBO(
                                  0, 123, 255, 1),
                              value: false,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          5.0))), // Rounded Checkbox
                              onChanged: (value) {
                                
                              },
                            )),
                        const Padding(
                            padding: EdgeInsets.only(left: 1)),
                        const Text(
                          'Email',
                          style: TextStyle(
                              fontSize: 10,
                              color:
                                  Colors.black),
                        ),
                      ],
                    ),

                      Row(
                        children: [
                          Transform.scale(
                              scale: 0.7,
                              child: Checkbox(
                                fillColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                                checkColor: Colors.blue,
                                activeColor: const Color.fromRGBO(
                                    0, 123, 255, 1),
                                value: false,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            5.0))), // Rounded Checkbox
                                onChanged: (value) {
                                  
                                },
                              )),
                          const Padding(
                              padding: EdgeInsets.only(left: 1)),
                          const Text(
                            'SMS',
                            style: TextStyle(
                                fontSize: 10,
                                color:
                                    Colors.black),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Transform.scale(
                              scale: 0.7,
                              child: Checkbox(
                                fillColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                                checkColor: Colors.blue,
                                activeColor: const Color.fromRGBO(
                                    0, 123, 255, 1),
                                value: true,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            5.0))), // Rounded Checkbox
                                onChanged: (value) {
                                  
                                },
                              )),
                          const Padding(
                              padding: EdgeInsets.only(left: 1)),
                          const Text(
                            'Google Authenticator',
                            style: TextStyle(
                                fontSize: 10,
                                color:
                                    Colors.black),
                          ),
                        ],
                      ),
                  ],)
                ),
                const Text('Select Email, SMS or Google Authenticator to send log in code to user Make sure you have configured SMS Settings', style: TextStyle(
                  fontSize: 12,
                ),)
              ]),)
                
            )
          ],),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          margin: EdgeInsets.only(left: 50),
          width: SizeConfig(context).screenWidth * 0.6,
          child: Column(children: [
            Row(children: [
              Expanded(
                child: Container(
                  child: Row(children: [
                    Container(
                      width: 35,
                      height: 35,
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fconsored_word.svg?alt=media&token=3df34012-041e-4ec7-8d31-326567f3ddfb'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Censored Words Enabled', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Enable/Disable Words to be censored', style: TextStyle(
                          fontSize: 11
                        ),),
                      )
                      
                    ],),
                    const Flexible(fit: FlexFit.tight, child: SizedBox()),
                    SizedBox(
                      height: 20,
                      child: Transform.scale(
                        scaleX: 0.55,
                        scaleY: 0.55,
                        child: CupertinoSwitch(
                          //thumbColor: kprimaryColor,
                          // activeColor: kprimaryColor,
                          value: true,
                          onChanged: (value) {
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
          margin: EdgeInsets.only(left: 30),
          width: SizeConfig(context).screenWidth*0.5,
          child: Row(
            children: [
            const Padding(padding: EdgeInsets.only(left: 20)),
            Container(
              width: 100,
              child:   const Text('Censored Words', style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 85, 95, 127)
              ),),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: 500,
                child: Column(children: [
                Container(
                  width: 400,
                  height: 100,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(
                          255, 250, 250, 250),
                      border:
                          Border.all(color: Colors.grey)),
                  child: TextFormField(
                        minLines: 1,
                        maxLines: 7,
                        onChanged: (value) async {
                        },
                        keyboardType: TextInputType.multiline,
                        style: const TextStyle(fontSize: 12),
                        decoration: const InputDecoration(
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
                const Text('Words to be censored, separated by a comma (,)', style: TextStyle(
                  fontSize: 12,
                ),)
              ]),)
                
            )
          ],),
        ),
        
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          margin: EdgeInsets.only(left: 50),
          width: SizeConfig(context).screenWidth * 0.6,
          child: Column(children: [
            Row(children: [
              Expanded(
                child: Container(
                  child: Row(children: [
                    Container(
                      width: 35,
                      height: 35,
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2FreCAPTCHA.svg?alt=media&token=79ac625a-83b8-43c4-a07f-2d25efb6f1c0'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('reCAPTCHA Enabled', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Turn reCAPTCHA On and Off', style: TextStyle(
                          fontSize: 11
                        ),),
                      )
                      
                    ],),
                    const Flexible(fit: FlexFit.tight, child: SizedBox()),
                    SizedBox(
                      height: 20,
                      child: Transform.scale(
                        scaleX: 0.55,
                        scaleY: 0.55,
                        child: CupertinoSwitch(
                          //thumbColor: kprimaryColor,
                          // activeColor: kprimaryColor,
                          value: true,
                          onChanged: (value) {
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
          margin: EdgeInsets.only(left: 30),
          width: SizeConfig(context).screenWidth*0.5,
          child: Row(
            children: [
            const Padding(padding: EdgeInsets.only(left: 20)),
            Container(
              width: 100,
              child:   const Text('reCAPTCHA Site Key', style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 85, 95, 127)
              ),),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: 500,
                child: Column(children: [
                Container(
                  width: 400,
                  height: 30,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(
                          255, 250, 250, 250),
                      border:
                          Border.all(color: Colors.grey)),
                  child: TextFormField(
                        minLines: 1,
                        maxLines: 7,
                        onChanged: (value) async {
                        },
                        keyboardType: TextInputType.multiline,
                        style: const TextStyle(fontSize: 12),
                        decoration: const InputDecoration(
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
              ]),)
                
            )
          ],),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          margin: EdgeInsets.only(left: 30),
          width: SizeConfig(context).screenWidth*0.5,
          child: Row(
            children: [
            const Padding(padding: EdgeInsets.only(left: 20)),
            Container(
              width: 100,
              child:   const Text('reCAPTCHA Secret Key', style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 85, 95, 127)
              ),),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: 500,
                child: Column(children: [
                Container(
                  width: 400,
                  height: 30,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(
                          255, 250, 250, 250),
                      border:
                          Border.all(color: Colors.grey)),
                  child: TextFormField(
                        minLines: 1,
                        maxLines: 7,
                        onChanged: (value) async {
                        },
                        keyboardType: TextInputType.multiline,
                        style: const TextStyle(fontSize: 12),
                        decoration: const InputDecoration(
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
              ]),)
                
            )
          ],),
        ),
        AdminSettingFooter()
      ]),
    );
  }
}
