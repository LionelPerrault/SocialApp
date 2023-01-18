import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/ChatController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';

class ShnatterMessage extends StatefulWidget {
  ShnatterMessage({Key? key})
      : con = ChatController(),
        super(key: key);
  final ChatController con;
  @override
  State createState() => ShnatterMessageState();
}

class ShnatterMessageState extends mvc.StateMVC<ShnatterMessage> {
  //
  bool isSound = false;
  var userInfo = UserManager.userInfo;
  late ChatController con;
  @override
  void initState() {
    add(widget.con);
    con = controller as ChatController;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Container(
          width: 400,
          color: const Color.fromARGB(255, 255, 255, 255),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Messages",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Row(children: [
                        TextButton(
                            child: const Text('ShnatterMessage',
                                style: TextStyle(fontSize: 11)),
                            onPressed: () {}),
                      ])
                    ],
                  )),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                height: 1,
                endIndent: 10,
              ),
              SizedBox(
                height: 300,
                //size: Size(100,100),
                child: ListView.separated(
                  itemCount: con.newMessage.length,
                  itemBuilder: (context, index) => Material(
                      child: ListTile(
                          onTap: () {
                            con.avatar = con.newMessage[index]['avatar'];
                            con.isMessageTap = 'message-list';
                            con.hidden = false;
                            con.chattingUser =
                                con.newMessage[index]['userName'];
                            con.chatUserFullName =
                                con.newMessage[index]['name'];
                            con.docId = con.newMessage[index]['id'];
                            con.newMessage = con.newMessage
                                .where((e) =>
                                    e['id'] != con.newMessage[index]['id'])
                                .toList();
                            // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                            Helper.setting.notifyListeners();
                          },
                          hoverColor: const Color.fromARGB(255, 243, 243, 243),
                          tileColor: const Color.fromARGB(230, 230, 230, 230),
                          contentPadding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 20, right: 10),
                          enabled: true,
                          leading: con.newMessage[index]['avatar'] != ''
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                  con.newMessage[index]['avatar'],
                                ))
                              : CircleAvatar(
                                  child: SvgPicture.network(
                                  con.newMessage[index]['avatar'],
                                )),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                con.newMessage[index]['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                              const Padding(padding: EdgeInsets.only(top: 5)),
                              Text(con.newMessage[index]['lastData'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 10)),
                            ],
                          ))),
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                    height: 1,
                    endIndent: 10,
                  ),
                ),
              ),
              const Divider(height: 1, indent: 0),
              Container(
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          child:
                              Text('See All', style: TextStyle(fontSize: 11)),
                          onPressed: () {}),
                    ],
                  ))
            ],
          )),
    );
  }
}
