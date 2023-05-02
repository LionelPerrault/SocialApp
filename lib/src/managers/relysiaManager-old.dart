import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shnatter/src/controllers/HomeController.dart';
import 'package:shnatter/src/helpers/relysiaHelper.dart';

class RelysiaManager {
  static const apiUrlAuth = 'https://api.relysia.com/v1/auth';
  static const serviceId = '4ea24081-3a73-4997-bdba-750541735c79';
  static var resToken = {};
  static var trHistory = [];
  static var history = {};
  static var t = 0;
  // ignore: prefer_typing_uninitialized_variables
  static var nextPageTokenId;
  static Future<Map> authUser(String email, String password) async {
    Map responseData = {};
    try {
      String bodyCode =
          jsonEncode(<String, String>{'email': email, 'password': password});
      await http
          .post(
            Uri.parse(apiUrlAuth),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'serviceID': serviceId
            },
            body: bodyCode,
          )
          .then((res) => {
                responseData = jsonDecode(res.body),
                //print(responseData),
              });
    } catch (exception) {
      print("occurs exception" + exception.toString());
    }
    return responseData;
  }

  static Future<Map> createUser(String email, String password) async {
    Map responseData = {};

    try {
      String bodyCode =
          jsonEncode(<String, String>{'email': email, 'password': password});
      await http
          .post(
            Uri.parse('https://api.relysia.com/v1/signUp'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'serviceID': serviceId
            },
            body: bodyCode,
          )
          .then((res) => {
                responseData = jsonDecode(res.body),
                //print(responseData),
              });
    } catch (exception) {
      if (kDebugMode) {
        print("occurs exception" + exception.toString());
      }
    }
    return responseData;
  }

  static Future<int> createWallet(String token) async {
    var r = 0;
    var respondData = {};

    try {
      await http
          .get(Uri.parse('https://api.relysia.com/v1/createWallet'), headers: {
        'authToken': token,
        'serviceID': serviceId,
        'walletTitle': '00000000-0000-0000-0000-000000000000',
        'paymailActivate': 'true',
      }).then((res) => {
                r = 1,
                respondData = jsonDecode(res.body),
              });
      // ignore: empty_catches
    } catch (exception) {}
    return r;
  }

  static Future<Map> getPaymail(String token) async {
    Map paymail = {};
    var resData = {};
    try {
      await http.get(Uri.parse('https://api.relysia.com/v1/address'), headers: {
        'authToken': token,
        'serviceID': serviceId,
      }).then((res) => {
            resData = jsonDecode(res.body),
            if (resData['statusCode'] == 200)
              {
                paymail['paymail'] = resData['data']['paymail'],
                paymail['address'] = resData['data']['address'],
              },
          });
    } catch (exception) {
      print(exception.toString());
    }
    return paymail;
  }

  static Future<Map> getBalance(String token) async {
    var balance = 0;
    var result = '';
    try {
      await http.get(Uri.parse('https://api.relysia.com/v2/balance'), headers: {
        'authToken': token,
        'serviceID': serviceId,
      }).then((res) async {
        resToken = jsonDecode(res.body);
        if (resToken['statusCode'] == 200) {
          var coin = [];
          for (var i = 0; i < resToken['data']['coins'].length; i++) {
            if (resToken['data']['coins'][i]['tokenId'] != null) {
              coin.add(resToken['data']['coins'][i]);
            }
            if (resToken['data']['coins'][i]['tokenId'] ==
                RelysiaHelper.tokenId) {
              balance = resToken['data']['coins'][i]['amount'];
            }
          }
          RelysiaHelper.myToken = coin;
          result = 'true';
        } else if (resToken['statusCode'] == 401 &&
            resToken['data']['msg'] == 'Invalid authToken provided') {
          result = 'false';
        }
      });
    } catch (exception) {
      if (kDebugMode) {
        print(exception.toString());
      }
    }
    return {'balance': balance, 'success': result};
  }

  static Future<Map> getTransactionHistory(String token, nextPageToken) async {
    var result = '';

    try {
      await http.get(Uri.parse('https://api.relysia.com/v2/history'), headers: {
        'authToken': token,
        'nextPageToken': nextPageToken,
        'serviceID': serviceId,
        'version': '1.1.0'
      }).then((res) async {
        history = jsonDecode(res.body);
        if (history['statusCode'] == 200) {
          if (nextPageToken == '') {
            var list = [];

            history['data']['histories'].forEach((elem) {
              elem['to'].forEach((e) {
                if (e['tokenId'] == RelysiaHelper.tokenId) {
                  list.add({
                    'txId': e['txId'] ?? '',
                    'from': elem['from'] ?? '',
                    'notes': elem['notes'] ?? '',
                    'to': e['to'] ?? '',
                    'balance_change': elem['totalAmount'] ?? '',
                    'timestamp': elem['timestamp'] ?? ''
                  });
                }
              });
            });
            trHistory = list;
          } else {
            var list = [];

            history['data']['histories'].forEach((elem) {
              elem['to'].forEach((e) {
                if (e['tokenId'] == RelysiaHelper.tokenId) {
                  list.add({
                    'txId': e['txId'],
                    'from': elem['from'],
                    'to': e['to'],
                    'balance_change': elem['totalAmount'],
                    'timestamp': elem['timestamp'],
                    'notes': elem['notes'] ?? ''
                  });
                }
              });
            });

            for (int i = 0; i < trHistory.length; i++) {
              list.add(trHistory[i]);
            }
            trHistory = list;
          }
          nextPageTokenId = history['data']['meta']['nextPageToken'];
          result = 'true';
        } else if (history['statusCode'] == 401 &&
            history['data']['msg'] == 'Invalid authToken provided') {
          result = 'false';
        }
      });
    } catch (exception) {}
    return {'history': trHistory, 'success': result};
  }

  static Future<Map> payNow(
      String token, String payMail, String amount, String notes) async {
    int r = 0;
    var respondData = {};
    try {
      await http
          .post(
        Uri.parse('https://api.relysia.com/v1/send'),
        headers: {
          'authToken': token,
          'content-type': 'application/json',
          'serviceID': serviceId,
        },
        body:
            '{ "dataArray" : [{"to" : "$payMail","amount" : $amount ,"tokenId" : "${RelysiaHelper.tokenId}","notes":"$notes"}]}',
      )
          .then(
        (res) async {
          respondData = jsonDecode(res.body);
          if (respondData['statusCode'] == 200) {
            r = 1;
          } else if (respondData['statusCode'] == 401 &&
              respondData['data']['msg'] == 'Invalid authToken provided') {
            r = 2;
          }
        },
      );
    } catch (exception) {
      if (kDebugMode) {
        print(exception.toString());
      }
    }
    return {'success': r};
  }

  static Future getLeaderBoard(token, nextPageToken) async {
    var response = {};
    var success = false;
    var next;
    var leaderBoard = HomeController().leaderBoard;
    int count = 0;
    next = nextPageToken;
    var strPaymailList = "";
    try {
      for (int i = 0; i < RelysiaHelper.adminDocId.length; i++) {
        String s = RelysiaHelper.adminDocId[i];
        DocumentSnapshot<Map<String, dynamic>> data =
            await FirebaseFirestore.instance.collection('User').doc(s).get();
        strPaymailList = strPaymailList + "," + data['paymail'];
      }
    } catch (exception) {}
    try {
      while (count < 10 && next != 'null') {
        await http.get(
            Uri.parse(
                'https://api.relysia.com/v1/leaderboard?nextPageToken=$next'),
            headers: {
              'tokenId': RelysiaHelper.tokenId,
              'authToken': token,
              'serviceID': serviceId,
            }).then((res) async {
          response = jsonDecode(res.body);
          if (response['statusCode'] == 200) {
            response['data']['leaderboard'].forEach((elem) => {
                  if (elem['paymail'] != 'poiintz@relysia.com' &&
                      !elem['paymail'].contains('shnatter') &&
                      elem['paymail'].contains('@poiintz.app') &&
                      !strPaymailList.contains(elem['paymail']))
                    {leaderBoard.add(elem), count++}
                });
            next = response['data']['nextPageToken'].toString();
            success = true;
          } else if (response['statusCode'] == 401) {
            success = false;
            next = 'null';
          }
        });
      }
    } catch (exception) {
      if (kDebugMode) {
        print("Exception:$exception");
      }
    }
    return {'success': success, 'data': leaderBoard, 'nextPageToken': next};
  }
}
