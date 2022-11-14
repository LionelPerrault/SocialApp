
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/views/box/searchbox.dart';
import 'package:shnatter/src/views/navigationbar.dart';
import 'package:shnatter/src/views/panel/leftpanel.dart';
import 'package:shnatter/src/views/panel/mainpanel.dart';
import 'package:shnatter/src/views/panel/rightpanel.dart';
import 'package:shnatter/src/widget/startedInput.dart';
import 'package:path/path.dart' as PPath;

import '../controllers/UserController.dart';
import '../utils/size_config.dart';
import '../widget/mprimary_button.dart';
import '../widget/list_text.dart';
import 'dart:io' show File, Platform;
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/gestures.dart';
import 'box/notification.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class StartedScreen extends StatefulWidget {
  StartedScreen({Key? key})
      : userCon = UserController(),
        super(key: key);
  final UserController userCon;
  @override
  State createState() => StartedScreenState();
}

class StartedScreenState extends mvc.StateMVC<StartedScreen>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  late UserController userCon;
  bool showSearch = false;
  late FocusNode searchFocusNode;
  bool showMenu = false;
  bool stepflag = true;
  var imageUrl = '';
  var progress;
  var selectFlag = {};
  Map<String, dynamic> saveData = {};
  var country = 'none';
  var relation = "none";
  var birthM = "none";
  var birthD = "none";
  var birthY = "none";
  var interests = "none";
  var isShowProgressive = false;
  var fullName = '';
  late AnimationController _drawerSlideController;
  var suggest = <String, bool>{
    'friends': true,
    'pages': true,
    'groups': true,
    'events': true
  };
  //
  @override
  void initState() {
    fullName = UserManager.userInfo['firstName'] + ' ' + UserManager.userInfo['lastName'];
    progress = 0;
    selectFlag['jew'] = false;
    selectFlag['policy1'] = false;
    selectFlag['policy2'] = false;
    selectFlag['policy3'] = false;
    selectFlag['avatar'] = '';
    add(widget.userCon);
    super.initState();
    userCon = controller as UserController;
    searchFocusNode = FocusNode();
    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    userCon.userAvatar = UserManager.userInfo['avatar'] == null ? '' : UserManager.userInfo['avatar'];
    print(UserManager.userInfo);
    print('avatar');
    userCon.setState(() {});
  }

  void onSearchBarFocus() {
    searchFocusNode.requestFocus();
    setState(() {
      showSearch = true;
    });
  }

  void clickMenu() {
    //setState(() {
    //  showMenu = !showMenu;
    //});
    //Scaffold.of(context).openDrawer();
    //print("showmenu is {$showMenu}");
    if (_isDrawerOpen() || _isDrawerOpening()) {
      _drawerSlideController.reverse();
    } else {
      _drawerSlideController.forward();
    }
  }

  void onSearchBarDismiss() {
    if (showSearch)
      setState(() {
        showSearch = false;
      });
  }

  bool _isDrawerOpen() {
    return _drawerSlideController.value == 1.0;
  }

  bool _isDrawerOpening() {
    return _drawerSlideController.status == AnimationStatus.forward;
  }

  bool _isDrawerClosed() {
    return _drawerSlideController.value == 0.0;
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    _drawerSlideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawerEnableOpenDragGesture: false,
        drawer: Drawer(),
        body: Stack(
          fit: StackFit.expand,
          children: [
            ShnatterNavigation(
              searchController: searchController,
              onSearchBarFocus: onSearchBarFocus,
              onSearchBarDismiss: onSearchBarDismiss,
              drawClicked: clickMenu,
            ),
            Padding(padding: EdgeInsets.only(top: 80),
              child: 
                SingleChildScrollView(
                child: Column(children: [
                        const Padding(padding: EdgeInsets.only(top:50)),
                        Column(children: const [
                          Text('Getting Started', style:TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )),
                          Padding(padding: EdgeInsets.only(top: 15)),
                          Text('This information will let us know more about you', style:TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ))
                        ],),
                        const Padding(padding: EdgeInsets.only(top: 50)),
                        Container(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          width: 760,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black38,
                                blurRadius: 4,
                                offset: Offset(0, 0), // Shadow position
                              ),
                            ],
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Column(
                            children: [
                              const Padding(padding: EdgeInsets.only(top: 20)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: stepflag
                                                    ? const Color.fromARGB(255, 0, 123, 255)
                                                    : const Color.fromARGB(255, 243, 243, 243),
                                                elevation: 3,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(4.0)),
                                                minimumSize: const Size(350, 75),
                                                maximumSize: const Size(350, 75),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  stepflag = true;
                                                });
                                              },
                                              child: Column(
                                                children: [
                                                  const Padding(
                                                      padding: EdgeInsets.only(top: 17)),
                                                  Text('Step 1',
                                                      style: TextStyle(
                                                          color: stepflag
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 22,
                                                          fontWeight: FontWeight.w600)),
                                                  const Padding(padding: EdgeInsets.only(top: 6)),
                                                  Text(
                                                    'Upload your photo',
                                                    style: TextStyle(
                                                        color: stepflag
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontSize: 13),
                                                  )
                                                ],
                                              )),
                                  ),
                                  const Padding(padding: EdgeInsets.only(left: 12)),
                                  Expanded(
                                    flex: 1,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: stepflag
                                            ? const Color.fromARGB(255, 243, 243, 243)
                                            : const Color.fromARGB(255, 0, 123, 255),
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4.0)),
                                        minimumSize: const Size(350, 75),
                                        maximumSize: const Size(350, 75),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          stepflag = false;
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          const Padding(
                                              padding: EdgeInsets.only(top: 17)),
                                          Text('Step 2',
                                              style: TextStyle(
                                                  color: stepflag
                                                      ? Colors.black
                                                      : Colors.white,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w600)),
                                          const Padding(padding: EdgeInsets.only(top: 6)),
                                          Text('Update your info',
                                              style: TextStyle(
                                                  color: stepflag
                                                      ? Colors.black
                                                      : Colors.white,
                                                  fontSize: 13)),
                                        ],
                                      )),
                                  )
                                ],
                              ),
                              const Padding(padding: EdgeInsets.only(top: 30)),
                              stepflag
                                  ? Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Welcome',
                                              style: TextStyle(
                                                  color: Colors.black, fontSize: 22),
                                            ),
                                            Padding(padding: EdgeInsets.only(left: 10)),
                                            Text(
                                              fullName,
                                              style: TextStyle(
                                                  color: Color.fromARGB(255, 0, 123, 255),
                                                  fontSize: 22),
                                            ),
                                          ],
                                        ),
                                        const Padding(padding: EdgeInsets.only(top: 15)),
                                        const Text('Let\'s start with your photo'),
                                        const Padding(padding: EdgeInsets.only(top: 20)),
                                        Stack(
                                          children: [
                                            userCon.userAvatar != '' ? 
                                            Container(
                                              width: 120,
                                              height: 120,
                                              padding: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                  color:
                                                      Color.fromARGB(255, 250, 250, 250),
                                                  borderRadius: BorderRadius.circular(60),
                                                  border: Border.all(color: Colors.grey)),
                                              child: CircleAvatar(
                                                  radius: 60,
                                                  backgroundImage: NetworkImage(userCon.userAvatar),
                                                ) 
                                            )
                                            : Container(
                                              width: 120,
                                              height: 120,
                                              padding: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                  color:
                                                      Color.fromARGB(255, 250, 250, 250),
                                                  borderRadius: BorderRadius.circular(60),
                                                  border: Border.all(color: Colors.grey)),
                                              child: SvgPicture.network(
                                                  'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fprofile%2Fblank_profile_male.svg?alt=media&token=eaf0c1c7-5a30-4771-a7b8-9dc312eafe82'),
                                            ),
                                            // (progress !=0&&progress !=100) ? LinearProgressIndicator(
                                            //   value: progress,
                                            //   semanticsLabel: 'Linear progress indicator',
                                            // ), : SizedBox(),
                                            (progress !=0&&progress !=100) ? Container(
                                              margin: EdgeInsets.only(top: 70, left: 10),
                                              width: 100,
                                              child: LinearProgressIndicator(
                                              value: 10,
                                              semanticsLabel: 'Linear progress indicator',
                                            ),) : SizedBox(),
                                            Container(
                                              width: 26,
                                              height: 26,
                                              margin: const EdgeInsets.only(
                                                  top: 90, left: 90),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(13),
                                                color: Colors.grey[400],
                                              ),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  padding: EdgeInsets.all(4),
                                                  backgroundColor: Colors.grey[300],
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(13)),
                                                  minimumSize: const Size(26, 26),
                                                  maximumSize: const Size(26, 26),
                                                ),
                                                onPressed: () {
                                                 uploadImage();
                                                  ()=>{};
                                                },
                                                child: const Icon(
                                                    Icons.camera_enhance_rounded,
                                                    color: Colors.black,
                                                    size: 16.0),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Padding(padding: EdgeInsets.only(top: 20)),
                                        Row(
                                          children: [
                                            const Flexible(
                                                fit: FlexFit.tight, child: SizedBox()),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  elevation: 3,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(4.0)),
                                                  minimumSize: const Size(110, 40),
                                                  maximumSize: const Size(110, 40),
                                                ),
                                                onPressed: () {
                                                    setState(() {
                                                      stepflag = false;
                                                    });
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: const [
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(top: 17)),
                                                    Text('Next Step',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 9,
                                                            fontWeight: FontWeight.w600)),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(left: 10)),
                                                    Icon(
                                                      Icons.arrow_circle_right,
                                                      color: Colors.black,
                                                      size: 14.0,
                                                    )
                                                  ],
                                                )),
                                            const Padding(
                                                padding: EdgeInsets.only(right: 50))
                                          ],
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.only(bottom: 20))
                                      ],
                                    )
                                  : SizedBox(
                                      width: double.infinity * 0.6,
                                      child: Column(
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: const [
                                              Text(
                                                'Update your info',
                                                style: TextStyle(
                                                    color: Colors.black, fontSize: 22),
                                              ),
                                              Padding(padding: EdgeInsets.only(left: 10)),
                                              Text(
                                                'Share your information with our community',
                                                style: TextStyle(
                                                    color: Colors.black, fontSize: 13),
                                              ),
                                            ],
                                          ),
                                          const Padding(
                                              padding: EdgeInsets.only(top: 30)),
                                          Row(
                                            children: const [
                                              Text('LOCATION',
                                                  style: TextStyle(
                                                      color: Colors.black, fontSize: 11)),
                                              Flexible(
                                                  fit: FlexFit.tight, child: SizedBox()),
                                            ],
                                          ),
                                          //country
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                  Text('Country',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 82, 95, 127),
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.bold)),
                                                  Container(
                                                    width: 750,
                                                    decoration: BoxDecoration(
                                                        color: Color.fromARGB(
                                                            255, 250, 250, 250),
                                                        border:
                                                            Border.all(color: Colors.grey)),
                                                    padding: const EdgeInsets.only(left: 20),
                                                    child: DropdownButton(
                                                      value: country,
                                                      items: const [
                                                        //add items in the dropdown
                                                        DropdownMenuItem(
                                                          value: "none",
                                                          child: Text("Select Country"),
                                                        ),
                                                        DropdownMenuItem(
                                                            value: "us",
                                                            child: Text("United Status")),
                                                        DropdownMenuItem(
                                                          value: "sw",
                                                          child: Text("Switzerland"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "ca",
                                                          child: Text("Canada"),
                                                        ),
                                                      ],
                                                      onChanged: (String? value) {
                                                        //get value when changed
                                                        saveData['country'] = value;
                                                        country = value!;
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
                                                ],)
                                              ),
                                            ],
                                          ),
                                          const Padding(padding: EdgeInsets.only(top: 20)),
                                          //current city
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                  Text('Current City',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 82, 95, 127),
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.bold)),
                                                  Container(
                                                    width: 360,
                                                    child:
                                                        input(validator: (value) async {
                                                      print(value);
                                                    }, onchange: (value) async {
                                                      saveData['current'] = value;
                                                      setState(() {});
                                                    }),
                                                  )
                                                ],)
                                              ),
                                              const Padding(padding: EdgeInsets.only(left: 30)),
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                  Text('Hometown',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 82, 95, 127),
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.bold)),
                                                  Container(
                                                    width: 360,
                                                    child:
                                                        input(validator: (value) async {
                                                      print(value);
                                                    }, onchange: (value) async {
                                                      saveData['hometown'] = value;
                                                      setState(() {});
                                                    }),
                                                  )
                                                ],)
                                              ),
                                            ],
                                          ),
                                          const Padding(padding: EdgeInsets.only(top: 20)),
                                          //relation
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                  Text('Relationship Status',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 82, 95, 127),
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.bold)),
                                                  Container(
                                                    width: 360,
                                                    decoration: BoxDecoration(
                                                        color: Color.fromARGB(
                                                            255, 250, 250, 250),
                                                        border:
                                                            Border.all(color: Colors.grey)),
                                                    padding: const EdgeInsets.only(left: 20),
                                                    child: DropdownButton(
                                                      value: relation,
                                                      items: const [
                                                        //add items in the dropdown
                                                        DropdownMenuItem(
                                                          value: "none",
                                                          child: Text("Select Relationship"),
                                                        ),
                                                        DropdownMenuItem(
                                                            value: "single",
                                                            child: Text("Single")),
                                                        DropdownMenuItem(
                                                          value: "inarelationship",
                                                          child: Text("In a relationship"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "complicated",
                                                          child: Text("It\'s a complicated"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "separated",
                                                          child: Text("Separated"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "divorced",
                                                          child: Text("Divorced"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "widowed",
                                                          child: Text("Widowed"),
                                                        ),
                                                      ],
                                                      onChanged: (String? value) {
                                                        //get value when changed
                                                        saveData['sex'] = value;
                                                        relation = value!;
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
                                                ],)
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: const [
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(left: 30)),
                                                      Text('I am jewish',
                                                          style: TextStyle(
                                                              color: Color.fromARGB(
                                                                  255, 82, 95, 127),
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight.bold)),
                                                      const Padding(
                                                        padding: EdgeInsets.only(top: 10),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Padding(
                                                          padding:
                                                              EdgeInsets.only(left: 20)),
                                                      SizedBox(
                                                        height: 20,
                                                        child: Transform.scale(
                                                          scaleX: 0.55,
                                                          scaleY: 0.55,
                                                          child: CupertinoSwitch(
                                                            activeColor: Colors.grey,
                                                            value: selectFlag['jew'],
                                                            onChanged: (value) {
                                                              setState(() {
                                                                selectFlag['jew'] = value;
                                                                saveData['jew'] = value;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              )
                                              ),
                                            ],
                                          ),
                                          const Padding(padding: EdgeInsets.only(top: 20)),
                                          //birthday
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                  Text('Birthday',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 82, 95, 127),
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.bold)),
                                                  Container(
                                                    width: 230,
                                                    decoration: BoxDecoration(
                                                        color: Color.fromARGB(
                                                            255, 250, 250, 250),
                                                        border:
                                                            Border.all(color: Colors.grey)),
                                                    padding: const EdgeInsets.only(left: 20),
                                                    child: DropdownButton(
                                                      value: birthM,
                                                      items: const [
                                                        //add items in the dropdown
                                                        DropdownMenuItem(
                                                          value: "none",
                                                          child: Text("Select Month"),
                                                        ),
                                                        DropdownMenuItem(
                                                            value: "1",
                                                            child: Text("Jan")),
                                                        DropdownMenuItem(
                                                          value: "2",
                                                          child: Text("Feb"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "3",
                                                          child: Text("Mar"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "4",
                                                          child: Text("Apr"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "5",
                                                          child: Text("May"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "6",
                                                          child: Text("Jun"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "7",
                                                          child: Text("Jul"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "8",
                                                          child: Text("Aug"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "9",
                                                          child: Text("Sep"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "10",
                                                          child: Text("Oct"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "11",
                                                          child: Text("Nov"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "12",
                                                          child: Text("Dec"),
                                                        ),
                                                      ],
                                                      onChanged: (String? value) {
                                                        //get value when changed
                                                        saveData['birthM'] = value;
                                                        birthM = value!;
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
                                                ],)
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                  Text('',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 82, 95, 127),
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.bold)),
                                                  Container(
                                                    width: 230,
                                                    decoration: BoxDecoration(
                                                        color: Color.fromARGB(
                                                            255, 250, 250, 250),
                                                        border:
                                                            Border.all(color: Colors.grey)),
                                                    padding: const EdgeInsets.only(left: 20),
                                                    child: DropdownButton(
                                                      value: birthD,
                                                      items: const [
                                                        //add items in the dropdown
                                                        DropdownMenuItem(
                                                          value: "none",
                                                          child: Text("Select Day"),
                                                        ),
                                                        DropdownMenuItem(
                                                            value: "1",
                                                            child: Text("1")),
                                                        DropdownMenuItem(
                                                          value: "2",
                                                          child: Text("2"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "3",
                                                          child: Text("3"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "4",
                                                          child: Text("4"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "5",
                                                          child: Text("5"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "6",
                                                          child: Text("6"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "7",
                                                          child: Text("7"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "8",
                                                          child: Text("8"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "9",
                                                          child: Text("9"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "10",
                                                          child: Text("10"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "11",
                                                          child: Text("11"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "12",
                                                          child: Text("12"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "13",
                                                          child: Text("13"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "14",
                                                          child: Text("14"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "15",
                                                          child: Text("15"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "16",
                                                          child: Text("16"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "17",
                                                          child: Text("17"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "18",
                                                          child: Text("18"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "19",
                                                          child: Text("19"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "20",
                                                          child: Text("20"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "21",
                                                          child: Text("21"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "22",
                                                          child: Text("22"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "23",
                                                          child: Text("23"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "24",
                                                          child: Text("24"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "25",
                                                          child: Text("25"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "26",
                                                          child: Text("26"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "27",
                                                          child: Text("27"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "28",
                                                          child: Text("28"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "29",
                                                          child: Text("29"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "30",
                                                          child: Text("30"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "31",
                                                          child: Text("31"),
                                                        ),
                                                      ],
                                                      onChanged: (String? value) {
                                                        //get value when changed
                                                        saveData['birthD'] = value;
                                                        birthD = value!;
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
                                                ],)
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                  Text('',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 82, 95, 127),
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.bold)),
                                                  Container(
                                                    width: 230,
                                                    decoration: BoxDecoration(
                                                        color: Color.fromARGB(
                                                            255, 250, 250, 250),
                                                        border:
                                                            Border.all(color: Colors.grey)),
                                                    padding: const EdgeInsets.only(left: 20),
                                                    child: DropdownButton(
                                                      value: birthY,
                                                      items: const [
                                                        //add items in the dropdown
                                                        DropdownMenuItem(
                                                          value: "none",
                                                          child: Text("Select Year"),
                                                        ),
                                                        DropdownMenuItem(
                                                            value: "1989",
                                                            child: Text("1989")),
                                                        DropdownMenuItem(
                                                          value: "1990",
                                                          child: Text("1990"),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: "1991",
                                                          child: Text("1991"),
                                                        ),
                                                      ],
                                                      onChanged: (String? value) {
                                                        saveData['birthY'] = value;
                                                        birthY = value!;
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
                                                ],)
                                              ),
                                            ],
                                          ),
                                          const Padding(padding: EdgeInsets.only(top: 20)),
                                          //about me
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                  Text('About Me',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 82, 95, 127),
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.bold)),
                                                  Container(
                                                    width: 750,
                                                    decoration: BoxDecoration(
                                                        color: Color.fromARGB(
                                                            255, 250, 250, 250),
                                                        border:
                                                            Border.all(color: Colors.grey)),
                                                    child: TextFormField(
                                                          minLines: 1,
                                                          maxLines: 5,
                                                          onChanged: (value) async {
                                                            saveData['about'] = value;
                                                            setState(() {});
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
                                          const Padding(padding: EdgeInsets.only(top: 20)),
                                          new Divider(
                                            height: 0,
                                          ),
                                          const Padding(padding: EdgeInsets.only(top: 20)),
                                          //WORK
                                          Row(
                                            children: const [
                                              Text('WORK',
                                                  style: TextStyle(
                                                      color: Colors.black, fontSize: 11)),
                                              Flexible(
                                                  fit: FlexFit.tight, child: SizedBox()),
                                            ],
                                          ),
                                          const Padding(padding: EdgeInsets.only(top: 20)),
                                          //work title
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                  Text('Work Title',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 82, 95, 127),
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.bold)),
                                                  Container(
                                                    width: 750,
                                                    child:
                                                        input(validator: (value) async {
                                                      print(value);
                                                    }, onchange: (value) async {
                                                      saveData['workTitle'] = value;
                                                      setState(() {});
                                                    }),
                                                  )
                                                ],)
                                              ),
                                            ],
                                          ),
                                          const Padding(padding: EdgeInsets.only(top: 20)),
                                          //work place and website
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                  Text('Work Place',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 82, 95, 127),
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.bold)),
                                                  Container(
                                                    width: 360,
                                                    child:
                                                        input(validator: (value) async {
                                                    }, onchange: (value) async {
                                                      saveData['workPlace'] = value;
                                                      setState(() {});
                                                    }),
                                                  )
                                                ],)
                                              ),
                                              const Padding(padding: EdgeInsets.only(left: 30)),
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                  Text('Work Website',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 82, 95, 127),
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.bold)),
                                                  Container(
                                                    width: 360,
                                                    child:
                                                        input(validator: (value) async {
                                                      print(value);
                                                    }, onchange: (value) async {
                                                      saveData['workWebsite'] = value;
                                                      setState(() {});
                                                    }),
                                                  )
                                                ],)
                                              ),
                                            ],
                                          ),
                                          const Padding(padding: EdgeInsets.only(top: 20)),
                                          new Divider(
                                            height: 0,
                                          ),
                                          //EDUCATION
                                          const Padding(padding: EdgeInsets.only(top: 20)),
                                          Row(
                                            children: const [
                                              Text('EDUCATION',
                                                  style: TextStyle(
                                                      color: Colors.black, fontSize: 11)),
                                              Flexible(
                                                  fit: FlexFit.tight, child: SizedBox()),
                                            ],
                                          ),
                                          const Padding(padding: EdgeInsets.only(top: 20)),
                                          //major
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                  Text('Major',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 82, 95, 127),
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.bold)),
                                                  Container(
                                                    width: 750,
                                                    child:
                                                        input(validator: (value) async {
                                                      print(value);
                                                    }, onchange: (value) async {
                                                      saveData['major'] = value;
                                                      setState(() {});
                                                    }),
                                                  )
                                                ],)
                                              ),
                                            ],
                                          ),
                                          const Padding(padding: EdgeInsets.only(top: 20)),
                                          //school and class
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                  Text('School',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 82, 95, 127),
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.bold)),
                                                  Container(
                                                    width: 360,
                                                    child:
                                                        input(validator: (value) async {
                                                      print(value);
                                                    }, onchange: (value) async {
                                                      saveData['school'] = value;
                                                      setState(() {});
                                                    }),
                                                  )
                                                ],)
                                              ),
                                              const Padding(padding: EdgeInsets.only(left: 30)),
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                  Text('Class',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 82, 95, 127),
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.bold)),
                                                  Container(
                                                    width: 360,
                                                    child:
                                                        input(validator: (value) async {
                                                      print(value);
                                                    }, onchange: (value) async {
                                                      saveData['class'] = value;
                                                      setState(() {});
                                                    }),
                                                  )
                                                ],)
                                              ),
                                            ],
                                          ),
                                          const Padding(padding: EdgeInsets.only(top: 20)),
                                          //politial interest
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
                                                      Text('POLITICAL INTEREST',
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
                                                    Row(
                                                    children: [
                                                      Transform.scale(
                                                          scale: 0.7,
                                                          child: Checkbox(
                                                            fillColor:
                                                                MaterialStateProperty.all<Color>(
                                                                    Colors.black),
                                                            checkColor: Colors.blue,
                                                            activeColor: const Color.fromRGBO(
                                                                0, 123, 255, 1),
                                                            value: selectFlag['policy1'],
                                                            shape: const RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.all(
                                                                    Radius.circular(
                                                                        5.0))), // Rounded Checkbox
                                                            onChanged: (value) {
                                                              setState(() {
                                                                selectFlag['policy1'] = selectFlag['policy1'] ? false : true;
                                                                saveData['policy1'] = selectFlag['policy1'];
                                                              });
                                                            },
                                                          )),
                                                      const Padding(
                                                          padding: EdgeInsets.only(left: 1)),
                                                      const Text(
                                                        'Liberal',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color:
                                                                Color.fromRGBO(150, 150, 150, 1)),
                                                      ),
                                                    ],
                                                  ),

                                                    Row(
                                                      children: [
                                                        Transform.scale(
                                                            scale: 0.7,
                                                            child: Checkbox(
                                                              fillColor:
                                                                  MaterialStateProperty.all<Color>(
                                                                      Colors.black),
                                                              checkColor: Colors.blue,
                                                              activeColor: const Color.fromRGBO(
                                                                  0, 123, 255, 1),
                                                              value: selectFlag['policy2'],
                                                              shape: const RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.all(
                                                                      Radius.circular(
                                                                          5.0))), // Rounded Checkbox
                                                              onChanged: (value) {
                                                                setState(() {
                                                                  selectFlag['policy2'] = selectFlag['policy2'] ? false : true;
                                                                  saveData['policy2'] = selectFlag['policy2'];
                                                                });
                                                              },
                                                            )),
                                                        const Padding(
                                                            padding: EdgeInsets.only(left: 1)),
                                                        const Text(
                                                          'Moderate',
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  Color.fromRGBO(150, 150, 150, 1)),
                                                        ),
                                                      ],
                                                    ),

                                                    Row(
                                                      children: [
                                                        Transform.scale(
                                                            scale: 0.7,
                                                            child: Checkbox(
                                                              fillColor:
                                                                  MaterialStateProperty.all<Color>(
                                                                      Colors.black),
                                                              checkColor: Colors.blue,
                                                              activeColor: const Color.fromRGBO(
                                                                  0, 123, 255, 1),
                                                              value: selectFlag['policy3'],
                                                              shape: const RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.all(
                                                                      Radius.circular(
                                                                          5.0))), // Rounded Checkbox
                                                              onChanged: (value) {
                                                                setState(() {
                                                                  selectFlag['policy3'] = selectFlag['policy3'] ? false : true;
                                                                  saveData['policy3'] = selectFlag['policy3'];
                                                                });
                                                              },
                                                            )),
                                                        const Padding(
                                                            padding: EdgeInsets.only(left: 1)),
                                                        const Text(
                                                          'Conservative',
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  Color.fromRGBO(150, 150, 150, 1)),
                                                        ),
                                                      ],
                                                    ),

                                                  ]),
                                                ],)
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
                                                          width: 750,
                                                          decoration: BoxDecoration(
                                                              color: Color.fromARGB(
                                                                  255, 250, 250, 250),
                                                              border:
                                                                  Border.all(color: Colors.grey)),
                                                          padding: const EdgeInsets.only(left: 20),
                                                          child: DropdownButton(
                                                            value: interests,
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
                                                              interests = value!;
                                                              saveData['interests'] = value;
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
                                          const Padding(padding: EdgeInsets.only(top: 20)),
                                          //save button
                                          Row(
                                            children: [
                                              const Flexible(
                                                  fit: FlexFit.tight, child: SizedBox()),
                                              ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    elevation: 3,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(4.0)),
                                                    minimumSize: const Size(110, 40),
                                                    maximumSize: const Size(110, 40),
                                                  ),
                                                  onPressed: () {
                                                    isShowProgressive = true;
                                                    setState(() {});
                                                    userCon.saveProfile(saveData);
                                                    Timer(const Duration(milliseconds: 1300), () {
                                                      Navigator
                                                      .pushReplacementNamed(
                                                          context,
                                                          '/');
                                                    });
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                    children: [
                                                      isShowProgressive
                                                          ? const SizedBox(
                                                              width: 10,
                                                              height: 10.0,
                                                              child: CircularProgressIndicator(
                                                                color: Colors.grey,
                                                              ),
                                                            )
                                                          : Container(),
                                                      isShowProgressive
                                                          ? const Padding(padding: EdgeInsets.only(left: 10))
                                                          : Container(),
                                                      const Padding(
                                                          padding:
                                                              EdgeInsets.only(top: 17)),
                                                      const Icon(
                                                        Icons.check_circle,
                                                        color: Colors.white,
                                                        size: 14.0,
                                                      ),
                                                      const Padding(
                                                          padding:
                                                              EdgeInsets.only(left: 10)),
                                                      const Text('Finish',
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 9,
                                                              fontWeight: FontWeight.w600)),
                                                    ],
                                                  )),
                                              const Padding(
                                                  padding: EdgeInsets.only(right: 50))
                                            ],
                                          ),
                                          const Padding(padding: EdgeInsets.only(top:20)),
                                        ],
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ]),
              ),
              ),
            
            AnimatedBuilder(
                animation: _drawerSlideController,
                builder: (context, child) {
                  return FractionalTranslation(
                      translation: SizeConfig(context).screenWidth >
                              SizeConfig.smallScreenSize
                          ? Offset(0, 0)
                          : Offset(_drawerSlideController.value * 0.001, 0.0),
                      child: SizeConfig(context).screenWidth >
                                  SizeConfig.smallScreenSize ||
                              _isDrawerClosed()
                          ? const SizedBox()
                          : Padding(
                              padding:
                                  EdgeInsets.only(top: SizeConfig.navbarHeight),
                              child: Container(
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        color: Colors.white,
                                        width: SizeConfig.leftBarWidth,
                                        child: SingleChildScrollView(
                                          child: LeftPanel(),
                                        ),
                                      )
                                    ]),
                              )));
                }),
            showSearch
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        showSearch = false;
                      });
                    },
                    child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: const Color.fromARGB(0, 214, 212, 212),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: const SizedBox(
                                      width: 20,
                                      height: 20,
                                    )),
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, right: 9),
                                  width: SizeConfig(context).screenWidth * 0.4,
                                  child: TextField(
                                    focusNode: searchFocusNode,
                                    controller: searchController,
                                    cursorColor: Colors.white,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.search,
                                          color: Color.fromARGB(
                                              150, 170, 212, 255),
                                          size: 20),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0)),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xff202020),
                                      hintText: 'Search',
                                      hintStyle: TextStyle(
                                          fontSize: 15.0, color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            ShnatterSearchBox()
                          ],
                        )),
                  )
                : const SizedBox()
          ],
        ));
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
  Future<XFile> chooseImage() async {
    final _imagePicker = ImagePicker();
    XFile? pickedFile;
    if (kIsWeb){
      pickedFile = await _imagePicker.pickImage(
          source: ImageSource.gallery,
        );
    }
    else{
      //Check Permissions
      await Permission.photos.request();

      var permissionStatus = await Permission.photos.status;

      if (permissionStatus.isGranted){
      }
      else{
        print('Permission not granted. Try Again with permission access');
      }
    }
    return pickedFile!;
  }
  uploadFile(XFile? pickedFile) async {
    final _firebaseStorage = FirebaseStorage.instance;
    if(kIsWeb){
        try{
          
          //print("read bytes");
          Uint8List bytes  = await pickedFile!.readAsBytes();
          //print(bytes);
          Reference _reference = await _firebaseStorage.ref()
            .child('images/${PPath.basename(pickedFile!.path)}');
          final uploadTask = _reference.putData(
            bytes,
            SettableMetadata(contentType: 'image/jpeg'),
          );
          uploadTask.whenComplete(() async {
            var downloadUrl = await _reference.getDownloadURL();
            userCon.userAvatar = downloadUrl;
            userCon.setState(() {});
            userCon.changeAvatar();
            //await _reference.getDownloadURL().then((value) {
            //  uploadedPhotoUrl = value;
            //});
          });
          uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
                      switch (taskSnapshot.state) {
                        case TaskState.running:
                          progress =
                              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
                              setState(() {});
                              print("Upload is $progress% complete.");

                          break;
                        case TaskState.paused:
                          print("Upload is paused.");
                          break;
                        case TaskState.canceled:

                          print("Upload was canceled");
                          break;
                        case TaskState.error:
                        // Handle unsuccessful uploads
                          break;
                        case TaskState.success:
                         print("Upload is completed");
                        // Handle successful uploads on complete
                        // ...
                        //  var downloadUrl = await _reference.getDownloadURL();
                          break;
                      }
                    });
        }catch(e)
        {
          // print("Exception $e");
        }
    }else{
      var file = File(pickedFile!.path);
      //write a code for android or ios
      Reference _reference = await _firebaseStorage.ref()
          .child('images/${PPath.basename(pickedFile!.path)}');
        _reference.putFile(
          file
        )
        .whenComplete(() async {
            print('value');
          var downloadUrl = await _reference.getDownloadURL();
          await _reference.getDownloadURL().then((value) {
            // userCon.userAvatar = value;
            // userCon.setState(() {});
            // print(value);
          });
        });
    }

  }
  uploadImage() async {
    XFile? pickedFile = await chooseImage();
    uploadFile(pickedFile);   
  }
}
