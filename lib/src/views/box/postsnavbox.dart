import 'package:flutter/material.dart';

import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/widget/createEventWidget.dart';
import 'package:shnatter/src/widget/createGroupWidget.dart';
import 'package:shnatter/src/widget/createProductWidget.dart';

class PostsNavBox extends StatefulWidget {
  PostsNavBox({Key? key, required this.routerChange, required this.hideNavBox})
      : super(key: key);
  Function routerChange;
  Function hideNavBox;
  @override
  State createState() => PostsNavBoxState();
}

class PostsNavBoxState extends State<PostsNavBox> {
  //
  late List<Map> eachList = [
    {
      'icon': Icons.person_add_sharp,
      'color': const Color.fromARGB(255, 43, 83, 164),
      'text': 'Add Friend',
      'onTap': (context) {
        widget.routerChange({
          'router': RouteNames.people,
        });
      },
    },
    {
      'icon': Icons.production_quantity_limits_sharp,
      'color': const Color.fromARGB(255, 43, 83, 164),
      'text': 'Create Product',
      'onTap': (context) {
        //Navigator.of(context).pop(true);
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => AlertDialog(
                title: const Row(
                  children: [
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
    {
      'icon': Icons.groups,
      'color': const Color.fromARGB(255, 43, 83, 164),
      'text': 'Create Group',
      'onTap': (context) {
        //Navigator.of(context).pop(true);
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => AlertDialog(
                title: const Row(
                  children: [
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
      'color': const Color.fromARGB(255, 247, 159, 88),
      'text': 'Create Event',
      'onTap': (context) {
        //Navigator.of(context).pop(true);
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Row(
              children: [
                Icon(
                  Icons.event,
                  color: Color.fromARGB(255, 247, 159, 88),
                ),
                Text(
                  'Create New Event',
                  style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                ),
              ],
            ),
            content: CreateEventModal(
              context: context,
              routerChange: widget.routerChange,
            ),
          ),
        );
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
    return Container(
        width: 160,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.white,
        ),
        child: Column(
          children: eachList
              .map((list) => PostButtonCell(nowContext, list['icon'],
                  list['color'], list['text'], list['onTap']))
              .toList(),
        ));
  }

  Widget PostButtonCell(nowContext, icon, iconColor, text, onTap) {
    return ListTile(
        onTap: () {
          widget.hideNavBox();
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
