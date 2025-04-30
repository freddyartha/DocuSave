import 'dart:ui';

import 'package:docusave/app/mahas/constants/input_formatter.dart';
import 'package:docusave/app/mahas/lang/translation_service.dart';
import 'package:flutter/services.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    double value =
        TranslationService.locale == Locale("id", "ID")
            ? InputFormatter.dynamicToDouble(
                  newValue.text.replaceAll(".", ""),
                ) ??
                0
            : InputFormatter.dynamicToDouble(
                  newValue.text.replaceAll(",", ""),
                ) ??
                0;
    String newText = InputFormatter.toCurrency(value);
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  static FilteringTextInputFormatter allow = FilteringTextInputFormatter.allow(
    RegExp(r'^(\d+)|(,)?\.?\d{0,10}'),
  );
}
