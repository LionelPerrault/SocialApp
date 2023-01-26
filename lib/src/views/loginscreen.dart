import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/footerbar.dart';

import '../controllers/UserController.dart';
import '../helpers/helper.dart';
import '../routes/route_names.dart';
import '../widget/mprimary_button.dart';
import '../widget/primaryInput.dart';
import '../widget/white_button.dart';
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
  final TextEditingController _controller = TextEditingController();
  final FocusNode _textNode = FocusNode();
  String password = '';
  String email = '';
  bool enableTwoFactor = false;
  String verificationCode = ' ';
  var isObscure = true;
  @override
  void initState() {
    add(widget.con);
    con = controller as UserController;
    super.initState();
  }

  late UserController con;

  void onCodeInput(String value) async {
    setState(() {
      verificationCode = value;
    });
    if (verificationCode.length == 6) {
      con.loginWithVerificationCode(verificationCode, context).then((value) => {
            if (!value) {Helper.failAlert('Verification Code is incorrect!')}
          });
    }
  }

  List<Widget> getField() {
    final List<Widget> result = <Widget>[];
    for (int i = 1; i <= 6; i++) {
      result.add(
        ShakeAnimatedWidget(
          enabled: false,
          duration: const Duration(
            milliseconds: 100,
          ),
          shakeAngle: Rotation.deg(
            z: 20,
          ),
          curve: Curves.linear,
          child: Column(
            children: <Widget>[
              if (verificationCode.length >= i)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                  ),
                  child: Text(
                    verificationCode[i - 1],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: Container(
                  height: 5.0,
                  width: 30.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return result;
  }

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

    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fmain-background-min.jpg?alt=media&token=47b6ab2c-74b4-455c-a61a-632cf6d476a8"),
              fit: BoxFit.cover,
            ),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
              alignment: AlignmentDirectional.topCenter,
              child: Container(
                width:
                    SizeConfig(context).screenWidth < SizeConfig.smallScreenSize
                        ? SizeConfig.smallScreenSize * 0.94
                        : 300,
                height:
                    SizeConfig(context).screenWidth < SizeConfig.smallScreenSize
                        ? 550
                        : con.failLogin == ''
                            ? 450
                            : 500,
                margin: EdgeInsets.only(
                  left: SizeConfig(context).screenWidth <
                          SizeConfig.smallScreenSize
                      ? SizeConfig(context).screenWidth * 0.03
                      : SizeConfig(context).screenWidth * 0.2,
                  right: SizeConfig(context).screenWidth <
                          SizeConfig.smallScreenSize
                      ? SizeConfig(context).screenWidth * 0.03
                      : 10,
                ),
                decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: enableTwoFactor
                    ? twoFactorAuthentication()
                    : ListView(
                        children: <Widget>[
                          Container(
                            width: 455,
                            height: 90,
                            margin: const EdgeInsets.only(top: 50.0),
                            color: const Color.fromARGB(255, 11, 35, 45),
                            child: Row(children: const <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 45.0),
                              ),
                              Text('Login',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 238, 238, 238),
                                    fontSize: 30,
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
                          Container(
                            margin: const EdgeInsets.only(top: 20.0),
                            padding: const EdgeInsets.only(left: 30, right: 30),
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
                              // input(
                              //     label: 'Password',
                              //     obscureText: true,
                              //     icon: const Icon(
                              //       Icons.key,
                              //       color: Colors.white,
                              //     ),
                              //     onchange: (value) async {
                              //       password = value;
                              //       setState(() {});
                              //     }),
                              passwordTextField(
                                  obscureText: isObscure,
                                  label: 'Password',
                                  icon: const Icon(
                                    Icons.key,
                                    color: Colors.white,
                                  ),
                                  suffixIcon: Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isObscure = !isObscure;
                                          });
                                        },
                                        icon: Icon(
                                          isObscure
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.white,
                                        )),
                                  ),
                                  onchange: (value) async {
                                    password = value;
                                    setState(() {});
                                  }),
                            ]),
                          ),
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

                                        fillColor:
                                            MaterialStateProperty.resolveWith(
                                                getColor),
                                        value: isRememberme,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    5.0))), //rounded checkbox
                                        onChanged: (value) {
                                          setState(() {
                                            isRememberme =
                                                isRememberme ? false : true;
                                          });
                                        },
                                      )),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 10)),
                                  const Text('Remember me',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 150, 150, 150),
                                          fontSize: 11)),
                                  const Flexible(
                                      fit: FlexFit.tight, child: SizedBox()),
                                  RichText(
                                    text: TextSpan(
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 10),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: 'Forgotten password?',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator
                                                      .pushReplacementNamed(
                                                          context,
                                                          RouteNames.reset);
                                                  con.isSendResetPassword =
                                                      false;
                                                  con.setState(() {});
                                                })
                                        ]),
                                  ),
                                ]),
                          ),
                          Container(
                            width: 260,
                            margin: const EdgeInsets.only(top: 10.0),
                            padding:
                                const EdgeInsets.only(left: 30.0, right: 30),
                            child: MyPrimaryButton(
                              color: Colors.white,
                              isShowProgressive: con.isSendLoginedInfo,
                              buttonName: "login",
                              onPressed: () => {
                                if (!con.isSendLoginedInfo)
                                  con
                                      .loginWithEmail(context, email, password,
                                          isRememberme)
                                      .then((value) => setState(() {
                                            enableTwoFactor = value;
                                          }))
                                // con.createPassword()
                              },
                            ),
                          ),
                          con.failLogin != ''
                              ? Container(
                                  margin: const EdgeInsets.only(
                                      left: 30, right: 30, top: 10),
                                  child: Helper.failAlert(con.failLogin))
                              : Container(),
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            alignment: Alignment.center,
                            child: RichText(
                              text: TextSpan(
                                  text: 'Not Regsitered?',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 10),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: ' Create an account',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 10),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.pushReplacementNamed(
                                                context, RouteNames.register);
                                          })
                                  ]),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            Padding(
                padding:
                    SizeConfig(context).screenWidth < SizeConfig.smallScreenSize
                        ? const EdgeInsets.only(top: 60)
                        : const EdgeInsets.only(top: 40)),
            Container(
                width:
                    SizeConfig(context).screenWidth < SizeConfig.smallScreenSize
                        ? SizeConfig(context).screenWidth
                        : SizeConfig(context).screenWidth * 0.6,
                margin: SizeConfig(context).screenWidth <
                        SizeConfig.smallScreenSize
                    ? const EdgeInsets.only(top: 60, right: 0, bottom: 130.35)
                    : const EdgeInsets.only(top: 80, right: 0, bottom: 20),
                child:
                    SizeConfig(context).screenWidth < SizeConfig.smallScreenSize
                        ? footbarM()
                        : footbar())
          ])),
    )));
  }

  Widget input({label, icon, onchange, obscureText = false, validator}) {
    return Container(
      height: 38,
      padding: const EdgeInsets.only(top: 10),
      child: PrimaryInput(
        validator: (val) async {
          validator(val);
        },
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
          child: Row(children: const <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 45.0),
            ),
            Text('Login',
                style: TextStyle(
                  color: Color.fromARGB(255, 238, 238, 238),
                  fontSize: 30,
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
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Stack(
              children: <Widget>[
                Opacity(
                  opacity: 1.0,
                  child: TextFormField(
                    controller: _controller,
                    focusNode: _textNode,
                    keyboardType: TextInputType.number,
                    onChanged: onCodeInput,
                    maxLength: 6,
                    style: const TextStyle(
                        color: Colors.white, backgroundColor: Colors.white),
                  ),
                ),
                Positioned(
                  // bottom: 0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: getField(),
                  ),
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
            onPressed: () => {
              // if (!con.isSendLoginedInfo)
              //   con.loginWithEmail(
              //       context, email, password, isRememberme)
              // con.createPassword()
            },
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
        style: const TextStyle(color: Colors.white, fontSize: 11),
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
            fontSize: 11,
            fontFamily: "verdana_regular",
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: icon,
          suffixIcon: IconButton(
            padding: EdgeInsets.only(bottom: 3),
            icon: Icon(
              isObscure ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() => {isObscure = !isObscure});
            },
          ),
        ),
      ),
    );
  }
}
