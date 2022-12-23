import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';

// ignore: must_be_immutable
class EventCell extends StatefulWidget {
  EventCell({
    super.key,
    required this.eventTap,
    required this.picture,
    required this.interests,
    required this.header,
    required this.interested,
    required this.status,
    required this.buttonFun,
  });
  Function eventTap;
  Function buttonFun;
  bool status;
  String picture;
  int interests;
  String header;
  bool interested;

  late PostController con;
  @override
  State createState() => EventCellState();
}

class EventCellState extends mvc.StateMVC<EventCell> {
  late PostController con;
  var loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                            text: widget.header,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                widget.eventTap();
                              }),
                      ]),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 5)),
                    Text(
                      '${widget.interests} Interested',
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
                        onPressed: () {
                          loading = true;
                          setState(() {});
                          widget.buttonFun();
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
                                  widget.interested
                                      ? Icon(
                                          Icons.star,
                                          color: Colors.black,
                                          size: 18.0,
                                        )
                                      : Icon(
                                          Icons.check,
                                          color: Colors.black,
                                          size: 18.0,
                                        ),
                                  Text('Interested',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold)),
                                ],
                              )),
                    Padding(padding: EdgeInsets.only(top: 30))
                  ],
                ),
              ),
              // Container(
              //   alignment: Alignment.topCenter,
              //   width: 120,
              //   height: 120,
              //   padding: const EdgeInsets.all(2),
              //   decoration: BoxDecoration(
              //       color: Color.fromARGB(255, 150, 99, 99),
              //       borderRadius: BorderRadius.circular(60),
              //       border: Border.all(color: Colors.grey)),
              //   child: SvgPicture.network(
              //       widget.picture == '' ? Helper.eventImage : widget.picture),
              // ),
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                    radius: 75,
                    backgroundImage: NetworkImage(widget.picture == ''
                        ? Helper.eventImage
                        : widget.picture)),
              )
            ],
          ),
        )
      ],
    );
  }
}
