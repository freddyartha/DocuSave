import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/lang/translation_service.dart';
import 'package:docusave/app/mahas/mahas_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
        scaffoldBackgroundColor: MahasColors.lightgray,
        appBarTheme: AppBarTheme(color: MahasColors.white),
        listTileTheme: ListTileThemeData(tileColor: MahasColors.white),
        fontFamily: 'Poppins',
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: MahasColors.primary,
          selectionColor: MahasColors.primary,
          selectionHandleColor: MahasColors.primary,
        ),
        primaryColor: MahasColors.primary,
        colorScheme: ColorScheme.light(
          primary: MahasColors.primary,
          onPrimary: MahasColors.white,
          onSurface: MahasColors.black,
        ),
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      locale: TranslationService.locale,
      translations: TranslationService(),
      fallbackLocale: TranslationService.locale,
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
    ),
  );
}
