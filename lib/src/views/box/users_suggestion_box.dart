// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PeopleController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/colors.dart';

import 'package:shnatter/src/utils/size_config.dart';

class ShnatterUserSuggest extends StatefulWidget {
  ShnatterUserSuggest({Key? key, required this.routerChange}) : super(key: key);
  Function routerChange;

  @override
  State createState() => ShnatterUserSuggestState();
}

class ShnatterUserSuggestState extends mvc.StateMVC<ShnatterUserSuggest> {
  //
  bool isSound = true;
  var con = PeopleController();
  var isFirst = false;
  @override
  void initState() {
    super.initState();

    print("call======================================== suggest");
    con.getUserList();
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
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Friend Suggestions",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 45.0),
                  ),
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
              AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  height: isSound
                      ? (con.userList.length < 5 ? con.userList.length : 5) * 60
                      : 0,
                  curve: Curves.fastOutSlowIn,
                  child: SizedBox(
                    //size: Size(100,100),
                    child: ListView.separated(
                      itemCount:
                          con.userList.length < 5 ? con.userList.length : 5,
                      itemBuilder: (context, index) {
                        var item = con.userList[index];
                        var itemData = item as Map;
                        return Material(
                            child: ListTile(
                          contentPadding:
                              const EdgeInsets.only(left: 10, right: 10),
                          leading: itemData['avatar'] == ''
                              ? CircleAvatar(
                                  radius: 17,
                                  child: SvgPicture.network(Helper.avatar))
                              : CircleAvatar(
                                  radius: 17,
                                  backgroundImage:
                                      NetworkImage(itemData['avatar'])),
                          title: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 11),
                              children: <TextSpan>[
                                TextSpan(
                                    text:
                                        '${itemData['firstName']} ${itemData['lastName']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                        color: Colors.black),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        widget.routerChange({
                                          'router': RouteNames.profile,
                                          'subRouter': itemData['userName']
                                        });
                                      })
                              ],
                            ),
                          ),
                          trailing: ElevatedButton(
                              onPressed: () async {
                                if (!itemData.containsKey('state')) {
                                  itemData['state'] = -1;
                                  setState(() {});
                                  await con.requestFriend(item);
                                  setState(() {});
                                } else {
                                  var status = itemData['state'];
                                  if (status == 0) {
                                    itemData['state'] = -1;
                                    setState(() {});
                                    await con.cancelFriend(item);
                                    setState(() {});
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 33, 37, 41),
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2.0)),
                                  minimumSize: itemData.containsKey('state') &&
                                          itemData['state'] == -1
                                      ? const Size(60, 35)
                                      : const Size(80, 35),
                                  maximumSize: itemData.containsKey('state') &&
                                          itemData['state'] == -1
                                      ? const Size(60, 35)
                                      : const Size(80, 35)),
                              child: itemData.containsKey('state') &&
                                      itemData['state'] == -1
                                  ? const SizedBox(
                                      width: 10,
                                      height: 10,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : itemData.containsKey('state') &&
                                          itemData['state'] == 0
                                      ? Row(
                                          children: const [
                                            Icon(
                                              FontAwesomeIcons.clock,
                                              color: Colors.white,
                                              size: 13,
                                            ),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(left: 2)),
                                            Text(' Sent',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.w900)),
                                          ],
                                        )
                                      : Row(
                                          children: const [
                                            Icon(
                                              Icons.person_add_alt_rounded,
                                              color: Colors.white,
                                              size: 18.0,
                                            ),
                                            Text(' Add',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.w900)),
                                          ],
                                        )),
                        ));
                      },
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
