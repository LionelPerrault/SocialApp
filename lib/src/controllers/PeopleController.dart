// ignore_for_file: unused_local_variable

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../firebase_options.dart';
import '../helpers/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../managers/user_manager.dart';
import '../models/chatModel.dart';
import 'package:path/path.dart' as PPath;
import 'dart:io' show File, Platform;

import '../models/userModel.dart';

enum EmailType { emailVerify, googleVerify }

class PeopleController extends ControllerMVC {
  factory PeopleController([StateMVC? state]) =>
      _this ??= PeopleController._(state);
  PeopleController._(StateMVC? state)
      : userList = [],
        pageIndex = 1,
        isShowProgressive = false,
        isFriendRequest = {},
        super(state);
  static PeopleController? _this;
  List userList;
  int pageIndex;
  bool isShowProgressive;
  Map isFriendRequest = {};
  var userInfo = UserManager.userInfo;
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

  getUserList() async {
    var snapshot = await FirebaseFirestore.instance
        .collection(Helper.userField)
        .limit(5 * pageIndex)
        .get();
    userList = snapshot.docs
        .where((element) =>
            element['userName'] != UserManager.userInfo['userName'])
        .toList();
    setState(() {});
  }

  requestFriend(receiver, fullName, index) async {
    isFriendRequest[index] = true;
    setState(() {});
    FirebaseFirestore.instance.collection(Helper.friendField).add({
      'requester': userInfo['userName'],
      'receiver': receiver,
      receiver: fullName,
      userInfo['userName']: userInfo['fullName'],
      'state': 0
    }).then((value) => {isFriendRequest[index] = false, setState(() {})});
  }

  getReceiveRequests() async {
    FirebaseFirestore.instance
        .collection(Helper.friendField)
        .where('receiver', isEqualTo: userInfo['userName'])
        .get();
  }
}
