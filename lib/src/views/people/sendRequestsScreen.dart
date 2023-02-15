import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PeopleController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/people/searchScreen.dart';

class SendRequestsScreen extends StatefulWidget {
  SendRequestsScreen({Key? key})
      : con = PeopleController(),
        super(key: key);
  final PeopleController con;
  @override
  State createState() => SendRequestsScreenState();
}

class SendRequestsScreenState extends mvc.StateMVC<SendRequestsScreen> {
  bool showMenu = false;
  late PeopleController con;
  var isConfirmRequest = {};
  var isDeclineRequest = {};
  var isDeleteRequest = {};
  var userInfo = UserManager.userInfo;
  //route variable
  String tabName = 'Discover';
  Color color = Color.fromRGBO(230, 236, 245, 1);
  @override
  void initState() {
    add(widget.con);
    con = controller as PeopleController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizeConfig(context).screenWidth > 900
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              sendFriends(),
              Padding(padding: EdgeInsets.only(left: 20)),
              SearchScreen(
                onClick: (value) async {
                  await con.fieldSearch(value);
                  setState(() {});
                },
              )
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SearchScreen(
                onClick: (value) async {
                  await con.fieldSearch(value);

                  setState(() {});
                },
              ),
              sendFriends(),
            ],
          );
  }

  Widget sendFriends() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(top: 20),
      color: Colors.white,
      width: SizeConfig(context).screenWidth < 900
          ? SizeConfig(context).screenWidth - 60
          : SizeConfig(context).screenWidth * 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(top: 15)),
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              con.isSearch
                  ? 'Search Results'
                  : 'Respond to Your Friend Request',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 13),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 15)),
          Container(
            height: 1,
            color: color,
          ),
          con.isSearch && con.sendFriends.isEmpty
              ? Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(top: 20, bottom: 50),
                  child: Text('No people available for your search',
                      style: TextStyle(fontSize: 14)))
              : con.sendFriends.isEmpty
                  ? Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.only(top: 20, bottom: 50),
                      child:
                          Text('No new sent', style: TextStyle(fontSize: 14)))
                  : Column(
                      children: con.sendFriends
                          .asMap()
                          .entries
                          .map((e) => Container(
                              padding:
                                  EdgeInsets.only(top: 10, left: 20, right: 20),
                              child: Column(
                                children: [
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(left: 10)),
                                        e.value[e.value['receiver']]
                                                    ['avatar'] ==
                                                ''
                                            ? CircleAvatar(
                                                radius: 20,
                                                child: SvgPicture.network(
                                                    Helper.avatar))
                                            : CircleAvatar(
                                                radius: 20,
                                                backgroundImage: NetworkImage(
                                                    e.value[e.value['receiver']]
                                                        ['avatar'])),
                                        Container(
                                          padding:
                                              EdgeInsets.only(left: 10, top: 5),
                                          child: Text(
                                            e.value[e.value['receiver']]
                                                ['name'],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 11),
                                          ),
                                        ),
                                        Flexible(
                                            fit: FlexFit.tight,
                                            child: SizedBox()),
                                        Container(
                                          padding: EdgeInsets.only(top: 6),
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              isDeleteRequest[e.key] = true;
                                              setState(() {});
                                              await con
                                                  .deleteFriend(e.value['id']);
                                              await con.getSendRequests(
                                                  userInfo['userName']);
                                              isDeleteRequest[e.key] = false;
                                              await con.getList();
                                              setState(() {});
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromRGBO(
                                                    245, 54, 92, 1),
                                                elevation: 3,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2.0)),
                                                minimumSize: isDeleteRequest[e.key] !=
                                                            null &&
                                                        isDeleteRequest[e.key]
                                                    ? const Size(60, 35)
                                                    : const Size(70, 35),
                                                maximumSize: isDeleteRequest[
                                                                e.key] !=
                                                            null &&
                                                        isDeleteRequest[e.key]
                                                    ? const Size(60, 35)
                                                    : const Size(70, 35)),
                                            child: isDeleteRequest[e.key] !=
                                                        null &&
                                                    isDeleteRequest[e.key]
                                                ? SizedBox(
                                                    width: 10,
                                                    height: 10,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: const [
                                                      Icon(
                                                        FontAwesomeIcons.clock,
                                                        color: Colors.white,
                                                        size: 13,
                                                      ),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 2)),
                                                      Text('Sent',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900))
                                                    ],
                                                  ),
                                          ),
                                        )
                                      ]),
                                  Padding(padding: EdgeInsets.only(top: 10)),
                                  Container(
                                    height: 1,
                                    color: color,
                                  ),
                                ],
                              )))
                          .toList()),
        ],
      ),
    );
  }
}
