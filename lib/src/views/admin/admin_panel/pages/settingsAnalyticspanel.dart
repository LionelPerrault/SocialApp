
import 'package:flutter/material.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_footer.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_header.dart';

// ignore: must_be_immutable
class AdminSettingsAnalytics extends StatelessWidget {
  AdminSettingsAnalytics(
      {super.key});
  var headerTab = [
    {'icon':Icons.track_changes,'title':'General','onClick':(value) {print(value);}},
    {'icon':Icons.time_to_leave,'title':'SEO','onClick':(value) {print(value);}},
    {'icon':Icons.mode,'title':'Modules','onClick':(value) {print(value);}}
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 30,right: 20),
      child: Column(children: [
        AdminSettingHeader(icon: Icon(Icons.settings), pagename: 'Settings › Analytics', button: const {'flag': false}),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const Text('Tracking Code', style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 85, 95, 127)
            ),),
            Expanded(
              flex: 2,
              child: Container(
                width: 500,
                child: Column(children: [
                Container(
                  width: 400,
                  height: 200,
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
                const Text('The analytics tracking code (Ex: Google Analytics)', style: TextStyle(
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
