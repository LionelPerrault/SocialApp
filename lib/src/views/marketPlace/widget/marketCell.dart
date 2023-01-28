import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';

import 'package:shnatter/src/controllers/PostController.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';

// ignore: must_be_immutable
class MarketCell extends StatefulWidget {
  MarketCell({
    super.key,
    required this.data,
    required this.routerChange,
  }) : con = PostController();
  // ignore: prefer_typing_uninitialized_variables
  var data;
  Function routerChange;
  late PostController con;
  @override
  State createState() => MarketCellState();
}

class MarketCellState extends mvc.StateMVC<MarketCell> {
  late PostController con;
  var loading = false;
  // ignore: prefer_typing_uninitialized_variables
  var product;
  var productId = '';
  var readyShow = false;
  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    super.initState();
    if (loading == false) {
      product = widget.data['data'];
    }
    loading = true;
    productId = widget.data['id'];
  }

  void _onFocusChange() {
    var future = Future.delayed(const Duration(milliseconds: 100), () {
      readyShow = !readyShow;
      setState(() {});
      print('here is getsturedetector');
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        readyShow = true;
        setState(() {});
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(10.0),
            width: SizeConfig(context).screenWidth > 800
                ? 220
                : SizeConfig(context).screenWidth * 0.9,
            height: 380,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: readyShow
                  ? [
                      const BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10.0,
                        spreadRadius: 4,
                        offset: Offset(
                          2,
                          1,
                        ),
                      )
                    ]
                  : [],
            ),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      width: SizeConfig(context).screenWidth > 800
                          ? 208
                          : SizeConfig(context).screenWidth * 0.9,
                      height: 250,
                      child: Image.network(
                          widget.data['data']['productPhoto'].isEmpty
                              ? Helper.productImage
                              : widget.data['data']['productPhoto'][0]['url'],
                          fit: BoxFit.cover),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 210, left: 10),
                      child: badges.Badge(
                        toAnimate: false,
                        shape: badges.BadgeShape.square,
                        badgeColor: const Color.fromRGBO(0, 0, 0, 0.65),
                        borderRadius: BorderRadius.circular(8),
                        badgeContent: Text(
                          'SHN ${widget.data['data']["productPrice"]}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      child: readyShow
                          ? Container(
                              // alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Color.fromRGBO(0, 0, 0, 0.4),
                              ),
                              width: SizeConfig(context).screenWidth > 800
                                  ? 208
                                  : SizeConfig(context).screenWidth * 0.9,
                              height: 250,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromRGBO(0, 0, 0, 0.9),
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(17.0)),
                                  minimumSize: const Size(70, 34),
                                  maximumSize: const Size(70, 34),
                                ),
                                onPressed: () {
                                  widget.routerChange({
                                    'router': RouteNames.products,
                                    'subRouter': widget.data["id"],
                                  });
                                },
                                child: Container(
                                  child: const Text('More',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ],
                ),
                Container(
                  width: 170,
                  margin: const EdgeInsets.only(top: 10, left: 10),
                  child: Text(
                    widget.data['data']['productName'],
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  width: 170,
                  margin: const EdgeInsets.only(top: 20, left: 13),
                  child: Text(
                    'For ${widget.data['data']["productOffer"]}',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  width: 170,
                  margin: const EdgeInsets.only(top: 10, left: 13),
                  child: Row(children: [
                    const Icon(
                      Icons.sell,
                      size: 20,
                      color: Color.fromRGBO(31, 156, 255, 1),
                    ),
                    Text(
                      'Type: ${widget.data['data']["productStatus"]}',
                      overflow: TextOverflow.ellipsis,
                    )
                  ]),
                ),
                Container(
                  width: 170,
                  margin: const EdgeInsets.only(top: 10, left: 13),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 20,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 140,
                        child: Text(
                          widget.data['data']['productLocation'],
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
