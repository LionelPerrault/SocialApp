// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/products/widget/productcell.dart';

import '../../widget/realEstateCell.dart';

// ignore: must_be_immutable
class RealEstateEachScreen extends StatefulWidget {
  RealEstateEachScreen(
      {Key? key, required this.docId, required this.routerChange})
      : con = PostController(),
        super(key: key);
  final PostController con;
  String docId;
  Function routerChange;

  @override
  State createState() => RealEstateEachScreenState();
}

class RealEstateEachScreenState extends mvc.StateMVC<RealEstateEachScreen>
    with SingleTickerProviderStateMixin {
  bool loading = true;
  late PostController con;
  var userInfo = UserManager.userInfo;
  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    super.initState();
    getSelectedRealEstate(widget.docId);
  }

  void getSelectedRealEstate(String docId) {
    con.getSelectedRealEstate(docId).then((value) => {
          loading = false,
          setState(() {}),
        });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: con.realEstate == null
            ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.only(
                      top: SizeConfig(context).screenHeight * 2 / 5),
                  child: const CircularProgressIndicator(
                    color: Colors.grey,
                  ),
                )
              ])
            : Container(
                width: SizeConfig(context).screenWidth < 600
                    ? SizeConfig(context).screenWidth
                    : 600,
                child: Row(
                  children: <Widget>[
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
                            padding: const EdgeInsets.only(top: 100),
                            child: loading
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          margin: EdgeInsets.only(
                                              top: SizeConfig(context)
                                                      .screenHeight *
                                                  2 /
                                                  5),
                                          child:
                                              const CircularProgressIndicator(
                                            color: Colors.grey,
                                          ),
                                        )
                                      ])
                                : RealEstateCell(
                                    data: {
                                      'data': con.realEstate,
                                      'id': con.viewRealEstateId,
                                      'adminInfo': con.realEstateAdmin,
                                    },
                                    routerChange: widget.routerChange,
                                  ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ));
  }
}
