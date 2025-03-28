import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/lang/translation_service.dart';
import 'package:docusave/app/mahas/mahas_service.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'app/routes/app_pages.dart';

void main() async {
  await initializeDateFormatting('id_ID');
  Intl.defaultLocale = 'id_ID';
  await MahasService.init();
  runApp(
    GetMaterialApp(
      title: "DocuSave",
      theme: ThemeData(
        scaffoldBackgroundColor: MahasColors.white,
        appBarTheme: AppBarTheme(color: MahasColors.white),
        listTileTheme: ListTileThemeData(tileColor: Colors.white),
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      locale: TranslationService.locale,
      translations: TranslationService(),
      fallbackLocale: TranslationService.locale,
      debugShowCheckedModeBanner: false,
    ),
  );
}
