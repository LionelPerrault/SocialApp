import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/widget/interests.dart';
import 'package:shnatter/src/widget/startedInput.dart';

import '../../../../widget/admin_list_text.dart';

class GroupSettingsScreen extends StatefulWidget {
  Function onClick;
  GroupSettingsScreen({Key? key, required this.onClick})
      : con = PostController(),
        super(key: key);
  final PostController con;
  @override
  State createState() => GroupSettingsScreenState();
}

class GroupSettingsScreenState extends mvc.StateMVC<GroupSettingsScreen> {
  var userInfo = UserManager.userInfo;
  var groupSettingTab = 'Group Settings';
  List<Map> list = [
    {
      'text': 'Group Settings',
      'icon': Icons.settings,
    },
    {
      'text': 'Join Requests',
      'icon': Icons.person_add_alt,
    },
    {
      'text': 'Members',
      'icon': Icons.groups,
    },
    {
      'text': 'Interests',
      'icon': Icons.heart_broken,
    },
    {
      'text': 'Delete Group',
      'icon': Icons.delete,
    },
  ];
  List<Map> GroupsDropDown = [
    {
      'value': 'public',
      'title': 'Public Group',
      'subtitle': 'Anyone can see the group, its members and their posts.',
      'icon': Icons.language
    },
    {
      'value': 'closed',
      'title': 'Closed Group',
      'subtitle': 'Only members can see posts.',
      'icon': Icons.lock_open_rounded
    },
    {
      'value': 'secret',
      'title': 'Secret Group',
      'subtitle': 'Only members can find the group and see posts.',
      'icon': Icons.lock_outline_rounded
    },
  ];
  var privacy = 'public';
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
          groupSettingTab == 'Group Settings'
              ? GroupSettingsWidget()
              : groupSettingTab == 'Join Requests'
                  ? GroupJoinWidget()
                  : groupSettingTab == 'Members'
                      ? GroupMembersWidget()
                      : groupSettingTab == 'Interests'
                          ? GroupInterestsWidget()
                          : GroupDeleteWidget(),
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
          mainAxisAlignment: MainAxisAlignment.start,
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
                    color: groupSettingTab == e['text']
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

