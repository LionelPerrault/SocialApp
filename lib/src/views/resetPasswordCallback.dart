import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/widget/mprimary_button.dart';
import '../helpers/helper.dart';
// ignore: depend_on_referenced_packages
import 'package:html/parser.dart' as html_parser;

// ignore: must_be_immutable
class ResetPasswordCallbackScreen extends StatefulWidget {
  ResetPasswordCallbackScreen(Key? key,
      {required this.oobCode, required this.apiKey})
      : super(key: key) {
    con = UserController();
  }
  late UserController con;
  String oobCode;
  String apiKey;
  @override
  State createState() => ResetPasswordCallbackScreenState();
}

class ResetPasswordCallbackScreenState
    extends mvc.StateMVC<ResetPasswordCallbackScreen> {
  late UserController con;
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var isResetPassword = false;

  var newPasswordObscure = true;
  var newPasswordConfirmObscure = true;

  String resetPasswordTitle = '';
  String resetPasswordSubTitle = '';
  @override
  void initState() {
    add(widget.con);
    con = controller as UserController;
    // con.emailVerified();
    super.initState();
  }

  void getWidth(elem) {
    var dom = html_parser.parse(elem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: SafeArea(child: buildSignup()));
  }

  Widget buildSignup() {
    return Stack(
      children: [
        Stack(
          children: [
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        width: SizeConfig(context).screenWidth * 0.7,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10, right: 10),
                                child: TextField(
                                  obscureText: newPasswordObscure,
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText: "Password",
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        newPasswordObscure =
                                            !newPasswordObscure;
                                        setState(() {});
                                      },
                                      child: Icon(newPasswordObscure
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 5),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10, right: 10),
                                child: TextField(
                                  obscureText: newPasswordConfirmObscure,
                                  controller: confirmPasswordController,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText: "Confirm Password",
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        newPasswordConfirmObscure =
                                            !newPasswordConfirmObscure;
                                        setState(() {});
                                      },
                                      child: Icon(newPasswordConfirmObscure
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 25),
                              ),
                              Container(
                                  height: 50,
                                  width: SizeConfig(context).screenWidth * 0.7,
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                  child: MyPrimaryButton(
                                      color:
                                          const Color.fromRGBO(68, 68, 68, 1),
                                      buttonName: "Reset Password",
                                      onPressed: () async {
                                        if (passwordController.text.length <
                                            6) {
                                          Helper.showToast(
                                              'Password length must be over 6');
                                          return;
                                        }
                                        if (passwordController.text !=
                                            confirmPasswordController.text) {
                                          Helper.showToast(
                                              'Password doesn\'t match');
                                          return;
                                        }
                                        if (!isResetPassword) {
                                          isResetPassword = true;
                                          setState(() {});
                                          await con.resetPasswordWithoob(
                                              passwordController.text,
                                              widget.oobCode);
                                          isResetPassword = false;
                                          Navigator.pushReplacementNamed(
                                              context, RouteNames.login);
                                          setState(() {});
                                        }
                                      })),
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 15),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Go to login Screen',
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 15),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.pushReplacementNamed(
                                              context, RouteNames.login);
                                        },
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 5),
                              ),
                            ])),
                  ],
                )),
          ],
        ),
        isResetPassword
            ? Container(
                alignment: Alignment.center,
                width: SizeConfig(context).screenWidth,
                height: SizeConfig(context).screenHeight,
                color: const Color.fromRGBO(255, 255, 255, 0.8),
                child: const CircularProgressIndicator(
                  strokeWidth: 4,
                ),
              )
            : Container()
      ],
    );
  }
}
