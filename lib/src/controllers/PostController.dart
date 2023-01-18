// ignore_for_file: unused_local_variable

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:uuid/uuid.dart';
import '../helpers/helper.dart';
import '../managers/relysia_manager.dart';
import '../models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../routes/route_names.dart';
import 'package:time_elapsed/time_elapsed.dart';

class PostController extends ControllerMVC {
  factory PostController([StateMVC? state]) =>
      _this ??= PostController._(state);
  PostController._(StateMVC? state)
      : eventSubRoute = '',
        pageSubRoute = '',
        groupSubRoute = '',
        super(state);
  static PostController? _this;
  List unlikedPages = [];
  List unJoindGroups = [];
  List unInterestedEvents = [];
  @override
  Future<bool> initAsync() async {
    //
    Helper.eventsData =
        FirebaseFirestore.instance.collection(Helper.eventsField);
    return true;
  }

  Future<bool> uploadPicture(String where, String what, String url) async {
    switch (where) {
      case 'group':
        print(what);
        FirebaseFirestore.instance
            .collection(Helper.groupsField)
            .doc(viewGroupId)
            .update({'groupPicture': url}).then((e) async {
          group[what] = url;
          setState(() {});
        });
        break;

      default:
    }
    return true;
  }

  /////////////////////////////all support ////////////////////////////////////
  //bool of my friends
  Future<bool> boolMyFriend(String userName) async {
    if (UserManager.userInfo['friends'] != null) {
      var friends = UserManager.userInfo['friends'].where(
          (eachUser) => eachUser['userName'] == userName && eachUser['status']);
      if (friends.length > 0) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  //bool of friends of my friends
  Future<bool> boolFriendMyFriend(String userId) async {
    if (UserManager.userInfo['friends'] != null) {
      var myFriends = UserManager.userInfo['friends'];
      var hisFriends = [];
      await Helper.authdata.doc(userId).get().then((value) async {
        hisFriends = value['friends'];
      });
      for (var i = 0; i < myFriends.length; i++) {
        for (var j = 0; j < hisFriends.length; j++) {
          if (myFriends[i]['userName'] == hisFriends[j]['userName'] &&
              myFriends[i]['status'] &&
              hisFriends[j]['status']) {
            return true;
          }
        }
      }
      return false;
    } else {
      return false;
    }
  }

  /////////////////////////////////////////////////////////////////////////////////

  //////////////////////////// start event functions ///////////////////////////////////

  //variable
  List events = [];
  var productsComments = {};
  //view each event support data
  var event;
  var viewEventId = '';
  var viewEventInterested = false;
  var viewEventGoing = false;
  var viewEventInvited = false;
  var allEvent;

  //sub router
  String eventTab = 'Timeline';

  //sub route
  String eventSubRoute;

  //get all event function
  Future<List> getEvent(String condition, String uid) async {
    var ae = await Helper.eventsData.get();
    allEvent = ae.docs;
    setState(() {});
    print(allEvent);
    List<Map> realAllEvents = [];
    await Helper.eventsData.get().then((value) async {
      var doc = value.docs;
      for (int i = 0; i < doc.length; i++) {
        var id = doc[i].id;
        var data = doc[i];
        var interested =
            await boolInterested(data, UserManager.userInfo['uid']);
        //closed event
        if (data['eventPrivacy'] == 'closed') {
          if (data['eventAdmin'][0]['uid'] == uid && condition == 'manage') {
            realAllEvents
                .add({'data': data, 'id': id, 'interested': interested});
          }
        }
        //security event
        else /*if (data['eventPrivacy'] == 'security') */ {
          var inInterested =
              await boolInterested(data, UserManager.userInfo['uid']);
          var inInvited = await boolInvited(data, UserManager.userInfo['uid']);
          var inGoing = await boolGoing(data, UserManager.userInfo['uid']);
          if (inInterested && condition == 'interested') {
            realAllEvents
                .add({'data': data, 'id': id, 'interested': interested});
          } else if (inInvited && condition == 'invited') {
            realAllEvents
                .add({'data': data, 'id': id, 'interested': interested});
          } else if (inGoing && condition == 'going') {
            realAllEvents
                .add({'data': data, 'id': id, 'interested': interested});
          } else if (uid == data['eventAdmin'][0]['uid'] &&
              condition == 'manage') {
            realAllEvents
                .add({'data': data, 'id': id, 'interested': interested});
          } else if (condition == 'all') {
            if (data['eventPrivacy'] == 'public' && data['eventPost'] == true) {
              realAllEvents
                  .add({'data': data, 'id': id, 'interested': interested});
            }
          } else if (condition == 'unInterested' &&
              !interested &&
              realAllEvents.length < 5) {
            realAllEvents.add({'data': data, 'id': id});
          }
          setState(() {});
        }
      }
      print('Now you get all events');
    });

    return realAllEvents;
  }

  //get one event function that using uid of firebase database
  Future<bool> getSelectedEvent(String id) async {
    id = id.split('/')[id.split('/').length - 1];
    viewEventId = id;
    await Helper.eventsData.doc(id).get().then((value) async {
      event = value.data();
      viewEventInterested =
          await boolInterested(value, UserManager.userInfo['uid']);
      viewEventGoing = await boolGoing(value, UserManager.userInfo['uid']);
      viewEventInvited = await boolInvited(value, UserManager.userInfo['uid']);
      for (var i = 0; i < event['eventAdmin'].length; i++) {
        var addAdmin = await ProfileController()
            .getUserInfo(event['eventAdmin'][i]['uid']);
        event['eventAdmin'][i] = {
          ...event['eventAdmin'][i],
          'userName': addAdmin!['userName'],
          'avatar': addAdmin['avatar'],
          'fullName': '${addAdmin["firstName"]} ${addAdmin["lastName"]}',
        };
      }
      for (var i = 0; i < event['eventInterested'].length; i++) {
        var addAdmin = await ProfileController()
            .getUserInfo(event['eventInterested'][i]['uid']);
        event['eventInterested'][i] = {
          ...event['eventInterested'][i],
          'userName': addAdmin!['userName'],
          'avatar': addAdmin['avatar'],
          'fullName': '${addAdmin["firstName"]} ${addAdmin["lastName"]}',
        };
      }
      for (var i = 0; i < event['eventInvited'].length; i++) {
        var addAdmin = await ProfileController()
            .getUserInfo(event['eventInvited'][i]['uid']);
        event['eventInvited'][i] = {
          ...event['eventInvited'][i],
          'userName': addAdmin!['userName'],
          'avatar': addAdmin['avatar'],
          'fullName': '${addAdmin["firstName"]} ${addAdmin["lastName"]}',
        };
      }
      for (var i = 0; i < event['eventInvites'].length; i++) {
        var addAdmin = await ProfileController()
            .getUserInfo(event['eventInvites'][i]['uid']);
        event['eventInvites'][i] = {
          ...event['eventInvites'][i],
          'userName': addAdmin!['userName'],
          'avatar': addAdmin['avatar'],
          'fullName': '${addAdmin["firstName"]} ${addAdmin["lastName"]}',
        };
      }
      setState(() {});
      print('This event was posted by ${event['eventAdmin'][0]["fullName"]}');
    });
    return true;
  }

  //create event function
  Future<String> createEvent(context, Map<String, dynamic> eventData) async {
    if (eventData['eventName'] == null || eventData['eventName'] == '') {
      return 'Please add your event name';
    } else if (eventData['eventLocation'] == null ||
        eventData['eventLocation'] == '') {
      return 'Please add your event location';
    } else if (eventData['eventStartDate'] == null ||
        eventData['eventStartDate'] == '') {
      return 'Please add your event start date';
    } else if (eventData['eventEndDate'] == null ||
        eventData['eventEndDate'] == '') {
      return 'Please add your event end date';
    }
    eventData = {
      ...eventData,
      'eventAdmin': [
        {
          'uid': UserManager.userInfo['uid'],
        }
      ],
      'eventDate': FieldValue.serverTimestamp(),
      'eventGoing': [],
      'eventInterested': [],
      'eventInvited': [],
      'eventInvites': [],
      'eventPost': false,
      'eventPicture': '',
      'eventCanPub': true,
      'eventApproval': true
    };
    await FirebaseFirestore.instance
        .collection(Helper.eventsField)
        .add(eventData)
        .then(
          (value) => {
            Navigator.pushReplacementNamed(context, '/events/${value.id}'),
          },
        );
    return 'Successfully created';
  }

  //get all interests from firebase
  Future<List> getAllInterests() async {
    QuerySnapshot querySnapshot =
        await Helper.allInterests.orderBy('title').get();
    var doc = querySnapshot.docs;
    print('Now you get all interests value to const');
    return doc;
  }

  ////////////////////functions that support for making comment to event/////////////////////////////

  //user join in event interested function
  Future<bool> interestedEvent(String eventId) async {
    print('now you are interested or uninterested this event ${eventId}');
    var querySnapshot = await Helper.eventsData.doc(eventId).get();
    var doc = querySnapshot;
    var interested = doc['eventInterested'];
    var respon = await boolInterested(doc, UserManager.userInfo['uid']);
    if (respon) {
      interested
          .removeWhere((item) => item['uid'] == UserManager.userInfo['uid']);
      await FirebaseFirestore.instance
          .collection(Helper.eventsField)
          .doc(eventId)
          .update({'eventInterested': interested});
      return true;
    } else {
      interested.add({
        'uid': UserManager.userInfo['uid'],
      });
      await FirebaseFirestore.instance
          .collection(Helper.eventsField)
          .doc(eventId)
          .update({'eventInterested': interested});
      return true;
    }
  }

  //bool of user already in event interested or not
  Future<bool> boolInterested(var eventData, String uid) async {
    var interested = eventData['eventInterested'];
    if (interested == null) {
      return false;
    }
    var returnData = interested.where((eachUser) => eachUser['uid'] == uid);
    print('you get bool of interested event');
    if (returnData.length == 0) {
      return false;
    } else {
      return true;
    }
  }

  //user join in event going function
  Future<bool> goingEvent(String eventId) async {
    print('now you are going or ungoing this event ${eventId}');
    var querySnapshot = await Helper.eventsData.doc(eventId).get();
    var doc = querySnapshot;
    var going = doc['eventGoing'];
    var respon = await boolGoing(doc, UserManager.userInfo['uid']);
    if (respon) {
      going.removeWhere((item) => item['uid'] == UserManager.userInfo['uid']);
      await FirebaseFirestore.instance
          .collection(Helper.eventsField)
          .doc(eventId)
          .update({'eventGoing': going});
      return true;
    } else {
      going.add({
        'uid': UserManager.userInfo['uid'],
      });
      await FirebaseFirestore.instance
          .collection(Helper.eventsField)
          .doc(eventId)
          .update({'eventGoing': going});
      return true;
    }
  }

  //bool of user already in event going or not
  Future<bool> boolGoing(var eventData, String uid) async {
    var going = eventData['eventGoing'];
    if (going == null) {
      return false;
    }
    var returnData = going.where((eachUser) => eachUser['uid'] == uid);
    print('you get bool of going event');
    if (returnData.length == 0) {
      return false;
    } else {
      return true;
    }
  }

  //user  join in event invited function
  Future<bool> invitedEvent(String eventId) async {
    print('now you are invited or uninvited this event ${eventId}');
    var querySnapshot = await Helper.eventsData.doc(eventId).get();
    var doc = querySnapshot;
    var invited = doc['eventInvited'];
    var respon = await boolInvited(doc, UserManager.userInfo['uid']);
    if (respon) {
      invited.removeWhere(
          (item) => item['userName'] == UserManager.userInfo['uid']);
      await FirebaseFirestore.instance
          .collection(Helper.eventsField)
          .doc(eventId)
          .update({'eventInvited': invited});
      return true;
    } else {
      invited.add({
        'uid': UserManager.userInfo['uid'],
      });
      await FirebaseFirestore.instance
          .collection(Helper.eventsField)
          .doc(eventId)
          .update({'eventInvited': invited});
      return true;
    }
  }

  //bool of user already in event invited or not
  Future<bool> boolInvited(var eventData, String uid) async {
    var invited = eventData['eventInvited'];
    if (invited == null) {
      return false;
    }
    var returnData = invited.where((eachUser) => eachUser['uid'] == uid);
    print('you get bool of invited event');
    if (returnData.length == 0) {
      return false;
    } else {
      return true;
    }
  }

  Future<String> updateEventInfo(Map<String, dynamic> pageInfo) async {
    var result = await Helper.eventsData.doc(viewEventId).update(pageInfo);
    return 'Successfully updated';
  }

  Future<bool> deleteEvent() async {
    await FirebaseFirestore.instance
        .collection(Helper.eventsField)
        .doc(viewEventId)
        .delete();
    return true;
  }

  ////////////////////functions that make comment to event/////////////////////////////

  ///////////////////////////end events functions //////////////////////////////////////////////////

  //////////////////////////// start page functions ///////////////////////////////////

  //variable
  List pages = [];

  //view each page support data
  var page;
  var viewPageId = '';
  var viewPageName = '';
  var viewPageLiked = false;

  //sub router
  String pageTab = 'Timeline';

  //sub route
  String pageSubRoute;

  //get all page function
  Future<List> getPage(String condition, String uid) async {
    List<Map> realAllpage = [];
    await Helper.pagesData.get().then((value) async {
      var doc = value.docs;
      for (int i = 0; i < doc.length; i++) {
        var id = doc[i].id;
        var data = doc[i];
        var liked = await boolLiked(data, UserManager.userInfo['uid']);
        if (uid == data['pageAdmin'][0]['uid'] && condition == 'manage') {
          realAllpage.add({'data': data, 'id': id, 'liked': liked});
        } else if (condition == 'all') {
          if (data['pagePost']) {
            realAllpage.add({'data': data, 'id': id, 'liked': liked});
          }
        } else if (condition == 'liked' && liked) {
          realAllpage.add({'data': data, 'id': id, 'liked': liked});
        } else if (condition == 'unliked' && !liked && realAllpage.length < 5) {
          realAllpage.add({'data': data, 'id': id});
        }
        setState(() {});
      }
      print('Now you get all pages');
    });
    print(realAllpage);
    return realAllpage;
  }

  //get one page function that using uid of firebase database
  Future<bool> getSelectedPage(String name) async {
    name = name.split('/')[name.split('/').length - 1];
    viewPageName = name;
    var reuturnValue = await Helper.pagesData
        .where('pageUserName', isEqualTo: viewPageName)
        .get();
    var value = reuturnValue.docs;
    viewPageId = value[0].id;
    page = value[0].data();
    viewPageLiked = await boolLiked(page, UserManager.userInfo['uid']);
    for (var i = 0; i < page['pageAdmin'].length; i++) {
      var addAdmin =
          await ProfileController().getUserInfo(page['pageAdmin'][i]['uid']);
      page['pageAdmin'][i] = {
        ...page['pageAdmin'][i],
        'userName': addAdmin!['userName'],
        'avatar': addAdmin['avatar'],
      };
    }
    for (var i = 0; i < page['pageLiked'].length; i++) {
      var pageUser =
          await ProfileController().getUserInfo(page['pageLiked'][i]['uid']);
      page['pageLiked'][i] = {
        ...page['pageLiked'][i],
        'userName': pageUser!['userName'],
        'avatar': pageUser['avatar'],
      };
    }
    print(page);
    print('wanna pageinfo');
    setState(() {});
    print('This page was posted by ${page['pageAdmin'][0]}');
    return true;
  }

  //create page function
  Future<String> createPage(context, Map<String, dynamic> pageData) async {
    if (pageData['pageName'] == null || pageData['pageName'] == '') {
      return 'Please add your page name';
    } else if (pageData['pageUserName'] == null ||
        pageData['pageUserName'] == '') {
      return 'Please add your page user name';
    } else if (pageData['pageLocation'] == null ||
        pageData['pageLocation'] == '') {
      return 'Please add your page location';
    }
    pageData = {
      ...pageData,
      'pageAdmin': [
        {'uid': UserManager.userInfo['uid']}
      ],
      'pageDate': DateTime.now().toString(),
      'pageLiked': [],
      'pagePost': false,
      'pagePicture': '',
      'pageCover': '',
      'pagePhotos': [],
      'pageAlbums': [],
      'pageVideos': [],
    };

    var reuturnValue = await Helper.pagesData
        .where('pageUserName', isEqualTo: pageData['pageUserName'])
        .get();
    var value = reuturnValue.docs;
    if (value.isNotEmpty) {
      return 'Page Name should be unique';
    }
    await FirebaseFirestore.instance
        .collection(Helper.pagesField)
        .add(pageData)
        .then((value) => {
              Navigator.pushReplacementNamed(
                  context, '${RouteNames.pages}/${pageData['pageUserName']}'),
            });

    return 'Page was created successfully';
  }

  ////////////////////functions that support for making comment to page/////////////////////////////

  //user join in page liked function
  Future<bool> likedPage(String pageId) async {
    print('now you are liked or unliked this page ${pageId}');
    var querySnapshot = await Helper.pagesData.doc(pageId).get();
    var doc = querySnapshot;
    var liked = doc['pageLiked'];
    var respon = await boolLiked(doc, UserManager.userInfo['uid']);
    print('respon$respon');
    if (respon) {
      liked.removeWhere((item) => item['uid'] == UserManager.userInfo['uid']);
      await FirebaseFirestore.instance
          .collection(Helper.pagesField)
          .doc(pageId)
          .update({'pageLiked': liked});
      return true;
    } else {
      liked.add({
        'uid': UserManager.userInfo['uid'],
      });
      await FirebaseFirestore.instance
          .collection(Helper.pagesField)
          .doc(pageId)
          .update({'pageLiked': liked});
      return true;
    }
  }

  //bool of user already in page interested or not
  Future<bool> boolLiked(var pageData, String uid) async {
    var liked = pageData['pageLiked'];
    if (liked == null) {
      return false;
    }
    var returnData = liked.where((eachUser) => eachUser['uid'] == uid);
    print('you get bool of liked page');
    if (returnData.length == 0) {
      return false;
    } else {
      return true;
    }
  }

  Future<String> updatePageInfo(dynamic pageInfo) async {
    print(page['pageUserName']);
    print(pageInfo['pageUserName']);
    if (pageInfo['pageUserName'] == page['pageUserName']) {
      var result = await Helper.pagesData.doc(viewPageId).update(pageInfo);
      getSelectedPage(viewPageName);
      return 'success';
    } else {
      QuerySnapshot querySnapshot = await Helper.pagesData.get();
      var allPage = querySnapshot.docs;
      var allPages = allPage.where(
          (eachPage) => eachPage['pageUserName'] == pageInfo['pageUserName']);
      if (allPages.isNotEmpty) {
        return 'dobuleName';
      } else {
        var result = await Helper.pagesData.doc(viewPageId).update(pageInfo);
        getSelectedPage(viewPageName);
        return 'success';
      }
    }
  }

  Future<bool> deletePage() async {
    await FirebaseFirestore.instance
        .collection(Helper.pagesField)
        .doc(viewPageId)
        .delete();
    return true;
  }

  Future<String> removeMember(String userName) async {
    page['pageLiked'].removeWhere((item) => item['userName'] == userName);
    await FirebaseFirestore.instance
        .collection(Helper.pagesField)
        .doc(viewPageId)
        .update({
      'pageLiked': page['pageLiked'],
    });
    return 'success';
  }

  Future<String> removeAdmin(String uid) async {
    if (page['pageAdmin'][0] == uid) {
      return 'superAdmin';
    }
    page['pageAdmin'].removeWhere((item) => item == uid);
    await FirebaseFirestore.instance
        .collection(Helper.pagesField)
        .doc(viewPageId)
        .update({
      'pageLiked': page['pageLiked'],
    });
    return 'success';
  }

  ////////////////////functions that make comment to page/////////////////////////////

  ///////////////////////////end pages functions //////////////////////////////////////////////////

  //////////////////////////// start groups functions ///////////////////////////////////

  //variable
  List groups = [];

  //view each group support data
  var group;
  var viewGroupId = '';
  var viewGroupName = '';
  var viewGroupJoined = false;

  //sub router
  String groupTab = 'Timeline';

  //sub route
  String groupSubRoute;

  //get all group function
  Future<List> getGroup(String condition, String uid) async {
    List<Map> realAllGroups = [];
    await Helper.groupsData.get().then((value) async {
      var doc = value.docs;
      for (int i = 0; i < doc.length; i++) {
        var id = doc[i].id;
        var data = doc[i];
        var joined = await boolJoined(data, UserManager.userInfo['uid']);
        if (uid == data['groupAdmin'][0]['uid'] && condition == 'manage') {
          realAllGroups.add({'data': data, 'id': id, 'joined': joined});
        } else if (condition == 'all') {
          if (data['groupPost']) {
            realAllGroups.add({'data': data, 'id': id, 'joined': joined});
          }
        } else if (condition == 'joined' && joined) {
          realAllGroups.add({'data': data, 'id': id, 'joined': joined});
        } else if (condition == 'unJoined' &&
            !joined &&
            realAllGroups.length < 5) {
          realAllGroups.add({'data': data, 'id': id});
        }
        setState(() {});
      }
      print('Now you get all groups');
    });

    return realAllGroups;
  }

  //get one group function that using uid of firebase database
  Future<bool> getSelectedGroup(String name) async {
    name = name.split('/')[name.split('/').length - 1];
    viewGroupName = name;
    var reuturnValue = await Helper.groupsData
        .where('groupUserName', isEqualTo: viewGroupName)
        .get();
    var value = reuturnValue.docs;
    viewGroupId = value[0].id;
    group = value[0].data();
    viewGroupJoined = await boolJoined(group, UserManager.userInfo['uid']);
    setState(() {});
    for (var i = 0; i < group['groupAdmin'].length; i++) {
      var addAdmin =
          await ProfileController().getUserInfo(group['groupAdmin'][i]['uid']);
      group['groupAdmin'][i] = {
        ...group['groupAdmin'][i],
        'userName': addAdmin!['userName'],
        'avatar': addAdmin['avatar'],
      };
    }
    for (var i = 0; i < group['groupJoined'].length; i++) {
      var groupUser =
          await ProfileController().getUserInfo(group['groupJoined'][i]['uid']);
      group['groupJoined'][i] = {
        ...group['groupJoined'][i],
        'userName': groupUser!['userName'],
        'avatar': groupUser['avatar'],
        'fullName': '${groupUser["firstName"]} ${groupUser["lastName"]}'
      };
    }
    setState(() {});
    print('This group was posted by ${group['groupAdmin'][0]['userName']}');
    return true;
  }

  //create group function
  Future<String> createGroup(context, Map<String, dynamic> groupData) async {
    if (groupData['groupName'] == null || groupData['groupName'] == '') {
      return 'Please add your group name';
    } else if (groupData['groupUserName'] == null ||
        groupData['groupUserName'] == '') {
      return 'Please add your group user name';
    } else if (groupData['groupLocation'] == null ||
        groupData['groupLocation'] == '') {
      return 'Please add your group location';
    }
    groupData = {
      ...groupData,
      'groupAdmin': [
        {'uid': UserManager.userInfo['uid']},
      ],
      'groupDate': DateTime.now().toString(),
      'groupJoined': [],
      'groupPost': false,
      'groupPicture': '',
      'groupCover': '',
      'groupPhotos': [],
      'groupAlbums': [],
      'groupVideos': [],
      'groupCanPub': false,
      'groupApproval': true,
    };

    var reuturnValue = await Helper.groupsData
        .where('groupUserName', isEqualTo: groupData['groupUserName'])
        .get();
    var value = reuturnValue.docs;
    if (value.isNotEmpty) {
      return 'Group name already exist';
    }

    await FirebaseFirestore.instance
        .collection(Helper.groupsField)
        .add(groupData);

    Navigator.pushReplacementNamed(
        context, '${RouteNames.groups}/${groupData['groupUserName']}');
    return 'Successfully created';
  }

  ////////////////////functions that support for making comment to group/////////////////////////////

  //user join in group liked function
  Future<bool> joinedGroup(String groupId) async {
    print('now you are joined or unjoined this group ${groupId}');
    var querySnapshot = await Helper.groupsData.doc(groupId).get();
    var doc = querySnapshot;
    var joined = doc['groupJoined'];
    var respon = await boolJoined(doc, UserManager.userInfo['uid']);
    if (respon) {
      joined.removeWhere((item) => item['uid'] == UserManager.userInfo['uid']);
      await FirebaseFirestore.instance
          .collection(Helper.groupsField)
          .doc(groupId)
          .update({'groupJoined': joined});
      return true;
    } else {
      joined.add({
        'uid': UserManager.userInfo['uid'],
      });
      await FirebaseFirestore.instance
          .collection(Helper.groupsField)
          .doc(groupId)
          .update({'groupJoined': joined});
      return true;
    }
  }

  //bool of user already in group interested or not
  Future<bool> boolJoined(var groupData, String uid) async {
    var joined = groupData['groupJoined'];
    if (joined == null) {
      return false;
    }
    var returnData = joined.where((eachUser) => eachUser['uid'] == uid);
    print('you get bool of joined group');
    if (returnData.length == 0) {
      return false;
    } else {
      return true;
    }
  }

  Future<String> updateGroupInfo(dynamic groupInfo) async {
    if (groupInfo['groupUserName'] == null) {
      var result = await Helper.groupsData.doc(viewGroupId).update(groupInfo);
      return group['groupUserName'];
    }
    if (groupInfo['groupUserName'] == group['groupUserName']) {
      var result = await Helper.groupsData.doc(viewGroupId).update(groupInfo);
      return group['groupUserName'];
    } else {
      QuerySnapshot querySnapshot = await Helper.groupsData.get();
      var allGroup = querySnapshot.docs;
      var flag = allGroup.where((eachGroup) =>
          eachGroup['groupUserName'] == groupInfo['groupUserName']);
      if (flag.isNotEmpty) {
        return 'dobuleName${groupInfo['groupUserName']}';
      } else {
        var result = await Helper.groupsData.doc(viewGroupId).update(groupInfo);
        return groupInfo['groupUserName'];
      }
    }
  }

  ////////////////////functions that make comment to group/////////////////////////////

  ///////////////////////////end groups functions //////////////////////////////////////////////////

  Future<String> createProduct(
      context, Map<String, dynamic> productData) async {
    if (productData['productName'] == null ||
        productData['productName'] == '') {
      return 'Please add your product name';
    } else if (productData['productPrice'] == null ||
        productData['productPrice'] == '') {
      return 'Please add your product price';
    } else if (productData['productCategory'] == null ||
        productData['productCategory'] == '') {
      return 'Please add your product category';
    }
    productData = {
      ...productData,
      'productAdmin': {
        'uid': UserManager.userInfo['uid'],
      },
      'productDate': DateTime.now().toString(),
      'productPost': false,
      'productMarkAsSold': false,
      'productTimeline': true,
      'productOnOffCommenting': true,
    };

    var notificationData;
    await FirebaseFirestore.instance
        .collection(Helper.productsField)
        .add(productData)
        .then((value) async => {
              notificationData = {
                'postType': 'products',
                'postId': value.id,
                'postAdminId': UserManager.userInfo['uid'],
                'notifyTime': DateTime.now().toString(),
                'tsNT': DateTime.now().millisecondsSinceEpoch,
                'userList': [],
              },
              saveNotifications(notificationData),
              Navigator.pushReplacementNamed(
                  context, '${RouteNames.products}/${value.id}')
            });
    // RelysiaManager.payNow(UserManager.userInfo, RelysiaManager.adminPaymail,
    //     '10', 'for create product');
    return 'Successfully created';
  }

  List<Map> allProduct = [];

  //get all product function
  Future<void> getProduct() async {
    allProduct = [];
    await Helper.productsData.get().then((value) async {
      var doc = value.docs;
      for (int i = 0; i < doc.length; i++) {
        var id = doc[i].id;
        var data = doc[i];
        allProduct.add({'data': data.data(), 'id': id});
        setState(() {});
      }
      print('Now you get all products');
    });
  }

  var viewProductId;
  var product;
  //get one page function that using uid of firebase database
  Future<bool> getSelectedProduct(String name) async {
    name = name.split('/')[name.split('/').length - 1];
    viewProductId = name;
    var reuturnValue = await Helper.productsData.doc(viewProductId).get();
    var value = reuturnValue.data();
    product = value;
    setState(() {});
    print('This page was posted by ${product['productAdmin']}');
    return true;
  }

  Future<void> productMarkAsSold(String productUid, bool value) async {
    print(productUid);
    print(value);
    await FirebaseFirestore.instance
        .collection(Helper.productsField)
        .doc(productUid)
        .update({'productMarkAsSold': value}).then((e) async {
      getProduct();
    });
  }

  Future<void> productSavePost(String productUid, bool value) async {
    print(productUid);
    print(value);
    await FirebaseFirestore.instance
        .collection(Helper.productsField)
        .doc(productUid)
        .update({'productPost': value}).then((e) async {
      getProduct();
    });
  }

  Future<void> productDelete(String productUid) async {
    print(productUid);
    await FirebaseFirestore.instance
        .collection(Helper.productsField)
        .doc(productUid)
        .delete()
        .then((e) async {
      getProduct();
    });
  }

  Future<void> productHideFromTimeline(String productUid, bool value) async {
    print(productUid);
    await FirebaseFirestore.instance
        .collection(Helper.productsField)
        .doc(productUid)
        .update({'productTimeline': value}).then((e) async {
      getProduct();
    });
  }

  Future<void> productTurnOffCommenting(String productUid, bool value) async {
    print(productUid);
    await FirebaseFirestore.instance
        .collection(Helper.productsField)
        .doc(productUid)
        .update({'productOnOffCommenting': value}).then((e) async {
      getProduct();
    });
  }

  changeProductSellState(productId) async {
    await Helper.productsData.doc(productId).update({'productSellState': true});
  }

  var productLikes = {};
  saveProductLikes(productId, likes) async {
    var userInfo = UserManager.userInfo;
    var snapshot = await Helper.productLikeComment.doc(productId).get();
    var a = [];
    if (snapshot.data() == null) {
      a.add({'userName': userInfo['userName'], 'likes': likes});
    } else {
      var arr = snapshot.data()!['likes'];
      var aa =
          arr.where((val) => val['userName'] == userInfo['userName']).toList();
      print(aa);
      if (aa.isEmpty) {
        a.add({'userName': userInfo['userName'], 'likes': likes});
      }
      var s = '';
      for (int i = 0; i < arr.length; i++) {
        s = arr[i]['likes'];
        if (userInfo['userName'] == arr[i]['userName']) {
          s = likes;
        }
        a.add({'userName': arr[i]['userName'], 'likes': s});
      }
    }
    await Helper.productLikeComment.doc(productId).set({'likes': a});
  }

  var productLikesCount = {};
  getProductLikes() async {
    var userInfo = UserManager.userInfo;
    var snapshot = await Helper.productLikeComment.get();
    for (int i = 0; i < snapshot.docs.length; i++) {
      productLikesCount[snapshot.docs[i].id] = [];
      for (int j = 0; j < snapshot.docs[i]['likes'].length; j++) {
        if (snapshot.docs[i]['likes'][j]['userName'] == userInfo['userName']) {
          productLikes[snapshot.docs[i].id] =
              snapshot.docs[i]['likes'][j]['likes'];
        }
        var aa = productLikesCount[snapshot.docs[i].id];
        var a = [];
        var count = 0;
        var s = aa
            .where(
                (val) => val['likes'] == snapshot.docs[i]['likes'][j]['likes'])
            .toList();
        if (s.isEmpty) {
          a.add({'likes': snapshot.docs[i]['likes'][j]['likes'], 'count': 1});
        }
        for (int k = 0; k < aa.length; k++) {
          count = aa[k]['count'];
          if (aa[k]['likes'] == snapshot.docs[i]['likes'][j]['likes']) {
            count += 1;
          }
          a.add({'likes': aa[k]['likes'], 'count': count});
        }
        productLikesCount[snapshot.docs[i].id] = a;
      }
      print(productLikesCount[snapshot.docs[i].id]);
    }
  }

  saveComment(productId, data, type) async {
    var snapshot = await Helper.productLikeComment.get();
    var userManager = UserManager.userInfo;
    var existId = false;
    for (int i = 0; i < snapshot.docs.length; i++) {
      if (snapshot.docs[i].id == productId) {
        existId = true;
        break;
      }
    }
    if (!existId) {
      await Helper.productLikeComment.doc(productId).set({'likes': []});
    }
    await Helper.productLikeComment
        .doc(productId)
        .collection('comments')
        .doc()
        .set({
      'data': {
        'type': type,
        'content': data,
        'userName': userManager['userName']
      },
      'timeStamp': FieldValue.serverTimestamp(),
      'likes': []
    });
  }

  saveLikesComment(productId, commentId, likes) async {
    var userInfo = UserManager.userInfo;
    var snapshot = await Helper.productLikeComment
        .doc(productId)
        .collection('comments')
        .doc(commentId)
        .get();
    var arr = snapshot.data()!['likes'];
    var a = [];
    var aa =
        arr.where((val) => val['userName'] == userInfo['userName']).toList();
    if (aa.isEmpty) {
      a.add({'userName': userInfo['userName'], 'likes': likes});
    }
    for (int i = 0; i < arr.length; i++) {
      var s = arr[i]['likes'];
      if (arr[i]['userName'] == userInfo['userName']) {
        s = likes;
      }
      a.add({'userName': arr[i]['userName'], 'likes': s});
    }
    await Helper.productLikeComment
        .doc(productId)
        .collection('comments')
        .doc(commentId)
        .update({'likes': a});
    getComment(productId);
  }

  var commentLikes = {};
  var commentLikesCount = {};
  getComment(productId) async {
    var userInfo = UserManager.userInfo;
    var snapshot = await Helper.productLikeComment
        .doc(productId)
        .collection('comments')
        .orderBy('timeStamp', descending: true)
        .get();
    var comment = [];
    for (int i = 0; i < snapshot.docs.length; i++) {
      var aa = snapshot.docs[i]['likes'];
      commentLikesCount[snapshot.docs[i].id] = [];
      for (int j = 0; j < aa.length; j++) {
        if (userInfo['userName'] == aa[j]['userName']) {
          commentLikes[snapshot.docs[i].id] = aa[j]['likes'];
        }
        var arr = commentLikesCount[snapshot.docs[i].id];

        var a = [];
        var s = arr.where((val) => val['likes'] == aa[j]['likes']).toList();
        if (s.isEmpty) {
          a.add({'likes': aa[j]['likes'], 'count': 1});
        }
        for (int k = 0; k < arr.length; k++) {
          var count = arr[k]['count'];
          if (arr[k]['likes'] == aa[j]['likes']) {
            count += 1;
          }
          a.add({'likes': arr[k]['likes'], 'count': count});
        }
        commentLikesCount[snapshot.docs[i].id] = a;
      }
      print(commentLikesCount[snapshot.docs[i].id]);
      var avatar =
          await Helper.getUserAvatar(snapshot.docs[i]['data']['userName']);
      comment.add({
        'data': snapshot.docs[i]['data'],
        'avatar': avatar,
        'id': snapshot.docs[i].id,
      });
    }
    print(snapshot.docs.length);
    if (comment.isNotEmpty) {
      productsComments[productId] = comment;
    }
  }

  saveReply(productId, commentId, data, type) async {
    var userInfo = UserManager.userInfo;
    await Helper.productLikeComment
        .doc(productId)
        .collection('comments')
        .doc(commentId)
        .collection('reply')
        .doc()
        .set({
      'data': {'type': type, 'content': data, 'userName': userInfo['userName']},
      'timeStamp': FieldValue.serverTimestamp(),
      'likes': []
    });
    await getReply(productId);
  }

  var commentReply = {};
  var replyLikes = {};
  var replyLikesCount = {};
  getReply(productId) async {
    var userInfo = UserManager.userInfo;
    var snapshot = await Helper.productLikeComment
        .doc(productId)
        .collection('comments')
        .get();
    for (int i = 0; i < snapshot.docs.length; i++) {
      var replies = await Helper.productLikeComment
          .doc(productId)
          .collection('comments')
          .doc(snapshot.docs[i].id)
          .collection('reply')
          .orderBy('timeStamp')
          .get();
      var arr = [];
      for (int j = 0; j < replies.docs.length; j++) {
        replyLikesCount[replies.docs[j].id] = [];
        for (int m = 0; m < replies.docs[j]['likes'].length; m++) {
          if (userInfo['userName'] == replies.docs[j]['likes'][m]['userName']) {
            replyLikes[replies.docs[j].id] =
                replies.docs[j]['likes'][m]['likes'];
          }
          var arr = replyLikesCount[replies.docs[j].id];
          var a = [];
          var aa = arr
              .where(
                  (val) => val['likes'] == replies.docs[j]['likes'][m]['likes'])
              .toList();
          if (aa.isEmpty) {
            a.add({'likes': replies.docs[j]['likes'][m]['likes'], 'count': 1});
          }
          for (int k = 0; k < arr.length; k++) {
            var count = arr[k]['count'];
            if (arr[k]['likes'] == replies.docs[j]['likes'][m]['likes']) {
              count++;
            }
            a.add({'likes': arr[k]['likes'], 'count': count});
          }
          replyLikesCount[replies.docs[j].id] = a;
        }
        var avatar =
            await Helper.getUserAvatar(replies.docs[j]['data']['userName']);
        arr.add({
          'data': replies.docs[j]['data'],
          'avatar': avatar,
          'id': replies.docs[j].id
        });
      }
      commentReply[snapshot.docs[i].id] = arr;
    }
    print(commentReply);
  }

  saveLikesReply(productId, commentId, replyId, likes) async {
    var userInfo = UserManager.userInfo;
    var snapshot = await Helper.productLikeComment
        .doc(productId)
        .collection('comments')
        .doc(commentId)
        .collection('reply')
        .doc(replyId)
        .get();
    var arr = snapshot.data()!['likes'];
    var a = [];
    var aa =
        arr.where((val) => val['userName'] == userInfo['userName']).toList();
    if (aa.isEmpty) {
      a.add({'userName': userInfo['userName'], 'likes': likes});
    }
    for (int i = 0; i < arr.length; i++) {
      var s = arr[i]['likes'];
      if (arr[i]['userName'] == userInfo['userName']) {
        s = likes;
      }
      a.add({'userName': arr[i]['userName'], 'likes': s});
    }
    await Helper.productLikeComment
        .doc(productId)
        .collection('comments')
        .doc(commentId)
        .collection('reply')
        .doc(replyId)
        .update({'likes': a});
  }

  saveNotifications(data) async {
    await FirebaseFirestore.instance
        .collection(Helper.notificationField)
        .add(data);
  }

  var realNotifi = [];
  var allNotification = [];

  checkNotification(notiUid, userUid) async {
    var notiSnap = await Helper.notifiCollection.doc(notiUid).get();
    var allNotifi = notiSnap.data();
    allNotifi!['userList'].add(userUid);
    await Helper.notifiCollection
        .doc(notiUid)
        .update({'userList': allNotifi['userList']});
  }

  Future checkNotify(int check) async {
    await FirebaseFirestore.instance
        .collection(Helper.userField)
        .doc(UserManager.userInfo['uid'])
        .update({'checkNotifyTime': check});
    print('check notify time');
  }

  getPostData(data) async {
    var fData = await Helper.notifiCollection.doc(data['postId']).get();
    var eachPost = fData.data();
    return eachPost;
  }
}
