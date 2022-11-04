
import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/utils/size_config.dart';

// ignore: must_be_immutable
class DayTimeM extends StatelessWidget {
  DayTimeM(
      {super.key,
      required this.time,
      required this.username});
  String time;
  String username;
  List<Map> sampleData = [
    {
      'id': 'morning',
      'welcome': 'Good Morning',
      'message': 'Write it on your heart that every day is the best day in the year',
      'image': 'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2FdayTimeMessage%2Fsunrise.svg?alt=media&token=5ae999ef-086c-4c96-a161-c7ec9d8a2f2b',
    },
    {
      'id': 'afternoon',
      'welcome': 'Good Afternoon',
      'message': 'May Your Good Afternoon Be Light, Blessed, Productive And Happy',
      'image': 'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2FdayTimeMessage%2Fsun.svg?alt=media&token=89731a8a-6027-4b9c-b71b-af34dff68aca',
    },
    {
      'id': 'evening',
      'welcome': 'Good Morning',
      'message': 'We hope you are enjoying your evening',
      'image': 'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2FdayTimeMessage%2Fnight.svg?alt=media&token=759baa82-e5be-4b88-9c03-6bc66510cd2d',
    },
  ];
  @override
  Widget build(BuildContext context) {
    List<Map> result = sampleData.where((i) => i['id']==time).toList();
    return Container(
      height: 42,
      width: SizeConfig(context).screenWidth * 0.4,
      child: Row(children: [
        SizedBox(width:SizeConfig(context).screenWidth * 0.4, child: SvgPicture.network(result[0]['image']),),
        Column(children: [
          Row(children: [
            Text(result[0]['welcome'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            Text(username, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ],),
          Text(result[0]['message'], style: const TextStyle(fontSize: 14,)),
        ],),
        Container(child: Icon(Icons.close))
      ]),
    );
  }
}
