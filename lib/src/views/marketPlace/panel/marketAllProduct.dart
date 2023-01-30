// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/marketPlace/widget/marketCell.dart';
import 'package:shnatter/src/views/products/widget/productcell.dart';

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
  State createState() => MarketAllProductState();
}

class MarketAllProductState extends mvc.StateMVC<MarketAllProduct> {
  late PostController con;
  var userInfo = UserManager.userInfo;
  var roundFlag = true;
  var allProducts = [];
  var products = [];
  bool scrollFlag = false;
  int count = 0;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    con.setState(() {});
    _scrollController.addListener(() {
      double offSet = _scrollController.offset;
      double scrollMax = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      if (scrollMax - currentScroll <= 10) {
        setState(() {
          scrollFlag = true;
        });
      }
    });

    super.initState();
    getProductNow();
    con.getProductLikes();
    if (con.allProduct == []) {
      roundFlag = false;
    }
    print('this is reload');
  }

  void getProductNow() {
    roundFlag = true;
    setState(() {});
    con.getProduct().then(
          (value) => {
            roundFlag = false,
            allProducts = con.allProduct,
            print(allProducts),
            setState(() {}),
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    if (scrollFlag == true) {
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
      switch (widget.arrayOption) {
        case 'Latest':
          allProducts.sort((a, b) => con
              .changeTimeType(d: b['data']['productDate'], type: false)
              .compareTo(con.changeTimeType(
                  d: a['data']['productDate'], type: false)));
          break;
        case 'Price High':
          allProducts.sort((a, b) => int.parse(a['data']['productPrice'])
              .compareTo(int.parse(b['data']['productPrice'])));
          break;
        case 'Price Low':
          allProducts.sort((a, b) => int.parse(b['data']['productPrice'])
              .compareTo(int.parse(a['data']['productPrice'])));
          break;
        default:
      }
      allProducts = allProducts
          .where((product) =>
              product['data']['productName'].contains(widget.searchValue) ==
              true)
          .toList();
      // ignore: prefer_is_empty
      if (allProducts.isNotEmpty) {
        if (count <= allProducts.length) {
          int totalCount = 0;
          int productCount = 0;
          productCount = allProducts.length - count;
          if (productCount < 10) {
            totalCount = count + allProducts.length - products.length;
          } else {
            totalCount = count + 10;
          }
          for (int i = count; i < totalCount; i++) {
            products.add(allProducts[i]);
            setState(() {
              count = products.length;
              scrollFlag = false;
            });
          }
        }
      }
    } else {
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
              .compareTo(con.changeTimeType(
                  d: a['data']['productDate'], type: false)));
          break;
        case 'Price High':
          allProducts.sort((a, b) => int.parse(a['data']['productPrice'])
              .compareTo(int.parse(b['data']['productPrice'])));
          break;
        case 'Price Low':
          allProducts.sort((a, b) => int.parse(b['data']['productPrice'])
              .compareTo(int.parse(a['data']['productPrice'])));
          break;
        default:
      }
      allProducts = allProducts
          .where((product) =>
              product['data']['productName'].contains(widget.searchValue) ==
              true)
          .toList();
      if (allProducts.isNotEmpty) {
        if (count <= allProducts.length) {
          print(allProducts.length);
          print(count);
          for (var i = count; i < 10; i++) {
            print(" start: $count");
            products.add(allProducts[i]);
            print("end: $count");
            print(products.length);
          }
          setState(() {
            count = 10;
          });
        }
      }
    }
    return Container(
      width: SizeConfig(context).screenWidth < 800
          ? SizeConfig(context).screenWidth
          : (SizeConfig(context).screenWidth - SizeConfig.leftBarAdminWidth) *
              0.8,
      height: 350,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: SizeConfig(context).screenWidth < 600
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: products
                          .map((product) => MarketCell(
                                data: product,
                                routerChange: widget.routerChange,
                              ))
                          .toList())
                  : GridView.count(
                      crossAxisCount:
                          SizeConfig(context).screenWidth > 1000 ? 3 : 2,
                      childAspectRatio: 2 / 3,
                      padding: const EdgeInsets.all(4.0),
                      mainAxisSpacing: 10.0,
                      shrinkWrap: true,
                      crossAxisSpacing: 10.0,
                      primary: false,
                      children: products
                          .map((product) => MarketCell(
                                data: product,
                                routerChange: widget.routerChange,
                              ))
                          .toList()),
            ),
          ],
        ),
      ),
    );
  }
}
