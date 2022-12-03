
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
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

class ShnatterSearchBox extends StatefulWidget {
  ShnatterSearchBox({Key? key}) : super(key: key);

  @override
  State createState() => ShnatterSearchBoxState();
}

class ShnatterSearchBoxState extends mvc.StateMVC<ShnatterSearchBox> {
  //
  bool isSound = false;
  List<Map> usersData = [
    {
      'avatarImg': '',
      'name': 'Adetola',
      'subname': '1 Interested',
      'icon': Icons.nature
    }
  ];
  List<Map> pagesData = [
    {
      'avatarImg': '',
      'name': 'Adetola',
      'subname': '1 Interested',
      'icon': Icons.nature
    }
  ];
  List<Map> groupsData = [
    {
      'avatarImg': '',
      'name': 'Adetola',
      'subname': '1 Interested',
      'icon': Icons.nature
    }
  ];
  List<Map> eventsData = [
    {
      'avatarImg': '',
      'name': 'Adetola',
      'subname': '1 Interested',
      'icon': Icons.nature
    },
    {
      'avatarImg': '',
      'name': 'Adetola',
      'subname': '1 Interested',
      'icon': Icons.nature
    },
    {
      'avatarImg': '',
      'name': 'Adetola',
      'subname': '1 Interested',
      'icon': Icons.nature
    },
    {
      'avatarImg': '',
      'name': 'Adetola',
      'subname': '1 Interested',
      'icon': Icons.nature
    },
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var listTileSize = SizeConfig(context).screenWidth * 0.4 * 0.6;
    return ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Column(
          children: [
            Container(
                width: 400,
                color: Color.fromARGB(255, 255, 255, 255),
                padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "Search Results",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(
                      height: 1,
                      endIndent: 10,
                    ),
                    SizedBox(
                      height: eventsData.length * 49,
                      //size: Size(100,100),
                      child: ListView.separated(
                        itemCount: eventsData.length,
                        itemBuilder: (context, index) => Material(
                            child: ListTile(
                                onTap: () {
                                  print("tap!");
                                },
                                hoverColor:
                                    const Color.fromARGB(255, 243, 243, 243),
                                tileColor: Colors.white,
                                enabled: true,
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "https://test.shnatter.com/content/themes/default/images/blank_event.jpg"),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 190,
                                          alignment: Alignment.topLeft,
                                          child: Column(children: [
                                            Text(
                                              eventsData[index]['name'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                            Text(eventsData[index]['subname'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 10)),
                                          ]),
                                        ),
                                        Container(
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  elevation: 3,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2.0)),
                                                  minimumSize:
                                                      new Size(100, 35),
                                                  maximumSize:
                                                      new Size(100, 35),
                                                ),
                                                onPressed: () {
                                                  () => {};
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: Color.fromARGB(
                                                          255, 33, 37, 41),
                                                      size: 18.0,
                                                    ),
                                                    Text('Interested',
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    33,
                                                                    37,
                                                                    41),
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
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
                    ),
                    Divider(height: 1, indent: 0),
                    Container(
                        color: Colors.grey[300],
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                child: Text('Search All Result',
                                    style: TextStyle(fontSize: 11)),
                                onPressed: () {}),
                          ],
                        ))
                  ],
                )),
          ],
        ));
  }
}
