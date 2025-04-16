import 'package:currency_picker/currency_picker.dart';
import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/constants/mahas_radius.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ReusableStatics {
  static double appBarHeight(BuildContext context) =>
      MediaQuery.of(context).padding.top + kToolbarHeight;

  static String idGenerator({bool simple = false}) {
    const uuid = Uuid();
    var r = simple ? uuid.v8().substring(0, 8) : uuid.v8();
    return r;
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
}
