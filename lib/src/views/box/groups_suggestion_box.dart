import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/colors.dart';

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shnatter/src/utils/size_config.dart';

import '../../controllers/UserController.dart';

class ShnatterGroupSuggest extends StatefulWidget {
  ShnatterGroupSuggest({Key? key}) : super(key: key);

  @override
  State createState() => ShnatterGroupSuggestState();
}

class ShnatterGroupSuggestState extends mvc.StateMVC<ShnatterGroupSuggest> {
  //
  bool isSound = true;
  List<Map> sampleData = [
    {
      'avatarImg': '',
      'name': 'Adetola',
      'subname': '1 Members',
      'icon': Icons.nature
    },
    {
      'avatarImg': '',
      'name': 'Adetola',
      'subname': '1 Members',
      'icon': Icons.nature
    },
    {
      'avatarImg': '',
      'name': 'Adetola',
      'subname': '1 Members',
      'icon': Icons.nature
    },
    {
      'avatarImg': '',
      'name': 'Adetola',
      'subname': '1 Members',
      'icon': Icons.nature
    },
    {
      'avatarImg': '',
      'name': 'Adetola',
      'subname': '1 Members',
      'icon': Icons.nature
    }
  ];
  var con = PostController();
  var userInfo = UserManager.userInfo;
  var isJoining = {};
  @override
  void initState() {
    Future.delayed(const Duration(microseconds: 0), () async {
      con.unJoindGroups = await con.getGroup('unJoined', userInfo['userName']);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Container(
          width: SizeConfig.rightPaneWidth,
          // color: Color.fromARGB(255, 255, 255, 255),
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Suggested Groups",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 45.0),
                  ),
                  Row(children: [
                    Text(
                      'See All',
                      style: TextStyle(fontSize: 11),
                    ),
                    SizedBox(
                      height: 20,
                      child: Transform.scale(
                        scaleX: 0.55,
                        scaleY: 0.55,
                        child: CupertinoSwitch(
                          //thumbColor: kprimaryColor,
                          activeColor: kprimaryColor,
                          value: isSound,
                          onChanged: (value) {
                            setState(() {
                              isSound = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ])
                ],
              ),
              const Divider(
                height: 1,
                //thickness: 5,
                //indent: 20,
                //endIndent: 0,
                //color: Colors.black,
              ),
              AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  height: isSound ? 260 : 0,
                  curve: Curves.fastOutSlowIn,
                  child: SizedBox(
                    //size: Size(100,100),
                    child: ListView.separated(
                      itemCount: con.unJoindGroups.length,
                      itemBuilder: (context, index) => Material(
                          child: ListTile(
                        contentPadding:
                            const EdgeInsets.only(left: 10, right: 10),
                        leading: Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: CircleAvatar(
                                radius: 17,
                                backgroundImage: NetworkImage(
                                    con.unJoindGroups[index]['data']
                                                ['groupPicture'] ==
                                            ''
                                        ? Helper.blankGroup
                                        : con.unJoindGroups[index]['data']
                                            ['groupPicture']))),
                        title: Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text(
                              con.unJoindGroups[index]['data']['groupName'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 11),
                            )),
                        subtitle: Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text(
                              '${con.unJoindGroups[index]['data']['groupJoined'].length} Members',
                              style: TextStyle(fontSize: 10),
                            )),
                        trailing: ElevatedButton(
                            onPressed: () async {
                              isJoining[index] = true;
                              setState(() {});
                              con
                                  .joinedGroup(con.unJoindGroups[index]['id'])
                                  .then((value) async {
                                con.unJoindGroups = await con.getGroup(
                                    'unJoined', userInfo['userName']);
                                isJoining[index] = false;
                                setState(() {});
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2.0)),
                                minimumSize:
                                    isJoining[index] != null && isJoining[index]
                                        ? const Size(60, 35)
                                        : const Size(80, 35),
                                maximumSize:
                                    isJoining[index] != null && isJoining[index]
                                        ? const Size(60, 35)
                                        : const Size(80, 35)),
                            child: isJoining[index] != null && isJoining[index]
                                ? const SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                  )
                                : Row(
                                    children: const [
                                      Icon(
                                        Icons.person_add_alt_rounded,
                                        color: Colors.black,
                                        size: 18.0,
                                      ),
                                      Text(' Join',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w900)),
                                    ],
                                  )),
                      )),
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(
                        height: 1,
                        endIndent: 10,
                      ),
                    ),
                  ))
            ],
          )),
    );
  }
}
