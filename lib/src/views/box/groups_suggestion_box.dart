import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';
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
  @override
  void initState() {
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
              isSound ? SizedBox(
                height: 260,
                //size: Size(100,100),
                child: ListView.separated(
                  itemCount: sampleData.length,
                  itemBuilder: (context, index) => Material(
                      child: ListTile(
                          onTap: () {
                            print("tap!");
                          },
                          hoverColor: const Color.fromARGB(255, 243, 243, 243),
                          enabled: true,
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://test.shnatter.com/content/themes/default/images/blank_group.jpg"),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 90,
                                    alignment: Alignment.topLeft,
                                    child: Column(children: [
                                      Text(
                                        sampleData[index]['name'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                      Text(sampleData[index]['subname'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 10)),
                                    ]),
                                  ),
                                  Container(
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Color.fromARGB(255, 33, 37, 41),
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(2.0)),
                                            minimumSize: new Size(75, 35),
                                          ),
                                          onPressed: () {
                                            () => {};
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.person_add_alt_rounded,
                                                color: Colors.white,
                                                size: 18.0,
                                              ),
                                              Text('Join',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ))),
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
              :
              Column()
            ],
          )),
    );
  }
}
