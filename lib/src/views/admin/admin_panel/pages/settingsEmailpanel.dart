
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/controllers/AdminController.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_footer.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_header.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

// ignore: must_be_immutable

class AdminSettingsEmail extends StatefulWidget {
  AdminSettingsEmail({Key? key})
  : con = AdminController(),
        super(key: key);
  final AdminController con;
  @override
  State createState() => AdminSettingsEmailState();
}
class AdminSettingsEmailState extends mvc.StateMVC<AdminSettingsEmail> {

  String tab = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20,right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        AdminSettingHeader(icon: Icon(Icons.settings), pagename: 'Settings › Email', button: const {'flag': false},),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          child: Column(children: [
            Row(children: [
              Expanded(
                child: Container(
                  child: Row(children: [
                    Container(
                      width: 35,
                      height: 35,
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2FSMTP.svg?alt=media&token=1429acde-2708-433e-9e3a-dd7b61f1d03a'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('SMTP', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Enable/Disable SMTP email system PHP mail() function will be used in case of disabled', style: TextStyle(
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
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          child: Column(children: [
            Row(children: [
              Expanded(
                child: Container(
                  child: Row(children: [
                    Container(
                      width: 35,
                      height: 35,
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2FSMTP_require.svg?alt=media&token=c55fe407-4a40-42bb-bdfb-8c6d808f9f44'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('SMTP Require Authentication', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Enable/Disable SMTP authentication', style: TextStyle(
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
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          child: Column(children: [
            Row(children: [
              Expanded(
                child: Container(
                  child: Row(children: [
                    Container(
                      width: 35,
                      height: 35,
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2FSMTP_ssl.svg?alt=media&token=e8a406e8-8278-46ca-8fdb-7c5a8157b137'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('SMTP SSL Encryption', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Enable/Disable SMTP SSL encryption TLS encryption will be used in case of disabled', style: TextStyle(
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
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          child: Column(children: [
            Row(children: [
              Expanded(
                child: Container(
                  child: Row(children: [
                    Container(
                      width: 35,
                      height: 35,
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fmemories.svg?alt=media&token=253f45d8-177f-4eba-9ca6-bb2c28cbb7ff'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Memories', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Turn the memories On and Off Memories are posts from the same day on last year', style: TextStyle(
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
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Container(
              width: 100,
              child:   const Text('SMTP Server', style: TextStyle(
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Container(
              width: 100,
              child:   const Text('SMTP Port', style: TextStyle(
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Container(
              width: 100,
              child:   const Text('SMTP Username', style: TextStyle(
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Container(
              width: 100,
              child:   const Text('SMTP Password', style: TextStyle(
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Container(
              width: 100,
              child:   const Text('Set From', style: TextStyle(
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
                const Text('Set the From email address, For example: email@domain.com', style: TextStyle(
                  fontSize: 12,
                ),)
              ]),)
                
            )
          ],),
        ),
        AdminSettingFooter()
      ]),
    );
  }
}
