// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/widget/mprimary_button.dart';
import 'package:shnatter/src/widget/primaryInput.dart';

import '../../../controllers/PostController.dart';
import '../../../models/chatModel.dart';

class MyEvents extends StatefulWidget {
  MyEvents({Key? key})
      : con = PostController(),
        super(key: key);
  late PostController con;
  State createState() => MyEventsState();
}

class MyEventsState extends mvc.StateMVC<MyEvents> {
  late PostController con;
  var userInfo = UserManager.userInfo;
  var events = [];
  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    con.getEvent();
    setState(() {});
    super.initState();
  }

  // Stream<QuerySnapshot<ChatModel>> getLoginedUsers() {
  //   return transactionCollection
  //       .where('from-to', arrayContains: con.paymail)
  //       //.orderBy("date")
  //       .snapshots();
  // }
  @override
  Widget build(BuildContext context) {
    
    // events = con.getEvent({'':''}) as List;
    print(con.events);

    return Container(
      child: Stack(children: [
        Container(
          width: 200,
          margin: EdgeInsets.only(top: 60),
          padding: EdgeInsets.only(top: 70),
          decoration: BoxDecoration(
              color: Colors.grey[350],
              borderRadius: BorderRadius.circular(5),
          ),
          child: Column(children: [
            RichText(
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                  text: 'My Events',
                  style: const TextStyle(
                      color: Colors.black, fontSize: 13,
                      fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator
                        .pushReplacementNamed(
                            context,
                            RouteNames.events_manage);
                    }
                ),
              ]),
            ),
            Padding(padding: EdgeInsets.only(top: 5)),
            Text('1 Interested', style: TextStyle(
                      color: Colors.black, fontSize: 13),),
            Padding(padding: EdgeInsets.only(top: 20)),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                                2.0)),
                    minimumSize: const Size(120, 35),
                    maximumSize: const Size(120, 35)),
                onPressed: () {
                  () => {};
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.star,
                      color: Colors.black,
                      size: 18.0,
                    ),
                    Text('Interested',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                            fontWeight:
                                FontWeight.bold)),
                  ],
                )),
            Padding(padding: EdgeInsets.only(top: 30))
          ],),
        ),
        Container(
          width: 120,
          height: 120,
          padding: const EdgeInsets.all(2),
          margin: EdgeInsets.only(left: 40),
          decoration: BoxDecoration(
              color:
                  Color.fromARGB(255, 250, 250, 250),
              borderRadius: BorderRadius.circular(60),
              border: Border.all(color: Colors.grey)),
          child: SvgPicture.network(
              'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fprofile%2Fblank_profile_male.svg?alt=media&token=eaf0c1c7-5a30-4771-a7b8-9dc312eafe82'),
        ),
      ],),
    );
  }

}
