import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
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
  ShnatterNavigation({Key? key})
      : con = HomeController(),
        super(key: key);
  final HomeController con;

  @override
  State createState() => ShnatterNavigationState();
}

class ShnatterNavigationState extends mvc.StateMVC<ShnatterNavigation> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  //
  @override
  void initState() {
    add(widget.con);
    con = controller as HomeController;
    super.initState();
  }

  late HomeController con;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: kprimaryColor,
        ),
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 58.0),
              child: SvgPicture.network(
                  SVGPath.logo,
                  width: 40,
                  height: 40,
                  semanticsLabel: 'Logo'),
            ),
            Row(
              children: [
                Container(
                    padding:const EdgeInsets.only(right: 20),
                    child: SvgPicture.network(
                      SVGPath.home,
                      color: Colors.white,
                      width: 20,
                      height: 20,
                    ) //Icon(Icons.home_outlined, size: 30, color: Colors.white),
                    ),
                
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
                    child:  SvgPicture.network(
                      SVGPath.group,
                      color: Colors.white,
                      width: 20,
                      height: 20,
                    )
                    
                    ),
                  ),
                  
                Container(
                  padding: EdgeInsets.all(9.0),
                  child: CustomPopupMenu(
                    menuBuilder: () => ShnatterMessage(),
                    pressType: PressType.singleClick,
                    verticalMargin: -10,
                    child:  SvgPicture.network(
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
                    child:  SvgPicture.network(
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
        ));
  }
}

