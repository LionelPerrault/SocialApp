// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shnatter/src/controllers/PeopleController.dart';
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';

// ignore: must_be_immutable
class SearchGroupCell extends StatefulWidget {
  SearchGroupCell({
    super.key,
    required this.groupInfo,
    required this.routerChange,
  }) : con = PostController();
  Map groupInfo;
  Function routerChange;

  late PostController con;
  @override
  State createState() => SearchGroupCellState();
}

class SearchGroupCellState extends mvc.StateMVC<SearchGroupCell> {
  late PostController con;
  bool requestStatus = false;
  bool joined = false;
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as PostController;
    con
        .boolJoined(widget.groupInfo, UserManager.userInfo['uid'])
        .then((value) => {
              joined = value,
            });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 10, right: 10),
        leading: CircleAvatar(
            radius: 17,
            backgroundImage: NetworkImage(widget.groupInfo['groupPicture'] == ''
                ? Helper.groupImage
                : widget.groupInfo['groupPicture'])),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                children: <TextSpan>[
                  TextSpan(
                      text: widget.groupInfo['groupName'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          widget.routerChange({
                            'router': RouteNames.groups,
                            'subRouter': widget.groupInfo['groupUserName']
                          });
                        })
                ],
              ),
            ),
            Text(
              '${widget.groupInfo['groupJoined'].length} Members',
              style: const TextStyle(
                fontSize: 13,
              ),
            )
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () async {
            // print(con.isFriendRequest);
            requestStatus = true;
            setState(() {});
            await con.joinedGroup(widget.groupInfo['uid']);
            requestStatus = false;
            joined = !joined;
            setState(() {});
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 33, 37, 41),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.0)),
              minimumSize:
                  requestStatus ? const Size(60, 35) : const Size(87, 35),
              maximumSize:
                  requestStatus ? const Size(60, 35) : const Size(87, 35)),
          child: requestStatus
              ? const SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : joined
                  ? Row(
                      children: const [
                        Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 18.0,
                        ),
                        Text(' Joined',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w900)),
                      ],
                    )
                  : Row(
                      children: const [
                        Icon(
                          Icons.person_add,
                          color: Colors.white,
                          size: 18.0,
                        ),
                        Text(' Join',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w900)),
                      ],
                    ),
        ),
      ),
    );
  }
}
