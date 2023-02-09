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

  getUsers() async {
    var snapShots = await Helper.userCollection.orderBy('userName').get();
    var usersDocs = snapShots.docs;
    var box = [];
    for (var i = 0; i < usersDocs.length; i++) {
      box.add({
        ...usersDocs[i].data(),
        'uid': usersDocs[i].id,
      });
    }
    users = box;
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
    var snapShots = await Helper.eventsData.get();
    var eventsDocs = snapShots.docs;
    var box = [];
    for (var i = 0; i < eventsDocs.length; i++) {
      box.add({
        ...eventsDocs[i].data(),
        'uid': eventsDocs[i].id,
      });
    }
    events = box;
    setState(() {});
  }

  getGroups() async {
    var snapShots = await Helper.groupsData.get();
    var groupsDocs = snapShots.docs;
    var box = [];
    for (var i = 0; i < groupsDocs.length; i++) {
      box.add({
        ...groupsDocs[i].data(),
        'uid': groupsDocs[i].id,
      });
    }
    groups = box;
    setState(() {});
  }
}
