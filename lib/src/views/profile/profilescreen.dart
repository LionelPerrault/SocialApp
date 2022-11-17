import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/FileManager.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/views/box/searchbox.dart';
import 'package:shnatter/src/views/chat/chatScreen.dart';
import 'package:shnatter/src/views/navigationbar.dart';
import 'package:shnatter/src/views/profile/profileAvatarandTabscreen.dart';
import 'package:shnatter/src/views/profile/profileEventsScreen.dart';
import 'package:shnatter/src/views/profile/profileFriendsScreen.dart';
import 'package:shnatter/src/views/profile/profileGroupsScreen.dart';
import 'package:shnatter/src/views/profile/profileLikesScreen.dart';
import 'package:shnatter/src/views/profile/profilePhotosScreen.dart';
import 'package:shnatter/src/views/profile/profileTimelineScreen.dart';
import 'package:shnatter/src/views/profile/profileVideosScreen.dart';
import '../../controllers/HomeController.dart';
import '../../utils/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as PPath;
import 'dart:io' show File, Platform;

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen({Key? key})
      : con = ProfileController(),
        super(key: key);
  final ProfileController con;

  @override
  State createState() => UserProfileScreenState();
}

class UserProfileScreenState extends mvc.StateMVC<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  bool showSearch = false;
  late FocusNode searchFocusNode;
  late FileController filecon;
  bool showMenu = false;
  late AnimationController _drawerSlideController;
  double progress = 0;
  //
  var userInfo = UserManager.userInfo;
  @override
  void initState() {
    add(widget.con);
    con = controller as ProfileController;
    filecon = FileController();
    con.profile_cover = UserManager.userInfo['profile_cover'] ?? '';
    setState(() { });
    super.initState();
    searchFocusNode = FocusNode();
    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  late ProfileController con;
  void onSearchBarFocus() {
    searchFocusNode.requestFocus();
    setState(() {
      showSearch = true;
    });
  }

  void clickMenu() {
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
            Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: SizeConfig.navbarHeight,left: 30,right: 30),
                  width: SizeConfig(context).screenWidth,
                  height: SizeConfig(context).screenHeight * 0.5,
                  decoration: con.profile_cover == '' ? const BoxDecoration(
                  color: Color.fromRGBO(66, 66, 66, 1),
                  ) : const BoxDecoration(),
                  child: con.profile_cover == '' ? Container() : Image.network(con.profile_cover,fit:BoxFit.cover),
                )
              ],
            ),
            ShnatterNavigation(
              searchController: searchController,
              onSearchBarFocus: onSearchBarFocus,
              onSearchBarDismiss: onSearchBarDismiss,
              drawClicked: clickMenu,
            ),
            Padding(
                padding: const EdgeInsets.only(top: SizeConfig.navbarHeight),
                child:
                    //AnimatedPositioned(
                    //top: showMenu ? 0 : -150.0,
                    //duration: const Duration(seconds: 2),
                    //curve: Curves.fastOutSlowIn,
                    //child:
                    SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileAvatarandTabScreen(onClick: (value) {
                          print(value);
                          con.tab = value;
                          setState(() { });
                        },),
                        con.tab == 'Timeline' ? ProfielTimelineScreen(onClick:(value){
                          con.tab = value;
                          setState(() { });
                        }) :
                        con.tab == 'Friends' ? ProfileFriendScreen(onClick:(value){
                          con.tab = value;
                          setState(() { });
                        }) :
                        con.tab == 'Photos' ? ProfilePhotosScreen(onClick:(value){
                          con.tab = value;
                          setState(() { });
                        }) :
                        con.tab == 'Videos' ? ProfileVideosScreen(onClick:(value){
                          con.tab = value;
                          setState(() { });
                        }) :
                        con.tab == 'Likes' ? ProfileLikesScreen(onClick:(value){
                          con.tab = value;
                          setState(() { });
                        }) :
                        con.tab == 'Groups' ? ProfileGroupsScreen(onClick:(value){
                          con.tab = value;
                          setState(() { });
                        }) :
                        ProfileEventsScreen()
                        // ProfileFriendScreen(),
                      ]),
                )),
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
                : const SizedBox(),
                Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(left: 50,top: SizeConfig.navbarHeight + 30),
                    child: GestureDetector(
                      onTap: () {
                        uploadImage();
                      },
                      child: const Icon(Icons.photo_camera,size: 25,),)
                  ),
            ChatScreen(),
            
          ],
        ));
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
            FirebaseFirestore.instance.collection(Helper.userField).doc(UserManager.userInfo['uid']).update({
                'profile_cover': downloadUrl
              }).then((e) async {
                  con.profile_cover = downloadUrl;
                  await Helper.saveJSONPreference(Helper.userField,
                    {...userInfo, 'profile_cover': downloadUrl});
              setState(() { });
            } );
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
