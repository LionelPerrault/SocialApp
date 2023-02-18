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

enum EmailType { statusFriendRequestSent, statusFriendsNow }
/*firebase data base structure looks like this.
{
	'user1id':{
		avatar:"avatar url",
		name:"user name",
	},
	'user2id':{
		avatar:"avatar url",
		name:"user name",
	},
	'receiver':"user1id or user2id who received',
	'requester':"user1id or ueer2id who sent',
	'state': "status of friend request" 0:statusFriendRequestSent, 1:statusFriendsNow
	'users': [ user1id, user2id] // used for search
}
*/

class PeopleController extends ControllerMVC {
  factory PeopleController([StateMVC? state]) =>
      _this ??= PeopleController._(state);
  PeopleController._(StateMVC? state)
      : userList = [],
        pageIndex = 1,
        isShowProgressive = false,
        requestFriends = [],
        allRequestFriends = [],
        sendFriends = [],
        isFriendRequest = {},
        isConfirmRequest = {},
        allFriendsList = [],
        tabName = 'Discover',
        allUserList = [],
        allSendFriends = [],
        isGetList = false,
        isSearch = false,
        isFirst = false,
        super(state);
  static PeopleController? _this;
  // array of my friends
  List friends = [];
  // discover user
  List<DocumentSnapshot> userList;
  // avoid bugs
  bool isLocked = false;
  List allFriendsList;
  int pageIndex;
  String ind = '';
  String tabName;
  bool isShowProgressive;
  List requestFriends;
  List allRequestFriends;
  List sendFriends;
  List allUserList;
  List allSendFriends;

  Map isFriendRequest = {};
  Map isConfirmRequest;
  bool isGetList;
  bool isSearch;
  bool isFirst;
  var userInfo = UserManager.userInfo;
  @override
  Future<bool> initAsync() async {
    return true;
  }

  // save the notifcation when friend request sent
  saveNotifications(addFriendsDocumentId) {
    var notificationData = {
      'postType': 'requestFriend',
      'postId': addFriendsDocumentId,
      'postAdminId': UserManager.userInfo['uid'],
      'notifyTime': DateTime.now().toString(),
      'tsNT': DateTime.now().millisecondsSinceEpoch,
      'userList': [],
      'timeStamp': FieldValue.serverTimestamp(),
    };
    FirebaseFirestore.instance
        .collection(Helper.notificationField)
        .add(notificationData);
  }

  logsData() {
    print("for test. user list length is #===========");
    print(userList.length);
  }

  // get my  friends in collection
  getFriends(name) async {
    var userInfo = UserManager.userInfo;
    var snapshot = await FirebaseFirestore.instance
        .collection(Helper.friendCollection)
        .where('state', isEqualTo: 1)
        .where('users', arrayContains: name)
        .get();
    var s = [];
    s = snapshot.docs.map((doc) => doc.data()).toList();
    friends = s;
  }

  // fetch all related data for Discover , Friend Rqeust, Send Reqeust.
  // all data will be saved in
  getUserList() async {
    if (isLocked) return;
    isLocked = true;
    await getReceiveRequests(userInfo['userName']);
    await getSendRequests(userInfo['userName']);
    await getDiscoverList();
    isLocked = false;
  }

  // send friend request
  requestFriend(receiver, fullName, avatar, index) async {
    var snapshot = await FirebaseFirestore.instance
        .collection(Helper.friendCollection)
        .where('users', arrayContains: userInfo['userName'])
        .where('users', arrayContains: receiver)
        .get();
    if (snapshot.docs.length > 0) {
      return;
    }
    setState(() {});
    Map<String, dynamic> notificationData;
    await FirebaseFirestore.instance.collection(Helper.friendCollection).add({
      'requester': userInfo['userName'],
      'receiver': receiver,
      receiver: {'name': fullName, 'avatar': avatar},
      userInfo['userName']: {
        'name': userInfo['fullName'],
        'avatar': userInfo['avatar']
      },
      'users': {userInfo['userName']: true, receiver: true},
      'state': 0
    }).then((value) async => {
          saveNotifications(value.id),
        });
    Helper.showToast('Sent request');
    return "Sent request";
  }

  getDiscoverList() async {
    //print(
    //    "========================================================================call");
    int pagination = pageIndex;
    if (userList.length > pagination * 5) return;
    var lastData = null;
    if (userList.length > 0) lastData = userList[userList.length - 1];

    while (userList.length <= pagination * 5) {
      var snapshot = null;
      if (lastData == null)
        snapshot = await FirebaseFirestore.instance
            .collection(Helper.userField)
            .orderBy('userName')
            .where('userName', isNotEqualTo: UserManager.userInfo['userName'])
            .limit(20)
            .get();
      else
        snapshot = await FirebaseFirestore.instance
            .collection(Helper.userField)
            .orderBy('userName')
            .where('userName', isNotEqualTo: UserManager.userInfo['userName'])
            .startAfterDocument(lastData)
            .limit(20)
            .get();
      List<DocumentSnapshot> newDocumentList = snapshot.docs;
      for (var elem in newDocumentList) {
        //check if it is already friends now.
        Map data = elem.data() as Map;
        var userName = '';
        try {
          userName = data['userName'];
        } catch (e) {}
        var snapshotFriend = await FirebaseFirestore.instance
            .collection(Helper.friendCollection)
            .where('users.' + UserManager.userInfo['userName'], isEqualTo: true)
            .where('users' + userName.toString(), isEqualTo: true)
            //.where('state', isEqualTo: 1)
            .get();
        var dataLength = snapshotFriend.docs.length;
        if (snapshotFriend.docs.length == 0) {
          print(elem);
          userList.add(elem);
        }
      }
      lastData = newDocumentList[newDocumentList.length - 1];
    }
    isGetList = true;
    setState(() {});
  }

