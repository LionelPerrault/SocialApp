// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';
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
  @override
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
    var userInfo = UserManager.userInfo;
    con.getProduct(userInfo['uid']).then(
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: con.allProduct.isEmpty
            ? [
                Container(
                  padding: const EdgeInsets.only(top: 40),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.network(Helper.emptySVG, width: 90),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        width: 140,
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(240, 240, 240, 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: const Text(
                          'No data to show',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(108, 117, 125, 1)),
                        ),
                      ),
                    ],
                  ),
                )
              ]
            : con.allProduct
                .map((e) =>
                    ProductCell(data: e, routerChange: widget.routerChange))
                .toList(),
      ),
    );
  }
}
