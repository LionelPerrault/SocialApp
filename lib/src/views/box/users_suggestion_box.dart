// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    con.getUserList();
    Future.delayed(const Duration(microseconds: 0), () async {
      await con.getUserList(isGetOnly5: true);
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
                  height: isSound ? con.userList.length * 60 : 0,
                  curve: Curves.fastOutSlowIn,
                  child: SizedBox(
                    //size: Size(100,100),
                    child: ListView.separated(
                      itemCount: con.userList.length,
                      itemBuilder: (context, index) => Material(
                          child: ListTile(
                        contentPadding:
                            const EdgeInsets.only(left: 10, right: 10),
                        leading: con.userList[index]['avatar'] == ''
                            ? CircleAvatar(
                                radius: 17,
                                child: SvgPicture.network(Helper.avatar))
                            : CircleAvatar(
                                radius: 17,
                                backgroundImage: NetworkImage(
                                    con.userList[index]['avatar'])),
                        title: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 11),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      '${con.userList[index]['firstName']} ${con.userList[index]['lastName']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                      color: Colors.black),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      widget.routerChange({
                                        'router': RouteNames.profile,
                                        'subRouter': con.userList[index]
                                            ['userName']
                                      });
                                    })
                            ],
                          ),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () async {
                            // print(con.isFriendRequest);

                            setState(() {});
                            if (con.isFriendRequest[index] == false) {
                              con.isFriendRequest[index] = null;
                              await con.cancelFriend(
                                  con.userList[index]['userName']);
                            } else {
                              con.isFriendRequest[index] = true;
                              await con.requestFriend(
                                  con.userList[index]['userName'],
                                  '${con.userList[index]['firstName']} ${con.userList[index]['lastName']}',
                                  con.userList[index]['avatar'],
                                  1);
                              con.isFriendRequest[index] = false;
                            }
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 33, 37, 41),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2.0)),
                              minimumSize: con.isFriendRequest[index] != null &&
                                      con.isFriendRequest[index]
                                  ? const Size(60, 35)
                                  : const Size(80, 35),
                              maximumSize: con.isFriendRequest[index] != null &&
                                      con.isFriendRequest[index]
                                  ? const Size(60, 35)
                                  : const Size(80, 35)),
                          child: con.isFriendRequest[index] == null
                              ? Row(
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
                                            fontWeight: FontWeight.w900)),
                                  ],
                                )
                              : con.isFriendRequest[index]
                                  ? const SizedBox(
                                      width: 10,
                                      height: 10,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : Row(
                                      children: const [
                                        Icon(
                                          Icons.timelapse,
                                          color: Colors.white,
                                          size: 18.0,
                                        ),
                                        Text(' Sent',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w900)),
                                      ],
                                    ),
                        ),
                      )),
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
