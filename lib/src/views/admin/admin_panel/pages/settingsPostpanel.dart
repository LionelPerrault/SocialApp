
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/controllers/AdminController.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_footer.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_header.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

// ignore: must_be_immutable

class AdminSettingsPosts extends StatefulWidget {
  AdminSettingsPosts({Key? key})
  : con = AdminController(),
        super(key: key);
  final AdminController con;
  @override
  State createState() => AdminSettingsPostsState();
}
class AdminSettingsPostsState extends mvc.StateMVC<AdminSettingsPosts> {

  String tab = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        AdminSettingHeader(icon: Icon(Icons.settings), pagename: 'Settings › Posts', button: const {'flag': false},),
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
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fstories.svg?alt=media&token=8df62c1f-3007-4f8e-b213-31de7b604902'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Stories', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Turn the stories On and Off Stories are photos and videos that only last 24 hours', style: TextStyle(
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
              child:   const Text('Story Duration', style: TextStyle(
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
                const Text('The story duration in seconds', style: TextStyle(
                  fontSize: 12,
                ),)
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
              child:   const Text('Who Can Add Stories', style: TextStyle(
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
        const Divider(
          thickness: 0.1,
          color: Colors.black,
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
              child:   const Text('Newsfeed Posts Source', style: TextStyle(
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
                const Text('Algorithm will exclude any post from closed/secret groups and events that users not member of incase of all posts also will disable all posts privacy', style: TextStyle(
                  fontSize: 12,
                ),)
              ]),)
                
            )
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
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fpopular.svg?alt=media&token=7ca882e3-df2c-4fe0-9799-9d82a5da53fd'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Popular Posts', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Turn the popular posts On and Off Popular posts are public posts ordered by most reactions, comments & shares', style: TextStyle(
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
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fdiscover_post.svg?alt=media&token=00f87033-188d-4b58-a5b5-a5ae3a2a01fb'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Discover Posts', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Turn the discover posts On and Off Discover posts are public posts ordered from most recent to old', style: TextStyle(
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
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fmemories.svg?alt=media&token=253f45d8-177f-4eba-9ca6-bb2c28cbb7ff'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Memories', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Turn the memories On and Off Memories are posts from the same day on last year', style: TextStyle(
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
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fwall_post.svg?alt=media&token=ed70c783-e4fe-4be0-af0d-094bb88edb0a'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Wall Posts', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Users can publish posts on their friends walls', style: TextStyle(
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
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fcolor_post.svg?alt=media&token=f7bd35bb-c568-4383-8d2a-d7f14ca273d8'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Colored Posts', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Turn the colored posts On and Off Make sure you have configured Colored Posts', style: TextStyle(
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
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Ffeeling_post.svg?alt=media&token=d54ff779-0538-449a-8017-1c9ed5a12d4c'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Feelings/Activity Posts', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Turn the feelings and activity posts On and Off', style: TextStyle(
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
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fvoice_note.svg?alt=media&token=75f22559-5ac1-40d8-961a-2aebdf6ab76a'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Voice Notes in Posts', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Turn the voice notes in posts On and Off', style: TextStyle(
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
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fvoice_note.svg?alt=media&token=75f22559-5ac1-40d8-961a-2aebdf6ab76a'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Voice Notes in Comments', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Turn the voice notes in comments On and Off', style: TextStyle(
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const Padding(padding: EdgeInsets.only(left: 20)),
            Container(
              width: 100,
              child:   const Text('Geolocation Google Key', style: TextStyle(
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
                const Text('Check the documentation to learn how to get this key', style: TextStyle(
                  fontSize: 12,
                ),)
              ]),)
                
            )
          ],),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          margin: EdgeInsets.only(left: 30),
          width: SizeConfig(context).screenWidth*0.5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const Padding(padding: EdgeInsets.only(left: 20)),
            Container(
              width: 100,
              child:   const Text('Voice Notes Encoding', style: TextStyle(
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
                  child: Column(children: [
                  Column(
                    children: [
                        Container(
                          width: 400,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(
                                  255, 250, 250, 250)),
                          padding: const EdgeInsets.only(left: 20),
                          child: DropdownButton(
                            value: 'none',
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
                ),
              ]),)
            )
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
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fpoll.svg?alt=media&token=e67169b2-93d4-4d46-be1a-2e2c052f32f7'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Polls', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Turn the poll posts On and Off', style: TextStyle(
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
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fgeolocation.svg?alt=media&token=c21265c8-935d-422c-bfa5-2652e6a5a1a4'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Geolocation', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Turn the post Geolocation On and Off', style: TextStyle(
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const Padding(padding: EdgeInsets.only(left: 20)),
            Container(
              width: 100,
              child:   const Text('Geolocation Google Key', style: TextStyle(
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
                const Text('Check the documentation to learn how to get this key', style: TextStyle(
                  fontSize: 12,
                ),)
              ]),)
                
            )
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
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fgif.svg?alt=media&token=0c46bac8-1534-4c6a-8226-0bb287c6cbd0'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('GIF', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Turn the gif posts On and Off', style: TextStyle(
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const Padding(padding: EdgeInsets.only(left: 20)),
            Container(
              width: 100,
              child:   const Text('Giphy API Key', style: TextStyle(
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
                const Text('Check the documentation to learn how to get this key', style: TextStyle(
                  fontSize: 12,
                ),)
              ]),)
                
            )
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
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Ftraslation.svg?alt=media&token=ef19a65d-e9ff-4d23-8f70-f4d4956baf15'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Post Translation', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Turn the post translation On and Off', style: TextStyle(
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const Padding(padding: EdgeInsets.only(left: 20)),
            Container(
              width: 100,
              child:   const Text('Yandex Key', style: TextStyle(
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
                const Text('Check the documentation to learn how to get this key', style: TextStyle(
                  fontSize: 12,
                ),)
              ]),)
                
            )
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
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fsmart_youtube.svg?alt=media&token=fd3c3f3f-2af7-4ece-9c53-e8c098142b01'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Smart YouTube Player', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Smart YouTube player will save a lot of bandwidth', style: TextStyle(
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
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fsocial_share.svg?alt=media&token=984618db-7bc8-4e2c-b822-3b72700b63e3'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Social Media Share', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Turn the social media share for posts On and Off', style: TextStyle(
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
          margin: EdgeInsets.only(left: 30),
          width: SizeConfig(context).screenWidth*0.5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const Padding(padding: EdgeInsets.only(left: 20)),
            Container(
              width: 100,
              child:   const Text('Max Post Characters', style: TextStyle(
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
                const Text('The Maximum allowed post characters length (0 for unlimited)', style: TextStyle(
                  fontSize: 12,
                ),)
              ]),)
                
            )
          ],),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          margin: EdgeInsets.only(left: 30),
          width: SizeConfig(context).screenWidth*0.5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const Padding(padding: EdgeInsets.only(left: 20)),
            Container(
              width: 100,
              child:   const Text('Max Comment Characters', style: TextStyle(
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
                const Text('The Maximum allowed comment characters length (0 for unlimited)', style: TextStyle(
                  fontSize: 12,
                ),)
              ]),)
                
            )
          ],),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          margin: EdgeInsets.only(left: 30),
          width: SizeConfig(context).screenWidth*0.5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const Padding(padding: EdgeInsets.only(left: 20)),
            Container(
              width: 100,
              child:   const Text('Max Posts/Hour', style: TextStyle(
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
                const Text('The Maximum number of posts that user can publish per hour (0 for unlimited)', style: TextStyle(
                  fontSize: 12,
                ),)
              ]),)
                
            )
          ],),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          margin: EdgeInsets.only(left: 30),
          width: SizeConfig(context).screenWidth*0.5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const Padding(padding: EdgeInsets.only(left: 20)),
            Container(
              width: 100,
              child:   const Text('Max Comments/Hour', style: TextStyle(
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
                const Text('The Maximum number of comments that user can publish per hour (0 for unlimited)', style: TextStyle(
                  fontSize: 12,
                ),)
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
              child:   const Text('Default Posts Privacy', style: TextStyle(
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
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fpost_anomous.svg?alt=media&token=571f551c-93c8-4bec-bc48-dce655c4d4e2'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Post As Anonymous', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: Column(children: [
                          const Text('Turn Anonymous mode On and Off', style: TextStyle(
                            fontSize: 11
                          ),),
                          const Text('Note: Admins and Moderators will able to see the real post author', style: TextStyle(
                            fontSize: 11
                          ),),
                        ],)
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
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fonline_status.svg?alt=media&token=cc7b80cc-e8d7-4ff9-a36e-9c6c439a4658'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Online Status on Posts', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Turn online indicator on Posts On and Off (User must be online and enabled the chat)', style: TextStyle(
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
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fdesktop_infinity.svg?alt=media&token=19335bba-5298-4d33-abd1-d0512defca3e'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Desktop Infinite Scroll', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Turn infinite scroll on desktop screens On and Off', style: TextStyle(
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
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fmobile_infiny.svg?alt=media&token=db3da096-52d5-4716-bb6f-cbb9c928fc74'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Mobile Infinite Scroll', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Turn infinite scroll on mobile screens On and Off', style: TextStyle(
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
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fauto_play.svg?alt=media&token=cca4a40c-f3a0-4adf-965c-20a2c1f291d6'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Auto Play Videos', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Turn auto play videos On and Off', style: TextStyle(
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
                      child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Ftrending.svg?alt=media&token=d4f2c06d-f8d3-4c3b-8c1e-5f87cf1672a5'),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const Text('Trending Hashtags', style: TextStyle(
                        color: Color.fromARGB(255, 82, 95, 127),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        width: SizeConfig(context).screenWidth * 0.35,
                        child: const Text('Turn the trending hashtags feature On and Off', style: TextStyle(
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const Padding(padding: EdgeInsets.only(left: 20)),
            Container(
              width: 100,
              child:   const Text('Trending Interval', style: TextStyle(
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
                    child: Column(children: [
                    Column(
                      children: [
                          Container(
                            width: 400,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(
                                    255, 250, 250, 250)),
                            padding: const EdgeInsets.only(left: 20),
                            child: DropdownButton(
                              value: 'none',
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
                          )
                        ],
                      ),
                    ]),
                  ),
                  const Text('Select the interval of trending hashtags', style: TextStyle(
                    fontSize: 12
                  ),)
              ]),)
            )
          ],),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          margin: EdgeInsets.only(left: 30),
          width: SizeConfig(context).screenWidth*0.5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const Padding(padding: EdgeInsets.only(left: 20)),
            Container(
              width: 100,
              child:   const Text('Hashtags Limit', style: TextStyle(
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
                const Text('How many hashtags you want to display', style: TextStyle(
                  fontSize: 12,
                ),)
              ]),)
                
            )
          ],),
        ),
        
        AdminSettingFooter()
      ]),
    );
  }
}
