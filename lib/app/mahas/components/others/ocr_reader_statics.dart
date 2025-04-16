import 'package:docusave/app/mahas/constants/input_formatter.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrReaderStatics {
  static String readDateTime(String sourceText) {
    final dateRegex = RegExp(r'\d{2}\.\d{2}\.\d{2}');
    final dateMatch = dateRegex.firstMatch(sourceText);
    if (dateMatch != null) {
      return dateMatch.group(0) ?? "";
    } else {
      final dateRegex = RegExp(r'\d{2}\/\d{2}\/\d{2}');
      final dateMatch = dateRegex.firstMatch(sourceText);
      if (dateMatch != null) {
        return dateMatch.group(0) ?? "";
      } else {
        return "";
      }
    }
  }

  static double? readTotalAmount(String sourceText) {
    final totalRegex = RegExp(
      r'TOTAL\s+(\d{1,3}(,\d{3})*|\d+)',
      caseSensitive: false,
    );
    final totalMatch = totalRegex.firstMatch(sourceText);
    if (totalMatch != null) {
      return InputFormatter.dynamicToDouble(totalMatch.group(1));
    } else {
      return null;
    }
  }

  static String readStoreName(RecognizedText source) {
    if (source.blocks.isEmpty) return "";

    final firstBlock = source.blocks.first;
    if (firstBlock.lines.isNotEmpty) {
      return firstBlock.lines.first.text;
    } else {
      return "";
    }
  }
}
