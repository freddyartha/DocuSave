import 'dart:ui';

import 'package:docusave/app/mahas/constants/mahas_config.dart';
import 'package:docusave/app/mahas/lang/en_us.dart';
import 'package:docusave/app/mahas/lang/id_id.dart';
import 'package:get/get.dart';

class TranslationService extends Translations {
  static Locale get locale {
    String? localeCode = MahasConfig.userProfile?.selectedLanguage;
    if (localeCode != null && localeCode == "id") {
      return Locale(localeCode, localeCode.toUpperCase());
    } else if (localeCode != null && localeCode == "en") {
      return Locale(localeCode, localeCode.toUpperCase());
    } else {
      return Get.deviceLocale ?? const Locale("id", "ID");
    }
  }

  Map<String, String> mergedIdLang = {...idID};
  Map<String, String> mergedEnLang = {...enUS};

  @override
  Map<String, Map<String, String>> get keys => {
    "id_ID": mergedIdLang,
    "en_US": mergedEnLang,
  };
}
