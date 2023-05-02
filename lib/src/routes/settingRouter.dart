import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/views/setting/pages/delete.dart';
import 'package:shnatter/src/views/setting/pages/information.dart';
import 'package:shnatter/src/views/setting/pages/notifications.dart';
import 'package:shnatter/src/views/setting/pages/privacy.dart';
import 'package:shnatter/src/views/setting/pages/profile_basic_page.dart';
import 'package:shnatter/src/views/setting/pages/profile_design_page.dart';
import 'package:shnatter/src/views/setting/pages/profile_education_page.dart';
import 'package:shnatter/src/views/setting/pages/profile_interests.dart';
import 'package:shnatter/src/views/setting/pages/profile_location_page.dart';
import 'package:shnatter/src/views/setting/pages/profile_social_page.dart';
import 'package:shnatter/src/views/setting/pages/profile_work_page.dart';
import 'package:shnatter/src/views/setting/pages/security_password.dart';
import 'package:shnatter/src/views/setting/pages/security_sessions.dart';
import 'package:shnatter/src/views/setting/pages/shnatter_token.dart';
import 'package:shnatter/src/views/setting/pages/verification.dart';
import 'package:shnatter/src/views/setting/pages/account_page.dart';
import 'package:shnatter/src/views/setting/pages/twoFactorAuthentication_page.dart';

class SettingRouter {
  SettingRouter(String settingPage);
  static settingRouter(settingPage, routerChange) {
    switch (settingPage) {
      case '':
        return SettingAccountScreen(routerChange: routerChange);
      case RouteNames.settings_profile_basic:
        return SettingBasicScreen(routerChange: routerChange);
      case RouteNames.settings_profile_work:
        return SettingWorkScreen(routerChange: routerChange);
      case RouteNames.settings_profile_location:
        return SettingLocationScreen(routerChange: routerChange);
      case RouteNames.settings_profile_education:
        return SettingEducationScreen(routerChange: routerChange);
      case RouteNames.settings_profile_social:
        return SettingSocialScreen(routerChange: routerChange);
      case RouteNames.settings_profile_interests:
        return SettingInterestsScreen(routerChange: routerChange);
      case RouteNames.settings_profile_design:
        return SettingDesignScreen(routerChange: routerChange);
      case RouteNames.settings_security_password:
        return SettingSecurityPasswordScreen(routerChange: routerChange);
      case RouteNames.settings_security_sessions:
        return SettingSecuritySessScreen(routerChange: routerChange);
      case RouteNames.settings_privacy:
        return SettingPrivacyScreen(routerChange: routerChange);
      case RouteNames.settings_notifications:
        return SettingNotificationScreen(routerChange: routerChange);
      case RouteNames.settings_token:
        return SettingShnatterTokenScreen(routerChange: routerChange);
      case RouteNames.settings_verification:
        return SettingVerificationScreen(routerChange: routerChange);
      case RouteNames.settings_information:
        return SettingInfoScreen(routerChange: routerChange);
      case RouteNames.settings_delete:
        return SettingDeleteScreen(routerChange: routerChange);
      case RouteNames.settings_two_factor:
        return TwoFactorAuthenticationScreen(routerChange: routerChange);
    }
  }
}
