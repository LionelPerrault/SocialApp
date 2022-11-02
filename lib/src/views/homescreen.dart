import 'dart:html';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/views/navigationbar.dart';

import '../controllers/HomeController.dart';
import '../utils/size_config.dart';
import '../widget/mprimary_button.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
    HomeScreen({Key? key})
        : con = HomeController(),
          super(key: key);
    final HomeController con;

    @override
    State createState() => HomeScreenState();
}

class HomeScreenState extends mvc.StateMVC<HomeScreen> {
    
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    //
    @override
    void initState() {
      add(widget.con);
      con = controller as HomeController;
      super.initState();
    }

    late HomeController con;

    @override
    Widget build(BuildContext context) {
        return Scaffold(
          key: _scaffoldKey,
          body: 
            Column(children: [
              ShnatterNavigation(),
              Text("text"),
              TextField(
                controller: new TextEditingController(text: "test"),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  labelText: 'Search',
                ),
              ),

            ],)
        );
    }
}
