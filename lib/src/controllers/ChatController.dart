import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../firebase_options.dart';
import '../helpers/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../managers/user_manager.dart';
import '../models/chatModel.dart';
import '../models/userModel.dart';

class ChatController extends ControllerMVC {
  factory ChatController() => _this ??= ChatController._();
  ChatController._();
  static ChatController? _this;
  var chatBoxs = [];
  var chatUserList = [];
  var chattingUser = '';
  var isMessageTap = 'all-list';
  var docId = '';
  var newRFirstName = '';
  var newRLastName = '';
  var chatId = '';
  var avatar = '';
  var emojiList = <Widget>[];
  TextEditingController textController = TextEditingController();
  bool isShowEmoticon = false;
  @override
  Future<bool> initAsync() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return true;
  }

  @override
  bool onAsyncError(FlutterErrorDetails details) {
    return false;
  }

  getTimeandSendMessage(newOrNot, messageType, data) async {
    DateTime time;
    Response res;
    bool success = false;
    try {
      res = await get(
          Uri.http('worldtimeapi.org', '/api/timezone/America/Los_Angeles'));
      var d = jsonDecode(res.body);
      time = DateTime.parse(d['datetime']);
      success = await sendMessage(newOrNot, messageType, data, time);
    } catch (e) {
      success = false;
    }
    return success;
    // return time;
  }

  Future<bool> sendMessage(newOrNot, messageType, data, time) async {
    var newChat = false;
    bool success = false;
    print(chattingUser);
    print(data);
    if (chattingUser == '' || data == '') {
      success = false;
    }
    if (newOrNot == 'new') {
      await FirebaseFirestore.instance.collection(Helper.message).add({
        'users': [UserManager.userInfo['userName'], chattingUser],
        UserManager.userInfo['userName']: {
          'name':
              '${UserManager.userInfo['firstName']} ${UserManager.userInfo['lastName']}',
          'avatar': UserManager.userInfo['avatar'] ?? ''
        },
        chattingUser: {
          'name': '$newRFirstName $newRLastName',
          'avatar': avatar
        },
        'lastData': data
      }).then((value) async {
        docId = value.id;
        success = true;
        setState(() {});
        await FirebaseFirestore.instance
            .collection(Helper.message)
            .doc(value.id)
            .collection('content')
            .add({
          'type': messageType,
          'sender': UserManager.userInfo['userName'],
          'receiver': chattingUser,
          'data': data,
          'timeStamp': time
        });
      });
    } else {
      success = true;
      FirebaseFirestore.instance
          .collection(Helper.message)
          .doc(docId)
          .update({'lastData': data});
      FirebaseFirestore.instance
          .collection(Helper.message)
          .doc(docId)
          .collection('content')
          .add({
        'type': messageType,
        'sender': UserManager.userInfo['userName'],
        'receiver': chattingUser,
        'data': data,
        'timeStamp': time
      }).then((value) => {});
    }
    return success;
  }

  final chatCollection = FirebaseFirestore.instance
      .collection(Helper.message)
      .withConverter<ChatModel>(
        fromFirestore: (snapshots, _) => ChatModel.fromJSON(snapshots.data()!),
        toFirestore: (value, _) => value.toMap(),
      );
  Stream<QuerySnapshot<ChatModel>> getChatUsers() {
    var stream = chatCollection
        .where('users', arrayContains: UserManager.userInfo['userName'])
        .snapshots();
    return stream;
  }
}
