import 'package:flutter/material.dart';

import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';

// ignore: must_be_immutable
class SettingHeader extends StatelessWidget {
  SettingHeader(
      {super.key,
      required this.icon,
      required this.pagename,
      this.button,
      required this.routerChange});
  Icon icon;
  String pagename;
  Function routerChange;
  var button;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 20),
      child: Container(
        height: 65,
        decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
            color: Color.fromARGB(255, 220, 226, 237),
            width: 1,
          )),
          color: Color.fromARGB(255, 240, 243, 246),
          // borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        padding: const EdgeInsets.only(top: 5, left: 15),
        child: Row(
          children: [
            icon,
            const Padding(padding: EdgeInsets.only(left: 10)),
            Text(pagename),
            const Flexible(fit: FlexFit.tight, child: SizedBox()),
            button['flag']
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(3),
                      backgroundColor: button['buttoncolor'],
                      // elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0)),
                      minimumSize: const Size(120, 50),
                      maximumSize: const Size(120, 50),
                    ),
                    onPressed: () {
                      ProfileController()
                          .updateProfile(UserManager.userInfo['userName']);
                      routerChange({
                        'router': RouteNames.profile,
                        'subRouter': UserManager.userInfo['userName'],
                      });
                      print('object');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        button['icon'],
                        Text(button['text'],
                            style: const TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.bold))
                      ],
                    ))
                : const SizedBox(),
            const Padding(padding: EdgeInsets.only(right: 30))
          ],
        ),
      ),
    );
  }
}
