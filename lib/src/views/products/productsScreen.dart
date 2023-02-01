import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/views/box/searchbox.dart';
import 'package:shnatter/src/views/chat/chatScreen.dart';
import 'package:shnatter/src/views/navigationbar.dart';
import 'package:shnatter/src/views/panel/leftpanel.dart';
import 'package:shnatter/src/views/products/panel/allproducts.dart';
import 'package:shnatter/src/widget/createProductWidget.dart';

import '../../controllers/PostController.dart';
import '../../utils/size_config.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';

class ProductsScreen extends StatefulWidget {
  ProductsScreen({Key? key, required this.routerChange})
      : con = PostController(),
        super(key: key);
  final PostController con;
  Function routerChange;

  @override
  State createState() => ProductsScreenState();
}

class ProductsScreenState extends mvc.StateMVC<ProductsScreen>
    with SingleTickerProviderStateMixin {
  //route variable
  String pageSubRoute = '';
  late PostController con;

  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  width: SizeConfig(context).screenWidth >
                          SizeConfig.mediumScreenSize
                      ? 700
                      : SizeConfig(context).screenWidth > 600
                          ? 600
                          : SizeConfig(context).screenWidth,
                  child: Column(
                    children: [
                      Container(
                          height: 70,
                          child: Row(
                            children: [
                              Container(
                                child: const Text(
                                  'My Products',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Flexible(
                                  fit: FlexFit.tight, child: SizedBox()),
                              Container(
                                width: SizeConfig(context).screenWidth >
                                        SizeConfig.mediumScreenSize
                                    ? 160
                                    : 50,
                                margin: const EdgeInsets.only(right: 20),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(3),
                                      backgroundColor: Colors.white,
                                      // elevation: 3,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(3.0)),
                                      minimumSize: Size(
                                          SizeConfig(context).screenWidth >
                                                  SizeConfig.mediumScreenSize
                                              ? 170
                                              : 50,
                                          50),
                                      maximumSize: Size(
                                          SizeConfig(context).screenWidth >
                                                  SizeConfig.mediumScreenSize
                                              ? 170
                                              : 50,
                                          50),
                                    ),
                                    onPressed: () {
                                      (showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                  title: Row(
                                                    children: const [
                                                      Icon(
                                                        Icons
                                                            .production_quantity_limits_sharp,
                                                        color: Color.fromARGB(
                                                            255, 33, 150, 243),
                                                      ),
                                                      Text(
                                                        'Add New Product',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15,
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      ),
                                                    ],
                                                  ),
                                                  content: CreateProductModal(
                                                    context: context,
                                                    routerChange:
                                                        widget.routerChange,
                                                  ))));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.add_circle,
                                          color: Colors.black,
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.only(left: 4)),
                                        SizeConfig(context).screenWidth >
                                                SizeConfig.mediumScreenSize
                                            ? const Text('Add New Product',
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold))
                                            : SizedBox()
                                      ],
                                    )),
                              )
                            ],
                          )),
                      Container(
                        width: SizeConfig(context).screenWidth >
                                SizeConfig.mediumScreenSize
                            ? 700
                            : SizeConfig(context).screenWidth > 600
                                ? 600
                                : SizeConfig(context).screenWidth,
                        child: const Divider(
                          thickness: 0.1,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
                AllProducts(
                  routerChange: widget.routerChange,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
