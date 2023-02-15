// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/date_symbols.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'dart:io' show File;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as PPath;
import 'package:shnatter/src/widget/alertYesNoWidget.dart';

class SharePostModal extends StatefulWidget {
  BuildContext context;
  final PostController Postcon;

  String postId;

  SharePostModal({
    Key? key,
    required this.context,
    required this.routerChange,
    required this.postId,
    this.editData,
  })  : Postcon = PostController(),
        super(key: key);
  Function routerChange;

  var editData;
  @override
  State createState() => SharePostModalState();
}

class SharePostModalState extends mvc.StateMVC<SharePostModal> {
  bool isSound = false;
  late PostController Postcon;
  bool postLoading = false;
  Color _color = Color.fromRGBO(0, 0, 0, 0.2);
  Color _color2 = Color.fromRGBO(0, 0, 0, 0.2);
  double _width = 1;
  double _width2 = 1;

  String postMessage = '';
  double uploadPhotoProgress = 0;
  List<dynamic> productPhoto = [];
  List<dynamic> productFile = [];
  double uploadFileProgress = 0;
  var photoLength;
  var fileLength;
  bool offer1 = true;
  bool offer2 = false;
  bool footerBtnState = false;
  bool payLoading = false;
  // bool loading = false;
  @override
  void initState() {
    add(widget.Postcon);
    Postcon = controller as PostController;
    if (widget.editData == null) {
      widget.editData = {
        'id': '',
        'data': {},
      };
    } else {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: SizeConfig(context).screenHeight - 300,
          child: SingleChildScrollView(
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
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Share the post to',
                        style: TextStyle(
                            color: Color.fromRGBO(82, 95, 127, 1),
                            fontSize: 23,
                            fontWeight: FontWeight.w600),
                      ),
                    ]),
                const Padding(padding: EdgeInsets.only(top: 25)),
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          print("Container clicked");
                          setState(() {
                            _color = Color.fromRGBO(51, 103, 214, 0.65);
                            _color2 = Color.fromRGBO(0, 0, 0, 0.2);
                            _width = 2;
                            _width2 = 1;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            border: Border.all(color: _color, width: _width),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 100,
                                height: 70,
                                child: const Icon(Icons.camera_enhance_rounded,
                                    color: Colors.grey, size: 30.0),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Timeline',
                                    style: TextStyle(
                                        color: Color.fromRGBO(82, 95, 127, 1),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const Padding(padding: EdgeInsets.only(top: 15)),
                            ],
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(left: 15)),
                      GestureDetector(
                        onTap: () {
                          print("Container clicked");
                          print(context);

                          setState(() {
                            _color2 = Color.fromRGBO(51, 103, 214, 0.65);
                            _color = Color.fromRGBO(0, 0, 0, 0.2);
                            _width2 = 2;
                            _width = 1;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            border: Border.all(color: _color2, width: _width2),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 100,
                                height: 70,
                                child: const Icon(Icons.camera_enhance_rounded,
                                    color: Colors.grey, size: 30.0),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Groups',
                                    style: TextStyle(
                                        color: Color.fromRGBO(82, 95, 127, 1),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const Padding(padding: EdgeInsets.only(top: 15)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: 400,
                        child: titleAndsubtitleInput('Message', 70, 5,
                            (value) async {
                          //postMessage = controller.text;

                          setState(() {});
                        }, widget.editData['data']['productAbout'] ?? ''),
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
                const Divider(
                  thickness: 0.1,
                  color: Colors.black,
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
              ],
            ),
          ),
        ),
        Container(
          width: 400,
          margin: const EdgeInsets.only(right: 20, bottom: 10),
          child: Row(
            children: [
              const Flexible(fit: FlexFit.tight, child: SizedBox()),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shadowColor: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)),
                  minimumSize: Size(100, 50),
                ),
                onPressed: () async {
                  setState(() {});
                  String postCase = 'share';
                  var postPayload;
                  String header = postMessage;

                  postPayload = widget.postId;

                  postLoading = true;
                  await Postcon.savePost(postCase, postPayload, 'Public',
                          header: header)
                      .then((value) {
                    print('after');
                    postLoading = false;

                    setState(() {});
                  });
                },
                child: footerBtnState
                    ? const SizedBox(
                        width: 10,
                        height: 10.0,
                        child: CircularProgressIndicator(
                          color: Colors.grey,
                        ),
                      )
                    : const Text('Share',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget customInput({title, onChange, value}) {
    return Column(
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
          child: TextFormField(
            initialValue: value,
            onChanged: (value) {
              onChange(value);
            },
            keyboardType:
                title == 'Price' ? TextInputType.number : TextInputType.text,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(top: 10, left: 10),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.0),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget titleAndsubtitleInput(title, double height, line, onChange, value) {
    TextEditingController controller = TextEditingController();
    controller.text = value;
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 85, 95, 127)),
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  width: 400,
                  height: height,
                  child: TextField(
                    controller: controller,
                    maxLines: line,
                    minLines: line,
                    onChanged: (value) {
                      //controller.text = controller.text + value;
                      //onChange(value);
                      //print(controller.text);
                      postMessage = controller.text;
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(top: 10, left: 10),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
