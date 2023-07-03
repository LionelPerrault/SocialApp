import 'package:flutter/foundation.dart';
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';
import 'package:http/http.dart' as http;
import 'package:shnatter/model/recaptcha.dart';

import '../config/config.dart';

/// A Service Layer that handles `Google reCAPTCHA V3` API operations.
class RecaptchaService {
  /// Holds the response token.
  static String _token = '';

  /// Prevents from class instantiation.
  RecaptchaService._();

  /// Loads the `Google reCAPTCHA V3` API.
  static Future<void> initiate() async =>
      await GRecaptchaV3.ready(Config.siteKey);

  /// Checks whether the form submission is done by a human or bot.
  static Future<bool> isNotABot() async {
    var verificationResponse = await _getVerificationResponse();
    var _score = verificationResponse?.score ?? 0.0;
    return _score >= 0.5 && _score < 1 ? true : false;
  }

  /// Verifies the client's response using HTTP POST method.
  ///
  /// For more information, read the `Google reCAPTCHA V3` [server side docs](https://developers.google.com/recaptcha/docs/verify#api_request)
  static Future<RecaptchaResponse?> _getVerificationResponse() async {
    _token = await GRecaptchaV3.execute('submit') ?? '';

    RecaptchaResponse? _recaptchaResponse;

    if (_token.isNotEmpty) {
      try {
        /// Holds the body parameter for the HTTP request.
        final _bodyParameters = {
          'secret': Config.secretKey,
          'response': _token,
        };

        var response = await http.post(Config.verificationURL,
            body: _bodyParameters,
            headers: {'Access-Control-Allow-Origin': '*'});

        _recaptchaResponse = RecaptchaResponse.fromJson(response.body);
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    return _recaptchaResponse;
  }
}
