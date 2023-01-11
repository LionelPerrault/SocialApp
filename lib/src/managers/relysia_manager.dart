import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shnatter/src/managers/user_manager.dart';

class RelysiaManager {
  static final apiUrlAuth = 'https://api.relysia.com/v1/auth';
  static final serviceId = '9ab1b69e-92ae-4612-9a4f-c5a102a6c068';
  static final shnToken1 = '9a0e862be07d8aa56311e5b211a4fdf9ddf03b2f-BNAF';
  static final shnToken = '9a0e862be07d8aa56311e5b211a4fdf9ddf03b2f-SHNATST';
  static final adminEmail = 'kalininviktor848@gmail.com';
  static final adminPassword = '1topnotch@';
  static final adminPaymail = '3982@relysia.com';
  static var resToken = {};
  static Future<Map> authUser(String email, String password) async {
    Map responseData = {};
    try {
      String bodyCode =
          jsonEncode(<String, String>{'email': email, 'password': password});
      await http
          .post(
            Uri.parse(apiUrlAuth),
            headers: <String, String>{
              HttpHeaders.authorizationHeader: jsonEncode(
                  <String, String>{'Key': serviceId, 'Value': 'true'}),
              'Content-Type': 'application/json; charset=UTF-8',
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
    print(2);
    try {
      String bodyCode =
          jsonEncode(<String, String>{'email': email, 'password': password});
      await http
          .post(
            Uri.parse('https://api.relysia.com/v1/signUp'),
            headers: <String, String>{
              HttpHeaders.authorizationHeader: jsonEncode(
                  <String, String>{'Key': serviceId, 'Value': 'true'}),
              'Content-Type': 'application/json; charset=UTF-8',
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
    print(3);
    return responseData;
  }

  static Future<int> createWallet(String token) async {
    var authData = await authUser(UserManager.userInfo['relysiaEmail'],
        UserManager.userInfo['relysiaPassword']);
    token = authData['data']['token'];
    var r = 0;
    var respondData = {};
    try {
      await http.get(
          Uri.parse(
              'https://api.relysia.com/v1/createWallet?serviceID=$serviceId'),
          headers: {
            'authToken': token,
            // 'serviceID': serviceId,
            'walletTitle': '00000000-0000-0000-0000-000000000000',
            'paymailActivate': 'true',
          }).then((res) => {
            r = 1,
            respondData = jsonDecode(res.body),
            print(respondData),
          });
      // ignore: empty_catches
    } catch (exception) {
      print(exception.toString());
    }
    return r;
  }

  static Future<Map> getPaymail(String token) async {
    var authData = await authUser(UserManager.userInfo['relysiaEmail'],
        UserManager.userInfo['relysiaPassword']);
    token = authData['data']['token'];
    Map paymail = {};
    var resData = {};
    try {
      await http.get(
          Uri.parse('https://api.relysia.com/v1/address?serviceID=$serviceId'),
          headers: {
            'authToken': token,
          }).then((res) => {
            resData = jsonDecode(res.body),
            if (resData['statusCode'] == 200)
              {
                paymail['paymail'] = resData['data']['paymail'],
                paymail['address'] = resData['data']['address'],
              },
            print("success in get paymail ${resData}"),
          });
    } catch (exception) {
      print(exception.toString());
    }
    return paymail;
  }

  static Future<int> getBalance(String token) async {
    var authData = await authUser(UserManager.userInfo['relysiaEmail'],
        UserManager.userInfo['relysiaPassword']);
    token = authData['data']['token'];
    var balance = 0;
    try {
      await http.get(
          Uri.parse('https://api.relysia.com/v1/balance?serviceID=$serviceId'),
          headers: {
            'authToken': token,
          }).then((res) => {
            resToken = jsonDecode(res.body),
            print(resToken['data']['coins']),
            for (var i = 0; i < resToken['data']['coins'].length; i++)
              {
                if (resToken['data']['coins'][i]['tokenId'] == shnToken)
                  {
                    balance = resToken['data']['coins'][i]['amount'],
                  }
              },
          });
    } catch (exception) {
      print(exception.toString());
    }
    return balance;
  }

  // static Future<int> payNow(
  //     Map senderInfo, String payMail, String amount, String notes) async {
  //   var authData = await authUser(
  //       senderInfo['relysiaEmail'], senderInfo['relysiaPassword']);
  //   String sendToken = authData['data']['token'];
  //   int r = 0;
  //   var respondData = {};
  //   try {
  //     await http
  //         .post(
  //           Uri.parse('https://api.relysia.com/v1/send'),
  //           headers: {
  //             'authToken': sendToken,
  //             'content-type': 'application/json',
  //             'serviceID': serviceId,
  //           },
  //           body:
  //               '{ "dataArray" : [{"to" : "$payMail","amount" : $amount ,"tokenId" : "$shnToken","notes":"$notes"}]}',
  //         )
  //         .then(
  //           (res) => {
  //             respondData = jsonDecode(res.body),
  //             if (respondData['statusCode'] == 200) r = 1,
  //             print("success" + respondData['statusCode'].toString())
  //           },
  //         );
  //   } catch (exception) {
  //     print(exception.toString());
  //   }
  //   return r;
  // }

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
            '{ "dataArray" : [{"to" : "$payMail","amount" : $amount ,"tokenId" : "$shnToken","notes":"$notes"}]}',
      )
          .then((res) async {
        respondData = jsonDecode(res.body);
        if (respondData['statusCode'] == 200) {
          r = 1;
        } else if (respondData['statusCode'] == 401 &&
            respondData['data']['msg'] == 'Invalid authToken provided') {
          r = 2;
        }
      });
    } catch (exception) {
      print(exception.toString());
    }
    return {'success': r};
  }
}












/*
http
.post(
  Uri.parse(
      'https://api.relysia.com/v1/send?serviceID=9ab1b61e-92ae-4612-9a4f-c5a102a6c068&authToken=$token'),
  headers: {
    'authToken': '$token',
    'content-type': 'application/json',
    'serviceID': '9ab1b69e-92ae-4612-9a4f-c5a102a6c068'
  },
  body:
      '{ "dataArray" : [{"to" : "4064@shnatter.com","amount" : 10,"tokenId" : "$shnToken"}]}',
)
*/