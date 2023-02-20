import 'dart:async';

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
        requestFriends = [],
        sendFriends = [],
        super(state);
  static PeopleController? _this;
  // array of my friends
  List friends = [];
  // discover user
  List userList;
  // avoid bugs
  bool isLocked = false;
  bool isListenAlready = false;

  // page of discover index
  int pageIndex;
  //
  bool isGetList = false;
  // list for what you received request friends
  List requestFriends;
  // list for waht you sent request
  List sendFriends;

  late StreamSubscription subscription;
  //is Searching state or discover
  bool isSearch = false;
  @override
  Future<bool> initAsync() async {
    listenReceiveRequests();
    //listenSendRequests();
    return true;
  }

  void listenData() {
    if (isListenAlready) return;
    isListenAlready = true;
    listenReceiveRequests();
    //listenSendRequests();
  }

  void disposeAll() {
    userList = [];
    pageIndex = 1;
    requestFriends = [];
    sendFriends = [];
    friends = [];
    //subscription.cancel();
    isListenAlready = false;
    isLocked = false;
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
    name = userInfo['userName'];
    var snapshot = await FirebaseFirestore.instance
        .collection(Helper.friendCollection)
        .where('state', isEqualTo: 1)
        .where('users.' + name, isEqualTo: true)
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
    //await getReceiveRequests(userInfo['userName']);
    await getDiscoverList();
    isGetList = true;
    setState(() {});
    isLocked = false;
  }

  requestFriendDirectlyMap(Map mapData) async {
    var receiver = mapData['userName'];
    var fullName = '${mapData['firstName']} ${mapData['lastName']}';
    var avatar = mapData['avatar'];
    await requestFriendAsData(receiver, fullName, avatar, mapData: mapData);
  }

  // send friend request
  requestFriend(Map data) async {
    var mapData = data;
    await requestFriendDirectlyMap(mapData);
  }

  requestFriendAsData(String receiver, String fullName, String avatar,
      {dynamic mapData}) async {
    var fieldName1 = 'users.' + UserManager.userInfo['userName'];
    var fieldName2 = 'users.' + receiver;
    var docId = '';
    var snapshot = await FirebaseFirestore.instance
        .collection(Helper.friendCollection)
        .where(fieldName1, isEqualTo: true)
        .where(fieldName2, isEqualTo: true)
        .get();
    if (snapshot.docs.length > 0) {
      if (mapData != null) mapData['state'] = 0;
      return;
    }
    Map<String, dynamic> notificationData;
    await FirebaseFirestore.instance.collection(Helper.friendCollection).add({
      'requester': UserManager.userInfo['userName'],
      'receiver': receiver,
      receiver: {'name': fullName, 'avatar': avatar},
      UserManager.userInfo['userName']: {
        'name': UserManager.userInfo['fullName'],
        'avatar': UserManager.userInfo['avatar']
      },
      'users': {UserManager.userInfo['userName']: true, receiver: true},
      'state': 0
    }).then((value) async => {
          if (mapData != null) mapData['state'] = 0,
          saveNotifications(value.id),
          docId = value.id
        });
    Helper.showToast('Sent request');
    setState(() {});

    return docId;
  }

  getSendRequest() async {
    var snapshots = await FirebaseFirestore.instance
        .collection(Helper.friendCollection)
        .where('requester', isEqualTo: UserManager.userInfo['userName'])
        .where('state', isEqualTo: 0)
        .get();

    sendFriends = snapshots.docs.map((doc) {
      Map data = doc.data() as Map;
      data['id'] = doc.id;
      return data;
    }).toList();
    setState(() {});
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
            .where('users.' + userName, isEqualTo: true)
            //.where('state', isEqualTo: 1)
            .get();
        var dataLength = snapshotFriend.docs.length;
        if (snapshotFriend.docs.length == 0) {
          print(elem);
          userList.add(elem.data());
        }
      }
      lastData = newDocumentList[newDocumentList.length - 1];
    }

    setState(() {
      isGetList = true;
    });
  }

  listenReceiveRequests() async {
    var userName = UserManager.userInfo['userName'];
    final Stream<QuerySnapshot> friendStream = FirebaseFirestore.instance
        .collection(Helper.friendCollection)
        .where('receiver', isEqualTo: userName)
        .where('state', isEqualTo: 0)
        .snapshots();
    subscription = friendStream.listen((event) {
      requestFriends = event.docs.map((doc) {
        Map data = doc.data() as Map;
        data['id'] = doc.id;
        return data;
      }).toList();
      setState(() {});
    });
  }

  /*listenSendRequests() async {
    listenSendRequestsWithName(userInfo['userName']);
  }

  listenSendRequestsWithName(String name) async {
    final Stream<QuerySnapshot> friendStrem = FirebaseFirestore.instance
        .collection(Helper.friendCollection)
        .where('requester', isEqualTo: name)
        .where('state', isEqualTo: 0)
        .snapshots();
    friendStrem.listen((event) {
      sendFriends = event.docs.map((doc) {
        Map data = doc.data() as Map;
        data['id'] = doc.id;
        return data;
      }).toList();
      setState(() {});
    });
  }
  */

  confirmFriend(id) async {
    await FirebaseFirestore.instance
        .collection(Helper.friendCollection)
        .doc(id)
        .update({'state': 1});
  }

  rejectFriend(id) async {
    await FirebaseFirestore.instance
        .collection(Helper.friendCollection)
        .doc(id)
        .delete();
  }

  cancelFriendDirectlyMap(Map mapData) async {
    var receiver = mapData['userName'];
    var snapshot = await FirebaseFirestore.instance
        .collection(Helper.friendCollection)
        .where('users.' + UserManager.userInfo['userName'], isEqualTo: true)
        .where('users.' + receiver.toString(), isEqualTo: true)
        .get();
    int len = snapshot.docs.length;
    for (int i = 0; i < len; i++) {
      var id = snapshot.docs[i].id;
      print('deletedata doc id is $id');
      FirebaseFirestore.instance
          .collection(Helper.friendCollection)
          .doc(id)
          .delete();
    }
    await mapData.remove('state');
  }

  cancelFriend(Map data) async {
    var mapData = data;
    await cancelFriendDirectlyMap(mapData);
  }

  Future<int> getRelation(name, friendName) async {
    var getDocs = await FirebaseFirestore.instance
        .collection(Helper.friendCollection)
        .where('users.' + name, isEqualTo: true)
        .where('users.' + friendName, isEqualTo: true)
        .get();

    if (getDocs.docs.isEmpty) {
      return -2;
    } else {
      return getDocs.docs[0]['state'];
    }
  }

  getUserListByUserName(String userName) async {
    var snapshot = await FirebaseFirestore.instance
        .collection(Helper.userField)
        .where('userName', isEqualTo: userName)
        .get();

    if (snapshot.docs.isNotEmpty) {
      userList = [];
      for (var elem in snapshot.docs) {
        userList.add(elem.data());
      }

      setState(() {});
    }
  }

  fieldSearch(Map search) async {
    if (search['userName'] != null) {
      await getUserListByUserName(search['userName']);
    } else {
      await getUserList();
    }
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
