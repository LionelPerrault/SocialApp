import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/views/box/mindpost.dart';
import 'package:shnatter/src/views/box/searchbox.dart';
import 'package:shnatter/src/views/chat/chatScreen.dart';
import 'package:shnatter/src/views/navigationbar.dart';
import '../../controllers/HomeController.dart';
import '../../utils/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../controllers/ProfileController.dart';

class ProfileVideosScreen extends StatefulWidget {
  Function onClick;
  ProfileVideosScreen({Key? key, required this.onClick})
      : con = ProfileController(),
        super(key: key);
  final ProfileController con;
  @override
  State createState() => ProfileVideosScreenState();
}

class ProfileVideosScreenState extends mvc.StateMVC<ProfileVideosScreen>{
  var userInfo = UserManager.userInfo;
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as ProfileController;
  }
  late ProfileController con;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      mainTabs(),
      videosData()
    ]);
  }
  Widget mainTabs(){
    return Container(
          width: SizeConfig(context).screenWidth ,
          height: 100,
          margin: const EdgeInsets.only(left: 30,right: 30),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(240, 240, 240, 1),
            borderRadius: BorderRadius.circular(3),
          ),
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left:20,top: 20),
                child: Row(children: const [
                  Icon(Icons.video_call,size: 15,),
                  Padding(padding: EdgeInsets.only(left: 5)),
                  Text('Videos',style: TextStyle(
                    fontSize: 15
                  ),)
                ],)
              ),
            ],
          ),
      );
  }
  Widget videosData(){
    return userInfo['videos'] == null ? Container(
      margin: const EdgeInsets.only(left: 30, right: 30),
      height: SizeConfig(context).screenHeight * 0.2,
      color: Colors.white,
      alignment: Alignment.center,
      child: Text('${userInfo['fullName']} doesn`t have videos',style:const TextStyle(
        color: Color.fromRGBO(108, 117, 125, 1)
      )),
    ) : Container();
  }
}
