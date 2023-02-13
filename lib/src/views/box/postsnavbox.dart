import 'package:flutter/material.dart';

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shnatter/src/widget/createEventWidget.dart';
import 'package:shnatter/src/widget/createGroupWidget.dart';
import 'package:shnatter/src/widget/createProductWidget.dart';

class PostsNavBox extends StatefulWidget {
  PostsNavBox({Key? key, required this.routerChange}) : super(key: key);
  Function routerChange;
  @override
  State createState() => PostsNavBoxState();
}

class PostsNavBoxState extends State<PostsNavBox> {
  //
  bool isSound = false;
  late List<Map> eachList = [
    // {
    //   'icon': Icons.photo_camera_back_outlined,
    //   'color': Color.fromARGB(255, 103, 58, 183),
    //   'text': 'Create Story',
    //   'onTap': (context) {
    //     //Navigator.of(context).pop(true);
    //     showDialog(
    //         context: context,
    //         builder: (BuildContext context) => AlertDialog(
    //             title: Row(
    //               children: const [
    //                 Icon(
    //                   Icons.event,
    //                   color: Color.fromARGB(255, 247, 159, 88),
    //                 ),
    //                 Text(
    //                   'Create New Event',
    //                   style:
    //                       TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
    //                 ),
    //               ],
    //             ),
    //             content: CreateEventModal(context: context)));
    //   },
    // },
    // {
    //   'icon': Icons.low_priority_outlined,
    //   'color': Color.fromARGB(255, 242, 94, 78),
    //   'text': 'Create News',
    //   'onTap': (context) {
    //     //Navigator.of(context).pop(true);
    //     showDialog(
    //         context: context,
    //         builder: (BuildContext context) => AlertDialog(
    //             title: Row(
    //               children: const [
    //                 Icon(
    //                   Icons.event,
    //                   color: Color.fromARGB(255, 247, 159, 88),
    //                 ),
    //                 Text(
    //                   'Create New Event',
    //                   style:
    //                       TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
    //                 ),
    //               ],
    //             ),
    //             content: CreateEventModal(context: context)));
    //   },
    // },
    {
      'icon': Icons.person_add_sharp,
      'color': Color.fromARGB(255, 43, 83, 164),
      'text': 'Add Friend',
      'onTap': (context) {},
    },
    {
      'icon': Icons.production_quantity_limits_sharp,
      'color': Color.fromARGB(255, 43, 83, 164),
      'text': 'Create Product',
      'onTap': (context) {
        //Navigator.of(context).pop(true);
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                title: Row(
                  children: const [
                    Icon(
                      Icons.shopping_bag,
                      color: Color.fromARGB(255, 43, 83, 164),
                    ),
                    Text(
                      'Create New Product',
                      style:
                          TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
                content: CreateProductModal(
                  context: context,
                  routerChange: widget.routerChange,
                )));
      },
    },
    // {
    //   'icon': Icons.flag,
    //   'color': Color.fromARGB(255, 33, 150, 243),
    //   'text': 'Create Page',
    //   'onTap': (context) {
    //     //Navigator.of(context).pop(true);
    //     showDialog(
    //         context: context,
    //         builder: (BuildContext context) => AlertDialog(
    //             title: Row(
    //               children: const [
    //                 Icon(
    //                   Icons.flag,
    //                   color: Color.fromARGB(255, 33, 150, 243),
    //                 ),
    //                 Text(
    //                   'Create New Event',
    //                   style:
    //                       TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
    //                 ),
    //               ],
    //             ),
    //             content: CreatePageModal(context: context)));
    //   },
    // },
    {
      'icon': Icons.groups,
      'color': Color.fromARGB(255, 43, 83, 164),
      'text': 'Create Group',
      'onTap': (context) {
        //Navigator.of(context).pop(true);
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                title: Row(
                  children: const [
                    Icon(
                      Icons.groups,
                      color: Color.fromARGB(255, 43, 83, 164),
                    ),
                    Text(
                      'Create New Group',
                      style:
                          TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
                content: CreateGroupModal(
                  context: context,
                  routerChange: widget.routerChange,
                )));
      },
    },
    {
      'icon': Icons.edit_calendar_rounded,
      'color': Color.fromARGB(255, 247, 159, 88),
      'text': 'Create Event',
      'onTap': (context) {
        //Navigator.of(context).pop(true);
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                title: Row(
                  children: const [
                    Icon(
                      Icons.event,
                      color: Color.fromARGB(255, 247, 159, 88),
                    ),
                    Text(
                      'Create New Event',
                      style:
                          TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
                content: CreateEventModal(
                  context: context,
                  routerChange: widget.routerChange,
                )));
      },
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
  Widget build(BuildContext nowContext) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Container(
          width: 160,
          color: Colors.white,
          // padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 200,
                //size: Size(100,100),
                child: ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  children: eachList
                      .map((list) => PostButtonCell(nowContext, list['icon'],
                          list['color'], list['text'], list['onTap']))
                      .toList(),
                ),
              )
            ],
          )),
    );
  }

  Widget PostButtonCell(nowContext, icon, iconColor, text, onTap) {
    return ListTile(
        onTap: () {
          onTap(nowContext);
        },
        hoverColor: Colors.grey[100],
        tileColor: Colors.white,
        enabled: true,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
            Column(
              children: [
                const Padding(padding: EdgeInsets.only(top: 3)),
                Text(text,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 12)),
              ],
            ),
          ],
        ));
  }
}
