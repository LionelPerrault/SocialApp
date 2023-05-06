// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';

import '../../../controllers/PostController.dart';
import '../widget/marketCell2.dart';

// ignore: must_be_immutable
class RealEstateAllProduct extends StatefulWidget {
  RealEstateAllProduct({
    Key? key,
    required this.realEstateCategory,
    required this.arrayOption,
    required this.searchValue,
    required this.routerChange,
  })  : con = PostController(),
        super(key: key);
  late PostController con;
  String realEstateCategory;
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
    if (con.allRealEstate == []) {
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
    allRealEstates = con.allRealEstate;

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
        .where((realEstate) =>
            realEstate['data']['realEstateName'].contains(widget.searchValue) ==
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
                    children: allRealEstates.isEmpty
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
                            )
                          ]
                        : allRealEstates
                            .map((realEstate) => MarketCell2(
                                  data: realEstate,
                                  routerChange: widget.routerChange,
                                ))
                            .toList())
                : allRealEstates.isEmpty
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
                            SizeConfig(context).screenWidth > 1000 ? 3 : 2,
                        childAspectRatio: 2 / 3,
                        padding: const EdgeInsets.all(4.0),
                        mainAxisSpacing: 10.0,
                        shrinkWrap: true,
                        crossAxisSpacing: 10.0,
                        primary: false,
                        children: allRealEstates
                            .map((realEstate) => MarketCell2(
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
