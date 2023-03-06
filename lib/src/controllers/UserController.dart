import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:otp/otp.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shnatter/src/controllers/PeopleController.dart';
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import '../helpers/helper.dart';
import '../managers/relysia_manager.dart';
import '../models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../routes/route_names.dart';
import '../utils/size_config.dart';

enum EmailType { emailVerify, googleVerify }

class UserController extends ControllerMVC {
  factory UserController([StateMVC? state]) =>
      _this ??= UserController._(state);
  UserController._(StateMVC? state)
      : isSettingAction = false,
        isProfileChange = false,
        super(state);
  static UserController? _this;
  String token = '';
  String email = '';
  String relysiaEmail = '';
  String relysiaPassword = '';
  String password = '';
  String paymail = '';
  String walletAddress = '';
  int balance = 0;
  bool isSendRegisterInfo = false;
  bool isProfileChange;
  bool isSettingAction;
  bool isSendLoginedInfo = false;
  bool isStarted = false;
  bool isVerify = false;
  bool isSendResetPassword = false;
  bool isLogined = false;
  bool isEnableTwoFactor = false;

  String failLogin = '';
  String failRegister = '';
  String isEmailExist = '';
  String userAvatar = '';
  String existPwd = '';
  // ignore: unused_field
  Timer? timer;
  var resData = {};
  Map<dynamic, dynamic> userInfo = {};
  // ignore: prefer_typing_uninitialized_variables
  var responseData;
  var context;
  var signUpUserInfo = {};
  var nextPageTokenCount = '0';
  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();

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

  String createRandNumber() {
    var rng = Random();
    int randomNumber = rng.nextInt(100);
    return randomNumber.toString();
  }

  String createRandEmail() {
    String code = ""; // Timestamp.now.toString();
    for (int i = 0; i < 13; i++) {
      code = code + createRandNumber();
    }
    return "relysia$code@shnatter.com";
  }

