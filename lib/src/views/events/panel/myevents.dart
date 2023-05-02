// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/events/widget/eventcell.dart';

import '../../../controllers/PostController.dart';

class MyEvents extends StatefulWidget {
  MyEvents({Key? key, required this.routerChange})
      : con = PostController(),
        super(key: key);
  late PostController con;
  Function routerChange;

  @override
  State createState() => MyEventsState();
}

class MyEventsState extends mvc.StateMVC<MyEvents> {
  bool loading = false;
  late PostController con;
  var userInfo = UserManager.userInfo;
  var myEvents = [];
  int arrayLength = 0;
  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    getEventNow();
  }

  void getEventNow() {
    loading = true;
    setState(() {});
    con.getEvent('manage', UserManager.userInfo['uid']).then((value) => {
          myEvents = [...value],
          myEvents.where((event) =>
              event['data']['eventAdmin'] == UserManager.userInfo['id']),
          loading = false,
          setState(() {})
        });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = SizeConfig(context).screenWidth - SizeConfig.leftBarWidth;
    if (loading) {
      return Row(
        children: [
          Expanded(
              child: Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(color: Colors.grey),
          )),
        ],
      );
    }
    if (screenWidth <= 600) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: myEvents.isEmpty
            ? [
                Container(
                  padding: const EdgeInsets.only(top: 40),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.network(Helper.emptySVG, width: 90),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        width: 140,
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(240, 240, 240, 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: const Text(
                          'No data to show',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(108, 117, 125, 1)),
                        ),
                      ),
                    ],
                  ),
                )
              ]
            : myEvents
                .map(
                  (event) => EventCell(
                    routerChange: widget.routerChange,
                    eventData: event,
                    buttonFun: () {
                      // con.interestedEvent(event['id']).then((value) {
                      getEventNow();
                      // });
                    },
                  ),
                )
                .toList(),
      );
    }
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: myEvents.isEmpty
                ? Container(
                    padding: const EdgeInsets.only(top: 40),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.network(Helper.emptySVG, width: 90),
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          width: 140,
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(240, 240, 240, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: const Text(
                            'No data to show',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(108, 117, 125, 1)),
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.count(
                    crossAxisCount: screenWidth > 900
                        ? 3
                        : screenWidth > 600
                            ? 2
                            : 1,
                    // childAspectRatio: 2 / 3,
                    padding: const EdgeInsets.all(4.0),
                    mainAxisSpacing: 4.0,
                    shrinkWrap: true,
                    crossAxisSpacing: 4.0,
                    children: myEvents
                        .map(
                          (event) => EventCell(
                            routerChange: widget.routerChange,
                            eventData: event,
                            buttonFun: () {
                              getEventNow();
                            },
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
