import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PeopleController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/colors.dart';

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shnatter/src/widget/requestFriendCell.dart';

import '../../controllers/UserController.dart';

class ShnatterFriendRequest extends StatefulWidget {
  ShnatterFriendRequest(
      {Key? key, required this.onClick, required this.routerChange})
      : con = PeopleController(),
        super(key: key);
  final PeopleController con;
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
          color: Color.fromARGB(255, 255, 255, 255),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Text(
                        "Friend Requests",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              const Divider(
                height: 1,
                endIndent: 10,
              ),
              SizedBox(
                  height: 300,
                  //size: Size(100,100),
                  child: con.requestFriends.isEmpty
                      ? Container(
                          padding: EdgeInsets.only(top: 15),
                          alignment: Alignment.topCenter,
                          child: const Text('No new requests'),
                        )
                      : Column(
                          children: con.requestFriends.asMap().entries.map((e) {
                          return RequestFriendCell(
                              cellData: e,
                              onClick: widget.onClick,
                              routerChange: widget.routerChange);
                        }).toList())),
              Divider(height: 1, indent: 0),
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
