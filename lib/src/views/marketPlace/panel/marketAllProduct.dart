// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/products/widget/productcell.dart';

import '../../../controllers/PostController.dart';

// ignore: must_be_immutable
class MarketAllProduct extends StatefulWidget {
  MarketAllProduct({Key? key, required this.productCategory})
      : con = PostController(),
        super(key: key);
  late PostController con;
  String productCategory;
  State createState() => MarketAllProductState();
}

class MarketAllProductState extends mvc.StateMVC<MarketAllProduct> {
  late PostController con;
  var userInfo = UserManager.userInfo;
  var roundFlag = true;
  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    con.setState(() {});
    super.initState();
    getProductNow();
    con.getProductLikes();
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
    var screenWidth = SizeConfig(context).screenWidth - SizeConfig.leftBarWidth;
    return Container(
      width: SizeConfig(context).screenWidth < 600
          ? SizeConfig(context).screenWidth
          : 600,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: roundFlag
                ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                      width: 50,
                      height: 50,
                      margin: EdgeInsets.only(
                          top: SizeConfig(context).screenHeight * 2 / 5),
                      child: const CircularProgressIndicator(
                        color: Colors.grey,
                      ),
                    )
                  ])
                : Column(
                    children: con.allProduct
                        .map((product) => ProductCell(data: product))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
