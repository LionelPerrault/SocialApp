import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/setting/widget/setting_header.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:url_launcher/url_launcher.dart';

class SettingShnatterTokenScreen extends StatefulWidget {
  SettingShnatterTokenScreen({Key? key, required this.routerChange})
      : con = UserController(),
        super(key: key);
  late UserController con;
  Function routerChange;
  @override
  State createState() => SettingShnatterTokenScreenState();
}

// ignore: must_be_immutable
class SettingShnatterTokenScreenState
    extends mvc.StateMVC<SettingShnatterTokenScreen> {
  var setting_security = {};

  late final PlutoGridStateManager stateManager;
  // List<Employee> employees = [];
  // late EmployeeDataSource employeeDataSource;
  late UserController con;
  late List transactionData = [];
  bool loadingTransactionHistory = true;
  late ScrollController _scrollController;

  // late List<Employee> emData = [];
  @override
  void initState() {
    add(widget.con);
    super.initState();
    con = controller as UserController;
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (con.nextPageTokenCount != 'null') {
          setState(() {
            loadingTransactionHistory = true;
          });
          con.getTransactionHistory(con.nextPageTokenCount).then(
                (resData) => {
                  loadingTransactionHistory = false,
                  if (resData.isNotEmpty)
                    {
                      transactionData.addAll(resData),
                      setState(() {}),
                    },
                },
              );
        }
      }
    });
    con.getTransactionHistory("0").then(
          (resData) => {
            if (resData != [])
              {
                loadingTransactionHistory = false,
                transactionData = resData,
                setState(() {}),
              },
          },
        );
    UserController().getBalance();
  }

  bool check1 = false;
  Color fontColor = const Color.fromRGBO(82, 95, 127, 1);
  double fontSize = 14;

  Future<void> reloadHistory() async {
    setState(() {
      loadingTransactionHistory = true;
    });
    con.getTransactionHistory("0").then(
          (resData) => {
            loadingTransactionHistory = false,
            if (resData.isNotEmpty)
              {
                transactionData = resData,
                setState(() {}),
              },
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SettingHeader(
              routerChange: widget.routerChange,
              icon: const Icon(Icons.attach_money,
                  color: Color.fromRGBO(76, 175, 80, 1)),
              pagename: 'Shnatter Token',
              button: const {'flag': false},
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              width: SizeConfig(context).screenWidth > 800
                  ? SizeConfig(context).screenWidth * 0.85
                  : SizeConfig(context).screenWidth,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              width: 330,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Icon(Icons.attach_money, color: Colors.black),
                                  Text(
                                    'Balance',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 330,
                              height: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.topRight,
                                  colors: <Color>[
                                    Color.fromARGB(255, 94, 114, 228),
                                    Color.fromARGB(255, 130, 94, 228),
                                  ],
                                  tileMode: TileMode.mirror,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    con.balance.toString(),
                                    style: const TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 20.0),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              width: 330,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Icon(Icons.attach_money, color: Colors.black),
                                  Text(
                                    'Reserved Balance',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 330,
                              height: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.topRight,
                                  colors: <Color>[
                                    Color.fromARGB(255, 94, 114, 228),
                                    Color.fromARGB(255, 130, 94, 228),
                                  ],
                                  tileMode: TileMode.mirror,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Text(
                                    '0.00',
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // const Padding(padding: EdgeInsets.only(top: 15)),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(3),
                          backgroundColor:
                              const Color.fromARGB(255, 251, 99, 64),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0)),
                          minimumSize: const Size(720, 40),
                          maximumSize: const Size(720, 40),
                        ),
                        onPressed: () {
                          (() => {});
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text(
                              'Buy Tokens',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Blockchain Address',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.all(3),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.0)),
                            minimumSize: const Size(330, 50),
                            maximumSize: const Size(330, 50),
                          ),
                          onPressed: () {
                            (() => {});
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                UserManager.userInfo['paymail'],
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              const Flexible(
                                  fit: FlexFit.tight, child: SizedBox()),
                              const Icon(
                                Icons.file_copy,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  transList()
                  // generalWidget()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget formatDate(String d) {
    var date = DateTime.parse(d);
    var trDate = '';
    DateTime date2 = DateTime.now();
    var dd = int.parse(date2.timeZoneOffset.toString().split(':')[0]);
    date2 = date2.add(Duration(hours: -dd));
    final difference = date2.difference(date);
    if (difference.inMinutes < 1) {
      trDate = 'Just Now';
    } else if (difference.inHours < 1) {
      trDate = '${difference.inMinutes}minutes ago';
    } else if (difference.inDays < 1) {
      trDate = '${difference.inHours}hours ago';
    } else if (difference.inDays < 31) {
      trDate = '${difference.inDays}days ago';
    } else if (difference.inDays >= 31) {
      trDate = '${(difference.inDays / 30 as String).split('.')[0]}days ago';
    }
    return Text(
      trDate,
      style: const TextStyle(color: Colors.grey, fontSize: 11),
    );
  }

  Widget transList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: SizeConfig(context).screenWidth > 800
              ? SizeConfig(context).screenWidth * 0.67
              : SizeConfig(context).screenWidth < 450
                  ? SizeConfig(context).screenWidth * 0.8
                  : SizeConfig(context).screenWidth * 0.78,
          height: 200,
          margin: const EdgeInsets.only(top: 30, bottom: 15),
          child: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFffffff),
              borderRadius: BorderRadius.all(Radius.circular(7)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 3.0, // soften the shadow
                  spreadRadius: 3.0, //extend the shadow
                  offset: Offset(
                    1.0, // Move to right 5  horizontally
                    3.0, // Move to bottom 5 Vertically
                  ),
                )
              ],
            ),
            child: !loadingTransactionHistory && transactionData.isEmpty
                ? Container(
                    padding: const EdgeInsets.only(top: 40),
                    alignment: Alignment.center,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.network(Helper.emptySVG, width: 90),
                          Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(top: 10),
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              width: 140,
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(240, 240, 240, 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: const Text(
                                'No data to show',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(108, 117, 125, 1)),
                              ))
                        ]))
                : Stack(children: [
                    RefreshIndicator(
                        onRefresh: reloadHistory,
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(top: 10),
                          itemCount: transactionData.length,
                          itemBuilder: (BuildContext context, int index) {
                            var data = transactionData[index];

                            return Container(
                                padding: const EdgeInsets.all(5),
                                alignment: Alignment.center,
                                child: Column(children: [
                                  Container(
                                      child: Theme(
                                    data: Theme.of(context).copyWith(
                                        dividerColor: Colors.transparent),
                                    child: ExpansionTile(
                                      tilePadding: const EdgeInsets.only(
                                          top: 10, bottom: 10, right: 10),
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Text(
                                                  (data['from'] !=
                                                          UserManager.userInfo[
                                                              'paymail']
                                                      ? data['sender']
                                                      : data['recipient']),
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                              Text(
                                                data['from'] !=
                                                        UserManager
                                                            .userInfo['paymail']
                                                    ? 'received'
                                                    : 'sent',
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12),
                                              ),
                                              formatDate(data['sendtime']),
                                            ],
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(left: 15),
                                            child: Text(
                                              data['notes'].toString().length >
                                                      65
                                                  ? '${data['notes'].toString().substring(0, 65)}...'
                                                  : data['notes'],
                                              maxLines: 3,
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing:
                                          Wrap(spacing: 6, children: <Widget>[
                                        Container(
                                          margin: const EdgeInsets.only(top: 2),
                                          child: Text(
                                            data['from'] !=
                                                    UserManager
                                                        .userInfo['paymail']
                                                ? '+${data['balance'].toString()}'
                                                : '-${data['balance'].toString()}',
                                            style: TextStyle(
                                                color: data['from'] !=
                                                        UserManager
                                                            .userInfo['paymail']
                                                    ? Colors.green
                                                    : Colors.red),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            var url = Uri.parse(
                                                'https://whatsonchain.com/tx/${data['txId']}');
                                            if (await canLaunchUrl(url)) {
                                              await launchUrl(
                                                url,
                                                mode: LaunchMode
                                                    .externalApplication,
                                              );
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          },
                                          child: const Icon(
                                            Icons.arrow_forward,
                                            color: Color.fromRGBO(
                                                200, 200, 200, 1),
                                          ),
                                        )
                                      ]),
                                      // children: [
                                      //   isShowExpandingNotes
                                      //       ? Padding(
                                      //           padding: EdgeInsets.all(10),
                                      //           child: Text(
                                      //             t['notes'],
                                      //             style: TextStyle(fontSize: 13),
                                      //           ))
                                      //       : Container()
                                      // ],
                                    ),
                                  )),
                                  Container(
                                    height: 1,
                                    color: const Color.fromARGB(
                                        255, 243, 243, 243),
                                  )
                                ]));
                          },
                        )),
                    if (loadingTransactionHistory)
                      const Positioned(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ]),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   verticalDirection: VerticalDirection.down,
            //   children: [
            //     // Row(
            //     //   verticalDirection: VerticalDirection.up,
            //     //   children: [
            //     //     Container(
            //     //       margin: const EdgeInsets.only(top: 7, bottom: 7),
            //     //       // alignment: Alignment.center,
            //     //       child: Row(
            //     //         children: [
            //     //           Container(
            //     //             width: 100,
            //     //             alignment: Alignment.center,
            //     //             child: const Text(
            //     //               'Sender',
            //     //               style: TextStyle(
            //     //                 fontSize: 20,
            //     //               ),
            //     //             ),
            //     //           ),
            //     //           Container(
            //     //             width: 100,
            //     //             alignment: Alignment.center,
            //     //             child: const Text(
            //     //               'Recipient',
            //     //               style: TextStyle(
            //     //                 fontSize: 20,
            //     //               ),
            //     //             ),
            //     //           ),
            //     //           Container(
            //     //             width: 100,
            //     //             alignment: Alignment.center,
            //     //             child: const Text(
            //     //               'Time',
            //     //               style: TextStyle(
            //     //                 fontSize: 20,
            //     //               ),
            //     //             ),
            //     //           ),
            //     //           Container(
            //     //             width: 100,
            //     //             alignment: Alignment.center,
            //     //             child: const Text(
            //     //               'Note',
            //     //               style: TextStyle(
            //     //                 fontSize: 20,
            //     //               ),
            //     //             ),
            //     //           ),
            //     //           Container(
            //     //             width: 100,
            //     //             alignment: Alignment.center,
            //     //             child: const Text(
            //     //               'Balance',
            //     //               style: TextStyle(
            //     //                 fontSize: 20,
            //     //               ),
            //     //             ),
            //     //           )
            //     //         ],
            //     //       ),
            //     //     ),
            //     //   ],
            //     // ),

            //   ],
            // ),
          ),
        ),
      ],
    );
    // ListView.builder(
    //   padding: const EdgeInsets.only(top: 50),
    //   itemCount: transactionData.length,
    //   itemBuilder: (BuildContext context, int index) {
    //     var data = transactionData[index];
    //     var userName = data['from'] != UserManager.userInfo['paymail']
    //         ? data['sender']
    //         : data['recipient'];
    //     print(userName);
    //     return const ListTile(
    //       title: Text('123123123123123'),
    //     );
    //   },
    // );
  }

  // Widget button({url, text}) {
  //   return Expanded(
  //     flex: 1,
  //     child: Container(
  //       width: 90,
  //       height: 90,
  //       margin: EdgeInsets.all(5),
  //       child: ElevatedButton(
  //         style: ElevatedButton.styleFrom(
  //           padding: EdgeInsets.all(3),
  //           backgroundColor: Colors.white,
  //           elevation: 3,
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(3.0)),
  //           minimumSize: const Size(90, 90),
  //           maximumSize: const Size(90, 90),
  //         ),
  //         onPressed: () {
  //           (() => {});
  //         },
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             Container(
  //               width: 40,
  //               height: 40,
  //               decoration: const BoxDecoration(
  //                   // color: Colors.grey,
  //                   borderRadius: BorderRadius.all(Radius.circular(20))),
  //               child: SvgPicture.network(url),
  //             ),
  //             Text(
  //               text,
  //               style: const TextStyle(
  //                   fontSize: 11,
  //                   color: Colors.grey,
  //                   fontWeight: FontWeight.bold),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildProgressIndicator() {
  //   return Container(
  //       height: 60.0,
  //       alignment: Alignment.center,
  //       width: double.infinity,
  //       decoration: const BoxDecoration(
  //         color: Color(0xFFFFFFFF),
  //         border: BorderDirectional(
  //           top: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.26)),
  //         ),
  //       ),
  //       child: Container(
  //           width: 40,
  //           height: 40,
  //           alignment: Alignment.center,
  //           child: const CircularProgressIndicator(
  //             backgroundColor: Colors.transparent,
  //           )));
  // }

  // Widget _buildLoadMoreView(BuildContext context, LoadMoreRows loadMoreRows) {
  //   Future<String> loadRows() async {
  //     // Call the loadMoreRows function to call the
  //     // DataGridSource.handleLoadMoreRows method. So, additional
  //     // rows can be added from handleLoadMoreRows method.
  //     await loadMoreRows();
  //     return Future<String>.value('Completed');
  //   }

  //   return FutureBuilder<String>(
  //     initialData: 'Loading',
  //     future: loadRows(),
  //     builder: (BuildContext context, AsyncSnapshot<String> snapShot) {
  //       print(snapShot.data);
  //       return snapShot.data == 'Loading'
  //           ? _buildProgressIndicator()
  //           : SizedBox.fromSize(size: Size.zero);
  //     },
  //   );
  // }

  // List<GridColumn> _getColumns() {
  //   return <GridColumn>[
  //     GridColumn(
  //         columnName: 'ID',
  //         columnWidthMode: ColumnWidthMode.lastColumnFill,
  //         label: Container(
  //             padding: const EdgeInsets.all(8),
  //             alignment: Alignment.centerRight,
  //             child: const Text(
  //               'ID',
  //               overflow: TextOverflow.ellipsis,
  //             ))),
  //     GridColumn(
  //         columnName: 'Sender',
  //         columnWidthMode: ColumnWidthMode.lastColumnFill,
  //         label: Container(
  //             padding: const EdgeInsets.all(8),
  //             alignment: Alignment.centerRight,
  //             child: const Text(
  //               'Sender',
  //               overflow: TextOverflow.ellipsis,
  //             ))),
  //     GridColumn(
  //         columnName: 'Recipient',
  //         columnWidthMode: ColumnWidthMode.lastColumnFill,
  //         label: Container(
  //             padding: const EdgeInsets.all(8),
  //             alignment: Alignment.centerRight,
  //             child: const Text(
  //               'Recipient',
  //               overflow: TextOverflow.ellipsis,
  //             ))),
  //     GridColumn(
  //         columnName: 'Send Time',
  //         columnWidthMode: ColumnWidthMode.lastColumnFill,
  //         label: Container(
  //             padding: const EdgeInsets.all(8),
  //             alignment: Alignment.centerRight,
  //             child: const Text(
  //               'Send Time',
  //               overflow: TextOverflow.ellipsis,
  //             ))),
  //     GridColumn(
  //         columnName: 'Note',
  //         columnWidthMode: ColumnWidthMode.lastColumnFill,
  //         label: Container(
  //             padding: const EdgeInsets.all(8),
  //             alignment: Alignment.centerRight,
  //             child: const Text(
  //               'Note',
  //               overflow: TextOverflow.ellipsis,
  //             ))),
  //     // GridColumn(
  //     //     columnName: 'Activated',
  //     //     columnWidthMode: ColumnWidthMode.lastColumnFill,
  //     //     label: Container(
  //     //         padding: const EdgeInsets.all(8),
  //     //         alignment: Alignment.centerRight,
  //     //         child: const Text(
  //     //           'Activated',
  //     //           overflow: TextOverflow.ellipsis,
  //     //         ))),
  //     GridColumn(
  //         columnName: 'Balance',
  //         columnWidthMode: ColumnWidthMode.lastColumnFill,
  //         label: Container(
  //             padding: const EdgeInsets.all(8),
  //             alignment: Alignment.centerRight,
  //             child: const Text(
  //               'Balance',
  //               overflow: TextOverflow.ellipsis,
  //             ))),
  // GridColumn(
  //     columnName: 'Actions',
  //     columnWidthMode: ColumnWidthMode.lastColumnFill,
  //     label: Container(
  //         padding: const EdgeInsets.all(8),
  //         alignment: Alignment.centerRight,
  //         child: const Text(
  //           'Actions',
  //           overflow: TextOverflow.ellipsis,
  //         )))
  //   ];
  // }

  // Widget generalWidget() {
  //   return Container(
  //     child: Column(
  //       children: [
  //         SizeConfig(context).screenWidth > 800
  //             ? Container(
  //                 width: SizeConfig(context).screenWidth > 800
  //                     ? SizeConfig(context).screenWidth * 0.85
  //                     : SizeConfig(context).screenWidth,
  //                 padding: const EdgeInsets.all(15),
  //                 alignment: Alignment.center,
  //                 child: Container(
  //                   width: SizeConfig(context).screenWidth > 800
  //                       ? SizeConfig(context).screenWidth * 0.85
  //                       : SizeConfig(context).screenWidth,
  //                   // height: SizeConfig(context).screenHeight - SizeConfig.navbarHeight,
  //                   padding: const EdgeInsets.all(15),
  //                   child: SfDataGrid(
  //                     allowSorting: true,
  //                     allowFiltering: true,
  //                     loadMoreViewBuilder: _buildLoadMoreView,
  //                     source: employeeDataSource,
  //                     columns: _getColumns(),
  //                     gridLinesVisibility: GridLinesVisibility.both,
  //                     headerGridLinesVisibility: GridLinesVisibility.both,
  //                   ),
  //                 ),
  //               )
  //             : Container(
  //                 width: SizeConfig(context).screenWidth < 800
  //                     ? SizeConfig(context).screenWidth * 0.85
  //                     : SizeConfig(context).screenWidth,
  //                 // height: SizeConfig(context).screenHeight - SizeConfig.navbarHeight,
  //                 padding: const EdgeInsets.all(15),
  //                 child: SfDataGrid(
  //                   allowSorting: true,
  //                   allowFiltering: true,
  //                   loadMoreViewBuilder: _buildLoadMoreView,
  //                   source: employeeDataSource,
  //                   columns: _getColumns(),
  //                   gridLinesVisibility: GridLinesVisibility.both,
  //                   headerGridLinesVisibility: GridLinesVisibility.both,
  //                 ),
  //               ),
  //       ],
  //     ),
  //   );
  // }
}
