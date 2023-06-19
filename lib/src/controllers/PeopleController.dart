import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shnatter/src/controllers/PostController.dart';
import '../helpers/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../managers/user_manager.dart';

import '../models/sendBadgeModel.dart';

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

  final DocumentSnapshot myUserDoc =
      await firestore.collection(Helper.userField).doc(myUserId).get();

  final List<dynamic> myInterestIds = myUserDoc['interests'];

  // Get all other user documents from Firebase
  final QuerySnapshot allUsersQuery =
      await firestore.collection(Helper.userField).get();

  final List<DocumentSnapshot> allUsersDocs = allUsersQuery.docs;

  // Calculate similarity scores for each user and store them in a map
  List<Map> potentialMatches = [];
  for (final DocumentSnapshot userDoc in allUsersDocs) {
    final String userId = userDoc.id;
    if (userId == myUserId) {
      continue; // Skip my own user document
    }

    if (!(userDoc.data() as Map<String, dynamic>).containsKey('interests')) {
      continue;
    }
    final List<dynamic> userInterestIds = userDoc['interests'];

    int count = 0;
    for (final dynamic myInterestId in myInterestIds) {
      if (myInterestId == null) continue;

      if (userInterestIds.contains(myInterestId)) {
        count++;
      }
    }

    potentialMatches.add({'doc': userDoc, 'count': count});
  }
  potentialMatches.sort((a, b) => b['count'] - a['count']);

  return potentialMatches;
}

