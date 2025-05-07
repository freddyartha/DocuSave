import 'package:currency_picker/currency_picker.dart';
import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/constants/mahas_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ReusableStatics {
  static double appBarHeight(BuildContext context) =>
      MediaQuery.of(context).padding.top + kToolbarHeight;

  static String idGenerator({bool simple = false}) {
    const uuid = Uuid();
    var r = simple ? uuid.v4().split('-').last : uuid.v8();
    return r;
  }

  static Future<String?> compressImage(String filePath) async {
    final dir = await getTemporaryDirectory();
    final targetPath =
        "${dir.absolute.path}/${basename(filePath)}_compressed.jpg";

    var result = await FlutterImageCompress.compressAndGetFile(
      filePath,
      targetPath,
      quality: 50,
    );

    return result?.path;
  }

  static CurrencyPickerThemeData currencyPickerTheme() =>
      CurrencyPickerThemeData(
        backgroundColor: MahasColors.white,
        bottomSheetHeight: Get.height * 0.6,
        inputDecoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          prefixIcon: Icon(Icons.search),
          focusColor: MahasColors.primary,
          hoverColor: MahasColors.primary,
          fillColor: MahasColors.white,
          label: TextComponent(value: "select_currency".tr),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MahasRadius.regular),
            borderSide: BorderSide(color: MahasColors.black),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MahasRadius.regular),
            borderSide: BorderSide(color: MahasColors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MahasRadius.regular),
            borderSide: BorderSide(color: MahasColors.black),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MahasRadius.regular),
            borderSide: BorderSide(color: MahasColors.black),
          ),
        ),
      );

  static String? getWarrantyRemaining(DateTime expiryDate) {
    final now = DateTime.now();

    int years = expiryDate.year - now.year;
    int months = expiryDate.month - now.month;
    int days = expiryDate.day - now.day;

    if (days < 0) {
      months -= 1;
      days += DateTime(expiryDate.year, expiryDate.month, 0).day;
    }

    if (months < 0) {
      years -= 1;
      months += 12;
    }

    List<String> parts = [];
    if (years > 0) {
      parts.add('$years ${'year'.tr}');
    }
    if (months > 0) {
      parts.add('$months ${'month'.tr}');
    }
    if (days > 0) {
      parts.add('$days ${'day'.tr}');
    }

    return DateTime(expiryDate.year, expiryDate.month, expiryDate.day) ==
            DateTime(now.year, now.month, now.day)
        ? "expires_today".tr
        : expiryDate.isBefore(DateTime(now.year, now.month, now.day))
        ? "expired".tr
        : parts.isEmpty
        ? null
        : "${'expires_in'.tr} ${parts.join(' ')}";
  }

  static DateTime addMonths(DateTime date, int months) {
    int year = date.year + ((date.month + months - 1) ~/ 12);
    int month = (date.month + months - 1) % 12 + 1;
    int day = date.day;

    int lastDayOfMonth = DateTime(year, month + 1, 0).day;
    if (day > lastDayOfMonth) {
      day = lastDayOfMonth;
    }

    return DateTime(year, month, day).subtract(const Duration(days: 1));
  }
}
