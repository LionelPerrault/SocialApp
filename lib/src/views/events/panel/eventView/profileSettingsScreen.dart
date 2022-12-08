import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';

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
      child: Row(children: [
        LeftSettingBar(),
      ]),
    );
  }

  Widget LeftSettingBar() {
    return Container(
      padding: const EdgeInsets.only(top: 30),
      width: SizeConfig.leftBarAdminWidth,
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Column(
          children: list
              .map(
                (e) => ListText(
                  onTap: () => {onClick(e['text'])},
                  label: e['text'],
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
    return Column(
      children: [Container()],
    );
  }

  onClick(String route) {
    eventSettingTab = route;
    setState(() {});
  }
}
