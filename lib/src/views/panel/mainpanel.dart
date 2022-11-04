
import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/utils/svg.dart';
import 'package:shnatter/src/widget/mindslice.dart';

// ignore: must_be_immutable
class MainPanel extends StatelessWidget {
  MainPanel(
      {super.key});
  bool showMind = false;
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(top: 20, left:0),
      child: 
        Column(children: [
          Container(
            width: SizeConfig(context).screenWidth * 0.4,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 250, 250, 250),
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
                  child: 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          child: const CircleAvatar(
                            backgroundColor: Colors.green,
                            backgroundImage: NetworkImage(
                                "https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fblank_package.png?alt=media&token=f5cf4503-e36b-416a-8cce-079dfcaeae83"),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 10, bottom: 10, right: 9),
                          width: SizeConfig(context).screenWidth * 0.35,
                          child: const TextField(
                            controller: null,
                            // cursorColor: Colors.white,
                            focusNode: null,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hoverColor: Color.fromARGB(255, 250, 250, 250),
                              filled: true,
                              fillColor: Color.fromARGB(255, 250, 250, 250),
                              hintText: 'What is on your mind? #Hashtag.. @Mention.. Link..',
                              border: InputBorder.none,
                              hintStyle: TextStyle(fontSize: 17.0, color: Colors.grey),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 40),
                          child: const Icon(Icons.emoji_emotions_outlined),
                        )
                      ],
                    ),
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                Row(children: [
                  const Padding(padding: EdgeInsets.only(left: 18)),
                  Column(
                    children: [
                      MindSlice(onTap: ()=>{}, label: 'Upload Photos', image: 'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Fcamera.svg?alt=media&token=0b7478a3-c746-47ed-a4fc-7505accf22a5'),
                      const Padding(padding: EdgeInsets.only(top: 15)),
                      MindSlice(onTap: ()=>{}, label: 'Feelings/Activity', image: 'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Fcolor.svg?alt=media&token=7d8b7631-2471-4acf-8f34-e0071e7a4600'),
                      const Padding(padding: EdgeInsets.only(top: 15)),
                      MindSlice(onTap: ()=>{}, label: 'Colored Posts', image: 'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Fcolor.svg?alt=media&token=7d8b7631-2471-4acf-8f34-e0071e7a4600'),
                      const Padding(padding: EdgeInsets.only(top: 15)),
                      MindSlice(onTap: ()=>{}, label: 'Write Aticle', image: 'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Farticle.svg?alt=media&token=585f68e4-bc57-4b5f-a55e-0e2f4e686809'),
                      const Padding(padding: EdgeInsets.only(top: 15)),
                      MindSlice(onTap: ()=>{}, label: 'Create Poll', image: 'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Fpoll.svg?alt=media&token=9a0f6f31-3685-42ce-9a2b-f18a512d3829'),
                      const Padding(padding: EdgeInsets.only(top: 15)),
                      MindSlice(onTap: ()=>{}, label: 'Upload Audio', image: 'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Fmusic_file.svg?alt=media&token=b2d62e94-0c58-487e-b3dc-da02bdfd7ac9'),
                      const Padding(padding: EdgeInsets.only(top: 15)),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(left: 40)),
                  Column(
                    children: [
                      MindSlice(onTap: ()=>{}, label: 'Create Album', image: 'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Falbum.svg?alt=media&token=a24aeb90-c93c-4a92-b116-7d85f2a3acbc'),
                      const Padding(padding: EdgeInsets.only(top: 15)),
                      MindSlice(onTap: ()=>{}, label: 'Check In', image: 'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Fcheckin.svg?alt=media&token=6f228dbc-b1a4-4d13-860b-18b686602738'),
                      const Padding(padding: EdgeInsets.only(top: 15)),
                      MindSlice(onTap: ()=>{}, label: 'Voice Notes', image: 'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Fvoice.svg?alt=media&token=b49c28b5-3b27-487e-a6c1-ffd978c215fa'),
                      const Padding(padding: EdgeInsets.only(top: 15)),
                      MindSlice(onTap: ()=>{}, label: 'Sell Something', image: 'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Fsellsomething.svg?alt=media&token=d4de8d00-e075-4e6f-8f65-111616413dda'),
                      const Padding(padding: EdgeInsets.only(top: 15)),
                      MindSlice(onTap: ()=>{}, label: 'Upload Video', image: 'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Fvideo_camera.svg?alt=media&token=89343741-3bfc-4001-87d4-9344e752192d'),
                      const Padding(padding: EdgeInsets.only(top: 15)),
                      MindSlice(onTap: ()=>{}, label: 'Upload File', image: 'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmind_svg%2Ffolder.svg?alt=media&token=8a62d7d4-95dc-4f0b-8a62-3c9ef26aec81'),
                      const Padding(padding: EdgeInsets.only(top: 15)),
                    ],
                  ),
                ],)
              ]
            ),
          )
          
      ],)
      );
  }
}
