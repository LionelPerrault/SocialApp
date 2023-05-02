import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:clipboard/clipboard.dart';
import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/views/setting/widget/setting_header.dart';
import 'package:shnatter/src/widget/startedInput.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

// ignore: must_be_immutable
class TwoFactorAuthenticationScreen extends StatefulWidget {
  TwoFactorAuthenticationScreen({Key? key, required this.routerChange})
      : con = UserController(),
        super(key: key);
  late UserController con;
  Function routerChange;
  @override
  State createState() => TwoFactorAuthenticationScreenState();
}

// ignore: must_be_immutable
class TwoFactorAuthenticationScreenState
    extends mvc.StateMVC<TwoFactorAuthenticationScreen> {
  // ignore: non_constant_identifier_names
  var setting_security = {};
  late UserController con;
  bool isEnableTwoFactor = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _textNode = FocusNode();
  String verificationCode = '';
  bool checkVerificationCode = false;
  @override
  void initState() {
    add(widget.con);
    con = controller as UserController;
    super.initState();
    con.isEnableTwoFactor = UserManager.userInfo['isEnableTwoFactor'] == '' ||
            UserManager.userInfo['isEnableTwoFactor'] == null
        ? false
        : true;
    con.setState(() {});
  }

  void onCodeInput(String value) async {
    setState(() {
      verificationCode = value;
    });
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
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: SizedBox(
                  height: 5.0,
                  width: 30.0,
                  // color: shake ? Colors.red : Colors.black,
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
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20),
          child: SettingHeader(
              icon: const Icon(
                Icons.security,
                color: Color.fromARGB(255, 244, 67, 54),
              ),
              pagename: 'Two-factor Authentication Setting',
              button: const {'flag': false},
              routerChange: widget.routerChange),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: Column(
                      children: [
                        SizedBox(
                            width: SizeConfig(context).screenWidth * 0.8,
                            child: const Text(
                              'Enable Two-factor Authentication to protect your account from unauthorized access. Scan the QR code with your Google Authenticator App or enter the secret key manually.',
                              style: TextStyle(fontSize: 11),
                            )),
                      ],
                    ),
                  ),
                )
              ],
            ),
            con.isEnableTwoFactor
                ? const SizedBox()
                : const Padding(padding: EdgeInsets.only(top: 20)),
            con.isEnableTwoFactor
                ? const SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PrettyQr(
                        typeNumber: 10,
                        size: 130,
                        data:
                            'otpauth://totp/shnatter?Algorithm=SHA1&digits=6&secret=JBSWY3DPEHPK3PXP&issuer=shnatter&period=30',
                        errorCorrectLevel: QrErrorCorrectLevel.M,
                        roundEdges: true,
                      ),
                    ],
                  ),
            con.isEnableTwoFactor
                ? const SizedBox()
                : const Padding(padding: EdgeInsets.only(top: 20)),
            con.isEnableTwoFactor
                ? const SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 35,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 222, 226, 230),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                const Text('JBSWY3DPEHPK3PXP',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color:
                                            Color.fromARGB(255, 61, 63, 65))),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    FlutterClipboard.copy('JBSWY3DPEHPK3PXP')
                                        .then((value) => Helper.showToast(
                                            'Secret Key Copied!'));
                                  },
                                  iconSize: 20,
                                  icon: const Icon(
                                    Icons.copy,
                                    color: Color.fromARGB(255, 61, 63, 65),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            SizedBox(
                width: SizeConfig(context).screenWidth * 0.8,
                child: const Text(
                  'Write down this code, never reveal it to others. You can use it to regain access to your account if there is no access to the authenticator.',
                  style: TextStyle(fontSize: 11),
                )),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text('Verification Code',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 80,
                  width: SizeConfig(context).screenWidth * 0.8,
                  // color: Colors.amber,
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
                        ),
                      ),
                      Positioned(
                        bottom: 40,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: getField(),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Row(
              children: [
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, bottom: 20),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(3),
                            backgroundColor:
                                const Color.fromARGB(255, 245, 54, 92),
                            // elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.0)),
                            minimumSize: const Size(140, 50),
                            maximumSize: const Size(140, 50),
                          ),
                          onPressed: () async {
                            if (con.isEnableTwoFactor) {
                              if (verificationCode.length == 6) {
                                checkVerificationCode = await con
                                    .enableDisableTwoFactorAuthentication(
                                        verificationCode, 'disable');
                              }
                              if (checkVerificationCode) {
                                Helper.showToast(
                                    'Two-factor Authentication was disabled!');
                                verificationCode = '';
                              } else {
                                Helper.showToast(
                                    'Verification code is incorrect!');
                              }
                            } else {
                              if (verificationCode.length == 6) {
                                checkVerificationCode = await con
                                    .enableDisableTwoFactorAuthentication(
                                        verificationCode, 'enable');
                              }
                              if (checkVerificationCode) {
                                Helper.showToast(
                                    'Two-factor Authentication was enabled!');
                                verificationCode = '';
                              } else {
                                Helper.showToast(
                                    'Verification code is incorrect!');
                              }
                            }
                            setState(() {});
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Icon(Icons.delete),
                              Text(con.isEnableTwoFactor ? 'Disable' : 'Enable',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))
                            ],
                          ))),
                )
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget input({label, onchange, obscureText = false, validator}) {
    return SizedBox(
      height: 28,
      child: StartedInput(
        validator: (val) async {
          validator(val);
        },
        obscureText: obscureText,
        onChange: (val) async {
          onchange(val);
        },
      ),
    );
  }
}
