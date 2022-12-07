import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';

// ignore: must_be_immutable
class ProductCell extends StatefulWidget {
  ProductCell({
    super.key,
    required this.data,
  });
  var data;

  late PostController con;
  @override
  State createState() => ProductCellState();
}

class ProductCellState extends mvc.StateMVC<ProductCell> {
  late PostController con;
  var loading = false;
  Map product = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    product = widget.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Container(
          width: 600,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Column(
            children: [
              Container(
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
                                                  fontSize: 16),
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
                                        ? SizeConfig(context).screenWidth - 200
                                        : 400,
                                    child: Text(
                                      ' added new ${product["productCategory"]} products item for ${product["productOffer"]}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  )
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
                                              text: 'minute ago',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.pushReplacementNamed(
                                                      context,
                                                      '${RouteNames.products}/${widget.data['id']}');
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
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 30)),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.grey,
                            size: 20,
                          ),
                          Text(
                            product['productLocation'] ?? '',
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(top: 30)),
                      Container(
                        child: Text(product['productAbout'] ?? ''),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 30)),
                      Container(
                        height: 78,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 247, 247, 247),
                          border: Border.all(
                              color: Color.fromARGB(255, 229, 229, 229)),
                          borderRadius: BorderRadius.all(Radius.circular(7.0)),
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
                                  Text(
                                    'Offer',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 5)),
                                  Text(
                                    'For ${product['productOffer']}',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                  )
                                ]),
                              )),
                              Container(
                                width: 1,
                                height: 60,
                                color: Color.fromARGB(255, 229, 229, 229),
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
                                        Icons.edit,
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
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                  )
                                ]),
                              )),
                              Container(
                                width: 1,
                                height: 60,
                                color: Color.fromARGB(255, 229, 229, 229),
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
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                  )
                                ]),
                              )),
                              Container(
                                width: 1,
                                height: 60,
                                color: Color.fromARGB(255, 229, 229, 229),
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
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 40, 167, 69),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4.0)),
                                    ),
                                    child: Text(
                                      'In Stock',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  )
                                ]),
                              )),
                            ]),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 30)),
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
                              setState(() {
                                // stepflag = true;
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.chat),
                                Padding(padding: EdgeInsets.only(left: 10)),
                                Text(
                                  'Buy',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            )),
                      ),
                    ]),
              )
            ],
          ),
        ))
      ],
    );
  }
}
