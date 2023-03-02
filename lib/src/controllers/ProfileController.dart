// ignore_for_file: unused_local_variable

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import '../helpers/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/userModel.dart';

enum EmailType { emailVerify, googleVerify }

class ProfileController extends ControllerMVC {
  factory ProfileController([StateMVC? state]) =>
      _this ??= ProfileController._(state);
  ProfileController._(StateMVC? state)
      : progress = 0,
        super(state);
  static ProfileController? _this;
  // ignore: non_constant_identifier_names
  String profile_cover = '';
  String viewProfileUserName = '';
  String viewProfileFullName = '';
  String viewProfileUid = '';
  String tab = 'Timeline';
  double progress;
  var resData = {};
  var userInfo = {};
  // ignore: prefer_typing_uninitialized_variables
  var responseData;
  Map<String, dynamic> userData = {};
  var signUpUserInfo = {};
  bool isGetData = false;
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

  updateProfile(userName) {
    tab = 'Timeline';
    var userInfo = UserManager.userInfo;

    viewProfileUserName = userName;
    if (viewProfileUserName == '') {
      viewProfileUserName = userInfo['userName'];
    }
    getProfileInfo();
  }

  //get user profile info
  Future<bool> getProfileInfo() async {
    print("callll profile get info =============");
    bool getFlag = false;
    isGetData = false;
    await FirebaseFirestore.instance
        .collection(Helper.userField)
        .where('userName', isEqualTo: viewProfileUserName)
        .get()
        .then((value) {
      viewProfileFullName =
          '${value.docs[0].data()['firstName']} ${value.docs[0].data()['lastName']}';
      viewProfileUid = value.docs[0].id;
      userData = value.docs[0].data();
      profile_cover = userData['profile_cover'] ?? '';
      setState(() {});
      isGetData = true;
      getFlag = true;
    });
    return getFlag;
  }

  //get user user info using uid
  Future<Map<String, dynamic>?> getUserInfo(uid) async {
    var getShot = await FirebaseFirestore.instance
        .collection(Helper.userField)
        .doc(uid)
        .get();
    var getUser = getShot.data();
    return getUser;
  }
}
