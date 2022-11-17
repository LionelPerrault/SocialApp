
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
              child:   const Text('Data Heartbeat', style: TextStyle(
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
                const Text('The update interval to check for new data (in seconds)', style: TextStyle(
                  fontSize: 12,
                ),)
              ]),)
                
            )
          ],),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        AdminSettingFooter()
      ]),
    );
  }
}
