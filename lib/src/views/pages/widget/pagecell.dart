import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';

// ignore: must_be_immutable
class PageCell extends StatefulWidget {
  PageCell({
    super.key,
    required this.pageInfo,
  }) : con = PostController();
  Map pageInfo;
  late PostController con;
  @override
  State createState() => PageCellState();
}

class PageCellState extends mvc.StateMVC<PageCell> {
  late PostController con;
  var loading = false;
  @override
  void initState() {
    // TODO: implement initState
    add(widget.con);
    con = controller as PostController;
    super.initState();
  }

  pageLikeFunc() async {
    loading = true;
    setState(() {});
    await con.likedPage(widget.pageInfo['id']).then((value) {
      // getPageNow();
    });
    loading = false;
    setState(() {});
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
