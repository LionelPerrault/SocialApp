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

class ProfileAvatarandTabScreen extends StatefulWidget {
  ProfileAvatarandTabScreen({Key? key})
      : con = HomeController(),
        super(key: key);
  final HomeController con;

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
  var url = window.location.href;
  var subUrl = '';
  var suggest = <String, bool>{
    'friends': true,
    'pages': true,
    'groups': true,
    'events': true
  };
  //
  var userInfo = UserManager.userInfo;
  var mainTabList = [
    {'title':'Timeline','icon':const Icon(Icons.tab)},
    {'title':'Friends','icon':const Icon(Icons.group_sharp)},
    {'title':'Photos','icon':const Icon(Icons.photo)},
    {'title':'Videos','icon':const Icon(Icons.video_call)},
    {'title':'Likes','icon':const Icon(Icons.flag)},
    {'title':'Groups','icon':const Icon(Icons.group_sharp)},
    {'title':'Events','icon':const Icon(Icons.gif_box)},

  ];
  @override
  void initState() {
    super.initState();

    con = controller as HomeController;
  }

  late HomeController con;

  @override
  Widget build(BuildContext context) {
    return Container(
            width: SizeConfig(context).screenWidth - 310,
            padding: const EdgeInsets.only(left: 60, right: 10),
            margin: const EdgeInsets.only(top: 200),
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

            ]),

          );
  }
  Widget mainTabWidget(){
    return Container(
      //width: SizeConfig(context).screenHeight,
      //height: ,
    );
  }
}
