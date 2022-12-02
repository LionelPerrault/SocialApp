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
        sendFriends = [],
        isFriendRequest = {},
        isConfirmRequest = {},
        allFriendsList = [],
        super(state);
  static PeopleController? _this;
  List userList;
  List allFriendsList;
  int pageIndex;
  String ind = '';
  bool isShowProgressive;
  List requestFriends;
  List sendFriends;
  Map isFriendRequest = {};
  Map isConfirmRequest;
  var userInfo = UserManager.userInfo;
  var addIndex = 0;
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
    await getReceiveRequests();
    await getSendRequests();
    await getList();
  }

  getList() async {
    var snapshot = await FirebaseFirestore.instance
        .collection(Helper.userField)
        .limit(5 * pageIndex + addIndex)
        .get();
    var snapshot1 = await FirebaseFirestore.instance
        .collection(Helper.userField)
        .where('userName', isNotEqualTo: UserManager.userInfo['userName'])
        .get();
    var snapshot2 = await FirebaseFirestore.instance
        .collection(Helper.friendField)
        .where('state', isEqualTo: 1)
        .get();
    allFriendsList = snapshot2.docs;
    userList = snapshot.docs
        .where((element) =>
            element['userName'] != UserManager.userInfo['userName'])
        .toList();

    var allUserList = getFilterList(snapshot1.docs);
    var arr = getFilterList(userList);
    if (arr.length < 5 * pageIndex && arr.length != allUserList.length) {
      addIndex += 5 * pageIndex - arr.length as int;
      await getUserList();
    } else if (arr.length == 5 * pageIndex ||
        arr.length == allUserList.length) {
      print(arr.length);
      addIndex = 0;
      userList = arr;
      setState(() {});
    }
  }

  getFilterList(list) {
    var arr = [];
    for (int i = 0; i < list.length; i++) {
      var f = 0;
      for (int j = 0; j < allFriendsList.length; j++) {
        if (allFriendsList[j]['users'].contains(list[i]['userName']) &&
            allFriendsList[j]['users'].contains(userInfo['userName'])) {
          f = 1;
        }
      }
      for (int j = 0; j < requestFriends.length; j++) {
        if (list[i]['userName'] == requestFriends[j]['requester']) {
          f = 1;
        }
      }
      for (int j = 0; j < sendFriends.length; j++) {
        if (list[i]['userName'] == sendFriends[j]['receiver']) {
          f = 1;
        }
      }

      if (f == 0) {
        arr.add(list[i]);
      }
    }
    var arr1 = [];
    return arr;
  }

  requestFriend(receiver, fullName, avatar) async {
    var snapshot = await FirebaseFirestore.instance
        .collection(Helper.friendField)
        .where('users', arrayContains: userInfo['userName'])
        .get();
    var t = 0;
    var user = [];
    snapshot.docs.forEach((element) {
      user = element['users'];
      if (element['users'].contains(receiver)) {
        t = 1;
      }
    });
    if (t == 1) {
      return;
    }
    setState(() {});
    FirebaseFirestore.instance.collection(Helper.friendField).add({
      'requester': userInfo['userName'],
      'receiver': receiver,
      receiver: {'name': fullName, 'avatar': avatar},
      userInfo['userName']: {
        'name': userInfo['fullName'],
        'avatar': userInfo['avatar']
      },
      'users': [userInfo['userName'], receiver],
      'state': 0
    }).then((value) async => {
          await getUserList(),
        });
  }

  getReceiveRequestsFriends() async {
    await getReceiveRequests();
    setState(() {});
  }

  getReceiveRequests() async {
    var snapshot = await FirebaseFirestore.instance
        .collection(Helper.friendField)
        .where('receiver', isEqualTo: userInfo['userName'])
        .get();
    var arr = [];
    snapshot.docs.forEach((element) {
      if (element['state'] == 0) {
        var j = {...element.data(), 'id': element.id};
        arr.add(j);
      }
    });
    requestFriends = arr;
  }

  getSendRequestsFriends() async {
    await getSendRequests();
    setState(() {});
  }

  getSendRequests() async {
    var snapshot = await FirebaseFirestore.instance
        .collection(Helper.friendField)
        .where('requester', isEqualTo: userInfo['userName'])
        .get();
    var arr = [];
    snapshot.docs.forEach((element) {
      if (element['state'] == 0) {
        var j = {...element.data(), 'id': element.id};
        arr.add(j);
      }
    });
    sendFriends = arr;
  }

  confirmFriend(id, key) async {
    await FirebaseFirestore.instance
        .collection(Helper.friendField)
        .doc(id)
        .update({'state': 1});
    await getReceiveRequestsFriends();
  }

  deleteFriend(id) async {
    await FirebaseFirestore.instance
        .collection(Helper.friendField)
        .doc(id)
        .delete();
    setState(() {});
  }
}
