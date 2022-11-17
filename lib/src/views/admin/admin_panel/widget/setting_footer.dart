import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/utils/size_config.dart';

// ignore: must_be_immutable
class AdminSettingFooter extends StatelessWidget {
  AdminSettingFooter({super.key});
  // Icon icon;
  // String pagename;
  @override
  Widget build(BuildContext context) {
    return Padding(
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
              minimumSize: const Size(120, 50),
              maximumSize: const Size(120, 50),
            ),
            onPressed: () {
              (()=>{});
            },
            child: Text('Save Changes', style: TextStyle(fontSize: 11, color: Colors.black, fontWeight: FontWeight.bold))),
            const Padding(padding: EdgeInsets.only(right: 30))
        ],)
        ),
    );
  }
}
