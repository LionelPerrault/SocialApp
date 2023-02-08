// ignore_for_file: unused_local_variable

import 'package:mvc_pattern/mvc_pattern.dart';
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
    for (var i = 0; i < usersDocs.length; i++) {
      users.add({
        ...usersDocs[i].data(),
        'uid': usersDocs[i].id,
      });
    }
    setState(() {});
  }

  getPosts() async {
    var snapShots = await Helper.postCollection.get();
    var postsDocs = snapShots.docs;
    for (var i = 0; i < postsDocs.length; i++) {
      posts.add({
        ...postsDocs[i].data(),
        'uid': postsDocs[i].id,
      });
    }
    setState(() {});
  }

  getEvents() async {
    var snapShots = await Helper.eventsData.get();
    var eventsDocs = snapShots.docs;
    for (var i = 0; i < eventsDocs.length; i++) {
      events.add({
        ...eventsDocs[i].data(),
        'uid': eventsDocs[i].id,
      });
    }
    setState(() {});
  }

  getGroups() async {
    var snapShots = await Helper.groupsData.get();
    var groupsDocs = snapShots.docs;
    for (var i = 0; i < groupsDocs.length; i++) {
      groups.add({
        ...groupsDocs[i].data(),
        'uid': groupsDocs[i].id,
      });
    }
    setState(() {});
  }
}
