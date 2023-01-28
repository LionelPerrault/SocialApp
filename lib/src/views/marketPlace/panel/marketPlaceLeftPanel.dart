import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/widget/createProductWidget.dart';

class MarketPlaceLeftPanel extends StatefulWidget {
  MarketPlaceLeftPanel(
      {Key? key,
      required this.changeCategory,
      required this.currentCategory,
      required this.routerChange})
      : super(key: key);
  Function changeCategory;
  String currentCategory;
  Function routerChange;
  State createState() => MarketPlaceLeftPanelState();
}

class MarketPlaceLeftPanelState extends mvc.StateMVC<MarketPlaceLeftPanel> {
  late List productCategory = [
    {
      'value': 'All',
      'title': 'All',
      'onTap': (value) {
        widget.changeCategory(value);
      },
    },
    {
      'value': 'Apparel & Accessories',
      'title': 'Apparel & Accessories',
      'onTap': (value) {
        widget.changeCategory(value);
      },
    },
    {
      'value': 'Autos & Vehicles',
      'title': 'Autos & Vehicles',
      'onTap': (value) {
        widget.changeCategory(value);
      },
    },
    {
      'value': 'Baby & Children\'s',
      'title': 'Baby & Children\'s',
      'onTap': (value) {
        widget.changeCategory(value);
      },
    },
    {
      'value': 'Beauty Products & Services',
      'title': 'Beauty Products & Services',
      'onTap': (value) {
        widget.changeCategory(value);
      },
    },
    {
      'value': 'Computers & Peripherals',
      'title': 'Computers & Peripherals',
      'onTap': (value) {
        widget.changeCategory(value);
      },
    },
    {
      'value': 'Consumer Electronics',
      'title': 'Consumer Electronics',
      'onTap': (value) {
        widget.changeCategory(value);
      },
    },
    {
      'value': 'Dating Services',
      'title': 'Dating Services',
      'onTap': (value) {
        widget.changeCategory(value);
      },
    },
    {
      'value': 'Financial Services',
      'title': 'Financial Services',
      'onTap': (value) {
        widget.changeCategory(value);
      },
    },
    {
      'value': 'Gifts & Occasions',
      'title': 'Gifts & Occasions',
      'onTap': (value) {
        widget.changeCategory(value);
      },
    },
    {
      'value': 'Home & Garden',
      'title': 'Home & Garden',
      'onTap': (value) {
        widget.changeCategory(value);
      },
    },
    {
      'value': 'Other',
      'title': 'Other',
      'onTap': (value) {
        widget.changeCategory(value);
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 30),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(3),
              backgroundColor: const Color.fromARGB(255, 33, 37, 41),
              // elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              minimumSize: Size(200, 40),
              maximumSize: Size(200, 40),
            ),
            onPressed: () {
              (showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                      title: Row(
                        children: const [
                          Icon(
                            Icons.production_quantity_limits_sharp,
                            color: Color.fromARGB(255, 33, 150, 243),
                          ),
                          Text(
                            'Add New Product',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                      content: CreateProductModal(
                        context: context,
                        routerChange: widget.routerChange,
                      ))));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.production_quantity_limits,
                  color: Colors.white,
                  size: 20,
                ),
                const Padding(padding: EdgeInsets.only(left: 4)),
                SizeConfig(context).screenWidth > SizeConfig.mediumScreenSize
                    ? const Text('Add New Product',
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.bold))
                    : SizedBox()
              ],
            ),
          ),
        ),
        Container(
          width: SizeConfig.leftBarWidth,
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: productCategory
                .map((e) => CategoryCell(
                    e['title'], e['onTap'], widget.currentCategory))
                .toList(),
          ),
        )
      ],
    );
  }

  Widget CategoryCell(label, onTap, currentCategory) {
    return GestureDetector(
      onTap: () {
        onTap(label);
      },
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
          color: currentCategory == label ? Colors.grey[200] : null,
          borderRadius: BorderRadius.circular(4),
        ),
        width: SizeConfig.leftBarAdminWidth,
        height: 50,
        child: Text(
          label,
          style: TextStyle(
              color: currentCategory == label
                  ? const Color.fromARGB(255, 94, 114, 228)
                  : const Color.fromARGB(255, 90, 90, 90),
              fontSize: 14),
        ),
      ),
    );
  }
}
