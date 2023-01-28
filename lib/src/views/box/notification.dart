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
class ShnatterNotification extends StatefulWidget {
  ShnatterNotification({Key? key})
      : con = PostController(),
        super(key: key);
  late PostController con;
  @override
  State createState() => ShnatterNotificationState();
}

class ShnatterNotificationState extends mvc.StateMVC<ShnatterNotification> {
  //
  bool isSound = false;

  late PostController postCon;
  var realNotification = [];
  var userCheckTime = 0;

  @override
  void initState() {
    add(widget.con);
    postCon = controller as PostController;
    userCheckTime = DateTime.now().millisecondsSinceEpoch;
    postCon.checkNotify(userCheckTime);
    final Stream<QuerySnapshot> stream = Helper.notifiCollection.snapshots();
    stream.listen((event) async {
      print('notification Stream');
      var notiSnap = await Helper.notifiCollection.orderBy('tsNT').get();
      var allNotifi = notiSnap.docs;
      var userSnap = await FirebaseFirestore.instance
          .collection(Helper.userField)
          .doc(UserManager.userInfo['uid'])
          .get();
      // ignore: unused_local_variable
      var userInfo = userSnap.data();
      var changeData = [];
      for (var i = 0; i < allNotifi.length; i++) {
        var adminUid = allNotifi[i]['postAdminId'];
        var postType = allNotifi[i]['postType'];
        var viewFlag = true;

        for (var j = 0; j < allNotifi[i]['userList'].length; j++) {
          if (allNotifi[i]['userList'][j] == UserManager.userInfo['uid']) {
            viewFlag = false;
          }
        }
        postCon.allNotification = [];
        var notifyTime =
            DateTime.parse(allNotifi[i]['timeStamp'].toDate().toString());
        print('notify time is ${typeOf()}');
        var formattedNotifyTime =
            DateFormat('yyyy-MM-dd kk:mm:ss.SSS').format(notifyTime).toString();
        print('formatted notify time is ${typeOf()}');
        print('notifications formatted notify time:$formattedNotifyTime');
        if (viewFlag) {
          var addData;
          if (adminUid != UserManager.userInfo['uid']) {
            await FirebaseFirestore.instance
                .collection(Helper.userField)
                .doc(allNotifi[i]['postAdminId'])
                .get()
                .then((userV) => {
                      addData = {
                        ...allNotifi[i].data(),
                        'uid': allNotifi[i].id,
                        'avatar': userV.data()!['avatar'],
                        'userName': userV.data()!['userName'],
                        'text': Helper
                            .notificationText[allNotifi[i]['postType']]['text'],
                        'date': 'Helper.formatDate(formattedNotifyTime)',
                      },
                      changeData.add(addData),
                    });
          }
          if (postType == 'requestFriend' &&
              adminUid == UserManager.userInfo['uid']) {
            print('here is requestFriend');
            await FirebaseFirestore.instance
                .collection(Helper.userField)
                .doc(allNotifi[i]['postAdminId'])
                .get()
                .then((userV) => {
                      addData = {
                        // ...allNotifi[i],
                        'uid': allNotifi[i].id,
                        'avatar': '',
                        'userName': Helper
                            .notificationName[allNotifi[i]['postType']]['name'],
                        'text': Helper
                            .notificationText[allNotifi[i]['postType']]['text'],
                        'date': 'Helper.formatDate(formattedNotifyTime)',
                      },
                      changeData.add(addData),
                    });
          }
        }
      }
      postCon.allNotification = changeData;
      setState(() {});
    });
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
                height: 300,
                //size: Size(100,100),
                child: ListView.separated(
                  itemCount: postCon.allNotification.length,
                  itemBuilder: (context, index) => Material(
                    child: ListTile(
                      onTap: () {
                        postCon.checkNotification(
                            postCon.allNotification[index]['uid'],
                            UserManager.userInfo['uid']);
                      },
                      hoverColor: const Color.fromARGB(255, 243, 243, 243),
                      enabled: true,
                      leading: postCon.allNotification[index]['avatar'] != ''
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(
                              postCon.allNotification[index]['avatar'],
                            ))
                          : postCon.allNotification[index]['userName'] ==
                                  'System Message'
                              ? CircleAvatar(
                                  child:
                                      SvgPicture.network(Helper.systemAvatar),
                                )
                              : CircleAvatar(
                                  child: SvgPicture.network(Helper.avatar),
                                ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            postCon.allNotification[index]['userName'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                          Text(postCon.allNotification[index]['text'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 10)),
                          Text(
                            postCon.allNotification[index]['date'],
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 8),
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
              Container(
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          child: const Text('Show All',
                              style: TextStyle(fontSize: 11)),
                          onPressed: () {}),
                    ],
                  ))
            ],
          )),
    );
  }
}
