import 'dart:ui';

import 'package:docusave/app/mahas/lang/en_us.dart';
import 'package:docusave/app/mahas/lang/id_id.dart';
import 'package:get/get.dart';

class TranslationService extends Translations {
  static Locale? get locale => Get.deviceLocale;
  // static Locale? get locale => const Locale("id", "ID");
  static const feedBackLocale = Locale("id", "ID");

  Map<String, String> mergedIdLang = {...idID};
  Map<String, String> mergedEnLang = {...enUS};

  @override
  Map<String, Map<String, String>> get keys => {
    "id_ID": mergedIdLang,
    "en_US": mergedEnLang,
  };

  static void changeLocale(String langCode) {
    final locale = Locale(langCode, langCode.toUpperCase());
    Get.updateLocale(locale);
  }
}
