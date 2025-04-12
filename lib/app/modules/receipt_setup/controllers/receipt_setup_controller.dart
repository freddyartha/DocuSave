import 'package:docusave/app/mahas/components/inputs/input_text_component.dart';
import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ReceiptSetupController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;
  final InputTextController receiptIdCon = InputTextController(
    type: InputTextType.text,
  );
  final InputTextController storeNameCon = InputTextController(
    type: InputTextType.text,
  );
  final InputTextController purchaseDateCon = InputTextController(
    type: InputTextType.text,
  );
  final InputTextController totalAmountCon = InputTextController(
    type: InputTextType.text,
  );
  final InputTextController currencyCon = InputTextController(
    type: InputTextType.text,
  );
  final InputTextController categoryCon = InputTextController(
    type: InputTextType.text,
  );
  final InputTextController paymentMethodCon = InputTextController(
    type: InputTextType.text,
  );
  final InputTextController notesCon = InputTextController(
    type: InputTextType.paragraf,
  );

  RxList<String> scannedDoc = <String>[].obs;

  RxBool isLoading = false.obs;
  RxBool buttonActive = false.obs;

  @override
  void onInit() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    animation = Tween(begin: 0.0, end: 12).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );
    animationController.repeat(reverse: true);
    super.onInit();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  void resetScan() async {
    bool? result = await ReusableWidgets.confirmationBottomSheet(
      textConfirm: "yes".tr,
      withImage: true,
      children: [
        TextComponent(
          value: "confirm_reset_scan".tr,
          textAlign: TextAlign.center,
        ),
      ],
    );
    if (result == true) {
      scannedDoc.clear();
      update();
    }
  }

  void scanDocument() async {
    try {
      final results = await FlutterDocScanner().getScannedDocumentAsImages(
        page: 4,
      );
      if (results != null) {
        scannedDoc.addAll(results as List<String>);

        // OCR
        final textRecognizer = TextRecognizer(
          script: TextRecognitionScript.latin,
        );
        if (scannedDoc.isNotEmpty) {
          for (var read in scannedDoc) {
            final inputImage = InputImage.fromFilePath(read);
            final recognizedText = await textRecognizer.processImage(
              inputImage,
            );

            print("Hasil OCR:");
            print(recognizedText.text);
          }
          await textRecognizer.close();
        }
      }

      update();
    } on PlatformException catch (e) {
      ReusableWidgets.notifBottomSheet(
        subtitle: e.message ?? "",
        notifType: NotifType.warning,
      );
    } catch (e) {
      ReusableWidgets.notifBottomSheet(
        subtitle: e.toString(),
        notifType: NotifType.warning,
      );
    }
  }
}
