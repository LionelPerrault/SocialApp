import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/box/mindpost.dart';
import 'package:shnatter/src/views/box/searchbox.dart';
import 'package:shnatter/src/views/chat/chatScreen.dart';
import 'package:shnatter/src/views/navigationbar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PageFriendScreen extends StatefulWidget {
  Function onClick;
  PageFriendScreen({Key? key,required this.onClick})
      : con = PostController(),
        super(key: key);
  final PostController con;
  @override
  State createState() => PageFriendScreenState();
}

class PageFriendScreenState extends mvc.StateMVC<PageFriendScreen>{
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  bool showSearch = false;
  late FocusNode searchFocusNode;
  bool showMenu = false;
  double width = 0;
  double itemWidth = 0;
  //
  var tab = 'Friends';
  var userInfo = UserManager.userInfo;
  List<Map> mainInfoList = [];
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as PostController;
    _gotoHome();
  }
  late PostController con;
  void _gotoHome(){
    Future.delayed(Duration.zero, () {
      width = SizeConfig(context).screenWidth - 260;
      itemWidth = width/7.5;
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      mainTabs(),
      tab == 'Friends' ? 
      friendsData() :
      tab == 'Follows' ?
      followsData() :
      followingsData()
    ]);
  }
  Widget mainTabs(){
    return Container(
          width: SizeConfig(context).screenWidth ,
          height: 100,
          margin: EdgeInsets.only(left: 30,right: 30),
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
                  Icon(Icons.group,size: 14,),
                  Padding(padding: EdgeInsets.only(left: 5)),
                  Text('Friends',style: TextStyle(
                    fontSize: 15
                  ),)
                ],)
              ),
              Container(
                margin: EdgeInsets.only(top: 22),
                child: Row(
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          tab = 'Friends';
                          setState(() { });
                        },
                        child: Container(
                      alignment: Alignment.center,
                      width: 100,
                      height: 40,
                      color: tab == 'Friends' ? Colors.white : Color.fromRGBO(240, 240, 240, 1),
                      child: const Text(
                        'Friends',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black
                        ),
                      ),
                    ),),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          tab = 'Follows';
                          setState(() { });
                        },
                        child: Container(
                      alignment: Alignment.center,
                      width: 100,
                      height: 40,
                      color: tab == 'Follows' ? Colors.white : Color.fromRGBO(240, 240, 240, 1),
                      child: const Text(
                        'Follows',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black
                        ),
                      ),
                    ),
                      ),
                    ),
                    
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          tab = 'Followings';
                          setState(() {});
                        },
                        child: Container(
                      alignment: Alignment.center,
                      width: 100,
                      height: 40,
                      color: tab == 'Followings' ? Colors.white : Color.fromRGBO(240, 240, 240, 1),
                      child: const Text(
                        'Followings',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black
                        ),
                      ),
                    ),
                      ),
                    )
                    
                ]),
              )
            ],
          ),
      );
  }
  Widget friendsData(){
    return userInfo['friends'] == null ? Container(
      padding: const EdgeInsets.only(top: 40),
      alignment: Alignment.center,
      child: Text('${userInfo['fullName']} doesn`t have friends',style:const TextStyle(
        color: Color.fromRGBO(108, 117, 125, 1)
      )),
    ) : Container();
  }
  Widget followingsData(){
    return userInfo['followings'] == null ? Container(
      padding: const EdgeInsets.only(top: 40),
      alignment: Alignment.center,
      child: Text('${userInfo['fullName']} doesn`t have followings',style:const TextStyle(
        color: Color.fromRGBO(108, 117, 125, 1)
      )),
    ) : Container();
  }
  Widget followsData(){
    return userInfo['followers'] == null ? Container(
      padding: const EdgeInsets.only(top: 40),
      alignment: Alignment.center,
      child: Text('${userInfo['fullName']} doesn`t have followers',style:const TextStyle(
        color: Color.fromRGBO(108, 117, 125, 1)
      )),
    ) : Container();
  }
}