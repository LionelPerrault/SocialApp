import 'dart:convert';
import 'dart:html';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/helper.dart';
import '../managers/relysia_manager.dart';
import '../models/tokenlogin.dart';
import '../models/user.dart';
import 'package:flutter/material.dart';

class HomeController extends ControllerMVC {
    factory HomeController([StateMVC? state]) =>
        _this ??= HomeController._(state);
    HomeController._(StateMVC? state)
        : user = User(),
          token = '',
          email = 'borismuslin.bm@gmail.com',
          password = 'wjdwkdwns',
          payMail = '4064@relysia.com',
          amount = '10',
          resData = {},
          balance = 0,
          paymail = '',
          address = '',
          qrCode = '',
          themeLight = false,
          isConnected = false,
          isCreatingAccount = false,
          isSendingTokenQr = false,
          emailAlreadyExists = false,
          super(state);
          
    static HomeController? _this;

    
    User user;
    String token;
    String email;
    String password;
    String payMail;
    String amount;
    String paymail;
    String address;
    String qrCode;
    var resData = {};
    bool themeLight = false;
    bool isConnected = false;
    int balance = 0;
    bool isSendingToken = false;
    bool isSendingTokenQr = false;
    bool isCreatingAccount = false;
    bool emailAlreadyExists = false;
    TokenLogin? loginSaved = null;
    final authdata = FirebaseFirestore.instance
      .collection(Helper.tokenName)
      .withConverter<TokenLogin>(
        fromFirestore: (snapshots, _) => TokenLogin.fromJSON(snapshots.data()!),
        toFirestore: (tokenlogin, _) => tokenlogin.toMap(),
      );
    Future<bool> checkIfWallet() async{

        //await removeAllPreference();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? paymail1 = prefs.getString(Helper.tokenName);
        if (paymail1 == null)
        {
          return false;
        }else
        {
          return true;
          
        }
    }
    void getWalletFromPref() async
    {
      Helper.getJSONPreference(Helper.tokenName).then((value) => {
        print(value),
        if (value['paymail'] != null)
        {
          paymail = value['paymail'],
          address = value['address'],
          email = value['email'],
          password = value['password'],
          loginUser(null),
          setState(() { })
        }
      });
    }
    Future<void> removeAllPreference()
    async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove(Helper.tokenName);
    }
    
    Future<void> saveInfoPreferences()
    async {
      await Helper.saveJSONPreference(Helper.tokenName, {
        'paymail':paymail,
        'address':address,
        'email':email,
        'password':password,
      });
      QuerySnapshot<TokenLogin> querySnapshot = await authdata.where('email', isEqualTo:email).get();
      if (querySnapshot.size == 0)
      {
         await FirebaseFirestore.instance.collection(Helper.tokenName).add({
        'paymail': paymail,
        'address': address,
        'email': email,
        'password': password,
        });

      }

    }
    
    void changeTheme(bool theme)
    {
       Helper.setting.value.isBright = theme;
       // ignore: invalid_use_of_protected_member
       Helper.setting.notifyListeners();
       setState(() {
          themeLight = theme;
       });
    }

    void changeLaguage(String languageCode)
    {
      Helper.setting.value.language = Locale(languageCode, '');
      Helper.setting.notifyListeners();
    }

    void getBalance()
    {
      RelysiaManager.getBalance(token).then((res) => {
        print('balance is $res'),
        balance = res,
        setState(() {
        })
      }
      );
    }
    String createRandNumber()
    {
      var rng = Random();
      int randomNumber = rng.nextInt(100);
      return randomNumber.toString();
    }
    String createPassword()
    {
      String password = "";
      for (int i =0; i<6; i++)
      {
        password = password + createRandNumber(); 
      }
      return password;
    }
    void createWallet() async
    {
      
      QuerySnapshot<TokenLogin> querySnapshot = await authdata.where('email', isEqualTo:email).get();
      if (querySnapshot.size > 0)
      {
        
        TokenLogin login =  querySnapshot.docs[0].data();
        login.documentId = querySnapshot.docs[0].id;
        var paymail = login.paymail;
        var address = login.address;
        var email = login.email;
        var password = login.password;
        var documentId = login.documentId;
        //load data;
        await Helper.saveJSONPreference(Helper.tokenName, {
          'paymail':paymail ,
          'address':address,
          'email':email,
          'password':password,
          'documentId':documentId,
        });
        
        loginSaved = login;
        getWalletFromPref();
        return;
      }

      isCreatingAccount = true;
      setState(() { });
      String token = "";
      //email = "test${createRandNumber()}@gmail.com";
      password = createPassword();
      paymail = "";
      address = "";
      print("email is ${email}");
      print("password is ${password}");
      var prefs;
      RelysiaManager.createUser(email,password).then((responseData) => {
        if (responseData['data'] != null){
            if (responseData['statusCode'] == 200){
                token = responseData['data']['token'],
                RelysiaManager.createWallet(token).then((rr) => {
                  if (rr== 0){
                    Helper.showToast("error occurs while create wallet"),
                    isCreatingAccount = false,
                    setState(() { })
                  }
                  else{
                    
                    RelysiaManager.authUser(email,password).then(
                      (responseData) =>{
                        if (responseData['data'] != null){
                          if (responseData['statusCode'] == 200){
                              token =  responseData['data']['token'],
                              RelysiaManager.getPaymail(token).then((response) async =>{
                                isCreatingAccount = false,
                                setState(() { }),
                                if(response['paymail'] != null)
                                {
                                  paymail = response['paymail'],
                                  address = response['address'],  
                                  saveInfoPreferences(),
                                  Helper.showToast("Successfully Created Account"),
                                  setState(() {
                                  })
                                }
                              })
                          }
                          else{
                            resData = responseData['data'],
                            if (resData['msg'] == 'INVALID_EMAIL')
                            {
                                Helper.showToast('You didn\'t sign up in Relysia!'),
                            } 
                            else if (resData['msg'] == 'EMAIL_NOT_FOUND')
                            {
                                Helper.showToast('Email Not Found!'),
                            } 
                            else{
                              Helper.showToast(resData['msg']),
                            }
                          }
                              
                        }else
                        {
                          
                        }
                          
                        
                      }
                    )
                  }
                })
                
            }
            else{
              resData = responseData['data'],
              Helper.showToast(resData['msg']),
              //if (resData['msg'] == 'EMAIL_EXISTS')
              //{
              //  emailAlreadyExists = true,
              //},
              isCreatingAccount = false,
              setState(() { })
            }
                
          }else
          {
              Helper.showToast("error"),
              isCreatingAccount = false,
              setState(() { })
          }
      });
    }
    //"uri": "payto:90@relysia.com?purpose=cashback&amount=0.013",
    bool processQrCode()
    {
      if (qrCode.startsWith("payto:"))
      {
        qrCode = qrCode.replaceAll("payto:", "");
        List<String> s = qrCode.split("?");
        if (s.length == 2)
        {
          payMail = s[0];
          qrCode = s[1];
          if (qrCode.startsWith("purpose=cashback&"))
          {
            qrCode = qrCode.replaceAll("purpose=cashback&", "");
            List<String> s = qrCode.split("=");
            if (s.length == 2)
            {
              amount = s[1]; 
              return true;
            }
          }
        }
      }
      return false;
    }
    void payNow(BuildContext context, bool back)
    {
       if (back)
       {
         isSendingToken = true;
         Navigator.of(context).pop(true);
       }
       else{
         isSendingTokenQr = true;
       }
        setState(() {
        });
       RelysiaManager.payNow(token,payMail,amount).then((value) =>{ 
        if (value == 0)
        {
          print('failed pay'),
          Helper.showToast('Payment failed'),
        }
        else{
          print('success pay'),
          Helper.showToast('Payment done'),
          getBalance(),
        },
        if(back){
          isSendingToken = false,}
        else {
          isSendingTokenQr = false,},
        setState(() {
        }),
       }
       );
    }
    //
    void loginUser(BuildContext? context) {
      print("try to login user....");
      RelysiaManager.authUser(email,password).then(
        (responseData) =>{
          if (responseData['data'] != null){
            if (responseData['statusCode'] == 200){
                Helper.showToast('Success fully Login'),
                isConnected = true,
                token = responseData['data']['token'],
                if (context != null)  
                  Navigator.of(context).pop(true),
                getBalance(),
                                RelysiaManager.getPaymail(token).then((response) async =>{
                                setState(() { }),
                                if(response['paymail'] != null)
                                {
                                  paymail = response['paymail'],
                                  address = response['address'],  
                                  saveInfoPreferences(),
                                  Helper.showToast("Check Your Info"),
                                  setState(() {
                                  })
                                }
                              }),
                setState(() {
                })
            }
            else{
              resData = responseData['data'],
              if (resData['msg'] == 'INVALID_EMAIL')
              {
                  Helper.showToast('You didn\'t sign up in Relysia!'),
              } 
              else if (resData['msg'] == 'EMAIL_NOT_FOUND')
              {
                  Helper.showToast('Email Not Found!'),
              } 
              else{
                Helper.showToast(resData['msg']),
              }
            }
                
          }else
          {
            
          }
            
          
        }
      );
    }
}
            