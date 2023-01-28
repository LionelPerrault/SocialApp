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
  static settingRouter(settingPage) {
    switch (settingPage) {
      case '':
        return SettingAccountScreen();
      case RouteNames.settings_profile_basic:
        return SettingBasicScreen();
      case RouteNames.settings_profile_work:
        return SettingWorkScreen();
      case RouteNames.settings_profile_location:
        return SettingLocationScreen();
      case RouteNames.settings_profile_education:
        return SettingEducationScreen();
      case RouteNames.settings_profile_social:
        return SettingSocialScreen();
      case RouteNames.settings_profile_interests:
        return SettingInterestsScreen();
      case RouteNames.settings_profile_design:
        return SettingDesignScreen();
      case RouteNames.settings_security_password:
        return SettingSecurityPasswordScreen();
      case RouteNames.settings_security_sessions:
        return SettingSecuritySessScreen();
      case RouteNames.settings_privacy:
        return SettingPrivacyScreen();
      case RouteNames.settings_notifications:
        return SettingNotificationScreen();
      case RouteNames.settings_token:
        return SettingShnatterTokenScreen();
      case RouteNames.settings_verification:
        return SettingVerificationScreen();
      case RouteNames.settings_information:
        return SettingInfoScreen();
      case RouteNames.settings_delete:
        return SettingDeleteScreen();
      case RouteNames.settings_two_factor:
        return TwoFactorAuthenticationScreen();
    }
  }
}
