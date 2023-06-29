// ignore_for_file: prefer_is_empty

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/footerbar.dart';

import '../controllers/UserController.dart';
import '../helpers/helper.dart';
import '../routes/route_names.dart';
import '../widget/mprimary_button.dart';
import '../widget/primaryInput.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key})
      : con = UserController(),
        super(key: key);
  final UserController con;
  @override
  State createState() => LoginScreenState();
}

class LoginScreenState extends mvc.StateMVC<LoginScreen> {
  bool isRememberme = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  String _verificationCode = '';
  String password = '';
  String email = '';
  bool enableTwoFactor = false;
  var isObscure = true;
  @override
  void initState() {
    add(widget.con);
    con = controller as UserController;
    super.initState();
  }

  late UserController con;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.blue;
    }

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      }, // Empty Function.
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Container(
                  height: SizeConfig(context).screenHeight -
                      SizeConfig(context).padding,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/main-background-min.jpg'), //NetworkImage("https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fmain-background-min.jpg?alt=media&token=47b6ab2c-74b4-455c-a61a-632cf6d476a8"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Column(
                        children: [
                          Container(
                            alignment: AlignmentDirectional.topCenter,
                            child: Container(
                              width: 340,
                              height: 540,
                              margin: EdgeInsets.only(
                                  top: 10,
                                  left: SizeConfig(context).screenWidth >
                                          SizeConfig.smallScreenSize
                                      ? SizeConfig(context).screenWidth * 0.2
                                      : 0),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5))),
                              child: enableTwoFactor
                                  ? twoFactorAuthentication()
                                  : ListView(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      children: <Widget>[
                                        Container(
                                          width: 455,
                                          height: 90,
                                          margin:
                                              const EdgeInsets.only(top: 50.0),
                                          color: const Color.fromARGB(
                                              255, 11, 35, 45),
                                          child: const Row(children: <Widget>[
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 45.0),
                                            ),
                                            Text('Login',
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 238, 238, 238),
                                                  fontSize: 30,
                                                )),
                                          ]),
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          margin: const EdgeInsets.only(
                                              top: 20.0, left: 30),
                                          child: SvgPicture.asset(
                                            'assets/images/shnatter-logo-login.svg',
                                            semanticsLabel: 'Logo',
                                            width: 200,
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 20.0),
                                          padding: const EdgeInsets.only(
                                              left: 30, right: 30),
                                          child: Column(children: <Widget>[
                                            input(
                                                label: 'Email or UserName',
                                                icon: const Icon(
                                                  Icons.person_outline_outlined,
                                                  color: Colors.white,
                                                ),
                                                onchange: (value) async {
                                                  email = value;
                                                  setState(() {});
                                                }),
                                            passwordTextField(
                                                obscureText: isObscure,
                                                label: 'Password',
                                                icon: const Icon(
                                                  Icons.key,
                                                  color: Colors.white,
                                                ),
                                                onchange: (value) async {
                                                  password = value;
                                                  setState(() {});
                                                }),
                                          ]),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(
                                              left: 25, right: 30),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Transform.scale(
                                                    scale: 0.7,
                                                    child: Checkbox(
                                                      checkColor: Colors.white,
                                                      activeColor: Colors.blue,

                                                      fillColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  getColor),
                                                      value: isRememberme,
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      5.0))), //rounded checkbox
                                                      onChanged: (value) {
                                                        setState(() {
                                                          isRememberme =
                                                              isRememberme
                                                                  ? false
                                                                  : true;
                                                        });
                                                      },
                                                    )),
                                                const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10)),
                                                const Text('Remember me',
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 150, 150, 150),
                                                        fontSize: 12)),
                                                const Flexible(
                                                    fit: FlexFit.tight,
                                                    child: SizedBox()),
                                                RichText(
                                                  text: TextSpan(
                                                      style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 10),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text:
                                                                'Forgotten password?',
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12),
                                                            recognizer:
                                                                TapGestureRecognizer()
                                                                  ..onTap = () {
                                                                    con.failLogin =
                                                                        '';
                                                                    setState(
                                                                        () {});
                                                                    Navigator.pushNamed(
                                                                        context,
                                                                        RouteNames
                                                                            .reset);
                                                                    con.isSendResetPassword =
                                                                        false;
                                                                    con.setState(
                                                                        () {});
                                                                  })
                                                      ]),
                                                ),
                                              ]),
                                        ),
                                        Container(
                                          width: 260,
                                          margin:
                                              const EdgeInsets.only(top: 10.0),
                                          padding: const EdgeInsets.only(
                                              left: 30.0, right: 30),
                                          child: MyPrimaryButton(
                                            color: email != "" && password != ""
                                                ? const Color.fromARGB(
                                                    255, 104, 184, 250)
                                                : Colors.white,
                                            isShowProgressive:
                                                con.isSendLoginedInfo,
                                            buttonName: "Login",
                                            onPressed: () => {
                                              if (!con.isSendLoginedInfo)
                                                con
                                                    .loginWithEmail(
                                                        context,
                                                        email,
                                                        password,
                                                        isRememberme)
                                                    .then(
                                                        (value) => setState(() {
                                                              enableTwoFactor =
                                                                  value;
                                                            })),
                                              // con.createPassword()
                                            },
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 10.0, bottom: 10),
                                          alignment: Alignment.center,
                                          child: RichText(
                                            text: TextSpan(
                                                text: 'Not Registered?',
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text:
                                                          ' Create an account',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14),
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () {
                                                              Navigator.pushNamed(
                                                                  context,
                                                                  RouteNames
                                                                      .register);
                                                            })
                                                ]),
                                          ),
                                        ),
                                        Offstage(
                                            offstage: con.failLogin == '',
                                            child: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 30,
                                                    right: 30,
                                                    top: 0),
                                                child: Helper.failAlert(
                                                    con.failLogin))),
                                      ],
                                    ),
                            ),
                          ),
                          //footerbar
                          const Flexible(fit: FlexFit.tight, child: SizedBox()),
                          Container(
                            margin: const EdgeInsets.only(bottom: 30),
                            alignment: Alignment.center,
                            width: SizeConfig(context).screenWidth <
                                    SizeConfig.smallScreenSize
                                ? SizeConfig(context).screenWidth
                                : SizeConfig(context).screenWidth * 0.75,
                            child: SizeConfig(context).screenWidth <
                                    SizeConfig.smallScreenSize
                                ? const footbarM()
                                : const footbar(),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }

  Widget input({label, icon, onchange, obscureText = false, validator}) {
    return Container(
      height: 38,
      padding: const EdgeInsets.only(top: 10),
      child: PrimaryInput(
        validator: (val) async {
          validator(val);
        },
        initialValue: '',
        obscureText: obscureText,
        onChange: (val) async {
          onchange(val);
        },
        icon: icon,
        label: label,
      ),
    );
  }

  Widget twoFactorAuthentication() {
    return ListView(
      children: <Widget>[
        Container(
          width: 455,
          height: 90,
          margin: const EdgeInsets.only(top: 50.0),
          color: const Color.fromARGB(255, 11, 35, 45),
          child: const Row(children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 45.0),
            ),
            Text('Login',
                style: TextStyle(
                  color: Color.fromARGB(255, 238, 238, 238),
                  fontSize: 20,
                )),
          ]),
        ),
        Container(
          margin: const EdgeInsets.only(top: 30.0),
          child: Row(children: [
            const Padding(
              padding: EdgeInsets.only(left: 30.0),
            ),
            SvgPicture.network(
                'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fshnatter-logo-login.svg?alt=media&token=9fd6f2bf-3e41-4d43-b052-10509f0b3719')
          ]),
        ),
        const Padding(padding: EdgeInsets.only(top: 40)),
        Container(
            margin: const EdgeInsets.only(top: 20.0),
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Stack(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int i = 0; i < _controllers.length; i++)
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          controller: _controllers[i],
                          focusNode: _focusNodes[i],
                          maxLength: 1,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              focusColor: Colors.white,
                              filled: true,
                              fillColor: Color.fromRGBO(35, 35, 35, 0.7)),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              setState(() {
                                _verificationCode += value;
                                _verificationCode.length;
                                if (_verificationCode.length == 6) {
                                  con
                                      .loginWithVerificationCode(
                                          _verificationCode, context)
                                      .then((value) => {
                                            if (!value)
                                              {
                                                Helper.failAlert(
                                                    'Verification Code is incorrect!'),
                                                _verificationCode = '',
                                              }
                                            else
                                              {
                                                _verificationCode = '',
                                              }
                                          });
                                }
                                FocusScope.of(context)
                                    .requestFocus(_focusNodes[i + 1]);
                              });
                            } else if (value.isEmpty) {
                              _controllers[i].clear();
                              _focusNodes[i].unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_focusNodes[i - 1]);
                              setState(() {
                                if (i != 0) {
                                  _verificationCode =
                                      _verificationCode.substring(
                                          0, _verificationCode.length - 1);
                                } else {
                                  _verificationCode = '';
                                  FocusScope.of(context)
                                      .requestFocus(_focusNodes[0]);
                                }
                              });
                            }
                          },
                        ),
                      ),
                  ],
                )
              ],
            )),
        Container(
          padding: const EdgeInsets.only(left: 25, right: 30),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Transform.scale(
                    scale: 0.7,
                    child: Checkbox(
                      checkColor: Colors.white,
                      activeColor: Colors.blue,

                      // fillColor: MaterialStateProperty.resolveWith(
                      //     getColor),
                      value: isRememberme,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(5.0))), //rounded checkbox
                      onChanged: (value) {
                        setState(() {
                          isRememberme = isRememberme ? false : true;
                        });
                      },
                    )),
              ]),
        ),
        Container(
          width: 260,
          margin: const EdgeInsets.only(top: 10.0),
          padding: const EdgeInsets.only(left: 30.0, right: 30),
          child: MyPrimaryButton(
            color: Colors.white,
            buttonName: "Back",
            onPressed: () => {},
          ),
        ),
      ],
    );
  }

  Widget passwordTextField(
      {label, icon, suffixIcon, onchange, obscureText = false, validator}) {
    return Container(
      height: 38,
      padding: const EdgeInsets.only(top: 10),
      child: TextField(
        obscureText: obscureText,
        onChanged: (val) async {
          onchange(val);
        },
        style: const TextStyle(color: Colors.white, fontSize: 14),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromRGBO(35, 35, 35, 1),
          focusColor: Colors.white,
          //add prefix icon
          contentPadding: const EdgeInsets.symmetric(vertical: 3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.grey, width: 0.1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.grey, width: 0.1),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 0.1),
            borderRadius: BorderRadius.circular(20.0),
          ),
          hintText: label,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontFamily: "verdana_regular",
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: icon,
          suffixIcon: IconButton(
            padding: const EdgeInsets.only(bottom: 3),
            icon: Icon(
              isObscure ? Icons.visibility_off : Icons.visibility,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() => isObscure = !isObscure);
            },
          ),
        ),
      ),
    );
  }
}
