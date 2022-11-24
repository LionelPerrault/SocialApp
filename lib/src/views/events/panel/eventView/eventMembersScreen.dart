import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';

// ignore: must_be_immutable
class EventMembersScreen extends StatefulWidget {
  Function onClick;
  EventMembersScreen({Key? key, required this.onClick})
      : con = ProfileController(),
        super(key: key);
  final ProfileController con;
  @override
  State createState() => EventMembersScreenState();
}

class EventMembersScreenState extends mvc.StateMVC<EventMembersScreen>{
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
      likesData()
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
            border: const Border(bottom: BorderSide(width: 0.5,color: Color.fromRGBO(240, 240, 240, 1)))
          ),
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left:20,top: 30),
                child: Row(children: const [
                  Icon(Icons.group,size: 17,),
                  Padding(padding: EdgeInsets.only(left: 5)),
                  Text('Groups',style: TextStyle(
                    fontSize: 15
                  ),)
                ],)
              ),
            ],
          ),
      );
  }
  Widget likesData(){
    return userInfo['groups'] == null ? Container(
      padding: const EdgeInsets.only(top: 40),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.network(Helper.emptySVG,width:90),
          Container(
            alignment:Alignment.center,
            margin: const EdgeInsets.only(top:10),
            padding: const EdgeInsets.only(top: 10,bottom:10),
            width: 140,
            decoration: const BoxDecoration(
            color: Color.fromRGBO(240,240,240, 1),
              borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: const Text('No data to show',style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(108, 117, 125, 1)
            ),)
          )
        ]

      )
    ) : Container();
  }
}
