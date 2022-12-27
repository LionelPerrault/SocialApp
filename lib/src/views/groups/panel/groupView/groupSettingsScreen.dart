import 'package:flutter/cupertino.dart';
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
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController groupUserNameController = TextEditingController();
  final TextEditingController groupLocationController = TextEditingController();
  final TextEditingController groupAboutController = TextEditingController();
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
  var privacy;
  var canPub;
  var approval;
  var groupInterests;
  var footerBtnState = false;
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as PostController;
    groupNameController.text = con.group['groupName'];
    groupUserNameController.text = con.group['groupUserName'];
    groupLocationController.text = con.group['groupLocation'];
    groupAboutController.text = con.group['groupAbout'];
    privacy = con.group['groupPrivacy'];
    canPub = con.group['groupCanPub'];
    approval = con.group['groupApproval'];
  }

  late PostController con;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LeftSettingBar(),
          Expanded(
            child: groupSettingTab == 'Group Settings'
                ? GroupSettingsWidget()
                : groupSettingTab == 'Join Requests'
                    ? GroupJoinWidget()
                    : groupSettingTab == 'Members'
                        ? GroupMembersWidget()
                        : groupSettingTab == 'Interests'
                            ? GroupInterestsWidget()
                            : GroupDeleteWidget(),
          ),
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
      width: 600,
      child: Column(
        children: [
          headerWidget(Icon(Icons.settings), 'Group Settings'),
          Container(
            width: 430,
            child: Column(children: [
              const Padding(padding: EdgeInsets.only(top: 15)),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 400,
                    child: customInput(
                        title: 'Name Your Group',
                        onChange: (value) async {},
                        controller: groupNameController),
                  )
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 15)),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 400,
                    child: customInput(
                        title: 'Location',
                        onChange: (value) async {},
                        controller: groupLocationController),
                  )
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 15)),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 400,
                    child: customInput(
                        title: 'Group Username',
                        onChange: (value) async {},
                        controller: groupUserNameController),
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
                      width: 400,
                      height: 70,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 250, 250, 250),
                          border: Border.all(color: Colors.grey)),
                      child: DropdownButton(
                        value: privacy,
                        itemHeight: 70,
                        items: GroupsDropDown.map((e) => DropdownMenuItem(
                            value: e['value'],
                            child: Container(
                                height: 70,
                                child: ListTile(
                                  leading: Icon(e['icon']),
                                  title: Text(e['title']),
                                  subtitle: Text(e['subtitle']),
                                )))).toList(),
                        onChanged: (value) {
                          privacy = value;
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
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 15)),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 400,
                    child: customInput(
                        title: 'About',
                        onChange: (value) async {},
                        controller: groupAboutController),
                  )
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
                          canPub,
                          (value) {
                            canPub = value;
                            setState(() {});
                          },
                        ),
                      ),
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
                          approval,
                          (value) {
                            approval = value;
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ]),
          ),
          footerWidget({
            'groupName': groupNameController.text,
            'groupUserName': groupUserNameController.text,
            'groupLocation': groupLocationController.text,
            'groupAbout': groupAboutController.text,
            'groupPrivacy': privacy,
            'groupCanPub': canPub,
            'groupApproval': approval,
          })
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
          Container(
            margin: const EdgeInsets.only(left: 30, right: 30),
            child: InterestsWidget(
                context: context,
                data: con.group['groupInterests'],
                sendUpdate: (value) {
                  groupInterests = value;
                  setState(() {});
                }),
          ),
          footerWidget({'groupInterests': groupInterests})
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
    return Container(
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
    );
  }

  Widget footerWidget(updateData) {
    return Container(
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
                minimumSize: const Size(120, 50),
                maximumSize: const Size(120, 50),
              ),
              onPressed: () {
                footerBtnState = true;
                setState(() {});
                print(updateData);
                con.updateGroupInfo(updateData).then(
                      (value) => {
                        footerBtnState = false,
                        setState(() {}),
                        if (value != 'doubleName${updateData['groupUserName']}')
                          {
                            Navigator.pushReplacementNamed(
                                context, '/groups/${value}')
                          }
                      },
                    );
              },
              child: footerBtnState
                  ? const SizedBox(
                      width: 10,
                      height: 10.0,
                      child: CircularProgressIndicator(
                        color: Colors.grey,
                      ),
                    )
                  : const Text('Save Changes',
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                          fontWeight: FontWeight.bold))),
          const Padding(padding: EdgeInsets.only(right: 30))
        ],
      ),
    );
  }

  Widget customInput({title, onChange, controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              color: Color.fromRGBO(82, 95, 127, 1),
              fontSize: 13,
              fontWeight: FontWeight.w600),
        ),
        Padding(padding: EdgeInsets.only(top: 2)),
        Container(
          height: 40,
          child: TextField(
            controller: controller,
            onChanged: onChange,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 10, left: 10),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue, width: 1.0),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget customTextarea({title, onChange, controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              color: Color.fromRGBO(82, 95, 127, 1),
              fontSize: 13,
              fontWeight: FontWeight.w600),
        ),
        const Padding(padding: EdgeInsets.only(top: 2)),
        SizedBox(
          height: 100,
          child: TextField(
            maxLines: 10,
            minLines: 5,
            controller: controller,
            onChanged: onChange,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(top: 10, left: 10),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.0),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget privacySelect(title, content, initialValue, onChange) {
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
              value: initialValue,
              onChanged: (value) {
                onChange(value);
              },
            ),
          ),
        ),
      ],
    );
  }

  onClick(String route) {
    groupSettingTab = route;
    setState(() {});
  }
}
