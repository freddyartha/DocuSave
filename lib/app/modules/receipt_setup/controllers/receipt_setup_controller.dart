import 'package:docusave/app/mahas/components/inputs/input_text_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ReceiptSetupController extends GetxController {
  final InputTextController namaCon = InputTextController(
    type: InputTextType.text,
  );
  final InputTextController emailCon = InputTextController(
    type: InputTextType.email,
  );
  List<String> scannedDoc = [];

  RxBool isLoading = false.obs;
  RxBool buttonActive = false.obs;

  void scanDocument() async {
    try {
      final results = await FlutterDocScanner().getScannedDocumentAsImages(
        page: 4,
      );
      if (results != null) {
        for (var r in results) {
          scannedDoc.add(r.toString());
        }

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
