import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/controllers/AdminController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_header.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class AdminShnatterToken extends StatefulWidget {
  AdminShnatterToken({Key? key})
      : con = AdminController(),
        super(key: key);
  final AdminController con;

  @override
  State createState() => AdminShnatterTokenState();
}

class AdminShnatterTokenState extends mvc.StateMVC<AdminShnatterToken> {
  late AdminController con;
  late List transactionData = [];
  bool loadingTransactionHistory = true;
  late ScrollController _scrollController;
  @override
  void initState() {
    add(widget.con);
    con = controller as AdminController;
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
    super.initState();
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
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          width: SizeConfig(context).screenWidth > 800
              ? SizeConfig(context).screenWidth * 0.75
              : SizeConfig(context).screenWidth,
          child: generalWidget(),
        ),
      ],
    );
  }

  Widget generalWidget() {
    return Column(
      children: [
        AdminSettingHeader(
          icon: const Icon(Icons.attach_money_outlined),
          pagename: 'Transactions History',
          button: const {
            'flag': false,
          },
        ),
        transList(),
      ],
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
          height: 400,
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            (data['from'] != con.backupPaymail
                                                ? data['sender']
                                                : data['recipient']),
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                          Text(
                                            data['from'] != con.backupPaymail
                                                ? 'received'
                                                : 'sent',
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
                                          ),
                                          formatDate(
                                              data['sendtime'].toString()),
                                        ],
                                      ),
                                      Flexible(
                                          child: Container(
                                        margin: const EdgeInsets.only(left: 15),
                                        child: Text(
                                          data['notes'].toString().length > 65
                                              ? '${data['notes'].toString().substring(0, 65)}...'
                                              : data['notes'],
                                          maxLines: 3,
                                          style: const TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 13,
                                              color: Colors.black),
                                        ),
                                      )),
                                      Row(
                                        children: [
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 2),
                                            child: Text(
                                              data['from'] != con.backupPaymail
                                                  ? '+${data['balance'].toString()}'
                                                  : '-${data['balance'].toString()}',
                                              style: TextStyle(
                                                  color: data['from'] !=
                                                          con.backupPaymail
                                                      ? Colors.green
                                                      : Colors.red),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
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
                                        ],
                                      )
                                    ],
                                  ),
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
          ),
        ),
      ],
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
      trDate =
          '${(difference.inDays / 30).toString().split('.')[0]} months ago';
    }
    return Text(
      trDate.toString(),
      style: const TextStyle(color: Colors.grey, fontSize: 11),
    );
  }
}
