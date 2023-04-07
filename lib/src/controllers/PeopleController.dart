import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../firebase_options.dart';
import '../helpers/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../managers/user_manager.dart';
import '../models/chatModel.dart';
import 'package:path/path.dart' as PPath;
import 'dart:io' show File, Platform;

import '../models/sendBadgeModel.dart';
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

final FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<List> findSimilarUsers(String myUserId) async {
  // Get my user document from Firebase
  print(myUserId);

  final DocumentSnapshot myUserDoc =
      await firestore.collection(Helper.userField).doc(myUserId).get();

  final List<dynamic> myInterestIds = myUserDoc['interests'];

  // Get all other user documents from Firebase
  final QuerySnapshot allUsersQuery =
      await firestore.collection(Helper.userField).get();

  final List<DocumentSnapshot> allUsersDocs = allUsersQuery.docs;

  // Calculate similarity scores for each user and store them in a map
  final Map<String, int> similarityScores = {};
  List<Map> potentialMatches = [];
  for (final DocumentSnapshot userDoc in allUsersDocs) {
    final String userId = userDoc.id;
    final String userName = userDoc['userName'];
    if (userId == myUserId) {
      continue; // Skip my own user document
    }

    print("userId is $userId");

    if (!(userDoc.data() as Map<String, dynamic>).containsKey('interests')) {
      continue;
    }
    final List<dynamic> userInterestIds = userDoc['interests'];
    print("userInterestIds is $userInterestIds");
    int count = 0;
    for (final dynamic myInterestId in myInterestIds) {
      if (myInterestId == null) continue;
      // final QueryDocumentSnapshot<Map<String, dynamic>> myInterest =
      //     await _getInterestById(
      //         myInterestId); // Helper method to get interest Map by ID
      // if (myInterest == null) {
      //   continue; // Skip invalid interests
      // }

      // print("myInterest is $myInterest");
      if (userInterestIds.contains(myInterestId)) {
        print("friend suggested userId is $userId");
        count++;
      }
    }

    potentialMatches.add({'doc': userDoc, 'count': count});
  }
  potentialMatches.sort((a, b) => b['count'] - a['count']);

  // // Sort user documents by descending similarity score
  // final List<DocumentSnapshot> similarUsersDocs = allUsersDocs
  //     .where((userDoc) => similarityScores[userDoc.id]! > 0)
  //     .toList();
  // similarUsersDocs.sort(
  //     (a, b) => similarityScores[b.id]!.compareTo(similarityScores[a.id]!));

  // print("similarUserDocs----$similarUsersDocs");
  return potentialMatches;
}

Future<QueryDocumentSnapshot<Map<String, dynamic>>> _getInterestById(
    dynamic interestId) async {
  print("myinterest id is $interestId");
  final QuerySnapshot<Map<String, dynamic>> interestDoc = await firestore
      .collection(Helper.interestsField)
      .where('id', isEqualTo: interestId.toString())
      .get();
  print("interestDoc id is $interestDoc");
  List<QueryDocumentSnapshot<Map<String, dynamic>>> interest = interestDoc.docs;
  var returnvalue = null;
  if (interest.isNotEmpty) {
    returnvalue = interest[0];
  }
  return returnvalue;
}

class PeopleController extends ControllerMVC {
  factory PeopleController([StateMVC? state]) =>
      _this ??= PeopleController._(state);
  PeopleController._(StateMVC? state)
      : userList = [],
        pageIndex = 1,
        requestFriends = [],
        sendFriends = [],
        notifiers = [],
        super(state);
  static PeopleController? _this;
  // array of my friends
  List friends = [];
  // discover user
  List userList;

  var lastData = null;

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
  var searchQuery = null;

  BadgeModel sendBadge = BadgeModel();

  //fix bugs on people screen
  List<mvc.StateMVC> notifiers;

  String tabName = 'Discover';
  @override
  Future<bool> initAsync() async {
    listenReceiveRequests();
    //listenSendRequests();
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

  logsData() {}

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

    var query = FirebaseFirestore.instance
        .collection(Helper.userField)
        .orderBy('userName')
        .where('userName', isNotEqualTo: UserManager.userInfo['userName']);

    await getDiscoverList(isSearch ? searchQuery : query);

    isLocked = false;
    setState(() {});
  }

  getFriendSubstituteList() async {
    List friendids = await findSimilarUsers(UserManager.userInfo['uid']);
  }

  getAllUserList() async {
    if (isLocked) return;
    isLocked = true;
    //await getReceiveRequests(userInfo['userName']);
    var query = FirebaseFirestore.instance
        .collection(Helper.userField)
        .orderBy('userName')
        .where('userName', isNotEqualTo: UserManager.userInfo['userName']);

    //await getDiscoverList(query);
    isLocked = false;
    setState(() {});
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
    var fieldName2 = 'users.$receiver';
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
    sendBadge.increaseBadge();
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
    sendBadge.updateBadge(sendFriends.length);
    setState(() {});
  }

  // getDiscoverList(Query<Map<String, dynamic>> query) async {
  //   try {
  //     int pagination = pageIndex;
  //     if (userList.length > pagination * 5) {
  //       isLocked = false;
  //       return;
  //     }
  //     isGetList = false;

  //     //if (userList.length > 0) lastData = userList[userList.length - 1];

