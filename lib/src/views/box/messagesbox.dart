import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/ChatController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';

class ShnatterMessage extends StatefulWidget {
  ShnatterMessage(
      {Key? key, required this.routerChange, required this.hideNavBox})
      : con = ChatController(),
        super(key: key);
  final ChatController con;
  Function routerChange;
  Function hideNavBox;

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
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Container(
            width: 400,
            color: const Color.fromARGB(255, 255, 255, 255),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Messages",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  height: 1,
                  endIndent: 10,
                ),
                con.newMessage.isEmpty
                    ? const SizedBox(
                        height: 100,
                        child: Center(
                          child: Text("No new messages"),
                        ))
                    : SizedBox(
                        //size: Size(100,100),
                        child: Column(
                          children: con.newMessage
                              .map(
                                (e) => Material(
                                    child: ListTile(
                                        onTap: () async {
                                          if (SizeConfig(context).screenWidth <
                                              700) {
                                            QuerySnapshot snapshot =
                                                await FirebaseFirestore.instance
                                                    .collection("user")
                                                    .where('userName',
                                                        isEqualTo:
                                                            e['userName'])
                                                    .get();
                                            con.docId = snapshot.docs[0].id;
                                            con.setState(() {});
                                            widget.routerChange({
                                              'router': RouteNames.messages,
                                              'subRouter':
                                                  snapshot.docs[0].id.toString()
                                            });
                                            setState(() {});
                                          } else {
                                            con.avatar = e['avatar'];
                                            con.isMessageTap = 'message-list';
                                            con.hidden = false;
                                            con.chattingUser = e['userName'];
                                            con.chatUserFullName = e['name'];
                                            con.docId = e['id'];
                                            con.newMessage = con.newMessage
                                                .where(
                                                    (e) => e['id'] != e['id'])
                                                .toList();
                                            // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                                            Helper.setting.notifyListeners();
                                          }
                                          widget.hideNavBox();
                                        },
                                        hoverColor: const Color.fromARGB(
                                            255, 243, 243, 243),
                                        tileColor: const Color.fromARGB(
                                            230, 230, 230, 230),
                                        contentPadding: const EdgeInsets.only(
                                            top: 5,
                                            bottom: 5,
                                            left: 20,
                                            right: 10),
                                        enabled: true,
                                        leading: e['avatar'] != ''
                                            ? CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                e['avatar'],
                                              ))
                                            : CircleAvatar(
                                                child: SvgPicture.network(
                                                e['avatar'],
                                              )),
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              e['name'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10),
                                            ),
                                            const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 5)),
                                            Text(e['lastData'],
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 10)),
                                          ],
                                        ))),
                              )
                              .toList(),
                        ),
                      ),
                const Divider(height: 1, indent: 0),
                InkWell(
                  onTap: () {
                    widget.hideNavBox();
                    widget.routerChange({
                      'router': RouteNames.messages,
                      'subRouter': '',
                    });
                  },
                  child: Container(
                    color: const Color.fromARGB(255, 130, 163, 255),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child:
                        const Text('See All', style: TextStyle(fontSize: 11)),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
