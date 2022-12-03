import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/utils/size_config.dart';

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
  late List<Widget> headerTab = [];
  @override
  void initState() {
    subTabname = widget.headerTab.isEmpty ? '' : widget.headerTab[0]['title'];
    
    WidgetsBinding.instance
        .addPostFrameCallback((_) {
          printHeaderTab();
          setState(() { });
        });
    super.initState();
  }
  void addEventListener(){

  }
  void printHeaderTab(){
    List<Widget> header = [];
    headerTab = [];
    int index = 0;
    for(int i = 0;i < widget.headerTab.length; i++){
        header.add(InkWell(
          onTap: () {
            subTabname = widget.headerTab[i]['title'];
            widget.headerTab[i]['onClick'](widget.headerTab[i]['title']);
            printHeaderTab();
            setState(() {});
          },
          child: Container(
            color: subTabname == widget.headerTab[i]['title']
                ? Colors.white
                : null,
            alignment: Alignment.center,
            width: 140,
            padding:
                const EdgeInsets.only(left: 20, right: 10,top: 10,bottom: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.headerTab[i]['icon']),
                  const Padding(
                      padding: EdgeInsets.only(left: 10)),
                      Expanded(child: 
                        Text(widget.headerTab[i]['title'])
                      )
                ]),
          )));
      if((i + 2 - index) * 140 + 15 >= SizeConfig(context).screenWidth || i == widget.headerTab.length- 1){
        headerTab.add(Row(
          children: header
              .map((value) => value).toList()));
        header = [];
        index = i + 1;
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 20, left: 15,top: 20,bottom: widget.headerTab.isEmpty ? 20 : 0),
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
              alignment: Alignment.center,
              child: mainHeaderWidget(),
            )
          :
             Column(
              children: [
                Container(
                  child: mainHeaderWidget(),
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                Column(
                    children: headerTab
                        .map((value) => value)
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
                        style: const TextStyle(
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
