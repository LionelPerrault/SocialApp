import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

class ShnatterPageSuggest extends StatefulWidget {
  ShnatterPageSuggest({Key? key, required this.routerChange}) : super(key: key);
  Function routerChange;
  @override
  State createState() => ShnatterPageSuggestState();
}

class ShnatterPageSuggestState extends mvc.StateMVC<ShnatterPageSuggest> {
  //
  bool isSound = true;
  var isLiked = {};
  List<Map> sampleData = [
    {
      'avatarImg': '',
      'name': 'Adetola',
      'subname': '1 Likes',
      'icon': Icons.nature
    },
    {
      'avatarImg': '',
      'name': 'Adetola',
      'subname': '1 Likes',
      'icon': Icons.nature
    },
    {
      'avatarImg': '',
      'name': 'Adetola',
      'subname': '1 Likes',
      'icon': Icons.nature
    },
    {
      'avatarImg': '',
      'name': 'Adetola',
      'subname': '1 Likes',
      'icon': Icons.nature
    },
    {
      'avatarImg': '',
      'name': 'Adetola',
      'subname': '1 Likes',
      'icon': Icons.nature
    }
  ];
  var con = PostController();
  var userInfo = UserManager.userInfo;
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 0), () async {
      con.unlikedPages = await con.getPage('unliked', userInfo['uid']);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Container(
          width: SizeConfig(context).screenWidth < 600
              ? SizeConfig(context).screenWidth
              : 600,
          // width: SizeConfig.rightPaneWidth,
          // color: Colors.white,
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Suggested Pages",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  // const Padding(
                  //   padding: EdgeInsets.only(top: 45.0),
                  // ),
                  Row(
                    children: [
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
                    ],
                  )
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
                    height: 260,
                    //size: Size(100,100),
                    child: ListView.separated(
                      itemCount: con.unlikedPages.length,
                      itemBuilder: (context, index) => Material(
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.only(left: 10, right: 10),
                          leading: Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: CircleAvatar(
                                  radius: 17,
                                  backgroundImage: NetworkImage(
                                      con.unlikedPages[index]['data']
                                                  ['pagePicture'] ==
                                              ''
                                          ? Helper.blankPage
                                          : con.unlikedPages[index]['data']
                                              ['pagePicture']))),
                          title: Padding(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Text(
                                con.unlikedPages[index]['data']['pageName'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 11),
                              )),
                          subtitle: Padding(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Text(
                                '${con.unlikedPages[index]['data']['pageLiked'].length} Likes',
                                style: TextStyle(fontSize: 10),
                              )),
                          trailing: ElevatedButton(
                              onPressed: () async {
                                isLiked[index] = true;
                                setState(() {});
                                con
                                    .likedPage(con.unlikedPages[index]['id'])
                                    .then((value) async {
                                  con.unlikedPages = await con.getPage(
                                      'unliked', userInfo['uid']);
                                  isLiked[index] = false;
                                  setState(() {});
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2.0)),
                                  minimumSize:
                                      isLiked[index] != null && isLiked[index]
                                          ? const Size(60, 35)
                                          : const Size(80, 35),
                                  maximumSize:
                                      isLiked[index] != null && isLiked[index]
                                          ? const Size(60, 35)
                                          : const Size(80, 35)),
                              child: isLiked[index] != null && isLiked[index]
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
                                          Icons.thumb_up,
                                          color: Colors.black,
                                          size: 18.0,
                                        ),
                                        Text(' Like',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w900)),
                                      ],
                                    )),
                        ),
                      ),
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
