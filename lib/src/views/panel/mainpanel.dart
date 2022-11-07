
import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/utils/svg.dart';
import 'package:shnatter/src/views/box/daytimeM.dart';
import 'package:shnatter/src/views/box/mindpost.dart';
import 'package:shnatter/src/widget/mindslice.dart';

// ignore: must_be_immutable
class MainPanel extends StatelessWidget {
  MainPanel(
      {super.key});
  bool showMind = false;
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(top: 20, left:0),
      child: 
        Column(children: [
          MindPost(),
          const Padding(padding: EdgeInsets.only(top: 20)),
          DayTimeM(time: 'evening', username: 'Shnatter Admin'),
      ],)
      );
  }
}
