
import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/utils/svg.dart';
import 'package:shnatter/src/views/box/daytimeM.dart';
import 'package:shnatter/src/views/box/mindpost.dart';
import 'package:shnatter/src/widget/createEventWidget.dart';
import 'package:shnatter/src/widget/mindslice.dart';

// ignore: must_be_immutable
class EventsHeaderPanel extends StatelessWidget {
  EventsHeaderPanel(
      {super.key});
  bool showMind = false;
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.only(top: 20, left:0),
      child: 
        Column(children: [
          Container(
            width: SizeConfig(context).screenWidth*0.6,
            height: 70,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 1.0,
                  spreadRadius: 0.1,
                  offset: Offset(
                    0.1,
                    0.11,
                  ),
                )
              ],
            ),
            child: Row(children: [
              Container(
                width: SizeConfig(context).screenWidth*0.4,
                child: Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 30)),
                    Expanded(
                      child: RichText(
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                              text: 'Discover',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 90, 90, 90), fontSize: 14),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator
                                    .pushReplacementNamed(
                                        context,
                                        RouteNames.events);
                                }
                            ),
                          ]),
                        ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 5)),
                    Expanded(
                      child: RichText(
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                              text: 'Going',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 90, 90, 90), fontSize: 14),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  ()=>{};
                                }
                            ),
                          ]),
                        ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 5)),
                    Expanded(
                      child: RichText(
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                              text: 'Interested',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 90, 90, 90), fontSize: 14),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  ()=>{};
                                }
                            ),
                          ]),
                        ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 5)),
                    Expanded(
                      child: RichText(
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                              text: 'Invited',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 90, 90, 90), fontSize: 14),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  ()=>{};
                                }
                            ),
                          ]),
                        ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 5)),
                    Expanded(
                      child: RichText(
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                              text: 'My Events',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 90, 90, 90), fontSize: 14),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator
                                    .pushReplacementNamed(
                                        context,
                                        RouteNames.events_manage);
                                }
                            ),
                          ]),
                        ),
                    ),
                ]),
              ),
              const Flexible(fit: FlexFit.tight, child: SizedBox()),
              Container(
                width: 120,
                margin: const EdgeInsets.only(right: 20),
                child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(3),
                          backgroundColor: Color.fromARGB(255, 45, 206, 137),
                          // elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0)),
                          minimumSize: const Size(120, 50),
                          maximumSize: const Size(120, 50),
                        ),
                        onPressed: () {
                          (showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              AlertDialog(
                                title: Row(children: const [
                                  Icon(Icons.event,color: Color.fromARGB(255, 247, 159, 88),),
                                  Text('Create New Event',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontStyle: FontStyle.italic
                                  ),),
                                ],),
                                content: CreateEventModal(context: context)
                              )
                        ));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                          Icon(Icons.add_circle),
                          Padding(padding: EdgeInsets.only(left: 4)),
                          Text('Create Event', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold))
                        ],)),
              )
            ],)
          )
        ],),
      );
  }
}
