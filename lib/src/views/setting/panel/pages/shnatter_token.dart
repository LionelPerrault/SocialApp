
import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/utils/svg.dart';
import 'package:shnatter/src/views/box/daytimeM.dart';
import 'package:shnatter/src/views/box/mindpost.dart';
import 'package:shnatter/src/views/setting/widget/setting_footer.dart';
import 'package:shnatter/src/views/setting/widget/setting_header.dart';
import 'package:shnatter/src/widget/mindslice.dart';
import 'package:shnatter/src/widget/startedInput.dart';

class SettingShnatterTokenScreen extends StatefulWidget {
  SettingShnatterTokenScreen({Key? key}) : super(key: key);
  @override
  State createState() => SettingShnatterTokenScreenState();
}
// ignore: must_be_immutable
class SettingShnatterTokenScreenState extends State<SettingShnatterTokenScreen> {
  var setting_security = {};
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.only(top: 20, left:30),
      child: 
        Column(children: [
          SettingHeader(icon: const Icon(Icons.money, color: Color.fromARGB(255, 76, 175, 80)), pagename: 'Shnatter Token',
            button: {'flag': false},),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Container(
            width: SizeConfig(context).screenWidth * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                width: 330,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                  Icon(Icons.money, color: Colors.black),
                  Text('Balance', style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),)
                ]),
              ),
              Container(
                width: 330,
                height: 190,
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
                    Text('Shnatter Token', style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),),
                    Text('100', style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),),
                ]),
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              Container(
              margin: EdgeInsets.all(5),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(3),
                  backgroundColor: const Color.fromARGB(255, 251, 99, 64),
                  // elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)),
                  minimumSize: const Size(330, 50),
                  maximumSize: const Size(330, 50),
                ),
                onPressed: () {
                  (()=>{});
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Buy Tokens', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold))
                ],)),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Blockchain Address', style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.all(3),
                        // elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0)),
                        minimumSize: const Size(330, 50),
                        maximumSize: const Size(330, 50),
                      ),
                      onPressed: () {
                        (()=>{});
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text('paymail', style: TextStyle(
                            color: Colors.black,
                          ),),
                          Flexible(fit: FlexFit.tight, child: SizedBox()),
                          Icon(Icons.file_copy, color: Colors.black,)
                    ],)),
                  ),
                ],
              )
            ],),
          ),
      ],)
      );
  }
  Widget button({url, text}) {
    return Expanded(
            flex: 1,
            child: Container(
              width: 90,
              height: 90,
              margin: EdgeInsets.all(5),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(3),
                  backgroundColor: Colors.white,
                  // elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)),
                  minimumSize: const Size(90, 90),
                  maximumSize: const Size(90, 90),
                ),
                onPressed: () {
                  (()=>{});
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                        decoration: BoxDecoration(
                      // color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                      child: SvgPicture.network(url),
                    ),
                  Text(text, style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold))
                ],))
            ),
            );
  }
}
