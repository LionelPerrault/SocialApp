import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/views/admin/navigationbar.dart';
import 'package:shnatter/src/views/admin/admin_panel/adminbodypanel.dart';

import '../../controllers/HomeController.dart';
import '../../utils/size_config.dart';
import '../box/notification.dart';
import '../box/admin_dash_chart.dart';
import 'admin_panel/adminleftpanel.dart';

class AdminScreen extends StatefulWidget {
  AdminScreen({Key? key})
      : con = HomeController(),
        super(key: key);
  final HomeController con;

  @override
  State createState() => AdminScreenState();
}

class AdminScreenState extends mvc.StateMVC<AdminScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  bool showSearch = false;
  late FocusNode searchFocusNode;
  bool showMenu = false;
  var suggest = <String, bool> {
    'friends': true,
    'pages': true,
    'groups': true,
    'events': true
  };
  //
  @override
  void initState() {
    add(widget.con);
    con = controller as HomeController;
    super.initState();
    searchFocusNode = FocusNode();
  }

  late HomeController con;
  void onSearchBarFocus() {
    searchFocusNode.requestFocus();
    setState(() {
      showSearch = true;
    });
  }
  void clickMenu() {
      setState(() {
        showMenu = !showMenu;
      });
    }

  void onSearchBarDismiss() {
    if (showSearch)
      setState(() {
        showSearch = false;
      });
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Stack(
          fit: StackFit.expand,
          children: [
            AdminShnatterNavigation(
              searchController: searchController,
              onSearchBarFocus: onSearchBarFocus,
              onSearchBarDismiss: onSearchBarDismiss,
              drawClicked: clickMenu,
            ),
            Row(
              children: [
            const AdminLeftPanel(),
            const AdminBodyPanel(),

              ],
            ),
            showSearch
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        showSearch = false;
                      });
                    },
                    child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: const Color.fromARGB(0, 214, 212, 212),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: const SizedBox(
                                      width: 20,
                                      height: 20,
                                    )),
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, right: 9),
                                  width: SizeConfig(context).screenWidth * 0.4,
                                  child: TextField(
                                    focusNode: searchFocusNode,
                                    controller: searchController,
                                    cursorColor: Colors.white,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.search,
                                          color: Color.fromARGB(
                                              150, 170, 212, 255),
                                          size: 20),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0)),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xff202020),
                                      hintText: 'Search',
                                      hintStyle: TextStyle(
                                          fontSize: 15.0, color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            ShnatterNotification()
                          ],
                        )),
                  )
                : const SizedBox()
          ],
        ));
  }
}
