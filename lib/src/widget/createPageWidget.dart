
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
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/widget/interests.dart';
import 'package:shnatter/src/widget/startedInput.dart';


class CreatePageModal extends StatefulWidget {
  BuildContext context;
  late PostController Postcon;
  CreatePageModal({Key? key,required this.context}) :Postcon = PostController(), super(key: key);
  @override
  State createState() => CreatePageModalState();
}
class CreatePageModalState extends mvc.StateMVC<CreatePageModal> {
  bool isSound = false;
  late PostController Postcon;
  Map<String, dynamic> pageInfo = {};
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
    return SingleChildScrollView(
        child: Column(
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
                      'Name Your Page',
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
                    pageInfo['pageName'] = value;
                    // setState(() {});
                  }),
                )
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 15)),
            
            const Padding(padding: EdgeInsets.only(top: 15)),
            Column(
              mainAxisAlignment:
                  MainAxisAlignment.start,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text('Page Username',
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
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                    ),
                    child: Row(children: [
                      Container(
                        padding: EdgeInsets.only(top: 7),
                        alignment: Alignment.topCenter,
                        width: 240,
                        height: 30,
                        color: Colors.grey,
                        child: Text('https://test.shnatter.com/pages'),
                      ),
                      Expanded(child: 
                      Container(
                        width: 260,
                        height: 30,
                        child: TextFormField(
                                onChanged: (value) {
                                  pageInfo['pageUserName'] = value;
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 54, 54, 54), width: 1.0),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                                style: const TextStyle(fontSize: 14),
                                onSaved: (String? value) {
                                  // This optional block of code can be used to run
                                  // code when the user saves the form.
                                },
                                validator: (String? value) {
                                  return (value != null && value.contains('@'))
                                      ? 'Do not use the @ char.'
                                      : null;
                                },
                              ),
                      )),
                    ]),
                  ),
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
                    pageInfo['pageLocation'] = value;
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
                                  pageInfo['pageAbout'] = value;
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
            Container(
              width: 400,
              child: InterestsWidget(context: context, sendUpdate: (value) {
                pageInfo['pageInterests'] = value;
              },),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
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
                    Postcon.createPage(context, pageInfo);
                    print(pageInfo);
                  },
                  child: const Text('Create',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                )
              ],),
            ),
          ],
        )
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