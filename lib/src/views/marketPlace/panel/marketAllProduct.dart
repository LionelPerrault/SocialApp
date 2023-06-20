// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/marketPlace/widget/marketCell.dart';

import '../../../controllers/PostController.dart';

// ignore: must_be_immutable
class MarketAllProduct extends StatefulWidget {
  MarketAllProduct({
    Key? key,
    required this.productCategory,
    required this.arrayOption,
    required this.searchValue,
    required this.routerChange,
  })  : con = PostController(),
        super(key: key);
  late PostController con;
  String productCategory;
  String arrayOption;
  String searchValue;
  Function routerChange;
  @override
  State createState() => MarketAllProductState();
}

class MarketAllProductState extends mvc.StateMVC<MarketAllProduct> {
  late PostController con;
  var userInfo = UserManager.userInfo;
  var roundFlag = true;
  var allProducts = [];
  var products = [];
  int count = 0;
  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;

    super.initState();
    getProductNow();
    if (con.allProduct == []) {
      roundFlag = false;
    }
  }

  void getProductNow() {
    roundFlag = true;
    setState(() {});
    con.getProduct().then(
          (value) => {
            roundFlag = false,
            allProducts = con.allProduct,
            setState(() {}),
          },
        );
  }

  removeShow() {
    for (var i = 0; i < allProducts.length; i++) {
      allProducts[i]['state'] = false;
    }
    print(allProducts);
    setState(() {});
    print('object');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.productCategory != 'All') {
      allProducts = con.allProduct
          .where((element) =>
              element['data']['productCategory'] == widget.productCategory)
          .toList();
    } else {
      allProducts = con.allProduct;
    }
    switch (widget.arrayOption) {
      case 'Latest':
        allProducts.sort((a, b) => con
            .changeTimeType(d: b['data']['productDate'], type: false)
            .compareTo(
                con.changeTimeType(d: a['data']['productDate'], type: false)));
        break;
      case 'Price High':
        allProducts.sort((a, b) => int.parse(b['data']['productPrice'])
            .compareTo(int.parse(a['data']['productPrice'])));
        break;
      case 'Price Low':
        allProducts.sort((a, b) => int.parse(a['data']['productPrice'])
            .compareTo(int.parse(b['data']['productPrice'])));
        break;
      default:
    }
    allProducts = allProducts
        .where((product) =>
            product['data']['productName'].contains(widget.searchValue) == true)
        .toList();
    return SizedBox(
      width: SizeConfig(context).screenWidth < SizeConfig.mediumScreenSize
          ? SizeConfig(context).screenWidth
          : (SizeConfig(context).screenWidth - SizeConfig.leftBarAdminWidth) *
              0.8,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: SizeConfig(context).screenWidth < 600
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: allProducts.isEmpty
                        ? [
                            Container(
                              padding: const EdgeInsets.only(top: 40),
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.network(Helper.emptySVG,
                                      width: 90),
                                  Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(top: 10),
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    width: 140,
                                    decoration: const BoxDecoration(
                                        color: Color.fromRGBO(240, 240, 240, 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: const Text(
                                      'No data to show',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromRGBO(108, 117, 125, 1)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]
                        : allProducts.map((product) {
                            clicked() {
                              removeShow();
                              if (product['state'] == true) {
                                product['state'] = false;
                              } else {
                                product['state'] = true;
                              }
                              setState(() {});
                            }

                            return MarketCell(
                              clicked: clicked,
                              data: product,
                              routerChange: widget.routerChange,
                            );
                          }).toList(),
                  )
                : allProducts.isEmpty
                    ? Container(
                        padding: const EdgeInsets.only(top: 40),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.network(Helper.emptySVG, width: 90),
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(top: 10),
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
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
                    : GridView.count(
                        crossAxisCount:
                            SizeConfig(context).screenWidth > 1200 ? 3 : 2,
                        childAspectRatio: 2 / 3,
                        padding: const EdgeInsets.all(4.0),
                        mainAxisSpacing: 10.0,
                        shrinkWrap: true,
                        crossAxisSpacing: 10.0,
                        primary: false,
                        children: allProducts.map((product) {
                          clicked() {
                            removeShow();
                            if (product['state'] == true) {
                              product['state'] = false;
                            } else {
                              product['state'] = true;
                            }
                            setState(() {});
                          }

                          return MarketCell(
                            data: product,
                            clicked: clicked,
                            routerChange: widget.routerChange,
                          );
                        }).toList()),
          ),
        ],
      ),
    );
  }
}
