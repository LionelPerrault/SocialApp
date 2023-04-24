import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/widget/custom_loader.dart';
import 'package:shnatter/src/widget/pin_input_field.dart';

class VerifyPhoneNumberScreen extends StatefulWidget {
  static const id = 'VerifyPhoneNumberScreen';

  final String phoneNumber;
  Function onBack;

  VerifyPhoneNumberScreen({
    Key? key,
    required this.phoneNumber,
    required this.onBack,
  }) : super(key: key);

  @override
  State<VerifyPhoneNumberScreen> createState() =>
      _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen>
    with WidgetsBindingObserver {
  bool isKeyboardVisible = false;

  late final ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomViewInsets = WidgetsBinding.instance.window.viewInsets.bottom;
    isKeyboardVisible = bottomViewInsets > 0;
  }

  // scroll to bottom of screen, when pin input field is in focus.
  Future<void> _scrollToBottomOnKeyboardOpen() async {
    while (!isKeyboardVisible) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    await Future.delayed(const Duration(milliseconds: 250));

    await scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FirebasePhoneAuthHandler(
        phoneNumber: widget.phoneNumber,
        signOutOnSuccessfulVerification: false,
        sendOtpOnInitialize: true,
        linkWithExistingUser: false,
        autoRetrievalTimeOutDuration: const Duration(seconds: 60),
        otpExpirationDuration: const Duration(seconds: 60),
        onCodeSent: () {},
        onLoginSuccess: (userCredential, autoVerified) async {
          Helper.showToast('Phone number verified successfully!');
          Future.delayed(const Duration(seconds: 5))
              .then((value) => {Helper.showToast('Now registering user!')});

          widget.onBack(true, false);
        },
        onLoginFailed: (authException, stackTrace) {
          switch (authException.code) {
            case 'invalid-phone-number':
              Helper.showToast('Invalid phone number!');
              widget.onBack(false, true);

              return;
            case 'invalid-verification-code':
              Helper.showToast('The entered OTP is invalid!');
              widget.onBack(false, true);

              return;
            // handle other error codes
            default:
              widget.onBack(false, true);

              Helper.showToast(authException.code);
          }
        },
        onError: (error, stackTrace) {
          Helper.showToast('An error occurred!');
          widget.onBack(false, true);
        },
        builder: (context, controller) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 44, 44, 44),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  widget.onBack(false, true);
                },
              ),
              title: const Text(
                'Verify Phone Number',
                style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.normal,
                    color: Color.fromARGB(255, 202, 202, 202),
                    fontFamily: 'Hind'),
              ),
              actions: [
                if (controller.codeSent)
                  TextButton(
                    onPressed: controller.isOtpExpired
                        ? () async {
                            await controller.sendOTP();
                          }
                        : null,
                    child: Text(
                      controller.isOtpExpired
                          ? 'Resend'
                          : '${controller.otpExpirationTimeLeft.inSeconds}s',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Hind'),
                    ),
                  ),
                const SizedBox(width: 5),
              ],
            ),
            body: controller.isSendingCode
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      CustomLoader(color: Colors.blue),
                      SizedBox(height: 50),
                      Center(
                        child: Text(
                          'Sending OTP',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      ),
                    ],
                  )
                : ListView(
                    padding: const EdgeInsets.all(20),
                    controller: scrollController,
                    children: [
                      Text(
                        "We've sent an SMS with a verification code to  ${widget.phoneNumber}",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.white70),
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      if (controller.isListeningForOtpAutoRetrieve)
                        Column(
                          children: const [
                            // CustomLoader(
                            //   color: Colors.blue,
                            // ),
                            SizedBox(height: 50),
                            Text(
                              'Waiting for code received by sms',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 15),
                            Divider(
                              color: Colors.white,
                            ),
                            Text(
                              'OR',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                            Divider(
                              color: Colors.white,
                            ),
                          ],
                        ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 40,
                        child: PinInputField(
                          length: 6,
                          onFocusChange: (hasFocus) async {
                            if (hasFocus) await _scrollToBottomOnKeyboardOpen();
                          },
                          onSubmit: (enteredOtp) async {
                            final verified =
                                await controller.verifyOtp(enteredOtp);
                            if (verified) {
                              // number verify success
                              // will call onLoginSuccess handler
                            } else {
                              // phone verification failed
                              // will call onLoginFailed or onError callbacks with the error
                            }
                          },
                        ),
                      )
                    ],
                  ),
          );
        },
      ),
    );
  }
}
