// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shnatter/src/controllers/PeopleController.dart';
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';

// ignore: must_be_immutable
class SearchUserCell extends StatefulWidget {
  SearchUserCell({
    super.key,
    required this.userInfo,
    required this.routerChange,
  }) : con = UserController();
  Map userInfo;
  Function routerChange;

  late UserController con;
  @override
  State createState() => SearchUserCellState();
}

class SearchUserCellState extends mvc.StateMVC<SearchUserCell> {
  late UserController con;
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as UserController;
    getState();
  }

  getState() async {
    await PeopleController()
        .getRelation(
            UserManager.userInfo['userName'], widget.userInfo['userName'])
        .then((value) {
      if (value >= 0) {
        widget.userInfo['state'] = value;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var itemData = widget.userInfo;
    return Material(
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 10, right: 10),
        leading: widget.userInfo['avatar'] == ''
            ? CircleAvatar(radius: 17, child: SvgPicture.network(Helper.avatar))
            : CircleAvatar(
                radius: 17,
                backgroundImage: NetworkImage(widget.userInfo['avatar'])),
        title: RichText(
          text: TextSpan(
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            children: <TextSpan>[
              TextSpan(
                  text:
                      '${widget.userInfo['firstName']} ${widget.userInfo['lastName']}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      color: Colors.black),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      ProfileController()
                          .updateProfile(widget.userInfo['userName']);
                      widget.routerChange({
                        'router': RouteNames.profile,
                        'subRouter': widget.userInfo['userName']
                      });
                    })
            ],
          ),
        ),
        trailing: ElevatedButton(
          onPressed: () async {
            var e = widget.userInfo;
            if (!e.containsKey('state')) {
              setState(() {
                widget.userInfo['state'] = 0;
              });
              await PeopleController()
                  .requestFriendDirectlyMap(widget.userInfo);
              setState(() {});
            } else {
              var status = e['state'];
              if (status == 0) {
                setState(() {});
                e['state'] = -1;
                await PeopleController()
                    .cancelFriendDirectlyMap(widget.userInfo);
                setState(() {});
              }
            }
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 33, 37, 41),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.0)),
              minimumSize:
                  itemData.containsKey('state') && itemData['state'] == -1
                      ? const Size(60, 35)
                      : const Size(80, 35),
              maximumSize:
                  itemData.containsKey('state') && itemData['state'] == -1
                      ? const Size(60, 35)
                      : const Size(80, 35)),
          child: itemData.containsKey('state') && itemData['state'] == -1
              ? const SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : widget.userInfo.containsKey("state")
                  ? Row(
                      children: const [
                        Icon(
                          Icons.person_add_alt_rounded,
                          color: Colors.white,
                          size: 18.0,
                        ),
                        Text(' Add',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w900)),
                      ],
                    )
                  : widget.userInfo['state'] == 0 ||
                          widget.userInfo['state'] == -1
                      ? Row(
                          children: const [
                            Icon(
                              Icons.timelapse,
                              color: Colors.white,
                              size: 18.0,
                            ),
                            Text(' Sent',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900)),
                          ],
                        )
                      : Row(
                          children: const [
                            Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 18.0,
                            ),
                            Text(' Friend',
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
