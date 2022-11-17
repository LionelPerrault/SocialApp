import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/views/box/searchbox.dart';
import 'package:shnatter/src/views/chat/chatScreen.dart';
import 'package:shnatter/src/views/navigationbar.dart';
import '../../controllers/HomeController.dart';
import '../../utils/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileAvatarandTabScreen extends StatefulWidget {
  Function onClick;
  ProfileAvatarandTabScreen({Key? key,required this.onClick})
      : con = ProfileController(),
        super(key: key);
  final ProfileController con;
  @override
  State createState() => ProfileAvatarandTabScreenState();
}

class ProfileAvatarandTabScreenState extends mvc.StateMVC<ProfileAvatarandTabScreen>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  bool showSearch = false;
  late FocusNode searchFocusNode;
  bool showMenu = false;
  late AnimationController _drawerSlideController;
  ScrollController _scrollController = ScrollController();
  double width = 0;
  double itemWidth = 0;
  var tap = 'Timeline';
  //
  var userInfo = UserManager.userInfo;
  List<Map> mainTabList = [
    {'title':'Timeline','icon':Icons.tab},
    {'title':'Friends','icon':Icons.group_sharp},
    {'title':'Photos','icon':Icons.photo},
    {'title':'Videos','icon':Icons.video_call},
    {'title':'Likes','icon':Icons.flag},
    {'title':'Groups','icon':Icons.group_sharp},
    {'title':'Events','icon':Icons.gif_box},

  ];
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as ProfileController;
    _gotoHome();
  }
  late ProfileController con;
  void _gotoHome(){
    Future.delayed(Duration.zero, () {
      width = SizeConfig(context).screenWidth - 260;
      itemWidth = 100;
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
            width: SizeConfig(context).screenWidth,
            padding: const EdgeInsets.only(left: 60, right: 10),
            margin: const EdgeInsets.only(top: 195),
            child: Row(children: [
              CircleAvatar(
                radius: 80,
                backgroundColor: Colors.white,
                child: userInfo['avatar'] != null
                    ? CircleAvatar(
                        radius: 75,
                        backgroundImage:
                            NetworkImage(userInfo['avatar']))
                    : CircleAvatar(
                        radius: 75,
                        child: SvgPicture.network(Helper.avatar),
                      ),

              ),
            Container(
              width: width,
              padding: const EdgeInsets.only(left: 50,top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${userInfo['firstName']} ${userInfo['lastName']}'
                  ,style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),),
                  Container(
                    child:  mainTabWidget(),
                  )
                 
                ],
            )),
            ]),
          );
  }
  Widget mainTabWidget(){
    return 
    SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child:
    Container(
      width: width,
      margin: const EdgeInsets.only(top: 15),
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
      ),
      child:Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: mainTabList.map((e) => 
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
        onTap: (){
          widget.onClick(e['title']);
          setState(() {});
        },
        child: 
      Container(
        padding: const EdgeInsets.only(top: 30),
        width: itemWidth,
        child: 
        Column(
          children: [
          Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(e['icon'],size: 15,color: Color.fromRGBO(76, 76, 76, 1),),
            const Padding(padding:EdgeInsets.only(left:5)),
            Text(e['title'],style:const TextStyle(
              fontSize:13,
              color: Color.fromRGBO(76, 76, 76, 1),
              fontWeight: FontWeight.bold
            ))
          ]),
          e['title'] == con.tab ? 
          Container(
            margin: const EdgeInsets.only(top: 23),
            height: 2,
            color: Colors.grey,
          ) : Container()
        ],)
        
      )),
      )
      ).toList()),
    ));
  }
}
