
import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/utils/size_config.dart';

// ignore: must_be_immutable
class MainPanel extends StatelessWidget {
  MainPanel(
      {super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(top: 0, left:0),
      child: Container(
        //width:double.infinity,
        //height: double.infinity,
        decoration: BoxDecoration(color: Colors.grey),
        child: Text("This is body", style: TextStyle(color: Colors.red, fontSize: 30),),
      )        
      );
  }
}
