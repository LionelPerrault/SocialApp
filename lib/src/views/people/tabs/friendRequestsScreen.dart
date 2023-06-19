import 'package:flutter/material.dart';

import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PeopleController.dart';
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/routes/route_names.dart';

import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/people/widget/searchScreen.dart';
import 'package:shnatter/src/widget/requestFriendCell.dart';

class FriendRequestsScreen extends StatefulWidget {
  FriendRequestsScreen({Key? key, required this.routerChange})
      : con = PeopleController(),
        super(key: key);
  final PeopleController con;
  Function routerChange;

  @override
  State createState() => FriendRequestsScreenState();
}

class FriendRequestsScreenState extends mvc.StateMVC<FriendRequestsScreen> {
  bool showMenu = false;
  late PeopleController con;
  //route variable
  String tabName = 'Discover';
  Color color = const Color.fromRGBO(230, 236, 245, 1);
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    add(widget.con);
    super.initState();
    con = controller as PeopleController;
    con.addNotifyCallBack(this);
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
              requestFriendWidget(),
              const Padding(padding: EdgeInsets.only(left: 20)),
              SearchScreen(
                isModal: false,
                onClick: (value) {
                  con.fieldSearch(value);

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
              requestFriendWidget(),
            ],
          );
  }

  Widget requestFriendWidget() {
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
          con.isSearch && con.requestFriends.isEmpty
              ? Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.only(top: 20, bottom: 50),
                  child: const Text('No people available for your search',
                      style: TextStyle(fontSize: 14)))
              : con.requestFriends.isEmpty
                  ? Container(
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.only(top: 20, bottom: 50),
                      child: const Text('No new requests',
                          style: TextStyle(fontSize: 14)))
                  : Column(
                      children: con.requestFriends.map((e) {
                      return InkWell(
                          onTap: () async {
                            await ProfileController()
                                .updateProfile(e['userName']);
                            print(e);
                            widget.routerChange({
                              'router': RouteNames.profile,
                              'subRouter': e['userName'],
                            });
                          },
                          child: RequestFriendCell(
                              cellData: e,
                              onClick: () {},
                              routerChange: widget.routerChange));
                    }).toList()),
        ],
      ),
    );
  }
}
