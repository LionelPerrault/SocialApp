import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/helpers/helper.dart';

// ignore: must_be_immutable
class NotificationsPage extends StatefulWidget {
  NotificationsPage({Key? key})
      : con = PostController(),
        super(key: key);
  late PostController con;
  @override
  State createState() => NotificationsPageState();
}

class NotificationsPageState extends mvc.StateMVC<NotificationsPage> {
  //
  bool isSound = false;

  late PostController postCon;
  @override
  void initState() {
    add(widget.con);
    postCon = controller as PostController;
    postCon.checkNotify();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Container(
          width: 400,
          color: const Color.fromARGB(255, 255, 255, 255),
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Notifications",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )),
                  Row(children: [
                    const Text(
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
              const SizedBox(
                height: 5,
              ),
              const Divider(
                height: 1,
                endIndent: 10,
              ),
              SizedBox(
                height: postCon.allNotification.isEmpty ? 100 : 300,
                //size: Size(100,100),
                child: postCon.allNotification.isEmpty
                    ? const Center(child: Text("No new notifications."))
                    : ListView.separated(
                        itemCount: postCon.allNotification.length,
                        itemBuilder: (context, index) => Material(
                          child: ListTile(
                            onTap: () async {
                              await postCon.checkNotification(
                                  postCon.allNotification[index]['uid'],
                                  UserManager.userInfo['uid']);
                              setState(() {});
                            },
                            hoverColor:
                                const Color.fromARGB(255, 243, 243, 243),
                            enabled: true,
                            leading: postCon.allNotification[index]['avatar'] !=
                                    ''
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(
                                    postCon.allNotification[index]['avatar'],
                                  ))
                                : postCon.allNotification[index]['userName'] ==
                                        'System Message'
                                    ? CircleAvatar(
                                        child: SvgPicture.network(
                                            Helper.systemAvatar),
                                      )
                                    : CircleAvatar(
                                        child:
                                            SvgPicture.network(Helper.avatar),
                                      ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  postCon.allNotification[index]['userName'] ??
                                      "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                ),
                                Text(
                                    postCon.allNotification[index]['text'] ??
                                        "",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 10)),
                                Text(
                                  postCon.allNotification[index]['date'] ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 8),
                                ),
                              ],
                            ),
                          ),
                        ),
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
                          height: 1,
                          endIndent: 10,
                        ),
                      ),
              ),
              const Divider(height: 1, indent: 0),
              if (postCon.allNotification.isNotEmpty)
                Container(
                    color: const Color.fromARGB(255, 130, 163, 255),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            child: const Text('All Read',
                                style: TextStyle(fontSize: 11)),
                            onPressed: () async {
                              await postCon.checkNotify();
                              postCon.allNotification = [];
                              postCon.realNotifi = [];
                              print("removed realNotifi empty in noti page");
                              postCon.setState(() {});
                            }),
                      ],
                    ))
            ],
          )),
    );
  }
}
