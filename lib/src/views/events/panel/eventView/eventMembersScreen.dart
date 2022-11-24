import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';

class EventMembersScreen extends StatefulWidget {
  Function onClick;
  EventMembersScreen({Key? key,required this.onClick})
      : con = PostController(),
        super(key: key);
  final PostController con;

  @override
  State createState() => EventMembersScreenState();
}

class EventMembersScreenState extends mvc.StateMVC<EventMembersScreen>{
  var userInfo = UserManager.userInfo;
  String tab = 'Going';
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
      tab == 'Going' ? GoingData() :
      tab == 'Interested' ? InterestedData() :
      tab == 'Invited' ? InvitedData() :
      InvitesData() 
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
                  Icon(Icons.groups,size: 15,),
                  Padding(padding: EdgeInsets.only(left: 5)),
                  Text('Members',style: TextStyle(
                    fontSize: 15
                  ),)
                ],)
              ),
              Container(
                margin: const EdgeInsets.only(top: 22),
                child: Row(
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          tab = 'Going';
                          setState(() { });
                        },
                        child: Container(
                      alignment: Alignment.center,
                      width: 100,
                      height: 40,
                      color: tab == 'Going' ? Colors.white : Color.fromRGBO(240, 240, 240, 1),
                      child: const Text(
                        'Going',
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
                          tab = 'Interested';
                          setState(() { });
                        },
                        child: Container(
                      alignment: Alignment.center,
                      width: 100,
                      height: 40,
                      color: tab == 'Interested' ? Colors.white : Color.fromRGBO(240, 240, 240, 1),
                      child: const Text(
                        'Interested',
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
                          tab = 'Invited';
                          setState(() { });
                        },
                        child: Container(
                      alignment: Alignment.center,
                      width: 100,
                      height: 40,
                      color: tab == 'Invited' ? Colors.white : Color.fromRGBO(240, 240, 240, 1),
                      child: const Text(
                        'Invited',
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
                          tab = 'Invites';
                          setState(() { });
                        },
                        child: Container(
                      alignment: Alignment.center,
                      width: 100,
                      height: 40,
                      color: tab == 'Invites' ? Colors.white : Color.fromRGBO(240, 240, 240, 1),
                      child: const Text(
                        'Invites',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black
                        ),
                      ),
                    ),
                      ),
                    ),
                    
                ]),
              )
            ],
          ),
      );
  }
  Widget GoingData(){
    return userInfo['photos'] == null ? Container(
      padding: const EdgeInsets.only(top: 40),
      alignment: Alignment.center,
      child: Text('${con.event['eventName']} doesn`t have photos',style:const TextStyle(
        color: Color.fromRGBO(108, 117, 125, 1)
      )),
    ) : Container();
  }
  Widget InterestedData(){
    return userInfo['albums'] == null ? Container(
      padding: const EdgeInsets.only(top: 40),
      alignment: Alignment.center,
      child: Text('${con.event['eventName']} doesn`t have albums',style:const TextStyle(
        color: Color.fromRGBO(108, 117, 125, 1)
      )),
    ) : Container();
  }
  
  Widget InvitedData(){
    return userInfo['albums'] == null ? Container(
      padding: const EdgeInsets.only(top: 40),
      alignment: Alignment.center,
      child: Text('${con.event['eventName']} doesn`t have albums',style:const TextStyle(
        color: Color.fromRGBO(108, 117, 125, 1)
      )),
    ) : Container();
  }
  
  Widget InvitesData(){
    return userInfo['albums'] == null ? Container(
      padding: const EdgeInsets.only(top: 40),
      alignment: Alignment.center,
      child: Text('${con.event['eventName']} doesn`t have albums',style:const TextStyle(
        color: Color.fromRGBO(108, 117, 125, 1)
      )),
    ) : Container();
  }
}
