// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/pages/widget/pagecell.dart';
import 'package:shnatter/src/views/products/widget/productcell.dart';

import '../../../controllers/PostController.dart';
import '../../../models/chatModel.dart';

class AllProducts extends StatefulWidget {
  AllProducts({Key? key})
      : con = PostController(),
        super(key: key);
  late PostController con;
  State createState() => AllProductsState();
}

class AllProductsState extends mvc.StateMVC<AllProducts> {
  late PostController con;
  var userInfo = UserManager.userInfo;
  var allProduct = [];
  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    con.setState(() {});
    super.initState();
    getProductNow();
  }

  void getProductNow() {
    con.getProduct().then((value) => {
          allProduct = value,
          print(allProduct),
          setState(() {}),
        });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = SizeConfig(context).screenWidth - SizeConfig.leftBarWidth;
    return Container(
      width: SizeConfig(context).screenWidth < 600
          ? SizeConfig(context).screenWidth
          : 600,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Column(
              children: allProduct
                  .map((product) => ProductCell(data: product))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
