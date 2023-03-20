import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/widget/interests.dart';
import 'package:shnatter/src/widget/startedInput.dart';

import '../../../../routes/route_names.dart';
import '../../../../widget/admin_list_text.dart';
import '../../../../widget/alertYesNoWidget.dart';

class EventSettingsScreen extends StatefulWidget {
  Function onClick;
  EventSettingsScreen(
      {Key? key, required this.onClick, required this.routerChange})
      : con = PostController(),
        super(key: key);
  final PostController con;
  Function routerChange;
  @override
  State createState() => EventSettingsScreenState();
}

class EventSettingsScreenState extends mvc.StateMVC<EventSettingsScreen> {
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventLocationController = TextEditingController();
  final TextEditingController eventStartDController = TextEditingController();
  final TextEditingController eventEndDController = TextEditingController();
  final TextEditingController eventAboutController = TextEditingController();
  bool footerBtnState = false;
  var eventPrivacy;
  var approval;
  var canPub;
  var eventInterests;
  var userInfo = UserManager.userInfo;
  var eventSettingTab = 'Event Settings';
  var loadingFlag = false;
  Map<String, dynamic> eventInfo = {};
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
    eventNameController.text = con.event['eventName'];
    eventLocationController.text = con.event['eventLocation'];
    eventStartDController.text = con.event['eventStartDate'];
    eventEndDController.text = con.event['eventEndDate'];
    eventAboutController.text = con.event['eventAbout'];
    eventPrivacy = con.event['eventPrivacy'];
    canPub = con.event['eventCanPub'];
    approval = con.event['eventApproval'];
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
            child: eventSettingTab == 'Event Settings'
                ? EventSettingsWidget()
                : eventSettingTab == 'Event Interests'
                    ? EventInterestsWidget()
                    : EventDeleteWidget(),
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
                  Container(
                    width: 400,
                    child: customInput(
                      title: 'Name Your Event',
                      controller: eventNameController,
                      onChange: (value) {
                        eventInfo['eventName'] = value;
                        setState(() {});
                      },
                    ),
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
                      controller: eventLocationController,
                      onChange: (value) {
                        eventInfo['eventLocation'] = value;
                        setState(() {});
                      },
                    ),
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
                    child: customDateInput(
                      title: 'Start Date',
                      controller: eventStartDController,
                      onChange: (value) async {},
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(), //get today's date
                            firstDate: DateTime(
                                2000), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101));
                        if (pickedDate != null) {
                          print(
                              pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
                          String formattedDate = DateFormat('yyyy-MM-dd').format(
                              pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                          print(
                              formattedDate); //formatted date output using intl package =>  2022-07-04
                          //You can format date as per your need

                          setState(() {
                            eventStartDController.text = formattedDate;
                            eventInfo['eventStartDate'] = formattedDate;
                          });
                        } else {
                          print("Date is not selected");
                        }
                      },
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
                    child: customDateInput(
                      title: 'End Date',
                      controller: eventEndDController,
                      onChange: (value) async {},
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(), //get today's date
                            firstDate: DateTime(
                                2000), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101));
                        if (pickedDate != null) {
                          print(
                              pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
                          String formattedDate = DateFormat('yyyy-MM-dd').format(
                              pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                          print(
                              formattedDate); //formatted date output using intl package =>  2022-07-04
                          //You can format date as per your need

                          setState(() {
                            eventInfo['eventEndDate'] = formattedDate;
                            eventEndDController.text = formattedDate;
                          });
                        } else {
                          print("Date is not selected");
                        }
                      },
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 15)),
              Container(
                padding: const EdgeInsets.only(left: 20),
                child: Column(children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Text(
                            'Select Privacy',
                            style: TextStyle(
                                color: Color.fromRGBO(82, 95, 127, 1),
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
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
                                    color:
                                        const Color.fromARGB(255, 17, 205, 239),
                                    width:
                                        0.1), //bordrder raiuds of dropdown button
                              ),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 7, left: 15),
                                  child: DropdownButton(
                                    value: eventPrivacy,
                                    items: [
                                      DropdownMenuItem(
                                        value: "public",
                                        child: Row(children: const [
                                          Icon(
                                            Icons.language,
                                            color: Colors.black,
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(left: 5)),
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
                                              padding:
                                                  EdgeInsets.only(left: 5)),
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
                                              padding:
                                                  EdgeInsets.only(left: 5)),
                                          Text(
                                            "Security",
                                            style: TextStyle(fontSize: 13),
                                          )
                                        ]),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      eventPrivacy = value;
                                      eventInfo['eventPrivacy'] = value;
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
                ]),
              ),
              const Padding(padding: EdgeInsets.only(top: 15)),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 400,
                    child: customTextarea(
                      title: 'About',
                      controller: eventAboutController,
                      onChange: (value) {
                        eventInfo['eventAbout'] = value;
                        setState(() {});
                      },
                    ),
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
                            setState(() {
                              canPub = value;
                              eventInfo['eventCanPub'] = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 15)),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Row(
              //       children: [
              //         Expanded(
              //           flex: 1,
              //           child: privacySelect(
              //             'Post Approval',
              //             'All posts must be approved by a group admin(Note: Disable it will approve any pending posts)',
              //             approval,
              //             (value) {
              //               setState(() {
              //                 approval = value;
              //                 eventInfo['eventApproval'] = value;
              //               });
              //             },
              //           ),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
            ]),
          ),
          footerWidget(eventInfo),
          const Padding(padding: EdgeInsets.only(top: 50)),
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
          Container(
            margin: const EdgeInsets.only(left: 30, right: 30),
            child: InterestsWidget(
                context: context,
                data: con.event['eventInterests'],
                sendUpdate: (value) {
                  eventInterests = value;
                  setState(() {});
                }),
          ),
          footerWidget({'eventInterests': eventInterests})
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

                                            con.deletePostOfEvent();
                                            con.deleteEvent();

                                            setState(() {
                                              loadingFlag = false;
                                            });
                                            Navigator.of(context).pop(true);
                                            widget.routerChange({
                                              'router': RouteNames.events,
                                            });
                                          },
                                          noFunc: () {
                                            Navigator.of(context).pop(true);
                                          },
                                          header: 'Delete Post',
                                          text:
                                              'Are you sure you want to delete this event? All posts in event will be deleted!',
                                          progress: loadingFlag),
                                    ),
                                  ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Icon(Icons.delete),
                                  Text('Delete Event',
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
                con.updateEventInfo(updateData).then(
                      (value) => {
                        con.getSelectedEvent(con.viewEventId).then((value) => {
                              setState(() {}),
                            }),
                        Helper.showToast(value),
                        footerBtnState = false,
                        setState(() {}),
                      },
                    );
                print(updateData);
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

  Widget privacySelect(title, content, value, onchange) {
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
              value: value,
              onChanged: (value) {
                onchange(value);
              },
            ),
          ),
        ),
      ],
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
            onChanged: (value) {
              onChange(value);
            },
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

  Widget customDateInput({title, onChange, controller, onTap}) {
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
        Container(
          height: 40,
          child: TextField(
            controller: controller,
            onChanged: onChange,
            onTap: () async {
              onTap();
            },
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

  onClick(String route) {
    eventSettingTab = route;
    setState(() {});
  }
}
