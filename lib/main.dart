import 'package:flutter/cupertino.dart';
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GRecaptchaV3.ready('6LdJxO8mAAAAANFdwyPTI0lUaY972EhxE7PSiV4k');
  Helper.environment = Environment.prod;
  runApp(const MyApp(key: Key('Shnatter')));
}