  Widget GroupSettingsWidget() {
    return Container(
      width: 450,
      child: Column(
        children: [
          headerWidget(Icon(Icons.settings), 'Group Settings'),
          Container(
            width: 430,
            child: Column(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text(
                        'Name Your Group',
                        style: TextStyle(
                            color: Color.fromARGB(255, 82, 95, 127),
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    width: 400,
                    child: input(validator: (value) async {
                      print(value);
                    }, onchange: (value) async {
                      con.group['groupName'] = value;
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
                    child: input(validator: (value) async {
                      print(value);
                    }, onchange: (value) async {
                      con.group['groupLocation'] = value;
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
                      Text('Group Username',
                          style: TextStyle(
                              color: Color.fromARGB(255, 82, 95, 127),
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Container(
                    width: 400,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                      ),
                      child: Row(children: [
                        Container(
                          padding: EdgeInsets.only(top: 7),
                          alignment: Alignment.topCenter,
                          width: 240,
                          height: 30,
                          color: Colors.grey,
                          child: Text('https://test.shnatter.com/groups/'),
                        ),
                        Expanded(
                            child: Container(
                          width: 260,
                          height: 30,
                          child: TextFormField(
                            onChanged: (value) {
                              con.group['groupUserName'] = value;
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 54, 54, 54),
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            style: const TextStyle(fontSize: 14),
                            onSaved: (String? value) {
                              // This optional block of code can be used to run
                              // code when the user saves the form.
                            },
                          ),
                        )),
                      ]),
                    ),
                  )
                ],
              ),
              Container(
                width: 380,
                child: const Text(
                  'Can only contain alphanumeric characters (A–Z, 0–9) and periods (\'.\')',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 15)),
              Row(
                children: [
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Colors.grey)),
                    height: 70,
                    child: DropdownButton(
                      value: privacy,
                      itemHeight: 70,
                      items: GroupsDropDown.map(
                        (e) => DropdownMenuItem(
                          value: e['value'],
                          child: Container(
                            height: 70,
                            margin: const EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                Container(
                                  height: 70,
                                  child: Icon(
                                    e['icon'],
                                    size: 40,
                                  ),
                                ),
                                Container(
                                  height: 70,
                                  margin:
                                      const EdgeInsets.only(top: 10, left: 5),
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e['title'],
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                      Text(
                                        e['subtitle'],
                                        style: const TextStyle(fontSize: 12),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ).toList(),
                      onChanged: (value) {
                        privacy = value.toString();
                        con.group['groupPrivacy'] = privacy;
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
                    ),
                  )),
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
                                    // con.group['groupAbout'] = value;
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
                            ],
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

  Widget GroupJoinWidget() {
    return Container(
      width: 450,
      child: Column(
        children: [
          headerWidget(Icon(Icons.person_add_alt), 'Member Requests'),
          Container(
            padding: const EdgeInsets.only(right: 30, left: 30),
            child: Text('No Requests'),
          ),
        ],
      ),
    );
  }

  Widget GroupMembersWidget() {
    return Container(
      width: 510,
      child: Column(
        children: [
          headerWidget(Icon(Icons.groups), 'Members'),
          Container(
            padding: const EdgeInsets.only(right: 30, left: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ADMINS (${con.group["groupAdmin"].length})'),
                SizedBox(
                  width: 450,
                  height: con.group['groupAdmin'].length * 45,
                  child: ListView.separated(
                    itemCount: con.group['groupAdmin'].length,
                    itemBuilder: (context, index) => Material(
                        child: ListTile(
                            onTap: () {
                              print("tap!");
                            },
                            hoverColor:
                                const Color.fromARGB(255, 243, 243, 243),
                            // tileColor: Colors.white,
                            enabled: true,
                            leading: const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://test.shnatter.com/content/themes/default/images/blank_profile_male.svg"),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text(
                                        con.group['groupAdmin'][index]
                                            ['userName'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                    Container(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 245, 54, 92),
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(2.0)),
                                            minimumSize: const Size(90, 35),
                                            maximumSize: const Size(90, 35)),
                                        onPressed: () {
                                          () => {};
                                        },
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 18.0,
                                            ),
                                            Text('Remove',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(left: 10)),
                                    Container(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 245, 54, 92),
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(2.0)),
                                            minimumSize: const Size(125, 35),
                                            maximumSize: const Size(125, 35)),
                                        onPressed: () {
                                          () => {};
                                        },
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 18.0,
                                            ),
                                            Text('Remove Admin',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ))),
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                      height: 1,
                      endIndent: 10,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 30, left: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ALL MEMBERS (${con.group["groupJoined"].length})'),
                SizedBox(
                  width: 450,
                  height: con.group['groupAdmin'].length * 45,
                  child: ListView.separated(
                    itemCount: con.group['groupJoined'].length,
                    itemBuilder: (context, index) => Material(
                        child: ListTile(
                            onTap: () {
                              print("tap!");
                            },
                            hoverColor:
                                const Color.fromARGB(255, 243, 243, 243),
                            // tileColor: Colors.white,
                            enabled: true,
                            leading: const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://test.shnatter.com/content/themes/default/images/blank_profile_male.svg"),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text(
                                        con.group['groupJoined'][index]
                                            ['userName'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                    Container(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 245, 54, 92),
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(2.0)),
                                            minimumSize: const Size(90, 35),
                                            maximumSize: const Size(90, 35)),
                                        onPressed: () {
                                          () => {};
                                        },
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 18.0,
                                            ),
                                            Text('Remove',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(left: 10)),
                                    Container(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 245, 54, 92),
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(2.0)),
                                            minimumSize: const Size(125, 35),
                                            maximumSize: const Size(125, 35)),
                                        onPressed: () {
                                          () => {};
                                        },
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 18.0,
                                            ),
                                            Text('Remove Admin',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ))),
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                      height: 1,
                      endIndent: 10,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget GroupInterestsWidget() {
    return Container(
      width: 450,
      child: Column(
        children: [
          headerWidget(Icon(Icons.heart_broken), 'Interests'),
          InterestsWidget(context: context, sendUpdate: () {}),
          footerWidget()
        ],
      ),
    );
  }

  Widget GroupDeleteWidget() {
    return Container(
      width: 450,
      child: Column(
        children: [
          headerWidget(Icon(Icons.delete), 'Delete'),
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
                                  'Once you delete your group you will no longer can access it again',
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
                                  Text('Delete Group',
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

  onClick(String route) {
    groupSettingTab = route;
    setState(() {});
  }
}
