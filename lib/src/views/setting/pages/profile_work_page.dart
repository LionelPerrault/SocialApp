import 'package:flutter/material.dart';

import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/setting/widget/setting_header.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

class SettingWorkScreen extends StatefulWidget {
  SettingWorkScreen({Key? key, required this.routerChange})
      : con = UserController(),
        super(key: key);
  late UserController con;
  Function routerChange;
  @override
  State createState() => SettingWorkScreenState();
}

// ignore: must_be_immutable
class SettingWorkScreenState extends mvc.StateMVC<SettingWorkScreen> {
  var workInfo = {};
  var userInfo = UserManager.userInfo;
  late UserController con;
  @override
  void initState() {
    add(widget.con);
    con = controller as UserController;
    workInfo['workTitle'] = userInfo['workTitle'];
    workInfo['workPlace'] = userInfo['workPlace'];
    workInfo['workWebsite'] = userInfo['workWebsite'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Container(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            SettingHeader(
              routerChange: widget.routerChange,
              icon: const Icon(
                Icons.work,
                color: Color.fromARGB(255, 43, 83, 164),
              ),
              pagename: 'Work',
              button: const {
                'buttoncolor': Color.fromARGB(255, 17, 205, 239),
                'icon': Icon(Icons.person),
                'text': 'View Profile',
                'flag': true
              },
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: titleAndsubtitleInput(
                          'Work Title',
                          50,
                          1,
                          (value) {
                            workInfo['workTitle'] = value;
                          },
                          workInfo['workTitle'] ?? '',
                        ),
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: titleAndsubtitleInput(
                          'Work Place',
                          50,
                          1,
                          (value) {
                            workInfo['workPlace'] = value;
                          },
                          workInfo['workPlace'] ?? '',
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(left: 25)),
                      Expanded(
                        flex: 1,
                        child: titleAndsubtitleInput(
                          'Work Website',
                          50,
                          1,
                          (value) async {
                            workInfo['workWebsite'] = value;
                          },
                          workInfo['workWebsite'] ?? '',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            footer()
          ],
        ),
      ),
    );
  }

  Widget titleAndsubtitleInput(title, double height, line, onChange, text) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 85, 95, 127)),
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  width: 400,
                  height: height,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: text,
                        maxLines: line,
                        minLines: line,
                        onChanged: (value) {
                          onChange(value);
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(top: 10, left: 10),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget footer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.only(top: 20),
      child: Container(
          height: 65,
          decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(
              color: Color.fromARGB(255, 220, 226, 237),
              width: 1,
            )),
            color: Color.fromARGB(255, 240, 243, 246),
            // borderRadius: BorderRadius.all(Radius.circular(3)),
          ),
          padding: const EdgeInsets.only(top: 5, left: 15),
          child: Row(
            children: [
              const Flexible(fit: FlexFit.tight, child: SizedBox()),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(3),
                    backgroundColor: Colors.white,
                    // elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0)),
                    minimumSize: con.isProfileChange
                        ? const Size(90, 50)
                        : const Size(120, 50),
                    maximumSize: con.isProfileChange
                        ? const Size(90, 50)
                        : const Size(120, 50),
                  ),
                  onPressed: () {
                    con.profileChange(workInfo);
                  },
                  child: con.isProfileChange
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10,
                              height: 10,
                              child: CircularProgressIndicator(
                                  color: Colors.black),
                            ),
                            Padding(padding: EdgeInsets.only(left: 7)),
                            Text('Loading',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold))
                          ],
                        )
                      : const Text('Save Changes',
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
              const Padding(padding: EdgeInsets.only(right: 30))
            ],
          )),
    );
  }
}
