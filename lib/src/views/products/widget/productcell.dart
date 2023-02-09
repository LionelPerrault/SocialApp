// ignore_for_file: use_build_context_synchronously
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/widget/alertYesNoWidget.dart';
import 'package:shnatter/src/widget/createProductWidget.dart';
import 'package:shnatter/src/widget/likesCommentWidget.dart';
import 'package:shnatter/src/views/messageBoard/messageScreen.dart';

// ignore: must_be_immutable
class ProductCell extends StatefulWidget {
  ProductCell({
    super.key,
    required this.data,
    required this.routerChange,
  }) : con = PostController();
  var data;
  Function routerChange;
  late PostController con;
  @override
  State createState() => ProductCellState();
}

class ProductCellState extends mvc.StateMVC<ProductCell> {
  late PostController con;
  var product;
  Map productAdmin = {};
  var productId = '';
  bool payLoading = false;
  bool loading = false;
  var postTime = '';
  var messsageScreen = MessageScreenState();

  List<Map> popupMenuItem = [
    {
      'icon': Icons.edit,
      'label': 'Edit Product',
      'value': 'edit',
    },
    {
      'icon': Icons.delete,
      'label': 'Delete Product',
      'value': 'delete',
    },
    {
      'icon': Icons.remove_red_eye_sharp,
      'label': 'Hide from Timeline',
      'labelE': 'Allow on Timeline',
      'value': 'timeline',
    },
    {
      'icon': Icons.chat_bubble,
      'label': 'Turn off Commenting',
      'labelE': 'Turn on Commenting',
      'value': 'comment',
    },
    {
      'icon': Icons.link,
      'label': 'Open post in new tab',
      'value': 'open',
    },
  ];

  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    super.initState();
    product = widget.data['data'];
    productAdmin = widget.data['adminInfo'];
    productId = widget.data['id'];
    con.formatDate(product['productDate']).then((value) {
      postTime = value;
      setState(() {});
    });
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
                      if (value = true)
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
                      else
                        {
                          payLoading = false,
                          setState(() {}),
                          Navigator.of(context).pop(true),
                          setState(() {}),
                          loading = true,
                          setState(() {})
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
    switch (value) {
      case 'edit':
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
            content: CreateProductModal(
              context: context,
              routerChange: widget.routerChange,
              editData: widget.data,
            ),
          ),
        );
        setState(() {});
        break;
      case 'delete':
        deleteProductInfo();
        break;
      case 'timeline':
        hideFromTimeline();
        break;
      case 'comment':
        upDateProductInfo(
            {'productOnOffCommenting': !product['productOnOffCommenting']});
        product['productOnOffCommenting'] = !product['productOnOffCommenting'];
        setState(() {});
        break;
      case 'open':
        widget.routerChange({
          'router': RouteNames.products,
          'subRouter': productId,
        });
        break;
      default:
    }
  }

  upDateProductInfo(value) async {
    con.updateProductInfo(productId, value);
  }

  deleteProductInfo() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const SizedBox(),
        content: AlertYesNoWidget(
            yesFunc: () async {
              con.deleteProduct(productId);
              Navigator.of(context).pop(true);
            },
            noFunc: () {
              Navigator.of(context).pop(true);
            },
            header: 'Delete Product',
            text: 'Are you sure you want to delete this product?',
            progress: false),
      ),
    );
  }

  hideFromTimeline() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const SizedBox(),
        content: AlertYesNoWidget(
            yesFunc: () async {
              upDateProductInfo(
                  {'productTimeline': !product['productTimeline']});
              product['productTimeline'] = !product['productTimeline'];
              setState(() {});
              Navigator.of(context).pop(true);
            },
            noFunc: () {
              Navigator.of(context).pop(true);
            },
            header: 'Hide from Timeline',
            text:
                'Are you sure you want to hide this post from your profile timeline? It may still appear in other places like newsfeed and search results',
            progress: false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return product['productTimeline'] == false
        ? DottedBorder(
            borderType: BorderType.RRect,
            radius: Radius.circular(20),
            dashPattern: [10, 10],
            color: Colors.grey,
            strokeWidth: 2,
            child: productWidget(),
          )
        : productWidget();
  }

  Widget productWidget() {
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
                          productAdmin['avatar'] != ''
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                  productAdmin['avatar'],
                                ))
                              : CircleAvatar(
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
                                              text:
                                                  '${productAdmin['firstName']} ${productAdmin['lastName']}',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  print('username');
                                                  widget.routerChange({
                                                    'router':
                                                        RouteNames.profile,
                                                    'subRouter': productAdmin[
                                                        'userName'],
                                                  });
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
                                      child: const Icon(
                                        Icons.arrow_drop_down,
                                        size: 18,
                                      ),
                                      itemBuilder: (BuildContext bc) {
                                        return popupMenuItem
                                            .map(
                                              (e) => PopupMenuItem(
                                                value: e['value'],
                                                child: Row(
                                                  children: [
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5.0)),
                                                    Icon(e['icon']),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 12.0)),
                                                    Text(
                                                      e['value'] == 'timeline'
                                                          ? product[
                                                                  'productTimeline']
                                                              ? e['label']
                                                              : e['labelE']
                                                          : e['value'] ==
                                                                  'comment'
                                                              ? product[
                                                                      'productOnOffCommenting']
                                                                  ? e['label']
                                                                  : e['labelE']
                                                              : e['label'],
                                                      style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 90, 90, 90),
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 12),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                            .toList();
                                      },
                                    ),
                                  ),
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
                                              text: postTime,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  widget.routerChange({
                                                    'router':
                                                        RouteNames.products,
                                                    'subRouter': productId,
                                                  });
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
                                  flex: 1,
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
                                  flex: 2,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Column(children: [
                                      const Padding(
                                          padding: EdgeInsets.only(top: 20)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.sell,
                                            color: Color.fromARGB(
                                                255, 31, 156, 255),
                                            size: 17,
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(left: 5)),
                                          Text(
                                            'Condition',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
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
                                  flex: 2,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Column(children: [
                                      const Padding(
                                          padding: EdgeInsets.only(top: 20)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.money,
                                            color: Color.fromARGB(
                                                255, 43, 180, 40),
                                            size: 17,
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(left: 5)),
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
                                  flex: 2,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Column(children: [
                                      const Padding(
                                          padding: EdgeInsets.only(top: 20)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.gif_box,
                                            color: Color.fromARGB(
                                                255, 160, 56, 178),
                                            size: 17,
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(left: 5)),
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
                                          color:
                                              Color.fromARGB(255, 40, 167, 69),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                        ),
                                        child: const Text(
                                          'In Stock',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                      )
                                    ]),
                                  )),
                            ]),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: UserManager.userInfo['userName'] ==
                                      productAdmin['userName']
                                  ? 0
                                  : 30)),
                      UserManager.userInfo['uid'] ==
                              product['productAdmin']['uid']
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
                                  onPressed: () async {
                                    widget.routerChange({
                                      'router': RouteNames.messages,
                                      'subRouter': widget.data["data"]
                                              ["productAdmin"]["uid"]
                                          .toString()
                                    });
                                    setState(() {});
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
              LikesCommentScreen(
                productId: productId,
                commentFlag: product['productOnOffCommenting'],
                routerChange: widget.routerChange,
              )
            ],
          ),
        ))
      ],
    );
  }
}
