import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/views/box/searchbox.dart';
import 'package:shnatter/src/views/chat/chatScreen.dart';
import 'package:shnatter/src/views/navigationbar.dart';
import 'package:shnatter/src/views/panel/leftpanel.dart';
import 'package:shnatter/src/views/products/panel/allproducts.dart';
import 'package:shnatter/src/widget/createProductWidget.dart';

import '../../controllers/PostController.dart';
import '../../utils/size_config.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';

class ProductsScreen extends StatefulWidget {
  ProductsScreen({Key? key})
      : con = PostController(),
        super(key: key);
  final PostController con;

  @override
  State createState() => ProductsScreenState();
}

class ProductsScreenState extends mvc.StateMVC<ProductsScreen>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  bool showSearch = false;
  late FocusNode searchFocusNode;
  bool showMenu = false;
  late AnimationController _drawerSlideController;
  //route variable
  String pageSubRoute = '';

  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    super.initState();
    searchFocusNode = FocusNode();
    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  late PostController con;
  void onSearchBarFocus() {
    searchFocusNode.requestFocus();
    setState(() {
      showSearch = true;
    });
  }

  void clickMenu() {
    //setState(() {
    //  showMenu = !showMenu;
    //});
    //Scaffold.of(context).openDrawer();
    //print("showmenu is {$showMenu}");
    if (_isDrawerOpen() || _isDrawerOpening()) {
      _drawerSlideController.reverse();
    } else {
      _drawerSlideController.forward();
    }
  }

  void onSearchBarDismiss() {
    if (showSearch)
      setState(() {
        showSearch = false;
      });
  }

  bool _isDrawerOpen() {
    return _drawerSlideController.value == 1.0;
  }

  bool _isDrawerOpening() {
    return _drawerSlideController.status == AnimationStatus.forward;
  }

  bool _isDrawerClosed() {
    return _drawerSlideController.value == 0.0;
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    _drawerSlideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawerEnableOpenDragGesture: false,
        drawer: Drawer(),
        body: Stack(
          fit: StackFit.expand,
          children: [
            ShnatterNavigation(
              searchController: searchController,
              onSearchBarFocus: onSearchBarFocus,
              onSearchBarDismiss: onSearchBarDismiss,
              drawClicked: clickMenu,
            ),
            Padding(
                padding: EdgeInsets.only(top: SizeConfig.navbarHeight),
                child: SingleChildScrollView(
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizeConfig(context).screenWidth <
                                SizeConfig.mediumScreenSize
                            ? const SizedBox()
                            : LeftPanel(),
                        //    : SizedBox(width: 0),
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Column(
                              children: [
                                Container(
                                  width: SizeConfig(context).screenWidth >
                                          SizeConfig.mediumScreenSize
                                      ? 700
                                      : SizeConfig(context).screenWidth > 600
                                          ? 600
                                          : SizeConfig(context).screenWidth,
                                  child: Column(
                                    children: [
                                      Container(
                                          height: 70,
                                          child: Row(
                                            children: [
                                              Container(
                                                child: Text(
                                                  'My Products',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              const Flexible(
                                                  fit: FlexFit.tight,
                                                  child: SizedBox()),
                                              Container(
                                                width: SizeConfig(context)
                                                            .screenWidth >
                                                        SizeConfig
                                                            .mediumScreenSize
                                                    ? 160
                                                    : 50,
                                                margin: const EdgeInsets.only(
                                                    right: 20),
                                                child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      padding:
                                                          EdgeInsets.all(3),
                                                      backgroundColor:
                                                          Colors.white,
                                                      // elevation: 3,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          3.0)),
                                                      minimumSize: Size(
                                                          SizeConfig(context)
                                                                      .screenWidth >
                                                                  SizeConfig
                                                                      .mediumScreenSize
                                                              ? 170
                                                              : 50,
                                                          50),
                                                      maximumSize: Size(
                                                          SizeConfig(context)
                                                                      .screenWidth >
                                                                  SizeConfig
                                                                      .mediumScreenSize
                                                              ? 170
                                                              : 50,
                                                          50),
                                                    ),
                                                    onPressed: () {
                                                      (showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                                  context) =>
                                                              AlertDialog(
                                                                  title: Row(
                                                                    children: const [
                                                                      Icon(
                                                                        Icons
                                                                            .add_circle,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            33,
                                                                            150,
                                                                            243),
                                                                      ),
                                                                      Text(
                                                                        'Add New Product',
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize:
                                                                                15,
                                                                            fontStyle:
                                                                                FontStyle.italic),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  content: CreateProductModal(
                                                                      context:
                                                                          context))));
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Icon(
                                                          Icons.add_circle,
                                                          color: Colors.black,
                                                        ),
                                                        const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 4)),
                                                        SizeConfig(context)
                                                                    .screenWidth >
                                                                SizeConfig
                                                                    .mediumScreenSize
                                                            ? const Text(
                                                                'Add New Product',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold))
                                                            : SizedBox()
                                                      ],
                                                    )),
                                              )
                                            ],
                                          )),
                                      Container(
                                        width: SizeConfig(context).screenWidth >
                                                SizeConfig.mediumScreenSize
                                            ? 700
                                            : SizeConfig(context).screenWidth >
                                                    600
                                                ? 600
                                                : SizeConfig(context)
                                                    .screenWidth,
                                        child: const Divider(
                                          thickness: 0.1,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(top: 20)),
                                AllProducts()
                              ],
                            )),
                          ],
                        )),
                      ]),
                )),
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
                            ShnatterSearchBox()
                          ],
                        )),
                  )
                : const SizedBox(),
            // ChatScreen(),
          ],
        ));
  }
}
