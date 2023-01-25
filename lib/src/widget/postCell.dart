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
class PostCell extends StatefulWidget {
  PostCell({
    super.key,
    required this.postInfo,
  }) : con = PostController();
  var postInfo;

  late PostController con;
  @override
  State createState() => PostCellState();
}

class PostCellState extends mvc.StateMVC<PostCell> {
  late PostController con;
  bool payLoading = false;
  bool loading = false;

  @override
  void initState() {
    print('widget.postInfo${widget.postInfo}');
    add(widget.con);
    con = controller as PostController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.postInfo['type'] == 'photo'
        ? picturePostCell()
        : widget.postInfo['type'] == 'photo'
            ? feelingPostCell()
            : SizedBox();
  }

  Widget picturePostCell() {
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
                  padding: EdgeInsets.only(left: 20, right: 20),
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
                                              text:
                                                  '${widget.postInfo['admin']['firstName']} ${widget.postInfo['admin']['lastName']}',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.pushReplacementNamed(
                                                      context,
                                                      '/${widget.postInfo['admin']['userName']}');
                                                })
                                        ]),
                                  ),
                                  Container(
                                    width: SizeConfig(context).screenWidth < 600
                                        ? SizeConfig(context).screenWidth - 240
                                        : 350,
                                    child: Text(
                                      ' added ${widget.postInfo['data'].length == 1 ? 'a' : widget.postInfo['data'].length} photo${widget.postInfo['data'].length == 1 ? '' : 's'}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  // Container(
                                  //   padding: EdgeInsets.only(right: 9.0),
                                  //   child: CustomPopupMenu(
                                  //       menuBuilder: () => SubFunction(),
                                  //       pressType: PressType.singleClick,
                                  //       verticalMargin: -10,
                                  //       child:
                                  //           const Icon(Icons.arrow_drop_down)),
                                  // ),
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
                                              // text: Helper.formatDate(
                                              //     widget.postInfo['time']),
                                              text: '',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.pushReplacementNamed(
                                                      context,
                                                      '${RouteNames.products}/${widget.postInfo['id']}');
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
                      const Padding(padding: EdgeInsets.only(top: 30)),
                      Row(
                        children: [
                          for (var item in widget.postInfo['data'])
                            Expanded(
                              child: Container(
                                height: 250,
                                child: Image.network(item['url'],
                                    fit: BoxFit.cover),
                              ),
                            )
                        ],
                      )
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 30)),
                LikesCommentScreen(productId: widget.postInfo['id'])
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget feelingPostCell() {
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
                  padding: EdgeInsets.only(left: 20, right: 20),
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
                                              text:
                                                  '${widget.postInfo['admin']['firstName']} ${widget.postInfo['admin']['lastName']}',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.pushReplacementNamed(
                                                      context,
                                                      '/${widget.postInfo['admin']['userName']}');
                                                })
                                        ]),
                                  ),
                                  Container(
                                    width: SizeConfig(context).screenWidth < 600
                                        ? SizeConfig(context).screenWidth - 240
                                        : 350,
                                    child: Text(
                                      ' added ${widget.postInfo['data'].length == 1 ? 'a' : widget.postInfo['data'].length} photo${widget.postInfo['data'].length == 1 ? '' : 's'}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  // Container(
                                  //   padding: EdgeInsets.only(right: 9.0),
                                  //   child: CustomPopupMenu(
                                  //       menuBuilder: () => SubFunction(),
                                  //       pressType: PressType.singleClick,
                                  //       verticalMargin: -10,
                                  //       child:
                                  //           const Icon(Icons.arrow_drop_down)),
                                  // ),
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
                                              // text: Helper.formatDate(
                                              //     widget.postInfo['time']),
                                              text: '',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.pushReplacementNamed(
                                                      context,
                                                      '${RouteNames.products}/${widget.postInfo['id']}');
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
                      const Padding(padding: EdgeInsets.only(top: 30)),
                      Row(
                        children: [
                          for (var item in widget.postInfo['data'])
                            Expanded(
                              child: Container(
                                height: 250,
                                child: Image.network(item['url'],
                                    fit: BoxFit.cover),
                              ),
                            )
                        ],
                      )
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 30)),
                LikesCommentScreen(productId: widget.postInfo['id'])
              ],
            ),
          ),
        )
      ],
    );
  }

  // Widget productPostCell() {
  //   return Row(
  //     children: [
  //       Expanded(
  //           child: Container(
  //         margin: const EdgeInsets.only(top: 30, bottom: 30),
  //         width: 600,
  //         padding: const EdgeInsets.only(top: 20),
  //         decoration: const BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.all(Radius.circular(5.0)),
  //         ),
  //         child: Column(
  //           children: [
  //             Container(
  //               padding: EdgeInsets.only(left: 20, right: 20),
  //               child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Row(
  //                       children: [
  //                         CircleAvatar(
  //                           radius: 22,
  //                           child: SvgPicture.network(Helper.avatar),
  //                         ),
  //                         const Padding(padding: EdgeInsets.only(left: 10)),
  //                         Column(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Row(
  //                               children: [
  //                                 RichText(
  //                                   text: TextSpan(
  //                                       style: const TextStyle(
  //                                           color: Colors.grey, fontSize: 10),
  //                                       children: <TextSpan>[
  //                                         TextSpan(
  //                                             text: widget.postInfo['data']
  //                                                 ['productAdmin']['fullName'],
  //                                             style: const TextStyle(
  //                                                 color: Colors.black,
  //                                                 fontWeight: FontWeight.bold,
  //                                                 fontSize: 16),
  //                                             recognizer: TapGestureRecognizer()
  //                                               ..onTap = () {
  //                                                 print('username');
  //                                                 Navigator.pushReplacementNamed(
  //                                                     context,
  //                                                     '/${widget.postInfo['data']['productAdmin']['userName']}');
  //                                               })
  //                                       ]),
  //                                 ),
  //                                 Container(
  //                                   width: SizeConfig(context).screenWidth < 600
  //                                       ? SizeConfig(context).screenWidth - 240
  //                                       : 350,
  //                                   child: Text(
  //                                     ' added new ${widget.postInfo['data']["productCategory"]} products item for ${widget.postInfo['data']["productOffer"]}',
  //                                     style: const TextStyle(fontSize: 14),
  //                                   ),
  //                                 ),
  //                                 // Container(
  //                                 //   padding: EdgeInsets.only(right: 9.0),
  //                                 //   child: CustomPopupMenu(
  //                                 //       menuBuilder: () => SubFunction(),
  //                                 //       pressType: PressType.singleClick,
  //                                 //       verticalMargin: -10,
  //                                 //       child:
  //                                 //           const Icon(Icons.arrow_drop_down)),
  //                                 // ),
  //                               ],
  //                             ),
  //                             const Padding(padding: EdgeInsets.only(top: 3)),
  //                             Row(
  //                               children: [
  //                                 RichText(
  //                                   text: TextSpan(
  //                                       style: const TextStyle(
  //                                           color: Colors.grey, fontSize: 10),
  //                                       children: <TextSpan>[
  //                                         TextSpan(
  //                                             text: Helper.formatDate(
  //                                                 widget.postInfo['data']
  //                                                     ['productDate']),
  //                                             style: const TextStyle(
  //                                                 color: Colors.black,
  //                                                 fontSize: 10),
  //                                             recognizer: TapGestureRecognizer()
  //                                               ..onTap = () {
  //                                                 Navigator.pushReplacementNamed(
  //                                                     context,
  //                                                     '${RouteNames.products}/${widget.postInfo['id']}');
  //                                               })
  //                                       ]),
  //                                 ),
  //                                 const Text(' - '),
  //                                 const Icon(
  //                                   Icons.language,
  //                                   size: 12,
  //                                 )
  //                               ],
  //                             ),
  //                           ],
  //                         )
  //                       ],
  //                     ),
  //                     const Padding(padding: EdgeInsets.only(top: 15)),
  //                     Text(
  //                       widget.postInfo['data']['productName'],
  //                       style: const TextStyle(
  //                           fontSize: 20, fontWeight: FontWeight.bold),
  //                     ),
  //                     const Padding(padding: EdgeInsets.only(top: 30)),
  //                     Row(
  //                       children: [
  //                         const Icon(
  //                           Icons.location_on,
  //                           color: Colors.grey,
  //                           size: 20,
  //                         ),
  //                         Text(
  //                           widget.postInfo['data']['productLocation'] ?? '',
  //                           style: const TextStyle(color: Colors.grey),
  //                         )
  //                       ],
  //                     ),
  //                     const Padding(padding: EdgeInsets.only(top: 30)),
  //                     Container(
  //                       child:
  //                           Text(widget.postInfo['data']['productAbout'] ?? ''),
  //                     ),
  //                     const Padding(padding: EdgeInsets.only(top: 30)),
  //                     Container(
  //                       height: 78,
  //                       decoration: BoxDecoration(
  //                         color: const Color.fromARGB(255, 247, 247, 247),
  //                         border: Border.all(
  //                             color: const Color.fromARGB(255, 229, 229, 229)),
  //                         borderRadius:
  //                             const BorderRadius.all(Radius.circular(7.0)),
  //                       ),
  //                       child: Row(
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             Expanded(
  //                                 child: Container(
  //                               alignment: Alignment.center,
  //                               child: Column(children: [
  //                                 const Padding(
  //                                     padding: EdgeInsets.only(top: 20)),
  //                                 const Text(
  //                                   'Offer',
  //                                   style: TextStyle(
  //                                       fontSize: 16,
  //                                       fontWeight: FontWeight.bold),
  //                                 ),
  //                                 const Padding(
  //                                     padding: EdgeInsets.only(top: 5)),
  //                                 Text(
  //                                   'For ${widget.postInfo['data']['productOffer']}',
  //                                   style: const TextStyle(
  //                                       color: Colors.grey, fontSize: 15),
  //                                 )
  //                               ]),
  //                             )),
  //                             Container(
  //                               width: 1,
  //                               height: 60,
  //                               color: const Color.fromARGB(255, 229, 229, 229),
  //                             ),
  //                             Expanded(
  //                                 child: Container(
  //                               alignment: Alignment.center,
  //                               child: Column(children: [
  //                                 const Padding(
  //                                     padding: EdgeInsets.only(top: 20)),
  //                                 Row(
  //                                   mainAxisAlignment: MainAxisAlignment.center,
  //                                   children: const [
  //                                     Icon(
  //                                       Icons.sell,
  //                                       color:
  //                                           Color.fromARGB(255, 31, 156, 255),
  //                                       size: 17,
  //                                     ),
  //                                     Padding(
  //                                         padding: EdgeInsets.only(left: 5)),
  //                                     Text(
  //                                       'Condition',
  //                                       style: TextStyle(
  //                                           fontSize: 16,
  //                                           fontWeight: FontWeight.bold),
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 const Padding(
  //                                     padding: EdgeInsets.only(top: 5)),
  //                                 Text(
  //                                   '${widget.postInfo['data']['productStatus']}',
  //                                   style: const TextStyle(
  //                                       color: Colors.grey, fontSize: 15),
  //                                 )
  //                               ]),
  //                             )),
  //                             Container(
  //                               width: 1,
  //                               height: 60,
  //                               color: const Color.fromARGB(255, 229, 229, 229),
  //                             ),
  //                             Expanded(
  //                                 child: Container(
  //                               alignment: Alignment.center,
  //                               child: Column(children: [
  //                                 const Padding(
  //                                     padding: EdgeInsets.only(top: 20)),
  //                                 Row(
  //                                   mainAxisAlignment: MainAxisAlignment.center,
  //                                   children: const [
  //                                     Icon(
  //                                       Icons.money,
  //                                       color: Color.fromARGB(255, 43, 180, 40),
  //                                       size: 17,
  //                                     ),
  //                                     Padding(
  //                                         padding: EdgeInsets.only(left: 5)),
  //                                     Text(
  //                                       'Price',
  //                                       style: TextStyle(
  //                                           fontSize: 16,
  //                                           fontWeight: FontWeight.bold),
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 const Padding(
  //                                     padding: EdgeInsets.only(top: 5)),
  //                                 Text(
  //                                   '${widget.postInfo['data']['productPrice']} (SHN)',
  //                                   style: const TextStyle(
  //                                       color: Colors.grey, fontSize: 15),
  //                                 )
  //                               ]),
  //                             )),
  //                             Container(
  //                               width: 1,
  //                               height: 60,
  //                               color: const Color.fromARGB(255, 229, 229, 229),
  //                             ),
  //                             Expanded(
  //                                 child: Container(
  //                               alignment: Alignment.center,
  //                               child: Column(children: [
  //                                 const Padding(
  //                                     padding: EdgeInsets.only(top: 20)),
  //                                 Row(
  //                                   mainAxisAlignment: MainAxisAlignment.center,
  //                                   children: const [
  //                                     Icon(
  //                                       Icons.gif_box,
  //                                       color:
  //                                           Color.fromARGB(255, 160, 56, 178),
  //                                       size: 17,
  //                                     ),
  //                                     Padding(
  //                                         padding: EdgeInsets.only(left: 5)),
  //                                     Text(
  //                                       'Status',
  //                                       style: TextStyle(
  //                                           fontSize: 16,
  //                                           fontWeight: FontWeight.bold),
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 const Padding(
  //                                     padding: EdgeInsets.only(top: 5)),
  //                                 Container(
  //                                   alignment: Alignment.center,
  //                                   width: 90,
  //                                   height: 25,
  //                                   decoration: const BoxDecoration(
  //                                     color: Color.fromARGB(255, 40, 167, 69),
  //                                     borderRadius: BorderRadius.all(
  //                                         Radius.circular(4.0)),
  //                                   ),
  //                                   child: const Text(
  //                                     'In Stock',
  //                                     style: TextStyle(
  //                                         color: Colors.white, fontSize: 15),
  //                                   ),
  //                                 )
  //                               ]),
  //                             )),
  //                           ]),
  //                     ),
  //                     Padding(
  //                         padding: EdgeInsets.only(
  //                             top: UserManager.userInfo['userName'] ==
  //                                     widget.postInfo['data']['productAdmin']
  //                                         ['userName']
  //                                 ? 0
  //                                 : 30)),
  //                     UserManager.userInfo['userName'] ==
  //                             widget.postInfo['data']['productAdmin']
  //                                 ['userName']
  //                         ? Container()
  //                         : Container(
  //                             height: 50,
  //                             child: ElevatedButton(
  //                                 style: ElevatedButton.styleFrom(
  //                                   backgroundColor:
  //                                       const Color.fromARGB(255, 17, 205, 239),
  //                                   elevation: 3,
  //                                   shape: RoundedRectangleBorder(
  //                                       borderRadius:
  //                                           BorderRadius.circular(3.0)),
  //                                 ),
  //                                 onPressed: () {
  //                                   if (UserManager.userInfo['uid'] !=
  //                                       widget.postInfo["data"]["productAdmin"]
  //                                           ["uid"]) {
  //                                     Navigator.pushNamed(
  //                                       context,
  //                                       RouteNames.messages,
  //                                       arguments: widget.postInfo["data"]
  //                                               ["productAdmin"]["uid"]
  //                                           .toString(),
  //                                     );
  //                                   }
  //                                   setState(() {
  //                                     // stepflag = true;
  //                                   });
  //                                 },
  //                                 child: Row(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.center,
  //                                   mainAxisAlignment: MainAxisAlignment.center,
  //                                   children: const [
  //                                     Icon(Icons.wechat_outlined),
  //                                     Padding(
  //                                         padding: EdgeInsets.only(left: 10)),
  //                                     Text(
  //                                       'Contact',
  //                                       style: TextStyle(
  //                                           fontWeight: FontWeight.bold),
  //                                     )
  //                                   ],
  //                                 )),
  //                           ),
  //                     const Padding(padding: EdgeInsets.only(top: 10)),
  //                     Container(
  //                       height: 50,
  //                       child: ElevatedButton(
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor:
  //                                 const Color.fromARGB(255, 240, 96, 63),
  //                             elevation: 3,
  //                             shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(3.0)),
  //                           ),
  //                           onPressed: () {
  //                             buyProduct();
  //                           },
  //                           child: Row(
  //                             crossAxisAlignment: CrossAxisAlignment.center,
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             children: const [
  //                               Icon(Icons.wechat_outlined),
  //                               Padding(padding: EdgeInsets.only(left: 10)),
  //                               Text(
  //                                 'Buy',
  //                                 style: TextStyle(fontWeight: FontWeight.bold),
  //                               )
  //                             ],
  //                           )),
  //                     ),
  //                   ]),
  //             ),
  //             LikesCommentScreen(productId: widget.postInfo['id'])
  //           ],
  //         ),
  //       ))
  //     ],
  //   );
  // }
}
