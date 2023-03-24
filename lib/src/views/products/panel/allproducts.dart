// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/products/widget/productcell.dart';

import '../../../controllers/PostController.dart';

// ignore: must_be_immutable
class AllProducts extends StatefulWidget {
  AllProducts({Key? key, required this.routerChange})
      : con = PostController(),
        super(key: key);
  late PostController con;
  Function routerChange;
  State createState() => AllProductsState();
}

class AllProductsState extends mvc.StateMVC<AllProducts> {
  late PostController con;
  var userInfo = UserManager.userInfo;
  var roundFlag = true;
  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    super.initState();
    getProductNow();
  }

  void getProductNow() {
    con.getProduct().then(
          (value) => {
            roundFlag = false,
            setState(() => {}),
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig(context).screenWidth < 600
          ? SizeConfig(context).screenWidth
          : 600,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[],
      ),
    );
  }
}
