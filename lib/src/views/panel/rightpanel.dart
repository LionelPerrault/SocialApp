
import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/utils/size_config.dart';
import '../box/users_suggestion_box.dart';
import '../box/pages_suggestion_box.dart';
import '../box/groups_suggestion_box.dart';
import '../box/events_suggestion_box.dart';

// ignore: must_be_immutable
class RightPanel extends StatelessWidget {
  RightPanel(
      {super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(top: SizeConfig.navbarHeight, left:SizeConfig.leftBarWidth+SizeConfig.mainPaneWidth),
      child: SizedBox(width: SizeConfig.rightPaneWidth,
        child: Row(children: [
          SingleChildScrollView(
            child: Column(children: [
              Container(
                child: Column(children: [
                  Padding(padding: EdgeInsets.only(top: 20.0),),
                  ShnatterUserSuggest(),
                  Padding(padding: EdgeInsets.only(top: 10.0),),
                  ShnatterPageSuggest(),
                  Padding(padding: EdgeInsets.only(top: 10.0),),
                  ShnatterGroupSuggest(),
                  Padding(padding: EdgeInsets.only(top: 10.0),),
                  ShnatterEventSuggest(),
                ]),
              )
            ]),
          ),
        ],)
        
      ),
    );    
  }
}