
import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/utils/svg.dart';
import 'package:shnatter/src/views/box/daytimeM.dart';
import 'package:shnatter/src/views/box/mindpost.dart';
import 'package:shnatter/src/views/setting/widget/setting_footer.dart';
import 'package:shnatter/src/views/setting/widget/setting_header.dart';
import 'package:shnatter/src/widget/mindslice.dart';
import 'package:shnatter/src/widget/startedInput.dart';

class SettingInfoScreen extends StatefulWidget {
  SettingInfoScreen({Key? key}) : super(key: key);
  @override
  State createState() => SettingInfoScreenState();
}
// ignore: must_be_immutable
class SettingInfoScreenState extends State<SettingInfoScreen> {
  var setting_security = {};
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.only(top: 20, left:30),
      child: 
        Column(children: [
          SettingHeader(icon: const Icon(Icons.file_present, color: Color.fromARGB(255, 40, 167, 69),), pagename: 'Download Your Information',
            button: {'flag': false},),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Container(
            width: SizeConfig(context).screenWidth * 0.5,
            child: Column(children: [
              Container(
                width: 680,
                height: 65,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 120, 137, 232),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Row(children: [
                  Padding(padding: EdgeInsets.only(left: 30)),
                  Icon(Icons.warning_rounded, color: Colors.white, size: 30,),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(top: 20)),
                    Text('Download Your Information',
                    style: TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),),
                    Text('You can download all of it at once, or you can select only the types of information you want',
                    style: TextStyle(color: Colors.white,
                                      fontSize: 11),),
                  ],),
                ],),
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              Row(
                children: [
                  button(url: 'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fsettings%2Fdownload%2Fdown_info.svg?alt=media&token=7fe56231-316b-41c8-8805-98af3f7f3a5c',
                          text: 'Info'),
                  button(url: 'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fsettings%2Fdownload%2Fdown_friends.svg?alt=media&token=05a26920-7a8d-460b-a8df-0e290668fe4e',
                          text: 'Friends'),
                  button(url: 'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fsettings%2Fdownload%2Fdown_following.svg?alt=media&token=280217c1-2e61-4da0-9b5e-f013fcf86d3c',
                          text: 'Followings'),
                  button(url: 'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fsettings%2Fdownload%2Fdown_followers.svg?alt=media&token=66f50064-f2ab-4f60-b8ff-682ef09ced4e',
                          text: 'Followers'),
                ],
              ),
              Row(
                children: [
                  button(url: 'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fsettings%2Fdownload%2Fdown_pages.svg?alt=media&token=c1072ce0-4fb2-428c-91dd-bb0fb84e0fe9',
                          text: 'Pages'),
                  button(url: 'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fsettings%2Fdownload%2Fdown_groups.svg?alt=media&token=cb13260e-761c-4ea6-8b4c-9abf8486f103',
                          text: 'Groups'),
                  button(url: 'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fsettings%2Fdownload%2Fdown_events.svg?alt=media&token=308047a0-0c4c-4a0e-9410-d6d035db05ed',
                          text: 'Events'),
                  button(url: 'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fsettings%2Fdownload%2Fdown_posts.svg?alt=media&token=4041790f-855b-4552-8e44-5df3d64acc25',
                          text: 'Posts'),
                ],
              ),
            ],),
          ),
          SettingFooter()
      ],)
      );
  }
  Widget button({url, text}) {
    return Expanded(
            flex: 1,
            child: Container(
              width: 90,
              height: 90,
              margin: EdgeInsets.all(5),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(3),
                  backgroundColor: Colors.white,
                  // elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)),
                  minimumSize: const Size(90, 90),
                  maximumSize: const Size(90, 90),
                ),
                onPressed: () {
                  (()=>{});
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                        decoration: BoxDecoration(
                      // color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                      child: SvgPicture.network(url),
                    ),
                  Text(text, style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold))
                ],))
            ),
            );
  }
}
