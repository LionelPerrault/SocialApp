import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/SearchController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/search/widget/eventCell.dart';
import 'package:shnatter/src/views/search/widget/groupCell.dart';
import 'package:shnatter/src/views/search/widget/userCell.dart';

class ShnatterSearchBox extends StatefulWidget {
  ShnatterSearchBox({
    Key? key,
    required this.routerChange,
    required this.hideSearch,
    required this.searchText,
  })  : con = SearchController(),
        super(key: key);

  Function routerChange;
  Function hideSearch;
  String searchText;
  final SearchController con;
  @override
  State createState() => ShnatterSearchBoxState();
}

class ShnatterSearchBoxState extends mvc.StateMVC<ShnatterSearchBox> {
  //
  bool isSound = false;
  List searchResult = [];
  late SearchController con;
  @override
  void initState() {
    add(widget.con);
    con = controller as SearchController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.searchText != '') {
      var total = [];
      var totalUsers = con.users
          .where((user) =>
              (user['userName'] != UserManager.userInfo['userName'] &&
                  (user['userName'].contains(widget.searchText) ||
                      '${user['firstName']} ${user['lastName']}'
                          .contains(widget.searchText))))
          .toList();
      var totalEvents = con.events
          .where((event) => event['eventName'].contains(widget.searchText))
          .toList();
      var totalGroups = con.groups
          .where((group) => (group['groupName'].contains(widget.searchText) ||
              group['groupUserName'].contains(widget.searchText)))
          .toList();
      total = [...totalUsers, ...total];
      total = [...totalEvents, ...total];
      total = [...totalGroups, ...total];
      searchResult = total;
      print('searchResult$searchResult');
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Column(
        children: [
          Container(
            width: 400,
            color: const Color.fromARGB(255, 255, 255, 255),
            padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Search Results",
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
                const Divider(height: 1, indent: 0),
                searchResult.isEmpty
                    ? Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 140,
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(240, 240, 240, 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
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
                                itemCount: searchResult.length,
                                itemBuilder: (context, index) =>
                                    searchCell(searchResult[index]),
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const Divider(
                                  height: 1,
                                  endIndent: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                Container(
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        child: const Text(
                          'Search All Result',
                          style: TextStyle(fontSize: 11),
                        ),
                        onPressed: () {
                          widget.routerChange({
                            'router': RouteNames.search,
                          });
                          widget.hideSearch();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget searchCell(data) {
    if (data['userName'] != null) {
      return SearchUserCell(
        userInfo: data,
        routerChange: widget.routerChange,
      );
    } else if (data['eventName'] != null) {
      return SearchEventCell(
        eventInfo: data,
        routerChange: widget.routerChange,
      );
    } else {
      return SearchGroupCell(
        groupInfo: data,
        routerChange: widget.routerChange,
      );
    }
  }
}
