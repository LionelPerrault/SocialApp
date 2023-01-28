import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/colors.dart';
import 'package:shnatter/src/utils/svg.dart';
import 'package:shnatter/src/helpers/helper.dart';
import '../../routes/route_names.dart';
import '../../utils/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum Menu {
  itemProfile,
  itemSettings,
  itemPrivacy,
  itemAdminPanel,
  itemLogout,
  itemKeyboardShortcut
}

class AdminShnatterNavigation extends StatefulWidget {
  const AdminShnatterNavigation({
    Key? key,
    required this.drawClicked,
  }) : super(key: key);
  final VoidCallback drawClicked;
  @override
  State createState() => AdminShnatterNavigationState();
}

class AdminShnatterNavigationState
    extends mvc.StateMVC<AdminShnatterNavigation> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController searhCon;
  late FocusNode searchFocusNode;
  bool onHover = false;
  //
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeConfig(context).screenWidth > SizeConfig.mediumScreenSize
        ? buildLargeSize()
        : buildSmallSize();
  }

  void onHomeClicked() {
    Navigator.pushReplacementNamed(context, RouteNames.homePage);
  }

  Future<void> onLogOut() async {
    UserManager.isLogined = false;
    Helper.makeOffline();

    UserManager.userInfo = {};

    await Helper.removeAllPreference();
    // ignore: use_build_context_synchronously
    await Navigator.pushReplacementNamed(context, RouteNames.login);
  }

  Widget buildSmallSize() {
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
                        padding: const EdgeInsets.only(right: 0, left: 10),
                        child: ElevatedButton(
                            onPressed: () {
                              widget.drawClicked();
                            },
                            style: ButtonStyle(
                              minimumSize:
                                  MaterialStateProperty.all(const Size(30, 30)),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(2)),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.black),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),
                            child: const Icon(CupertinoIcons.line_horizontal_3,
                                size: 30, color: Colors.white))
                        //Icon(Icons.home_outlined, size: 30, color: Colors.white),
                        ),
                  ],
                ),
                Row(children: [
                  Container(
                      padding: const EdgeInsets.only(right: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          onHomeClicked();
                        },
                        style: ButtonStyle(
                          minimumSize:
                              MaterialStateProperty.all(const Size(30, 30)),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(2)),
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
                      padding: const EdgeInsets.all(9.0),
                      child: PopupMenuButton(
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<Menu>>[
                          PopupMenuItem<Menu>(
                            onTap: () => {onLogOut()},
                            value: Menu.itemLogout,
                            child: Row(children: const [
                              Icon(Icons.logout),
                              SizedBox(width: 8),
                              Text('Log Out'),
                            ]),
                          ),
                          const PopupMenuDivider(),
                        ],
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.green,
                              backgroundImage: NetworkImage(UserManager
                                          .userInfo['avatar'] ==
                                      ''
                                  ? "https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fblank_package.png?alt=media&token=f5cf4503-e36b-416a-8cce-079dfcaeae83"
                                  : UserManager.userInfo['avatar']),
                            ),
                            //Icon(Icons.arrow_downward,
                            //    size: 15, color: Colors.white)
                          ],
                        ),
                      )),
                ])
              ],
            )),
      ],
    );
  }

  Widget buildLargeSize() {
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
                        child: Row(
                          children: [
                            AnimatedOpacity(
                              duration: const Duration(microseconds: 1000),
                              curve: Curves.easeIn,
                              opacity: onHover ? 0.5 : 1,
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
                            const Padding(
                              padding: EdgeInsets.only(left: 20.0),
                            ),
                            const Text('Admin Page',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600))
                          ],
                        ))),
                Row(
                  children: [
                    Container(
                        padding: const EdgeInsets.only(right: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            onHomeClicked();
                          },
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
                Row(children: [
                  Container(
                      padding: const EdgeInsets.all(9.0),
                      child: PopupMenuButton(
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<Menu>>[
                          PopupMenuItem<Menu>(
                            onTap: () => {onLogOut()},
                            value: Menu.itemLogout,
                            child: Row(children: const [
                              Icon(Icons.logout),
                              SizedBox(width: 8),
                              Text('Log Out'),
                            ]),
                          ),
                        ],
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.green,
                              backgroundImage: NetworkImage(UserManager
                                          .userInfo['avatar'] ==
                                      ''
                                  ? "https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fblank_package.png?alt=media&token=f5cf4503-e36b-416a-8cce-079dfcaeae83"
                                  : UserManager.userInfo['avatar']),
                            ),
                            //Icon(Icons.arrow_downward,
                            //    size: 15, color: Colors.white)
                          ],
                        ),
                      )),
                ])
              ],
            )),
      ],
    );
  }
}
