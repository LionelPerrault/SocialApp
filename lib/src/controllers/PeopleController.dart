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
        requestFriends = [],
        isFriendRequest = {},
        isConfirmRequest = {},
        super(state);
  static PeopleController? _this;
  List userList;
  int pageIndex;
  bool isShowProgressive;
  List requestFriends;
  Map isFriendRequest = {};
  Map isConfirmRequest;
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

  requestFriend(receiver, fullName, avatar, index) async {
    var snapshot = await FirebaseFirestore.instance.collection(Helper.friendField)
      .where('users', arrayContains: userInfo['userName']).get();
    var t = 0;
    var user = [];
    snapshot.docs.forEach((element) {
      user = element['users'];
      if(element['users'].contains(receiver)){
        t = 1;
      }
    });
    print(t);
    if(t == 1){
      return;
    }
    isFriendRequest[index] = true;
    setState(() {});
    FirebaseFirestore.instance.collection(Helper.friendField).add({
      'requester': userInfo['userName'],
      'receiver': receiver,
      receiver: {'name':fullName,'avatar':avatar},
      userInfo['userName']: {'name':userInfo['fullName'],'avatar':userInfo['avatar']},
      'users':[userInfo['userName'], receiver],
      'state': 0
    }).then((value) => {isFriendRequest[index] = false, setState(() {})});
  }

  getReceiveRequests() async {
    var snapshot = await FirebaseFirestore.instance
        .collection(Helper.friendField)
        .where('receiver', isEqualTo: userInfo['userName'])
        .get();
    var arr = [];
    snapshot.docs.forEach((element) {
        var j = {...element.data(),'id': element.id};
        arr.add(j);
    });
    requestFriends = arr;
    setState(() { });
  }
  confirmFriend(id,key) async {
    await FirebaseFirestore.instance.collection(Helper.friendField).doc(id)
            .update({
              'state': 1 
            });
    await getReceiveRequests();
    
  }
  deleteFriend(id) async {
    await FirebaseFirestore.instance.collection(Helper.friendField).doc(id)
          .update({
            'state': 0 
          });
    await getReceiveRequests();
    setState(() { });
  }
}
