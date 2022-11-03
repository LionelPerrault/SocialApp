import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/utils/colors.dart';
import 'package:shnatter/src/utils/svg.dart';
import 'package:shnatter/src/views/box/friendrequestbox.dart';
import 'package:shnatter/src/views/box/messagesbox.dart';

import '../controllers/HomeController.dart';
import '../utils/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'box/notification.dart';

enum Menu {
  itemProfile,
  itemSettings,
  itemPrivacy,
  itemAdminPanel,
  itemLogout,
  itemKeyboardShortcut
}

class ShnatterNavigation extends StatefulWidget {
  ShnatterNavigation(
      {Key? key,
      required this.searchController,
      required this.onSearchBarFocus,
      required this.onSearchBarDismiss
      })
      : con = HomeController(),
        super(key: key);
  final HomeController con;
  final TextEditingController searchController;
  final VoidCallback onSearchBarFocus;
  final VoidCallback onSearchBarDismiss;
  @override
  State createState() => ShnatterNavigationState();
}

class ShnatterNavigationState extends mvc.StateMVC<ShnatterNavigation> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController searhCon;
  late FocusNode searchFocusNode;
  bool onHover = false;
  //
  @override
  void initState() {
    add(widget.con);
    searhCon = widget.searchController;
    con = controller as HomeController;
    searchFocusNode = FocusNode();
    searchFocusNode.addListener(() {
      widget.onSearchBarFocus();
    });
    super.initState();
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    super.dispose();
  }

  late HomeController con;
  @override
  Widget build(BuildContext context) {
    return SizeConfig(context).screenWidth >600 ? buildLargeSize():buildSmallSize();
  }
  @override
  Widget buildSmallSize()
  {
    Future.delayed(
      Duration(microseconds: 300),
    () =>{
      widget.onSearchBarDismiss()
    }
    );


    return Stack(
      children: [
        Container(
            decoration: BoxDecoration(
              color: kprimaryColor,
            ),
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                      Container(
                        padding: const EdgeInsets.only(right: 0),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            minimumSize:MaterialStateProperty.all(Size(30, 30)) ,
                            padding: MaterialStateProperty.all(EdgeInsets.all(2)),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.black),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          child:const Icon(
                                CupertinoIcons.line_horizontal_3,
                                size: 30,
                                color: Colors.white)
                        )
                        //Icon(Icons.home_outlined, size: 30, color: Colors.white),
                        ),
                  ],
                ),
                Container(
                  child: Row(children: [
                    Container(
                        padding: const EdgeInsets.only(right: 20),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            minimumSize:MaterialStateProperty.all(Size(30, 30)) ,
                            padding: MaterialStateProperty.all(EdgeInsets.all(2)),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.black),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          child: SvgPicture.network(
                            placeholderBuilder: (context) => const Icon(
                                Icons.logo_dev,
                                size: 30,
                                color: Colors.white),
                            SVGPath.home,
                            color: Colors.white,
                            width: 20,
                            height: 20,
                          ),
                        )
                        //Icon(Icons.home_outlined, size: 30, color: Colors.white),
                        ),
                    Container(
                      padding: EdgeInsets.only(right: 9.0),
                      child: CustomPopupMenu(
                          menuBuilder: () => ShnatterFriendRequest(),
                          pressType: PressType.singleClick,
                          verticalMargin: -10,
                          child: SvgPicture.network(
                            placeholderBuilder: (context) => const Icon(
                                Icons.logo_dev,
                                size: 30,
                                color: Colors.white),
                            SVGPath.group,
                            color: Colors.white,
                            width: 20,
                            height: 20,
                          )),
                    ),
                    Container(
                      padding: EdgeInsets.all(9.0),
                      child: CustomPopupMenu(
                          menuBuilder: () => ShnatterMessage(),
                          pressType: PressType.singleClick,
                          verticalMargin: -10,
                          child: SvgPicture.network(
                            placeholderBuilder: (context) => const Icon(
                                Icons.logo_dev,
                                size: 30,
                                color: Colors.white),
                            SVGPath.message,
                            color: Colors.white,
                            width: 20,
                            height: 20,
                          )),
                    ),
                    Container(
                      padding: EdgeInsets.all(9.0),
                      child: CustomPopupMenu(
                        menuBuilder: () => ShnatterNotification(),
                        pressType: PressType.singleClick,
                        verticalMargin: -10,
                        child: SvgPicture.network(
                          placeholderBuilder: (context) => const Icon(
                              Icons.logo_dev,
                              size: 30,
                              color: Colors.white),
                          SVGPath.notification,
                          color: Colors.white,
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                     Container(
                        padding: const EdgeInsets.only(right: 1),
                        child: ButtonTheme(
                          minWidth: 30,
                          child: ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            minimumSize:MaterialStateProperty.all(Size(30, 30)) ,
                            padding: MaterialStateProperty.all(EdgeInsets.all(2)),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.black),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          child: SvgPicture.network(
                            placeholderBuilder: (context) => const Icon(
                                Icons.logo_dev,
                                size: 30,
                                color: Colors.white),
                            SVGPath.search,
                            color: Colors.white,
                            width: 20,
                            height: 20,
                          ),
                        ),)
                         
                        //Icon(Icons.home_outlined, size: 30, color: Colors.white),
                        ),
                    Container(
                        padding: EdgeInsets.all(9.0),
                        child: PopupMenuButton(
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<Menu>>[
                            const PopupMenuItem<Menu>(
                              value: Menu.itemProfile,
                              child: Text('Profile'),
                            ),
                            const PopupMenuItem<Menu>(
                              value: Menu.itemSettings,
                              child: Text('Settings'),
                            ),
                            const PopupMenuItem<Menu>(
                              value: Menu.itemPrivacy,
                              child: Text('Privacy'),
                            ),
                            PopupMenuDivider(),
                            const PopupMenuItem<Menu>(
                              value: Menu.itemAdminPanel,
                              child: Text('AdminPanel'),
                            ),
                            PopupMenuDivider(),
                            PopupMenuItem<Menu>(
                                value: Menu.itemLogout,
                                child: Row(children: [
                                  Icon(Icons.logout),
                                  SizedBox(width: 8),
                                  Text('Log Out'),
                                ])),
                            PopupMenuDivider(),
                            const PopupMenuItem<Menu>(
                              value: Menu.itemKeyboardShortcut,
                              child: Text('Keyboard Shortcuts'),
                            ),
                            PopupMenuDivider(),
                          ],
                          onSelected: (Menu item) {},
                          child: Row(
                            children: const [
                              CircleAvatar(
                                backgroundColor: Colors.green,
                                backgroundImage: NetworkImage(
                                    "https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fblank_package.png?alt=media&token=f5cf4503-e36b-416a-8cce-079dfcaeae83"),
                              ),
                              //Icon(Icons.arrow_downward,
                              //    size: 15, color: Colors.white)
                            ],
                          ),
                        )),
                  ]),
                )
              ],
            )),
      ],
    );
  }
  @override
  Widget buildLargeSize()
  {
    return Stack(
      children: [
        Container(
            decoration: BoxDecoration(
              color: kprimaryColor,
            ),
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 58.0),
                    child: TextButton(
                      onPressed: () {},
                      onHover: (hover) { 
                        setState(() {
                          onHover = hover;
                        });

                      },
                      child: AnimatedOpacity(
                        duration: Duration(microseconds:1000),
                        curve: Curves.easeIn,
                        opacity: onHover?0.5:1,
                        child: SvgPicture.network(
                            placeholderBuilder: (context) => const Icon(
                                Icons.logo_dev,
                                size: 30,
                                color: Colors.white),
                            SVGPath.logo,
                            width: 40,
                            height: 40,
                            semanticsLabel: 'Logo'),
                      ),
                    )),
                Row(
                  children: [
                    Container(
                        padding: const EdgeInsets.only(right: 20),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all(Colors.black),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          child: SvgPicture.network(
                            placeholderBuilder: (context) => const Icon(
                                Icons.logo_dev,
                                size: 30,
                                color: Colors.white),
                            SVGPath.home,
                            color: Colors.white,
                            width: 20,
                            height: 20,
                          ),
                        )
                        //Icon(Icons.home_outlined, size: 30, color: Colors.white),
                        ),
                    SizedBox(
                      width: SizeConfig(context).screenWidth * 0.35,
                    )
                  ],
                ),
                Container(
                  child: Row(children: [
                    Container(
                      padding: EdgeInsets.only(right: 9.0),
                      child: CustomPopupMenu(
                          menuBuilder: () => ShnatterFriendRequest(),
                          pressType: PressType.singleClick,
                          verticalMargin: -10,
                          child: SvgPicture.network(
                            placeholderBuilder: (context) => const Icon(
                                Icons.logo_dev,
                                size: 30,
                                color: Colors.white),
                            SVGPath.group,
                            color: Colors.white,
                            width: 20,
                            height: 20,
                          )),
                    ),
                    Container(
                      padding: EdgeInsets.all(9.0),
                      child: CustomPopupMenu(
                          menuBuilder: () => ShnatterMessage(),
                          pressType: PressType.singleClick,
                          verticalMargin: -10,
                          child: SvgPicture.network(
                            placeholderBuilder: (context) => const Icon(
                                Icons.logo_dev,
                                size: 30,
                                color: Colors.white),
                            SVGPath.message,
                            color: Colors.white,
                            width: 20,
                            height: 20,
                          )),
                    ),
                    Container(
                      padding: EdgeInsets.all(9.0),
                      child: CustomPopupMenu(
                        menuBuilder: () => ShnatterNotification(),
                        pressType: PressType.singleClick,
                        verticalMargin: -10,
                        child: SvgPicture.network(
                          placeholderBuilder: (context) => const Icon(
                              Icons.logo_dev,
                              size: 30,
                              color: Colors.white),
                          SVGPath.notification,
                          color: Colors.white,
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.all(9.0),
                        child: PopupMenuButton(
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<Menu>>[
                            const PopupMenuItem<Menu>(
                              value: Menu.itemProfile,
                              child: Text('Profile'),
                            ),
                            const PopupMenuItem<Menu>(
                              value: Menu.itemSettings,
                              child: Text('Settings'),
                            ),
                            const PopupMenuItem<Menu>(
                              value: Menu.itemPrivacy,
                              child: Text('Privacy'),
                            ),
                            PopupMenuDivider(),
                            const PopupMenuItem<Menu>(
                              value: Menu.itemAdminPanel,
                              child: Text('AdminPanel'),
                            ),
                            PopupMenuDivider(),
                            PopupMenuItem<Menu>(
                                value: Menu.itemLogout,
                                child: Row(children: [
                                  Icon(Icons.logout),
                                  SizedBox(width: 8),
                                  Text('Log Out'),
                                ])),
                            PopupMenuDivider(),
                            const PopupMenuItem<Menu>(
                              value: Menu.itemKeyboardShortcut,
                              child: Text('Keyboard Shortcuts'),
                            ),
                            PopupMenuDivider(),
                          ],
                          onSelected: (Menu item) {},
                          child: Row(
                            children: const [
                              CircleAvatar(
                                backgroundColor: Colors.green,
                                backgroundImage: NetworkImage(
                                    "https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fblank_package.png?alt=media&token=f5cf4503-e36b-416a-8cce-079dfcaeae83"),
                              ),
                              //Icon(Icons.arrow_downward,
                              //    size: 15, color: Colors.white)
                            ],
                          ),
                        )),
                  ]),
                )
              ],
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.only(right: 20.0),
                child: const SizedBox(
                  width: 20,
                  height: 20,
                )),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10, right: 9),
              width: SizeConfig(context).screenWidth * 0.4,
              child: TextField(
                controller: searhCon,
                cursorColor: Colors.white,
                focusNode: searchFocusNode,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search,
                      color: Color.fromARGB(150, 170, 212, 255), size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  filled: true,
                  fillColor: Color(0xff202020),
                  hintText: 'Search',
                  hintStyle: TextStyle(fontSize: 15.0, color: Colors.white),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}