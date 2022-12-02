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

class PageVideosScreen extends StatefulWidget {
  Function onClick;
  PageVideosScreen({Key? key, required this.onClick})
      : con = PostController(),
        super(key: key);
  final PostController con;
  @override
  State createState() => PageVideosScreenState();
}

class PageVideosScreenState extends mvc.StateMVC<PageVideosScreen>{
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as PostController;
  }
  late PostController con;
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
          height: 70,
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
    return con.page['pageVideos'].isEmpty ? Container(
      padding: const EdgeInsets.only(top: 40),
      alignment: Alignment.center,
      child: Text('${con.page['pageName']} doesn`t have videos',style:const TextStyle(
        color: Color.fromRGBO(108, 117, 125, 1)
      )),
    ) : Container();
  }
}
