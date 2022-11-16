import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/views/box/searchbox.dart';
import 'package:shnatter/src/views/chat/chatScreen.dart';
import 'package:shnatter/src/views/navigationbar.dart';
import '../../controllers/HomeController.dart';
import '../../utils/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileInfoScreen extends StatefulWidget {
  ProfileInfoScreen({Key? key})
      : con = HomeController(),
        super(key: key);
  final HomeController con;

  @override
  State createState() => ProfileInfoScreenState();
}

class ProfileInfoScreenState extends mvc.StateMVC<ProfileInfoScreen>
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
  List<Map> mainTabList = [
    {'title':'Add your profile picture','add': UserManager.userInfo['avatar'] ==null ? false : true},
    {'title':'Add your profile cover','add':UserManager.userInfo['profile_cover'] == null ? false : true},
    {'title':'Add your biography','add':UserManager.userInfo['about'] == null ? false : true},
    {'title':'Add your birthdate','add':UserManager.userInfo['birthY'] == null ? false : true},
    {'title':'Add your relationship','add':Icons.flag},
    {'title':'Add your work info','add':UserManager.userInfo['school'] == null ? false : true},
    {'title':'Add your location info','add':UserManager.userInfo['current'] == null ? false : true},
    {'title':'Add your education info','add':
      UserManager.userInfo['school'] == null && UserManager.userInfo['class'] == null && UserManager.userInfo['major'] == null ? false : true},
  ];
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as HomeController;
    _gotoHome();
  }
  late HomeController con;
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
            width: SizeConfig(context).screenWidth,
            padding: const EdgeInsets.only(left: 60, right: 10),
            child: Row(
              children: [
              Container(
              margin:EdgeInsets.only(left: 70),
                width: SizeConfig(context).screenWidth*0.2,
                child: profileCompletion(),
              )
            ])
          );
  }
  Widget profileCompletion(){
    return Row(
    children: <Widget>[
        Text('\$8.99', style: TextStyle(decoration: TextDecoration.lineThrough))

    ]
);
  }
  Widget mainTabWidget(){
    return Container(
      width: width,
      margin: const EdgeInsets.only(top: 15),
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
      ),
      child:Row(children: mainTabList.map((e) => Container(
        width: itemWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(e['icon'],size: 15,color: Color.fromRGBO(76, 76, 76, 1),),
            Padding(padding:EdgeInsets.only(left:5)),
            Text(e['title'],style:TextStyle(
              fontSize:13,
              color: Color.fromRGBO(76, 76, 76, 1),
              fontWeight: FontWeight.bold
            ))
        ]),
      )).toList()),
    );
  }
}
