import 'package:docusave/app/mahas/lang/translation_service.dart';
import 'package:docusave/app/mahas/mahas_service.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() async {
  //mahas Service
  await MahasService.init();
  runApp(
    GetMaterialApp(
      title: "DocuSave",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      locale: TranslationService.locale,
      translations: TranslationService(),
      fallbackLocale: TranslationService.locale,
      debugShowCheckedModeBanner: false,
    ),
  );
}
