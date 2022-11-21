import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

// ignore: must_be_immutable
class AdminSettingHeader extends StatefulWidget {
  AdminSettingHeader(
      {super.key,
      required this.icon,
      required this.pagename,
      this.button,
      this.headerTab = const []});
  Icon icon;
  // ignore: prefer_typing_uninitialized_variables
  List<Map> headerTab = [];
  String pagename;
  var button;
  @override
  State createState() => AdminSettingHeaderState();
}

class AdminSettingHeaderState extends mvc.StateMVC<AdminSettingHeader> {
  late String subTabname;
  void initState() {
    subTabname = widget.headerTab.isEmpty ? '' : widget.headerTab[0]['title'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 20, left: 15),
      height: widget.headerTab.isNotEmpty ? 100 : 65,
      decoration: const BoxDecoration(
        border: Border(
            bottom: BorderSide(
          color: Color.fromARGB(255, 220, 226, 237),
          width: 1,
        )),
        color: Color.fromARGB(255, 240, 243, 246),
        // borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: widget.headerTab.isEmpty
          ? Container(
              height: double.infinity,
              alignment: Alignment.center,
              child: mainHeaderWidget(),
            )
          : Column(
              children: [
                Container(
                  height: 60,
                  child: mainHeaderWidget(),
                ),
                Row(
                    children: widget.headerTab
                        .map((value) => InkWell(
                            onTap: () {
                              subTabname = value['title'];
                              value['onClick'](value['title']);
                              setState(() {});
                            },
                            child: Container(
                              color: subTabname == value['title']
                                  ? Colors.white
                                  : null,
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              height: 39,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(value['icon']),
                                    const Padding(
                                        padding: EdgeInsets.only(left: 10)),
                                    Text(value['title'])
                                  ]),
                            )))
                        .toList())
              ],
            ),
    );
  }

  Widget mainHeaderWidget() {
    return Row(
      children: [
        widget.icon,
        const Padding(padding: EdgeInsets.only(left: 10)),
        Text(widget.pagename),
        const Flexible(fit: FlexFit.tight, child: SizedBox()),
        widget.button['flag']
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(3),
                  backgroundColor: widget.button['buttoncolor'],
                  // elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)),
                  minimumSize: const Size(120, 50),
                  maximumSize: const Size(120, 50),
                ),
                onPressed: () {
                  (() => {});
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widget.button['icon'],
                    Text(widget.button['text'],
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.bold))
                  ],
                ))
            : SizedBox(),
        const Padding(padding: EdgeInsets.only(right: 30))
      ],
    );
  }
}
