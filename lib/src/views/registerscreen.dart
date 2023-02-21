import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/views/phonenumberscreen.dart';
import 'package:shnatter/src/views/privacy.dart';
import 'package:shnatter/src/views/terms.dart';
import 'package:shnatter/src/views/verfiyphonenumberscreen.dart';
import 'package:shnatter/src/widget/primaryInput.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../helpers/helper.dart';
import '../utils/size_config.dart';
import '../widget/mprimary_button.dart';
import './footerbar.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key})
      : con = UserController(),
        super(key: key);
  @override
  State createState() => RegisterScreenState();
  late UserController con;
}

class RegisterScreenState extends mvc.StateMVC<RegisterScreen> {
  bool check1 = false;
  bool check2 = false;
  int registerStep = 1;
  String phoneNumber = '';
  late UserController con;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as UserController;
  }

  var signUpUserInfo = {};
  String dropdownValue = 'Male';
  var isObscure = true;
  var _isButtonDisabled = false;

  @override
  void buttonDisableFlag() {
    setState(() {
      _isButtonDisabled = true;
    });
  }

  Widget build(BuildContext context) {
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            alignment: Alignment.topCenter,
                            width: SizeConfig(context).screenWidth <
                                    SizeConfig.smallScreenSize
                                ? SizeConfig.smallScreenSize * 0.94
                                : 300,
                            margin: EdgeInsets.only(
                              left: SizeConfig(context).screenWidth <
                                      SizeConfig.smallScreenSize
                                  ? SizeConfig(context).screenWidth * 0.03
                                  : SizeConfig(context).screenWidth * 0.2,
                              right: SizeConfig(context).screenWidth <
                                      SizeConfig.smallScreenSize
                                  ? SizeConfig(context).screenWidth * 0.03
                                  : SizeConfig(context).screenWidth * 0.03,
                            ),
                            height: SizeConfig(context).screenWidth <
                                    SizeConfig.smallScreenSize
                                ? 687
                                : con.failRegister == ''
                                    ? 600
                                    : 630,
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: registerStep == 1
                                ? ListView(children: [
                                    Container(
                                        margin: const EdgeInsets.only(top: 40),
                                        padding: const EdgeInsets.only(
                                            left: 30, top: 15),
                                        width: double.infinity,
                                        height: 60,
                                        color:
                                            const Color.fromRGBO(11, 35, 45, 1),
                                        child: const Text(
                                          'Register',
                                          style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.white,
                                          ),
                                        )),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 25, right: 25),
                                      child: Column(
                                        children: [
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(top: 20)),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: SvgPicture.network(
                                                'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fshnatter-logo-login.svg?alt=media&token=9fd6f2bf-3e41-4d43-b052-10509f0b3719'),
                                          ),
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(top: 20)),
                                          input(
                                              label: 'First Name',
                                              icon: const Icon(
                                                Icons.person,
                                                color: Colors.white,
                                              ),
                                              validator: (value) async {
                                                print(value);
                                              },
                                              onchange: (value) async {
                                                signUpUserInfo['firstName'] =
                                                    value;
                                                setState(() {});
                                              }),
                                          input(
                                              label: 'Last Name',
                                              icon: const Icon(
                                                Icons.person,
                                                color: Colors.white,
                                              ),
                                              onchange: (value) async {
                                                signUpUserInfo['lastName'] =
                                                    value;
                                                setState(() {});
                                              }),
                                          input(
                                              label: 'User Name',
                                              icon: const Icon(
                                                Icons.ev_station_sharp,
                                                color: Colors.white,
                                              ),
                                              onchange: (value) async {
                                                signUpUserInfo['userName'] =
                                                    value;
                                                setState(() {});
                                              }),
                                          input(
                                              label: 'Email',
                                              icon: const Icon(
                                                Icons.email,
                                                color: Colors.white,
                                              ),
                                              onchange: (value) async {
                                                signUpUserInfo['email'] = value;
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
                                                signUpUserInfo['password'] =
                                                    value;
                                                setState(() {});
                                              }),
                                          Container(
                                              width: double.infinity - 50,
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              decoration: const ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      width: 0.5,
                                                      style: BorderStyle.solid),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5.0)),
                                                ),
                                              ),
                                              child: DecoratedBox(
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromRGBO(
                                                        35,
                                                        35,
                                                        35,
                                                        1), //background color of dropdown button
                                                    border: Border.all(
                                                        color: Colors.grey,
                                                        width:
                                                            0.1), //border of dropdown button
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20), //border raiuds of dropdown button
                                                  ),
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 30,
                                                              right: 10),
                                                      child: DropdownButton(
                                                        value: dropdownValue,
                                                        items: const [
                                                          //add items in the dropdown
                                                          DropdownMenuItem(
                                                            value: "Male",
                                                            child: Text("Male"),
                                                          ),
                                                          DropdownMenuItem(
                                                              value: "Female",
                                                              child: Text(
                                                                  "Female")),
                                                          DropdownMenuItem(
                                                            value: "Other",
                                                            child:
                                                                Text("Other"),
                                                          )
                                                        ],
                                                        onChanged:
                                                            (String? value) {
                                                          //get value when changed
                                                          signUpUserInfo[
                                                              'sex'] = value;
                                                          dropdownValue =
                                                              value!;
                                                          setState(() {});
                                                        },
                                                        icon: const Padding(
                                                            //Icon at tail, arrow bottom is default icon
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 20),
                                                            child: Icon(Icons
                                                                .arrow_drop_down)),
                                                        iconEnabledColor: Colors
                                                            .white, //Icon color
                                                        style: const TextStyle(
                                                            //te
                                                            color: Colors
                                                                .white, //Font color
                                                            fontSize:
                                                                12 //font size on dropdown button
                                                            ),

                                                        dropdownColor: const Color
                                                                .fromRGBO(
                                                            35,
                                                            35,
                                                            35,
                                                            1), //dropdown background color
                                                        underline:
                                                            Container(), //remove underline
                                                        isExpanded: true,
                                                        isDense: true,
                                                      )))),
                                          Row(
                                            children: [
                                              Transform.scale(
                                                  scale: 0.7,
                                                  child: Checkbox(
                                                    fillColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                Colors.white),
                                                    checkColor:
                                                        Colors.greenAccent,
                                                    activeColor:
                                                        const Color.fromRGBO(
                                                            0, 123, 255, 1),
                                                    value: check1,
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .all(Radius.circular(
                                                                5.0))), // Rounded Checkbox
                                                    onChanged: (value) {
                                                      setState(() {
                                                        check1 = check1
                                                            ? false
                                                            : true;
                                                      });
                                                    },
                                                  )),
                                              const Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 1)),
                                              const Text(
                                                'I expressly agree to receive the newsletter',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Color.fromRGBO(
                                                        150, 150, 150, 1)),
                                              ),
                                            ],
                                          ),
                                          const Padding(
                                              padding: EdgeInsets.only(top: 0)),
                                          Row(
                                            children: [
                                              Transform.scale(
                                                  scale: 0.7,
                                                  child: Checkbox(
                                                    fillColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                Colors.white),
                                                    checkColor:
                                                        Colors.greenAccent,
                                                    activeColor:
                                                        const Color.fromRGBO(
                                                            0, 123, 255, 1),
                                                    value: check2,
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .all(Radius.circular(
                                                                5.0))), // Rounded Checkbox
                                                    onChanged: (value) {
                                                      setState(() {
                                                        check2 = check2
                                                            ? false
                                                            : true;
                                                      });
                                                    },
                                                  )),
                                              const Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 1)),
                                              Flexible(
                                                child: RichText(
                                                  text: TextSpan(
                                                      text:
                                                          'By creating your account, you agree to our',
                                                      style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 10),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text: ' Terms',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 10),
                                                          recognizer:
                                                              TapGestureRecognizer()
                                                                ..onTap = () {
                                                                  Navigator
                                                                      .push<
                                                                          void>(
                                                                    context,
                                                                    MaterialPageRoute<
                                                                        void>(
                                                                      builder: (BuildContext
                                                                              context) =>
                                                                          TermsScreen(),
                                                                    ),
                                                                  );
                                                                },
                                                        ),
                                                        const TextSpan(
                                                          text: ' &',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 11),
                                                        ),
                                                        TextSpan(
                                                            text:
                                                                ' Privacy Policy',
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10),
                                                            recognizer:
                                                                TapGestureRecognizer()
                                                                  ..onTap = () {
                                                                    Navigator
                                                                        .push<
                                                                            void>(
                                                                      context,
                                                                      MaterialPageRoute<
                                                                          void>(
                                                                        builder:
                                                                            (BuildContext context) =>
                                                                                const PrivacyScreen(),
                                                                      ),
                                                                    );
                                                                  })
                                                      ]),
                                                ),
                                              )
                                            ],
                                          ),
                                          const Padding(
                                              padding: EdgeInsets.only(top: 5)),
                                          Container(
                                            width: double.infinity - 50,
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: MyPrimaryButton(
                                              color: Colors.white,
                                              isShowProgressive:
                                                  con.isSendRegisterInfo,
                                              buttonName: "Sign up",
                                              onPressed: () => {
                                                if (!check1 || !check2)
                                                  {
                                                    con.failRegister =
                                                        'You must read and agree to our terms and privacy policy',
                                                    con.setState(() {}),
                                                  }
                                                else
                                                  {
                                                    if (!con.isSendRegisterInfo)
                                                      {
                                                        setState(
                                                          () {
                                                            registerStep = 2;
                                                          },
                                                        ),
                                                      }
                                                  }
                                                // con.createPassword()
                                              },
                                            ),
                                          ),
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(top: 10)),
                                          con.failRegister == ''
                                              ? Container()
                                              : Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 10),
                                                  child: Helper.failAlert(
                                                      con.failRegister)),
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(top: 20)),
                                          RichText(
                                            text: TextSpan(
                                                text: 'Have an account?',
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 10),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: ' Login Now',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10),
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () {
                                                              Navigator
                                                                  .pushReplacementNamed(
                                                                      context,
                                                                      RouteNames
                                                                          .login);
                                                            })
                                                ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ])
                                : registerStep == 3
                                    ? VerifyPhoneNumberScreen(
                                        phoneNumber: phoneNumber,
                                        onBack: (value) {
                                          if (value == true) {
                                            con.validate(
                                                context, signUpUserInfo);
                                          }
                                        },
                                      )
                                    : ListView(children: [
                                        Container(
                                            margin:
                                                const EdgeInsets.only(top: 40),
                                            padding: const EdgeInsets.only(
                                                left: 30, top: 15),
                                            width: double.infinity,
                                            height: 60,
                                            color: const Color.fromRGBO(
                                                11, 35, 45, 1),
                                            child: const Text(
                                              'Phone Number Authentication',
                                              style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white,
                                              ),
                                            )),
                                        Container(
                                            padding: const EdgeInsets.only(
                                                left: 25, right: 25),
                                            child: Column(children: [
                                              const Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 20)),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: SvgPicture.network(
                                                    'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fshnatter-logo-login.svg?alt=media&token=9fd6f2bf-3e41-4d43-b052-10509f0b3719'),
                                              ),
                                              PhoneNumberScreen(
                                                onBack: (value) {
                                                  setState(() {
                                                    phoneNumber = value;
                                                    registerStep = 3;
                                                  });
                                                },
                                              )
                                            ]))
                                      ])),
                        Container(
                            width: SizeConfig(context).screenWidth <
                                    SizeConfig.smallScreenSize
                                ? SizeConfig(context).screenWidth
                                : SizeConfig(context).screenWidth * 0.6,
                            margin:
                                const EdgeInsets.only(top: 60, bottom: 53.5),
                            child: SizeConfig(context).screenWidth <
                                    SizeConfig.smallScreenSize
                                ? footbarM()
                                : footbar())
                      ],
                    )))));
  }

  Widget input(
      {label, icon, eyeIcon, onchange, obscureText = false, validator}) {
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
              isObscure ? Icons.visibility_off : Icons.visibility,
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
