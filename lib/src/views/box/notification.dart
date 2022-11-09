import 'dart:html';

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

import '../../controllers/UserController.dart';

class ShnatterNotification extends StatefulWidget {
  ShnatterNotification({Key? key}) : super(key: key);

  @override
  State createState() => ShnatterNotificationState();
}

class ShnatterNotificationState extends mvc.StateMVC<ShnatterNotification> {
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
    super.initState();
  }

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
              SizedBox(
                height: 5,
              ),
              const Divider(
                height: 1,
                endIndent: 10,
              ),
              SizedBox(
                height: 300,
                //size: Size(100,100),
                child: ListView.separated(
                  itemCount: sampleData.length,
                  itemBuilder: (context, index) => Material(
                      child: ListTile(
                          onTap: () {
                            print("tap!");
                          },
                          hoverColor: Color.fromARGB(255, 243, 243, 243),
                          enabled: true,
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fblank_package.png?alt=media&token=f5cf4503-e36b-416a-8cce-079dfcaeae83"),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sampleData[index]['name'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                              Text(sampleData[index]['subname'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 10)),
                              Text(sampleData[index]['subsubtitle'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 8))
                            ],
                          ))),
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                    height: 1,
                    endIndent: 10,
                  ),
                ),
              ),
              Container(
              height: 22,
              color: Colors.grey[400],
              alignment: Alignment.center,
              child: Flexible(
                      child: RichText(
                        text: TextSpan(
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'See All',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10),
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () {
                                          ()=>{};
                                        }),
                            ]),
                      ),
                    )
              )
            ],
          )),
    );
  }
}
