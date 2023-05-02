// ignore_for_file: unused_local_variable

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import '../helpers/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/userModel.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

import 'package:flutter/material.dart';

enum EmailType { emailVerify, googleVerify }

class ProfileController extends ControllerMVC {
  factory ProfileController([StateMVC? state]) =>
      _this ??= ProfileController._(state);
  ProfileController._(StateMVC? state)
      : progress = 0,
        super(state);
  static ProfileController? _this;
  // ignore: non_constant_identifier_names
  String profile_cover = '';
  String viewProfileUserName = '';
  String viewProfileFullName = '';
  String viewProfileUid = '';
  String tab = 'Timeline';
  double progress;
  List<mvc.StateMVC> notifiers = [];
  var resData = {};
  var userInfo = {};
  Map cachedData = {};
  // ignore: prefer_typing_uninitialized_variables
  var responseData;
  Map<String, dynamic> userData = {};
  var signUpUserInfo = {};
  bool isGetData = false;
  @override
  Future<bool> initAsync() async {
    //
    Helper.authdata = FirebaseFirestore.instance
        .collection(Helper.userField)
        .withConverter<TokenLogin>(
          fromFirestore: (snapshots, _) =>
              TokenLogin.fromJSON(snapshots.data()!),
          toFirestore: (tokenlogin, _) => tokenlogin.toMap(),
        );
    return true;
  }

  //fix bugs of unknown
  void addNotifyCallBack(mvc.StateMVC notifi) {
    notifiers.add(notifi);
  }

  //fix bugs of unknown

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    for (int i = 0; i < notifiers.length; i++) {
      mvc.StateMVC notifi = notifiers[i];
      notifi.setState(() {});
    }
  }

  updateProfile(userName) {
    tab = 'Timeline';
    var userInfo = UserManager.userInfo;

    viewProfileUserName = userName;
    if (viewProfileUserName == '') {
      viewProfileUserName = userInfo['userName'];
    }
    ProfileController().isGetData = true;
    setState(() {});
    getProfileInfo();
  }

  //get user profile info
  Future<bool> getProfileInfo() async {
    bool getFlag = false;
    isGetData = false;
    await FirebaseFirestore.instance
        .collection(Helper.userField)
        .where('userName', isEqualTo: viewProfileUserName)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        viewProfileFullName =
            '${value.docs[0].data()['firstName']} ${value.docs[0].data()['lastName']}';
        viewProfileUid = value.docs[0].id;
        userData = value.docs[0].data();
        profile_cover = userData['profile_cover'] ?? '';
        setState(() {});
      } else {
        viewProfileFullName = "UserNotExits!~";
        viewProfileUid = 'none';
        userData = {};
        profile_cover = '';
        setState(() {});
      }
      isGetData = true;
      getFlag = true;
    });
    return getFlag;
  }

  //get user user info using uid
  Future<Map<String, dynamic>?> getUserInfo(uid) async {
    if (cachedData.containsKey(uid)) {
      return cachedData[uid];
    }
    var getShot = await FirebaseFirestore.instance
        .collection(Helper.userField)
        .doc(uid)
        .get();
    var getUser = getShot.data();
    cachedData[uid] = getUser;
    return getUser;
  }
}
