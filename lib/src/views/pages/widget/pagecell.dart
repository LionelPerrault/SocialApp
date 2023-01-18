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
import 'package:shnatter/src/widget/alertYesNoWidget.dart';

// ignore: must_be_immutable
class PageCell extends StatefulWidget {
  PageCell({
    super.key,
    required this.pageInfo,
    required this.refreshFunc,
  }) : con = PostController();
  Map pageInfo;
  late PostController con;
  var refreshFunc;
  @override
  State createState() => PageCellState();
}

class PageCellState extends mvc.StateMVC<PageCell> {
  late PostController con;
  var loading = false;
  var payLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    add(widget.con);
    con = controller as PostController;
    super.initState();
  }

  pageLikeFunc() async {
    print(widget.pageInfo['data']['pageAdmin'][0]['uid']);
    var pageAdminInfo = await ProfileController()
        .getUserInfo(widget.pageInfo['data']['pageAdmin'][0]['uid']);
    print(pageAdminInfo);
    if (pageAdminInfo!['paywall']['likeMyPage'] == null ||
        pageAdminInfo['paywall']['likeMyPage'] == '0' ||
        widget.pageInfo['data']['pageAdmin'][0]['uid'] ==
            UserManager.userInfo['uid']) {
      loading = true;
      setState(() {});
      await con.likedPage(widget.pageInfo['id']).then((value) {
        widget.refreshFunc();
      });
      loading = false;
      setState(() {});
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const SizedBox(),
          content: AlertYesNoWidget(
              yesFunc: () async {
                payLoading = true;
                setState(() {});
                await UserController()
                    .payShnToken(
                        pageAdminInfo['paymail'].toString(),
                        pageAdminInfo['paywall']['likeMyPage'],
                        'Pay for view profile of user')
                    .then(
                      (value) async => {
                        if (value)
                          {
                            payLoading = false,
                            setState(() {}),
                            Navigator.of(context).pop(true),
                            loading = true,
                            setState(() {}),
                            await con
                                .likedPage(widget.pageInfo['id'])
                                .then((value) {
                              widget.refreshFunc();
                            }),
                            loading = false,
                            setState(() {}),
                          }
                      },
                    );
              },
              noFunc: () {
                Navigator.of(context).pop(true);
              },
              header: 'Pay token for like or unlike this page',
              text:
                  'Admin of this page set price is ${pageAdminInfo['paywall']['likeMyPage']} for like or unlike this page',
              progress: payLoading),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          width: 200,
          height: 250,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                width: 200,
                margin: EdgeInsets.only(top: 60),
                padding: EdgeInsets.only(top: 70),
                decoration: BoxDecoration(
                  color: Colors.grey[350],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: widget.pageInfo['data']['pageName'],
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacementNamed(context,
                                    '/pages/${widget.pageInfo['data']['pageUserName']}');
                              }),
                      ]),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 5)),
                    Text(
                      '${widget.pageInfo['data']['pageLiked'].length} Likes',
                      style: const TextStyle(color: Colors.black, fontSize: 13),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2.0)),
                            minimumSize: const Size(120, 35),
                            maximumSize: const Size(120, 35)),
                        onPressed: () async {
                          pageLikeFunc();
                        },
                        child: loading
                            ? Container(
                                width: 10,
                                height: 10,
                                child: const CircularProgressIndicator(
                                  color: Colors.grey,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.thumb_up_sharp,
                                    color: Colors.black,
                                    size: 18.0,
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(left: 3)),
                                  Text(
                                      widget.pageInfo['liked']
                                          ? 'Unlike'
                                          : 'Like',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold)),
                                ],
                              )),
                    const Padding(padding: EdgeInsets.only(top: 30))
                  ],
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                width: 120,
                height: 120,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          widget.pageInfo['data']['pagePicture'] != ''
                              ? widget.pageInfo['data']['pagePicture']
                              : Helper.pageAvatar),
                      fit: BoxFit.cover,
                    ),
                    color: Color.fromARGB(255, 150, 99, 99),
                    borderRadius: BorderRadius.circular(60),
                    border: Border.all(color: Colors.grey)),
              ),
            ],
          ),
        )
      ],
    );
  }
}
