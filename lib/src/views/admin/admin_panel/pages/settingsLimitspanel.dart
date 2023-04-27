import 'package:flutter/material.dart';
import 'package:shnatter/src/controllers/AdminController.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_footer.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_header.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

// ignore: must_be_immutable
class AdminSettingsLimits extends StatefulWidget {
  AdminSettingsLimits({Key? key})
      : con = AdminController(),
        super(key: key);
  final AdminController con;
  @override
  State createState() => AdminSettingsLimitsState();
}

class AdminSettingsLimitsState extends mvc.StateMVC<AdminSettingsLimits> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 30, right: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AdminSettingHeader(
          icon: const Icon(Icons.settings),
          pagename: 'Settings › Limits',
          button: const {'flag': false},
        ),
        titleAndsubtitleInput('Data Heartbeat', 30, 1, () {},
            'The update interval to check for new data (in seconds)'),
        titleAndsubtitleInput('Chat Heartbeat', 30, 1, () {},
            'The update interval to check for new messages (in seconds)'),
        titleAndsubtitleInput('Offline After', 30, 1, () {},
            'The amount of time to be considered online since the last user\'s activity (in seconds). The maximim value is one day = 86400 seconds'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        titleAndsubtitleInput('Newsfeed Results', 30, 1, () {},
            'The number of posts in the newsfeed'),
        titleAndsubtitleInput('Pages Results', 30, 1, () {},
            'The number of results in the pages module'),
        titleAndsubtitleInput('Groups Results', 30, 1, () {},
            'The number of results in the groups module'),
        titleAndsubtitleInput('Events Results', 30, 1, () {},
            'The number of results in the events module'),
        titleAndsubtitleInput('Marketplace Results', 30, 1, () {},
            'The number of results in the marketplace module'),
        titleAndsubtitleInput('Offers Results', 30, 1, () {},
            'The number of results in the offers module'),
        titleAndsubtitleInput('Jobs Results', 30, 1, () {},
            'The number of results in the jobs module'),
        titleAndsubtitleInput('Games Results', 30, 1, () {},
            'The number of results in the games module'),
        titleAndsubtitleInput('Search Results', 30, 1, () {},
            'The number of results in the search module'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        new Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        titleAndsubtitleInput('Minimum Results', 30, 1, () {},
            'The Min number of results per request'),
        titleAndsubtitleInput('Maximum Results', 30, 1, () {},
            'The Max number of results per request'),
        titleAndsubtitleInput('Minimum Even Results', 30, 1, () {},
            'The Min even number of results per request'),
        titleAndsubtitleInput('Maximum Even Results', 30, 1, () {},
            'The Max even number of results per request'),
        titleAndsubtitleInput('Daily chat thereshold', 30, 1, () {},
            'The Max number of chat messages per day'),
        const AdminSettingFooter()
      ]),
    );
  }

  Widget titleAndsubtitleInput(title, height, line, onChange, subTitle) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 85, 95, 127)),
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  width: 400,
                  child: Column(children: [
                    TextField(
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
                              BorderSide(color: Colors.blue, width: 1.0),
                        ),
                      ),
                    ),
                    Text(subTitle)
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
