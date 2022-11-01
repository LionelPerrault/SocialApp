import 'dart:convert';
import 'dart:developer';
import 'dart:html';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/routes/route_generator.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/colors.dart';
import 'package:shnatter/src/views/homescreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'controllers/AppController.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'helpers/helper.dart';
import 'models/setting.dart';

class MyApp extends AppStatefulWidgetMVC {
  const MyApp({Key? key}) : super(key: key);

  /// This is the App's State object
  @override
  AppStateMVC createState() => _MyAppState();
}

class _MyAppState extends AppStateMVC<MyApp> {
  factory _MyAppState() => _this ??= _MyAppState._();
  _MyAppState._()
      : super(
          controller: AppController(),
          controllers: [],
        );
  static _MyAppState? _this;
  Widget createApp()
  {
    return 
      ValueListenableBuilder(
        valueListenable: Helper.setting,
        builder: (context, Setting _setting, _) {
            return MaterialApp(
                title: 'Shnatter',
                //home: HomeScreen(key: UniqueKey()),
                locale: _setting.language,
                localizationsDelegates: [
                  AppLocalizations.delegate, // Add this line
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const <Locale>[
                  Locale.fromSubtags(languageCode: 'en'),
                  Locale.fromSubtags(languageCode: 'ar'),
                  Locale.fromSubtags(languageCode: 'es'),
                  Locale.fromSubtags(languageCode: 'fr'),
                  Locale.fromSubtags(languageCode: 'fr', countryCode: 'CA'),
                  Locale.fromSubtags(languageCode: 'in'),
                  Locale.fromSubtags(languageCode: 'ko'),
                  Locale.fromSubtags(languageCode: 'pt', countryCode: 'BR'),
                ]   ,
                initialRoute: "/",
                onGenerateRoute: RouteGenerator.generateRoute,
                // ignore: dead_code
                theme: _setting.isBright? ThemeData(
                                  brightness: Brightness.dark,
                                  primarySwatch: kprimarySwatch,
                                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                                  fontFamily: 'Georgia',
                                  buttonTheme: ButtonThemeData(
                                    buttonColor: Color(0xff00adb5),
                                  ),
                                  textTheme: const TextTheme(
                                    headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
                                    headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
                                    bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
                                  ),
                                  ):
                                  ThemeData(
                                  brightness: Brightness.light,
                                  primarySwatch: kprimarySwatch,
                                  backgroundColor: Color(0xffeeeeee),
                                  fontFamily: 'Georgia',
                                  buttonTheme: ButtonThemeData(
                                    buttonColor: Color(0xff00adb5),
                                  ),
                                  textTheme: const TextTheme(
                                    headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
                                    headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
                                    bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
                                  ),
                                  )
              );
          });
  }
  @override
  Widget buildChild(BuildContext context) {
    bool isBright = false;
    return createApp();        
  }
}
