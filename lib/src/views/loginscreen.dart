import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
  String password = '';
  String email = '';
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

    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    "https://test.shnatter.com/content/themes/default/images/main-background-min.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Container(
                alignment: AlignmentDirectional.topCenter,
                child: Container(
                  width:
                      SizeConfig(context).screenWidth < SizeConfig.smallScreenSize
                          ? SizeConfig.smallScreenSize * 0.94
                          : 300,
                  height: con.failLogin == '' ? 450 : 500,
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
                  child: ListView(
                    children: <Widget>[
                      Container(
                        width: 445,
                        height: 60,
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
                              'https://test.shnatter.com/content/themes/default/images/shnatter-logo-login.svg')
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
                          input(
                              label: 'Password',
                              obscureText: true,
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
                        padding: const EdgeInsets.only(left: 25, right: 30),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Transform.scale(
                                  scale: 0.7,
                                  child: Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: Colors.blue,

                                    fillColor: MaterialStateProperty.resolveWith(
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
                              const Padding(padding: EdgeInsets.only(top: 10)),
                              const Text('Remember me',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 150, 150, 150),
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
                                              color: Colors.white, fontSize: 10),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.pushReplacementNamed(
                                                  context, RouteNames.reset);
                                              con.isSendResetPassword = false;
                                              con.setState(() {});
                                            })
                                    ]),
                              ),
                            ]),
                      ),
                      Container(
                        width: 260,
                        margin: const EdgeInsets.only(top: 10.0),
                        padding: const EdgeInsets.only(left: 30.0, right: 30),
                        child: MyPrimaryButton(
                          color: Colors.white,
                          isShowProgressive: con.isSendLoginedInfo,
                          buttonName: "login",
                          onPressed: () => {
                            if(!con.isSendLoginedInfo)
                              con.loginWithEmail(
                                context, email, password, isRememberme)
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
              Padding(padding: EdgeInsets.only(top: 40)),
              Container(
                  width:
                      SizeConfig(context).screenWidth < SizeConfig.smallScreenSize
                          ? SizeConfig(context).screenWidth
                          : SizeConfig(context).screenWidth * 0.6,
                  margin: const EdgeInsets.only(top: 80, right: 0, bottom: 20),
                  child:
                      SizeConfig(context).screenWidth < SizeConfig.smallScreenSize
                          ? footbarM()
                          : footbar())
            ])),
    ));
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
}
