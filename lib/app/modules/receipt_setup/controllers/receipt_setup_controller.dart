import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:docusave/app/data/firebase_repository.dart';
import 'package:docusave/app/mahas/components/inputs/input_checkbox_multiple_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_datetime_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_dropdown_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_text_component.dart';
import 'package:docusave/app/mahas/components/others/ocr_reader_statics.dart';
import 'package:docusave/app/mahas/components/others/reusable_statics.dart';
import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/input_formatter.dart';
import 'package:docusave/app/mahas/mahas_service.dart';
import 'package:docusave/app/models/receipt_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ReceiptSetupController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;
  RxString id = "".obs;
  RxBool loadingData = false.obs;
  RxBool editable = true.obs;
  final InputTextController receiptIdCon = InputTextController(
    type: InputTextType.text,
  );
  final InputTextController storeNameCon = InputTextController(
    type: InputTextType.text,
  );
  final InputDatetimeController purchaseDateCon = InputDatetimeController();
  final InputTextController totalAmountCon = InputTextController(
    type: InputTextType.money,
  );
  final InputTextController currencyCon = InputTextController(
    type: InputTextType.text,
  );
  final InputCheckboxMultipleController categoryCon =
      InputCheckboxMultipleController(items: ReusableStatics.listKategori);
  final InputDropdownController paymentMethodCon = InputDropdownController(
    items: ReusableStatics.listPaymentMethod,
  );
  final InputTextController notesCon = InputTextController(
    type: InputTextType.paragraf,
  );

  RxList<String> scannedDoc = <String>[].obs;

  RxBool buttonActive = false.obs;

  @override
  void onInit() async {
    purchaseDateCon.value = DateTime.now();
    currencyCon.value = "IDR";

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
      var r = await FirebaseRepository.getReceiptById(
        documentId: id.value,
        userUid: auth.currentUser!.uid,
      );
      loadingData.value = false;
      if (r != null) {
        scannedDoc.addAll(r.receiptimage);
        receiptIdCon.value = r.receiptid;
        storeNameCon.value = r.storename;
        purchaseDateCon.value = r.purchasedate;
        totalAmountCon.value = r.totalamount;
        currencyCon.value = r.currency;
        categoryCon.value = r.category;
        paymentMethodCon.value = r.paymentmethod;
        notesCon.value = r.notes;
      }
    } else {
      currencyOnTap();
    }

    ever(editable, (value) {
      if (value) {
        currencyOnTap();
      } else {
        currencyCon.onTap = () {};
      }
    });

    activateButton();
    super.onInit();
  }

  void currencyOnTap() =>
      currencyCon.onTap =
          () => showCurrencyPicker(
            context: Get.context!,
            showFlag: true,
            showCurrencyName: true,
            showCurrencyCode: true,
            favorite: ["IDR", "USD", "SGD"],
            onSelect: (Currency currency) => currencyCon.value = currency.code,
            theme: ReusableStatics.currencyPickerTheme(),
          );

  void activateButton() {
    receiptIdCon.onChanged = (value) {
      if (!buttonActive.value) buttonActive.value = true;
    };
    storeNameCon.onChanged = (value) {
      if (!buttonActive.value) buttonActive.value = true;
    };
    purchaseDateCon.onChanged = () {
      if (!buttonActive.value) buttonActive.value = true;
    };
    totalAmountCon.onChanged = (value) {
      if (!buttonActive.value) buttonActive.value = true;
    };
    currencyCon.onChanged = (value) {
      if (!buttonActive.value) buttonActive.value = true;
    };
    categoryCon.onChanged = () {
      if (!buttonActive.value) buttonActive.value = true;
    };
    paymentMethodCon.onChanged = (value) {
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
            if (scannedDoc.length > 1) {
              totalAmountCon.value = OcrReaderStatics.readTotalAmount(
                recognizedFirstPage.text,
              );
            } else {
              final lastPage = InputImage.fromFilePath(scannedDoc.last);
              final recognizedLastPage = await textRecognizer.processImage(
                lastPage,
              );
              totalAmountCon.value = OcrReaderStatics.readTotalAmount(
                recognizedLastPage.text,
              );
            }
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
            receiptIdCon.value != null ||
            storeNameCon.value != null ||
            totalAmountCon.value != null ||
            categoryCon.value.isNotEmpty ||
            paymentMethodCon.value != null ||
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
      if (!receiptIdCon.isValid) return;
      if (!storeNameCon.isValid) return;
      if (!purchaseDateCon.isValid) return;
      if (!totalAmountCon.isValid) return;
      if (!currencyCon.isValid) return;
      if (!categoryCon.isValid) return;
      if (!paymentMethodCon.isValid) return;
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
                imageLocationType: ImageLocationType.receipt,
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
        ReceiptModel receiptModel = ReceiptModel(
          documentid: id.isNotEmpty ? id.value : ReusableStatics.idGenerator(),
          receiptid: receiptIdCon.value,
          storename: storeNameCon.value,
          purchasedate: purchaseDateCon.value,
          totalamount: totalAmountCon.value,
          currency: currencyCon.value,
          category:
              categoryCon.value
                  .map((item) => InputFormatter.dynamicToInt(item) ?? 0)
                  .toList(),
          paymentmethod: paymentMethodCon.value,
          receiptimage: imageUrl,
          notes: notesCon.value,
          createdat: Timestamp.now(),
          updatedat: id.isNotEmpty ? Timestamp.now() : null,
        );

        bool result =
            id.isNotEmpty
                ? await FirebaseRepository.updateReceiptById(
                  receiptModel: receiptModel,
                  userUid: auth.currentUser!.uid,
                )
                : await FirebaseRepository.addReceiptToFirestore(
                  receiptModel: receiptModel,
                  userUid: auth.currentUser!.uid,
                );

        update();
        await EasyLoading.dismiss();
        if (result) {
          bool? result = await ReusableWidgets.notifBottomSheet(
            notifType: NotifType.success,
            subtitle: "success_save_receipt".tr,
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
    bool? result = await FirebaseRepository.deleteReceiptById(
      documentId: id.value,
      userUid: auth.currentUser!.uid,
    );
    if (result == true) {
      Get.back(result: true);
    }
    await EasyLoading.dismiss();
  }
}
