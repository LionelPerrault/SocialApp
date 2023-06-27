import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shnatter/src/controllers/AdminController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/utils/size_config.dart';

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
  Map<String, dynamic> adminConfig = {};

  @override
  void initState() {
    getAdminConfig();
    super.initState();
  }

  getAdminConfig() async {
    var adminSnap = await FirebaseFirestore.instance
        .collection(Helper.adminPanel)
        .doc(Helper.adminConfig)
        .get();
    adminConfig = adminSnap.data()!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: SizeConfig(context).screenWidth > 700
          ? SizeConfig(context).screenWidth * 0.75
          : SizeConfig(context).screenWidth,
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            width: SizeConfig(context).screenWidth > 800
                ? SizeConfig(context).screenWidth * 0.75
                : SizeConfig(context).screenWidth,
            child: generalWidget(),
          ),
        ],
      ),
    );
  }

  Widget generalWidget() {
    return Column(
      children: [
        AdminSettingHeader(
          icon: const Icon(Icons.attach_money_outlined),
          pagename: 'Manage Prices',
          button: const {'flag': false},
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Column(children: [
          customInput(
            title: 'Price of token reward',
            onChange: (value) async {
              adminConfig['priceTokenReward'] = value;
            },
            value: adminConfig['priceTokenReward'] ?? '',
          ),
          customInput(
            title: 'Price for creating a page',
            onChange: (value) async {
              adminConfig['priceCreatingPage'] = value;
            },
            value: adminConfig['priceCreatingPage'] ?? '',
          ),
          customInput(
            title: 'Price for creating a product',
            onChange: (value) async {
              adminConfig['priceCreatingProduct'] = value;
            },
            value: adminConfig['priceCreatingProduct'] ?? '',
          ),
          customInput(
            title: 'Price for creating a real estate',
            onChange: (value) async {
              adminConfig['priceCreatingRealEstate'] = value;
            },
            value: adminConfig['priceCreatingRealEstate'] ?? '',
          ),
          customInput(
            title: 'Price for creating an event',
            onChange: (value) async {
              adminConfig['priceCreatingEvent'] = value;
            },
            value: adminConfig['priceCreatingEvent'] ?? '',
          ),
          customInput(
            title: 'Price for creating a group',
            onChange: (value) async {
              adminConfig['priceCreatingGroup'] = value;
            },
            value: adminConfig['priceCreatingGroup'] ?? '',
          ),
          customInput(
            title: 'Price for sending friend request',
            onChange: (value) async {
              adminConfig['priceSendingFriendRquest'] = value;
            },
            value: adminConfig['priceSendingFriendRquest'] ?? '',
          ),
          customInput(
            title: 'Price for accepting friend request',
            onChange: (value) async {
              adminConfig['priceReceiveFriendRquest'] = value;
            },
            value: adminConfig['priceReceiveFriendRquest'] ?? '',
          ),
        ]),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
              height: 65,
              decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(
                  color: Color.fromARGB(255, 220, 226, 237),
                  width: 1,
                )),
                color: Color.fromARGB(255, 240, 243, 246),
                // borderRadius: BorderRadius.all(Radius.circular(3)),
              ),
              child: Row(
                children: [
                  const Flexible(fit: FlexFit.tight, child: SizedBox()),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(3),
                        backgroundColor: Colors.white,
                        // elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0)),
                        minimumSize: const Size(120, 50),
                        maximumSize: const Size(120, 50),
                      ),
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection(Helper.adminPanel)
                            .doc(Helper.adminConfig)
                            .update(adminConfig);
                        Helper.showToast("Price changed");
                      },
                      child: const Text('Save Changes',
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  const Padding(padding: EdgeInsets.only(right: 30))
                ],
              )),
        )
      ],
    );
  }

  Widget customInput({title, onChange, value}) {
    var controller = TextEditingController();
    controller.text = value;
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
