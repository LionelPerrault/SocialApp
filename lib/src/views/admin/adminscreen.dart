import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/routes/admin_router.dart';
import 'package:shnatter/src/views/admin/navigationbar.dart';
import '../../utils/size_config.dart';
import 'admin_panel/adminleftpanel.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State createState() => AdminScreenState();
}

class AdminScreenState extends mvc.StateMVC<AdminScreen>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();

  late AnimationController _drawerSlideController;

  bool _isDrawerOpen() {
    return _drawerSlideController.value == 1.0;
  }

  bool _isDrawerOpening() {
    return _drawerSlideController.status == AnimationStatus.forward;
  }

  bool _isDrawerClosed() {
    return _drawerSlideController.value == 0.0;
  }

  String adminAllRouter = '';
  //
  @override
  void initState() {
    super.initState();
    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
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

  @override
  void dispose() {
    _drawerSlideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawerEnableOpenDragGesture: false,
        drawer: const Drawer(),
        body: Stack(
          fit: StackFit.expand,
          children: [
            AdminShnatterNavigation(
              drawClicked: clickMenu,
            ),
            Padding(
                padding: const EdgeInsets.only(top: SizeConfig.navbarHeight),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const ClampingScrollPhysics(),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizeConfig(context).screenWidth <
                                SizeConfig.mediumScreenSize
                            ? const SizedBox()
                            : AdminLeftPanel(
                                onClick: (value) {
                                  adminAllRouter = value;
                                  setState(() {});
                                },
                              ),
                        //    : SizedBox(width: 0),
                        Expanded(
                            child: AdminRouter.adminRouter(adminAllRouter)),
                        //MainPanel(),
                      ]),
                )),
            AnimatedBuilder(
                animation: _drawerSlideController,
                builder: (context, child) {
                  return FractionalTranslation(
                      translation: SizeConfig(context).screenWidth >
                              SizeConfig.mediumScreenSize
                          ? const Offset(0, 0)
                          : Offset(_drawerSlideController.value * 0.001, 0.0),
                      child: SizeConfig(context).screenWidth >
                                  SizeConfig.mediumScreenSize ||
                              _isDrawerClosed()
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(
                                  top: SizeConfig.navbarHeight),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      color: Colors.white,
                                      width:
                                          SizeConfig(context).screenWidth > 800
                                              ? SizeConfig.leftBarWidth + 15
                                              : SizeConfig.leftBarWidth + 30,
                                      child: SingleChildScrollView(
                                        child: AdminLeftPanel(
                                          onClick: (value) {
                                            adminAllRouter = value;
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    )
                                  ])));
                }),
          ],
        ));
  }
}
