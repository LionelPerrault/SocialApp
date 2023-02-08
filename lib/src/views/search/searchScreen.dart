import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/views/events/panel/allevents.dart';
import 'package:shnatter/src/views/events/panel/goingevents.dart';
import 'package:shnatter/src/views/events/panel/interestedevents.dart';
import 'package:shnatter/src/views/events/panel/invitedevents.dart';
import 'package:shnatter/src/views/events/panel/myevents.dart';
import 'package:shnatter/src/widget/createEventWidget.dart';

import '../../controllers/PostController.dart';
import '../../utils/size_config.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key, required this.routerChange})
      : con = PostController(),
        super(key: key);
  final PostController con;
  Function routerChange;

  @override
  State createState() => SearchScreenState();
}

class SearchScreenState extends mvc.StateMVC<SearchScreen>
    with SingleTickerProviderStateMixin {
  //route variable
  String searchPageRoute = '';
  late PostController con;

  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [],
            ),
          ),
        ],
      ),
    );
  }

  Widget searchRouteWidget() {
    switch (searchPageRoute) {
      case 'value':
        return Container();
      default:
        return Container();
    }
  }
}
