import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';

class EventPhotosScreen extends StatefulWidget {
  Function onClick;
  EventPhotosScreen({Key? key,required this.onClick})
      : con = ProfileController(),
        super(key: key);
  final ProfileController con;

  @override
  State createState() => EventPhotosScreenState();
}

class EventPhotosScreenState extends mvc.StateMVC<EventPhotosScreen>{
  var userInfo = UserManager.userInfo;
  String tab = 'Photos';
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
      tab == 'Photos' ? 
      PhotosData() :
      AlbumsData()
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
                  Icon(Icons.photo,size: 15,),
                  Padding(padding: EdgeInsets.only(left: 5)),
                  Text('Photos',style: TextStyle(
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
                          tab = 'Photos';
                          setState(() { });
                        },
                        child: Container(
                      alignment: Alignment.center,
                      width: 100,
                      height: 40,
                      color: tab == 'Photos' ? Colors.white : Color.fromRGBO(240, 240, 240, 1),
                      child: const Text(
                        'Photos',
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
                          tab = 'Albums';
                          setState(() { });
                        },
                        child: Container(
                      alignment: Alignment.center,
                      width: 100,
                      height: 40,
                      color: tab == 'Albums' ? Colors.white : Color.fromRGBO(240, 240, 240, 1),
                      child: const Text(
                        'Albums',
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
  Widget PhotosData(){
    return userInfo['photos'] == null ? Container(
      padding: const EdgeInsets.only(top: 40),
      alignment: Alignment.center,
      child: Text('${userInfo['fullName']} doesn`t have photos',style:const TextStyle(
        color: Color.fromRGBO(108, 117, 125, 1)
      )),
    ) : Container();
  }
  Widget AlbumsData(){
    return userInfo['albums'] == null ? Container(
      padding: const EdgeInsets.only(top: 40),
      alignment: Alignment.center,
      child: Text('${userInfo['fullName']} doesn`t have albums',style:const TextStyle(
        color: Color.fromRGBO(108, 117, 125, 1)
      )),
    ) : Container();
  }
}
