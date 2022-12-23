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

import '../../controllers/UserController.dart';

class ShnatterFriendRequest extends StatefulWidget {
  ShnatterFriendRequest({Key? key, required this.onClick})
      : con = PeopleController(),
        super(key: key);
  final PeopleController con;
  Function onClick;
  @override
  State createState() => ShnatterFriendRequestState();
}

class ShnatterFriendRequestState extends mvc.StateMVC<ShnatterFriendRequest> {
  //
  bool isSound = false;
  late PeopleController con;
  var isConfirmRequest = {};
  var isDeclineRequest = {};
  var isDeleteRequest = {};
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
              SizedBox(
                height: 10,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
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
                          children: con.requestFriends
                              .asMap()
                              .entries
                              .map((e) => Container(
                                  padding: EdgeInsets.only(
                                      top: 10, left: 20, right: 20),
                                  child: Column(
                                    children: [
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10)),
                                            e.value[e.value['requester']]
                                                        ['avatar'] ==
                                                    ''
                                                ? CircleAvatar(
                                                    radius: 20,
                                                    child: SvgPicture.network(
                                                        Helper.avatar))
                                                : CircleAvatar(
                                                    radius: 20,
                                                    backgroundImage:
                                                        NetworkImage(e.value[e
                                                                    .value[
                                                                'requester']]
                                                            ['avatar'])),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 10, top: 5),
                                              child: InkWell(
                                                  onTap: () {
                                                    Navigator.pushReplacementNamed(
                                                        context,
                                                        '/${e.value['requester']}');
                                                  },
                                                  child: Text(
                                                    e.value[e
                                                            .value['requester']]
                                                        ['name'],
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 11),
                                                  )),
                                            ),
                                            const Flexible(
                                                fit: FlexFit.tight,
                                                child: SizedBox()),
                                            Container(
                                              padding:
                                                  const EdgeInsets.only(top: 6),
                                              child: e.value['state'] == 0
                                                  ? Row(children: [
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          isConfirmRequest[
                                                              e.key] = true;
                                                          setState(() {});
                                                          await con
                                                              .confirmFriend(
                                                                  e.value['id'],
                                                                  e.key);
                                                          isConfirmRequest[
                                                              e.key] = false;
                                                          widget.onClick();
                                                          setState(() {});
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Colors.white,
                                                            elevation: 3,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        2.0)),
                                                            minimumSize: isConfirmRequest[e.key] !=
                                                                        null &&
                                                                    isConfirmRequest[
                                                                        e.key]
                                                                ? const Size(
                                                                    60, 35)
                                                                : const Size(
                                                                    80, 35),
                                                            maximumSize: isConfirmRequest[e.key] !=
                                                                        null &&
                                                                    isConfirmRequest[e.key]
                                                                ? const Size(60, 35)
                                                                : const Size(80, 35)),
                                                        child: isConfirmRequest[e
                                                                        .key] !=
                                                                    null &&
                                                                isConfirmRequest[
                                                                    e.key]
                                                            ? const SizedBox(
                                                                width: 10,
                                                                height: 10,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              )
                                                            : const Text(
                                                                'Confirm',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        11,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900)),
                                                      ),
                                                      const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5)),
                                                      ElevatedButton(
                                                        onHover: (value) {},
                                                        onPressed: () async {
                                                          isDeclineRequest[
                                                              e.key] = true;
                                                          setState(() {});
                                                          await con
                                                              .deleteFriend(e
                                                                  .value['id']);
                                                          widget.onClick();
                                                          isDeclineRequest[
                                                              e.key] = false;
                                                          con.getList();
                                                          setState(() {});
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                const Color.fromRGBO(
                                                                    245, 54, 92, 1),
                                                            elevation: 3,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        2.0)),
                                                            minimumSize:
                                                                isDeclineRequest[e.key] != null && isDeclineRequest[e.key]
                                                                    ? const Size(
                                                                        60, 35)
                                                                    : const Size(
                                                                        80, 35),
                                                            maximumSize: isDeclineRequest[e.key] !=
                                                                        null &&
                                                                    isDeclineRequest[e.key]
                                                                ? const Size(60, 35)
                                                                : const Size(80, 35)),
                                                        child: isDeclineRequest[e
                                                                        .key] !=
                                                                    null &&
                                                                isDeclineRequest[
                                                                    e.key]
                                                            ? const SizedBox(
                                                                width: 10,
                                                                height: 10,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              )
                                                            : const Text(
                                                                'Decline',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        11,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900)),
                                                      )
                                                    ])
                                                  : ElevatedButton(
                                                      onPressed: () async {
                                                        isDeleteRequest[e.key] =
                                                            true;
                                                        setState(() {});
                                                        await con.deleteFriend(
                                                            e.value['id']);
                                                        isDeleteRequest[e.key] =
                                                            false;
                                                        setState(() {});
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.green,
                                                          elevation: 3,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      2.0)),
                                                          minimumSize:
                                                              isDeleteRequest[e.key] !=
                                                                          null &&
                                                                      isDeleteRequest[
                                                                          e.key]
                                                                  ? const Size(
                                                                      50, 35)
                                                                  : const Size(
                                                                      80, 35),
                                                          maximumSize: isDeleteRequest[e.key] !=
                                                                      null &&
                                                                  isDeleteRequest[e.key]
                                                              ? const Size(50, 35)
                                                              : const Size(80, 35)),
                                                      child: isDeleteRequest[
                                                                      e.key] !=
                                                                  null &&
                                                              isDeleteRequest[
                                                                  e.key]
                                                          ? SizedBox(
                                                              width: 10,
                                                              height: 10,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )
                                                          : Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: const [
                                                                Icon(
                                                                  Icons
                                                                      .check_circle,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 13,
                                                                ),
                                                                Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                3)),
                                                                Text('Friend',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            11,
                                                                        fontWeight:
                                                                            FontWeight.w900))
                                                              ],
                                                            ),
                                                    ),
                                            )
                                          ]),
                                      Padding(
                                          padding: EdgeInsets.only(top: 10)),
                                      Container(
                                        height: 1,
                                        color: color,
                                      ),
                                    ],
                                  )))
                              .toList())),
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
