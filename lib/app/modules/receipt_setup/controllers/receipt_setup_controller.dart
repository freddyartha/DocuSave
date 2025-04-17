import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:docusave/app/data/firebase_repository.dart';
import 'package:docusave/app/mahas/components/inputs/input_datetime_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_dropdown_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_text_component.dart';
import 'package:docusave/app/mahas/components/others/ocr_reader_statics.dart';
import 'package:docusave/app/mahas/components/others/reusable_statics.dart';
import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
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
  final InputDropdownController categoryCon = InputDropdownController(
    items: [
      DropdownItem.simple("food_beverage".tr),
      DropdownItem.simple("transportation".tr),
      DropdownItem.simple("electronics".tr),
      DropdownItem.simple("healthcare".tr),
      DropdownItem.simple("entertainment".tr),
      DropdownItem.simple("personal_care".tr),
      DropdownItem.simple("education".tr),
    ],
  );
  final InputDropdownController paymentMethodCon = InputDropdownController(
    items: [
      DropdownItem.simple("cash".tr),
      DropdownItem.simple("bank_transfer".tr),
      DropdownItem.simple("debit_card".tr),
      DropdownItem.simple("credit_card".tr),
      DropdownItem.simple("e_wallet".tr),
      DropdownItem.simple("qris".tr),
      DropdownItem.simple("virtual_account".tr),
      DropdownItem.simple("paylater".tr),
      DropdownItem.simple("cod".tr),
      DropdownItem.simple("voucher".tr),
    ],
  );
  final InputTextController notesCon = InputTextController(
    type: InputTextType.paragraf,
  );

  RxList<String> scannedDoc = <String>[].obs;

  RxBool buttonActive = false.obs;

  @override
  void onInit() {
    scannedDoc.add("element");
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
    activateButton();
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
    categoryCon.onChanged = (value) {
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
    if (scannedDoc.isNotEmpty ||
        receiptIdCon.value != null ||
        storeNameCon.value != null ||
        purchaseDateCon.value != null ||
        totalAmountCon.value != null ||
        currencyCon.value != null ||
        categoryCon.value != null ||
        paymentMethodCon.value != null ||
        notesCon.value != null) {
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
      if (EasyLoading.isShow) EasyLoading.dismiss();
      await EasyLoading.show(status: "Menyimpan Gambar");
      buttonActive.value = false;
      if (auth.currentUser != null) {
        List<String> imageUrl = [];
        // for (var img in scannedDoc) {
        //   String? compressedImagePath = await ReusableStatics.compressImage(
        //     img,
        //   );
        //   if (compressedImagePath != null) {
        //     var result = await FirebaseRepository.saveImageToFirebaseStorage(
        //       imageLocationType: ImageLocationType.receipt,
        //       fileName: ReusableStatics.idGenerator(simple: true),
        //       imageFile: File(compressedImagePath),
        //     );
        //     if (result != null) {
        //       imageUrl.add(result);
        //     }
        //   }
        // }

        if (EasyLoading.isShow) EasyLoading.dismiss();
        await EasyLoading.show(status: "Menyimpan Dokumen");
        ReceiptModel receiptModel = ReceiptModel(
          documentid: ReusableStatics.idGenerator(),
          receiptid: receiptIdCon.value,
          storename: storeNameCon.value,
          purchasedate: purchaseDateCon.value,
          totalamount: totalAmountCon.value,
          currency: currencyCon.value,
          category: categoryCon.value,
          paymentmethod: paymentMethodCon.value,
          receiptimage: imageUrl,
          notes: notesCon.value,
          createdat: Timestamp.now(),
        );
        bool result = await FirebaseRepository.addReceiptToFirestore(
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
}
