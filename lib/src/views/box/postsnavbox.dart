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

import '../../controllers/UserController.dart';

class PostsNavBox extends StatefulWidget {
  PostsNavBox({Key? key}) : super(key: key);

  @override
  State createState() => PostsNavBoxState();
}

class PostsNavBoxState extends mvc.StateMVC<PostsNavBox> {
  //
  bool isSound = false;
  List<Map> sampleData = [
    {
      'icon': Icons.photo_camera_back_outlined,
      'color': Color.fromARGB(255, 103, 58, 183),
      'text': 'Create Story',
      'event': ()=>{},
    },
    {
      'icon': Icons.low_priority_outlined,
      'color': Color.fromARGB(255, 242, 94, 78),
      'text': 'Create News',
      'event': ()=>{},
    },
    {
      'icon': Icons.production_quantity_limits_sharp,
      'color': Color.fromARGB(255, 43, 83, 164),
      'text': 'Create Product',
      'event': ()=>{},
    },
    {
      'icon': Icons.flag,
      'color': Color.fromARGB(255, 33, 150, 243), 
      'text': 'Create Page',
      'event': ()=>{},
    },
    {
      'icon': Icons.groups,
      'color': Color.fromARGB(255, 43, 83, 164),
      'text': 'Create Group',
      'event': ()=>{},
    },
    {
      'icon': Icons.edit_calendar_rounded,
      'color': Color.fromARGB(255, 247, 159, 88),
      'text': 'Create Event',
      'event': ()=>{},
    },
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
          width: 150,
          color: Colors.white,
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 200,
                //size: Size(100,100),
                child: ListView.separated(
                  itemCount: sampleData.length,
                  itemBuilder: (context, index) => Material(
                      child: ListTile(
                          onTap: () {
                            sampleData[index]['event'];
                          },
                          hoverColor: Colors.grey[100],
                          tileColor: Colors.white,
                          enabled: true,
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(sampleData[index]['icon'],
                              color: sampleData[index]['color'],
                              size: 20,),
                              Column(children: [
                                const Padding(padding: EdgeInsets.only(top: 3)),
                                Text(sampleData[index]['text'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12)),
                              ],),
                              
                            ],
                          ))),
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                    height: 0,
                    endIndent: 0,
                  ),
                ),
              )
            ],
          )),
    );
  }
}
