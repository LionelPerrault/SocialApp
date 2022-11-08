import 'dart:html';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/views/box/searchbox.dart';
import 'package:shnatter/src/views/navigationbar.dart';
import 'package:shnatter/src/views/panel/leftpanel.dart';
import 'package:shnatter/src/views/panel/mainpanel.dart';
import 'package:shnatter/src/views/panel/rightpanel.dart';
import 'package:shnatter/src/widget/primaryInput.dart';

import '../controllers/UserController.dart';
import '../utils/size_config.dart';
import '../widget/mprimary_button.dart';
import '../widget/list_text.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/gestures.dart';
import 'box/notification.dart';

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
  bool stepflag = false;
  String country = 'Select Country';
  var profileInfo = {};
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
    add(widget.userCon);
    super.initState();
    userCon = controller as UserController;
    searchFocusNode = FocusNode();
    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    userCon.checkIfLogined().then((value) => {
          if (!value)
            {Navigator.pushReplacementNamed(context, RouteNames.login)}
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
            Column(
            children: [
              const Padding(padding:EdgeInsets.only(top: 190)),
              Container(
                width: 752,
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
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: stepflag ? const Color.fromARGB(255, 0, 123, 255) : const Color.fromARGB(255, 243, 243, 243),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0)),
                            minimumSize: const Size(350, 75),
                            maximumSize: const Size(350, 75),
                          ),
                          onPressed: () { ()=>{}; },
                          child: Column(children: [
                            const Padding(padding: EdgeInsets.only(top: 17)),
                            Text('Step 1',
                            style: TextStyle(
                            color: stepflag ? Colors.white : Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w600)),
                            const Padding(padding: EdgeInsets.only(top: 6)),
                            Text('Upload your photo',
                            style: TextStyle(
                            color: stepflag ? Colors.white : Colors.black,
                            fontSize: 13),)
                          ],)
                        ),
                        const Padding(padding: EdgeInsets.only(left: 12)),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: stepflag ? const Color.fromARGB(255, 243, 243, 243) : const Color.fromARGB(255, 0, 123, 255),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0)),
                            minimumSize: const Size(350, 75),
                            maximumSize: const Size(350, 75),
                          ),
                          onPressed: () { ()=>{}; },
                          child: Column(children: [
                            const Padding(padding: EdgeInsets.only(top: 17)),
                            Text('Step 2',
                            style: TextStyle(
                            color: stepflag ? Colors.black : Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600)),
                            const Padding(padding: EdgeInsets.only(top: 6)),
                            Text('Update your info',
                            style: TextStyle(
                            color: stepflag ? Colors.black : Colors.white,
                            fontSize: 13)),
                          ],)
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(top: 30)),
                    stepflag?
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text('Welcome',
                              style: TextStyle(
                              color: Colors.black,
                              fontSize: 22),),
                            Padding(padding: EdgeInsets.only(left: 10)),
                            Text('username',
                              style: TextStyle(
                              color: Color.fromARGB(255, 0, 123, 255),
                              fontSize: 22),),
                          ],),
                        const Padding(padding: EdgeInsets.only(top: 15)),
                        const Text('Let\'s start with your photo'),
                        const Padding(padding: EdgeInsets.only(top: 20)),
                        Stack(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 250, 250, 250),
                                borderRadius: BorderRadius.circular(60),
                                border: Border.all(color: Colors.grey)
                              ),
                              child: SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fprofile%2Fblank_profile_male.svg?alt=media&token=eaf0c1c7-5a30-4771-a7b8-9dc312eafe82'),
                            ),
                            Container(
                              width: 26,
                              height: 26,
                              margin: const EdgeInsets.only(top: 90, left: 90),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.grey[400],
                              ),
                              child: 
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(4),
                                  backgroundColor: Colors.grey[300],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13)),
                                  minimumSize: const Size(26, 26),
                                  maximumSize: const Size(26, 26),
                                ),
                                onPressed: () { ()=>{}; },
                                child: const Icon(Icons.camera_enhance_rounded,
                                    color: Colors.black,
                                    size: 16.0),
                              ),
                            ),
                          ],
                        ),
                        const Padding(padding: EdgeInsets.only(top: 20)),
                        Row(children: [
                          const Flexible(fit: FlexFit.tight, child: SizedBox()),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0)),
                              minimumSize: const Size(110, 40),
                              maximumSize: const Size(110, 40),
                            ),
                            onPressed: () { ()=>{}; },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                              const Padding(padding: EdgeInsets.only(top: 17)),
                              Text('Next Step',
                              style: TextStyle(
                              color: stepflag ? Colors.black : Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w600)),
                              const Padding(padding: EdgeInsets.only(left: 10)),
                              const Icon(Icons.arrow_circle_right,
                                color: Colors.black,
                                size: 14.0,)
                            ],)
                          ),
                          const Padding(padding: EdgeInsets.only(right: 50))
                        ],),
                        const Padding(padding: EdgeInsets.only(bottom: 20))
                      ],
                    )
                    :
                    Column(children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text('Update your info',
                              style: TextStyle(
                              color: Colors.black,
                              fontSize: 22),),
                            Padding(padding: EdgeInsets.only(left: 10)),
                            Text('Share your information with our community',
                              style: TextStyle(
                              color: Colors.black,
                              fontSize: 13),),
                          ],),
                      const Padding(padding: EdgeInsets.only(top: 30)),
                      Row(
                        children: const [
                          Padding(padding: EdgeInsets.only(left: 30)),
                          Text('LOCATION',
                            style: TextStyle(
                            color: Colors.black,
                            fontSize: 11)),
                          Flexible(fit: FlexFit.tight, child: SizedBox()),
                          const Padding(padding: EdgeInsets.only(top: 30),)
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: const [
                              Padding(padding: EdgeInsets.only(left: 40)),
                              Text('Country',
                                style: TextStyle(
                                color: Color.fromARGB(255, 82, 95, 127),
                                fontSize: 11)),
                              Flexible(fit: FlexFit.tight, child: SizedBox()),
                              const Padding(padding: EdgeInsets.only(top: 30),)
                            ],
                          ),
                          Container(
                            width: 680,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 250, 250, 250),
                              border: Border.all(color: Colors.grey)
                            ),
                            padding: const EdgeInsets.only(left: 20),
                            child: DropdownButton(
                                value: country,
                                items: const [
                                  //add items in the dropdown
                                  DropdownMenuItem(
                                    value: "Select Country",
                                    child: Text("Select Country"),
                                  ),
                                  DropdownMenuItem(
                                      value: "Female",
                                      child: Text("Female")),
                                  DropdownMenuItem(
                                    value: "Other",
                                    child: Text("Other"),
                                  )
                                ],
                                onChanged: (String? value) {
                                  //get value when changed
                                  profileInfo['country'] = value;
                                  country= value!;
                                  setState(() {});
                                },
                                style: const TextStyle(
                                    //te
                                    color:
                                        Colors.black, //Font color
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
                          const Padding(padding: EdgeInsets.only(bottom: 10))
                        ],
                      ),
                      Row(children: [
                        Column(children: [
                          Row(
                            children: const [
                              Padding(padding: EdgeInsets.only(left: 30)),
                              Text('Current City',
                                style: TextStyle(
                                color: Colors.black,
                                fontSize: 11)),
                              const Padding(padding: EdgeInsets.only(top: 30),)
                            ],
                          ),
                        ],)
                      ],)
                    ],),
                  ],
                ),),]),
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
  Widget input({label, icon, onchange, obscureText = false, validator}) {
    return Container(
      height: 38,
      padding: const EdgeInsets.only(top: 10),
      child: PrimaryInput(
        validator: (val) async {
          validator(val);
        },
        obscureText: obscureText,
        onChange: (val) async {
          onchange(val);
        },
        icon: icon,
        label: label,
      ),
    );
  }
}
