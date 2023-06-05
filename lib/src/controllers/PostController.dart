// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/views/events/panel/eventView/eventTimelineScreen.dart';
import '../helpers/helper.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import '../views/profile/model/friends.dart';

enum PostType { timeline, profile, event, group }

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
  var postsTimeline = [];
  var postsProfile = [];
  var postsEvent = [];
  var postsGroup = [];
  var replyLikes = {};
  var where = PostType.timeline.index;
  var replyLikesCount = {};
  Map likes = {};
  Map comments = {};

  List unlikedPages = [];
  List unJoindGroups = [];
  List unInterestedEvents = [];
  List<mvc.StateMVC> notifiers;
  var serverTimeStamp;
  @override
  Future<bool> initAsync() async {
    //
    Helper.eventsData =
        FirebaseFirestore.instance.collection(Helper.eventsField);
    return true;
  }

  getServerTime() async {
    var serverTime = await getNowTime();
    serverTimeStamp = await changeTimeType(d: serverTime);
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

  String timeAgo(Timestamp timestamp) {
    DateTime now = DateTime.now();

    DateTime time = timestamp.toDate();

    Duration difference = now.difference(time);
    int days = difference.inDays;
    int hours = difference.inHours;

    int minutes = difference.inMinutes.remainder(60);

    if (days > 0) {
      return "$days day${days > 1 ? 's' : ''} ago";
    } else if (hours > 0) {
      return "$hours hour${hours > 1 ? 's' : ''} ago";
    } else if (minutes > 0) {
      return "$minutes minute${minutes > 1 ? 's' : ''} ago";
    } else {
      return "Just Now";
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
    List<Map> realAllEvents = [];
    await Helper.eventsData.get().then((value) async {
      var doc = value.docs;
      print("length is ${doc.length}");
      for (int i = 0; i < doc.length; i++) {
        dynamic value = doc[i].data();
        var id = doc[i].id;
        var data = value;
        var interested = boolInterested(data, UserManager.userInfo['uid']);
        //closed event
        if (data['eventPrivacy'] == 'closed') {
          if (data['eventAdmin'][0]['uid'] == uid && condition == 'manage') {
            realAllEvents
                .add({'data': data, 'id': id, 'interested': interested});
          }
        }
        //security event
        else /*if (data['eventPrivacy'] == 'security') */ {
          var inInterested = boolInterested(data, UserManager.userInfo['uid']);
          var inInvited = boolInvited(data, UserManager.userInfo['uid']);
          var inGoing = boolGoing(data, UserManager.userInfo['uid']);
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
            if (data['eventPrivacy'] == 'public') {
              //&& data['eventPost'] == true) {
              if (!inInterested &&
                  !inGoing &&
                  !inInvited &&
                  uid != data['eventAdmin'][0]['uid']) {
                realAllEvents
                    .add({'data': data, 'id': id, 'interested': interested});
              }
            }
          } else if (condition == 'unInterested' &&
              !interested &&
              realAllEvents.length < 5) {
            realAllEvents.add({'data': data, 'id': id});
          }
          setState(() {});
        }
      }
    });

    return realAllEvents;
  }

  //get one event function that using uid of firebase database
  Map getSuchEvent(String id) {
    id = id.split('/')[id.split('/').length - 1];
    viewEventId = id;

    Helper.eventsData.doc(id).get().then((value) {
      return value.data();
    });
    return {};
  }

  Map getSuchGroup(String id) {
    id = id.split('/')[id.split('/').length - 1];
    viewGroupId = id;

    Helper.groupsData.doc(id).get().then((value) {
      return value.data();
    });

    return {};
  }

  Future<bool> getSelectedEvent(String id) async {
    id = id.split('/')[id.split('/').length - 1];
    viewEventId = id;

    await Helper.eventsData.doc(id).get().then((value) async {
      event = value.data();
      viewEventInterested = boolInterested(value, UserManager.userInfo['uid']);
      viewEventGoing = boolGoing(value, UserManager.userInfo['uid']);
      viewEventInvited = boolInvited(value, UserManager.userInfo['uid']);
      for (var i = 0; i < event['eventAdmin'].length; i++) {
        var addAdmin = await ProfileController()
            .getUserInfo(event['eventAdmin'][i]['uid']);
        if (addAdmin != null) {
          event['eventAdmin'][i] = {
            ...event['eventAdmin'][i],
            'userName': addAdmin['userName'],
            'avatar': addAdmin['avatar'],
            'fullName': '${addAdmin["firstName"]} ${addAdmin["lastName"]}',
          };
        } else {
          event['eventAdmin'].removeWhere(
              (item) => item['uid'] == event['eventAdmin'][i]['uid']);
          i--;
        }
      }

      for (var i = 0; i < event['eventInterested'].length; i++) {
        var addAdmin = await ProfileController()
            .getUserInfo(event['eventInterested'][i]['uid']);
        if (addAdmin != null) {
          event['eventInterested'][i] = {
            ...event['eventInterested'][i],
            'userName': addAdmin['userName'],
            'avatar': addAdmin['avatar'],
            'fullName': '${addAdmin["firstName"]} ${addAdmin["lastName"]}',
          };
        } else {
          event['eventInterested'].removeWhere(
              (item) => item['uid'] == event['eventInterested'][i]['uid']);
          i--;
        }
      }

      for (var i = 0; i < event['eventGoing'].length; i++) {
        var addAdmin = await ProfileController()
            .getUserInfo(event['eventGoing'][i]['uid']);
        if (addAdmin != null) {
          event['eventGoing'][i] = {
            ...event['eventGoing'][i],
            'userName': addAdmin['userName'],
            'avatar': addAdmin['avatar'],
            'fullName': '${addAdmin["firstName"]} ${addAdmin["lastName"]}',
          };
        } else {
          event['eventGoing'].removeWhere(
              (item) => item['uid'] == event['eventGoing'][i]['uid']);
          i--;
        }
      }

      for (var i = 0; i < event['eventInvited'].length; i++) {
        var addAdmin = await ProfileController()
            .getUserInfo(event['eventInvited'][i]['uid']);
        if (addAdmin != null) {
          event['eventInvited'][i] = {
            ...event['eventInvited'][i],
            'userName': addAdmin['userName'],
            'avatar': addAdmin['avatar'],
            'fullName': '${addAdmin["firstName"]} ${addAdmin["lastName"]}',
          };
        } else {
          event['eventInvited'].removeWhere(
              (item) => item['uid'] == event['eventInvited'][i]['uid']);
          i--;
        }
      }

      for (var i = 0; i < event['eventInvites'].length; i++) {
        var addAdmin = await ProfileController()
            .getUserInfo(event['eventInvites'][i]['uid']);
        if (addAdmin != null) {
          event['eventInvites'][i] = {
            ...event['eventInvites'][i],
            'userName': addAdmin['userName'],
            'avatar': addAdmin['avatar'],
            'fullName': '${addAdmin["firstName"]} ${addAdmin["lastName"]}',
          };
        } else {
          event['eventInvited'].removeWhere(
              (item) => item['uid'] == event['eventInvited'][i]['uid']);
          i--;
        }
      }
      setState(() {});
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
      'eventPost': true,
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
              await getServerTime(),
              notificationData = {
                'postType': 'events',
                'postId': value.id,
                'postAdminId': UserManager.userInfo['uid'],
                'notifyTime': DateTime.now().toString(),
                'tsNT': serverTimeStamp,
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

    return doc;
  }

  ////////////////////functions that support for making comment to event/////////////////////////////

  //user join in event interested function
  Future<bool> interestedEvent(String eventId) async {
    var querySnapshot = await Helper.eventsData.doc(eventId).get();
    var doc = querySnapshot;
    var interested = doc['eventInterested'];
    var respon = boolInterested(doc, UserManager.userInfo['uid']);
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
  bool boolInterested(var eventData, String uid) {
    var interested = eventData['eventInterested'];
    if (interested == null) {
      return false;
    }
    var returnData = interested.where((eachUser) => eachUser['uid'] == uid);

    if (returnData.length == 0) {
      return false;
    } else {
      return true;
    }
  }

  //user join in event going function
  Future<bool> goingEvent(String eventId) async {
    var querySnapshot = await Helper.eventsData.doc(eventId).get();
    var doc = querySnapshot;
    var going = doc['eventGoing'];
    var respon = boolGoing(doc, UserManager.userInfo['uid']);
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
  bool boolGoing(var eventData, String uid) {
    var going = eventData['eventGoing'];
    if (going == null) {
      return false;
    }
    var returnData = going.where((eachUser) => eachUser['uid'] == uid);

    if (returnData.length == 0) {
      return false;
    } else {
      return true;
    }
  }

  //user  join in event invited function
  Future<bool> invitedEvent(String eventId) async {
    var querySnapshot = await Helper.eventsData.doc(eventId).get();
    var doc = querySnapshot;
    var invited = doc['eventInvited'];
    var respon = boolInvited(doc, UserManager.userInfo['uid']);
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
  bool boolInvited(var eventData, String uid) {
    var invited = eventData['eventInvited'];
    if (invited == null) {
      return false;
    }
    var returnData = invited.where((eachUser) => eachUser['uid'] == uid);

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

  Future<bool> deletePostOfEvent() async {
    await FirebaseFirestore.instance
        .collection(Helper.postField)
        .where('eventId', isEqualTo: viewEventId)
        .get()
        .then((snapshot) {
      for (var i = 0; i < snapshot.docs.length; i++) {
        snapshot.docs[i].reference.delete();
      }
    });
    return true;
  }

  Future<bool> deleteGroup() async {
    await FirebaseFirestore.instance
        .collection(Helper.groupsField)
        .doc(viewGroupId)
        .delete();
    return true;
  }

  Future<bool> deletePostOfGroup() async {
    await FirebaseFirestore.instance
        .collection(Helper.postField)
        .where('groupId', isEqualTo: viewGroupId)
        .get()
        .then((snapshot) {
      for (var i = 0; i < snapshot.docs.length; i++) {
        snapshot.docs[i].reference.delete();
      }
    });
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

    setState(() {});

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
        .then((value) async => {
              await getServerTime(),
              notificationData = {
                'postType': 'pages',
                'postId': value.id,
                'postAdminId': UserManager.userInfo['uid'],
                'notifyTime': DateTime.now().toString(),
                'tsNT': serverTimeStamp,
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
    var querySnapshot = await Helper.pagesData.doc(pageId).get();
    var doc = querySnapshot;
    var liked = doc['pageLiked'];
    var respon = await boolLiked(doc, UserManager.userInfo['uid']);

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

    if (returnData.length == 0) {
      return false;
    } else {
      return true;
    }
  }

  Future<String> updatePageInfo(dynamic pageInfo) async {
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
        var joined = boolJoined(data, UserManager.userInfo['uid']);
        if (uid == data['groupAdmin'][0]['uid'] && condition == 'manage') {
          realAllGroups.add({'data': data, 'id': id, 'joined': joined});
        } else if (condition == 'all' && uid != data['groupAdmin'][0]['uid']) {
          if (data['groupPost']) {
            if (!joined && uid != data['groupAdmin'][0]['uid']) {
              realAllGroups.add({'data': data, 'id': id, 'joined': joined});
            }
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

  Future<bool> getSelectedGroup(String id) async {
    id = id.split('/')[id.split('/').length - 1];
    var reuturnValue;

    await Helper.groupsData.doc(id).get().then((value1) async {
      reuturnValue = value1;
      var value = reuturnValue.data();
      viewGroupId = id;
      group = value;
      viewGroupJoined = boolJoined(group, UserManager.userInfo['uid']);
      setState(() {});
      for (var i = 0; i < group['groupAdmin'].length; i++) {
        var addAdmin = await ProfileController()
            .getUserInfo(group['groupAdmin'][i]['uid']);
        if (addAdmin != null) {
          group['groupAdmin'][i] = {
            ...group['groupAdmin'][i],
            'userName': addAdmin['userName'],
            'avatar': addAdmin['avatar'],
          };
        } else {
          group['groupAdmin'].removeWhere(
              (item) => item['uid'] == group['groupAdmin'][i]['uid']);
          i--;
        }
      }

      for (var i = 0; i < group['groupJoined'].length; i++) {
        var groupUser = await ProfileController()
            .getUserInfo(group['groupJoined'][i]['uid']);
        if (groupUser != null) {
          group['groupJoined'][i] = {
            ...group['groupJoined'][i],
            'userName': groupUser['userName'] ?? '',
            'avatar': groupUser['avatar'] ?? '',
            'fullName': '${groupUser["firstName"]} ${groupUser["lastName"]}'
          };
        } else {
          group['groupJoined'].removeWhere(
              (item) => item['uid'] == group['groupJoined'][i]['uid']);
          i--;
        }
      }

      for (var i = 0; i < group['groupInvites'].length; i++) {
        var groupUser = await ProfileController()
            .getUserInfo(group['groupInvites'][i]['uid']);
        if (groupUser != null) {
          group['groupInvites'][i] = {
            ...group['groupInvites'][i],
            'userName': groupUser['userName'] ?? '',
            'avatar': groupUser['avatar'] ?? '',
            'fullName': '${groupUser["firstName"]} ${groupUser["lastName"]}'
          };
        } else {
          group['groupInvites'].removeWhere(
              (item) => item['uid'] == group['groupInvites'][i]['uid']);
          i--;
        }
      }
      setState(() {});
    });
    return true;
  }

  //create group function
  Future<Map> createGroup(context, Map<String, dynamic> groupData,
      {bool canCreate = false}) async {
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
      'groupInvites': [],
      'groupPost': true,
      'groupPicture': '',
      'groupCover': '',
      'groupPhotos': [],
      'groupAlbums': [],
      'groupVideos': [],
      'groupCanPub': true,
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
    if (canCreate) {
      return {
        'msg': 'You can create group',
        'result': canCreate,
      };
    }
    Map<String, dynamic> notificationData;
    String id = '';
    await FirebaseFirestore.instance
        .collection(Helper.groupsField)
        .add(groupData)
        .then((value) async => {
              await getServerTime(),
              notificationData = {
                'postType': 'groups',
                'postId': value.id,
                'postAdminId': UserManager.userInfo['uid'],
                'notifyTime': DateTime.now().toString(),
                'tsNT': serverTimeStamp,
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
    var querySnapshot = await Helper.groupsData.doc(groupId).get();
    var doc = querySnapshot;
    var joined = doc['groupJoined'];
    var respon = boolJoined(doc, UserManager.userInfo['uid']);
    if (respon) {
      joined.removeWhere((item) => item['uid'] == UserManager.userInfo['uid']);
      await FirebaseFirestore.instance
          .collection(Helper.groupsField)
          .doc(groupId)
          .update({'groupJoined': joined});
      Helper.showToast('Leaved group');
      setState(() {});
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
      setState(() {});
      return true;
    }
  }

  //user invite in group liked function
  Future<bool> inviteGroup(String groupId, userId) async {
    var querySnapshot = await Helper.groupsData.doc(groupId).get();
    var doc = querySnapshot;
    var invited = doc['groupInvites'];
    var respon = boolInvitedGroup(doc, userId);
    if (respon) {
      invited.removeWhere((item) => item['uid'] == userId);
      await FirebaseFirestore.instance
          .collection(Helper.groupsField)
          .doc(groupId)
          .update({'groupInvites': invited});
      Helper.showToast('Remove Invited group');
      setState(() {});
      return false;
    } else {
      invited.add({
        'uid': userId,
      });
      await FirebaseFirestore.instance
          .collection(Helper.groupsField)
          .doc(groupId)
          .update({'groupInvites': invited});
      Helper.showToast('Invited group');
      setState(() {});
      return true;
    }
  }

  //bool of user already in group interested or not
  bool boolJoined(var groupData, String uid) {
    var joined = groupData['groupJoined'];
    if (joined == null) {
      return false;
    }
    var returnData = joined.where((eachUser) => eachUser['uid'] == uid);
    if (returnData.length == 0) {
      return false;
    } else {
      return true;
    }
  }

  //bool of user already in group invite or not
  bool boolInvitedGroup(var groupData, String uid) {
    var invited = groupData['groupInvites'];
    if (invited == null) {
      return false;
    }
    var returnData = invited.where((eachUser) => eachUser['uid'] == uid);
    if (returnData.length == 0) {
      return false;
    } else {
      return true;
    }
  }

  Future<String> updateGroupInfo(dynamic groupInfo) async {
    // if (groupInfo['groupUserName'] == null) {
    FirebaseFirestore.instance
        .collection(Helper.groupsField)
        .doc(viewGroupId)
        .update(groupInfo)
        .then((value) async {
      await updateGroup();
    });
    Helper.showToast('Successfully updated');
    return viewGroupId;
    // }
    // if (groupInfo['groupUserName'] == group['groupUserName']) {
    //   var result = await Helper.groupsData.doc(viewGroupId).update(groupInfo);
    //   await updateGroup();
    //   return group['groupUserName'];
    // } else {
    //   QuerySnapshot querySnapshot = await Helper.groupsData.get();
    //   var allGroup = querySnapshot.docs;
    //   var flag = allGroup.where((eachGroup) =>
    //       eachGroup['groupUserName'] == groupInfo['groupUserName']);
    //   if (flag.isNotEmpty) {
    //     await updateGroup();
    //     return 'dobuleName${groupInfo['groupUserName']}';
    //   } else {
    //     await updateGroup();
    //     var result = await Helper.groupsData.doc(viewGroupId).update(groupInfo);

    //     return groupInfo['groupUserName'];
    //   }
    // }
  }

  Future<void> updateGroup() async {
    var doc = await FirebaseFirestore.instance
        .collection(Helper.groupsField)
        .doc(viewGroupId)
        .get();
    group = doc.data();
    setState(() {});
  }

  Future<void> updateEvent() async {
    eventTab = 'Timeline';

    var doc = await Helper.eventsData.doc(viewEventId).get();
    event = doc.data();
    setState(() {});
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
              await getServerTime(),
              notificationData = {
                'postType': 'products',
                'postId': value.id,
                'postAdminId': UserManager.userInfo['uid'],
                'notifyTime': DateTime.now().toString(),
                'tsNT': serverTimeStamp,
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

  Future<Map> createRealEstate(
      context, Map<String, dynamic> realEstateData) async {
    if (realEstateData['realEstateName'] == '' ||
        realEstateData['realEstatePrice'] == '0' ||
        realEstateData['realEstateLocation'] == '' ||
        realEstateData['realEstateAbout'] == '') {
      return {
        'msg': 'Please add your real-estate name, price, location and about',
        'result': false,
      };
    }
    realEstateData = {
      ...realEstateData,
      'realEstateAdmin': {
        'uid': UserManager.userInfo['uid'],
      },
      'realEstateDate': FieldValue.serverTimestamp(),
      'realEstatePost': false,
      'realEstateMarkAsSold': false,
      'realEstateTimeline': true,
      'realEstateOnOffCommenting': true,
      'realEstatePrivacy': 'Public'
    };
    Map<String, dynamic> postData = {};
    Map<String, dynamic> notificationData;
    String id = '';
    try {
      DocumentReference result = await FirebaseFirestore.instance
          .collection(Helper.realEstatesField)
          .add(realEstateData);
      postData = {
        'postAdmin': UserManager.userInfo['uid'],
        'type': 'real-estate',
        'value': result.id,
        'privacy': 'Public',
        'postTime': FieldValue.serverTimestamp(),
        'header': realEstateData['realEstateName'],
        'timeline': true,
        'comment': true,
      };
      await Helper.postCollection.add(postData);
      await getServerTime();
      notificationData = {
        'postType': 'realEstates',
        'postId': result.id,
        'postAdminId': UserManager.userInfo['uid'],
        'notifyTime': DateTime.now().toString(),
        'tsNT': serverTimeStamp,
        'userList': [],
        'timeStamp': FieldValue.serverTimestamp(),
      };
      await saveNotifications(notificationData);
      id = result.id;
    } catch (e) {
      return {
        'msg': 'Error creating real estate',
        'result': false,
        'error': e.toString(),
      };
    }

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

  Future<Map> editRealEstate(
      context, uid, Map<String, dynamic> realEstateData) async {
    if (realEstateData['realEstateName'] == null ||
        realEstateData['realEstateName'] == '') {
      return {
        'msg': 'Please add your real estate name',
        'result': false,
      };
    } else if (realEstateData['realEstatePrice'] == null ||
        realEstateData['realEstatePrice'] == '') {
      return {
        'msg': 'Please add your real estate price',
        'result': false,
      };
    } else if (realEstateData['realEstateCategory'] == null ||
        realEstateData['realEstateCategory'] == '') {
      return {
        'msg': 'Please add your real estate category',
        'result': false,
      };
    }

    Map<String, dynamic> notificationData;
    await FirebaseFirestore.instance
        .collection(Helper.realEstatesField)
        .doc(uid)
        .update(realEstateData);
    return {
      'msg': 'Successfully edited',
      'result': true,
      'value': uid,
    };
  }

  List<Map> allProduct = [];

  //get all product function
  Future<void> getProduct([String uid = ""]) async {
    allProduct = [];
    var query = Helper.productsData.orderBy('productDate', descending: true);
    if (uid.isNotEmpty) {
      query = query.where('productAdmin.uid', isEqualTo: uid);
    }
    await query.get().then((value) async {
      var doc = value.docs;
      for (int i = 0; i < doc.length; i++) {
        var id = doc[i].id;
        var data = doc[i];
        var adminInfo =
            await ProfileController().getUserInfo(data['productAdmin']['uid']);
        if (adminInfo != null) {
          allProduct
              .add({'data': data.data(), 'id': id, 'adminInfo': adminInfo});
        }
        setState(() {});
      }
    });
  }

  List<Map> allRealEstate = [];

  //get all product function
  Future<void> getRealEstate() async {
    allRealEstate = [];
    await Helper.realEstatesData
        .orderBy('realEstateDate', descending: true)
        .get()
        .then((value) async {
      var doc = value.docs;
      for (int i = 0; i < doc.length; i++) {
        var id = doc[i].id;
        var data = doc[i];
        var adminInfo = await ProfileController()
            .getUserInfo(data['realEstateAdmin']['uid']);
        if (adminInfo != null) {
          allRealEstate
              .add({'data': data.data(), 'id': id, 'adminInfo': adminInfo});
        }
        setState(() {});
      }
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

    return true;
  }

  var viewRealEstateId;
  var realEstate;
  var realEstateAdmin;
  //get one page function that using uid of firebase database
  Future<bool> getSelectedRealEstate(String name) async {
    name = name.split('/')[name.split('/').length - 1];
    viewRealEstateId = name;
    var reuturnValue = await Helper.realEstatesData.doc(viewRealEstateId).get();
    var value = reuturnValue.data();
    realEstate = value;
    var adminInfo = await ProfileController()
        .getUserInfo(realEstate['realEstateAdmin']['uid']);
    realEstateAdmin = adminInfo;
    setState(() {});

    return true;
  }

  Future<void> productMarkAsSold(String productUid, bool value) async {
    await FirebaseFirestore.instance
        .collection(Helper.productsField)
        .doc(productUid)
        .update({'productMarkAsSold': value}).then((e) async {
      getProduct();
    });
  }

  Future<void> productSavePost(String productUid, bool value) async {
    await FirebaseFirestore.instance
        .collection(Helper.productsField)
        .doc(productUid)
        .update({'productPost': value}).then((e) async {
      getProduct();
    });
  }

  Future<void> productDelete(String productUid) async {
    await FirebaseFirestore.instance
        .collection(Helper.productsField)
        .doc(productUid)
        .delete()
        .then((e) async {
      getProduct();
    });
  }

  Future<void> realEstateMarkAsSold(String realEstateUid, bool value) async {
    await FirebaseFirestore.instance
        .collection(Helper.realEstatesField)
        .doc(realEstateUid)
        .update({'realEstateMarkAsSold': value}).then((e) async {
      getRealEstate();
    });
  }

  Future<void> realEstateSavePost(String realEstateUid, bool value) async {
    await FirebaseFirestore.instance
        .collection(Helper.realEstatesField)
        .doc(realEstateUid)
        .update({'realEstatePost': value}).then((e) async {
      getRealEstate();
    });
  }

  Future<void> realEstateDelete(String realEstateUid) async {
    await FirebaseFirestore.instance
        .collection(Helper.realEstatesField)
        .doc(realEstateUid)
        .delete()
        .then((e) async {
      getRealEstate();
    });
  }

  Future<void> productHideFromTimeline(String productUid, bool value) async {
    await FirebaseFirestore.instance
        .collection(Helper.productsField)
        .doc(productUid)
        .update({'productTimeline': value}).then((e) async {
      getProduct();
    });
  }

  Future<void> productTurnOffCommenting(String productUid, bool value) async {
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

  Future<void> realEstateHideFromTimeline(
      String realEstateUid, bool value) async {
    await FirebaseFirestore.instance
        .collection(Helper.realEstatesField)
        .doc(realEstateUid)
        .update({'realEstateTimeline': value}).then((e) async {
      getRealEstate();
    });
  }

  Future<void> realEstateTurnOffCommenting(
      String realEstateUid, bool value) async {
    await FirebaseFirestore.instance
        .collection(Helper.realEstatesField)
        .doc(realEstateUid)
        .update({'realEstateOnOffCommenting': value}).then((e) async {
      getRealEstate();
    });
  }

  changeRealEstateSellState(realEstateId) async {
    await Helper.realEstatesData
        .doc(realEstateId)
        .update({'realEstateSellState': true});
  }

  savePost(type, value, privacy, {header = ''}) async {
    Map<String, dynamic> postData = {};
    List followers = [];

    Friends friendModel = Friends();

    try {
      if (privacy == 'Public' || privacy == 'Friends') {
        List friends =
            await friendModel.getFriends(UserManager.userInfo['userName']);

        for (var item in friends) {
          String friendUserName = item['requester'].toString();
          if (friendUserName == UserManager.userInfo['userName']) {
            friendUserName = item['receiver'];
          }
          followers.add(friendUserName);
        }
      }
      followers.add(UserManager.userInfo['userName']);
      postData = {
        'postAdmin': UserManager.userInfo['uid'],
        'type': type,
        'value': value,
        'privacy': privacy,
        'postTime': FieldValue.serverTimestamp(),
        'header': header,
        'timeline': true,
        'comment': true,
        'followers': followers,
        'eventId':
            where == PostType.event.index ? PostController().viewEventId : '',
        'groupId':
            where == PostType.group.index ? PostController().viewGroupId : '',
      };
      Helper.postCollection.add(postData);

      setState(
        () {},
      );
    } catch (e) {
      print(e);
    }

    return true;
  }

  // var lastTime;
  var lastData;
  var latestTime;

  Map adminSnapHash = {};
  Map valueSnapHash = {};

  getTimelinePost(slide, direction, type, uid) async {
    where = type;
    var profileSnap, friendSnap;
    List allPosts = [];
    latestTime = DateTime.now();
    Query<Map<String, dynamic>> baseQuery =
        Helper.postCollection.orderBy('postTime', descending: true);

    if (type == PostType.timeline.index) {
      baseQuery = baseQuery.where('followers',
          arrayContains: UserManager.userInfo['userName'].toString());
      baseQuery = baseQuery.where('privacy', whereIn: ['Public', 'Friends']);
      if (direction == 0) {
        // baseQuery = baseQuery.where('postTime', isLessThan: lastTime);
        baseQuery = baseQuery.startAfterDocument(lastData);
      }
      friendSnap = await baseQuery.limit(slide).get();

      Query<Map<String, dynamic>> profileQuery =
          Helper.postCollection.orderBy('postTime', descending: true);

      profileQuery = profileQuery
          .where('postAdmin', isEqualTo: UserManager.userInfo['uid'])
          .where('privacy', isEqualTo: 'Only Me');
      if (direction == 0) {
        profileQuery = profileQuery.startAfterDocument(lastData);
      }
      profileSnap = await profileQuery.limit(slide).get();
      allPosts = friendSnap.docs + profileSnap.docs;
      allPosts.sort((b, a) => a['postTime'].compareTo(b['postTime']));
    } else {
      if (type == PostType.profile.index) {
        baseQuery = baseQuery.where('postAdmin', isEqualTo: uid);
        if (UserManager.userInfo['uid'] != uid) {
          baseQuery =
              baseQuery.where('privacy', whereIn: ['Public', 'Friends']);
        }
      } else if (type == PostType.event.index) {
        baseQuery = baseQuery.where('eventId', isEqualTo: uid);
      } else if (type == PostType.group.index) {
        baseQuery = baseQuery.where('groupId', isEqualTo: uid);
      }
      if (direction == 0) {
        baseQuery = baseQuery.startAfterDocument(lastData);
      }
      profileSnap = await baseQuery.limit(slide).get();

      allPosts = profileSnap.docs;
    }

    var postsBox = [];
    int i = 0;

    if (direction == -1 || direction == 0) {
      if (type == PostType.profile.index) {
        postsBox = postsProfile;
      } else if (type == PostType.timeline.index) {
        postsBox = postsTimeline;
      } else if (type == PostType.event.index) {
        postsBox = postsEvent;
      } else if (type == PostType.group.index) {
        postsBox = postsGroup;
      }
    }

    int index = 0;
    slide = allPosts.length < slide ? allPosts.length : slide;

    while (i < slide) {
      if (direction == -1) {
        index = slide - 1 - i;
      } else {
        index = i;
      }
      var currentPost = allPosts[index];
      var postData;
      if (currentPost['type'] == 'product') {
        var valueSnap =
            await Helper.productsData.doc(currentPost['value']).get();
        postData = valueSnap.data();
      } else {
        postData = currentPost['value'];
      }

      var adminInfo;
      if (UserManager.userInfo['uid'] == currentPost['postAdmin']) {
        adminInfo = UserManager.userInfo;
      } else {
        adminInfo =
            await ProfileController().getUserInfo(currentPost['postAdmin']);
      }
      var eachPost = {
        'id': currentPost.id,
        'data': postData,
        'type': currentPost['type'],
        'adminInfo': adminInfo,
        'time': currentPost['postTime'],
        'adminUid': currentPost['postAdmin'],
        'privacy': currentPost['privacy'],
        'header': currentPost['header'],
        'timeline': currentPost['timeline'],
        'comment': currentPost['comment'],
      };

      Map curPost = currentPost.data() as Map;

      if (curPost.containsKey('eventId')) {
        if (curPost['eventId'].isNotEmpty) {
          var event = await Helper.eventsData.doc(curPost['eventId']).get();

          eachPost['eventName'] = event['eventName'];
        }
      }

      if (curPost.containsKey('groupId')) {
        if (curPost['groupId'].isNotEmpty) {
          var group = await Helper.groupsData.doc(curPost['groupId']).get();
          eachPost['groupName'] = group['groupName'];
        }
      }

      if (direction == -1) {
        postsBox = [eachPost, ...postsBox];
      } else {
        postsBox.add(eachPost);
      }
      i++;
    }

    if (direction == 1 || direction == 0) {
      if (slide > 0) {
        lastData = allPosts[slide - 1];
      }
    }
    if (slide != 0) {
      latestTime = Timestamp(allPosts[0]['postTime'].seconds,
              allPosts[0]['postTime'].nanoseconds)
          .toDate();
    }

    // if (slide == 0) {
    //   lastTime = latestTime = DateTime.now();
    // } else {
    //   lastTime = allPosts[slide - 1]['postTime'];
    // }
    if (type == PostType.profile.index) {
      postsProfile = postsBox;
    } else if (type == PostType.timeline.index) {
      postsTimeline = postsBox;
    } else if (type == PostType.event.index) {
      postsEvent = postsBox;
    } else if (type == PostType.group.index) {
      postsGroup = postsBox;
    }

    posts = postsBox;

    setState(() {});

    return slide >= defaultSlide;
  }

  updatePostInfo(uid, value) async {
    await Helper.postCollection.doc(uid).update(value);
  }

  updateProductInfo(uid, value) async {
    await Helper.productsData.doc(uid).update(value);
  }

  updateRealEstateInfo(uid, value) async {
    await Helper.realEstatesData.doc(uid).update(value);
  }

  deletePost(uid) async {
    Helper.postCollection.doc(uid).delete();
  }

  deletePostFromTimeline(post) {
    posts.removeWhere((item) => item['id'] == post['id']);

    setState(() {});
  }

  deletePhoto(Map value) async {
    FirebaseFirestore.instance
        .collection(Helper.postField)
        .where('value.photo', arrayContains: value)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        List<dynamic> updatedValue = doc['value']['photo']
            .where((elem) => elem['url'] != value['url'])
            .toList();
        if (updatedValue.isEmpty) {
          doc.reference.delete();
        } else {
          //  doc['value']['photo'].update(updatedValue);
          Map data = {};
          if (doc['value'].containsKey('feeling')) {
            data['feeling'] = doc['value']['feeling'];
          }
          data['photo'] = updatedValue;

          doc.reference.update({'value': data});
        }
      }
    });

    FirebaseFirestore.instance
        .collection(Helper.userField)
        .where('avatar', isEqualTo: value['url'])
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.update({'avatar': ""});
      }
    });

    FirebaseFirestore.instance
        .collection(Helper.userField)
        .where('profile_cover', isEqualTo: value['url'])
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.update({'profile_cover': ""});
      }
    });
  }

  deletePhotoFromTimeline(Map value) {
    posts.removeWhere((item) {
      if (item['value'].contains(value)) {
        List<dynamic> updatedValue =
            item['value'].where((elem) => elem['url'] != value['url']).toList();
        if (updatedValue.isEmpty) {
          posts.removeAt(item.index);
        } else {
          posts[item.index] = updatedValue;
        }
        return true;
      }
      return false;
    });

    setState(() {});
  }

  deleteProduct(uid) async {
    await Helper.productsData.doc(uid).delete();
    posts.removeWhere((item) => item['id'] == uid);
  }

  deleteRealEstate(uid) async {
    await Helper.realEstatesData.doc(uid).delete();
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
      'adminUid': postData['postAdmin'],
      'privacy': postData['privacy'],
      'header': postData['header'],
      'timeline': postData['timeline'],
      'comment': postData['comment'],
    };
    if (postData['eventId'] != null) {
      if (postData['eventId'].isNotEmpty) {
        var event = await Helper.eventsData.doc(postData['eventId']).get();

        eachPost['eventName'] = event['eventName'];
      }
    }

    if (postData['groupId'] != null) {
      if (postData['groupId'].isNotEmpty) {
        var group = await Helper.groupsData.doc(postData['groupId']).get();
        eachPost['groupName'] = group['groupName'];
      }
    }

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

    // if (!existId) {
    //   await Helper.postLikeComment.doc(postId).set({'likes': {}});
    // }
    DocumentReference commentRef =
        Helper.postLikeComment.doc(postId).collection('comments').doc();
    String commentId = commentRef.id;

    await commentRef.set({
      'data': {'type': type, 'content': data, 'uid': userManager['uid']},
      'timeStamp': FieldValue.serverTimestamp(),
      'likes': []
    });
    print('Comment ID: $commentId');
    comment.insert(0, {
      'data': {'uid': userManager['uid'], 'content': data, 'type': type},
      'userInfo': userManager,
      'id': commentId,
      'reply': reply,
      'likes': [],
    });
    comments[postId] = comment;
    print("comments:----${comments[postId]}");
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

      await Helper.postLikeComment
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .update({'likes': gotLike});

      commentLikes[commentId] = commentLike;

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
    var allNot = notiSnap.data();
    allNot!['userList'].add(userUid);
    await Helper.notifiCollection
        .doc(notiUid)
        .update({'userList': allNot['userList']});
  }

  clearAllNotify(array, userUid) async {
    allNotification = [];
    setState(() {});
    for (var i = 0; i < array.length; i++) {
      var notiSnap = await Helper.notifiCollection.doc(array[i]['uid']).get();
      var allNot = notiSnap.data();
      allNot!['userList'].add(userUid);
      await Helper.notifiCollection.doc(array[i]['uid']).update({
        'userList': allNot['userList'],
      });
    }
  }

  Future checkNotify() async {
    try {
      realNotifi = [];
      print("removed realNotifi empty");
      await getServerTime();
      await FirebaseFirestore.instance
          .collection(Helper.userField)
          .doc(UserManager.userInfo['uid'])
          .update({'checkNotifyTime': serverTimeStamp});
      var userManager = UserManager.userInfo;
      userManager['checkNotifyTime'] = serverTimeStamp;
      var j = {};
      userManager.forEach((key, value) {
        j = {...j, key.toString(): value};
      });
      await Helper.saveJSONPreference(Helper.userField, {...j});
      await UserManager.getUserInfo();
      setState(() {});
      await UserManager.getUserInfo();
      await Helper.saveJSONPreference(
          Helper.userField, {...UserManager.userInfo});
      UserManager.userInfo['checkNotifyTime'] = serverTimeStamp;
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

  disposeAll() {
    allNotification = [];
    realNotifi = [];
  }
}
