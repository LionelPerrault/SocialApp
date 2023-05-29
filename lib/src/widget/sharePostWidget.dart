// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';

class SharePostModal extends StatefulWidget {
  BuildContext context;
  final PostController postCon;

  var postInfo;

  SharePostModal({
    Key? key,
    required this.context,
    required this.routerChange,
    required this.postInfo,
    this.editData,
  })  : postCon = PostController(),
        super(key: key);
  Function routerChange;

  var editData;
  @override
  State createState() => SharePostModalState();
}

class SharePostModalState extends mvc.StateMVC<SharePostModal> {
  bool isSound = false;
  late PostController postCon;
  bool postLoading = false;
  Color _color = const Color.fromRGBO(51, 103, 214, 0.65);
  double _width = 2;

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
    add(widget.postCon);
    postCon = controller as PostController;
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
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Column(
        children: [
          SingleChildScrollView(
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
                const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                          setState(() {
                            _color = const Color.fromRGBO(51, 103, 214, 0.65);
                            _width = 2;
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
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
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
                      // const Padding(padding: EdgeInsets.only(left: 15)),
                      // GestureDetector(
                      //   onTap: () {
                      //     print("Container clicked");
                      //     print(context);

                      //     setState(() {
                      //       _color2 = Color.fromRGBO(51, 103, 214, 0.65);
                      //       _color = Color.fromRGBO(0, 0, 0, 0.2);
                      //       _width2 = 2;
                      //       _width = 1;
                      //     });
                      //   },
                      //   child: Container(
                      //     alignment: Alignment.center,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(13),
                      //       border: Border.all(color: _color2, width: _width2),
                      //     ),
                      //     child: Column(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       crossAxisAlignment: CrossAxisAlignment.center,
                      //       children: [
                      //         Container(
                      //           alignment: Alignment.center,
                      //           width: 100,
                      //           height: 70,
                      //           child: const Icon(Icons.camera_enhance_rounded,
                      //               color: Colors.grey, size: 30.0),
                      //         ),
                      //         Row(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: const [
                      //             Text(
                      //               'Groups',
                      //               style: TextStyle(
                      //                   color: Color.fromRGBO(82, 95, 127, 1),
                      //                   fontSize: 13,
                      //                   fontWeight: FontWeight.w600),
                      //             ),
                      //           ],
                      //         ),
                      //         const Padding(padding: EdgeInsets.only(top: 15)),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                Row(
                  children: [
                    Expanded(
                      child: Container(
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
          Container(
            height: 50,
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
                    minimumSize: const Size(100, 50),
                  ),
                  onPressed: () async {
                    setState(() {});
                    if (_width != 2) return;
                    String postCase = 'share';
                    var postPayload;
                    String header = postMessage;

                    postPayload = widget.postInfo;

                    postLoading = true;
                    await postCon
                        .savePost(postCase, postPayload, 'Public',
                            header: header)
                        .then((value) {
                      postLoading = false;

                      setState(() {});
                      Navigator.of(context).pop(true);
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
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
        ],
      ),
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
        SizedBox(
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
                child: SizedBox(
                  height: height,
                  child: TextField(
                    controller: controller,
                    maxLines: line,
                    minLines: line,
                    textInputAction: TextInputAction.done,
                    onChanged: (value) {
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
