import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PeopleController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/people/widget/searchScreen.dart';

import '../../../controllers/ProfileController.dart';

class SendRequestsScreen extends StatefulWidget {
  SendRequestsScreen({Key? key, required this.routerChange})
      : con = PeopleController(),
        super(key: key);
  final PeopleController con;

  Function routerChange;
  @override
  State createState() => SendRequestsScreenState();
}

class SendRequestsScreenState extends mvc.StateMVC<SendRequestsScreen> {
  bool showMenu = false;
  late PeopleController con;
  var userInfo = UserManager.userInfo;
  //route variable
  String tabName = 'Discover';
  Color color = const Color.fromRGBO(230, 236, 245, 1);
  @override
  void initState() {
    add(widget.con);
    super.initState();
    con = controller as PeopleController;
    con.addNotifyCallBack(this);

    Future.delayed(const Duration(microseconds: 5), () async {
      await con.getSendRequest();
      setState(() {});
    });
  }

  Widget searchButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
          minimumSize: Size(
              SizeConfig(context).screenWidth < 900
                  ? SizeConfig(context).screenWidth - 60
                  : SizeConfig(context).screenWidth * 0.3 - 90,
              50),
          maximumSize: Size(
              SizeConfig(context).screenWidth < 900
                  ? SizeConfig(context).screenWidth - 60
                  : SizeConfig(context).screenWidth * 0.3 - 90,
              50),
        ),
        onPressed: () async {
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    content: SingleChildScrollView(
                      child: SearchScreen(
                        isModal: true,
                        onClick: (value) async {
                          await con.fieldSearch(value);
                          setState(() {});
                        },
                      ),
                    ),

                    ///title:Text("Search")
                  ));
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              color: Colors.black,
              size: 16,
            ),
            Padding(padding: EdgeInsets.only(left: 3)),
            Text('Search',
                style: TextStyle(
                    color: Color.fromARGB(255, 33, 37, 41),
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold)),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SizeConfig(context).screenWidth > 900
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              sendFriends(),
              const Padding(padding: EdgeInsets.only(left: 20)),
              SearchScreen(
                isModal: false,
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
              searchButton(),
              sendFriends(),
            ],
          );
  }

  Widget sendFriends() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(top: 20),
      color: Colors.white,
      width: SizeConfig(context).screenWidth < 900
          ? SizeConfig(context).screenWidth - 60
          : SizeConfig(context).screenWidth * 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.only(top: 15)),
          Container(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              con.isSearch
                  ? 'Search Results'
                  : 'Respond to Your Friend Request',
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 13),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 15)),
          Container(
            height: 1,
            color: color,
          ),
          con.isSearch && con.sendFriends.isEmpty
              ? Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.only(top: 20, bottom: 50),
                  child: const Text('No people available for your search',
                      style: TextStyle(fontSize: 14)))
              : con.sendFriends.isEmpty
                  ? Container(
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.only(top: 20, bottom: 50),
                      child: const Text('No new sent',
                          style: TextStyle(fontSize: 14)))
                  : Column(
                      children: con.sendFriends
                          .map(
                            (e) => InkWell(
                              onTap: () {
                                ProfileController()
                                    .updateProfile(e['userName']);

                                widget.routerChange({
                                  'router': RouteNames.profile,
                                  'subRouter': e['userName']
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 20, right: 20),
                                child: Column(
                                  children: [
                                    Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10)),
                                          e['avatar'] == ''
                                              ? CircleAvatar(
                                                  radius: 20,
                                                  child: SvgPicture.network(
                                                      Helper.avatar))
                                              : CircleAvatar(
                                                  radius: 20,
                                                  backgroundImage: NetworkImage(
                                                      e['avatar'])),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 10, top: 5),
                                            child: Text(
                                              e['fullName'],
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 11),
                                            ),
                                          ),
                                          const Flexible(
                                              fit: FlexFit.tight,
                                              child: SizedBox()),
                                          Container(
                                            padding:
                                                const EdgeInsets.only(top: 6),
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                if (!e.containsKey('state') ||
                                                    e['state'] == 0) {
                                                  e['state'] = -1;
                                                  setState(() {});
                                                  await con
                                                      .cancelFriendDirectlyMap(
                                                          {'uid': e['uid']});
                                                  e['state'] = -2;
                                                  setState(() {});
                                                } else if (e['state'] == 0) {
                                                  e['state'] = -1;
                                                  setState(() {});
                                                  await con
                                                      .cancelFriendDirectlyMap(
                                                          {'uid': e['uid']});
                                                  e['state'] = -2;
                                                  setState(() {});
                                                } else if (e['state'] == -2) {
                                                  e['state'] = -1;
                                                  setState(() {});
                                                  await con.requestFriendAsData(
                                                    e['uid'],
                                                  );
                                                  e['state'] = 0;
                                                  setState(() {});
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      (e as Map).containsKey('state') && e['state'] == -2
                                                          ? Colors.black
                                                          : const Color.fromRGBO(
                                                              245, 54, 92, 1),
                                                  elevation: 3,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2.0)),
                                                  minimumSize: (e).containsKey('state') &&
                                                          e['state'] == -1
                                                      ? const Size(60, 35)
                                                      : const Size(70, 35),
                                                  maximumSize:
                                                      (e).containsKey('state') &&
                                                              e['state'] == -1
                                                          ? const Size(60, 35)
                                                          : const Size(70, 35)),
                                              child: (e).containsKey('state') &&
                                                      e['state'] == -1
                                                  ? const SizedBox(
                                                      width: 10,
                                                      height: 10,
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : (e).containsKey('state') &&
                                                          e['state'] == -2
                                                      ? const Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .person_add_alt_rounded,
                                                              color:
                                                                  Colors.white,
                                                              size: 13,
                                                            ),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            2)),
                                                            Text('Add',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        11,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900))
                                                          ],
                                                        )
                                                      : const Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              FontAwesomeIcons
                                                                  .clock,
                                                              color:
                                                                  Colors.white,
                                                              size: 13,
                                                            ),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            2)),
                                                            Text('Sent',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        11,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900))
                                                          ],
                                                        ),
                                            ),
                                          )
                                        ]),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 10)),
                                    Container(
                                      height: 1,
                                      color: color,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList()),
        ],
      ),
    );
  }
}