Future<QueryDocumentSnapshot<Map<String, dynamic>>> _getInterestById(
    dynamic interestId) async {
  final QueryDocumentSnapshot<Map<String, dynamic>> interestDoc =
      await firestore
          .collection(Helper.interestsField)
          .where('id', isEqualTo: interestId.toString())
          .limit(1)
          .get()
          .then((querySnapshot) => querySnapshot.docs[0]);
  return interestDoc;
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

  var lastData;

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
  var searchQuery;

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
  saveNotifications(addFriendsDocumentId) async {
    await PostController().getServerTime();
    var notificationData = {
      'postType': 'requestFriend',
      'postId': addFriendsDocumentId,
      'postAdminId': UserManager.userInfo['uid'],
      'notifyTime': DateTime.now().toString(),
      'tsNT': PostController().serverTimeStamp,
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
    var snapshot = await FirebaseFirestore.instance
        .collection(Helper.friendCollection)
        .where('users', arrayContains: UserManager.userInfo['uid'])
        .where('state', isEqualTo: true)
        .get();
    var allFriendsData = [];
    for (var i = 0; i < snapshot.docs.length; i++) {
      var friendUid = snapshot.docs[i].data()['users'];
      friendUid.removeWhere((item) => item == UserManager.userInfo['uid']);
      print(friendUid);
      var fData = Helper.userUidToInfo[friendUid[0]];
      fData['uid'] = friendUid[0];
      fData['fieldUid'] = snapshot.docs[i].id;
      fData['state'] = 1;
      allFriendsData.add(fData);
    }
    print('getfriend $allFriendsData');
    friends = allFriendsData;
    setState(() {});
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

    await getSuggestList(isSearch ? searchQuery : query);

    isLocked = false;
    setState(() {});
  }

  requestFriendDirectlyMap(Map mapData) async {
    var receiver = mapData['uid'];
    if (receiver == UserManager.userInfo['uid']) return;
    await requestFriendAsData(receiver, mapData: mapData);
  }

  // send friend request
  requestFriend(Map data) async {
    var mapData = data;
    await requestFriendDirectlyMap(mapData);
  }

  requestFriendAsData(String receiver, {dynamic mapData}) async {
    var docId = '';
    var snapshot = await FirebaseFirestore.instance
        .collection(Helper.friendCollection)
        .where('receiver', isEqualTo: UserManager.userInfo['uid'])
        .where('requester', isEqualTo: receiver)
        .get();
    if (snapshot.docs.isNotEmpty) {
      if (mapData != null) mapData['state'] = 0;
      return;
    }
    await FirebaseFirestore.instance.collection(Helper.friendCollection).add({
      'requester': UserManager.userInfo['uid'],
      'receiver': receiver,
      'users': [UserManager.userInfo['uid'], receiver],
      'state': false,
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
        .where('requester', isEqualTo: UserManager.userInfo['uid'])
        .where('state', isEqualTo: false)
        .get();

    sendFriends = snapshots.docs.map((doc) {
      var friendUid = doc.data()['receiver'];
      var fData = Helper.userUidToInfo[friendUid];
      fData['uid'] = friendUid;
      fData['fieldUid'] = doc.id;
      return fData;
    }).toList();
    print('sendfriends $sendFriends');
    sendBadge.updateBadge(sendFriends.length);
    setState(() {});
  }

  getDiscoverList(Query<Map<String, dynamic>> query) async {
    try {
      int pagination = pageIndex;
      if (userList.length > pagination * 5) {
        isLocked = false;
        return;
      }
      isGetList = false;

      //if (userList.length > 0) lastData = userList[userList.length - 1];

      while (userList.length <= pagination * 5) {
        QuerySnapshot<Map<String, dynamic>> snapshot;
        if (lastData == null) {
          snapshot = await query.limit(20).get();
        } else {
          snapshot = await query.startAfterDocument(lastData).limit(20).get();
        }
        // get friends list and make hash;
        var snapshotFriend = await FirebaseFirestore.instance
            .collection(Helper.friendCollection)
            .where('users.' + UserManager.userInfo['userName'], isEqualTo: true)
            //.where('state', isEqualTo: 1)
            .get();
        List friends = snapshotFriend.docs.map((doc) {
          Map data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();

        List<DocumentSnapshot> newDocumentList = snapshot.docs;
        for (var elem in newDocumentList) {
          //check if it is already friends now.
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
            //  if (friendids.contains(data['userName'])) {
            //    userList = [elem.data(), ...userList];
            //    print("datausername is ${data['userName']}");
            //    setState(() {});
            //  } else {
            userList.add(elem.data());
            //   }
          }
        }
        lastData = newDocumentList[newDocumentList.length - 1];
      }
      isGetList = true;
      setState(() {});
    } catch (exception) {
      isGetList = true;
      isLocked = false;
      setState(() {});
    }
  }

  getSuggestList(Query<Map<String, dynamic>> query) async {
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

      QuerySnapshot snapshotFriend = await FirebaseFirestore.instance
          .collection(Helper.friendCollection)
          .where('users', arrayContains: UserManager.userInfo['uid'])
          .get();

      List friends = snapshotFriend.docs.map((doc) {
        Map data = doc.data() as Map;
        data['id'] = doc.id;
        return data;
      }).toList();
      //List<DocumentSnapshot> newDocumentList = snapshot.docs;

      List maplist = await findSimilarUsers(UserManager.userInfo['uid']);

      List newDocumentList = [];
      for (var elem in maplist) {
        newDocumentList.add(elem['doc']);
      }
      var boxList = [];
      for (var elem in newDocumentList) {
        Map data = elem.data() as Map;
        data['uid'] = elem.id;
        var userUid = '';
        userUid = data['uid'];
        Iterable value = friends.where((element) {
          Map m = element as Map;
          return m['users'].contains(userUid) == true;
        });
        if (value.isEmpty) {
          boxList.add(data);
        }
      }
      userList = boxList;

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
    var uid = UserManager.userInfo['uid'];
    final Stream<QuerySnapshot> friendStream = FirebaseFirestore.instance
        .collection(Helper.friendCollection)
        .where('receiver', isEqualTo: uid)
        .where('state', isEqualTo: false)
        .snapshots();
    subscription = friendStream.listen((event) {
      requestFriends = event.docs.map((doc) {
        var friendUid = doc['requester'];
        var fData = Helper.userUidToInfo[friendUid];
        fData['uid'] = friendUid;
        fData['fieldUid'] = doc.id;
        return fData;
      }).toList();
      print('requestFriends$requestFriends');
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
        .update({'state': true});
    sendBadge.decreaseBadge();

    setState(() {});
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
    var receiver = mapData['uid'];
    var snapshot = await FirebaseFirestore.instance
        .collection(Helper.friendCollection)
        .where('users',
            arrayContainsAny: [receiver, UserManager.userInfo['uid']]).get();
    FirebaseFirestore.instance
        .collection(Helper.friendCollection)
        .doc(snapshot.docs[0].id)
        .delete();
    sendBadge.decreaseBadge();
    await mapData.remove('state');
    setState(() {});
  }

  cancelFriend(Map data) async {
    var mapData = data;
    await cancelFriendDirectlyMap(mapData);
  }

  Future<dynamic> getRelation(uid, friendUid) async {
    var getDocs = await FirebaseFirestore.instance
        .collection(Helper.friendCollection)
        .where('users', arrayContainsAny: [uid, friendUid]).get();

    if (getDocs.docs.isEmpty) {
      return null;
    } else {
      return getDocs.docs[0]['state'];
    }
  }

  fieldSearch(Map search) async {
    var query = FirebaseFirestore.instance
        .collection(Helper.userField)
        .orderBy('userName')
        .where('userName', isNotEqualTo: UserManager.userInfo['userName']);

    if (search['userName'] != null) {
      query = query.where('userName', isGreaterThan: search['userName']);
      query = query.where('userName', isLessThan: search['userName'] + 'z');
    }
    if (search['sex'] != null) {
      query = query.where('sex', isEqualTo: search['sex']);
    }

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
