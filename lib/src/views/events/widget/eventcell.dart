
import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class EventCell extends StatelessWidget {
  EventCell(
      {super.key,
      required this.eventTap,
      required this.picture,
      required this.interests,
      required this.header,
      required this.interested});
Function eventTap;
  String picture;
  int interests;
  String header;
  bool interested;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(children: [
        Container(
          width: 200,
          margin: EdgeInsets.only(top: 60),
          padding: EdgeInsets.only(top: 70),
          decoration: BoxDecoration(
              color: Colors.grey[350],
              borderRadius: BorderRadius.circular(5),
          ),
          child: Column(children: [
            RichText(
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                  text: header,
                  style: const TextStyle(
                      color: Colors.black, fontSize: 13,
                      fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      eventTap();
                    }
                ),
              ]),
            ),
            Padding(padding: EdgeInsets.only(top: 5)),
            Text('${interests} Interested', style: TextStyle(
                      color: Colors.black, fontSize: 13),),
            Padding(padding: EdgeInsets.only(top: 20)),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                                2.0)),
                    minimumSize: const Size(120, 35),
                    maximumSize: const Size(120, 35)),
                onPressed: () {
                  interested ? () {}:()=>{};
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    interested ? Icon(
                      Icons.star,
                      color: Colors.black,
                      size: 18.0,
                    )
                    :
                    Icon(
                      Icons.check,
                      color: Colors.black,
                      size: 18.0,
                    ),
                    Text('Interested',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                            fontWeight:
                                FontWeight.bold)),
                  ],
                )),
            Padding(padding: EdgeInsets.only(top: 30))
          ],),
        ),
        Container(
          width: 120,
          height: 120,
          padding: const EdgeInsets.all(2),
          margin: EdgeInsets.only(left: 40),
          decoration: BoxDecoration(
              color:
                  Color.fromARGB(255, 250, 250, 250),
              borderRadius: BorderRadius.circular(60),
              border: Border.all(color: Colors.grey)),
          child: SvgPicture.network(
              picture),
        ),
      ],),
    );
  }
}
