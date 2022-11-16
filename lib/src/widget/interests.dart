import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/HomeController.dart';
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/colors.dart';

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shnatter/src/widget/startedInput.dart';


class CreateEventModal extends StatefulWidget {
  BuildContext context;
  late PostController Postcon;
  Function onClick;
  CreateEventModal({Key? key,required this.context,required this.onClick}) :Postcon = PostController(), super(key: key);
  @override
  State createState() => CreateEventModalState();
}
class CreateEventModalState extends mvc.StateMVC<CreateEventModal> {
  bool isSound = false;
  late PostController Postcon;
  Map<String, dynamic> eventInfo = {'eventPrivacy': 'public'};
  var interests = "none";
  var privacy = 'public';
  var interest = 'none';
  var interestsCheck = [];
  var parent;
  List category = [
    {
      'title' : 'none'
    }
  ];
  List subCategory = [];
  @override
  void initState(){
    add(widget.Postcon);
    Postcon = controller as PostController;
    Postcon.getAllInterests().then((allInterests) =>
    {
      for(int i = 0; i<allInterests.length; i++){
        if (allInterests[i]['parentId'] == '0') {
          category.add(allInterests[i])
        },
        subCategory.add(allInterests[i]),
        parent = allInterests.where((inte) => inte['id'] == allInterests[i]['parentId']).toList(),
        interestsCheck.add({'title' : allInterests[i]['title'], 'interested' : false, 'parentId' : parent.length == 0 ? allInterests[i]['title'] : parent[0]['title']})
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
                            style: TextStyle(
                                color: Colors.black, fontSize: 11)),
                        Flexible(
                            fit: FlexFit.tight, child: SizedBox()),
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
                                color: Color.fromARGB(
                                    255, 250, 250, 250),
                                border:
                                    Border.all(color: Colors.grey)),
                            padding: const EdgeInsets.only(left: 20),
                            child: DropdownButton(
                              value: interests,
                              items: 
                              category.map((inte) => 
                                DropdownMenuItem(
                                  value: inte['title'],
                                  child: Text(inte['title'] == 'none'? "Select Interests": inte['title']),
                                )
                              ).toList(),
                              onChanged: (dynamic? value) {
                                //get value when changed
                                interests = value!;
                                for (var i = 0; i < interestsCheck.length; i++) {
                                  if (interestsCheck[i]['parentId'] == interests) {
                                    interestsCheck[i]['interested'] = true;
                                  }
                                }
                                setState(() {});
                              },
                              style: const TextStyle(
                                  //te
                                  color: Colors.black, //Font color
                                  fontSize:
                                      12 //font size on dropdown button
                                  ),

                              dropdownColor: Colors.white,
                              underline:
                                  Container(), //remove underline
                              isExpanded: true,
                              isDense: true,
                            ),
                          ),
                          const Padding(
                              padding: EdgeInsets.only(bottom: 10))
                        ],
                      ),
                    ]),
                  ],)
                ),
              ],
            ),
            //all interests
            Container(
              height: 300,
              child: SingleChildScrollView(
                child: Column(children: [
                  Column(children: [
                      const Divider(
                        thickness: 0.1,
                        color: Colors.black,
                      ),
                      Row(children: const [
                      Padding(padding: EdgeInsets.only(left: 10)),
                      Text('Title',style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                      ),),
                      Flexible(fit: FlexFit.tight, child: SizedBox()),
                      Text('Check',style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                      ),),
                      Padding(padding: EdgeInsets.only(left: 30))
                    ],),
                    const Divider(
                      thickness: 0.1,
                      color: Colors.black,
                    )
                  ]),
                  Column(
                    children: 
                    subCategory.asMap().entries.map((inte) => 
                      Column(children: [ Row(children: [
                        const Padding(padding: EdgeInsets.only(left: 10)),
                        Text(inte.value['title'],style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black
                        ),),
                        const Flexible(fit: FlexFit.tight, child: SizedBox()),
                        Transform.scale(
                            scale: 0.7,
                            child: Checkbox(
                              fillColor:
                                  MaterialStateProperty.all<Color>(
                                      Colors.black),
                              checkColor: Colors.blue,
                              activeColor: const Color.fromRGBO(
                                  0, 123, 255, 1),
                              value: interestsCheck[inte.key]['interested'],
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          5.0))), // Rounded Checkbox
                              onChanged: (value) {
                                setState(() {
                                  interestsCheck[inte.key]['interested'] = !interestsCheck[inte.key]['interested'];
                                });
                              },
                            )),
                        const Padding(padding: EdgeInsets.only(left: 30))
                      ],),
                      Divider(
                        thickness: 0.1,
                        color: Colors.black,
                      )])
                              ).toList(),
                  )
                ]),
              ),
            ),
          ],
        );
  }
}