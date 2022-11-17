
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
  var interestsCheck = [];
  var parent;
  List years = [];
  List days = [];
  List months = [];
  List category = [
    {
      'title' : 'none'
    }
  ];
  List subCategory = [];
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
    years.add('none');
    for(int i = 1905; i<2023; i++){
      years.add('$i');
    }
    days.add('none');
    for(int i = 1; i<32; i++){
      days.add('$i');
    }
    months.add('none');
    for(int i = 1; i<13; i++){
      months.add('$i');
    }
    add(widget.userCon);
    super.initState();
    userCon = controller as UserController;
    searchFocusNode = FocusNode();
    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    userCon.userAvatar = UserManager.userInfo['avatar'] == null ? '' : UserManager.userInfo['avatar'];
    userCon.setState(() {});
    userCon.getAllInterests().then((allInterests) =>
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
                                                      items: 
                                                      months.map((year) => DropdownMenuItem(
                                                              value: year,
                                                              child: Text(year == 'none'? "Select Month": year),
                                                            )).toList(),
                                                      onChanged: (dynamic? value) {
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
                                                      items: 
                                                      days.map((year) => DropdownMenuItem(
                                                              value: year,
                                                              child: Text(year == 'none'? "Select Day": year),
                                                            )).toList(),
                                                      onChanged: (dynamic? value) {
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
                                                      items: 
                                                      years.map((year) => DropdownMenuItem(
                                                              value: year,
                                                              child: Text(year == 'none'? "Select Year": year),
                                                            )).toList(),
                                                      onChanged: (dynamic? value) {
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
                                                Container(
                                                  height: 300,
                                                  child: ListView.builder(
                                                    itemCount: subCategory.length,
                                                    itemBuilder: (BuildContext context, int index) {
                                                    return Column(children: [ Row(children: [
                                                      const Padding(padding: EdgeInsets.only(left: 10)),
                                                      Text(subCategory[index]['title'],style: const TextStyle(
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
                                                            value: interestsCheck[index]['interested'],
                                                            shape: const RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.all(
                                                                    Radius.circular(
                                                                        5.0))), // Rounded Checkbox
                                                            onChanged: (value) {
                                                              setState(() {
                                                                interestsCheck[index]['interested'] = !interestsCheck[index]['interested'];
                                                              });
                                                            },
                                                          )),
                                                      const Padding(padding: EdgeInsets.only(left: 30))
                                                    ],),
                                                    Divider(
                                                      thickness: 0.1,
                                                      color: Colors.black,
                                                    )]);
                                                  }),
                                                )
                                              ]),
                                            ),
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
                                                    saveData['interests'] = [];
                                                    for(int i = 0; i<interestsCheck.length; i++){
                                                      if (interestsCheck[i]['interested'] == true) {
                                                        saveData['interests'].add(interestsCheck[i]['title']);
                                                      }
                                                    }
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
