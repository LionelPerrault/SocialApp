// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/marketPlace/widget/marketCell.dart';
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
  var allProducts = [];
  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    con.setState(() {});
    super.initState();
    getProductNow();
    con.getProductLikes();
    if (con.allProduct.isEmpty) {
      roundFlag = false;
    }
    print('this is reload');
  }

  void getProductNow() {
    con.getProduct().then(
          (value) => {
            if (con.allProduct.isEmpty)
              {
                roundFlag = false,
              },
            allProducts = con.allProduct,
            setState(() {}),
            setState(() => {}),
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.productCategory != 'All') {
      allProducts = con.allProduct
          .where((element) =>
              element['data']['productCategory'] == widget.productCategory)
          .toList();
      print(widget.productCategory);
      print(allProducts);
    } else {
      allProducts = con.allProduct;
    }

    var screenWidth = SizeConfig(context).screenWidth - SizeConfig.leftBarWidth;
    return Container(
      width: SizeConfig(context).screenWidth < 800
          ? SizeConfig(context).screenWidth
          : (SizeConfig(context).screenWidth - SizeConfig.leftBarAdminWidth) *
              0.8,
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
                : GridView.count(
                    crossAxisCount: screenWidth > 800
                        ? 3
                        : screenWidth > 600
                            ? 2
                            : 1,
                    childAspectRatio: 1 / 2,
                    padding: const EdgeInsets.all(4.0),
                    mainAxisSpacing: 10.0,
                    shrinkWrap: true,
                    crossAxisSpacing: 10.0,
                    primary: false,
                    children: allProducts
                        .map((product) => MarketCell(data: product))
                        .toList()),
          ),
        ],
      ),
    );
  }
}
