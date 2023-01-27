import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/utils/svg.dart';
import 'package:shnatter/src/widget/alertYesNoWidget.dart';
import 'package:shnatter/src/widget/createProductWidget.dart';
import 'package:shnatter/src/widget/likesCommentWidget.dart';
import 'package:shnatter/src/views/messageBoard/messageScreen.dart';

// ignore: must_be_immutable
class ProductCell extends StatefulWidget {
  ProductCell({
    super.key,
    required this.data,
  }) : con = PostController();
  var data;

  late PostController con;
  @override
  State createState() => ProductCellState();
}

class ProductCellState extends mvc.StateMVC<ProductCell> {
  late PostController con;
  var product;
  var productId = '';
  bool payLoading = false;
  bool loading = false;

  late List<Map> subFunctionList = [
    {
      'icon': product['productMarkAsSold']
          ? Icons.shopping_cart
          : Icons.shopping_cart,
      'text':
          product['productMarkAsSold'] ? 'Mark as Available' : 'Mark as Sold',
      'onTap': () {
        con
            .productMarkAsSold(productId, !product['productMarkAsSold'])
            .then((value) => {
                  con.getProduct().then((value) => {
                        product = con.allProduct
                            .where((val) => val['id'] == widget.data['id'])
                            .toList()[0]['data'],
                        print(product),
                        setState(() {}),
                        Helper.setting.notifyListeners(),
                      })
                });
      },
    },
    {
      'icon': product['productMarkAsSold'] ? Icons.bookmark : Icons.bookmark,
      'text': product['productMarkAsSold'] ? 'UnSave Post' : 'Save Post',
      'onTap': () {
        con
            .productSavePost(productId, !product['productMarkAsSold'])
            .then((value) => {
                  con.getProduct().then((value) => {
                        product = con.allProduct
                            .where((val) => val['id'] == widget.data['id'])
                            .toList()[0]['data'],
                        print(product),
                        setState(() {}),
                        Helper.setting.notifyListeners(),
                      })
                });
      },
    },
    {
      'icon': Icons.pin_drop,
      'text': 'Pin Post',
      'onTap': () {},
    },
    {
      'icon': Icons.edit,
      'text': 'Edit Product',
      'onTap': () {
        showDialog(
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
                content: CreateProductModal(context: context)));
      },
    },
    {
      'icon': Icons.delete,
      'text': 'Delete Post',
      'onTap': () {
        con.productDelete(productId).then((value) => {
              con.getProduct().then((value) => {
                    product = con.allProduct
                        .where((val) => val['id'] == widget.data['id'])
                        .toList()[0]['data'],
                    print(product),
                    setState(() {}),
                    Helper.setting.notifyListeners(),
                  })
            });
      },
    },
    {
      'icon': Icons.remove_red_eye,
      'text': product['productTimeline']
          ? 'Hide from Timeline'
          : 'Allow on Timeline',
      'onTap': () {
        con
            .productHideFromTimeline(productId, !product['productTimeline'])
            .then((value) => {
                  con.getProduct().then((value) => {
                        product = con.allProduct
                            .where((val) => val['id'] == widget.data['id'])
                            .toList()[0]['data'],
                        print(product),
                        setState(() {}),
                        Helper.setting.notifyListeners(),
                      })
                });
      },
    },
    {
      'icon': Icons.comment,
      'text': product['productOnOffCommenting']
          ? 'Turn off Commenting'
          : 'Trun on Commenting',
      'onTap': () {
        con
            .productTurnOffCommenting(productId, !product['productTimeline'])
            .then((value) => con.getProduct().then((value) => {
                  product = con.allProduct
                      .where((val) => val['id'] == widget.data['id'])
                      .toList()[0]['data'],
                  print(product),
                  setState(() {}),
                  Helper.setting.notifyListeners(),
                }));
      },
    },
    {
      'icon': Icons.link,
      'text': 'Open Post in new Tab',
      'onTap': () {
        Navigator.pushReplacementNamed(
            context, '${RouteNames.products}/${productId}');
      },
    },
  ];

  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    super.initState();
    product = widget.data['data'];
    productId = widget.data['id'];
    con.formatDate(product['productDate']);
    print('initstate');
  }

  buyProduct() async {
    var eventAdminInfo =
        await ProfileController().getUserInfo(product['productAdmin']['uid']);
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const SizedBox(),
        content: AlertYesNoWidget(
            yesFunc: () async {
              payLoading = true;
              setState(() {});
              await UserController()
                  .payShnToken(eventAdminInfo!['paymail'].toString(),
                      product['productPrice'], 'Pay for buy product')
                  .then(
                    (value) async => {
                      if (value)
                        {
                          payLoading = false,
                          setState(() {}),
                          Navigator.of(context).pop(true),
                          loading = true,
                          setState(() {}),
                          await con.changeProductSellState(productId),
                          loading = false,
                          setState(() {}),
                        }
                    },
                  );
            },
            noFunc: () {
              Navigator.of(context).pop(true);
            },
            header: 'Pay Token',
            text: 'Are you sure about pay token',
            progress: payLoading),
      ),
    );
  }

  popUpFunction(value) async {
    var functionContainer =
        subFunctionList.where((element) => element['text'] == value).toList();
    functionContainer[0]['onTap']();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Container(
          margin: const EdgeInsets.only(top: 30, bottom: 30),
          width: 600,
          padding: const EdgeInsets.only(top: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            child: SvgPicture.network(Helper.avatar),
                          ),
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 10),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: product['productAdmin']
                                                  ['fullName'],
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  print('username');
                                                  Navigator.pushReplacementNamed(
                                                      context,
                                                      '/${product['productAdmin']['userName']}');
                                                })
                                        ]),
                                  ),
                                  Container(
                                    width: SizeConfig(context).screenWidth < 600
                                        ? SizeConfig(context).screenWidth - 240
                                        : 350,
                                    child: Text(
                                      ' added new ${product["productCategory"]} products item for ${product["productOffer"]}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  Container(
                                      padding: EdgeInsets.only(right: 9.0),
                                      child: PopupMenuButton(
                                        onSelected: (value) {
                                          popUpFunction(value);
                                        },
                                        child: Icon(
                                          Icons.arrow_drop_down,
                                        ),
                                        itemBuilder: (BuildContext bc) {
                                          return subFunctionList
                                              .map(
                                                (e) => PopupMenuItem(
                                                  value: e['text'],
                                                  child: listCell(
                                                      e['icon'], e['text']),
                                                ),
                                              )
                                              .toList();
                                        },
                                      )),
                                ],
                              ),
                              const Padding(padding: EdgeInsets.only(top: 3)),
                              Row(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 10),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: '',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.pushReplacementNamed(
                                                      context,
                                                      '${RouteNames.products}/$productId');
                                                })
                                        ]),
                                  ),
                                  const Text(' - '),
                                  const Icon(
                                    Icons.language,
                                    size: 12,
                                  )
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(top: 15)),
                      Text(
                        product['productName'],
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Padding(padding: EdgeInsets.only(top: 30)),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.grey,
                            size: 20,
                          ),
                          Text(
                            product['productLocation'] ?? '',
                            style: const TextStyle(color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(top: 30)),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          product['productAbout'] ?? '',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 30)),
                      Container(
                        height: 78,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 247, 247, 247),
                          border: Border.all(
                              color: const Color.fromARGB(255, 229, 229, 229)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(7.0)),
                        ),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Container(
                                alignment: Alignment.center,
                                child: Column(children: [
                                  const Padding(
                                      padding: EdgeInsets.only(top: 20)),
                                  const Text(
                                    'Offer',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 5)),
                                  Text(
                                    'For ${product['productOffer']}',
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ]),
                              )),
                              Container(
                                width: 1,
                                height: 60,
                                color: const Color.fromARGB(255, 229, 229, 229),
                              ),
                              Expanded(
                                  child: Container(
                                alignment: Alignment.center,
                                child: Column(children: [
                                  const Padding(
                                      padding: EdgeInsets.only(top: 20)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.sell,
                                        color:
                                            Color.fromARGB(255, 31, 156, 255),
                                        size: 17,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 5)),
                                      Text(
                                        'Condition',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 5)),
                                  Text(
                                    '${product['productStatus']}',
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ]),
                              )),
                              Container(
                                width: 1,
                                height: 60,
                                color: const Color.fromARGB(255, 229, 229, 229),
                              ),
                              Expanded(
                                  child: Container(
                                alignment: Alignment.center,
                                child: Column(children: [
                                  const Padding(
                                      padding: EdgeInsets.only(top: 20)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.money,
                                        color: Color.fromARGB(255, 43, 180, 40),
                                        size: 17,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 5)),
                                      Text(
                                        'Price',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 5)),
                                  Text(
                                    '${product['productPrice']} (SHN)',
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ]),
                              )),
                              Container(
                                width: 1,
                                height: 60,
                                color: const Color.fromARGB(255, 229, 229, 229),
                              ),
                              Expanded(
                                  child: Container(
                                alignment: Alignment.center,
                                child: Column(children: [
                                  const Padding(
                                      padding: EdgeInsets.only(top: 20)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.gif_box,
                                        color:
                                            Color.fromARGB(255, 160, 56, 178),
                                        size: 17,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 5)),
                                      Text(
                                        'Status',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 5)),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 90,
                                    height: 25,
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 40, 167, 69),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4.0)),
                                    ),
                                    child: const Text(
                                      'In Stock',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  )
                                ]),
                              )),
                            ]),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: UserManager.userInfo['userName'] ==
                                      product['productAdmin']['userName']
                                  ? 0
                                  : 30)),
                      UserManager.userInfo['userName'] ==
                              product['productAdmin']['userName']
                          ? Container()
                          : Container(
                              height: 50,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 17, 205, 239),
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(3.0)),
                                  ),
                                  onPressed: () {
                                    if (UserManager.userInfo['uid'] !=
                                        widget.data["data"]["productAdmin"]
                                            ["uid"]) {
                                      Navigator.pushNamed(
                                        context,
                                        RouteNames.messages,
                                        arguments: widget.data["data"]
                                                ["productAdmin"]["uid"]
                                            .toString(),
                                      );
                                    }
                                    setState(() {
                                      // stepflag = true;
                                    });
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.wechat_outlined),
                                      Padding(
                                          padding: EdgeInsets.only(left: 10)),
                                      Text(
                                        'Contact',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )),
                            ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Container(
                        height: 50,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 240, 96, 63),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3.0)),
                            ),
                            onPressed: () {
                              buyProduct();
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.wechat_outlined),
                                Padding(padding: EdgeInsets.only(left: 10)),
                                Text(
                                  'Buy',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            )),
                      ),
                    ]),
              ),
              LikesCommentScreen(productId: productId)
            ],
          ),
        ))
      ],
    );
  }

  Widget SubFunction() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Container(
          width: 250,
          color: Colors.white,
          // padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 400,
                child: ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  children: subFunctionList
                      .map((list) => listCell(
                            list['icon'],
                            list['text'],
                          ))
                      .toList(),
                ),
              )
            ],
          )),
    );
  }

  Widget listCell(icon, text) {
    return ListTile(
        hoverColor: Colors.grey[100],
        tileColor: Colors.white,
        enabled: true,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Colors.grey,
              size: 20,
            ),
            const Padding(padding: EdgeInsets.only(left: 10)),
            Column(
              children: [
                const Padding(padding: EdgeInsets.only(top: 3)),
                Text(text,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 12)),
              ],
            ),
          ],
        ));
  }
}
