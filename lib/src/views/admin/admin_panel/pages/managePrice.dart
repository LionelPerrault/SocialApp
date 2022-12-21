import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/controllers/AdminController.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_footer.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_header.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

// ignore: must_be_immutable

class AdminManagePrice extends StatefulWidget {
  AdminManagePrice({Key? key})
      : con = AdminController(),
        super(key: key);
  final AdminController con;
  @override
  State createState() => AdminManagePriceState();
}

class AdminManagePriceState extends mvc.StateMVC<AdminManagePrice> {
  String tab = '';
  final TextEditingController priceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig(context).screenWidth > 700
          ? SizeConfig(context).screenWidth * 0.75
          : SizeConfig(context).screenWidth,
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          width: SizeConfig(context).screenWidth > 800
              ? SizeConfig(context).screenWidth * 0.75
              : SizeConfig(context).screenWidth,
          child: generalWidget(),
        ),
      ]),
    );
  }

  Widget generalWidget() {
    return Container(
      child: Column(
        children: [
          AdminSettingHeader(
            icon: Icon(Icons.attach_money_outlined),
            pagename: 'Manage Prices',
            button: const {'flag': false},
          ),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Container(
            child: Column(children: [
              customInput(
                title: 'Price for creating a page',
                onChange: (value) {},
              ),
              customInput(
                title: 'Price for creating a product',
                onChange: (value) {},
              ),
              customInput(
                title: 'Price for creating an event',
                onChange: (value) {},
              ),
              customInput(
                title: 'Price for creating a group',
                onChange: (value) {},
              ),
              customInput(
                title: 'Price for sending friend request',
                onChange: (value) {},
              ),
              customInput(
                title: 'Price for accepting friend request',
                onChange: (value) {},
              ),
            ]),
          ),
          const Padding(padding: EdgeInsets.only(top: 20)),
          AdminSettingFooter()
        ],
      ),
    );
  }

  Widget customInput({title, onChange, controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.only(top: 10)),
        Text(
          title,
          style: const TextStyle(
              color: Color.fromRGBO(82, 95, 127, 1),
              fontSize: 13,
              fontWeight: FontWeight.w600),
        ),
        const Padding(padding: EdgeInsets.only(top: 2)),
        SizedBox(
          height: 40,
          child: TextField(
            controller: controller,
            onChanged: onChange,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(top: 10, left: 10),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.0),
              ),
            ),
          ),
        )
      ],
    );
  }
}
