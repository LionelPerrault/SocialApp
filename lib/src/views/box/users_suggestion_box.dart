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

import '../../controllers/HomeController.dart';

class ShnatterUserSuggest extends StatefulWidget {
  ShnatterUserSuggest({Key? key})
      : con = HomeController(),
        super(key: key);
  final HomeController con;

  @override
  State createState() => ShnatterUserSuggestState();
}

class ShnatterUserSuggestState extends mvc.StateMVC<ShnatterUserSuggest> {
  //
  bool isSound = false;
  List<Map> sampleData = [
    {
      'avatarImg': '',
      'name': 'Adetola',
      'icon': Icons.nature
    },
    {
      'avatarImg': '',
      'name': 'Adetola',
      'icon': Icons.nature
    },
    {
      'avatarImg': '',
      'name': 'Adetola',
      'icon': Icons.nature
    },
    {
      'avatarImg': '',
      'name': 'Adetola',
      'icon': Icons.nature
    },
    {
      'avatarImg': '',
      'name': 'Adetola',
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
          width: SizeConfig.rightPaneWidth,
          // color: Colors.white,
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Friend Suggestions",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 45.0),),
                  Row(children: [
                    const Text(
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
              SizedBox(
                height: 260,
                //size: Size(100,100),
                child: ListView.separated(
                  itemCount: sampleData.length,
                  itemBuilder: (context, index) => 
                  Material(
                  child:
                  ListTile(
                      onTap: () { print("tap!");},
                      hoverColor: const Color.fromARGB(255, 243, 243, 243),
                      // tileColor: Colors.white,
                      enabled: true,
                      leading: const CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://test.shnatter.com/content/themes/default/images/blank_profile_male.svg"),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 100,
                                child: Text(sampleData[index]['name'],
                                    style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
                                ),
                              ),
                              Container(
                                child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(255, 33, 37, 41),
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(2.0)),
                                        minimumSize: const Size(70, 35),
                                        maximumSize: const Size(70, 35)
                                      ),
                                      onPressed: () { ()=>{}; },
                                      child: 
                                      Row(children: const [
                                        Icon(Icons.person_add_alt_rounded,
                                            color: Colors.white,
                                            size: 18.0,
                                        ),
                                        Text('Add',
                                          style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold)),
                                      ],)
                                    )
                              ),
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
            ],
          )),
    );
  }
}
