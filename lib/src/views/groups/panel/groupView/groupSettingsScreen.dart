// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/widget/interests.dart';

import '../../../../widget/admin_list_text.dart';
import '../../../../widget/alertYesNoWidget.dart';

// ignore: must_be_immutable
class GroupSettingsScreen extends StatefulWidget {
  Function onClick;
  GroupSettingsScreen(
      {Key? key, required this.onClick, required this.routerChange})
      : con = PostController(),
        super(key: key);
  final PostController con;
  Function routerChange;

  @override
  State createState() => GroupSettingsScreenState();
}

class GroupSettingsScreenState extends mvc.StateMVC<GroupSettingsScreen> {
  var userInfo = UserManager.userInfo;
  var groupSettingTab = 'Group Settings';
  var groupName = '';
  var groupLocation = '';
  var groupAbout = '';
  var loadingFlag = false;
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController groupLocationController = TextEditingController();
  final TextEditingController groupAboutController = TextEditingController();
  List<Map> list = [
    {
      'text': 'Group Settings',
      'icon': Icons.settings,
    },
    // {
    //   'text': 'Join Requests',
    //   'icon': Icons.person_add_alt,
    // },
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
      'value': 'security',
      'title': 'Secret Group',
      'subtitle': 'Only members can find the group and see posts.',
      'icon': Icons.lock_outline_rounded
    },
  ];
  var privacy;
  var canPub;
  var approval;
  var footerBtnState = false;
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as PostController;
    groupNameController.text = con.group['groupName'];
    groupName = con.group['groupName'];
    groupLocationController.text = con.group['groupLocation'];
    groupLocation = con.group['groupLocation'];
    groupAboutController.text = con.group['groupAbout'];
    groupAbout = con.group['groupAbout'];
    privacy = con.group['groupPrivacy'];
    canPub = con.group['groupCanPub'];
    approval = con.group['groupApproval'];
  }

  late PostController con;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: SizeConfig(context).screenWidth > SizeConfig.mediumScreenSize
            ? SizeConfig(context).screenWidth - SizeConfig.leftBarWidth
            : SizeConfig(context).screenWidth,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
        ));
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
                        ? const Color.fromARGB(255, 94, 114, 228)
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
    return Flexible(
        child: Container(
            padding: const EdgeInsets.only(right: 15),
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    headerWidget(const Icon(Icons.settings), 'Group Settings'),
                    customInput(
                        title: 'Name Your Group',
                        onChange: (value) async {
                          setState(() {
                            groupName = value;
                          });
                        },
                        controller: groupNameController),
                    const Padding(padding: EdgeInsets.only(top: 15)),
                    customInput(
                        title: 'Location',
                        onChange: (value) async {
                          setState(() {
                            groupLocation = value;
                          });
                        },
                        controller: groupLocationController),
                    // const Padding(padding: EdgeInsets.only(top: 15)),
                    // customInput(
                    //     title: 'Group Username',
                    //     onChange: (value) async {},
                    //     controller: groupUserNameController),
                    // const Text(
                    //   'Can only contain alphanumeric characters (A–Z, 0–9) and periods (\'.\')',
                    //   style: TextStyle(fontSize: 12),
                    // ),
                    const Padding(padding: EdgeInsets.only(top: 15)),
                    Container(
                      height: 70,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 250, 250, 250),
                          border: Border.all(color: Colors.grey)),
                      child: DropdownButton(
                        value: privacy,
                        itemHeight: 70,
                        items: GroupsDropDown.map((e) => DropdownMenuItem(
                            value: e['value'],
                            child: SizedBox(
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
                    const Padding(padding: EdgeInsets.only(top: 15)),
                    customInput(
                        title: 'About',
                        onChange: (value) async {
                          setState(() {
                            groupAbout = value;
                          });
                        },
                        controller: groupAboutController),
                    const Padding(padding: EdgeInsets.only(top: 15)),
                    privacySelect(
                      'Members Can Publish Posts?',
                      'Members can publish posts or only group admins',
                      canPub,
                      (value) {
                        canPub = value;
                        setState(() {});
                      },
                    ),
                    const Padding(padding: EdgeInsets.only(top: 15)),

                    footerWidget({
                      'groupName': groupName,
                      'groupLocation': groupLocation,
                      'groupAbout': groupAbout,
                      'groupPrivacy': privacy,
                      'groupCanPub': canPub,
                      'groupApproval': approval,
                    }),
                    const Padding(padding: EdgeInsets.only(top: 50)),
                  ],
                ))));
  }

  Widget GroupSettingsWidget1() {
    return SizedBox(
      width: 600,
      child: Column(
        children: [
          headerWidget(const Icon(Icons.settings), 'Group Settings'),
          SizedBox(
            width: 430,
            child: Column(children: [
              const Padding(padding: EdgeInsets.only(top: 15)),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
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
                  SizedBox(
                    width: 400,
                    child: customInput(
                        title: 'Location',
                        onChange: (value) async {},
                        controller: groupLocationController),
                  )
                ],
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
                            child: SizedBox(
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
                  SizedBox(
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
    return Flexible(
        child: Container(
            padding: const EdgeInsets.only(right: 15),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                children: [
                  headerWidget(
                      const Icon(Icons.person_add_alt), 'Member Requests'),
                  Container(
                    padding: const EdgeInsets.only(right: 30, left: 30),
                    child: const Text('No Requests'),
                  ),
                ],
              ),
            )));
  }

  Widget GroupMembersWidget() {
    return Flexible(
        child: Container(
            padding: const EdgeInsets.only(right: 15),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(children: [
                headerWidget(const Icon(Icons.groups), 'Members'),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ADMINS (${con.group["groupAdmin"].length})'),
                    SizedBox(
                      height: con.group['groupAdmin'].length * 45.0,
                      child: ListView.separated(
                        itemCount: con.group['groupAdmin'].length,
                        itemBuilder: (context, index) => Material(
                            child: ListTile(
                                onTap: () {},
                                hoverColor:
                                    const Color.fromARGB(255, 243, 243, 243),
                                // tileColor: Colors.white,
                                enabled: true,
                                leading: con.group['groupAdmin'][index]
                                            ['avatar'] ==
                                        ''
                                    ? CircleAvatar(
                                        radius: 17,
                                        child:
                                            SvgPicture.network(Helper.avatar))
                                    : CircleAvatar(
                                        radius: 17,
                                        backgroundImage: NetworkImage(
                                            con.group['groupAdmin'][index]
                                                ['avatar'])),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          child: Text(
                                            con.group['groupAdmin'][index]
                                                ['userName'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ),
                                        // ElevatedButton(
                                        //   style: ElevatedButton.styleFrom(
                                        //       backgroundColor:
                                        //           const Color.fromARGB(
                                        //               255, 245, 54, 92),
                                        //       elevation: 3,
                                        //       shape: RoundedRectangleBorder(
                                        //           borderRadius:
                                        //               BorderRadius.circular(
                                        //                   2.0)),
                                        //       minimumSize: const Size(90, 35),
                                        //       maximumSize: const Size(90, 35)),
                                        //   onPressed: () {
                                        //     () => {};
                                        //   },
                                        //   child: Row(
                                        //     children: const [
                                        //       Icon(
                                        //         Icons.delete,
                                        //         color: Colors.white,
                                        //         size: 18.0,
                                        //       ),
                                        //       Text('Remove',
                                        //           style: TextStyle(
                                        //               color: Colors.white,
                                        //               fontSize: 11,
                                        //               fontWeight:
                                        //                   FontWeight.bold)),
                                        //     ],
                                        //   ),
                                        // ),
                                        // const Padding(
                                        //     padding: EdgeInsets.only(left: 10)),
                                        // ElevatedButton(
                                        //   style: ElevatedButton.styleFrom(
                                        //       backgroundColor:
                                        //           const Color.fromARGB(
                                        //               255, 245, 54, 92),
                                        //       elevation: 3,
                                        //       shape: RoundedRectangleBorder(
                                        //           borderRadius:
                                        //               BorderRadius.circular(
                                        //                   2.0)),
                                        //       minimumSize: const Size(125, 35),
                                        //       maximumSize: const Size(125, 35)),
                                        //   onPressed: () {
                                        //     () => {};
                                        //   },
                                        //   child: Row(
                                        //     children: const [
                                        //       Icon(
                                        //         Icons.delete,
                                        //         color: Colors.white,
                                        //         size: 18.0,
                                        //       ),
                                        //       Text('Remove Admin',
                                        //           style: TextStyle(
                                        //               color: Colors.white,
                                        //               fontSize: 11,
                                        //               fontWeight:
                                        //                   FontWeight.bold)),
                                        //     ],
                                        //   ),
                                        // ),
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ALL MEMBERS (${con.group["groupJoined"].length})'),
                    con.group['groupJoined'].length == 0
                        ? const SizedBox()
                        : SizedBox(
                            height: con.group['groupJoined'].length * 45.0,
                            child: ListView.separated(
                              itemCount: con.group['groupJoined'].length,
                              itemBuilder: (context, index) => Material(
                                  child: ListTile(
                                      onTap: () {},
                                      hoverColor: const Color.fromARGB(
                                          255, 243, 243, 243),
                                      // tileColor: Colors.white,
                                      enabled: true,
                                      leading: con.group['groupJoined'][index]
                                                  ['avatar'] ==
                                              ''
                                          ? CircleAvatar(
                                              radius: 17,
                                              child: SvgPicture.network(
                                                  Helper.avatar))
                                          : CircleAvatar(
                                              radius: 17,
                                              backgroundImage: NetworkImage(
                                                  con.group['groupJoined']
                                                      [index]['avatar'])),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                  con.group['groupJoined']
                                                      [index]['userName'],
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12),
                                                ),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color
                                                                .fromARGB(255,
                                                            245, 54, 92),
                                                    elevation: 3,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        2.0)),
                                                    minimumSize:
                                                        const Size(90, 35),
                                                    maximumSize:
                                                        const Size(90, 35)),
                                                onPressed: () => showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    title: const SizedBox(),
                                                    content: AlertYesNoWidget(
                                                        yesFunc: () {
                                                          Navigator.of(context)
                                                              .pop(true);
                                                          con.group[
                                                                  'groupJoined']
                                                              .removeAt(index);
                                                          setState(() {});
                                                        },
                                                        noFunc: () {
                                                          Navigator.of(context)
                                                              .pop(true);
                                                        },
                                                        header: 'Delete Member',
                                                        text:
                                                            'Are you sure you want to delete this member? ',
                                                        progress: loadingFlag),
                                                  ),
                                                ),
                                                child: const Row(
                                                  children: [
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
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                              ),
                                              const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10)),
                                              // ElevatedButton(
                                              //   style: ElevatedButton.styleFrom(
                                              //       backgroundColor:
                                              //           const Color.fromARGB(
                                              //               255, 245, 54, 92),
                                              //       elevation: 3,
                                              //       shape:
                                              //           RoundedRectangleBorder(
                                              //               borderRadius:
                                              //                   BorderRadius
                                              //                       .circular(
                                              //                           2.0)),
                                              //       minimumSize:
                                              //           const Size(125, 35),
                                              //       maximumSize:
                                              //           const Size(125, 35)),
                                              //   onPressed: () {
                                              //     () => {};
                                              //   },
                                              //   child: Row(
                                              //     children: const [
                                              //       Icon(
                                              //         Icons.delete,
                                              //         color: Colors.white,
                                              //         size: 18.0,
                                              //       ),
                                              //       Text('Remove Admin',
                                              //           style: TextStyle(
                                              //               color: Colors.white,
                                              //               fontSize: 11,
                                              //               fontWeight:
                                              //                   FontWeight
                                              //                       .bold)),
                                              //     ],
                                              //   ),
                                              // ),
                                            ],
                                          )
                                        ],
                                      ))),
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(
                                height: 1,
                                endIndent: 10,
                              ),
                            ),
                          )
                  ],
                ),
              ]),
            )));
  }

  Widget GroupInterestsWidget() {
    return Flexible(
        child: Container(
            padding: const EdgeInsets.only(right: 15),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                children: [
                  headerWidget(const Icon(Icons.heart_broken), 'Interests'),
                  Container(
                    margin: const EdgeInsets.only(left: 30, right: 30),
                    child: InterestsWidget(
                        context: context,
                        data: con.group['groupInterests'],
                        sendUpdate: (value) {
                          con.group['groupInterests'] = value;
                          setState(() {});
                        }),
                  ),
                  footerWidget({'groupInterests': con.group['groupInterests']})
                ],
              ),
            )));
  }

  Widget GroupDeleteWidget() {
    return Flexible(
        child: Container(
            padding: const EdgeInsets.only(right: 15),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                children: [
                  headerWidget(const Icon(Icons.delete), 'Delete'),
                  Container(
                    padding: const EdgeInsets.only(right: 30, left: 30),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Container(
                              height: 60,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 252, 124, 95),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                              child: const Row(
                                children: [
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.warning_rounded,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  SizedBox(width: 10),
                                  Flexible(
                                      child: Text(
                                    'Once you delete your group you will no longer can access it again',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 11),
                                  )),
                                ],
                              ),
                            )),
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
                                        backgroundColor: const Color.fromARGB(
                                            255, 245, 54, 92),
                                        // elevation: 3,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(3.0)),
                                        minimumSize: const Size(140, 50),
                                        maximumSize: const Size(140, 50),
                                      ),
                                      onPressed: () => showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              title: const SizedBox(),
                                              content: AlertYesNoWidget(
                                                  yesFunc: () {
                                                    setState(() {
                                                      loadingFlag = true;
                                                    });

                                                    con.deletePostOfGroup();
                                                    con.deleteGroup();

                                                    setState(() {
                                                      loadingFlag = false;
                                                    });
                                                    Navigator.of(context)
                                                        .pop(true);
                                                    widget.routerChange({
                                                      'router':
                                                          RouteNames.groups,
                                                    });
                                                  },
                                                  noFunc: () {
                                                    Navigator.of(context)
                                                        .pop(true);
                                                  },
                                                  header: 'Delete Group',
                                                  text:
                                                      'Are you sure you want to delete this group? All posts in group will be deleted!',
                                                  progress: loadingFlag),
                                            ),
                                          ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
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
            )));
  }

  Widget headerWidget(icon, pagename) {
    return Container(
      height: 65,
      alignment: Alignment.center,
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          const Padding(padding: EdgeInsets.only(left: 10)),
          Text(pagename),
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
                if (groupNameController.text.isEmpty) {
                  Helper.showToast("Please input Group name!");
                  return;
                }
                footerBtnState = true;

                setState(() {});
                con.updateGroupInfo({
                  'groupName': groupNameController.text,
                  'groupLocation': groupLocationController.text,
                  'groupAbout': groupAboutController.text,
                  'groupPrivacy': privacy,
                  'groupCanPub': canPub,
                  'groupApproval': approval,
                  'groupInterests': con.group['groupInterests'],
                }).then(
                  (value) async {
                    footerBtnState = false;
                    await con.updateGroup();
                    groupNameController.text = con.group['groupName'];
                    groupLocationController.text = con.group['groupLocation'];
                    groupAboutController.text = con.group['groupAbout'];
                    privacy = con.group['groupPrivacy'];
                    canPub = con.group['groupCanPub'];
                    approval = con.group['groupApproval'];

                    setState(() {});
                    widget.routerChange({
                      'router': RouteNames.groups,
                      'subRouter': value,
                    });
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
          style: const TextStyle(
              color: Color.fromRGBO(82, 95, 127, 1),
              fontSize: 13,
              fontWeight: FontWeight.w600),
        ),
        const Padding(padding: EdgeInsets.only(top: 2)),
        SizedBox(
          height: 40,
          child: TextField(
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
              padding: const EdgeInsets.only(left: 10, right: 30),
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
                      style: const TextStyle(fontSize: 13)),
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
