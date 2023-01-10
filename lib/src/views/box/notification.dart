import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/utils/colors.dart';

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
  late PostController con;
  var notifications = [];
  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    super.initState();
    final Stream<QuerySnapshot> stream = con.streamPosts();
    stream.listen((event) {
      notifications = event.docs;
      setState(() {});
    });
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
                  itemCount: sampleData.length,
                  itemBuilder: (context, index) => Material(
                      child: ListTile(
                          onTap: () {
                            print("tap!");
                          },
                          hoverColor: const Color.fromARGB(255, 243, 243, 243),
                          enabled: true,
                          leading: const CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fblank_package.png?alt=media&token=f5cf4503-e36b-416a-8cce-079dfcaeae83"),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sampleData[index]['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                              Text(sampleData[index]['subname'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 10)),
                              Text(sampleData[index]['subsubtitle'],
                                  style: const TextStyle(
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
