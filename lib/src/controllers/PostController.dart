// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import '../helpers/helper.dart';
import '../routes/route_names.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

class PostController extends ControllerMVC {
  factory PostController([StateMVC? state]) =>
      _this ??= PostController._(state);
  PostController._(StateMVC? state)
      : eventSubRoute = '',
        pageSubRoute = '',
        groupSubRoute = '',
        notifiers = [],
        super(state);
  static PostController? _this;

  var posts = [];
  var replyLikes = {};
  var replyLikesCount = {};
  Map likes = {};
  Map comments = {};
  int allposts = 0;
  List unlikedPages = [];
  List unJoindGroups = [];
  List unInterestedEvents = [];
  List<mvc.StateMVC> notifiers;
  @override
  Future<bool> initAsync() async {
    //
    Helper.eventsData =
        FirebaseFirestore.instance.collection(Helper.eventsField);
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

  Future<String> formatDate(d) async {
    String trDate = 'Just Now';
    try {
      var time = changeTimeType(d: d);
      var nowTimeStamp = DateTime.now().millisecondsSinceEpoch;
      final difference =
          nowTimeStamp - time + UserManager.userInfo['timeDifference'];
      if (difference / (1000 * 60) < 1) {
        trDate = 'Just Now';
      } else if (difference / (1000 * 60 * 60) < 1) {
        trDate = '${(difference / (1000 * 60)).round()} minutes ago';
      } else if (difference / (1000 * 60 * 60 * 24) < 1) {
        trDate = '${(difference / (1000 * 60 * 60)).round()} hours ago';
      } else if (difference / (1000 * 60 * 60 * 24 * 30) < 1) {
        trDate = '${(difference / (1000 * 60 * 60 * 24)).round()} days ago';
      } else if (difference / (1000 * 60 * 60 * 24 * 30) >= 1) {
        trDate =
            '${(difference / (1000 * 60 * 60 * 24 * 30)).round()} months ago';
      }
    } catch (e) {}
    return trDate;
  }

  changeTimeType({var d, bool type = false}) {
    var time = DateTime.parse(d.toDate().toString());
    var formattedTime =
        DateFormat('yyyy-MM-dd kk:mm:ss.SSS').format(time).toString();
    if (type) {
      return formattedTime;
    } else {
      return DateTime.parse(formattedTime).millisecondsSinceEpoch;
    }
  }

  getNowTime() async {
    await FirebaseFirestore.instance
        .collection(Helper.adminPanel)
        .doc(Helper.timeNow)
        .update({
      'time': FieldValue.serverTimestamp(),
    });
    var snapShot = await FirebaseFirestore.instance
        .collection(Helper.adminPanel)
        .doc(Helper.timeNow)
        .get();
    var nowTime = snapShot.data()!['time'];
    return nowTime;
  }

  Future<bool> uploadPicture(String where, String what, String url) async {
    switch (where) {
      case 'group':
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
  Future<Map> createEvent(context, Map<String, dynamic> eventData) async {
    if (eventData['eventName'] == null || eventData['eventName'] == '') {
      return {
        'msg': 'Please add your event name',
        'result': false,
      };
    } else if (eventData['eventLocation'] == null ||
        eventData['eventLocation'] == '') {
      return {
        'msg': 'Please add your event location',
        'result': false,
      };
    } else if (eventData['eventStartDate'] == null ||
        eventData['eventStartDate'] == '') {
      return {
        'msg': 'Please add your event start date',
        'result': false,
      };
    } else if (eventData['eventEndDate'] == null ||
        eventData['eventEndDate'] == '') {
      return {
        'msg': 'Please add your event end date',
        'result': false,
      };
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
    Map<String, dynamic> notificationData;
    String id = '';
    await FirebaseFirestore.instance
        .collection(Helper.eventsField)
        .add(eventData)
        .then((value) async => {
              notificationData = {
                'postType': 'events',
                'postId': value.id,
                'postAdminId': UserManager.userInfo['uid'],
                'notifyTime': DateTime.now().toString(),
                'tsNT': DateTime.now().millisecondsSinceEpoch,
                'userList': [],
                'timeStamp': FieldValue.serverTimestamp(),
              },
              saveNotifications(notificationData),
              id = value.id,
            });
    return {
      'msg': 'Successfully created',
      'result': true,
      'value': id,
    };
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
      Helper.showToast('Uninterested event');
      return true;
    } else {
      interested.add({
        'uid': UserManager.userInfo['uid'],
      });
      await FirebaseFirestore.instance
          .collection(Helper.eventsField)
          .doc(eventId)
          .update({'eventInterested': interested});
      Helper.showToast('Interested event');
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
  Future<Map> createPage(context, Map<String, dynamic> pageData) async {
    if (pageData['pageName'] == null || pageData['pageName'] == '') {
      return {
        'msg': 'Please add your page name',
        'result': false,
      };
    } else if (pageData['pageUserName'] == null ||
        pageData['pageUserName'] == '') {
      return {
        'msg': 'Please add your page user name',
        'result': false,
      };
    } else if (pageData['pageLocation'] == null ||
        pageData['pageLocation'] == '') {
      return {
        'msg': 'Please add your page location',
        'result': false,
      };
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
      return {
        'msg': 'Page Name should be unique',
        'result': false,
      };
    }
    Map<String, dynamic> notificationData;
    String id = '';
    await FirebaseFirestore.instance
        .collection(Helper.pagesField)
        .add(pageData)
        .then((value) => {
              notificationData = {
                'postType': 'pages',
                'postId': value.id,
                'postAdminId': UserManager.userInfo['uid'],
                'notifyTime': DateTime.now().toString(),
                'tsNT': DateTime.now().millisecondsSinceEpoch,
                'userList': [],
                'timeStamp': FieldValue.serverTimestamp(),
              },
              saveNotifications(notificationData),
              id = value.id,
            });
    return {
      'msg': 'Page was created successfully',
      'result': true,
      'value': id,
    };
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
      Helper.showToast('Unliked page');
      return true;
    } else {
      liked.add({
        'uid': UserManager.userInfo['uid'],
      });
      await FirebaseFirestore.instance
          .collection(Helper.pagesField)
          .doc(pageId)
          .update({'pageLiked': liked});
      Helper.showToast('Liked page');
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
    });

    return realAllGroups;
  }

  //get one group function that using uid of firebase database
  Future<bool> getSelectedGroup(String name) async {
    // name = name.split('/')[name.split('/').length - 1];
    // viewGroupName = name;
    var reuturnValue = await Helper.groupsData.doc(name).get();
    var value = reuturnValue.data();
    viewGroupId = name;
    group = value;
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
    return true;
  }

  //create group function
  Future<Map> createGroup(context, Map<String, dynamic> groupData) async {
    if (groupData['groupName'] == null || groupData['groupName'] == '') {
      return {
        'msg': 'Please add your group name',
        'result': false,
      };
    } else if (groupData['groupLocation'] == null ||
        groupData['groupLocation'] == '') {
      return {
        'msg': 'Please add your group location',
        'result': false,
      };
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
        .where('groupName', isEqualTo: groupData['groupName'])
        .get();
    var value = reuturnValue.docs;
    if (value.isNotEmpty) {
      return {
        'msg': 'Group name already exist',
        'result': false,
      };
    }
    Map<String, dynamic> notificationData;
    String id = '';
    await FirebaseFirestore.instance
        .collection(Helper.groupsField)
        .add(groupData)
        .then((value) async => {
              notificationData = {
                'postType': 'groups',
                'postId': value.id,
                'postAdminId': UserManager.userInfo['uid'],
                'notifyTime': DateTime.now().toString(),
                'tsNT': DateTime.now().millisecondsSinceEpoch,
                'userList': [],
                'timeStamp': FieldValue.serverTimestamp(),
              },
              saveNotifications(notificationData),
              id = value.id,
            });
    return {
      'msg': 'Successfully created',
      'result': true,
      'value': id,
    };
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
      Helper.showToast('Leaved group');
      return true;
    } else {
      joined.add({
        'uid': UserManager.userInfo['uid'],
      });
      await FirebaseFirestore.instance
          .collection(Helper.groupsField)
          .doc(groupId)
          .update({'groupJoined': joined});
      Helper.showToast('Joined group');
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

  Future<Map> createProduct(context, Map<String, dynamic> productData) async {
    if (productData['productName'] == null ||
        productData['productName'] == '') {
      return {
        'msg': 'Please add your product name',
        'result': false,
      };
    } else if (productData['productPrice'] == null ||
        productData['productPrice'] == '') {
      return {
        'msg': 'Please add your product price',
        'result': false,
      };
    } else if (productData['productCategory'] == null ||
        productData['productCategory'] == '') {
      return {
        'msg': 'Please add your product category',
        'result': false,
      };
    } else if (productData['productLocation'] == null ||
        productData['productLocation'] == '') {
      return {
        'msg': 'Please add your product location',
        'result': false,
      };
    }
    productData = {
      ...productData,
      'productAdmin': {
        'uid': UserManager.userInfo['uid'],
      },
      'productDate': FieldValue.serverTimestamp(),
      'productPost': false,
      'productMarkAsSold': false,
      'productTimeline': true,
      'productOnOffCommenting': true,
      'productPrivacy': 'Public'
    };
    Map<String, dynamic> postData = {};
    Map<String, dynamic> notificationData;
    String id = '';
    await FirebaseFirestore.instance
        .collection(Helper.productsField)
        .add(productData)
        .then((value) async => {
              postData = {
                'postAdmin': UserManager.userInfo['uid'],
                'type': 'product',
                'value': value.id,
                'privacy': 'Public',
                'postTime': FieldValue.serverTimestamp(),
                'header': productData['productName'],
                'timeline': true,
                'comment': true,
              },
              await Helper.postCollection.add(postData),
              notificationData = {
                'postType': 'products',
                'postId': value.id,
                'postAdminId': UserManager.userInfo['uid'],
                'notifyTime': DateTime.now().toString(),
                'tsNT': DateTime.now().millisecondsSinceEpoch,
                'userList': [],
                'timeStamp': FieldValue.serverTimestamp(),
              },
              saveNotifications(notificationData),
              id = value.id,
            });
    // RelysiaManager.payNow(UserManager.userInfo, RelysiaManager.adminPaymail,
    //     '10', 'for create product');
    return {
      'msg': 'Successfully created',
      'result': true,
      'value': id,
    };
  }

  Future<Map> editProduct(
      context, uid, Map<String, dynamic> productData) async {
    if (productData['productName'] == null ||
        productData['productName'] == '') {
      return {
        'msg': 'Please add your product name',
        'result': false,
      };
    } else if (productData['productPrice'] == null ||
        productData['productPrice'] == '') {
      return {
        'msg': 'Please add your product price',
        'result': false,
      };
    } else if (productData['productCategory'] == null ||
        productData['productCategory'] == '') {
      return {
        'msg': 'Please add your product category',
        'result': false,
      };
    }

    Map<String, dynamic> notificationData;
    await FirebaseFirestore.instance
        .collection(Helper.productsField)
        .doc(uid)
        .update(productData);
    return {
      'msg': 'Successfully edited',
      'result': true,
      'value': uid,
    };
  }

  List<Map> allProduct = [];

  //get all product function
  Future<void> getProduct() async {
    allProduct = [];
    await Helper.productsData
        .orderBy('productDate', descending: true)
        .get()
        .then((value) async {
      var doc = value.docs;
      for (int i = 0; i < doc.length; i++) {
        var id = doc[i].id;
        var data = doc[i];
        var adminInfo =
            await ProfileController().getUserInfo(data['productAdmin']['uid']);
        allProduct.add({'data': data.data(), 'id': id, 'adminInfo': adminInfo});
        setState(() {});
      }
      print('Now you get all products');
    });
  }

  var viewProductId;
  var product;
  var productAdmin;
  //get one page function that using uid of firebase database
  Future<bool> getSelectedProduct(String name) async {
    name = name.split('/')[name.split('/').length - 1];
    viewProductId = name;
    var reuturnValue = await Helper.productsData.doc(viewProductId).get();
    var value = reuturnValue.data();
    product = value;
    var adminInfo =
        await ProfileController().getUserInfo(product['productAdmin']['uid']);
    productAdmin = adminInfo;
    setState(() {});
    print('This product was posted by ${product['productAdmin']}');
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

  savePost(type, value, privacy, {header = ''}) async {
    Map<String, dynamic> postData = {};
    postData = {
      'postAdmin': UserManager.userInfo['uid'],
      'type': type,
      'value': value,
      'privacy': privacy,
      'postTime': FieldValue.serverTimestamp(),
      'header': header,
      'timeline': true,
      'comment': true,
    };
    Helper.postCollection.add(postData);
    setState(
      () {},
    );
    return true;
  }

  var lastTime;
  getAllPost(type) async {
    var allSanp =
        await Helper.postCollection.orderBy('postTime', descending: true).get();

    var allPosts = allSanp.docs;
    allposts = 0;
    for (var i = 0; i < allSanp.docs.length; i++) {
      if (type == 0) {
        if (allPosts[i]['postAdmin'] == UserManager.userInfo['uid'] ||
            allPosts[i]['privacy'] == 'Public') {
          allposts++;
        }
      } else if (type == 1) {
        if (allPosts[i]['postAdmin'] == UserManager.userInfo['uid']) allposts++;
      }
    }

    var postData;
    var adminInfo;
    var postsBox = [];
    int i = 0;
    //int firstlength = allSanp.docs.length > 10 ? 10 : allSanp.docs.length;

    //for (var i = 0; i < firstlength; i++) {
    do {
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
        'comment': allPosts[i]['comment'],
      };

      if (type == 0) {
        if (eachPost['adminUid'] == UserManager.userInfo['uid'] ||
            eachPost['privacy'] == 'Public') {
          postsBox.add(eachPost);
        }
      } else if (type == 1) {
        if (eachPost['adminUid'] == UserManager.userInfo['uid']) {
          postsBox.add(eachPost);
        }
      }
      lastTime = allPosts[i]['postTime'];
      i++;
    } while (postsBox.length < 10 && i < allSanp.docs.length);

    posts = postsBox;
    setState(() {});
    return true;
  }

  addNewPosts(newCount) async {
    var allSanp = await Helper.postCollection
        .orderBy('postTime', descending: true)
        .limit(newCount)
        .get();
    var allPosts = allSanp.docs;
    var postData;
    var adminInfo;
    for (var i = 0; i < newCount; i++) {
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

      print("adminsnapid:");
      print(adminSnap.id);
      if (eachPost['adminUid'] == UserManager.userInfo['uid'] ||
          eachPost['privacy'] == 'Public') {
        setState(() {
          posts = [eachPost, ...posts];
        });
      }
    }

    return posts;
  }

  loadNextPosts(newCount, type) async {
    var allSanp = await Helper.postCollection
        .orderBy('postTime', descending: true)
        .where('postTime', isLessThan: lastTime)
        .limit(newCount)
        .get();
    var allPosts = allSanp.docs;
    var postData;
    var adminInfo;
    int i = 0;
    int newitemindex = 0;
    do {
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
      if (adminInfo == null) continue;
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

      lastTime = allPosts[allPosts.length - 1]['postTime'];
      if (type == 0) {
        if (eachPost['adminUid'] == UserManager.userInfo['uid'] ||
            eachPost['privacy'] == 'Public') {
          posts.add(eachPost);
          newitemindex++;
        }
      } else if (type == 1) {
        if (eachPost['adminUid'] == UserManager.userInfo['uid']) {
          posts.add(eachPost);
          newitemindex++;
        }
      }
      print("i----------$i");
      print("newCount----------$newCount");
    } while (++i < newCount);
    setState(() {});
    return true;
  }

  updatePostInfo(uid, value) async {
    await Helper.postCollection.doc(uid).update(value);
  }

  updateProductInfo(uid, value) async {
    await Helper.productsData.doc(uid).update(value);
  }

  deletePost(uid) async {
    Helper.postCollection.doc(uid).delete();
  }

  deletePostFromTimeline(post) {
    posts.removeWhere((item) => item['id'] == post['id']);
    allposts--;
    setState(() {});
  }

  deleteProduct(uid) async {
    await Helper.productsData.doc(uid).delete();
    posts.removeWhere((item) => item['id'] == uid);
  }

  String postId = '';
  Map post = {};
  getSelectedPost(uid) async {
    var postSnap = await Helper.postCollection.doc(uid).get();
    var postData = postSnap.data();
    var adminSnap =
        await Helper.userCollection.doc(postData!['postAdmin']).get();
    var adminInfo = adminSnap.data();
    var eachPost = {
      'id': postSnap.id,
      'data': postData['value'],
      'type': postData['type'],
      'adminInfo': adminInfo,
      'time': postData['postTime'],
      'adminUid': adminSnap.id,
      'privacy': postData['privacy'],
      'header': postData['header'],
      'timeline': postData['timeline'],
      'comment': postData['comment']
    };
    post = eachPost;
    setState(() {});
  }

  loadPostLikes(postId) async {
    var snapshot = await Helper.postLikeComment.doc(postId).get();
    var allLikesofProduct = snapshot.data();

    if (allLikesofProduct == null) return;

    List likesdata = [];
    for (var entry in allLikesofProduct.entries) {
      var userInfo = await ProfileController().getUserInfo(entry.key);

      likesdata.add({
        'userInfo': userInfo,
        'value': entry.value,
      });
    }

    likes[postId] = likesdata;

    setState(() {});
  }

  var commentLikes = {};
  var commentLikesCount = {};
  loadComments(postId) async {
    var userInfo = UserManager.userInfo;
    var snapshot = await Helper.postLikeComment
        .doc(postId)
        .collection('comments')
        .orderBy('timeStamp', descending: true)
        .get();
    var comment = [];
    if (snapshot.docs.isEmpty) return [];

    for (int i = 0; i < snapshot.docs.length; i++) {
      var userINFO = await ProfileController()
          .getUserInfo(snapshot.docs[i]['data']['uid']);
      var reply = [];
      reply = await getReply(postId, snapshot.docs[i].id);

      comment.add({
        'data': snapshot.docs[i]['data'],
        'userInfo': userINFO!,
        'id': snapshot.docs[i].id,
        'reply': reply,
        'likes': snapshot.docs[i]['likes']
      });
      List likesdata = [];
      for (var j = 0; j < snapshot.docs[i]['likes'].length; j++) {
        var userInfo = await ProfileController()
            .getUserInfo(snapshot.docs[i]['likes'][j]['userInfo']);

        likesdata.add({
          'userInfo': userInfo,
          'uid': snapshot.docs[i]['likes'][j]['userInfo'],
          'value': snapshot.docs[i]['likes'][j]['value'],
        });
      }

      //commentLikes[snapshot.docs[i].id] = snapshot.docs[i]['likes'];
      commentLikes[snapshot.docs[i].id] = likesdata;
    }
    comments[postId] = comment;
    setState(() {});
  }

  savePostLikes(postId, like) async {
    print("save post likes");
    var userInfo = UserManager.userInfo;
    var snapshot = await Helper.postLikeComment.doc(postId).get();
    Map<String, dynamic> gotLikes = snapshot.data() ?? {};
    List likesdata = likes[postId] ?? [];
    likesdata.removeWhere(
        (item) => item['userInfo']['userName'] == userInfo['userName']);

    if (gotLikes[userInfo['uid']] == like) {
      gotLikes.removeWhere((key, value) => key == userInfo['uid']);
    } else {
      gotLikes[userInfo['uid']] = like;

      likesdata.add({
        'userInfo': userInfo,
        'value': like,
      });

      likes[postId] = likesdata;
    }

    await Helper.postLikeComment.doc(postId).set(gotLikes);
    setState(() {});
  }

  saveComment(postId, data, type) async {
    var snapshot = await Helper.postLikeComment.get();
    var userManager = UserManager.userInfo;
    var existId = false;
    var comment = [];

    comment = comments[postId] ?? [];

    for (int i = 0; i < snapshot.docs.length; i++) {
      if (snapshot.docs[i].id == postId) {
        existId = true;

        break;
      }
    }

    var reply = [];
    //  await getReply(postId, snapshot.docs[i].id).then((value) {
    //    reply = value;
    //  });
    print("comment-------------$userManager");
    comment.insert(0, {
      'data': {'uid': userManager['uid'], 'content': data, 'type': type},
      'userInfo': userManager,
      'id': postId,
      'reply': reply,
      'likes': [],
    });
    print("comment- added------------$comment");
    // if (!existId) {
    //   await Helper.postLikeComment.doc(postId).set({'likes': {}});
    // }
    await Helper.postLikeComment.doc(postId).collection('comments').doc().set({
      'data': {'type': type, 'content': data, 'uid': userManager['uid']},
      'timeStamp': FieldValue.serverTimestamp(),
      'likes': []
    });
    comments[postId] = comment;
    setState(() {});
  }

  saveLikesComment(postId, commentId, likes) async {
    var userInfo = UserManager.userInfo;
    var snapshot = await Helper.postLikeComment
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .get();
    var data = snapshot.data();

    //Map<String, dynamic> gotLikes = snapshot.data() ?? {};
    if (data != null) {
      List commentLike = data['likes'] ?? [];

      //List likesdata = likes[postId] ?? [];
      for (var i = 0; i < commentLike.length; i++) {
        if (commentLike[i]['userInfo'] == userInfo['uid']) {
          commentLike.removeAt(i);
        }
      }
      // commentLike.removeWhere(
      //      (item) => item['userInfo']['userName'] == userInfo['uid']);

      // if (gotLikes[userInfo['uid']] == like) {
      //   gotLikes.removeWhere((key, value) => key == userInfo['uid']);
      // } else {
      //   gotLikes[userInfo['uid']] = like;
      List gotLike = List.from(commentLike);
      commentLike.add({
        'userInfo': userInfo,
        'uid': userInfo['uid'],
        'value': likes,
      });
      gotLike.add({
        'userInfo': userInfo['uid'],
        'value': likes,
      });

      // if (gotLikes['likes'][userInfo['uid']] == likes) {
      //   gotLikes['likes'].removeWhere((key, value) => key == userInfo['uid']);
      // } else {
      //   gotLikes['likes'][userInfo['uid']] = likes;

      print('$postId $commentId $likes');
      await Helper.postLikeComment
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .update({'likes': gotLike});

      commentLikes[commentId] = commentLike;
      print('saveLikesComment end');
      // getComment(postId);
      setState(() {});
    }
  }

  saveReply(postId, commentId, data, type) async {
    var userInfo = UserManager.userInfo;
    await Helper.postLikeComment
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .collection('reply')
        .doc()
        .set({
      'data': {'type': type, 'content': data, 'uid': userInfo['uid']},
      'timeStamp': FieldValue.serverTimestamp(),
      'likes': {}
    });

    var reply;
    await getReply(postId, commentId).then((value) {
      reply = value;

      var comment = comments[postId].firstWhere((o) => o['id'] == commentId);

      comment['reply'] = reply;
      // comments[postId].add({
      //   'data': {'type': type, 'content': data, 'uid': userInfo['uid']},
      //   'userInfo': userInfo,
      //   'id': commentId,
      //   'reply': reply,
      //   'likes': {}
      // });
      print(comments[postId]);
      setState(() {});
    });
  }

  var commentReply = {};

  Future<List> getReply(postId, commentId) async {
    var userInfo = UserManager.userInfo;
    var replies = await Helper.postLikeComment
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .collection('reply')
        .orderBy('timeStamp')
        .get();
    var arr = [];
    for (int j = 0; j < replies.docs.length; j++) {
      replyLikesCount[replies.docs[j].id] = [];
      for (int m = 0; m < replies.docs[j]['likes'].length; m++) {
        if (userInfo['uid'] == replies.docs[j]['likes'][m]['uid']) {
          replyLikes[replies.docs[j].id] = replies.docs[j]['likes'][m]['likes'];
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
      var userINFO =
          await ProfileController().getUserInfo(replies.docs[j]['data']['uid']);
      arr.add({
        'data': replies.docs[j]['data'],
        'userInfo': userINFO,
        'id': replies.docs[j].id
      });
    }

    return arr;
  }

  saveLikesReply(postId, commentId, replyId, likes) async {
    var userInfo = UserManager.userInfo;
    var snapshot = await Helper.postLikeComment
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .collection('reply')
        .doc(replyId)
        .get();
    var arr = snapshot.data()!['likes'];
    var a = [];
    var aa = [];
    if (arr == null || arr.length == 0) {
      print(" arr empty");
    } else {
      aa = arr.where((val) => val['uid'] == userInfo['uid']).toList();
    }
    if (aa.isEmpty) {
      a.add({'uid': userInfo['uid'], 'likes': likes});
    }
    for (int i = 0; i < arr.length; i++) {
      var s = arr[i]['likes'];
      if (arr[i]['uid'] == userInfo['uid']) {
        s = likes;
      }
      a.add({'uid': arr[i]['uid'], 'likes': s});
    }
    await Helper.postLikeComment
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .collection('reply')
        .doc(replyId)
        .update({'likes': a});
    setState(() {});
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

  Future checkNotify() async {
    try {
      var serverTime = await getNowTime();
      var serverTimeStamp = await changeTimeType(d: serverTime);
      await FirebaseFirestore.instance
          .collection(Helper.userField)
          .doc(UserManager.userInfo['uid'])
          .update({'checkNotifyTime': serverTimeStamp});
      realNotifi = [];
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  getPostData(data) async {
    var fData = await Helper.notifiCollection.doc(data['postId']).get();
    var eachPost = fData.data();
    return eachPost;
  }
}
