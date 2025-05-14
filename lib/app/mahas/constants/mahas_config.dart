import 'package:docusave/app/mahas/models/update_app_values_model.dart';
import 'package:docusave/app/models/user_model.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MahasConfig {
  static PackageInfo? packageInfo;
  static UpdateappvaluesModel updateAppValues = UpdateappvaluesModel();
  static UserModel? userProfile;
  static bool demo = false;
}
