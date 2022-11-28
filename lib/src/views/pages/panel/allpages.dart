// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/pages/widget/pagecell.dart';

import '../../../controllers/PostController.dart';
import '../../../models/chatModel.dart';

class AllPages extends StatefulWidget {
  AllPages({Key? key})
      : con = PostController(),
        super(key: key);
  late PostController con;
  State createState() => AllPagesState();
}

class AllPagesState extends mvc.StateMVC<AllPages> {
  bool check1 = false;
  bool check2 = false;
  late PostController con;
  var userInfo = UserManager.userInfo;
  var realAllEvents = [];
  int arrayLength = 0;
  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    con.setState(() { });
    super.initState();
    getEventNow();
  }

  void getEventNow() {
    con.getEvent('all').then((value) => {
      realAllEvents = value,
      realAllEvents.where((event) => event['data']['eventPost'] == true),
      print(realAllEvents),
      setState(() {}),
    });
  }
  
  @override
  Widget build(BuildContext context) {
    var  screenWidth = SizeConfig(context).screenWidth - SizeConfig.leftBarWidth;
    return Container(
      child: 
      Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: GridView.count(
                crossAxisCount: screenWidth > 800 ? 4 : screenWidth > 600 ? 3 : screenWidth > 210 ? 2 : 1  ,
                childAspectRatio: 2/ 3,
                padding: const EdgeInsets.all(4.0),
                mainAxisSpacing: 4.0,
                shrinkWrap: true,
                crossAxisSpacing: 4.0,
                children: 
                  realAllEvents.map((event) => 
                    EventCell(
                      eventTap: (){
                        Navigator
                        .pushReplacementNamed(
                            context,
                            '/events/${event['id']}');
                      },
                      buttonFun: (){
                        con.interestedEvent(event['id']).then((value){
                          getEventNow();
                        });
                      },
                      picture: 'null',
                      status: false,
                      interests: event['data']['eventInterested'].length,
                      header: event['data']['eventName'],
                      interested: event['interested'])).toList(),),
          ),
        ],
      ),
    );
  }
}
