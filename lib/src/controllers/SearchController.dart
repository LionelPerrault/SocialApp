// ignore_for_file: unused_local_variable

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import '../helpers/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/userModel.dart';

enum EmailType { emailVerify, googleVerify }

class SearchController extends ControllerMVC {
  factory SearchController([StateMVC? state]) =>
      _this ??= SearchController._(state);
  SearchController._(StateMVC? state) : super(state);
  static SearchController? _this;

  List users = [];
  List posts = [];
  List events = [];
  List groups = [];
  String searchText = '';

  updateSearchText(searchParam) {
    searchText = searchParam;
    setState(() {});
    getUsers();
    getEvents();
    getGroups();
  }

  getUsers() async {
    var snapShots = await Helper.userCollection.orderBy('userName').get();
    List box = [];

    for (var doc in snapShots.docs) {
      String name = doc.data()["userName"];
      String firstName = doc.data()["firstName"];
      String lastName = doc.data()["lastName"];
      
      if ((name + firstName + lastName).contains(searchText)) {
        box.add({...doc.data(), 'uid': doc.id,});
      }
    }

    users = box;
    setState(() {});
  }

  getPosts() async {
    var allSanp = await Helper.postCollection.orderBy('postTime', descending: true).get();
    var allPosts = allSanp.docs;
    var postData;
    var adminInfo;
    var postsBox = [];
    for (var i = 0; i < allPosts.length; i++) {
      if (allPosts[i]['type'] == 'product') {
        var valueSnap = await Helper.productsData.doc(allPosts[i]['value']).get();
        postData = valueSnap.data();
      } else {
        postData = allPosts[i]['value'];
      }
      var adminSnap = await Helper.userCollection.doc(allPosts[i]['postAdmin']).get();
      adminInfo = adminSnap.data();
      var eachPost = {
        'id': allPosts[i].id,
        'data': postData,
        'type': allPosts[i]['type'],
        'adminInfo': adminInfo,
        'time': allPosts[i]['postTime'],
        'adminUid': adminSnap.id,
        'privacy': allPosts[i]['privacy'],
        'header': allPosts[i]['header'],
        'timeline': allPosts[i]['timeline'],
        'comment': allPosts[i]['comment']
      };
      if (eachPost['adminUid'] == UserManager.userInfo['uid'] ||
          eachPost['privacy'] == 'Public') {
        postsBox.add(eachPost);
      }
    }
    posts = postsBox;
    setState(() {});
  }

  getEvents() async {
    var snapShots = await Helper.eventsData.get();
    List box = [];

    for (var doc in snapShots.docs) {      
      if (doc.data()["eventName"].contains(searchText)) {
        box.add({...doc.data(), 'uid': doc.id,});
      }
    }

    events = box;
    setState(() {});
  }

  getGroups() async {
    var snapShots = await Helper.groupsData.get();
    List box = [];

    for (var doc in snapShots.docs) {
      if (doc.data()["groupName"].contains(searchText)) {
        box.add({...doc.data(), 'uid': doc.id,});
      }
    }

    groups = box;
    setState(() {});
  }

  getAllSearchResult() async {
    await getUsers();
    await getEvents();
    await getGroups();
  }
}
