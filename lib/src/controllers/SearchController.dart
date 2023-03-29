// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import '../helpers/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import '../models/userModel.dart';

enum EmailType { emailVerify, googleVerify }

class SearchController extends ControllerMVC {
  factory SearchController([StateMVC? state]) =>
      _this ??= SearchController._(state);
  SearchController._(StateMVC? state) : super(state);
  static SearchController? _this;

  List users = [];
  List usersByFirstName = [];
  List usersByLastName = [];
  List posts = [];
  List events = [];
  List groups = [];
  String searchText = '';

  updateSearchText(searchParam) {
    searchText = searchParam;
    setState(() {});
    getUsersByFirstName(searchText);
    getUsersByLastName(searchText);
    getEvents();
    getGroups();
  }

  getUsersByFirstName(searchText) async {
    List box = [];

    var snapShots = await FirebaseFirestore.instance
        .collection(Helper.userField)
        .where('firstName', isGreaterThanOrEqualTo: searchText)
        .where('firstName', isLessThan: searchText + 'z')
        .get();

    for (var doc in snapShots.docs) {
      box.add({
        ...doc.data(),
        'uid': doc.id,
      });
    }

    usersByFirstName = box;

    setState(() {});
  }

  getUsersByLastName(searchText) async {
    List box = [];

    var snapShots = await FirebaseFirestore.instance
        .collection(Helper.userField)
        .where('lastName', isGreaterThanOrEqualTo: searchText)
        .where('lastName', isLessThan: searchText + 'z')
        .get();

    for (var doc in snapShots.docs) {
      box.add({
        ...doc.data(),
        'uid': doc.id,
      });
    }
    usersByLastName = box;

    setState(() {});
  }

  getPosts() async {
    var allSanp =
        await Helper.postCollection.orderBy('postTime', descending: true).get();
    var allPosts = allSanp.docs;
    var postData;
    var adminInfo;
    var postsBox = [];
    for (var i = 0; i < allPosts.length; i++) {
      if (allPosts[i]['type'] == 'product') {
        var valueSnap =
            await Helper.productsData.doc(allPosts[i]['value']).get();
        postData = valueSnap.data();
      } else {
        postData = allPosts[i]['value'];
      }
      var adminSnap =
          await Helper.userCollection.doc(allPosts[i]['postAdmin']).get();
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
    //var snapShots = await Helper.eventsData.get();

    if (searchText != '') {
      var snapShots = await FirebaseFirestore.instance
          .collection(Helper.eventsField)
          .where('eventName', isGreaterThanOrEqualTo: searchText)
          .where('eventName', isLessThan: '${searchText}z')
          .get();
      List box = [];

      for (var doc in snapShots.docs) {
        box.add({
          ...doc.data(),
          'uid': doc.id,
        });
        // if (doc.data()["eventName"].contains(searchText)) {
        //   box.add({
        //     ...doc.data(),
        //     'uid': doc.id,
        //   });
        // }
      }

      events = box;
      setState(() {});
    }
  }

  getGroups() async {
    if (searchText != '') {
      var snapShots = await FirebaseFirestore.instance
          .collection(Helper.groupsField)
          .where('groupName', isGreaterThanOrEqualTo: searchText)
          .where('groupName', isLessThan: '${searchText}z')
          .get();
      List box = [];

      for (var doc in snapShots.docs) {
        box.add({
          ...doc.data(),
          'uid': doc.id,
        });
      }

      groups = box;
      setState(() {});
    }
  }

  getAllSearchResult() async {
    // await getUsersByFirstName(searchText);
    // await getUsersByLastName(searchText);
    // await getEvents();
    // await getGroups();
  }
}
