// ignore_for_file: prefer_const_constructors, must_be_immutable, annotate_overrides

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/SearchController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/search/widget/userCell.dart';

class PeopleSearch extends StatefulWidget {
  PeopleSearch(
      {Key? key, required this.routerChange, required this.searchResult})
      : con = SearchController(),
        super(key: key);
  late SearchController con;

  Function routerChange;
  List searchResult;
  State createState() => PeopleSearchState();
}

class PeopleSearchState extends mvc.StateMVC<PeopleSearch> {
  late SearchController searchCon;
  var userInfo = UserManager.userInfo;
  var resultUsers = [];
  @override
  void initState() {
    add(widget.con);

    searchCon = controller as SearchController;
    super.initState();

    // QuerySnapshot snapshotFriend = await FirebaseFirestore.instance
    //     .collection(Helper.friendCollection)
    //     .where('users.${UserManager.userInfo['userName']}', isEqualTo: true)
    //     .get();

    // // Convert friends list into a set for O(1) lookup time.
    // Set<String> friendSet = Set.from(snapshotFriend.docs.map((doc) {
    //   Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    //   return data != null ? data['userName'] : null;
    // }).where((value) => value != null));

    ///List<DocumentSnapshot> newDocumentList = snapshot.docs;
    // for (var elem in searchCon.users) {
    //   Map data = elem.data() as Map;
    //   var userName = data['userName'] ?? '';

    //   if (!PeopleController().userList.contains(userName)) {
    //     userList.add(data);
    //   }
    // }
    // resultUsers = searchCon.users
    //     .where((user) => (user['userName'].contains(widget.searchValue) ||
    //         '${user['firstName']} ${user['lastName']}'
    //             .contains(widget.searchValue)))
    //     .toList();
  }

  @override
  Widget build(BuildContext context) {
    return widget.searchResult.isEmpty
        ? Container(
            padding: const EdgeInsets.only(top: 40),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.network(Helper.emptySVG, width: 90),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  width: 140,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(240, 240, 240, 1),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: const Text(
                    'No data to show',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(108, 117, 125, 1)),
                  ),
                ),
              ],
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: Container(
                  width: SizeConfig(context).screenWidth,
                  height: SizeConfig(context).screenHeight -
                      SizeConfig.navbarHeight -
                      150 -
                      (UserManager.userInfo['isVerify'] ? 0 : 50),
                  child: ListView.separated(
                    itemCount: widget.searchResult.length,
                    itemBuilder: (context, index) => SearchUserCell(
                      userInfo: widget.searchResult[index],
                      routerChange: widget.routerChange,
                    ),
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                      height: 1,
                      endIndent: 10,
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
