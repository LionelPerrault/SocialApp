import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/utils/size_config.dart';

// ignore: must_be_immutable
class DayTimeM extends StatelessWidget {
  DayTimeM({super.key, required this.time, required this.username});
  int time;
  String username;
  List<Map> sampleData = [
    {
      'id': 'morning',
      'welcome': 'Good Morning, ',
      'message':
          'Write it on your heart that every day is the best day in the year',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2FdayTimeMessage%2Fsunrise.svg?alt=media&token=5ae999ef-086c-4c96-a161-c7ec9d8a2f2b',
    },
    {
      'id': 'afternoon',
      'welcome': 'Good Afternoon, ',
      'message':
          'May Your Good Afternoon Be Light, Blessed, Productive And Happy',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2FdayTimeMessage%2Fsun.svg?alt=media&token=89731a8a-6027-4b9c-b71b-af34dff68aca',
    },
    {
      'id': 'evening',
      'welcome': 'Good Evening, ',
      'message': 'We hope you are enjoying your evening',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2FdayTimeMessage%2Fnight.svg?alt=media&token=759baa82-e5be-4b88-9c03-6bc66510cd2d',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(4.0),
            topRight: Radius.circular(4.0),
          ),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                  left: BorderSide(
                color: Color.fromARGB(255, 251, 165, 64),
                width: 3,
              )),
              // borderRadius: BorderRadius.circular(12),
            ),
            height: 70,
            child: Row(children: [
              const Padding(padding: EdgeInsets.only(left: 20)),
              SizedBox(
                width: 42,
                child: SvgPicture.network(sampleData[time]['image']),
              ),
              const Padding(padding: EdgeInsets.only(left: 10)),
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        Container(
                          width: SizeConfig(context).screenWidth >
                                  SizeConfig.mediumScreenSize
                              ? SizeConfig(context).screenWidth -
                                  SizeConfig.leftBarAdminWidth -
                                  SizeConfig.rightPaneWidth -
                                  80
                              : SizeConfig(context).screenWidth - 130,
                          child: Text(
                            '${sampleData[time]['welcome']} $username',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: SizeConfig(context).screenWidth >
                              SizeConfig.mediumScreenSize
                          ? SizeConfig(context).screenWidth -
                              SizeConfig.leftBarAdminWidth -
                              SizeConfig.rightPaneWidth -
                              80
                          : SizeConfig(context).screenWidth - 130,
                      child: Text(sampleData[time]['message'],
                          style: const TextStyle(
                            fontSize: 14,
                          )),
                    ),
                  ]),
              const Flexible(fit: FlexFit.tight, child: SizedBox()),
              Container(
                height: 15,
                width: 15,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0)),
                    maximumSize: const Size(20, 20),
                    minimumSize: const Size(20, 20),
                  ),
                  onPressed: () {},
                  child: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
              )
            ]),
          )),
    );
  }
}
