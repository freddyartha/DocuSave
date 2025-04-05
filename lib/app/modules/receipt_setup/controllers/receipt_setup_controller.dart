import 'package:docusave/app/mahas/components/inputs/input_text_component.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:get/get.dart';

class ReceiptSetupController extends GetxController {
  final InputTextController namaCon = InputTextController(
    type: InputTextType.text,
  );
  final InputTextController emailCon = InputTextController(
    type: InputTextType.email,
  );

  RxBool isLoading = false.obs;
  RxBool buttonActive = false.obs;

  void scanDocument() async {
    try {
      await FlutterDocScanner().getScanDocuments(page: 1);
    } on PlatformException {
      print("terjadi kesalahan");
    } catch (e) {
      print("terjadi kesalahan");
    }
  }
}
