import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/views/navigationbar.dart';
import 'package:shnatter/src/widget/interests.dart';
import 'package:path/path.dart' as PPath;

import '../controllers/UserController.dart';
import '../utils/size_config.dart';
import 'dart:io' show File, Platform;
import 'package:flutter/foundation.dart' show Uint8List, kDebugMode, kIsWeb;
import 'package:flutter_svg/flutter_svg.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
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
  List country = [
    {
      'title': 'Select Country',
      'value': 'none',
    },
    {
      'title': 'United State',
      'value': 'us',
    },
    {
      'title': 'Switzerland',
      'value': 'sw',
    },
    {
      'title': 'Canada',
      'value': 'ca',
    },
  ];
  List userRelationship = [
    {
      'value': 'none',
      'title': 'Select Relationship',
    },
    {
      'value': 'single',
      'title': 'Single',
    },
    {
      'value': 'inarelationship',
      'title': 'In a relationship',
    },
    {
      'value': 'Married',
      'title': 'Married',
    },
    {
      'value': 'complicated',
      'title': 'It\'s a complicated',
    },
    {
      'value': 'separated',
      'title': 'Seperated',
    },
    {
      'value': 'divorced',
      'title': 'Divorced',
    },
    {
      'value': 'widowed',
      'title': 'Widowed',
    },
  ];

  var interestsCheck = [];
  var parent;

  Map day = {};
  List<dynamic> year = [
    {'value': 'none', 'title': 'Year'}
  ];
  List<dynamic> month = [
    {'value': 'none', 'title': 'Month'},
    {'value': '1', 'title': 'Jan'},
    {'value': '2', 'title': 'Feb'},
    {'value': '3', 'title': 'Mar'},
    {'value': '4', 'title': 'Apr'},
    {'value': '5', 'title': 'May'},
    {'value': '6', 'title': 'Jun'},
    {'value': '7', 'title': 'Jul'},
    {'value': '8', 'title': 'Aug'},
    {'value': '9', 'title': 'Sep'},
    {'value': '10', 'title': 'Oct'},
    {'value': '11', 'title': 'Nov'},
    {'value': '12', 'title': 'Dec'}
  ];
  List category = [
    {'title': 'none'}
  ];
  List subCategory = [];
  var isShowProgressive = false;
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
    progress = 0;
    selectFlag['jew'] = false;
    selectFlag['policy1'] = false;
    selectFlag['policy2'] = false;
    selectFlag['policy3'] = false;
    selectFlag['avatar'] = '';
    for (int i = 1; i < 13; i++) {
      var d = [
        {'value': 'none', 'title': 'Day'}
      ];
      for (int j = 1; j < 32; j++) {
        if (i == 2 && j == 29) {
          break;
        } else if (i == 4 || i == 6 || i == 9 || i == 11) {
          if (j == 31) {
            break;
          }
        }
        d.add({
          'value': j.toString(),
          'title': j.toString(),
        });
      }
      day = {...day, i.toString(): d};
    }
    for (int i = 1910; i < 2022; i++) {
      year.add({
        'value': i.toString(),
        'title': i.toString(),
      });
    }
    add(widget.userCon);
    super.initState();
    userCon = controller as UserController;
    searchFocusNode = FocusNode();
    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    // ignore: prefer_if_null_operators
    userCon.userAvatar = UserManager.userInfo['avatar'] == null
        ? ''
        : UserManager.userInfo['avatar'];
    userCon.setState(() {});
    userCon.getAllInterests().then((allInterests) => {
          for (int i = 0; i < allInterests.length; i++)
            {
              if (allInterests[i]['parentId'] == '0')
                {category.add(allInterests[i]), setState(() {})},
              subCategory.add(allInterests[i]),
              parent = allInterests
                  .where((inte) => inte['id'] == allInterests[i]['parentId'])
                  .toList(),
              interestsCheck.add({
                'title': allInterests[i]['title'],
                'interested': false,
                'parentId': parent.length == 0
                    ? allInterests[i]['title']
                    : parent[0]['title']
              }),
              setState(() {})
            }
        });
    Helper.userCollection
        .doc(UserManager.userInfo['uid'])
        .get()
        .then((value) => {
              saveData = value.data()!,
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
    // if (_isDrawerOpen() || _isDrawerOpening()) {
    //   _drawerSlideController.reverse();
    // } else {
    //   _drawerSlideController.forward();
    // }
  }

  void onSearchBarDismiss() {
    if (showSearch) {
      setState(() {
        showSearch = false;
      });
    }
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
    List<dynamic> bDay = day[saveData['birthM'] ?? '1'];
    return Scaffold(
      key: _scaffoldKey,
      drawerEnableOpenDragGesture: false,
      drawer: const Drawer(),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            ShnatterNavigation(
              searchController: searchController,
              onSearchBarFocus: onSearchBarFocus,
              onSearchBarDismiss: onSearchBarDismiss,
              drawClicked: clickMenu,
              routerChange: () {},
              textChange: () {},
            ),
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: SingleChildScrollView(
                child: Column(children: [
                  const Padding(padding: EdgeInsets.only(top: 50)),
                  const Column(
                    children: [
                      Text('Getting Started',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )),
                      Padding(padding: EdgeInsets.only(top: 15)),
                      Text('This information will let us know more about you',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ))
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    margin: const EdgeInsets.only(bottom: 20, top: 20),
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
                                        : const Color.fromARGB(
                                            255, 243, 243, 243),
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0)),
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
                                          padding: EdgeInsets.only(top: 15)),
                                      Text('Step 1',
                                          style: TextStyle(
                                              color: stepflag
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600)),
                                      const Padding(
                                          padding: EdgeInsets.only(top: 3)),
                                      Text(
                                        'Upload your photo',
                                        style: TextStyle(
                                            color: stepflag
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 12),
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
                                        ? const Color.fromARGB(
                                            255, 243, 243, 243)
                                        : const Color.fromARGB(
                                            255, 0, 123, 255),
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0)),
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
                                          padding: EdgeInsets.only(top: 15)),
                                      Text('Step 2',
                                          style: TextStyle(
                                              color: stepflag
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600)),
                                      const Padding(
                                          padding: EdgeInsets.only(top: 3)),
                                      Text('Update your info',
                                          style: TextStyle(
                                              color: stepflag
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontSize: 12)),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Welcome',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 22),
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(left: 10)),
                                      Text(
                                        UserManager.userInfo['fullName'],
                                        style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 0, 123, 255),
                                            fontSize: 22),
                                      ),
                                    ],
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 15)),
                                  const Text('Let\'s start with your photo'),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 20)),
                                  Stack(
                                    children: [
                                      userCon.userAvatar != ''
                                          ? Container(
                                              width: 120,
                                              height: 120,
                                              padding: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 250, 250, 250),
                                                  borderRadius:
                                                      BorderRadius.circular(60),
                                                  border: Border.all(
                                                      color: Colors.grey)),
                                              child: CircleAvatar(
                                                radius: 60,
                                                backgroundImage: NetworkImage(
                                                    userCon.userAvatar),
                                              ))
                                          : Container(
                                              width: 120,
                                              height: 120,
                                              padding: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 250, 250, 250),
                                                  borderRadius:
                                                      BorderRadius.circular(60),
                                                  border: Border.all(
                                                      color: Colors.grey)),
                                              child: SvgPicture.network(
                                                  'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fprofile%2Fblank_profile_male.svg?alt=media&token=eaf0c1c7-5a30-4771-a7b8-9dc312eafe82'),
                                            ),
                                      // (progress !=0&&progress !=100) ? LinearProgressIndicator(
                                      //   value: progress,
                                      //   semanticsLabel: 'Linear progress indicator',
                                      // ), : SizedBox(),
                                      (progress != 0 && progress != 100)
                                          ? AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              margin: const EdgeInsets.only(
                                                  top: 70, left: 10),
                                              width: 100,
                                              padding: EdgeInsets.only(
                                                  right: 100 -
                                                      (100 * progress / 100)),
                                              child:
                                                  const LinearProgressIndicator(
                                                color: Colors.blue,
                                                value: 10,
                                                semanticsLabel:
                                                    'Linear progress indicator',
                                              ),
                                            )
                                          : const SizedBox(),
                                      Container(
                                        width: 26,
                                        height: 26,
                                        margin: const EdgeInsets.only(
                                            top: 90, left: 90),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(13),
                                          color: Colors.grey[400],
                                        ),
                                        child: kIsWeb
                                            ? ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  backgroundColor:
                                                      Colors.grey[300],
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              13)),
                                                  minimumSize:
                                                      const Size(26, 26),
                                                  maximumSize:
                                                      const Size(26, 26),
                                                ),
                                                onPressed: () {
                                                  uploadImage();
                                                },
                                                child: const Icon(
                                                    Icons
                                                        .camera_enhance_rounded,
                                                    color: Colors.black,
                                                    size: 16.0),
                                              )
                                            : PopupMenuButton(
                                                onSelected: (value) {
                                                  _onMenuItemSelected(
                                                      value, 'avatar');
                                                },
                                                child: const Icon(
                                                    Icons
                                                        .camera_enhance_rounded,
                                                    color: Colors.black,
                                                    size: 16.0),
                                                itemBuilder: (context) => [
                                                      const PopupMenuItem(
                                                        value: 1,
                                                        child: Text(
                                                          'Camera',
                                                        ),
                                                      ),
                                                      const PopupMenuItem(
                                                        value: 2,
                                                        child: Text(
                                                          "Gallery",
                                                        ),
                                                      )
                                                    ]),
                                      ),
                                    ],
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 20)),
                                  Row(
                                    children: [
                                      const Flexible(
                                          fit: FlexFit.tight,
                                          child: SizedBox()),
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
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 17)),
                                              Text('Next Step',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10)),
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
                                    const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Update your info',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 22),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(left: 10)),
                                        Text(
                                          'Share your information with our community',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13),
                                        ),
                                      ],
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 30)),
                                    const Row(
                                      children: [
                                        Text('LOCATION',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 11)),
                                        Flexible(
                                            fit: FlexFit.tight,
                                            child: SizedBox()),
                                      ],
                                    ),
                                    //country
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: SizedBox(
                                            width: 400,
                                            child: customDropDownButton(
                                              title: 'Country',
                                              width: 400,
                                              item: country,
                                              value: saveData['country'] ??
                                                  country[0]['value'],
                                              onChange: (value) {
                                                saveData['country'] = value!;
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 20)),
                                    //current city
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: customInput(
                                              title: 'Current City',
                                              onChange: (value) async {
                                                saveData['current'] = value;
                                                setState(() {});
                                              }),
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.only(left: 30)),
                                        Expanded(
                                          flex: 1,
                                          child: customInput(
                                              title: 'Hometown',
                                              onChange: (value) async {
                                                saveData['hometown'] = value;
                                                setState(() {});
                                              }),
                                        ),
                                      ],
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 20)),
                                    //relation
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 400,
                                                child: customDropDownButton(
                                                  title: 'Relationship Status',
                                                  width: 400,
                                                  item: userRelationship,
                                                  value: saveData[
                                                          'relationship'] ??
                                                      userRelationship[0]
                                                          ['value'],
                                                  onChange: (value) {
                                                    saveData['relationship'] =
                                                        value!;
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Row(
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 30)),
                                                    Text('I am jewish',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    82,
                                                                    95,
                                                                    127),
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 20)),
                                                    SizedBox(
                                                      height: 20,
                                                      child: Transform.scale(
                                                        scaleX: 0.55,
                                                        scaleY: 0.55,
                                                        child: CupertinoSwitch(
                                                          activeColor:
                                                              Colors.grey,
                                                          value:
                                                              selectFlag['jew'],
                                                          onChanged: (value) {
                                                            setState(() {
                                                              selectFlag[
                                                                      'jew'] =
                                                                  value;
                                                              saveData['jew'] =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )),
                                      ],
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 20)),
                                    //birthday
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: SizedBox(
                                            width: 400,
                                            child: customDropDownButton(
                                              width: 400,
                                              title: 'Birthday',
                                              item: month,
                                              value: saveData['birthM'] ??
                                                  month[0]['value'],
                                              onChange: (value) {
                                                saveData['birthM'] =
                                                    value.toString();
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: SizedBox(
                                            width: 400,
                                            child: customDropDownButton(
                                              title: '',
                                              width: 400,
                                              item: bDay,
                                              value: saveData['birthD'] ??
                                                  bDay[0]['value'],
                                              onChange: (value) {
                                                saveData['birthD'] =
                                                    value.toString();
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: SizedBox(
                                            width: 400,
                                            child: customDropDownButton(
                                              width: 400,
                                              title: '',
                                              item: year,
                                              value: saveData['birthY'] ??
                                                  year[0]['value'],
                                              onChange: (value) {
                                                saveData['birthY'] =
                                                    value.toString();
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 20)),
                                    //about me
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: SizedBox(
                                            width: 700,
                                            child: titleAndsubtitleInput(
                                                'About Me', 100, 4, (value) {
                                              saveData['about'] = value;
                                            }, saveData['about'] ?? ''),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 20)),
                                    const Divider(
                                      height: 0,
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 20)),
                                    //WORK
                                    const Row(
                                      children: [
                                        Text('WORK',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 11)),
                                        Flexible(
                                            fit: FlexFit.tight,
                                            child: SizedBox()),
                                      ],
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 20)),
                                    //work title
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: customInput(
                                              title: 'Work Title',
                                              onChange: (value) async {
                                                saveData['workTitle'] = value;
                                                setState(() {});
                                              }),
                                        ),
                                      ],
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 20)),
                                    //work place and website
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: customInput(
                                              title: 'Work Place',
                                              onChange: (value) async {
                                                saveData['workPlace'] = value;
                                                setState(() {});
                                              }),
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.only(left: 30)),
                                        Expanded(
                                          flex: 1,
                                          child: customInput(
                                              title: 'Work Website',
                                              onChange: (value) async {
                                                saveData['workWebsite'] = value;
                                                setState(() {});
                                              }),
                                        ),
                                      ],
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 20)),
                                    const Divider(
                                      height: 0,
                                    ),
                                    //EDUCATION
                                    const Padding(
                                        padding: EdgeInsets.only(top: 20)),
                                    const Row(
                                      children: [
                                        Text('EDUCATION',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 11)),
                                        Flexible(
                                            fit: FlexFit.tight,
                                            child: SizedBox()),
                                      ],
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 20)),
                                    //major
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: customInput(
                                              title: 'Major',
                                              onChange: (value) async {
                                                saveData['major'] = value;
                                                setState(() {});
                                              }),
                                        ),
                                      ],
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 20)),
                                    //school and class
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: customInput(
                                              title: 'School',
                                              onChange: (value) async {
                                                saveData['school'] = value;
                                                setState(() {});
                                              }),
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.only(left: 30)),
                                        Expanded(
                                          flex: 1,
                                          child: customInput(
                                              title: 'Class',
                                              onChange: (value) async {
                                                saveData['class'] = value;
                                                setState(() {});
                                              }),
                                        ),
                                      ],
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 20)),
                                    //politial interest
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Row(
                                                  children: [
                                                    Text('POLITICAL INTEREST',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 11)),
                                                    Flexible(
                                                        fit: FlexFit.tight,
                                                        child: SizedBox()),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 30),
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
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                                        Colors
                                                                            .black),
                                                            checkColor:
                                                                Colors.blue,
                                                            activeColor:
                                                                const Color
                                                                        .fromRGBO(
                                                                    0,
                                                                    123,
                                                                    255,
                                                                    1),
                                                            value: selectFlag[
                                                                'policy1'],
                                                            shape: const RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5.0))), // Rounded Checkbox
                                                            onChanged: (value) {
                                                              setState(() {
                                                                selectFlag[
                                                                        'policy1'] =
                                                                    selectFlag[
                                                                            'policy1']
                                                                        ? false
                                                                        : true;
                                                                saveData[
                                                                        'policy1'] =
                                                                    selectFlag[
                                                                        'policy1'];
                                                              });
                                                            },
                                                          )),
                                                      const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 1)),
                                                      const Text(
                                                        'Liberal',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color:
                                                                Color.fromRGBO(
                                                                    150,
                                                                    150,
                                                                    150,
                                                                    1)),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Transform.scale(
                                                          scale: 0.7,
                                                          child: Checkbox(
                                                            fillColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                                        Colors
                                                                            .black),
                                                            checkColor:
                                                                Colors.blue,
                                                            activeColor:
                                                                const Color
                                                                        .fromRGBO(
                                                                    0,
                                                                    123,
                                                                    255,
                                                                    1),
                                                            value: selectFlag[
                                                                'policy2'],
                                                            shape: const RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5.0))), // Rounded Checkbox
                                                            onChanged: (value) {
                                                              setState(() {
                                                                selectFlag[
                                                                        'policy2'] =
                                                                    selectFlag[
                                                                            'policy2']
                                                                        ? false
                                                                        : true;
                                                                saveData[
                                                                        'policy2'] =
                                                                    selectFlag[
                                                                        'policy2'];
                                                              });
                                                            },
                                                          )),
                                                      const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 1)),
                                                      const Text(
                                                        'Moderate',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color:
                                                                Color.fromRGBO(
                                                                    150,
                                                                    150,
                                                                    150,
                                                                    1)),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Transform.scale(
                                                          scale: 0.7,
                                                          child: Checkbox(
                                                            fillColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                                        Colors
                                                                            .black),
                                                            checkColor:
                                                                Colors.blue,
                                                            activeColor:
                                                                const Color
                                                                        .fromRGBO(
                                                                    0,
                                                                    123,
                                                                    255,
                                                                    1),
                                                            value: selectFlag[
                                                                'policy3'],
                                                            shape: const RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5.0))), // Rounded Checkbox
                                                            onChanged: (value) {
                                                              setState(() {
                                                                selectFlag[
                                                                        'policy3'] =
                                                                    selectFlag[
                                                                            'policy3']
                                                                        ? false
                                                                        : true;
                                                                saveData[
                                                                        'policy3'] =
                                                                    selectFlag[
                                                                        'policy3'];
                                                              });
                                                            },
                                                          )),
                                                      const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 1)),
                                                      const Text(
                                                        'Conservative',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color:
                                                                Color.fromRGBO(
                                                                    150,
                                                                    150,
                                                                    150,
                                                                    1)),
                                                      ),
                                                    ],
                                                  ),
                                                ]),
                                              ],
                                            )),
                                      ],
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 20)),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InterestsWidget(
                                            context: context,
                                            header: true,
                                            data: UserManager
                                                .userInfo['interests'],
                                            sendUpdate: (value) {
                                              saveData['interests'] = value;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    //all interests
                                    const Padding(
                                        padding: EdgeInsets.only(top: 20)),
                                    //save button
                                    Row(
                                      children: [
                                        const Flexible(
                                            fit: FlexFit.tight,
                                            child: SizedBox()),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              elevation: 3,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0)),
                                              minimumSize: const Size(110, 40),
                                              maximumSize: const Size(110, 40),
                                            ),
                                            onPressed: () async {
                                              isShowProgressive = true;
                                              setState(() {});
                                              await userCon.saveProfile({
                                                ...saveData,
                                                'isStarted': true
                                              });
                                              Timer(
                                                  const Duration(
                                                      milliseconds: 1300), () {
                                                Navigator.pushReplacementNamed(
                                                    context,
                                                    RouteNames.homePage);
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
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Colors.grey,
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                                const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 17)),
                                                const Icon(
                                                  Icons.check_circle,
                                                  color: Colors.white,
                                                  size: 14.0,
                                                ),
                                                const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10)),
                                                const Text('Finish',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 9,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ],
                                            )),
                                        const Padding(
                                            padding: EdgeInsets.only(right: 50))
                                      ],
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 20)),
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
                          ? const Offset(0, 0)
                          : Offset(_drawerSlideController.value * 0.001, 0.0),
                      child: SizeConfig(context).screenWidth >
                                  SizeConfig.smallScreenSize ||
                              _isDrawerClosed()
                          ? const SizedBox()
                          : const Padding(
                              padding:
                                  EdgeInsets.only(top: SizeConfig.navbarHeight),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [])));
                }),
          ],
        ),
      ),
    );
  }

  Widget customInput({title, onChange, controller}) {
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
          child: TextField(
            controller: controller,
            onChanged: onChange,
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

  Widget customDropDownButton(
      {title, double width = 0, item = const [], value, onChange}) {
    List items = item;
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Column(
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
            width: width,
            child: DropdownButtonFormField(
              value: value,
              items: items
                  .map((e) => DropdownMenuItem(
                      value: e['value'], child: Text(e['title'])))
                  .toList(),
              onChanged: onChange,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(top: 10, left: 10),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 1),
                ),
              ),
              icon: const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Icon(Icons.arrow_drop_down)),
              iconEnabledColor: Colors.grey, //Icon color

              style: const TextStyle(
                color: Colors.grey, //Font color
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              dropdownColor: Colors.white,
              isExpanded: true,
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget titleAndsubtitleInput(title, double height, line, onChange, text) {
    TextEditingController inputController = TextEditingController();
    inputController.text = text;
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
                  width: 400,
                  height: height,
                  child: Column(
                    children: [
                      TextField(
                        maxLines: line,
                        minLines: line,
                        controller: inputController,
                        onChanged: (value) {
                          onChange(value);
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(top: 10, left: 10),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<XFile> chooseImage(int value) async {
    final imagePicker = ImagePicker();

    if (value == 1 && !kIsWeb) {
      XFile? pickedFile;
      if (kIsWeb) {
        pickedFile = await imagePicker.pickImage(
          source: ImageSource.camera,
        );
      } else {
        pickedFile = await imagePicker.pickImage(
          source: ImageSource.camera,
        );
      }
      return pickedFile!;
    } else {
      XFile? pickedFile;
      if (kIsWeb) {
        pickedFile = await imagePicker.pickImage(
          source: ImageSource.gallery,
        );
      } else {
        pickedFile = await imagePicker.pickImage(
          source: ImageSource.gallery,
        );
      }
      return pickedFile!;
    }
  }

  uploadFile(XFile? pickedFile) async {
    final firebaseStorage = FirebaseStorage.instance;
    UploadTask uploadTask;
    Reference reference;
    try {
      if (kIsWeb) {
        //print("read bytes");
        Uint8List bytes = await pickedFile!.readAsBytes();
        //print(bytes);
        reference = firebaseStorage
            .ref()
            .child('images/${PPath.basename(pickedFile.path)}');
        uploadTask = reference.putData(
          bytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      } else {
        var file = File(pickedFile!.path);
        //write a code for android or ios
        reference = firebaseStorage
            .ref()
            .child('images/${PPath.basename(pickedFile.path)}');
        uploadTask = reference.putFile(file);
      }
      uploadTask.whenComplete(() async {
        var downloadUrl = await reference.getDownloadURL();
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
            progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            setState(() {});

            break;
          case TaskState.paused:
            break;
          case TaskState.canceled:
            break;
          case TaskState.error:
            // Handle unsuccessful uploads
            break;
          case TaskState.success:

            // Handle successful uploads on complete
            // ...
            //  var downloadUrl = await _reference.getDownloadURL();
            break;
        }
      });
    } catch (e) {
      // print("Exception $e");
    }
  }

  uploadImage() async {
    XFile? pickedFile = await chooseImage(2);
    uploadFile(pickedFile);
  }

  Future<void> _onMenuItemSelected(int value, type) async {
    XFile? pickedFile = await chooseImage(value);

    uploadFile(
      pickedFile,
    );
  }
}
