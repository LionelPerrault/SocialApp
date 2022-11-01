import 'dart:html';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:my_app/src/helpers/helper.dart';
import 'package:my_app/src/routes/route_names.dart';

import '../controllers/HomeController.dart';
import '../utils/size_config.dart';
import '../widget/mprimary_button.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
    HomeScreen({Key? key})
        : con = HomeController(),
          super(key: key);
    final HomeController con;

    @override
    State createState() => HomeScreenState();
}

class HomeScreenState extends mvc.StateMVC<HomeScreen> {
    bool light = true;
    final List<String> imagesList = [
      'assets/images/3.jpg',
      'assets/images/2.jpg',
      'assets/images/1.jpg',
    ];
    var rR;
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    TextEditingController emailController = TextEditingController(text:'borismuslin.bm@gmail.com');
    TextEditingController passwordController = TextEditingController(text:'wjdwkdwns');

    TextEditingController payMailController = TextEditingController(text:'4064@relysia.com');
    TextEditingController amountController = TextEditingController(text:'10');
    //
    @override
    void initState() {
      add(widget.con);
      con = controller as HomeController;
      super.initState();
      con.checkIfWallet().then((value) => {
        if (value == false)
        {
          showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          addEmail(context),
                    )
        }else{
          con.getWalletFromPref()
        }
      });
    }

    late HomeController con;

    @override
    Widget addEmail(BuildContext context) {
      return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
        title: const Text('Create Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: emailController,
              onChanged: (newIndex) {
                con.setState(() => con.email=newIndex);
              },
              decoration: const InputDecoration(
                icon: Icon(Icons.email),
                hintText: 'Email',
              ),
              onSaved: (String? value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
              },
              validator: (String? value) {
                return (value != null && value.contains('@'))
                    ? 'Do not use the @ char.'
                    : null;
              },
            ),
            /*Container(
                margin: const EdgeInsets.only(top: 20),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    onChanged: (value) => {con.password = value},
                    decoration: const InputDecoration(
                        icon: Icon(Icons.password_rounded), hintText: 'Password'),
                    onSaved: (String? value) {
                      // This optional block of code can be used to run
                      // code when the user saves the form.
                    },
                    validator: (String? value) {
                      return (value != null && value.contains('@'))
                          ? 'Do not use the @ char.'
                          : null;
                    },
                  ),
                )),*/
            Container(
              margin: const EdgeInsets.only(top: 20, right: 0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.greenAccent,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)),
                  minimumSize: Size(100, 50),
                ),
                onPressed: () {
                 con.createWallet();
                 Navigator.of(context).pop();

                },
                child: const Text('Create',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      );
      });
      
      
    }

    @override
    Widget askPassword(BuildContext context) {
      con.emailAlreadyExists = false;
      return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
        title: const Text('Your Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            
            Container(
                margin: const EdgeInsets.only(top: 20),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    onChanged: (value) => {con.password = value},
                    decoration: const InputDecoration(
                        icon: Icon(Icons.password_rounded), hintText: 'Password'),
                    onSaved: (String? value) {
                      // This optional block of code can be used to run
                      // code when the user saves the form.
                    },
                    validator: (String? value) {
                      return (value != null && value.contains('@'))
                          ? 'Do not use the @ char.'
                          : null;
                    },
                  ),
                )),
            Container(
              margin: const EdgeInsets.only(top: 20, right: 0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.greenAccent,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)),
                  minimumSize: Size(100, 50),
                ),
                onPressed: () {
                 con.loginUser(context);
                },
                child: const Text('Connect',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      );
      });
      
      
    }

    @override
    Widget userLogin(BuildContext context) {
      return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
        title: const Text('Sign In'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: emailController,
              onChanged: (newIndex) {
                con.setState(() => con.email=newIndex);
              },
              decoration: const InputDecoration(
                icon: Icon(Icons.email),
                hintText: 'Email',
              ),
              onSaved: (String? value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
              },
              validator: (String? value) {
                return (value != null && value.contains('@'))
                    ? 'Do not use the @ char.'
                    : null;
              },
            ),
            Container(
                margin: const EdgeInsets.only(top: 20),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    onChanged: (value) => {con.password = value},
                    decoration: const InputDecoration(
                        icon: Icon(Icons.password_rounded), hintText: 'Password'),
                    onSaved: (String? value) {
                      // This optional block of code can be used to run
                      // code when the user saves the form.
                    },
                    validator: (String? value) {
                      return (value != null && value.contains('@'))
                          ? 'Do not use the @ char.'
                          : null;
                    },
                  ),
                )),
            Container(
              margin: const EdgeInsets.only(top: 20, right: 0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.greenAccent,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)),
                  minimumSize: Size(100, 50),
                ),
                onPressed: () {
                  con.loginUser(context);
                  setState(){

                  }
                },
                child: const Text('Connect',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      );
      });
      
      
    }

    @override
    Widget tokenPay(BuildContext context) {
      return AlertDialog(
        title: const Text('Transfer Token'),
        content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return con.isSendingToken?
          CircularProgressIndicator():
         Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: payMailController,
              onChanged: (value) => { con.payMail = value},
              decoration: const InputDecoration(
                icon: Icon(Icons.email),
                hintText: 'To',
              ),
              onSaved: (String? value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
              },
              validator: (String? value) {
                return (value != null && value.contains('@'))
                    ? 'Do not use the @ char.'
                    : null;
              },
            ),
            Container(
                margin: const EdgeInsets.only(top: 20),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: TextFormField(
                    controller: amountController,
                    obscureText: false,
                    onChanged: (value) => { con.amount = value},
                    decoration: const InputDecoration(
                        icon: Icon(Icons.attach_money_outlined), hintText: 'Amount'),
                    onSaved: (String? value) {
                      // This optional block of code can be used to run
                      // code when the user saves the form.
                    },
                    validator: (String? value) {
                      return (value != null && value.contains('@'))
                          ? 'Do not use the @ char.'
                          : null;
                    },
                  ),
                )),
            Container(
              margin: const EdgeInsets.only(top: 20, right: 0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.greenAccent,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)),
                  minimumSize: Size(100, 50),
                ),
                onPressed: () {
                  con.payNow(context,true);
                },
                child: const Text('Transfer',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        );
        })
      );
    }
    @override
    Widget build(BuildContext context) {
      
      con.emailAlreadyExists? 
      Future.delayed(
      const Duration(microseconds: 50),
      () =>       {Navigator.of(context).pop(true),
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          askPassword(context),
                    )},
      )
       :null;
      return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.wallet_homepage),
          ),
          body: ListView(
            children: [
              con.paymail!=''? Row(
                children: [
                  Text("email:${con.email};"),
                  Text("paymail:${con.paymail};"),
                  Text("address:${con.address};"),
                ],
              ):Text(""),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    MyPrimaryButton(
                    buttonName:  "English",
                    onPressed: () =>{
                      con.changeLaguage("en")
                    },
                    miniumSize: const Size(60, 30),
                    ),
                    Padding(padding: EdgeInsets.all(2.0),),
                    MyPrimaryButton(
                    buttonName:  "French",
                    onPressed: () =>{
                      con.changeLaguage("fr")
                    },
                    miniumSize: const Size(60, 30),
                    ),
                  ],),
                
                  Padding(padding: EdgeInsets.all(16.0),),
                  /*MyPrimaryButton(
                    isShowProgressive:con.isCreatingAccount,
                    buttonName:  "",
                    onPressed: () =>{
                      //con.createWallet()
                    },
                    miniumSize: const Size(200, 50),
                  ),*/
                  
                  //Padding(padding: EdgeInsets.all(16.0),),
                  /*MyPrimaryButton(
                  buttonName:  con.isConnected?con.email:AppLocalizations.of(context)!.wallet,
                  onPressed: () =>{
                    emailController.text = con.email,
                    passwordController.text = con.password,
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          userLogin(context),
                    )
                  },
                  miniumSize: const Size(100, 50),
                  ),*/
              ],),
              Row (
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("Change Theme"),
                  Switch(
                  // This bool value toggles the switch.
                  value: con.themeLight,
                  onChanged: (bool value) {
                    con.changeTheme(value);
                    setState(() {
                    });
                  },
                  ),
                ],
              ),
              CarouselSlider(
                options: CarouselOptions(
                  height: SizeConfig(context).screenHeight*0.4,
                  autoPlay: true,
                  viewportFraction: 0.8,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                ),
                items: imagesList
                    .map(
                      (item) => Center(
                        child: Image(image: AssetImage(item)),
                      ),
                    )
                    .toList(),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: MaterialButton(
                        shape: const CircleBorder(
                            side: BorderSide(
                                width: 2, color: Color.fromRGBO(68, 68, 68, 1))),
                        onPressed: () {},
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: 
                          Column(
                            children: const [
                              SizedBox(
                                child: Image(image: AssetImage(Helper.tokenIcon)),
                                width:20,
                                height: 20,
                              ),
                              
                              //Icon(Icons.token),
                              Text(
                                'Token',
                                style: TextStyle(
                                    //color: Color.fromRGBO(68, 68, 68, 1),
                                    fontSize: 20),
                              ),
                          ],
                          )
                          
                        ),
                      ),
                    ),
                    Flexible(
                        flex: 1,
                        child: MaterialButton(
                          shape: const CircleBorder(
                              side: BorderSide(
                                  width: 2,
                                  color: Color.fromRGBO(68, 68, 68, 1))),
                          onPressed: () {},
                          child:  Padding(
                            padding: EdgeInsets.all(40),
                            child: Text(
                              con.balance.toString(),
                              style: const TextStyle(
                                  //color: Color.fromRGBO(68, 68, 68, 1),
                                  fontSize: 24),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 50.0, bottom: 20),
                  width: double.infinity,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: 
                          MyPrimaryButton(
                            isShowProgressive: con.isSendingToken,
                            buttonName:con.isSendingToken?"Sending...":"Pay", 
                            onPressed: () =>
                            {
                              if (!con.isSendingToken)
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    tokenPay(context),
                              )
                            }
                            )
                        ),
                        Flexible(
                          flex: 1,
                          child: MyPrimaryButton(
                            buttonName:"Scan", 
                            isShowProgressive: con.isSendingTokenQr,
                            onPressed: () async =>
                            {
                                print("scan now ......"),
                                if (rR = await Navigator.of(context).pushNamed(RouteNames.qrCodeScan) is String)
                                {
                                  con.qrCode = rR as String,
                                  if (con.processQrCode())
                                    con.payNow(context,false),
                                }
                                else{
                                  con.qrCode = "payto:4064@relysia.com?purpose=cashback&amount=1",
                                  if (con.processQrCode())
                                    con.payNow(context, false),
                                }
                                  
                            }     
                            )
                        )
                      ]))
            ],
          ));
    }
}
