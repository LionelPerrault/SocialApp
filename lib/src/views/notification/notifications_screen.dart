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
import 'package:shnatter/src/utils/size_config.dart';

// ignore: must_be_immutable
class NotificationsScreen extends StatefulWidget {
  NotificationsScreen({Key? key})
      : con = PostController(),
        super(key: key);
  late PostController con;
  @override
  State createState() => NotificationsScreenState();
}

class NotificationsScreenState extends mvc.StateMVC<NotificationsScreen> {
  //

  late PostController postCon;
  var notifications = [];
  bool isLoaded = false;
  @override
  void initState() {
    add(widget.con);
    postCon = controller as PostController;
    postCon.checkNotify();
    getAllNotifications();
    super.initState();
  }

  Future<void> getAllNotifications() async {
    if (!mounted) return;
    dynamic snapshot = await FirebaseFirestore.instance
        .collection(Helper.notificationField)
        .get();
    var allNotifi = snapshot.docs;
    var notifyData = null;
    for (var i = 0; i < allNotifi.length; i++) {
      notifyData = allNotifi[i].data();
      var adminUid = notifyData['postAdminId'];
      var postType = notifyData['postType'];

      var addData = {};
      if (adminUid != UserManager.userInfo['uid'] &&
          postType != 'requestFriend') {
        dynamic userV = await FirebaseFirestore.instance
            .collection(Helper.userField)
            .doc(notifyData['postAdminId'])
            .get();
        dynamic data = userV.data();
        var type = notifyData['postType'];
        var text = Helper.notificationText[type.toString()]['text'];
        var date = await postCon.formatDate(notifyData['timeStamp']);
        if (data != null) {
          addData = {
            'avatar': data['avatar'],
            'userName': userV.data()!['userName'],
            'text': text,
            'date': date,
          };
          notifications.add(addData);
        }
      }
      if (postType == 'requestFriend' &&
          adminUid == UserManager.userInfo['uid']) {
        dynamic userV = await FirebaseFirestore.instance
            .collection(Helper.userField)
            .doc(notifyData['postAdminId'])
            .get();
        dynamic data = userV.data();
        var type = notifyData['postType'];
        var text = Helper.notificationText[type.toString()]['text'];
        if (data != null) {
          addData = {
            // ...notifyData,
            'avatar': Helper.systemAvatar,
            'userName': Helper.notificationName[notifyData['postType']]['name'],
            'text': text,
          };
          notifications.add(addData);
        }
      }
    }
    isLoaded = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: isLoaded
          ? Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: SizeConfig(context).screenHeight - 100,
                  //size: Size(100,100),
                  child: notifications.isEmpty
                      ? const Center(child: Text("No notifications."))
                      : ListView.separated(
                          itemCount: notifications.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) => Material(
                            child: ListTile(
                              hoverColor:
                                  const Color.fromARGB(255, 243, 243, 243),
                              enabled: true,
                              leading: notifications[index]['avatar'] != ''
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                      notifications[index]['avatar'],
                                    ))
                                  : notifications[index]['userName'] ==
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
                                    notifications[index]['userName'] ?? "",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10),
                                  ),
                                  Text(notifications[index]['text'] ?? "",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 10)),
                                  Text(
                                    notifications[index]['date'] ?? "",
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
              ],
            )
          : SizedBox(
              height: SizeConfig(context).screenHeight - 100,
              child: Center(child: CircularProgressIndicator())),
    );
  }
}
