
import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/utils/size_config.dart';

// ignore: must_be_immutable
class RightPanel extends StatelessWidget {
  RightPanel(
      {super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(top: SizeConfig.navbarHeight, left:SizeConfig.leftBarWidth+SizeConfig.mainPaneWidth),
      child: SizedBox(width: SizeConfig.rightPaneWidth,
        child: Text("This is right padding", style: TextStyle(color: Colors.red, fontSize: 30),),
      ),
    );    
  }
}
