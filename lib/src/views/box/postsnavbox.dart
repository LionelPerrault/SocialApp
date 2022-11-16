import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/HomeController.dart';
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/colors.dart';

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shnatter/src/widget/createEventWidget.dart';
import 'package:shnatter/src/widget/startedInput.dart';

import '../../controllers/UserController.dart';

class PostsNavBox extends StatefulWidget {
  PostsNavBox({Key? key}) : super(key: key);

  @override
  State createState() => PostsNavBoxState();
}

class PostsNavBoxState extends State<PostsNavBox> {
  //
  bool isSound = false;
  List<Map> sampleData = [
    {
      'icon': Icons.photo_camera_back_outlined,
      'color': Color.fromARGB(255, 103, 58, 183),
      'text': 'Create Story',
    },
    {
      'icon': Icons.low_priority_outlined,
      'color': Color.fromARGB(255, 242, 94, 78),
      'text': 'Create News',
    },
    {
      'icon': Icons.production_quantity_limits_sharp,
      'color': Color.fromARGB(255, 43, 83, 164),
      'text': 'Create Product',
    },
    {
      'icon': Icons.flag,
      'color': Color.fromARGB(255, 33, 150, 243), 
      'text': 'Create Page',
    },
    {
      'icon': Icons.groups,
      'color': Color.fromARGB(255, 43, 83, 164),
      'text': 'Create Group',
    },
    {
      'icon': Icons.edit_calendar_rounded,
      'color': Color.fromARGB(255, 247, 159, 88),
      'text': 'Create Event',
    },
  ];
  var eventInfo = {};
  var privacy = 'public';
  var interest = 'none';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(privacy);
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Container(
          width: 160,
          color: Colors.white,
          // padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 300,
                //size: Size(100,100),
                child: ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  children: [
                    ListTile(
                      onTap: () {
                        sampleData[0]['event'];
                      },
                      hoverColor: Colors.grey[100],
                      tileColor: Colors.white,
                      enabled: true,
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(sampleData[0]['icon'],
                          color: sampleData[0]['color'],
                          size: 20,),
                          Column(children: [
                            const Padding(padding: EdgeInsets.only(top: 3)),
                            Text(sampleData[0]['text'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12)),
                          ],),
                          
                        ],
                      )
                    ),
                    const Divider(
                      height: 0,
                      thickness: 0,
                    ),
                    ListTile(
                      onTap: () {
                        sampleData[0]['event'];
                      },
                      hoverColor: Colors.grey[100],
                      tileColor: Colors.white,
                      enabled: true,
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(sampleData[1]['icon'],
                          color: sampleData[1]['color'],
                          size: 20,),
                          Column(children: [
                            const Padding(padding: EdgeInsets.only(top: 3)),
                            Text(sampleData[1]['text'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12)),
                          ],),
                          
                        ],
                      )
                    ),
                    const Divider(
                      height: 0,
                      thickness: 0,
                    ),
                    ListTile(
                      onTap: () {
                        sampleData[0]['event'];
                      },
                      hoverColor: Colors.grey[100],
                      tileColor: Colors.white,
                      enabled: true,
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(sampleData[2]['icon'],
                          color: sampleData[2]['color'],
                          size: 20,),
                          Column(children: [
                            const Padding(padding: EdgeInsets.only(top: 3)),
                            Text(sampleData[2]['text'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12)),
                          ],),
                          
                        ],
                      )
                    ),
                    const Divider(
                      height: 0,
                      thickness: 0,
                    ),
                    ListTile(
                      onTap: () {
                        sampleData[0]['event'];
                      },
                      hoverColor: Colors.grey[100],
                      tileColor: Colors.white,
                      enabled: true,
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(sampleData[3]['icon'],
                          color: sampleData[3]['color'],
                          size: 20,),
                          Column(children: [
                            const Padding(padding: EdgeInsets.only(top: 3)),
                            Text(sampleData[3]['text'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12)),
                          ],),
                          
                        ],
                      )
                    ),
                    const Divider(
                      height: 0,
                      thickness: 0,
                    ),
                    ListTile(
                      onTap: () {
                        sampleData[0]['event'];
                      },
                      hoverColor: Colors.grey[100],
                      tileColor: Colors.white,
                      enabled: true,
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(sampleData[4]['icon'],
                          color: sampleData[4]['color'],
                          size: 20,),
                          Column(children: [
                            const Padding(padding: EdgeInsets.only(top: 3)),
                            Text(sampleData[4]['text'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12)),
                          ],),
                          
                        ],
                      )
                    ),
                    const Divider(
                      height: 0,
                      thickness: 0,
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.of(context).pop(true);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              AlertDialog(
                                title: Row(children: const [
                                  Icon(Icons.event,color: Color.fromARGB(255, 247, 159, 88),),
                                  Text('Create New Event',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontStyle: FontStyle.italic
                                  ),),
                                ],),
                                content: CreateEventModal(context: context)
                              )
                        );},
                      hoverColor: Colors.grey[100],
                      tileColor: Colors.white,
                      enabled: true,
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(sampleData[5]['icon'],
                          color: sampleData[5]['color'],
                          size: 20,),
                          Column(children: [
                            const Padding(padding: EdgeInsets.only(top: 3)),
                            Text(sampleData[5]['text'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12)),
                          ],),
                          
                        ],
                      )
                    ),
                  ],
                      
                ),
              )
            ],
          )),
    );
  }
    
}