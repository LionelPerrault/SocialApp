// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';

import '../../../controllers/PostController.dart';
import '../widget/realEstateCell.dart';

// ignore: must_be_immutable
class RealEstateAllProduct extends StatefulWidget {
  RealEstateAllProduct({
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
  State createState() => RealEstateAllProductState();
}

class RealEstateAllProductState extends mvc.StateMVC<RealEstateAllProduct> {
  late PostController con;
  var userInfo = UserManager.userInfo;
  var roundFlag = true;
  var allRealEstates = [];
  var realEstates = [];
  int count = 0;
  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;

    super.initState();
    getRealEstateNow();
    if (con.allProduct == []) {
      roundFlag = false;
    }
  }

  void getRealEstateNow() {
    roundFlag = true;
    setState(() {});
    con.getRealEstate().then(
          (value) => {
            roundFlag = false,
            allRealEstates = con.allRealEstate,
            setState(() {}),
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.productCategory != 'All') {
      allRealEstates = con.allRealEstate.toList();
    } else {
      allRealEstates = con.allRealEstate;
    }
    switch (widget.arrayOption) {
      case 'Latest':
        allRealEstates.sort((a, b) => con
            .changeTimeType(d: b['data']['realEstateDate'], type: false)
            .compareTo(con.changeTimeType(
                d: a['data']['realEstateDate'], type: false)));
        break;
      case 'Price High':
        allRealEstates.sort((a, b) => int.parse(a['data']['realEstatePrice'])
            .compareTo(int.parse(b['data']['realEstatePrice'])));
        break;
      case 'Price Low':
        allRealEstates.sort((a, b) => int.parse(b['data']['realEstatePrice'])
            .compareTo(int.parse(a['data']['realEstatePrice'])));
        break;
      default:
    }
    allRealEstates = allRealEstates
        .where((product) =>
            product['data']['realEstateName'].contains(widget.searchValue) ==
            true)
        .toList();
    return SizedBox(
      width: SizeConfig(context).screenWidth < 800
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
                    children: allRealEstates
                        .map((realEstate) => RealEstateCell(
                              data: realEstate,
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
                    children: allRealEstates
                        .map((realEstate) => RealEstateCell(
                              data: realEstate,
                              routerChange: widget.routerChange,
                            ))
                        .toList()),
          ),
        ],
      ),
    );
  }
}