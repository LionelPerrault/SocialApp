import 'package:flutter/material.dart';

import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/widget/createProductWidget.dart';
import 'package:shnatter/src/widget/mindslice.dart';

import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

class MindPost extends StatefulWidget {
  const MindPost({Key? key}) : super(key: key);
  @override
  State createState() => MindPostState();
}

// ignore: must_be_immutable
class MindPostState extends mvc.StateMVC<MindPost> {
  String dropdownValue = 'Public';
  final _focus = FocusNode();
  final ScrollController _scrollController = ScrollController();
  var show = false;
  var notActionShow = false;
  var state = false;
  List<Map> mindPostCase = [
    {
      'title': 'Upload Photos',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Fcamera.svg?alt=media&token=0b7478a3-c746-47ed-a4fc-7505accf22a5',
      'mindFunc': (context) {}
    },
    {
      'title': 'Create Album',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Falbum.svg?alt=media&token=a24aeb90-c93c-4a92-b116-7d85f2a3acbc',
      'mindFunc': (context) {}
    },
    {
      'title': 'Feelings/Activity',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Femoji.svg?alt=media&token=d8ff786b-c7e0-4922-a260-0627bacab851',
      'mindFunc': (context) {}
    },
    {
      'title': 'Check In',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Fcheckin.svg?alt=media&token=6f228dbc-b1a4-4d13-860b-18b686602738',
      'mindFunc': (context) {}
    },
    {
      'title': 'Colored Posts',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Fcolor.svg?alt=media&token=7d8b7631-2471-4acf-8f34-e0071e7a4600',
      'mindFunc': (context) {}
    },
    {
      'title': 'Voice Notes',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Fvoice.svg?alt=media&token=b49c28b5-3b27-487e-a6c1-ffd978c215fa',
      'mindFunc': (context) {}
    },
    {
      'title': 'Write Aticle',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Farticle.svg?alt=media&token=585f68e4-bc57-4b5f-a55e-0e2f4e686809',
      'mindFunc': (context) {}
    },
    {
      'title': 'Sell Something',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Fsellsomething.svg?alt=media&token=d4de8d00-e075-4e6f-8f65-111616413dda',
      'mindFunc': (context) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Row(
              children: const [
                Icon(
                  Icons.production_quantity_limits_sharp,
                  color: Color.fromARGB(255, 33, 150, 243),
                ),
                Text(
                  'Add New Product',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontStyle: FontStyle.italic),
                ),
              ],
            ),
            content: CreateProductModal(context: context),
          ),
        );
      }
    },
    {
      'title': 'Create Poll',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Fpoll.svg?alt=media&token=9a0f6f31-3685-42ce-9a2b-f18a512d3829',
      'mindFunc': (context) {}
    },
    {
      'title': 'Upload Video',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Fvideo_camera.svg?alt=media&token=89343741-3bfc-4001-87d4-9344e752192d',
      'mindFunc': (context) {}
    },
    {
      'title': 'Upload Audio',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Fmusic_file.svg?alt=media&token=b2d62e94-0c58-487e-b3dc-da02bdfd7ac9',
      'mindFunc': (context) {}
    },
    {
      'title': 'Upload File',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Ffolder.svg?alt=media&token=8a62d7d4-95dc-4f0b-8a62-3c9ef26aec81',
      'mindFunc': (context) {}
    },
  ];
  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  void _onFocusChange() {
    var future = Future.delayed(const Duration(milliseconds: 100), () {
      if (state) {
        show = true;
        state = false;
        return;
      }
      if (!notActionShow) {
        show = !show;
      } else {
        state = true;
        notActionShow = false;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: SizeConfig(context).screenWidth > SizeConfig.smallScreenSize
            ? 530
            : 350,
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Column(children: [
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 250, 250, 250),
              borderRadius: BorderRadius.circular(2),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(255, 230, 230, 230),
                  blurRadius: 0.1,
                  spreadRadius: 0.1,
                  offset: Offset(
                    -1,
                    1,
                  ),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 35,
                  height: 35,
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    backgroundImage: NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fblank_package.png?alt=media&token=f5cf4503-e36b-416a-8cce-079dfcaeae83"),
                  ),
                ),
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10, right: 4),
                  child: TextField(
                    controller: null,
                    // cursorColor: Colors.white,
                    focusNode: _focus,
                    style: const TextStyle(color: Color.fromARGB(255, 3, 3, 3)),
                    decoration: const InputDecoration(
                      hoverColor: Color.fromARGB(255, 250, 250, 250),
                      filled: true,
                      fillColor: Color.fromARGB(255, 250, 250, 250),
                      hintText:
                          'What is on your mind? #Hashtag.. @Mention.. Link..',
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 17.0, color: Colors.grey),
                    ),
                  ),
                )),
                Container(
                  padding: const EdgeInsets.only(top: 40),
                  child: const Icon(Icons.emoji_emotions_outlined),
                )
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 15)),
          SingleChildScrollView(
            child: GestureDetector(
              onTap: () {
                if (!state) {
                  notActionShow = true;
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: show ? 360 : 0,
                child: ListView(
                  children: [
                    ListView(
                        shrinkWrap: true,
                        controller: _scrollController,
                        children: [
                          Column(
                            children: [
                              GridView.count(
                                crossAxisCount:
                                    SizeConfig(context).screenWidth >
                                            SizeConfig.smallScreenSize
                                        ? 2
                                        : 1,
                                childAspectRatio:
                                    SizeConfig(context).screenWidth >
                                            SizeConfig.smallScreenSize
                                        ? 240 / 45
                                        : 240 / 39,
                                padding: const EdgeInsets.all(4.0),
                                mainAxisSpacing: 4.0,
                                shrinkWrap: true,
                                crossAxisSpacing: 4.0,
                                children: mindPostCase
                                    .map(
                                      (mind) => MindSlice(
                                          onTap: () => {
                                                if (!state)
                                                  {notActionShow = true}
                                              },
                                          mindFunc: mind['mindFunc'],
                                          label: mind['title'],
                                          image: mind['image']),
                                    )
                                    .toList(),
                              ),
                              Row(
                                children: [
                                  const Flexible(
                                      fit: FlexFit.tight, child: SizedBox()),
                                  Expanded(
                                    child: SizedBox(
                                      width: 100,
                                      height: 38,
                                      child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 17, 205, 239),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            border: Border.all(
                                                color: const Color.fromARGB(
                                                    255, 17, 205, 239),
                                                width:
                                                    0.1), //bordrder raiuds of dropdown button
                                          ),
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 7, left: 15),
                                              child: DropdownButton(
                                                onTap: () {
                                                  if (!state) {
                                                    notActionShow = true;
                                                  }
                                                },
                                                hint: Row(
                                                  children: const [
                                                    Icon(
                                                      Icons.language,
                                                      color: Colors.white,
                                                    ),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5)),
                                                    Text(
                                                      'Public',
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                items: [
                                                  DropdownMenuItem(
                                                    value: "Public",
                                                    child: Row(children: const [
                                                      Icon(
                                                        Icons.language,
                                                        color: Colors.black,
                                                      ),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5)),
                                                      Text(
                                                        "Public",
                                                        style: TextStyle(
                                                            fontSize: 13),
                                                      )
                                                    ]),
                                                  ),
                                                  DropdownMenuItem(
                                                    value: "Friends",
                                                    child: Row(children: const [
                                                      Icon(
                                                        Icons.groups,
                                                        color: Colors.black,
                                                      ),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5)),
                                                      Text(
                                                        "Friends",
                                                        style: TextStyle(
                                                            fontSize: 13),
                                                      )
                                                    ]),
                                                  ),
                                                  DropdownMenuItem(
                                                    value: "Friends of Friends",
                                                    child: Row(children: const [
                                                      Icon(
                                                        Icons.groups,
                                                        color: Colors.black,
                                                      ),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5)),
                                                      Text(
                                                        "Friends of Friends",
                                                        style: TextStyle(
                                                            fontSize: 13),
                                                      )
                                                    ]),
                                                  ),
                                                  DropdownMenuItem(
                                                    value: "Only Me",
                                                    child: Row(children: const [
                                                      Icon(
                                                        Icons.lock_outline,
                                                        color: Colors.black,
                                                      ),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5)),
                                                      Text(
                                                        "Only Me",
                                                        style: TextStyle(
                                                            fontSize: 13),
                                                      )
                                                    ]),
                                                  ),
                                                ],
                                                onChanged: (String? value) {
                                                  //get value when changed
                                                  dropdownValue = value!;
                                                  setState(() {});
                                                },
                                                icon: const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 20),
                                                    child: Icon(
                                                        Icons.arrow_drop_down)),
                                                iconEnabledColor:
                                                    Colors.white, //Icon color
                                                style: const TextStyle(
                                                  color:
                                                      Colors.black, //Font color
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                dropdownColor: Colors.white,
                                                underline:
                                                    Container(), //remove underline
                                                isExpanded: true,
                                                isDense: true,
                                              ))),
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(left: 10)),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0)),
                                      minimumSize: const Size(85, 45),
                                      maximumSize: const Size(85, 45),
                                    ),
                                    onPressed: () {
                                      () => {if (!state) notActionShow = true};
                                    },
                                    child: const Text('Post',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w900)),
                                  )
                                ],
                              )
                            ],
                          )
                        ])
                  ],
                ),
              ),
            ),
          ),
        ]));
  }
}
