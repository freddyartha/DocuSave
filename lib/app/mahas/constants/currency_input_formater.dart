import 'package:docusave/app/mahas/constants/input_formatter.dart';
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
    double value = InputFormatter.currencyToDouble(newValue.text);
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
