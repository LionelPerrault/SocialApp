import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/widget/interests.dart';
import 'package:shnatter/src/widget/startedInput.dart';

import '../../../../widget/admin_list_text.dart';

class EventSettingsScreen extends StatefulWidget {
  Function onClick;
  EventSettingsScreen({Key? key, required this.onClick})
      : con = PostController(),
        super(key: key);
  final PostController con;
  @override
  State createState() => EventSettingsScreenState();
}

class EventSettingsScreenState extends mvc.StateMVC<EventSettingsScreen> {
  var userInfo = UserManager.userInfo;
  var eventSettingTab = 'Event Settings';
  List<Map> list = [
    {
      'text': 'Event Settings',
      'icon': Icons.settings,
    },
    {
      'text': 'Event Interests',
      'icon': Icons.heart_broken,
    },
    {
      'text': 'Delete Event',
      'icon': Icons.delete,
    },
  ];
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as PostController;
  }

  late PostController con;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig(context).screenWidth - SizeConfig.leftBarAdminWidth,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LeftSettingBar(),
          eventSettingTab == 'Event Settings'
              ? EventSettingsWidget()
              : eventSettingTab == 'Event Interests'
                  ? EventInterestsWidget()
                  : EventDeleteWidget(),
        ],
      ),
    );
  }

  Widget LeftSettingBar() {
    return Container(
      padding: const EdgeInsets.only(top: 30, right: 20),
      // width: SizeConfig.leftBarAdminWidth,
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: list
              .map(
                (e) => ListText(
                  onTap: () => {onClick(e['text'])},
                  label: SizeConfig(context).screenWidth >
                          SizeConfig.mediumScreenSize
                      ? e['text']
                      : '',
                  icon: Icon(
                    e['icon'],
                    color: eventSettingTab == e['text']
                        ? Color.fromARGB(255, 94, 114, 228)
                        : Colors.grey,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget EventSettingsWidget() {
    return Container(
      width: 450,
      child: Column(
        children: [
          headerWidget(Icon(Icons.settings), 'Settings'),
          Container(
            width: 430,
            child: Column(children: [
              const Padding(padding: EdgeInsets.only(top: 15)),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text(
                        'Name Your Event',
                        style: TextStyle(
                            color: Color.fromARGB(255, 82, 95, 127),
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    width: 400,
                    child: inputWidget('value', (value) {
                      con.event['eventName'] = value;
                      setState(() {});
                    }),
                  )
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 15)),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text('Location',
                          style: TextStyle(
                              color: Color.fromARGB(255, 82, 95, 127),
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Container(
                    width: 400,
                    child: inputWidget('value', (value) {
                      con.event['eventName'] = value;
                      setState(() {});
                    }),
                  )
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 15)),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text('Start Date',
                          style: TextStyle(
                              color: Color.fromARGB(255, 82, 95, 127),
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Container(
                    width: 400,
                    child: inputWidget('value', (value) {
                      con.event['eventName'] = value;
                      setState(() {});
                    }),
                  )
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 15)),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text('End Date',
                          style: TextStyle(
                              color: Color.fromARGB(255, 82, 95, 127),
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Container(
                    width: 400,
                    child: inputWidget('value', (value) {
                      con.event['eventName'] = value;
                      setState(() {});
                    }),
                  )
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 15)),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text('Select Privacy',
                          style: TextStyle(
                              color: Color.fromARGB(255, 82, 95, 127),
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: 380,
                      height: 40,
                      padding: EdgeInsets.only(right: 30),
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 17, 205, 239),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                                color: const Color.fromARGB(255, 17, 205, 239),
                                width:
                                    0.1), //bordrder raiuds of dropdown button
                          ),
                          child: Padding(
                              padding: const EdgeInsets.only(top: 7, left: 15),
                              child: DropdownButton(
                                value: con.event['eventPrivacy'],
                                items: [
                                  DropdownMenuItem(
                                    value: "public",
                                    child: Row(children: const [
                                      Icon(
                                        Icons.language,
                                        color: Colors.black,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 5)),
                                      Text(
                                        "Public",
                                        style: TextStyle(fontSize: 13),
                                      )
                                    ]),
                                  ),
                                  DropdownMenuItem(
                                    value: "closed",
                                    child: Row(children: const [
                                      Icon(
                                        Icons.groups,
                                        color: Colors.black,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 5)),
                                      Text(
                                        "Closed",
                                        style: TextStyle(fontSize: 13),
                                      )
                                    ]),
                                  ),
                                  DropdownMenuItem(
                                    value: "security",
                                    child: Row(children: const [
                                      Icon(
                                        Icons.lock_outline,
                                        color: Colors.black,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 5)),
                                      Text(
                                        "Security",
                                        style: TextStyle(fontSize: 13),
                                      )
                                    ]),
                                  ),
                                ],
                                onChanged: (value) {
                                  con.event['eventPrivacy'] = value;
                                  setState(() {});
                                },
                                icon: const Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Icon(Icons.arrow_drop_down)),
                                iconEnabledColor: Colors.white, //Icon color
                                style: const TextStyle(
                                  color: Colors.black, //Font color
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                                dropdownColor: Colors.white,
                                underline: Container(), //remove underline
                                isExpanded: true,
                                isDense: true,
                              ))),
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 15)),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('About',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 82, 95, 127),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                width: 400,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 250, 250, 250),
                                    border: Border.all(color: Colors.grey)),
                                child: TextFormField(
                                  minLines: 1,
                                  maxLines: 4,
                                  onChanged: (value) async {
                                    con.event['eventAbout'] = value;
                                    setState(() {});
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
                            ],
                          )),
                    ],
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 15)),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: privacySelect(
                            'Members Can Publish Posts?',
                            'Members can publish posts or only group admins',
                          )),
                    ],
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 15)),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: privacySelect(
                            'Post Approval',
                            'All posts must be approved by a group admin(Note: Disable it will approve any pending posts)',
                          )),
                    ],
                  ),
                ],
              ),
            ]),
          ),
          footerWidget()
        ],
      ),
    );
  }

  Widget EventInterestsWidget() {
    return Container(
      width: 450,
      child: Column(
        children: [
          headerWidget(Icon(Icons.settings), 'Settings'),
          InterestsWidget(context: context, sendUpdate: () {}),
          footerWidget()
        ],
      ),
    );
  }

  Widget EventDeleteWidget() {
    return Container(
      width: 450,
      child: Column(
        children: [
          headerWidget(Icon(Icons.settings), 'Settings'),
          Container(
            padding: const EdgeInsets.only(right: 30, left: 30),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 65,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 252, 124, 95),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Row(
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 30)),
                            Icon(
                              Icons.warning_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            Container(
                                width: 200,
                                child: const Text(
                                  'Once you delete your event you will no longer can access it again',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 11),
                                )),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                          width: 145,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(3),
                                backgroundColor:
                                    const Color.fromARGB(255, 245, 54, 92),
                                // elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3.0)),
                                minimumSize: const Size(140, 50),
                                maximumSize: const Size(140, 50),
                              ),
                              onPressed: () {
                                (() => {});
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Icon(Icons.delete),
                                  Text('Delete My Account',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))
                                ],
                              ))),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget headerWidget(icon, pagename) {
    return Padding(
      padding: EdgeInsets.only(right: 20, top: 20),
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
          ],
        ),
      ),
    );
  }

  Widget footerWidget() {
    return Padding(
      padding: EdgeInsets.only(right: 20, top: 20),
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
                    padding: EdgeInsets.all(3),
                    backgroundColor: Colors.white,
                    // elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0)),
                    minimumSize: const Size(120, 50),
                    maximumSize: const Size(120, 50),
                  ),
                  onPressed: () {
                    (() => {});
                  },
                  child: Text('Save Changes',
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                          fontWeight: FontWeight.bold))),
              const Padding(padding: EdgeInsets.only(right: 30))
            ],
          )),
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

  Widget privacySelect(title, content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
            flex: 4,
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 30),
              width: SizeConfig(context).screenWidth * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        color: Color.fromRGBO(82, 95, 127, 1),
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(content,
                      overflow: TextOverflow.clip,
                      style: TextStyle(fontSize: 13)),
                ],
              ),
            )),
        const Flexible(fit: FlexFit.tight, child: SizedBox()),
        SizedBox(
          height: 20,
          child: Transform.scale(
            scaleX: 1,
            scaleY: 1,
            child: CupertinoSwitch(
              thumbColor: Colors.white,
              activeColor: Colors.black,
              value: true,
              onChanged: (value) {},
            ),
          ),
        ),
      ],
    );
  }

  Widget inputWidget(value, onChangeFun) {
    return Container(
      width: 400,
      height: 30,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 250, 250, 250),
          border: Border.all(color: Colors.grey)),
      child: TextFormField(
        minLines: 1,
        maxLines: 7,
        initialValue: value,
        onChanged: (value) async {
          onChangeFun(value);
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
    );
  }

  onClick(String route) {
    eventSettingTab = route;
    setState(() {});
  }
}