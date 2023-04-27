import 'package:shnatter/src/views/admin/admin_panel/pages/adminbodypanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/adminsList.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/countries.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/currencies.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/design.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/genders.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/languages.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/managePrice.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/onlinesList.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsAccountpanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsAnalyticspanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsChatpanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsEmailpanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsLimitspanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsLivepanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsNotificationpanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsPaymentpanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsRegistrationpanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsSecuritypanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsUploadpanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsPostpanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsSMSpanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/settingsSystempanel.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/shnatter_tokens.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/themes.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/usersList.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/listForums.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/listThreads.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/listReplies.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/listMovies.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/listGenres.dart';
import 'package:shnatter/src/views/admin/admin_panel/pages/games.dart';

class AdminRouter {
  AdminRouter(String settingPage);
  static adminRouter(settingPage) {
    switch (settingPage) {
      case '':
        return AdminMainPanel();
      case '/settings/analystics':
        return AdminSettingsAnalytics();
      case '/settings/chat':
        return AdminSettingsChat();
      case '/settings/limits':
        return AdminSettingsLimits();
      case '/settings/live':
        return AdminSettingsLive();
      case '/settings/system':
        return const AdminSettingsSystem();
      case '/settings/security':
        return const AdminSettingsSecurity();
      case '/settings/registration':
        return const AdminSettingsRegistration();
      case '/settings/account':
        return const AdminSettingsAccount();
      case '/settings/notification':
        return const AdminSettingsNotification();
      case '/settings/upload':
        return const AdminSettingsUpload();
      case '/settings/payments':
        return const AdminSettingsPayment();
      case '/settings/posts':
        return AdminSettingsPosts();
      case '/settings/email':
        return AdminSettingsEmail();
      case '/settings/sms':
        return AdminSettingsSMS();
      case '/manage-prices':
        return AdminManagePrice();
      case '/design':
        return const AdminDesign();
      case '/currencies':
        return const AdminCurrencies();
      case '/languages':
        return AdminLanguages();
      case '/themes':
        return const AdminThemes();
      case '/shnatter_token':
        return AdminShnatterToken();
      case '/genders':
        return const AdminGenders();
      case '/countries':
        return AdminCountries();
      case '/users':
        return AdminUsersList();
      case '/admins':
        return AdminAdminsList();
      case '/onlines':
        return AdminOnlinesList();

      case '/forums/listForums':
        return AdminListForums();
      case '/forums/listThreads':
        return AdminListThreads();
      case '/forums/listReplies':
        return const AdminListReplies();
      case '/movies/listMovies':
        return const AdminListMovies();
      case '/movies/listGenres':
        return const AdminListGenres();
      case '/games':
        return const AdminGames();
    }
  }
}
