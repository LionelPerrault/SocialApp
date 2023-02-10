// ignore_for_file: unused_local_variable

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shnatter/src/controllers/ProfileController.dart';
import '../helpers/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../managers/user_manager.dart';
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
  List userList;
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
  List friends = [];
  Map isFriendRequest = {};
  Map isConfirmRequest;
  bool isGetList;
  bool isSearch;
  bool isFirst;
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

  saveNotifications(data) async {
    await FirebaseFirestore.instance
        .collection(Helper.notificationField)
        .add(data);
  }

  requestFriend(receiver) async {
    setState(() {});
    Map<String, dynamic> notificationData;
    await FirebaseFirestore.instance.collection(Helper.friendField).add({
      'requester': userInfo['uid'],
      'receiver': receiver,
      'users': [userInfo['uid'], receiver],
      'state': 0
    }).then((value) async => {
          // await getUserList(index: index),
          notificationData = {
            'postType': 'requestFriend',
            'postId': value.id,
            'postAdminId': userInfo['uid'],
            'notifyTime': DateTime.now().toString(),
            'tsNT': DateTime.now().millisecondsSinceEpoch,
            'userList': [],
            'timeStamp': FieldValue.serverTimestamp(),
          },
          saveNotifications(notificationData),
        });
    Helper.showToast('Sent request');
    return "Sent request";
  }

  cancelRequest(receiver) async {
    try {
      await FirebaseFirestore.instance
          .collection(Helper.friendField)
          .where('requester', isEqualTo: userInfo['uid'])
          .where('receiver', isEqualTo: receiver)
          .get()
          .then((value) => {
                FirebaseFirestore.instance
                    .collection(Helper.friendField)
                    .doc(value.docs[0].id)
                    .delete(),
              });
      return true;
    } catch (e) {
      return false;
    }
  }

  cancelFriend(friend) async {
    try {
      await FirebaseFirestore.instance
          .collection(Helper.friendField)
          .where('users', arrayContains: friend)
          .where('users', arrayContains: userInfo['uid'])
          .get()
          .then((value) => {
                FirebaseFirestore.instance
                    .collection(Helper.friendField)
                    .doc(value.docs[0].id)
                    .delete(),
              });
      return true;
    } catch (e) {
      return false;
    }
  }

  confirmFriend(id) async {
    try {
      await FirebaseFirestore.instance
          .collection(Helper.friendField)
          .doc(id)
          .update({'state': 1});
      await getReceiveRequestsFriends();
      return true;
    } catch (e) {
      return false;
    }
  }

  getAllFriends(uid) async {
    var snapshot = await FirebaseFirestore.instance
        .collection(Helper.friendField)
        .where('state', isEqualTo: 1)
        .where('users', arrayContains: uid)
        .get();
    var allFriendUid = snapshot.docs;
    var allFriendsInfo = [];
    for (var i = 0; i < allFriendUid.length; i++) {
      var friendId =
          allFriendUid[i]['users'].where((user) => user != uid).toList()[0];
      var friendInfo = ProfileController().getUserInfo(friendId);
      allFriendsInfo.add(friendInfo);
    }

    friends = allFriendsInfo;
  }

  getUserList({index = -1, isGetOnly5 = false}) async {
    await getReceiveRequests(userInfo['uid']);
    await getSendRequests(userInfo['uid']);
    await getList(index: index, isGetOnly5: isGetOnly5);
  }

  getList({index = -1, isGetOnly5 = false, int add = 0}) async {
    int pagination = pageIndex;
    if (isGetOnly5) {
      pagination = 1;
    }
    var snapshot = await FirebaseFirestore.instance
        .collection(Helper.userField)
        .limit(5 * pagination + add)
        .get();
    var snapshot1 = await FirebaseFirestore.instance
        .collection(Helper.userField)
        .where('userName', isNotEqualTo: userInfo['userName'])
        .get();
    var snapshot2 = await FirebaseFirestore.instance
        .collection(Helper.friendField)
        .where('state', isEqualTo: 1)
        .get();
    allFriendsList = snapshot2.docs;
    var friends = snapshot.docs
        .where((element) => element['userName'] != userInfo['userName'])
        .toList();
    allUserList = getFilterList(snapshot1.docs);
    var arr = getFilterList(friends);
    print(arr.length);
    if (arr.length < 5 * pagination && arr.length != allUserList.length) {
      int addIndex = 0;
      addIndex += 5 * pagination - arr.length + add as int;
      await getList(index: index, isGetOnly5: isGetOnly5, add: addIndex);
    } else if (arr.length == 5 * pagination ||
        arr.length == allUserList.length) {
      print('---------');
      if (index != -1) {
        isFriendRequest[index] = false;
      }
      userList = arr;
      isGetList = true;
      setState(() {});
    }
  }

  getFilterList(list) {
    var arr = [];
    for (int i = 0; i < list.length; i++) {
      var f = 0;
      for (int j = 0; j < allFriendsList.length; j++) {
        if (allFriendsList[j]['users'].contains(list[i]['uid']) &&
            allFriendsList[j]['users'].contains(userInfo['uid'])) {
          f = 1;
        }
      }
      for (int j = 0; j < requestFriends.length; j++) {
        if (list[i]['uid'] == requestFriends[j]['requester']) {
          f = 1;
        }
      }
      for (int j = 0; j < sendFriends.length; j++) {
        if (list[i]['uid'] == sendFriends[j]['receiver']) {
          f = 1;
        }
      }

      if (f == 0) {
        arr.add(list[i]);
      }
    }
    return arr;
  }

  getReceiveRequestsFriends() async {
    await getReceiveRequests(userInfo['uid']);
    setState(() {});
  }

  getReceiveRequests(uid) async {
    var snapshot = await FirebaseFirestore.instance
        .collection(Helper.friendField)
        .where('receiver', isEqualTo: uid)
        .get();
    var arr = [];
    for (var element in snapshot.docs) {
      if (element['state'] == 0) {
        var j = {...element.data(), 'id': element.id};
        arr.add(j);
      }
    }
    allRequestFriends = arr;
    requestFriends = arr;
  }

  getSendRequestsFriends() async {
    await getSendRequests(userInfo['uid']);
    setState(() {});
  }

  getSendRequests(uid) async {
    var snapshot = await FirebaseFirestore.instance
        .collection(Helper.friendField)
        .where('requester', isEqualTo: uid)
        .get();
    var arr = [];
    snapshot.docs.forEach((element) {
      if (element['state'] == 0) {
        var j = {...element.data(), 'id': element.id};
        arr.add(j);
      }
    });
    allSendFriends = arr;
    sendFriends = arr;
  }

  deleteFriend(id) async {
    await FirebaseFirestore.instance
        .collection(Helper.friendField)
        .doc(id)
        .delete();
    await getReceiveRequestsFriends();
  }

  fieldSearch(Map search) async {
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
        await getList();
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
        var a = element['users'].where((e) => e != userInfo['uid']).toList()[0];
        snapshot.docs.forEach((e) {
          if (e['uid'] == a) {
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
        var a = element['users'].where((e) => e != userInfo['uid']).toList()[0];
        snapshot.docs.forEach((e) {
          if (e['uid'] == a) {
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
        await getSendRequests(userInfo['uid']);
        isSearch = false;
        return;
      } else {
        isSearch = true;
      }
      sendFriends = arr1;
    }
    setState(() {});
  }
}
