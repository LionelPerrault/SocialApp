import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class InterestsWidget extends StatefulWidget {
  BuildContext context;
  Function sendUpdate;
  var data;
  late PostController Postcon;
  bool header;
  InterestsWidget(
      {Key? key,
      required this.context,
      required this.sendUpdate,
      this.data,
      this.header = false})
      : Postcon = PostController(),
        super(key: key);
  @override
  State createState() => InterestsWidgetState();
}

class InterestsWidgetState extends mvc.StateMVC<InterestsWidget> {
  bool isSound = false;
  late PostController Postcon;
  var interests = "none";
  var interest = 'none';
  var interestsCheck = [];
  var parent;
  var saveData;
  List category = [
    {'title': 'none'}
  ];
  List subCategory = [];
  @override
  void initState() {
    add(widget.Postcon);
    Postcon = controller as PostController;
    Postcon.getAllInterests().then((allInterests) => {
          for (int i = 0; i < allInterests.length; i++)
            {
              if (allInterests[i]['parentId'] == '0')
                {category.add(allInterests[i])},
              subCategory.add(allInterests[i]),
              parent = allInterests
                  .where((inte) => inte['id'] == allInterests[i]['parentId'])
                  .toList(),
              interestsCheck.add({
                'id': allInterests[i]['id'],
                'title': allInterests[i]['title'],
                'interested': (widget.data != null &&
                        widget.data
                                .where((inte) => inte == allInterests[i]['id'])
                                .length >
                            0)
                    ? true
                    : false,
                'parentId': parent.length == 0
                    ? allInterests[i]['title']
                    : parent[0]['title']
              }),
              setState(() {})
            }
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Row(
        //   children: [
        //     Expanded(
        //         flex: 1,
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Row(
        //               children: const [
        //                 Text('INTERESTS',
        //                     style:
        //                         TextStyle(color: Colors.black, fontSize: 11)),
        //                 Flexible(fit: FlexFit.tight, child: SizedBox()),
        //                 const Padding(
        //                   padding: EdgeInsets.only(top: 30),
        //                 ),
        //               ],
        //             ),
        //             Column(children: [
        //               Column(
        //                 children: [
        //                   Container(
        //                     width: 750,
        //                     decoration: BoxDecoration(
        //                         color: Color.fromARGB(255, 250, 250, 250),
        //                         border: Border.all(color: Colors.grey)),
        //                     padding: const EdgeInsets.only(left: 20),
        //                     child: DropdownButton(
        //                       value: interests,
        //                       items: category
        //                           .map((inte) => DropdownMenuItem(
        //                                 value: inte['title'],
        //                                 child: Text(inte['title'] == 'none'
        //                                     ? "Select Interests"
        //                                     : inte['title']),
        //                               ))
        //                           .toList(),
        //                       onChanged: (dynamic? value) {
        //                         interests = value!;
        //                         for (var i = 0;
        //                             i < interestsCheck.length;
        //                             i++) {
        //                           if (interestsCheck[i]['parentId'] ==
        //                               interests) {
        //                             interestsCheck[i]['interested'] = true;
        //                           }
        //                         }
        //                         setState(() {});
        //                         saveData = [];
        //                         for (int i = 0;
        //                             i < interestsCheck.length;
        //                             i++) {
        //                           if (interestsCheck[i]['interested'] == true) {
        //                             saveData.add(interestsCheck[i]['id']);
        //                           }
        //                         }
        //                         widget.sendUpdate(saveData);
        //                       },
        //                       style: const TextStyle(
        //                           color: Colors.black, fontSize: 12),
        //                       dropdownColor: Colors.white,
        //                       underline: Container(),
        //                       isExpanded: true,
        //                       isDense: true,
        //                     ),
        //                   ),
        //                   const Padding(padding: EdgeInsets.only(bottom: 10))
        //                 ],
        //               ),
        //             ]),
        //           ],
        //         )),
        //   ],
        // ),
        //all interests
        widget.header
            ? Row(
                children: const [
                  Text('INTERESTS',
                      style: TextStyle(color: Colors.black, fontSize: 11)),
                  Flexible(fit: FlexFit.tight, child: SizedBox()),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                  ),
                ],
              )
            : const SizedBox(),
        widget.header
            ? Column(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: 750,
                              child: customDropDownButton(
                                title: '',
                                width: 400,
                                item: category,
                                value: 'none',
                                onChange: (dynamic value) {
                                  //get value when changed
                                  handleOnchange(value);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Container(
                      //   width: 750,
                      //   decoration: BoxDecoration(
                      //       color: const Color.fromARGB(255, 250, 250, 250),
                      //       border: Border.all(color: Colors.grey)),
                      //   padding: const EdgeInsets.only(left: 20),
                      //   child: DropdownButton(
                      //     value: interests,
                      //     items: category
                      //         .map((inte) => DropdownMenuItem(
                      //               value: inte['title'],
                      //               child: Text(inte['title'] == 'none'
                      //                   ? "Select Interests"
                      //                   : inte['title']),
                      //             ))
                      //         .toList(),
                      //     onChanged: (dynamic value) {
                      //       //get value when changed
                      //       handleOnchange(value);
                      //     },
                      //     style: const TextStyle(
                      //         //te
                      //         color: Colors.black, //Font color
                      //         fontSize: 12 //font size on dropdown button
                      //         ),
                      //     dropdownColor: Colors.white,
                      //     underline: Container(), //remove underline
                      //     isExpanded: true,
                      //     isDense: true,
                      //   ),
                      // ),
                      const Padding(padding: EdgeInsets.only(bottom: 10))
                    ],
                  ),
                ],
              )
            : const SizedBox(),
        Container(
          child: SingleChildScrollView(
            child: Column(children: [
              Column(children: [
                const Divider(
                  thickness: 0.1,
                  color: Colors.black,
                ),
                Row(
                  children: const [
                    Padding(padding: EdgeInsets.only(left: 10)),
                    Text(
                      'Title',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Flexible(fit: FlexFit.tight, child: SizedBox()),
                    Text(
                      'Check',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Padding(padding: EdgeInsets.only(left: 30))
                  ],
                ),
                const Divider(
                  thickness: 0.1,
                  color: Colors.black,
                )
              ]),
              SizedBox(
                height: 250,
                child: ListView.builder(
                    itemCount: subCategory.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(children: [
                        Row(
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            Expanded(
                              child: SizedBox(
                                width: 400,
                                child: Text(
                                  subCategory[index]['title'],
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.black),
                                ),
                              ),
                            ),
                            const Flexible(
                                fit: FlexFit.tight, child: SizedBox()),
                            Transform.scale(
                                scale: 0.7,
                                child: Checkbox(
                                  fillColor: MaterialStateProperty.all<Color>(
                                      Colors.black),
                                  checkColor: Colors.blue,
                                  activeColor:
                                      const Color.fromRGBO(0, 123, 255, 1),
                                  value: interestsCheck[index]['interested'],
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0))),
                                  onChanged: (value) {
                                    setState(() {
                                      interestsCheck[index]['interested'] =
                                          !interestsCheck[index]['interested'];
                                    });
                                    saveData = [];
                                    for (int i = 0;
                                        i < interestsCheck.length;
                                        i++) {
                                      if (interestsCheck[i]['interested'] ==
                                          true) {
                                        saveData.add(interestsCheck[i]['id']);
                                        setState(() {});
                                      }
                                    }
                                    widget.sendUpdate(saveData);
                                  },
                                )),
                            const Padding(padding: EdgeInsets.only(left: 30))
                          ],
                        ),
                        Divider(
                          thickness: 0.1,
                          color: Colors.black,
                        )
                      ]);
                    }),
              )
            ]),
          ),
        ),
      ],
    );
  }

  handleOnchange(value) {
    interests = value!;
    for (var i = 0; i < subCategory.length; i++) {
      if (category[int.parse(subCategory[i]['parentId'])]['title'] ==
              interests ||
          subCategory[i]['title'] == interests) {
        interestsCheck[i]['interested'] = true;
      }
    }
    setState(() {});
    saveData = [];
    for (int i = 0; i < interestsCheck.length; i++) {
      if (interestsCheck[i]['interested'] == true) {
        saveData.add(interestsCheck[i]['id']);
        setState(() {});
      }
    }
    widget.sendUpdate(saveData);
  }

  Widget customDropDownButton(
      {title, double width = 0, item = const [], value, onChange}) {
    List items = item;
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Color.fromRGBO(82, 95, 127, 1),
                fontSize: 13,
                fontWeight: FontWeight.w600),
          ),
          const Padding(padding: EdgeInsets.only(top: 2)),
          Container(
            height: 40,
            // width: width,
            child: DropdownButtonFormField(
              value: value,
              items: items
                  .map((e) => DropdownMenuItem(
                      value: e['title'],
                      child: Text(e['title'] == 'none'
                          ? "Select Interests"
                          : e['title'])))
                  .toList(),
              onChanged: onChange,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(top: 10, left: 10),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 1),
                ),
              ),
              icon: const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Icon(Icons.arrow_drop_down)),
              iconEnabledColor: Colors.grey, //Icon color

              style: const TextStyle(
                color: Colors.grey, //Font color
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              dropdownColor: Colors.white,
              isExpanded: true,
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }
}
