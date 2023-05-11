import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/helpers/helper.dart';

// ignore: must_be_immutable
class ShnatterNotification extends StatefulWidget {
  ShnatterNotification({
    Key? key,
    required this.hideMenu,
    required this.routerChange,
  })  : con = PostController(),
        super(key: key);
  late PostController con;
  Function hideMenu;
  Function routerChange;

  @override
  State createState() => ShnatterNotificationState();
}

class ShnatterNotificationState extends mvc.StateMVC<ShnatterNotification> {
  //
  bool isSound = false;

  late PostController postCon;
  @override
  void initState() {
    add(widget.con);
    postCon = controller as PostController;
    super.initState();
    checkNotify();
  }

  Future<void> checkNotify() async {
    // postCon.realNotifi = [];
    // postCon.setState(() {});
    await postCon.checkNotify();
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
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () {
                        postCon.clearAllNotify(
                          postCon.allNotification,
                          UserManager.userInfo['uid'],
                        );
                      },
                      child: const Text('Clear All'),
                    ),
                  )
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
                              if (postCon.allNotification[index]['redirect'] !=
                                  null) {
                                widget.routerChange(
                                    postCon.allNotification[index]['redirect']);
                                widget.hideMenu();
                              }
                              await postCon.checkNotification(
                                postCon.allNotification[index]['uid'],
                                UserManager.userInfo['uid'],
                              );
                              await postCon.allNotification.removeAt(index);
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      color: const Color.fromARGB(255, 130, 163, 255),
                      alignment: Alignment.center,
                      child: TextButton(
                          style: TextButton.styleFrom(
                              fixedSize: const Size(400, 11)),
                          child: const Text('See All',
                              style: TextStyle(fontSize: 11)),
                          onPressed: () async {
                            widget.routerChange({
                              'router': RouteNames.notifications,
                            });
                            widget.hideMenu();
                          }),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
