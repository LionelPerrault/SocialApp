// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/chat/writeMessageScreen.dart';
import 'package:shnatter/src/widget/mprimary_button.dart';
import 'package:shnatter/src/widget/primaryInput.dart';

import '../../controllers/ChatController.dart';
import '../../helpers/helper.dart';
import '../../models/chatModel.dart';

class NewMessageScreen extends StatefulWidget {
  Function onBack;
  NewMessageScreen({Key? key,required this.onBack})
      : con = ChatController(),
        super(key: key);
  late ChatController con;
  State createState() => NewMessageScreenState();
}

class NewMessageScreenState extends mvc.StateMVC<NewMessageScreen> {
  bool check1 = false;
  bool check2 = false;
  late ChatController con;
  var userInfo = UserManager.userInfo;
  @override
  void initState() {
    add(widget.con);
    con = controller as ChatController;
    setState(() {});
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print(con.allUsersList.length);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Message',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Color.fromRGBO(51, 103, 214, 1),
        toolbarHeight: 40,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              widget.onBack('all-list');
            }),
      ),
      body: Column(
      children:[
          TextField(
            onChanged: ((value) async {
              await allUserSearch(value);
            }),
            decoration: InputDecoration(
              hintText: 'To :',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
              // Enabled Border
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 0.1),
              ),
              // Focused Border
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 0.1),
              ),
              // Error Border
              contentPadding: EdgeInsets.only(left: 15, right: 15),
              // Focused Error Border
              focusedErrorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 0.1),
              ),
            ),
          ),
          Container(
          height: SizeConfig(context).screenHeight - 260,
            child:
          con.allUsersList.isNotEmpty ? 
           userList() : Container()),
           WriteMessageScreen(type:'new',goMessage: (value){
            widget.onBack(value);
            con.docId = '';
           },)
      ]));
  }
  Widget userList(){
    print(con.allUsersList);
    return
    SingleChildScrollView(child:
    Container(
      child: Column(
      children: con.allUsersList.map((e) => ListTile(
        contentPadding: EdgeInsets.all(10),
            enabled: true,
            tileColor: con.chattingUser == e['userName'] ? Color.fromRGBO(240, 240, 240, 1) : Colors.white,
            hoverColor: Color.fromRGBO(240, 240, 240, 1),
            onTap: (){
              con.chattingUser = e['userName'];
              con.newRFirstName = e['firstName'];
              con.newRLastName = e['lastName'];
              con.setState(() { });
              setState(() {
                
              },);
            },
            leading: CircleAvatar(
              radius: 25,
              child: SvgPicture.network(Helper.avatar),
            ),
            title: Text(e['userName']),
          )).toList(),
    )));
  }
  Future<void> allUserSearch(String value) async {
    var list = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection(Helper.userField).where(Helper.newMessageSearch, isEqualTo:value).get();
    // ignore: unnecessary_cast
    con.allUsersList = querySnapshot.docs;
    con.setState(() { });
    setState(() {
      
    });
  }
}
