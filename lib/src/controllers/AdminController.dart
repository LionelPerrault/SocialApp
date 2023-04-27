import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shnatter/src/managers/relysia_manager.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import '../helpers/helper.dart';

enum PostType { timeline, profile, event, group }

class AdminController extends ControllerMVC {
  factory AdminController([StateMVC? state]) =>
      _this ??= AdminController._(state);
  AdminController._(StateMVC? state) : super(state);
  static AdminController? _this;

  // List<mvc.StateMVC> notifiers;

  @override
  Future<bool> initAsync() async {
    return true;
  }

  int usersNum = 0;
  int postsNum = 0;
  int eventsNum = 0;
  int groupsNum = 0;
  int onlineUsers = 0;
  late String adminEmail = '';
  late String adminPassword = '';
  late String backupPaymail = '';
  beforeFunction() async {
    DocumentSnapshot adminData = await Helper.systemSnap.doc('treasure').get();
    DocumentSnapshot backup = await Helper.systemSnap.doc('backPaymail').get();
    adminEmail = adminData['adminEmail'];
    adminPassword = adminData['adminPassword'];
    backupPaymail = backup['address'];
  }

  bool adminTotalPage = false;
  getBodyData() async {
    adminTotalPage = true;
    setState(() {});
    await beforeFunction();

    QuerySnapshot usersSnap = await Helper.userCollection.get();
    QuerySnapshot eventsSnap = await Helper.eventsData.get();
    QuerySnapshot groupsSnap = await Helper.groupsData.get();
    QuerySnapshot onlineUsersSnap = await FirebaseFirestore.instance
        .collection(Helper.onlineStatusField)
        .where('status', isEqualTo: 1)
        .get();
    await getTreasure();
    usersNum = usersSnap.docs.length;
    postsNum = eventsSnap.docs.length + groupsSnap.docs.length;
    eventsNum = eventsSnap.docs.length;
    groupsNum = groupsSnap.docs.length;
    onlineUsers = onlineUsersSnap.docs.length;

    adminTotalPage = false;
    setState(() {});
  }

  int treasure = 0;
  getTreasure() async {
    setState(() {});
    await RelysiaManager.authUser(adminEmail, adminPassword).then(
      (res) async => {
        if (res['data'] != null)
          {
            if (res['statusCode'] == 200)
              {
                token = res['data']['token'],
                await RelysiaManager.getBalance(token).then((value) {
                  treasure = value;
                  setState(() {});
                }),
              }
          }
        else
          {
            Helper.showToast('Something went wrong!'),
          }
      },
    );
  }

  String token = '';
  String nextPageTokenCount = '0';
  Future<List> getTransactionHistory(nextPageToken) async {
    DocumentSnapshot adminData = await Helper.systemSnap.doc('treasure').get();
    var trdata = [];
    var transactionData = [];
    var user = await Helper.userCollection.get();
    var allUser = user.docs;
    String sender = '';
    String recipient = '';

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
                        recipient = trdata[i]['to'],
                        for (int j = 0; j < allUser.length; j++)
                          {
                            if (trdata[i]['from'] ==
                                allUser[j].data()['paymail'])
                              {
                                sender = allUser[j].data()['userName'],
                              },
                            if (trdata[i]['to'] ==
                                    allUser[j].data()['walletAddress'] ||
                                trdata[i]['to'] == allUser[j].data()['paymail'])
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
                      },
                  },
                nextPageTokenCount = res['nextPageToken'],
                setState(() {}),
              }
          }
        else if (res['success'] == false)
          {
            await RelysiaManager.authUser(
                    adminData['adminEmail'], adminData['adminPassword'])
                .then(
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
                        await RelysiaManager.authUser(adminData['adminEmail'],
                                adminData['adminPassword'])
                            .then(
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

  List usersList = [];
  getUsers() async {
    var onlineStatus =
        await Helper.userCollection.orderBy('userName', descending: true).get();
    usersList = onlineStatus.docs;
    setState(() {});
  }

  List adminsList = [];
  getAdmins() async {
    var onlineStatus =
        await Helper.userCollection.where('admin', isEqualTo: 'admin').get();
    adminsList = onlineStatus.docs;
    setState(() {});
  }

  List onlineUsersList = [];
  getOnlineUsers() async {
    var onlineStatus = await FirebaseFirestore.instance
        .collection(Helper.onlineStatusField)
        .where('status', isEqualTo: 1)
        .get();
    List userList = [];
    for (var i = 0; i < onlineStatus.docs.length; i++) {
      var statusUser = await Helper.userCollection
          .where('userName', isEqualTo: onlineStatus.docs[i]['userName'])
          .get();
      if (statusUser.docs.isNotEmpty) userList.add(statusUser.docs[0]);
    }
    onlineUsersList = userList;
    setState(() {});
  }
}
