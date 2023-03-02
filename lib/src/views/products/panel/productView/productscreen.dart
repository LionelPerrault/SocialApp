import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/products/widget/productcell.dart';

class ProductEachScreen extends StatefulWidget {
  ProductEachScreen({Key? key, required this.docId, required this.routerChange})
      : con = PostController(),
        super(key: key);
  final PostController con;
  String docId;
  Function routerChange;

  @override
  State createState() => ProductEachScreenState();
}

class ProductEachScreenState extends mvc.StateMVC<ProductEachScreen>
    with SingleTickerProviderStateMixin {
  bool loading = true;
  late PostController con;
  var userInfo = UserManager.userInfo;
  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    super.initState();
    getSelectedProduct(widget.docId);
  }

  void getSelectedProduct(String docId) {
    con.getSelectedProduct(docId).then((value) => {
          loading = false,
          setState(() {}),
          print('You get selected product info!'),
        });
  }

  @override
  Widget build(BuildContext context) {
    return con.product == null
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
              mainAxisSize: MainAxisSize.min,
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
                        padding: EdgeInsets.only(top: 100),
                        child: loading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      margin: EdgeInsets.only(
                                          top:
                                              SizeConfig(context).screenHeight *
                                                  2 /
                                                  5),
                                      child: const CircularProgressIndicator(
                                        color: Colors.grey,
                                      ),
                                    )
                                  ])
                            : ProductCell(
                                data: {
                                  'data': con.product,
                                  'id': con.viewProductId,
                                  'adminInfo': con.productAdmin,
                                },
                                routerChange: widget.routerChange,
                              ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
