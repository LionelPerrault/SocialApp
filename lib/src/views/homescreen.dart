import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/models/userModel.dart';
import 'package:shnatter/src/views/panel/mainpanel.dart';
import 'package:shnatter/src/views/panel/rightpanel.dart';
import 'package:shnatter/src/views/whiteFooter.dart';

import '../utils/size_config.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, required this.routerChange})
      : con = UserController(),
        super(key: key);
  final UserController con;
  Function routerChange;

  @override
  State createState() => HomeScreenState();
}

class HomeScreenState extends mvc.StateMVC<HomeScreen>
    with SingleTickerProviderStateMixin {
  late UserController con;
  @override
  void initState() {
    add(widget.con);
    con = controller as UserController;
    super.initState();
    Stream<QuerySnapshot<TokenLogin>> stream = Helper.authdata
        .where('email', isEqualTo: UserManager.userInfo['email'])
        .snapshots();
    stream.listen((event) async {
      await con.checkAuthToken(context);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SizeConfig(context).screenWidth >
                SizeConfig.mediumScreenSize + 300
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: MainPanel(
                      routerChange: widget.routerChange,
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          SizedBox(
                            width: SizeConfig.rightPaneWidth,
                            child:
                                RightPanel(routerChange: widget.routerChange),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: rightFootbar(),
                          )
                        ],
                      ))
                ],
              )
            : Container(
                margin: const EdgeInsets.only(bottom: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MainPanel(
                      routerChange: widget.routerChange,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: RightPanel(routerChange: widget.routerChange),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: footbar(),
                    )
                  ],
                ),
              ));
  }
}
