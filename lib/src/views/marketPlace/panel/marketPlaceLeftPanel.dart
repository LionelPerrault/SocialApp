import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';

class MarketPlaceLeftPanel extends StatefulWidget {
  MarketPlaceLeftPanel(
      {Key? key, required this.changeCategory, required this.currentCategory})
      : super(key: key);
  Function changeCategory;
  String currentCategory;
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
      'value': 'Baby & Children\'s Product',
      'title': 'Baby & Children\'s Product',
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
        SizedBox(
          width: SizeConfig.leftBarWidth,
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
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
        color: currentCategory == label ? Colors.grey[200] : null,
        borderRadius: BorderRadius.circular(4),
      ),
      width: SizeConfig.leftBarAdminWidth,
      height: 50,
      child: RichText(
        text: TextSpan(children: <TextSpan>[
          TextSpan(
              text: label,
              style: TextStyle(
                  color: currentCategory == label
                      ? const Color.fromARGB(255, 94, 114, 228)
                      : const Color.fromARGB(255, 90, 90, 90),
                  fontSize: 14),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  onTap(label);
                })
        ]),
      ),
    );
  }
}
