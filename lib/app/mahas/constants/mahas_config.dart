import 'package:docusave/app/mahas/models/update_app_values_model.dart';
import 'package:docusave/app/mahas/models/web_view_values_model.dart';
import 'package:docusave/app/models/user_model.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MahasConfig {
  static PackageInfo? packageInfo;
  static UpdateappvaluesModel updateAppValues = UpdateappvaluesModel();
  static WebViewValuesModel webViewValues = WebViewValuesModel();
  static UserModel? userProfile;
  static bool demo = false;
  static bool isInitialShortcut = false;
  static String webViewDirectory = '';
  static String localWebViewVersion = '1.0.1';
}