  //     while (userList.length <= pagination * 5) {
  //       var snapshot = null;
  //       if (lastData == null)
  //         snapshot = await query.limit(20).get();
  //       else
  //         snapshot = await query.startAfterDocument(lastData).limit(20).get();
  //       // get friends list and make hash;
  //       var snapshotFriend = await FirebaseFirestore.instance
  //           .collection(Helper.friendCollection)
  //           .where('users.' + UserManager.userInfo['userName'], isEqualTo: true)
  //           //.where('state', isEqualTo: 1)
  //           .get();
  //       List friends = snapshotFriend.docs.map((doc) {
  //         Map data = doc.data() as Map;
  //         data['id'] = doc.id;
  //         return data;
  //       }).toList();

  //       List<DocumentSnapshot> newDocumentList = snapshot.docs;
  //       for (var elem in newDocumentList) {
  //         //check if it is already friends now.
  //         Map data = elem.data() as Map;
  //         var userName = '';
  //         try {
  //           userName = data['userName'];
  //         } catch (e) {}
  //         Iterable value = friends.where((element) {
  //           Map m = element as Map;
  //           return m['users'][userName] == true;
  //         });
  //         if (value.isEmpty) {
  //           Map data = elem.data() as Map;

  //           //  if (friendids.contains(data['userName'])) {
  //           //    userList = [elem.data(), ...userList];
  //           //    print("datausername is ${data['userName']}");
  //           //    setState(() {});
  //           //  } else {
  //           userList.add(elem.data());
  //           //   }
  //         }
  //       }
  //       lastData = newDocumentList[newDocumentList.length - 1];
  //     }
  //     isGetList = true;
  //     setState(() {});
  //   } catch (exception) {
  //     isGetList = true;
  //     isLocked = false;
  //     setState(() {});
  //   }
  // }

  getDiscoverList(Query<Map<String, dynamic>> query) async {
    try {
      // int pagination = pageIndex;
      // if (userList.length > pagination * 5) {
      //   isLocked = false;
      //   return;
      // }
      // isGetList = false;

      //if (userList.length > 0) lastData = userList[userList.length - 1];

      // while (userList.length <= pagination * 5) {
      // var snapshot = null;
      // if (lastData == null) {
      //   snapshot = await query.limit(20).get();
      // } else {
      //   snapshot = await query.startAfterDocument(lastData).limit(20).get();
      // }

      print("this is ");
      QuerySnapshot snapshotFriend = await FirebaseFirestore.instance
          .collection(Helper.friendCollection)
          .where('users.${UserManager.userInfo['userName']}', isEqualTo: true)
          .get();
      print("username is ${UserManager.userInfo['userName']}");
      List friends = snapshotFriend.docs.map((doc) {
        Map data = doc.data() as Map;
        data['id'] = doc.id;
        return data;
      }).toList();

      //List<DocumentSnapshot> newDocumentList = snapshot.docs;

      List maplist = await findSimilarUsers(UserManager.userInfo['uid']);
      print("maplist is $maplist");
      List newDocumentList = [];
      for (var elem in maplist) {
        newDocumentList.add(elem['doc']);
      }

      print("newDocumentList is $newDocumentList");
      for (var elem in newDocumentList) {
        Map data = elem.data() as Map;
        var userName = '';
        try {
          userName = data['userName'];
        } catch (e) {}
        Iterable value = friends.where((element) {
          Map m = element as Map;
          return m['users'][userName] == true;
        });
        if (value.isEmpty) {
          userList.add(data);
        }
      }

      print("userList is $userList");
      // Set the lastData variable to the last user in the user list.
      lastData = newDocumentList[newDocumentList.length - 1];
      //  }
      isGetList = true;
      setState(() {});
    } catch (exception) {
      isGetList = true;
      isLocked = false;
      setState(() {});
    }
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
    sendBadge.decreaseBadge();
    setState(() {});
  }

  cancelFriendDirectlyMap(Map mapData) async {
    var receiver = mapData['userName'];
    var snapshot = await FirebaseFirestore.instance
        .collection(Helper.friendCollection)
        // ignore: prefer_interpolation_to_compose_strings
        .where('users.' + UserManager.userInfo['userName'], isEqualTo: true)
        .where('users.$receiver', isEqualTo: true)
        .get();
    int len = snapshot.docs.length;
    for (int i = 0; i < len; i++) {
      var id = snapshot.docs[i].id;
      FirebaseFirestore.instance
          .collection(Helper.friendCollection)
          .doc(id)
          .delete();
    }
    sendBadge.decreaseBadge();
    await mapData.remove('state');
    setState(() {});
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

  fieldSearch(Map search) async {
    var query = FirebaseFirestore.instance
        .collection(Helper.userField)
        .orderBy('userName')
        .where('userName', isNotEqualTo: UserManager.userInfo['userName']);
    //if (search['keyword'] != null) {
    //  query = query.where('userName', isGreaterThan: search['keyword']);
    //  query = query.where('userName', isLessThan: search['keyword'] + 'z');
    //}
    if (search['userName'] != null) {
      query = query.where('userName', isGreaterThan: search['userName']);
      query = query.where('userName', isLessThan: search['userName'] + 'z');
    }
    if (search['sex'] != null) {
      query = query.where('sex', isEqualTo: search['sex']);
    }
    // if (search['sex'] != null) {
    //   query = query.where('sex', isEqualTo: search['sex']);
    // }
    if (search['relationship'] != null) {
      query = query.where('relationship', isEqualTo: search['relationship']);
    }

    pageIndex = 1;
    lastData = null;
    userList = [];
    isSearch = true;
    isGetList = false;
    searchQuery = query;
    tabName = 'Discover';
    getDiscoverList(query);
  }

  resetSearch() {
    pageIndex = 1;
    lastData = null;
    userList = [];
    isSearch = false;
    isGetList = false;
  }
}
