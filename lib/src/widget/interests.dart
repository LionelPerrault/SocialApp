import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class InterestsWidget extends StatefulWidget {
  BuildContext context;
  Function sendUpdate;
  late PostController Postcon;
  InterestsWidget({Key? key, required this.context, required this.sendUpdate})
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
                'interested': false,
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
        Row(
          children: [
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text('INTERESTS',
                            style:
                                TextStyle(color: Colors.black, fontSize: 11)),
                        Flexible(fit: FlexFit.tight, child: SizedBox()),
                        const Padding(
                          padding: EdgeInsets.only(top: 30),
                        ),
                      ],
                    ),
                    Column(children: [
                      Column(
                        children: [
                          Container(
                            width: 750,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 250, 250, 250),
                                border: Border.all(color: Colors.grey)),
                            padding: const EdgeInsets.only(left: 20),
                            child: DropdownButton(
                              value: interests,
                              items: category
                                  .map((inte) => DropdownMenuItem(
                                        value: inte['title'],
                                        child: Text(inte['title'] == 'none'
                                            ? "Select Interests"
                                            : inte['title']),
                                      ))
                                  .toList(),
                              onChanged: (dynamic? value) {
                                interests = value!;
                                for (var i = 0;
                                    i < interestsCheck.length;
                                    i++) {
                                  if (interestsCheck[i]['parentId'] ==
                                      interests) {
                                    interestsCheck[i]['interested'] = true;
                                  }
                                }
                                setState(() {});
                                saveData = [];
                                for (int i = 0;
                                    i < interestsCheck.length;
                                    i++) {
                                  if (interestsCheck[i]['interested'] == true) {
                                    saveData.add(interestsCheck[i]['id']);
                                  }
                                }
                                widget.sendUpdate(saveData);
                              },
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 12),
                              dropdownColor: Colors.white,
                              underline: Container(),
                              isExpanded: true,
                              isDense: true,
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(bottom: 10))
                        ],
                      ),
                    ]),
                  ],
                )),
          ],
        ),
        //all interests
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
              Container(
                height: 300,
                child: ListView.builder(
                    itemCount: subCategory.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(children: [
                        Row(
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            Text(
                              subCategory[index]['title'],
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.black),
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
}
