import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shnatter/src/managers/user_manager.dart';

import '../helpers/helper.dart';

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
    print(2);
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
                print('this is responseData in createUser: $responseData'),
              });
    } catch (exception) {
      print("occurs exception" + exception.toString());
    }
    print(3);
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
                print(respondData),
              });
      // ignore: empty_catches
    } catch (exception) {
      print(exception.toString());
    }
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

  static Future<int> getBalance(String token) async {
    var balance = 0;
    try {
      await http.get(Uri.parse('https://api.relysia.com/v2/balance'), headers: {
        'authToken': token,
        'serviceID': serviceId,
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

  static Future<String> payNow(
      String token, String payMail, String amount, String notes) async {
    String returnData = '';
    var respondData = {};
    try {
      var senderBalance = await getBalance(token);
      if (senderBalance < int.parse(amount)) {
        returnData = 'Not enough token amount';
      } else {
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
            .then(
              (res) => {
                respondData = jsonDecode(res.body),
                if (respondData['statusCode'] == 200)
                  {
                    returnData = 'Successfully paid',
                    print("success" + respondData['statusCode'].toString()),
                  }
                else
                  {
                    returnData = 'Failed payment',
                  },
              },
            );
      }
    } catch (exception) {
      print(exception.toString());
    }
    return returnData;
  }

  static Future<int> deleteUser(String token) async {
    var r = 0;
    var respondData = {};
    try {
      await http.delete(Uri.parse('https://api.relysia.com/v1/user'), headers: {
        'authToken': token,
        'serviceID': serviceId,
        'walletTitle': '00000000-0000-0000-0000-000000000000',
        'paymailActivate': 'true',
      }).then((res) => {
            respondData = jsonDecode(res.body),
            if (respondData['statusCode'] == 200)
              {
                r = 1,
              }
            else if (respondData['statusCode'] == 401 &&
                respondData['data']['msg'] == "Invalid authToken provided")
              {
                r = 2,
              }
            else if (respondData['statusCode'] == 401 &&
                respondData['data']['msg'] == "authToken not found")
              {
                r = 2,
              }
          });
      // ignore: empty_catches
    } catch (exception) {
      Helper.showToast(
          "An error has occurred. Please check your internet connectivity or try again later");
    }
    return r;
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