  Future<bool> validate(cont, info) async {
    isSendRegisterInfo = true;
    var fill = true;
    bool passworkdValidation = false;
    var validation = [
      'userName',
      'firstName',
      'lastName',
      'email',
      'password',
    ];
    for (var i = 0; i < validation.length; i++) {
      if (info[validation[i]] == null) {
        fill = false;
        break;
      }
    }
    if (!fill) {
      failRegister = 'You must fill all field';
      isSendRegisterInfo = false;
      setState(() {});
      return false;
    }
    context = cont;
    signUpUserInfo = info;
    email = signUpUserInfo['email'].toLowerCase().trim();
    password = signUpUserInfo['password'];
    var check = email.contains('@'); //return true if contains
    if (!check) {
      failRegister = 'Invalid Email';
      isSendRegisterInfo = false;
      setState(() {});
      return false;
    }

    passworkdValidation = await passworkdValidate(password);

    try {
      if (!passworkdValidation) {
        failRegister = 'A minimum 8 Characters required for password';
        isSendRegisterInfo = false;
        setState(() {});
        return false;
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }

    QuerySnapshot<TokenLogin> querySnapshot =
        await Helper.authdata.where('email', isEqualTo: email).get();
    QuerySnapshot<TokenLogin> querySnapshot1 = await Helper.authdata
        .where('userName', isEqualTo: signUpUserInfo['userName'])
        .get();
    if (querySnapshot.size > 0) {
      failRegister =
          'Sorry, it looks like $email belongs to an existing account';
      isSendRegisterInfo = false;
      setState(() {});
      return false;
    }
    if (querySnapshot1.size > 0) {
      failRegister =
          'Sorry, it looks like ${signUpUserInfo['userName']} belongs to an existing account';
      isSendRegisterInfo = false;
      setState(() {});
      return false;
    }
    RelysiaManager.authUser(relysiaEmail, relysiaPassword).then((res) async => {
          if (res['data'] == null)
            {
              failRegister = 'No access the net',
              isSendRegisterInfo = false,
              setState(() {}),
            }
        });
    if (isSendRegisterInfo = false) {
      return false;
    }
    failRegister = '';
    // createRelysiaAccount(cont);
    setState(() {});

    return true;
  }

  bool passworkdValidate(String value) {
    // String pattern =
    //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~_\-+=@,\.;\{\}\[\]]).{8,}$';
    // RegExp regExp = RegExp(pattern);
    // return regExp.hasMatch(value);
    if (value.length < 8) {
      return false;
    } else {
      return true;
    }
  }

  String createActivationCode() {
    String code = ""; // Timestamp.now.toString();
    for (int i = 0; i < 13; i++) {
      code = code + createRandNumber();
    }
    return code;
  }

  String createPassword() {
    String password = "";
    for (int i = 0; i < 6; i++) {
      password = password + createRandNumber();
    }
    return password;
  }

  Future<void> registerUserInfo() async {
    setState(() {});
    var uuid = await sendEmailVeryfication();
    signUpUserInfo.removeWhere((key, value) => key == 'password');
    await FirebaseFirestore.instance
        .collection(Helper.userField)
        .doc(uuid)
        .set({
      ...signUpUserInfo,
      'paymail': paymail,
      'isEnableTwoFactor': '',
      'avatar': '',
      'isEmailVerify': false,
      'walletAddress': walletAddress,
      'relysiaEmail': relysiaEmail,
      'relysiaPassword': relysiaPassword,
      'paywall': {},
      'isStarted': false,
    });
    var serverTime = await PostController().getNowTime();
    var serverTimeStamp = await PostController().changeTimeType(d: serverTime);
    var localTimeStamp = DateTime.now().millisecondsSinceEpoch;
    var difference = localTimeStamp - serverTimeStamp;
    await Helper.saveJSONPreference(Helper.userField, {
      ...signUpUserInfo,
      'paywall': {},
      'paymail': paymail,
      'fullName':
          '${signUpUserInfo['firstName']} ${signUpUserInfo['lastName']}',
      'walletAddress': walletAddress,
      // 'relysiaEmail': relysiaEmail,
      // 'relysiaPassword': relysiaPassword,
      'isEnableTwoFactor': '',
      'password': password,
      'isStarted': false,
      'isEmailVerify': false,
      'isRememberme': false,
      'avatar': '',
      'uid': uuid,
      'expirationPeriod': DateTime.now().toString(),
      'timeDifference': difference,
    });
  }

  bool twoFactorAuthenticationChecker(String verificationCode) {
    var code = OTP.generateTOTPCodeString(
        'JBSWY3DPEHPK3PXP', DateTime.now().millisecondsSinceEpoch,
        length: 6, interval: 30, algorithm: Algorithm.SHA1, isGoogle: true);
    if (code == verificationCode) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> inviteCodecheck(String inviteCode) async {
    var user = await Helper.userCollection.get();
    var allUser = user.docs;
    bool exist = false;
    String id = '';
    for (int i = 0; i < allUser.length; i++) {
      id = allUser[i].id.toString();
      if (id == inviteCode) exist = true;
    }
    return exist;
  }

  Future<bool> enableDisableTwoFactorAuthentication(
      String verificationCode, String type) async {
    var codeCheck = await twoFactorAuthenticationChecker(verificationCode);
    if (codeCheck) {
      var twoFactorData = {
        'isEnableTwoFactor': type == 'enable' ? 'JBSWY3DPEHPK3PXP' : '',
      };
      await FirebaseFirestore.instance
          .collection(Helper.userField)
          .doc(UserManager.userInfo['uid'])
          .update({...twoFactorData});
      isEnableTwoFactor = (type == 'enable' ? true : false);
      // await Helper.saveJSONPreference(Helper.userField, {...{'isEnableTwoFactor': type == 'enable' ? 'JBSWY3DPEHPK3PXP' : ''}});
      // await UserManager.getUserInfo();
      setState(() {});
    }
    return codeCheck;
  }

  Future<int> getBalance() async {
    if (token == '') {
      var relysiaAuth = await RelysiaManager.authUser(
          UserManager.userInfo['email'], UserManager.userInfo['password']);
      token = relysiaAuth['data']['token'];
    }
    await RelysiaManager.getBalance(token).then(
        (res) => {balance = res, Helper.balance = balance, setState(() {})});
    return balance;
  }

  Future<List> getTransactionHistory(nextPageToken) async {
    var trdata = [];
    var transactionData = [];
    var user = await Helper.userCollection.get();
    var allUser = user.docs;
    String sender = '';
    String recipient = '';
    int sendFlag = 0;
    int reciFlag = 0;
    if (token == '') {
      var relysiaAuth = await RelysiaManager.authUser(
          UserManager.userInfo['email'], UserManager.userInfo['password']);
      token = relysiaAuth['data']['token'];
    }

    await RelysiaManager.getTransactionHistory(token, nextPageToken).then(
      (res) async => {
        if (res['success'] == true)
          {
            if (allUser != [])
              {
                trdata = res['history'],
                if (trdata != [])
                  {
                    for (int i = 0; i < trdata.length; i++)
                      {
                        sender = trdata[i]['from'],
                        recipient = "Treasury",
                        for (int j = 0; j < allUser.length; j++)
                          {
                            if (trdata[i]['from'] ==
                                allUser[j].data()['paymail'])
                              {
                                sender = allUser[j].data()['userName'],
                              },
                            if (trdata[i]['to'] ==
                                allUser[j].data()['walletAddress'])
                              recipient = allUser[j].data()['userName'],
                          },
                        transactionData.add({
                          'from': trdata[i]['from'],
                          'to': trdata[i]['to'],
                          'txId': trdata[i]['txId'],
                          'sender': sender,
                          'recipient': recipient,
                          'sendtime': trdata[i]['timestamp'],
                          'notes': trdata[i]['notes'],
                          'balance': trdata[i]['balance_change'],
                        }),
                        sendFlag = 0,
                        reciFlag = 0,
                      },
                  },
                nextPageTokenCount = res['nextPageToken'],
                setState(() {}),
              }
          }
        else if (res['success'] == false)
          {
            await RelysiaManager.authUser(email, password).then(
              (res) async => {
                if (res['data'] != null)
                  {
                    if (res['statusCode'] == 200)
                      {
                        token = res['data']['token'],
                        getTransactionHistory(nextPageToken),
                      }
                    else if (res['statusCode'] == 400 &&
                        res['data']['msg'] == 'INVALID_EMAIL')
                      {
                        await RelysiaManager.authUser(email, password).then(
                          (resData) => {
                            if (resData['data'] != null)
                              {
                                if (resData['statusCode'] == 200)
                                  {
                                    token = resData['data']['token'],
                                  }
                                else
                                  {Helper.showToast(resData['data']['msg'])}
                              }
                            else
                              {
                                Helper.showToast(resData['data']['msg']),
                              }
                          },
                        )
                      }
                  }
                else
                  {
                    Helper.showToast(res['data']['msg']),
                  }
              },
            )
          }
      },
    );
    return transactionData;
  }

  void getWalletFromPref(context) async {}

  Future<void> resetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      isSendResetPassword = true;
      setState(() {});
      Helper.showToast('Email is sent');
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'invalid-email') {
        isEmailExist = 'Not email type';
        setState(() {});
      } else if (e.code == 'user-not-found') {
        isEmailExist = 'That email is not exist in database now';
        setState(() {});
      } else if (e.code == 'network-request-failed') {
        isEmailExist = 'No access the net';
        setState(() {});
      }
      setState(() {});
    }
  }

  Future<bool> loginWithEmail(context, em, pass, isRememberme) async {
    isSendLoginedInfo = true;
    setState(() {});
    if (em == '' || pass == '') {
      failLogin = 'You must fill all field';
      isSendLoginedInfo = false;
      setState(() {});
      return false;
    }
    email = em;
    password = pass;
    var returnVal = false;
    try {
      if (!email.contains('@')) {
        QuerySnapshot<TokenLogin> checkUsername =
            await Helper.authdata.where('userName', isEqualTo: email).get();
        if (checkUsername.size > 0) {
          TokenLogin getInfo = checkUsername.docs[0].data();
          email = getInfo.email;
        } else {
          failLogin = 'The username you entered does not belong to any account';
          setState(() {});
        }
      }
      setState(() {});
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      var uid = userCredential.user!.uid;
      failLogin = '';
      setState(() {});
      QuerySnapshot<TokenLogin> querySnapshot =
          await Helper.authdata.where('email', isEqualTo: email).get();
      if (querySnapshot.size == 0) {
        failLogin = 'The email you entered does not belong to any account';
        isSendLoginedInfo = false;
        setState(() {});
        return false;
      }
      if (querySnapshot.size > 0) {
        TokenLogin user = querySnapshot.docs[0].data();
        user.documentId = querySnapshot.docs[0].id;

        relysiaEmail = user.email;
        relysiaPassword = password;
        isStarted = user.isStarted;
        isVerify = userCredential.user!.emailVerified;
        addFCMTokenToUser(user.documentId, user.paymail);

        var b = user.userInfo;
        var j = {};
        b.forEach((key, value) {
          j = {...j, key.toString(): value};
        });
        var serverTime = await PostController().getNowTime();
        var serverTimeStamp =
            await PostController().changeTimeType(d: serverTime);
        var localTimeStamp = DateTime.now().millisecondsSinceEpoch;
        var difference = localTimeStamp - serverTimeStamp;
        userInfo = {
          ...j,
          'fullName': '${j['firstName']} ${j['lastName']}',
          'password': password,
          'isVerify': isVerify,
          'isRememberme': isRememberme.toString(),
          'uid': querySnapshot.docs[0].id,
          'expirationPeriod': isRememberme ? '' : DateTime.now().toString(),
          'timeDifference': difference,
        };
        isEnableTwoFactor =
            j['isEnableTwoFactor'] == '' || j['isEnableTwoFactor'] == null
                ? false
                : true;
        if (!isEnableTwoFactor) {
          await Helper.saveJSONPreference(Helper.userField, {...userInfo});
          await UserManager.getUserInfo();
          setState(() {});
          RouteNames.userName = user.userName;
          loginRelysia(context);
          setState(() {});
          return false;
        } else {
          setState(() {});
          returnVal = true;
          return true;
        }
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'invalid-email' || e.code == 'user-not-found') {
        failLogin = 'The email you entered does not belong to any account';
        setState(() {});
      } else if (e.code == 'wrong-password') {
        failLogin = 'wrong-password';
        isSendLoginedInfo = false;
        setState(() {});
      } else if (e.code == 'network-request-failed') {
        failLogin = 'No access the net';
        isSendLoginedInfo = false;
        setState(() {});
      } else if (e.code == 'too-many-requests') {
        isSendLoginedInfo = false;
        failLogin = 'Retry after 3 minutes';
        setState(() {});
      }
      isSendLoginedInfo = false;
      setState(() {});
      return false;
    }
    return returnVal;
  }

  Future<void> addFCMTokenToUser(userDocuId, userPaymail) async {
    var fcmtoken = await Helper.getStringPreference('fcmtoken');
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("FCMToken")
        .where('token', isEqualTo: fcmtoken)
        .get();
    if (!snapshot.docs.isEmpty) {
      var docuId = snapshot.docs.first.id;
      await FirebaseFirestore.instance
          .collection("FCMToken")
          .doc(docuId)
          .update({'userDocId': userDocuId, 'paymail': userPaymail});
    }
  }

  Future<bool> loginWithVerificationCode(
      String verificationCode, context) async {
    var returnVal = await twoFactorAuthenticationChecker(verificationCode);
    print(returnVal);
    if (returnVal) {
      await Helper.saveJSONPreference(Helper.userField, {...userInfo});
      await UserManager.getUserInfo();
      setState(() {});
      RouteNames.userName = UserManager.userInfo['userName'];
      loginRelysia(context);
      setState(() {});
    }
    return returnVal;
  }

  void loginRelysia(context) {
    RelysiaManager.authUser(relysiaEmail, relysiaPassword).then((res) async => {
          if (res['data'] != null)
            {
              if (res['statusCode'] == 200)
                {
                  token = res['data']['token'],
                  getBalance(),
                  RelysiaManager.getPaymail(token).then((response) async => {
                        setState(() {}),
                        if (response['paymail'] != null)
                          {
                            paymail = response['paymail'],
                            walletAddress = response['address'],
                            isSendLoginedInfo = false,
                            isLogined = true,
                            Helper.connectOnlineDatabase(),
                            Navigator.pushReplacementNamed(
                                context,
                                isStarted
                                    ? RouteNames.homePage
                                    : RouteNames.started),
                            setState(() {})
                          }
                      }),
                  setState(() {})
                }
              else
                {
                  resData = res['data'],
                  if (resData['msg'] == 'INVALID_EMAIL')
                    {
                      Helper.showToast('You didn\'t sign up in Relysia!'),
                    }
                  else if (resData['msg'] == 'EMAIL_NOT_FOUND')
                    {
                      Helper.showToast('Email Not Found!'),
                    }
                  else
                    {
                      Helper.showToast(resData['msg']),
                    },
                  isSendLoginedInfo = true,
                  setState(() {})
                }
            }
          else
            {isSendLoginedInfo = true, setState(() {})}
        });
  }

  Future<String> sendEmailVeryfication() async {
    setState(() {});
    var uuid = '';
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      uuid = userCredential.user!.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        uuid = userCredential.user!.uid;
      } else {}
    } catch (e) {
      rethrow;
    }

    ActionCodeSettings acs = ActionCodeSettings(
        url:
            "https://us-central1-shnatter-a69cd.cloudfunctions.net/emailVerification?uid=${uuid}",
        handleCodeInApp: true);
    await FirebaseAuth.instance.currentUser?.sendEmailVerification(acs);
    return uuid;
  }

  Future<String> reSendEmailVeryfication() async {
    ActionCodeSettings acs = ActionCodeSettings(
        url:
            "https://us-central1-shnatter-a69cd.cloudfunctions.net/emailVerification?uid=${UserManager.userInfo['uid']}",
        handleCodeInApp: true);
    await FirebaseAuth.instance.currentUser?.sendEmailVerification(acs);
    return 'ok';
  }

  signOutUser(context) async {
    UserManager.isLogined = false;
    Helper.makeOffline();
    FirebaseAuth.instance.signOut();
    UserManager.userInfo = {};
    setState(() {});
    PeopleController().disposeAll();
    await Helper.removeAllPreference();
    // ignore: use_build_context_synchronously
    await Navigator.pushReplacementNamed(context, RouteNames.login);

    setState(() {});
  }

  createRelysiaAccount(context) async {
    relysiaEmail = signUpUserInfo['email'];
    relysiaPassword = signUpUserInfo['password'];
    responseData =
        await RelysiaManager.createUser(relysiaEmail, relysiaPassword);
    if (responseData['data'] != null) {
      if (responseData['statusCode'] == 200) {
        createEmail();
        isSendRegisterInfo = true;
        failRegister = '';
        setState(() {});
      } else if (responseData['statusCode'] == 400 &&
          responseData['data']['msg'] == "EMAIL_EXISTS") {
        Helper.showToast(responseData['data']['msg']);
        showModal(context, relysiaEmail, relysiaPassword);
        // createRelysiaAccount();
      }
    } else {
      createRelysiaAccount(context);
    }
  }

  void createEmail() async {
    token = responseData['data']['token'];
    RelysiaManager.createWallet(token).then((rr) => {
          if (rr == 0)
            {
              Helper.showToast("Error occurs while create wallet"),
              isSendRegisterInfo = false,
              setState(() {}),
            }
          else
            {
              RelysiaManager.authUser(relysiaEmail, relysiaPassword)
                  .then((responseData) => {
                        if (responseData['data'] != null)
                          {
                            if (responseData['statusCode'] == 200)
                              {
                                token = responseData['data']['token'],
                                RelysiaManager.getPaymail(token)
                                    .then((response) async => {
                                          if (response['paymail'] != null)
                                            {
                                              paymail = response['paymail'],
                                              walletAddress =
                                                  response['address'],
                                              await registerUserInfo(),
                                              await UserManager.getUserInfo(),
                                              setState(() {}),
                                              RouteNames.userName =
                                                  signUpUserInfo['userName'],
                                              isSendRegisterInfo = false,
                                              isLogined = true,
                                              Navigator.pushReplacementNamed(
                                                  context, RouteNames.started),
                                              setState(() {}),
                                            }
                                        })
                              }
                            else
                              {
                                resData = responseData['data'],
                                if (resData['msg'] == 'INVALID_EMAIL')
                                  {
                                    Helper.showToast(
                                        'You didn\'t sign up in Relysia!'),
                                  }
                                else if (resData['msg'] == 'EMAIL_NOT_FOUND')
                                  {
                                    Helper.showToast('Email Not Found!'),
                                  }
                                else
                                  {
                                    Helper.showToast(resData['msg']),
                                    setState(() {})
                                  },
                                isSendRegisterInfo = false,
                                setState(() {}),
                              }
                          }
                        else
                          {
                            isSendRegisterInfo = false,
                            setState(() {}),
                          },
                      })
            },
        });
  }

  Future<void> resetGetUserInfo() async {
    var info;
    FirebaseFirestore.instance
        .collection(Helper.userField)
        .doc(UserManager.userInfo['uid'])
        .get()
        .then((value) async => {
              userInfo = await Helper.getJSONPreference(Helper.userField),
              userInfo['isStarted'] = true,
              info = UserManager.userInfo.toString(),
              UserManager.getUserInfo(),
              await Helper.saveJSONPreference(Helper.userField,
                  {...userInfo, 'avatar': value.data()!['avatar']}),
              print(userInfo),
              await Helper.getJSONPreference(Helper.userField),
              setState(() {})
            });
  }

  //change user avatar
  Future<void> changeAvatar() async {
    await FirebaseFirestore.instance
        .collection(Helper.userField)
        .doc(UserManager.userInfo['uid'])
        .update({'avatar': userAvatar});
    FirebaseFirestore.instance
        .collection(Helper.message)
        .where('users', arrayContains: UserManager.userInfo['userName'])
        .get()
        .then((value) async {
      for (int i = 0; i < value.docs.length; i++) {
        await FirebaseFirestore.instance
            .collection(Helper.message)
            .doc(value.docs[i].id)
            .update({
          UserManager.userInfo['userName']: {
            'avatar': userAvatar,
            'name':
                "${UserManager.userInfo['firstName']} ${UserManager.userInfo['lastName']}"
          }
        });
      }
    });
    resetGetUserInfo();
  }

  //in started page, save profile function, (all save profile)
  Future<void> saveProfile(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection(Helper.userField)
        .doc(UserManager.userInfo['uid'])
        .update({
      ...data,
      'isStarted': true,
    });
    resetGetUserInfo();
  }

  //get all interests from firebase
  Future<List> getAllInterests() async {
    QuerySnapshot querySnapshot =
        await Helper.allInterests.orderBy('title').get();

    var doc = querySnapshot.docs;
    return doc;
  }

  saveAccountSettings(email, userName, password) async {
    var userManager = UserManager.userInfo;
    var uuid = '';
    isSettingAction = true;
    setState(() {});
    if (!email.contains('@')) {
      return;
    }
    if (password.length < Helper.passwordMinLength) {
      return;
    }
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userManager['email'], password: userManager['password']);
    await FirebaseAuth.instance.currentUser?.delete();
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      uuid = userCredential.user!.uid;

      var snapshot = await FirebaseFirestore.instance
          .collection(Helper.userField)
          .doc(UserManager.userInfo['uid'])
          .get();
      await FirebaseFirestore.instance
          .collection(Helper.userField)
          .doc(UserManager.userInfo['uid'])
          .delete();
      var user = {};
      snapshot.data()!.forEach((key, value) {
        user = {
          ...user,
          key: key == 'email'
              ? email
              : key == 'password'
                  ? password
                  : key == 'userName'
                      ? userName
                      : value
        };
      });
      await FirebaseFirestore.instance
          .collection(Helper.userField)
          .doc(uuid)
          .set({
        ...user,
      });
      var j = {};
      user.forEach((key, value) {
        j = {...j, key.toString(): value.toString()};
      });
      await Helper.saveJSONPreference(Helper.userField, {...j, 'uid': uuid});
      await UserManager.getUserInfo();
      setState(() {});
      isSettingAction = false;
      setState(() {});
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        uuid = userCredential.user!.uid;
        print('this is save account uuid: $uuid');
      } else {}
      isSettingAction = false;
      setState(() {});
    } catch (e) {
      rethrow;
    }
  }

  changePassword(email, password) async {
    var userManager = UserManager.userInfo;
    var uuid = '';
    isSettingAction = true;
    setState(() {});
    if (password.length < Helper.passwordMinLength) {
      isSettingAction = false;
      setState(() {});
      return;
    }
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userManager['email'], password: userManager['password']);
    await FirebaseAuth.instance.currentUser?.delete();

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      uuid = userCredential.user!.uid;
      var snapshot = await FirebaseFirestore.instance
          .collection(Helper.userField)
          .where('email', isEqualTo: email)
          .get();
      await FirebaseFirestore.instance
          .collection(Helper.userField)
          .doc(snapshot.docs[0].id)
          .delete();
      var user = {};
      snapshot.docs[0].data().forEach((key, value) {
        user = {...user, key: key == 'password' ? password : value};
      });
      await FirebaseFirestore.instance
          .collection(Helper.userField)
          .doc(uuid)
          .set({
        ...user,
      });
      var j = {};
      user.forEach((key, value) {
        j = {...j, key.toString(): value.toString()};
      });
      await Helper.saveJSONPreference(Helper.userField, {...j, 'uid': uuid});
      await UserManager.getUserInfo();
      setState(() {});
      isSettingAction = false;
      setState(() {});
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('email already in use');
      } else {}
      isSettingAction = false;
      setState(() {});
    } catch (e) {
      rethrow;
    }
  }

  profileChange(profile) async {
    if (profile.isNotEmpty) {
      isProfileChange = true;
      setState(() {});
      var userManager = UserManager.userInfo;
      var snapshot = await FirebaseFirestore.instance
          .collection(Helper.userField)
          .where('userName', isEqualTo: userManager['userName'])
          .get();
      await FirebaseFirestore.instance
          .collection(Helper.userField)
          .doc(snapshot.docs[0].id)
          .update({...profile});
      profile.forEach((key, value) {
        userManager[key] = value;
      });
      var j = {};
      userManager.forEach((key, value) {
        j = {...j, key.toString(): value};
      });
      await Helper.saveJSONPreference(Helper.userField, {...j});
      await UserManager.getUserInfo();
      setState(() {});
      isProfileChange = false;
      setState(() {});
      Helper.showToast("Succesfully updated your profile!");
    }
  }

  deleteUserAccount(context) async {
    isProfileChange = true;
    setState(() {});
    try {
      var userManager = UserManager.userInfo;
      await RelysiaManager.deleteUser(token).then(
        (value) async => {
          if (value == 1)
            {
              Helper.showToast("Success"),
            }
          else if (value == 2)
            {
              await RelysiaManager.authUser(email, password).then(
                (res) async => {
                  if (res["data"] != null)
                    {
                      if (res['statusCode'] == 200)
                        {
                          token = res['data']['token'],
                          await RelysiaManager.deleteUser(token),
                        }
                      else
                        {
                          Helper.showToast(res['data']['msg']),
                        }
                    }
                  else
                    {
                      Helper.showToast(res['data']),
                    }
                },
              ),
            }
        },
      );
      var snapshot = await FirebaseFirestore.instance
          .collection(Helper.userField)
          .where('userName', isEqualTo: userManager['userName'])
          .get();
      FirebaseFirestore.instance
          .collection(Helper.userField)
          .doc(snapshot.docs[0].id)
          .delete()
          .then((_) async {
        // delete account on authentication after user data on database is deleted
        await FirebaseAuth.instance.currentUser?.delete();
      });
    } catch (e) {
      print(e);
    }
    timer?.cancel();
    UserManager.isLogined = false;
    await Navigator.pushReplacementNamed(context, RouteNames.login);
    isProfileChange = false;
    setState(() {});
  }

  pinPost() async {
    var pinData = UserManager.userInfo['pinnedPost'];
    pinData = pinData
        .where((eachPage) => eachPage['pageName'] == eachPage['pageName']);
    await FirebaseFirestore.instance
        .collection(Helper.userField)
        .doc(UserManager.userInfo['uid'])
        .update({
      'pinnedPost': [
        ...UserManager.userInfo['uid'],
      ]
    });
  }

  //for Paywall
  Future<bool> payShnToken(String payMail, String amount, String notes) async {
    bool payResult = false;
    if (token == '') {
      var relysiaAuth = await RelysiaManager.authUser(
          UserManager.userInfo['email'], UserManager.userInfo['password']);
      token = relysiaAuth['data']['token'];
    }
    await RelysiaManager.payNow(token, payMail, amount, notes).then(
      (value) => {
        Helper.showToast(value),
        if (value == 'Successfully paid')
          {
            payResult = true,
          }
        else
          {
            payResult = false,
          }
      },
    );
    return payResult;
  }

  showModal(context_1, email, password) {
    TextEditingController passwordController =
        TextEditingController(); // String token = "";
    showDialog(
      context: context_1,
      builder: (BuildContext context) => AlertDialog(
        title: Row(
          children: [
            Expanded(
              child: SizedBox(
                  width: SizeConfig(context).screenWidth < 600 ? 200 : 400,
                  height: 60,
                  child: Container(
                    color: Colors.blue,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 10),
                    child: const Text(
                      'Account already exists in Relysia, please enter same credentials',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  )),
            ),
          ],
        ),
        content: Row(
          children: [
            Expanded(
              child: Container(
                width: SizeConfig(context).screenWidth < 600 ? 300 : 500,
                alignment: Alignment.center,
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      obscureText: true,
                      controller: passwordController,
                      onChanged: (value) {
                        existPwd = value;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Password",
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 13)),
                    RoundedLoadingButton(
                      successColor: Colors.blue,
                      // ignore: sort_child_properties_last
                      child: const Text('Continue',
                          style: TextStyle(color: Colors.white)),
                      controller: btnController,
                      onPressed: () => loginRelysiaAgain(
                        btnController,
                        context_1,
                        passwordController.text,
                        existPwd,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loginRelysiaAgain(RoundedLoadingButtonController controller, context_1,
      pwdController, existPwd) async {
    bool? result;
    if (existPwd != '') {
      await RelysiaManager.authUser(email, pwdController).then(
        (responseData) async => {
          if (responseData['data'] != null)
            {
              if (responseData['statusCode'] == 200)
                {
                  token = responseData['data']['token'],
                  result = await relysiaAuthUser(
                      context_1, email, password, existPwd, token),
                  if (result == true)
                    {
                      await registerUserInfo(),
                      await UserManager.getUserInfo(),
                      RouteNames.userName = signUpUserInfo['userName'],
                      isSendRegisterInfo = false,
                      isLogined = true,
                      controller.success(),
                      Navigator.pushReplacementNamed(
                          context, RouteNames.started),
                      setState(() {}),
                    }
                  else
                    {
                      controller.error(),
                    }
                }
              else
                {
                  Helper.showToast("INVALID_PASSWORD"),
                  existPwd = "",
                  showModal(context_1, email, password)
                }
            }
        },
      );
    } else {
      Helper.showToast('Enter Password');
    }
  }

  relysiaAuthUser(context, email, password, existpwd, token) async {
    var resData = {};
    bool state = false;
    await RelysiaManager.createWallet(token).then(
      (value) async => {
        if (value == 0)
          {
            Helper.showToast("Error occurs while create wallet"),
            setState(() {}),
          }
        else
          {
            await RelysiaManager.authUser(email, existPwd).then(
              (responseData) async => {
                if (responseData['data'] != null)
                  {
                    if (responseData['statusCode'] == 200)
                      {
                        token = responseData['data']['token'],
                        await RelysiaManager.getPaymail(token)
                            .then((resData) async => {
                                  if (resData['paymail'] != null)
                                    {
                                      paymail = resData['paymail'],
                                      walletAddress = resData['address'],
                                      state = true,
                                    }
                                })
                      }
                    else
                      {
                        resData = responseData['data'],
                        if (resData['msg'] == 'INVALID_EMAIL')
                          {
                            Helper.showToast('You didn\'t sign up in Relysia!'),
                            state = false,
                          }
                        else if (resData['msg'] == 'EMAIL_NOT_FOUND')
                          {
                            Helper.showToast('Email Not Found!'),
                            state = false,
                          }
                        else
                          {Helper.showToast(resData['msg']), setState(() {})},
                        isSendRegisterInfo = false,
                        setState(() {}),
                      }
                  }
                else
                  {
                    isSendRegisterInfo = false,
                    state = false,
                    setState(() {}),
                  }
              },
            ),
          }
      },
    );
    return state;
  }
}
