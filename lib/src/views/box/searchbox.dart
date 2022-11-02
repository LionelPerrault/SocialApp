import 'dart:html';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/colors.dart';

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../controllers/HomeController.dart';

class ShnatterSearchBox extends StatefulWidget {
  ShnatterSearchBox({Key? key})
      : con = HomeController(),
        super(key: key);
  final HomeController con;

  @override
  State createState() => ShnatterSearchBoxState();
}

class ShnatterSearchBoxState extends mvc.StateMVC<ShnatterSearchBox> {
  //
  bool isSound = false;
  List<Map> sampleData = [
    {
      'avatarImg': '',
      'name': 'Adetola',
      'subname': 'now following you',
      'subsubtitle': '2 days ago',
      'icon': Icons.nature
    },
    {
      'avatarImg': '',
      'name': 'Adetola',
      'subname': 'now following you',
      'subsubtitle': '2 days ago',
      'icon': Icons.nature
    },
    {
      'avatarImg': '',
      'name': 'Adetola',
      'subname': 'now following you',
      'subsubtitle': '2 days ago',
      'icon': Icons.nature
    }
  ];
  @override
  void initState() {
    add(widget.con);
    con = controller as HomeController;
    super.initState();
  }

  late HomeController con;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Container(
          width: 400,
          color: Color.fromARGB(255, 255, 255, 255),
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Notifications",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Row(children: [
                    Text(
                      'Alert Sound',
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
                  //height: 20,
                  //thickness: 5,
                  //indent: 20,
                  //endIndent: 0,
                  //color: Colors.black,
                  ),
              SizedBox(
                height: 300,
                //size: Size(100,100),
                child: ListView.separated(
                  itemCount: sampleData.length,
                  itemBuilder: (context, index) => 
                  Material(
                  child:
                  ListTile(
                      onTap: () { print("tap!");},
                      hoverColor: Color.fromARGB(255, 243, 243, 243),
                      enabled: true,
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fblank_package.png?alt=media&token=f5cf4503-e36b-416a-8cce-079dfcaeae83"),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(sampleData[index]['name'],
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),
                          ),
                          Text(sampleData[index]['subname'],
                          style: TextStyle(fontWeight: FontWeight.normal,fontSize: 10)
                          ),
                          Text(sampleData[index]['subsubtitle'],
                          style: TextStyle(fontWeight: FontWeight.normal,fontSize: 8)
                          )
                        ],
                      ))),
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                ),
              )
            ],
          )),
    );
  }
}
