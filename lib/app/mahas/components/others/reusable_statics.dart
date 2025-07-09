import 'dart:io';

import 'package:currency_picker/currency_picker.dart';
import 'package:docusave/app/mahas/components/buttons/button_component.dart';
import 'package:docusave/app/mahas/components/images/image_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_checkbox_multiple_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_dropdown_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_radio_component.dart';
import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/constants/mahas_config.dart';
import 'package:docusave/app/mahas/constants/mahas_font_size.dart';
import 'package:docusave/app/mahas/constants/mahas_radius.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
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

  static String getMonthKey(DateTime date) =>
      DateFormat('yyyy-MM').format(date);

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

  static Future<void> checkingVersion() async {
    final storage = GetStorage();
    final updateLater = storage.read('update_later');
    final now = DateTime.now();
    final updateLaterDate =
        updateLater == null ? null : DateTime.parse(updateLater);
    String versi = MahasConfig.packageInfo!.version;

    if ((!kIsWeb && updateLaterDate != null && updateLaterDate.isBefore(now)) ||
        updateLater == null) {
      if (Platform.isIOS || Platform.isAndroid) {
        if (versi != MahasConfig.updateAppValues.version) {
          final r = await ReusableWidgets.customBottomSheet(
            title: "Update ke Versi Terbaru",
            allowPopScope:
                MahasConfig.updateAppValues.mustUpdate == true ? false : true,
            children: [
              Center(
                child: ImageComponent(
                  localUrl: "assets/images/update_app.png",
                  height: 220,
                  width: Get.width,
                  boxFit: BoxFit.fitHeight,
                  margin: EdgeInsets.only(bottom: 10),
                ),
              ),
              TextComponent(
                value: "Terdapat pembaharuan di versi aplikasi",
                fontWeight: FontWeight.w600,
                fontSize: MahasFontSize.h6,
                margin: EdgeInsets.only(bottom: 20),
              ),
              ButtonComponent(
                onTap: () async {
                  await launchUrl(
                    Uri.parse(MahasConfig.updateAppValues.urlUpdate ?? ""),
                    mode: LaunchMode.externalApplication,
                  ).then(
                    (value) => {
                      if (Platform.isAndroid)
                        {SystemNavigator.pop()}
                      else if (Platform.isIOS)
                        {exit(0)},
                    },
                  );
                },
                text: "Perbaharui Sekarang",
              ),
            ],
          );
          if (r != true) {
            storage.write(
              'update_later',
              now
                  .add(
                    Duration(
                      days: MahasConfig.updateAppValues.dismissDuration ?? 5,
                    ),
                  )
                  .toString(),
            );
          }
        }
      }
    }
  }

  static Future<void> launchPrivacyPolicy() async => await launchUrl(
    Uri.parse(
      "https://www.termsfeed.com/live/4c6ab02d-a200-4431-8d44-8b67a330ef6e",
    ),
    mode: LaunchMode.externalApplication,
  );

  static List<CheckboxItem> listKategori = [
    CheckboxItem(text: "food_beverage".tr, value: 1),
    CheckboxItem(text: "transportation".tr, value: 2),
    CheckboxItem(text: "electronics".tr, value: 3),
    CheckboxItem(text: "healthcare".tr, value: 4),
    CheckboxItem(text: "entertainment".tr, value: 5),
    CheckboxItem(text: "personal_care".tr, value: 6),
    CheckboxItem(text: "education".tr, value: 7),
    CheckboxItem(text: "salary".tr, value: 9),
    CheckboxItem(text: "business_profit".tr, value: 10),
    CheckboxItem(text: "saving".tr, value: 11),
  ];

  static List<DropdownItem> listPaymentMethod = [
    DropdownItem(text: "cash".tr, value: 1),
    DropdownItem(text: "bank_transfer".tr, value: 2),
    DropdownItem(text: "debit_card".tr, value: 3),
    DropdownItem(text: "credit_card".tr, value: 4),
    DropdownItem(text: "e_wallet".tr, value: 5),
    DropdownItem(text: "qris".tr, value: 6),
    DropdownItem(text: "virtual_account".tr, value: 7),
    DropdownItem(text: "paylater".tr, value: 8),
    DropdownItem(text: "cod".tr, value: 9),
    DropdownItem(text: "voucher".tr, value: 10),
  ];

  static List<RadioButtonItem> listTypeMoneyTracker = [
    RadioButtonItem(text: "pemasukan".tr, value: 1),
    RadioButtonItem(text: "pengeluaran".tr, value: 2),
  ];

  static String getTypeMoneyTrackerFromId(int id) {
    if (id == 1) {
      return "pemasukan".tr;
    }
    return "pengeluaran".tr;
  }
}
