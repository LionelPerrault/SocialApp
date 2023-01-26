import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/views/box/searchbox.dart';
import 'package:shnatter/src/views/marketPlace/panel/marketAllProduct.dart';
import 'package:shnatter/src/views/marketPlace/panel/marketPlaceLeftPanel.dart';
import 'package:shnatter/src/views/navigationbar.dart';
import 'package:shnatter/src/widget/createProductWidget.dart';

import '../../controllers/PostController.dart';
import '../../utils/size_config.dart';

class MarketPlaceScreen extends StatefulWidget {
  MarketPlaceScreen({Key? key})
      : con = PostController(),
        super(key: key);
  final PostController con;

  @override
  State createState() => MarketPlaceScreenState();
}

class MarketPlaceScreenState extends mvc.StateMVC<MarketPlaceScreen>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  bool showSearch = false;
  late FocusNode searchFocusNode;
  bool showMenu = false;
  late AnimationController _drawerSlideController;
  String category = 'All';
  String arrayOption = 'Latest';
  String searchValue = '';

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
              padding: const EdgeInsets.only(top: SizeConfig.navbarHeight),
              child: SingleChildScrollView(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 20)),
                    SizeConfig(context).screenWidth <
                            SizeConfig.mediumScreenSize
                        ? const SizedBox()
                        : MarketPlaceLeftPanel(
                            changeCategory: (value) {
                              category = value;
                              setState(() {});
                            },
                            currentCategory: category,
                          ),
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
                                      customInput(
                                        place: 'I am looking for',
                                        onChange: (value) {
                                          searchValue = value;
                                          setState(() {});
                                        },
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(top: 20)),
                                      Row(
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Colors.black,
                                                  width: 1,
                                                ),
                                              ),
                                            ),
                                            child: const Text(
                                              'PRODUCTS',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ),
                                          const Flexible(
                                              fit: FlexFit.tight,
                                              child: SizedBox()),
                                          Container(
                                            width: 160,
                                            alignment: Alignment.center,
                                            margin: const EdgeInsets.only(
                                                right: 20),
                                            child: PopupMenuButton(
                                              onSelected: (value) {
                                                arrayOption = value;
                                                setState(() {});
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 33, 37, 41),
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      arrayOption == 'Latest'
                                                          ? Icons.menu
                                                          : Icons.sort,
                                                      color: Colors.white,
                                                    ),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10)),
                                                    Text(
                                                      arrayOption,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              itemBuilder: (BuildContext bc) {
                                                return [
                                                  PopupMenuItem(
                                                    value: 'Latest',
                                                    child: Row(children: const [
                                                      Icon(Icons.menu),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10)),
                                                      Text(
                                                        "Latest",
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      )
                                                    ]),
                                                  ),
                                                  PopupMenuItem(
                                                    value: 'Price High',
                                                    child: Row(
                                                      children: const [
                                                        Icon(Icons.sort),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10)),
                                                        Text(
                                                          "Price High",
                                                          style: TextStyle(
                                                              fontSize: 14),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  PopupMenuItem(
                                                    value: 'Price Low',
                                                    child: Row(
                                                      children: const [
                                                        Icon(Icons.sort),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10)),
                                                        Text(
                                                          "Price Low",
                                                          style: TextStyle(
                                                              fontSize: 14),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ];
                                              },
                                            ),
                                          )
                                        ],
                                      ),
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
                                MarketAllProduct(
                                  productCategory: category,
                                  arrayOption: arrayOption,
                                  searchValue: searchValue,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _drawerSlideController,
              builder: (context, child) {
                return FractionalTranslation(
                  translation: SizeConfig(context).screenWidth >
                          SizeConfig.smallScreenSize
                      ? const Offset(0, 0)
                      : Offset(_drawerSlideController.value * 0.001, 0.0),
                  child: SizeConfig(context).screenWidth >
                              SizeConfig.smallScreenSize ||
                          _isDrawerClosed()
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(
                              top: SizeConfig.navbarHeight),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  color: Colors.white,
                                  width: SizeConfig.leftBarWidth,
                                  child: SingleChildScrollView(
                                    child: MarketPlaceLeftPanel(
                                      changeCategory: (value) {
                                        category = value;
                                        setState(() {});
                                      },
                                      currentCategory: category,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                );
              },
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
                            ShnatterSearchBox()
                          ],
                        )),
                  )
                : const SizedBox(),
            // ChatScreen(),
          ],
        ));
  }

  Widget customInput({place, onChange}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.only(top: 2)),
        Container(
          height: 40,
          child: TextField(
            onChanged: onChange,
            decoration: InputDecoration(
              hintText: place,
              hintStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              contentPadding: const EdgeInsets.only(top: 10, left: 10),
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.0),
              ),
            ),
          ),
        )
      ],
    );
  }
}
