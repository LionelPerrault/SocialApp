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

class ProfileTimelineScreen extends StatefulWidget {
  Function onClick;
  ProfileTimelineScreen({Key? key,required this.onClick})
      : con = ProfileController(),
        super(key: key);
  final ProfileController con;

  @override
  State createState() => ProfileTimelineScreenState();
}

class ProfileTimelineScreenState extends mvc.StateMVC<ProfileTimelineScreen>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  bool showSearch = false;
  late FocusNode searchFocusNode;
  bool showMenu = false;
  late AnimationController _drawerSlideController;
  var url = window.location.href;
  var subUrl = '';
  double width = 0;
  double itemWidth = 0;
  //
  var userInfo = UserManager.userInfo;
  List<Map> mainInfoList = [];
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as ProfileController;
    mainInfoList = [
      {'title':'Add your profile picture','add': UserManager.userInfo['avatar'] ==null ? false : true},
      {'title':'Add your profile cover','add':con.profile_cover == '' ? false : true},
      {'title':'Add your biography','add':UserManager.userInfo['about'] == null ? false : true},
      {'title':'Add your birthdate','add':UserManager.userInfo['birthY'] == null ? false : true},
      {'title':'Add your relationship','add':UserManager.userInfo['school'] == null ? false : true},
      {'title':'Add your work info','add':UserManager.userInfo['workTitle'] == null ? false : true},
      {'title':'Add your location info','add':UserManager.userInfo['current'] == null ? false : true},
      {'title':'Add your education info','add':
        UserManager.userInfo['school'] == null && UserManager.userInfo['class'] == null && UserManager.userInfo['major'] == null ? false : true},
    ];
    _gotoHome();
  }
  late ProfileController con;
  void _gotoHome(){
    Future.delayed(Duration.zero, () {
      width = SizeConfig(context).screenWidth - 260;
      itemWidth = width/7.5;
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(right: 10,left: 70,top: 15),
            child:SizeConfig(context).screenWidth < 800 ? 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                profileCompletion(),
                MindPost()
            ]
              )
            : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Container(
                  height: (SizeConfig(context).screenHeight - SizeConfig.navbarHeight)/2,
                  padding: EdgeInsets.only(bottom: 90),
                  child: profileCompletion(),
                ),
                MindPost()
            ]),
        );
  }
  Widget profileCompletion(){
    return 
    Container(
      padding: EdgeInsets.only(left:15,right: 15,top: 15,),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child: 
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        // children: <Widget>[
        //     Text('\$', style: TextStyle(decoration: TextDecoration.lineThrough))
        children: mainInfoList.map((e) =>Container(
          padding: const EdgeInsets.only(top: 5),
          child:
          Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          Icon(e['add'] ? Icons.check : Icons.add,size:15),
          const Padding(padding: EdgeInsets.only(left: 5),),
          Text(e['title'],style: e['add'] ? const TextStyle(decoration: TextDecoration.lineThrough) : const TextStyle(),)  
        ],))).toList(),
        
    ));
  }
}
