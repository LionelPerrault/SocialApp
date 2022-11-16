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
  CreateEventModal({Key? key,required this.context}) :Postcon = PostController(), super(key: key);
  @override
  State createState() => CreateEventModalState();
}
class CreateEventModalState extends mvc.StateMVC<CreateEventModal> {
  bool isSound = false;
  late PostController Postcon;
  Map<String, dynamic> eventInfo = {'eventPrivacy': 'public'};
  var privacy = 'public';
  var interest = 'none';
  @override
  void initState(){
    add(widget.Postcon);
    Postcon = controller as PostController;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Divider(
              height: 0,
              indent: 0,
              endIndent: 0,
            ),
            const Padding(padding: EdgeInsets.only(top: 15)),
            Column(
              mainAxisAlignment:
                  MainAxisAlignment.start,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text(
                      'Name Your Event',
                      style: TextStyle(
                          color: Color.fromARGB(
                              255, 82, 95, 127),
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  width: 400,
                  child:
                      input(validator: (value) async {
                    print(value);
                  }, onchange: (value) async {
                    eventInfo['eventName'] = value;
                    // setState(() {});
                  }),
                )
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 15)),
            Column(
              mainAxisAlignment:
                  MainAxisAlignment.start,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text('Location',
                        style: TextStyle(
                            color: Color.fromARGB(
                                255, 82, 95, 127),
                            fontSize: 11,
                            fontWeight:
                                FontWeight.bold)),
                  ],
                ),
                Container(
                  width: 400,
                  child:
                      input(validator: (value) async {
                    print(value);
                  }, onchange: (value) async {
                    eventInfo['eventLocation'] = value;
                    // setState(() {});
                  }),
                )
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 15)),
            Column(
              mainAxisAlignment:
                  MainAxisAlignment.start,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text('Start Date',
                        style: TextStyle(
                            color: Color.fromARGB(
                                255, 82, 95, 127),
                            fontSize: 11,
                            fontWeight:
                                FontWeight.bold)),
                  ],
                ),
                Container(
                  width: 400,
                  child:
                      input(validator: (value) async {
                    print(value);
                  }, onchange: (value) async {
                    eventInfo['eventStartDate'] = value;
                    // setState(() {});
                  }),
                )
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 15)),
            Column(
              mainAxisAlignment:
                  MainAxisAlignment.start,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text('End Date',
                        style: TextStyle(
                            color: Color.fromARGB(
                                255, 82, 95, 127),
                            fontSize: 11,
                            fontWeight:
                                FontWeight.bold)),
                  ],
                ),
                Container(
                  width: 400,
                  child:
                      input(validator: (value) async {
                    print(value);
                  }, onchange: (value) async {
                    eventInfo['eventEndDate'] = value;
                    // setState(() {});
                  }),
                )
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 15)),
            Column(
              mainAxisAlignment:
                  MainAxisAlignment.start,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text('Select Privacy',
                        style: TextStyle(
                            color: Color.fromARGB(
                                255, 82, 95, 127),
                            fontSize: 11,
                            fontWeight:
                                FontWeight.bold)),
                  ],
                ),
              ],
            ),
            Row(children: [
              Expanded(
                child: SizedBox(
                  width: 400,
                  height: 40,
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 17, 205, 239),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                            color: const Color.fromARGB(255, 17, 205, 239),
                            width: 0.1), //bordrder raiuds of dropdown button
                      ),
                      child: Padding(
                          padding: const EdgeInsets.only(top: 7, left: 15),
                          child: DropdownButton(
                            value: privacy,
                            items: [
                              DropdownMenuItem(
                                value: "public",
                                child: Row(children: const [
                                  Icon(
                                    Icons.language,
                                    color: Colors.black,
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 5)),
                                  Text(
                                    "Public",
                                    style: TextStyle(fontSize: 13),
                                  )
                                ]),
                              ),
                              DropdownMenuItem(
                                value: "friends",
                                child: Row(children: const [
                                  Icon(
                                    Icons.groups,
                                    color: Colors.black,
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 5)),
                                  Text(
                                    "Friends",
                                    style: TextStyle(fontSize: 13),
                                  )
                                ]),
                              ),
                              DropdownMenuItem(
                                value: "friendsof",
                                child: Row(children: const [
                                  Icon(
                                    Icons.groups,
                                    color: Colors.black,
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 5)),
                                  Text(
                                    "Friends of Friends",
                                    style: TextStyle(fontSize: 13),
                                  )
                                ]),
                              ),
                              DropdownMenuItem(
                                value: "onlyme",
                                child: Row(children: const [
                                  Icon(
                                    Icons.lock_outline,
                                    color: Colors.black,
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 5)),
                                  Text(
                                    "Only Me",
                                    style: TextStyle(fontSize: 13),
                                  )
                                ]),
                              ),
                            ],
                            onChanged: (value) {
                              //get value when changed
                              eventInfo['eventPrivacy'] = value;
                              privacy = value.toString();
                              print(privacy);
                              // click(value);
                              setState(() {});
                            },
                            icon: const Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Icon(Icons.arrow_drop_down)),
                            iconEnabledColor: Colors.white, //Icon color
                            style: const TextStyle(
                              color: Colors.black, //Font color
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                            dropdownColor: Colors.white,
                            underline: Container(), //remove underline
                            isExpanded: true,
                            isDense: true,
                          ))),
                ),
              ),
            ],),
            const Padding(padding: EdgeInsets.only(top: 15)),
            Column(
              mainAxisAlignment:
                  MainAxisAlignment.start,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text('About',
                            style: TextStyle(
                                color: Color.fromARGB(
                                    255, 82, 95, 127),
                                fontSize: 11,
                                fontWeight: FontWeight.bold)),
                        Container(
                          width: 400,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(
                                  255, 250, 250, 250),
                              border:
                                  Border.all(color: Colors.grey)),
                          child: TextFormField(
                                minLines: 1,
                                maxLines: 4,
                                onChanged: (value) async {
                                  eventInfo['eventAbout'] = value;
                                  // setState(() {});
                                },
                                keyboardType: TextInputType.multiline,
                                style: TextStyle(fontSize: 12),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  hintText: '',
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                              ),
                        ),
                      ],)
                    ),
                  ],
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
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
                        )
                      ],
                    ),
                    Column(children: [
                      Column(
                        children: [
                          Container(
                            width: 400,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(
                                    255, 250, 250, 250),
                                border:
                                    Border.all(color: Colors.grey)),
                            padding: const EdgeInsets.only(left: 20),
                            child: DropdownButton(
                              value: interest,
                              items: const [
                                //add items in the dropdown
                                DropdownMenuItem(
                                  value: "none",
                                  child: Text("Select Category"),
                                ),
                                DropdownMenuItem(
                                    value: "automotive",
                                    child: Text("Automotive")),
                                DropdownMenuItem(
                                  value: "beauty",
                                  child: Text("Beauty"),
                                )
                              ],
                              onChanged: (String? value) {
                                //get value when changed
                                interest= value!;
                                eventInfo['eventCategory'] = value;
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
                        ],
                      ),
                    ]),
                  ],)
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 15)),
            Container(
              width: 400,
              margin: const EdgeInsets.only(right: 0),
              child: Row(children: [
                const Flexible(
                  fit: FlexFit.tight, child: SizedBox()),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[400],
                    shadowColor: Colors.grey[400],
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0)),
                    minimumSize: Size(100, 50),
                  ),
                  onPressed: () {
                    Navigator.of(widget.context).pop(true);
                  },
                  child: const Text('Cancel',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const Padding(padding: EdgeInsets.only(left: 10)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shadowColor: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0)),
                    minimumSize: Size(100, 50),
                  ),
                  onPressed: () {
                    Postcon.createEvent(context,eventInfo);
                  },
                  child: const Text('Create',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                )
              ],),
            ),
          ],
        );
  }
}
Widget input({label, onchange, obscureText = false, validator}) {
    return Container(
      height: 28,
      child: StartedInput(
        validator: (val) async {
          validator(val);
        },
        obscureText: obscureText,
        onChange: (val) async {
          onchange(val);
        },
      ),
    );
  }