  getReceiveRequestsFriends() async {
    await getReceiveRequests(userInfo['userName']);
    setState(() {});
  }

  getReceiveRequests(name) async {
    var snapshot = await FirebaseFirestore.instance
        .collection(Helper.friendCollection)
        .where('receiver', isEqualTo: name)
        .where('state', isEqualTo: 0)
        .get();

    var arr = [];
    arr = snapshot.docs.map((doc) => doc.data()).toList();
    allRequestFriends = arr;
    requestFriends = arr;
  }

  getSendRequestsFriends() async {
    await getSendRequests(userInfo['userName']);
    setState(() {});
  }

  getSendRequests(name) async {
    var snapshot = await FirebaseFirestore.instance
        .collection(Helper.friendCollection)
        .where('requester', isEqualTo: name)
        .where('state', isEqualTo: 0)
        .get();
    var arr = [];
    arr = snapshot.docs.map((doc) => doc.data()).toList();
    allSendFriends = arr;
    sendFriends = arr;
  }

  confirmFriend(id, key) async {
    await FirebaseFirestore.instance
        .collection(Helper.friendCollection)
        .doc(id)
        .update({'state': 1});
    await getReceiveRequestsFriends();
  }

  deleteFriend(id) async {
    await FirebaseFirestore.instance
        .collection(Helper.friendCollection)
        .doc(id)
        .delete();
    await getReceiveRequestsFriends();
  }

  cancelFriend(name) async {
    await FirebaseFirestore.instance
        .collection(Helper.friendCollection)
        .where('users', arrayContains: userInfo['userName'])
        .get()
        .then((value) => {
              FirebaseFirestore.instance
                  .collection(Helper.friendCollection)
                  .doc(value.docs
                      .where((element) => element['users'].contains(name))
                      .toList()[0]
                      .id)
                  .delete(),
            });
  }

  Future<int> getRelation(name, friendName) async {
    var getDocs = await FirebaseFirestore.instance
        .collection(Helper.friendCollection)
        .where('users', arrayContains: name)
        .get();
    var getData = getDocs.docs
        .where((element) => element['users'].contains(friendName))
        .toList();
    if (getData.isEmpty) {
      return 0;
    } else if (getDocs.docs[0]['state'] == 0) {
      return 1;
    } else {
      return 2;
    }
  }

  fieldSearch(Map search) async {
    /*
    var arr = [];
    var arr1 = [];
    print(search);

    var t = 0;
    if (tabName == 'Discover') {
      search.forEach((key, value) {
        if (value != '') {
          t = 1;
        }
        allUserList.forEach((element) {
          element.data().forEach((key1, value1) {
            if (key1 == 'sex') {
              // print(element['sex']);
            }
            if (key == key1 && value == value1) {
              arr1.add(element);
            }
          });
        });
      });
      if (t == 0) {
        await getDiscoverList();
        isSearch = false;
        return;
      } else {
        isSearch = true;
      }
      userList = arr1;
    } else if (tabName == 'Friend Requests') {
      var c = [];
      var snapshot =
          await FirebaseFirestore.instance.collection(Helper.userField).get();
      allRequestFriends.forEach((element) {
        var a = element['users']
            .where((e) => e != userInfo['userName'])
            .toList()[0];
        snapshot.docs.forEach((e) {
          if (e['userName'] == a) {
            search.forEach((key, value) {
              if (value != '') {
                t = 1;
              }
              e.data().forEach((key1, value1) {
                if (key == key1 && value == value1) {
                  arr1.add(element);
                }
              });
            });
          }
        });
      });
      arr = c;
      if (t == 0) {
        await getReceiveRequestsFriends();
        isSearch = false;
        return;
      } else {
        isSearch = true;
      }
      requestFriends = arr1;
    } else {
      var c = [];
      var snapshot =
          await FirebaseFirestore.instance.collection(Helper.userField).get();
      allSendFriends.forEach((element) {
        var a = element['users']
            .where((e) => e != userInfo['userName'])
            .toList()[0];
        snapshot.docs.forEach((e) {
          if (e['userName'] == a) {
            search.forEach((key, value) {
              if (value != '') {
                t = 1;
              }
              e.data().forEach((key1, value1) {
                if (key == key1 && value == value1) {
                  arr1.add(element);
                }
              });
            });
          }
        });
      });
      arr = c;
      if (t == 0) {
        await getSendRequests(userInfo['userName']);
        isSearch = false;
        return;
      } else {
        isSearch = true;
      }
      sendFriends = arr1;
    }
    */
    setState(() {});
  }
}
