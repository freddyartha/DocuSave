import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docusave/app/data/firebase_repository.dart';
import 'package:docusave/app/mahas/components/inputs/input_datetime_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_text_component.dart';
import 'package:docusave/app/mahas/components/others/ocr_reader_statics.dart';
import 'package:docusave/app/mahas/components/others/reusable_statics.dart';
import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/mahas_service.dart';
import 'package:docusave/app/models/warranty_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class WarrantySetupController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;
  RxString id = "".obs;
  RxBool loadingData = false.obs;
  RxBool editable = true.obs;
  final InputTextController storeNameCon = InputTextController(
    type: InputTextType.text,
  );
  final InputTextController itemNameCon = InputTextController(
    type: InputTextType.text,
  );
  final InputTextController serialNumberCon = InputTextController(
    type: InputTextType.text,
  );
  final InputDatetimeController purchaseDateCon = InputDatetimeController();
  final InputTextController warrantyPeriodCon = InputTextController(
    type: InputTextType.number,
  );
  final InputDatetimeController warrantyExpiryCon = InputDatetimeController();
  final InputTextController warrantyProviderCon = InputTextController(
    type: InputTextType.text,
  );
  final InputTextController receiptIdCon = InputTextController(
    type: InputTextType.text,
  );
  final InputTextController notesCon = InputTextController(
    type: InputTextType.paragraf,
  );

  RxList<String> scannedDoc = <String>[].obs;

  RxBool buttonActive = false.obs;

  @override
  void onInit() async {
    purchaseDateCon.value = DateTime.now();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    animation = Tween(begin: 0.0, end: 12).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );
    animationController.repeat(reverse: true);

    id.value = Get.parameters["id"] ?? "";
    if (id.value.isNotEmpty) {
      editable.value = false;
      loadingData.value = true;
      var r = await FirebaseRepository.getWarrantytById(
        documentId: id.value,
        userUid: auth.currentUser!.uid,
      );
      loadingData.value = false;
      if (r != null) {
        scannedDoc.addAll(r.warrantyimage);
        storeNameCon.value = r.storename;
        itemNameCon.value = r.itemname;
        serialNumberCon.value = r.serialnumber;
        purchaseDateCon.value = r.purchasedate;
        warrantyPeriodCon.value = r.warrantyperiodmonths;
        warrantyExpiryCon.value = r.warrantyexpirydate;
        warrantyProviderCon.value = r.warrantyprovider;
        receiptIdCon.value = r.receiptid;
        notesCon.value = r.notes;
      }
    }

    activateButton();
    super.onInit();
  }

  void activateButton() {
    storeNameCon.onChanged = (value) {
      if (!buttonActive.value) buttonActive.value = true;
    };
    itemNameCon.onChanged = (value) {
      if (!buttonActive.value) buttonActive.value = true;
    };
    serialNumberCon.onChanged = (value) {
      if (!buttonActive.value) buttonActive.value = true;
    };
    purchaseDateCon.onChanged = () {
      if (!buttonActive.value) buttonActive.value = true;
    };
    warrantyPeriodCon.onChanged = (value) {
      if (!buttonActive.value) buttonActive.value = true;
      if (purchaseDateCon.value != null && value.isNotEmpty) {
        DateTime purchaseDate = (purchaseDateCon.value as Timestamp).toDate();
        DateTime expiryDate = ReusableStatics.addMonths(
          purchaseDate,
          int.parse(value),
        );
        warrantyExpiryCon.value = expiryDate;
      } else {
        warrantyExpiryCon.value = null;
      }
    };
    warrantyExpiryCon.onChanged = () {
      if (!buttonActive.value) buttonActive.value = true;
    };
    warrantyProviderCon.onChanged = (value) {
      if (!buttonActive.value) buttonActive.value = true;
    };
    receiptIdCon.onChanged = (value) {
      if (!buttonActive.value) buttonActive.value = true;
    };
    notesCon.onChanged = (value) {
      if (!buttonActive.value) buttonActive.value = true;
    };
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
        for (var r in results) {
          scannedDoc.add(r.toString());
        }

        // OCR
        final textRecognizer = TextRecognizer(
          script: TextRecognitionScript.latin,
        );
        if (scannedDoc.isNotEmpty) {
          try {
            final firstPage = InputImage.fromFilePath(scannedDoc.first);
            final recognizedFirstPage = await textRecognizer.processImage(
              firstPage,
            );

            storeNameCon.value = OcrReaderStatics.readStoreName(
              recognizedFirstPage,
            );
            purchaseDateCon.value = OcrReaderStatics.readDateTime(
              recognizedFirstPage.text,
            );

            await textRecognizer.close();
          } catch (e) {
            await ReusableWidgets.notifBottomSheet(
              subtitle: "failed_read_ocr".tr,
            );
          }
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

  bool showConfirmationCondition() {
    if (editable.value &&
        (scannedDoc.isNotEmpty ||
            storeNameCon.value != null ||
            itemNameCon.value != null ||
            serialNumberCon.value != null ||
            warrantyPeriodCon.value != null ||
            warrantyExpiryCon.value != null ||
            warrantyProviderCon.value != null ||
            receiptIdCon.value != null ||
            notesCon.value != null)) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> saveOnTap() async {
    if (buttonActive.value) {
      FocusScope.of(Get.context!).unfocus();
      bool validation = showConfirmationCondition();
      if (!validation) return;
      if (!storeNameCon.isValid) return;
      if (!itemNameCon.isValid) return;
      if (!serialNumberCon.isValid) return;
      if (!purchaseDateCon.isValid) return;
      if (!warrantyPeriodCon.isValid) return;
      if (!warrantyExpiryCon.isValid) return;
      if (!warrantyProviderCon.isValid) return;
      if (!receiptIdCon.isValid) return;
      if (!notesCon.isValid) return;

      buttonActive.value = false;
      if (auth.currentUser != null) {
        List<String> imageUrl = [];
        if (scannedDoc.first.contains(RegExp('http', caseSensitive: false))) {
          imageUrl.addAll(scannedDoc);
        } else {
          if (EasyLoading.isShow) EasyLoading.dismiss();
          await EasyLoading.show(status: "save_image".tr);
          for (var img in scannedDoc) {
            String? compressedImagePath = await ReusableStatics.compressImage(
              img,
            );
            if (compressedImagePath != null) {
              var result = await FirebaseRepository.saveImageToFirebaseStorage(
                imageLocationType: ImageLocationType.warranty,
                fileName: ReusableStatics.idGenerator(simple: true),
                imageFile: File(compressedImagePath),
              );
              if (result != null) {
                imageUrl.add(result);
              }
            }
          }
        }

        if (EasyLoading.isShow) EasyLoading.dismiss();
        await EasyLoading.show(status: "save_data".tr);
        WarrantyModel model = WarrantyModel(
          documentid: id.isNotEmpty ? id.value : ReusableStatics.idGenerator(),
          itemname: itemNameCon.value,
          serialnumber: serialNumberCon.value,
          purchasedate: purchaseDateCon.value,
          warrantyperiodmonths: warrantyPeriodCon.value,
          warrantyexpirydate: warrantyExpiryCon.value,
          storename: storeNameCon.value,
          warrantyprovider: warrantyProviderCon.value,
          warrantyimage: imageUrl,
          receiptid: receiptIdCon.value,
          notes: notesCon.value,
          remindersent: false,
          createdat: Timestamp.now(),
          updatedat: id.isNotEmpty ? Timestamp.now() : null,
        );

        bool result =
            id.isNotEmpty
                ? await FirebaseRepository.updateWarrantyById(
                  model: model,
                  userUid: auth.currentUser!.uid,
                )
                : await FirebaseRepository.addWarrantyToFirestore(
                  model: model,
                  userUid: auth.currentUser!.uid,
                );

        update();
        await EasyLoading.dismiss();
        if (result) {
          bool? result = await ReusableWidgets.notifBottomSheet(
            notifType: NotifType.success,
            subtitle: "success_save_warranty".tr,
          );
          if (result != null) Get.back(result: true);
        } else {
          buttonActive.value = true;
        }
      }
    }
  }

  void deleteData() async {
    if (EasyLoading.isShow) EasyLoading.dismiss();
    await EasyLoading.show(status: "delete_data".tr);
    bool? result = await FirebaseRepository.deleteWarrantyById(
      documentId: id.value,
      userUid: auth.currentUser!.uid,
    );
    if (result == true) {
      Get.back(result: true);
    }
    await EasyLoading.dismiss();
  }
}
