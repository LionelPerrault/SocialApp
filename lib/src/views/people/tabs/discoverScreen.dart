import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PeopleController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/people/widget/searchScreen.dart';

class PeopleDiscoverScreen extends StatefulWidget {
  PeopleDiscoverScreen({Key? key, required this.routerChange})
      : con = PeopleController(),
        super(key: key);
  final PeopleController con;
  Function routerChange;
  @override
  State createState() => PeopleDiscoverScreenState();
}

class PeopleDiscoverScreenState extends mvc.StateMVC<PeopleDiscoverScreen> {
  late PeopleController con;
  //route variable
  Color color = const Color.fromRGBO(230, 236, 245, 1);
  @override
  void initState() {
    add(widget.con);
    con = controller as PeopleController;
    con.getUserList();
    con.logsData();
    super.initState();
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
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
              userListWidget(),
              Padding(padding: EdgeInsets.only(left: 20)),
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
              userListWidget(),
            ],
          );
  }

  Widget userListWidget() {
    // get only pagination list;
    int lastIndex = con.pageIndex * 5;
    if (lastIndex > con.userList.length) lastIndex = con.userList.length;
    List<DocumentSnapshot> data = con.userList.getRange(0, lastIndex).toList();

    return con.isGetList
        ? Container(
            margin: const EdgeInsets.only(top: 10),
            color: Colors.white,
            width: SizeConfig(context).screenWidth < 900
                ? SizeConfig(context).screenWidth - 60
                : SizeConfig(context).screenWidth * 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(padding: EdgeInsets.only(top: 25)),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    con.isSearch ? 'Search Results' : 'People You May Know',
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                Container(
                  height: 1,
                  color: color,
                ),
                con.isSearch && con.userList.isEmpty
                    ? Container(
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.only(top: 20, bottom: 50),
                        child: const Text(
                          'No people available for your search',
                          style: TextStyle(fontSize: 14),
                        ),
                      )
                    : Column(
                        children: data
                            .asMap()
                            .entries
                            .map((e) => Container(
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
                                          e.value['avatar'] == ''
                                              ? CircleAvatar(
                                                  radius: 20,
                                                  child: SvgPicture.network(
                                                      Helper.avatar))
                                              : CircleAvatar(
                                                  radius: 20,
                                                  backgroundImage: NetworkImage(
                                                      e.value['avatar'])),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 10, top: 5),
                                            child: RichText(
                                              text: TextSpan(
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text:
                                                          '${e.value['firstName']} ${e.value['lastName']}',
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 11),
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () {
                                                              print(
                                                                  'visit profile');
                                                              widget
                                                                  .routerChange({
                                                                'router':
                                                                    RouteNames
                                                                        .profile,
                                                                'subRouter': e
                                                                        .value[
                                                                    'userName']
                                                              });
                                                            })
                                                ],
                                              ),
                                            ),
                                          ),
                                          const Flexible(
                                            fit: FlexFit.tight,
                                            child: SizedBox(),
                                          ),
                                          Container(
                                            padding:
                                                const EdgeInsets.only(top: 6),
                                            child: ElevatedButton(
                                                onPressed: () async {
                                                  con.isFriendRequest[e.key] =
                                                      true;
                                                  setState(() {});
                                                  await con.requestFriend(
                                                      e.value['userName'],
                                                      '${e.value['firstName']} ${e.value['lastName']}',
                                                      e.value['avatar'],
                                                      e.key);
                                                  con.isFriendRequest[e.key] =
                                                      false;

                                                  setState(() {});
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: const Color.fromARGB(
                                                        255, 33, 37, 41),
                                                    elevation: 3,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                2.0)),
                                                    minimumSize: con.isFriendRequest[e.key] != null &&
                                                            con.isFriendRequest[
                                                                e.key]
                                                        ? const Size(90, 35)
                                                        : const Size(110, 35),
                                                    maximumSize: con.isFriendRequest[e.key] != null &&
                                                            con.isFriendRequest[e.key]
                                                        ? const Size(90, 35)
                                                        : const Size(110, 35)),
                                                child: con.isFriendRequest[e.key] != null && con.isFriendRequest[e.key]
                                                    ? const SizedBox(
                                                        width: 10,
                                                        height: 10,
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    : Row(
                                                        children: const [
                                                          Icon(
                                                            Icons
                                                                .person_add_alt_rounded,
                                                            color: Colors.white,
                                                            size: 18.0,
                                                          ),
                                                          Text(' Add Friend',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900)),
                                                        ],
                                                      )),
                                          )
                                        ]),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 10)),
                                    Container(
                                      height: 1,
                                      color: color,
                                    ),
                                  ],
                                )))
                            .toList()),
                con.isSearch
                    ? Container()
                    : MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: InkWell(
                          onTap: () async {
                            con.pageIndex++;
                            con.isShowProgressive = true;
                            setState(() {});
                            await con.getUserList();
                            con.isShowProgressive = false;
                            setState(() {});
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(55, 213, 242, 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3))),
                            alignment: Alignment.center,
                            height: 45,
                            child: con.isShowProgressive
                                ? const SizedBox(
                                    width: 20,
                                    height: 20.0,
                                    child: CircularProgressIndicator(
                                      color: Colors.grey,
                                    ),
                                  )
                                : const Text('See More',
                                    style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      )
              ],
            ))
        : Container(
            height: SizeConfig(context).screenHeight / 2,
            width: SizeConfig(context).screenWidth < 900
                ? SizeConfig(context).screenWidth - 60
                : SizeConfig(context).screenWidth * 0.4,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
  }

  requestFriends(e) async {
    con.isFriendRequest[e.key] = true;
    setState(() {});
    await con.requestFriend(
        e.value['userName'],
        '${e.value['firstName']} ${e.value['lastName']}',
        e.value['avatar'],
        e.key);
    setState(() {});
  }
}
