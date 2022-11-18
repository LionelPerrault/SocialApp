
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_footer.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_header.dart';

// ignore: must_be_immutable
class AdminBodyPanel extends StatelessWidget {
  const AdminBodyPanel(
      {super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        AdminSettingHeader(icon: Icon(Icons.settings), pagename: 'Settings › Chat', button: const {'flag': false},),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          margin: EdgeInsets.only(left: 50),
          width: SizeConfig(context).screenWidth * 0.6,
          child: Column(children: [
            Row(children: [
              Expanded(
                child: Container(
                  child: Row(children: [
                    Container(
                      width: 35,
                      height: 35,
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fchat.svg?alt=media&token=efe43532-6cf3-4382-9691-c72ffdf40a70'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Chat Enabled', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Turn the chat system On and Off', style: TextStyle(
                          fontSize: 11
                        ),),
                      )
                    ],),
                    const Flexible(fit: FlexFit.tight, child: SizedBox()),
                    SizedBox(
                      height: 20,
                      child: Transform.scale(
                        scaleX: 0.55,
                        scaleY: 0.55,
                        child: CupertinoSwitch(
                          //thumbColor: kprimaryColor,
                          // activeColor: kprimaryColor,
                          value: true,
                          onChanged: (value) {
                          },
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 15))
                  ],),
                )
              )
            ],)
          ],),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          margin: EdgeInsets.only(left: 50),
          width: SizeConfig(context).screenWidth * 0.6,
          child: Column(children: [
            Row(children: [
              Expanded(
                child: Container(
                  child: Row(children: [
                    Container(
                      width: 35,
                      height: 35,
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fvoice_note.svg?alt=media&token=905f72cc-f9ab-4aa1-a44a-33b892b710c7'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Voice Notes', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Turn the voice notes in chat On and Off', style: TextStyle(
                          fontSize: 11
                        ),),
                      )
                    ],),
                    const Flexible(fit: FlexFit.tight, child: SizedBox()),
                    SizedBox(
                      height: 20,
                      child: Transform.scale(
                        scaleX: 0.55,
                        scaleY: 0.55,
                        child: CupertinoSwitch(
                          //thumbColor: kprimaryColor,
                          // activeColor: kprimaryColor,
                          value: true,
                          onChanged: (value) {
                          },
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 15))
                  ],),
                )
              )
            ],)
          ],),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          margin: EdgeInsets.only(left: 50),
          width: SizeConfig(context).screenWidth * 0.6,
          child: Column(children: [
            Row(children: [
              Expanded(
                child: Container(
                  child: Row(children: [
                    Container(
                      width: 35,
                      height: 35,
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fuser_status.svg?alt=media&token=558abb2f-da0c-4222-b6b0-ffb3c0a5ff6e'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('User Status Enabled', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Turn the Last Seen On and Off', style: TextStyle(
                          fontSize: 11
                        ),),
                      )
                    ],),
                    const Flexible(fit: FlexFit.tight, child: SizedBox()),
                    SizedBox(
                      height: 20,
                      child: Transform.scale(
                        scaleX: 0.55,
                        scaleY: 0.55,
                        child: CupertinoSwitch(
                          //thumbColor: kprimaryColor,
                          // activeColor: kprimaryColor,
                          value: true,
                          onChanged: (value) {
                          },
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 15))
                  ],),
                )
              )
            ],)
          ],),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          margin: EdgeInsets.only(left: 50),
          width: SizeConfig(context).screenWidth * 0.6,
          child: Column(children: [
            Row(children: [
              Expanded(
                child: Container(
                  child: Row(children: [
                    Container(
                      width: 35,
                      height: 35,
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Ftyping_status.svg?alt=media&token=b729925b-1cdf-4766-924f-65cb3c25457a'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Typing Status Enabled', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Turn the Typing Status On and Off (Needs a good server to work fine)', style: TextStyle(
                          fontSize: 11
                        ),),
                      )
                    ],),
                    const Flexible(fit: FlexFit.tight, child: SizedBox()),
                    SizedBox(
                      height: 20,
                      child: Transform.scale(
                        scaleX: 0.55,
                        scaleY: 0.55,
                        child: CupertinoSwitch(
                          //thumbColor: kprimaryColor,
                          // activeColor: kprimaryColor,
                          value: true,
                          onChanged: (value) {
                          },
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 15))
                  ],),
                )
              )
            ],)
          ],),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          margin: EdgeInsets.only(left: 50),
          width: SizeConfig(context).screenWidth * 0.6,
          child: Column(children: [
            Row(children: [
              Expanded(
                child: Container(
                  child: Row(children: [
                    Container(
                      width: 35,
                      height: 35,
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fseen_status.svg?alt=media&token=e2ba70ad-5d94-40e6-b0f9-5740b900480e'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Seen Status Enabled', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Turn the Seen Status On and Off (Needs a good server to work fine)', style: TextStyle(
                          fontSize: 11
                        ),),
                      )
                    ],),
                    const Flexible(fit: FlexFit.tight, child: SizedBox()),
                    SizedBox(
                      height: 20,
                      child: Transform.scale(
                        scaleX: 0.55,
                        scaleY: 0.55,
                        child: CupertinoSwitch(
                          //thumbColor: kprimaryColor,
                          // activeColor: kprimaryColor,
                          value: true,
                          onChanged: (value) {
                          },
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 15))
                  ],),
                )
              )
            ],)
          ],),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          margin: EdgeInsets.only(left: 50),
          width: SizeConfig(context).screenWidth * 0.6,
          child: Column(children: [
            Row(children: [
              Expanded(
                child: Container(
                  child: Row(children: [
                    Container(
                      width: 35,
                      height: 35,
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fdelete_for.svg?alt=media&token=ea100abb-d511-4eda-88fa-2170b59c9a22'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Delete For Everyone', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Permanently remove the conversation for all chat members when user delete it', style: TextStyle(
                          fontSize: 11
                        ),),
                      )
                    ],),
                    const Flexible(fit: FlexFit.tight, child: SizedBox()),
                    SizedBox(
                      height: 20,
                      child: Transform.scale(
                        scaleX: 0.55,
                        scaleY: 0.55,
                        child: CupertinoSwitch(
                          //thumbColor: kprimaryColor,
                          // activeColor: kprimaryColor,
                          value: true,
                          onChanged: (value) {
                          },
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 15))
                  ],),
                )
              )
            ],)
          ],),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          margin: EdgeInsets.only(left: 50),
          width: SizeConfig(context).screenWidth * 0.6,
          child: Column(children: [
            Row(children: [
              Expanded(
                child: Container(
                  child: Row(children: [
                    Container(
                      width: 35,
                      height: 35,
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Faudio_call.svg?alt=media&token=3a2ca3be-a739-437b-9184-3b4885f032c7'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Audio Call Enabled', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Turn the audio call system On and Off', style: TextStyle(
                          fontSize: 11
                        ),),
                      )
                    ],),
                    const Flexible(fit: FlexFit.tight, child: SizedBox()),
                    SizedBox(
                      height: 20,
                      child: Transform.scale(
                        scaleX: 0.55,
                        scaleY: 0.55,
                        child: CupertinoSwitch(
                          //thumbColor: kprimaryColor,
                          // activeColor: kprimaryColor,
                          value: true,
                          onChanged: (value) {
                          },
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 15))
                  ],),
                )
              )
            ],)
          ],),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          margin: EdgeInsets.only(left: 30),
          width: SizeConfig(context).screenWidth*0.5,
          child: Row(
            children: [
            const Padding(padding: EdgeInsets.only(left: 20)),
            Container(
              width: 100,
              child:   const Text('Who Can Start Audio Call', style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 85, 95, 127)
              ),),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: 500,
                child: Column(children: [
                Container(
                  width: 400,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(
                          255, 250, 250, 250),
                      border:
                          Border.all(color: Colors.grey)),
                  child: Row(children: [
                    Expanded(
                      child: SizedBox(
                        width: 400,
                        height: 45,
                        child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.only(top: 7, left: 15),
                                child: DropdownButton(
                                  value: 'public',
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
                ),
              ]),)
                
            )
          ],),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          margin: EdgeInsets.only(left: 50),
          width: SizeConfig(context).screenWidth * 0.6,
          child: Column(children: [
            Row(children: [
              Expanded(
                child: Container(
                  child: Row(children: [
                    Container(
                      width: 35,
                      height: 35,
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fvideo_call.svg?alt=media&token=181da183-967a-48b3-8cba-b554303cc770'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Video Call Enabled', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Turn the video call system On and Off', style: TextStyle(
                          fontSize: 11
                        ),),
                      )
                    ],),
                    const Flexible(fit: FlexFit.tight, child: SizedBox()),
                    SizedBox(
                      height: 20,
                      child: Transform.scale(
                        scaleX: 0.55,
                        scaleY: 0.55,
                        child: CupertinoSwitch(
                          //thumbColor: kprimaryColor,
                          // activeColor: kprimaryColor,
                          value: true,
                          onChanged: (value) {
                          },
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 15))
                  ],),
                )
              )
            ],)
          ],),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          margin: EdgeInsets.only(left: 30),
          width: SizeConfig(context).screenWidth*0.5,
          child: Row(
            children: [
            const Padding(padding: EdgeInsets.only(left: 20)),
            Container(
              width: 100,
              child:   const Text('Who Can Start Video Call', style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 85, 95, 127)
              ),),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: 500,
                child: Column(children: [
                Container(
                  width: 400,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(
                          255, 250, 250, 250),
                      border:
                          Border.all(color: Colors.grey)),
                  child: Row(children: [
                    Expanded(
                      child: SizedBox(
                        width: 400,
                        height: 45,
                        child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.only(top: 7, left: 15),
                                child: DropdownButton(
                                  value: 'public',
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
                ),
              ]),)
                
            )
          ],),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          margin: EdgeInsets.only(left: 30),
          width: SizeConfig(context).screenWidth*0.5,
          child: Row(
            children: [
            const Padding(padding: EdgeInsets.only(left: 20)),
            Container(
              width: 100,
              child:   const Text('Twilio Account SID', style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 85, 95, 127)
              ),),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: 500,
                child: Column(children: [
                Container(
                  width: 400,
                  height: 30,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(
                          255, 250, 250, 250),
                      border:
                          Border.all(color: Colors.grey)),
                  child: TextFormField(
                        minLines: 1,
                        maxLines: 7,
                        onChanged: (value) async {
                        },
                        keyboardType: TextInputType.multiline,
                        style: const TextStyle(fontSize: 12),
                        decoration: const InputDecoration(
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
              ]),)
                
            )
          ],),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          margin: EdgeInsets.only(left: 30),
          width: SizeConfig(context).screenWidth*0.5,
          child: Row(
            children: [
            const Padding(padding: EdgeInsets.only(left: 20)),
            Container(
              width: 100,
              child:   const Text('Twilio API SID', style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 85, 95, 127)
              ),),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: 500,
                child: Column(children: [
                Container(
                  width: 400,
                  height: 30,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(
                          255, 250, 250, 250),
                      border:
                          Border.all(color: Colors.grey)),
                  child: TextFormField(
                        minLines: 1,
                        maxLines: 7,
                        onChanged: (value) async {
                        },
                        keyboardType: TextInputType.multiline,
                        style: const TextStyle(fontSize: 12),
                        decoration: const InputDecoration(
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
              ]),)
                
            )
          ],),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          margin: EdgeInsets.only(left: 30),
          width: SizeConfig(context).screenWidth*0.5,
          child: Row(
            children: [
            const Padding(padding: EdgeInsets.only(left: 20)),
            Container(
              width: 100,
              child:   const Text('Twilio API SECRET', style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 85, 95, 127)
              ),),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: 500,
                child: Column(children: [
                Container(
                  width: 400,
                  height: 30,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(
                          255, 250, 250, 250),
                      border:
                          Border.all(color: Colors.grey)),
                  child: TextFormField(
                        minLines: 1,
                        maxLines: 7,
                        onChanged: (value) async {
                        },
                        keyboardType: TextInputType.multiline,
                        style: const TextStyle(fontSize: 12),
                        decoration: const InputDecoration(
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
              ]),)
                
            )
          ],),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        AdminSettingFooter()
      ]),
    );
  }
}
