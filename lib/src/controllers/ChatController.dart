import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
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
  var type = 'text';
  var allUsersList = [];
  var chatUserList = [];
  var chattingUser = '';
  var data = '';
  var isMessageTap = 'all-list';
  var docId = '';
  var newRFirstName = '';
  var newRLastName = '';
  var chatId = '';
  final chatCollection = FirebaseFirestore.instance
      .collection(Helper.message)
      .withConverter<ChatModel>(
        fromFirestore: (snapshots, _) => ChatModel.fromJSON(snapshots.data()!),
        toFirestore: (value, _) => value.toMap(),
      );
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
  
  Future<void> sendMessage(newOrNot) async {
    print('chattingUser$chattingUser');
    var newChat = false;
    if (chattingUser == '' || data == '') {
      return;
    }
    List<String> lst= [];
    lst.add(UserManager.userInfo['userName']);
    lst.add(chattingUser);
    if (newOrNot == 'new') {
      FirebaseFirestore.instance.collection(Helper.message).add({
        'users': [UserManager.userInfo['userName'], chattingUser],
        UserManager.userInfo['userName']:
            '${UserManager.userInfo['firstName']} ${UserManager.userInfo['lastName']}',
        chattingUser: '$newRFirstName $newRLastName'
      }).then((value) {
        docId = value.id;
        setState(() { });
        FirebaseFirestore.instance
            .collection(Helper.message)
            .doc(value.id)
            .collection('content')
            .add({
          'type': type,
          'sender': UserManager.userInfo['userName'],
          'receiver': chattingUser,
          'data': data,
          'timeStamp': DateTime.now()
        });
        
      });
    } else {
      FirebaseFirestore.instance
          .collection(Helper.message)
          .doc(docId)
          .collection('content')
          .add({
        'type': type,
        'sender': UserManager.userInfo['userName'],
        'receiver': chattingUser,
        'data': data,
        'timeStamp': DateTime.now()
      }).then((value) => print(value));
    }
  }
  Stream<QuerySnapshot<ChatModel>> getChatUsers() {
    return chatCollection.where('users',
        arrayContains: UserManager.userInfo['userName']).snapshots();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessageList() {
    return chatCollection.doc(docId).collection('content').snapshots();
  }
}
