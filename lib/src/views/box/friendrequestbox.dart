import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PeopleController.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/widget/requestFriendCell.dart';

class ShnatterFriendRequest extends StatefulWidget {
  ShnatterFriendRequest(
      {Key? key,
      required this.hideMenu,
      required this.onClick,
      required this.routerChange})
      : con = PeopleController(),
        super(key: key);
  final PeopleController con;
  Function hideMenu;
  Function onClick;
  Function routerChange;

  @override
  State createState() => ShnatterFriendRequestState();
}

class ShnatterFriendRequestState extends mvc.StateMVC<ShnatterFriendRequest> {
  //
  bool isSound = false;
  late PeopleController con;
  Color color = const Color.fromRGBO(230, 236, 245, 1);
  @override
  void initState() {
    add(widget.con);
    con = controller as PeopleController;
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
              const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Text(
                        "Friend Requests",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                height: 1,
                endIndent: 10,
              ),
              SizedBox(
                  height: con.requestFriends.isEmpty ? 100 : 300,
                  //size: Size(100,100),
                  child: con.requestFriends.isEmpty
                      ? Container(
                          padding: const EdgeInsets.only(top: 15),
                          alignment: Alignment.topCenter,
                          child: const Text('No new requests'),
                        )
                      : Column(
                          children: con.requestFriends.map((e) {
                          return RequestFriendCell(
                              cellData: e,
                              onClick: widget.onClick,
                              routerChange: widget.routerChange);
                        }).toList())),
              const Divider(height: 1, indent: 0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      color: const Color.fromARGB(255, 130, 163, 255),
                      alignment: Alignment.center,
                      child: TextButton(
                          style: TextButton.styleFrom(
                              fixedSize: const Size(400, 11)),
                          child: const Text('See All',
                              style: TextStyle(fontSize: 11)),
                          onPressed: () async {
                            widget.hideMenu();
                            widget.routerChange({
                              'router': RouteNames.people,
                              'subRouter': 'Friend Requests',
                            });
                          }),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
