import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:docusave/app/data/firebase_repository.dart';
import 'package:docusave/app/mahas/components/inputs/input_datetime_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_radio_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_text_component.dart';
import 'package:docusave/app/mahas/components/others/reusable_statics.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/mahas_service.dart';
import 'package:docusave/app/models/service_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ServiceSetupController extends GetxController {
  RxString id = "".obs;
  RxBool loadingData = false.obs;
  RxBool editable = true.obs;
  RxBool buttonActive = false.obs;

  final InputTextController productNameCon = InputTextController();
  final InputDatetimeController serviceDateCon = InputDatetimeController();
  final InputTextController storeNameCon = InputTextController();
  final InputTextController problemDescCon = InputTextController(
    type: InputTextType.paragraf,
  );
  final InputTextController serviceDescCon = InputTextController(
    type: InputTextType.paragraf,
  );
  final InputTextController priceCon = InputTextController(
    type: InputTextType.money,
  );
  final InputTextController currencyCon = InputTextController();
  final InputTextController warrantyPeriodCon = InputTextController(
    type: InputTextType.number,
  );
  final InputDatetimeController expiryDateCon = InputDatetimeController();
  final InputRadioController statusCon = InputRadioController(
    items: [
      RadioButtonItem(text: "service_status_completed".tr, value: 1),
      RadioButtonItem(text: "service_status_processing".tr, value: 2),
      RadioButtonItem(text: "service_status_pending".tr, value: 3),
    ],
  );
  final InputDatetimeController pickUpDateCon = InputDatetimeController();

  @override
  void onInit() async {
    id.value = Get.parameters["id"] ?? "";
    if (id.value.isNotEmpty) {
      editable.value = false;
      loadingData.value = true;
      var r = await FirebaseRepository.getServiceById(
        documentId: id.value,
        userUid: auth.currentUser!.uid,
      );
      loadingData.value = false;
      if (r != null) {
        productNameCon.value = r.productname;
        serviceDateCon.value = r.servicedate;
        storeNameCon.value = r.storename;
        problemDescCon.value = r.problemdescription;
        serviceDescCon.value = r.servicedescription;
        priceCon.value = r.price;
        currencyCon.value = r.currency;
        warrantyPeriodCon.value = r.warrantyperioddays;
        expiryDateCon.value = r.warrantyexpirydate;
        statusCon.value = r.servicestatus;
        pickUpDateCon.value = r.pickupdate;
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
    productNameCon.onChanged = (value) {
      if (!buttonActive.value) buttonActive.value = true;
    };
    serviceDateCon.onChanged = () {
      if (!buttonActive.value) buttonActive.value = true;
    };
    storeNameCon.onChanged = (value) {
      if (!buttonActive.value) buttonActive.value = true;
    };
    problemDescCon.onChanged = (value) {
      if (!buttonActive.value) buttonActive.value = true;
    };
    serviceDescCon.onChanged = (value) {
      if (!buttonActive.value) buttonActive.value = true;
    };
    priceCon.onChanged = (value) {
      if (!buttonActive.value) buttonActive.value = true;
    };
    currencyCon.onChanged = (value) {
      if (!buttonActive.value) buttonActive.value = true;
    };
    expiryDateCon.onChanged = () {
      if (!buttonActive.value) buttonActive.value = true;
    };
    statusCon.onChanged = (value) {
      if (!buttonActive.value) buttonActive.value = true;
    };
    pickUpDateCon.onChanged = () {
      if (!buttonActive.value) buttonActive.value = true;
    };
    warrantyPeriodCon.onChanged = (value) {
      if (!buttonActive.value) buttonActive.value = true;
      if (pickUpDateCon.value != null && value.isNotEmpty) {
        DateTime serviceDate = (pickUpDateCon.value as Timestamp).toDate();
        DateTime expiryDate = serviceDate.add(Duration(days: int.parse(value)));
        expiryDateCon.value = expiryDate;
      } else {
        expiryDateCon.value = null;
      }
    };
  }

  bool showConfirmationCondition() {
    if (editable.value &&
        (productNameCon.value != null ||
            serviceDateCon.value != null ||
            storeNameCon.value != null ||
            problemDescCon.value != null ||
            serviceDescCon.value != null ||
            priceCon.value != null ||
            currencyCon.value != null ||
            warrantyPeriodCon.value != null ||
            expiryDateCon.value != null ||
            statusCon.value != null ||
            pickUpDateCon.value != null)) {
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
      if (!productNameCon.isValid) return;
      if (!serviceDateCon.isValid) return;
      if (!storeNameCon.isValid) return;
      if (!problemDescCon.isValid) return;
      if (!serviceDescCon.isValid) return;
      if (!priceCon.isValid) return;
      if (!currencyCon.isValid) return;
      if (!warrantyPeriodCon.isValid) return;
      if (!expiryDateCon.isValid) return;
      if (!statusCon.isValid) return;
      if (!pickUpDateCon.isValid) return;

      buttonActive.value = false;
      if (auth.currentUser != null) {
        // List<String> imageUrl = [];
        // if (scannedDoc.first.contains(RegExp('http', caseSensitive: false))) {
        //   imageUrl.addAll(scannedDoc);
        // } else {
        //   if (EasyLoading.isShow) EasyLoading.dismiss();
        //   await EasyLoading.show(status: "save_image".tr);
        //   for (var img in scannedDoc) {
        //     String? compressedImagePath = await ReusableStatics.compressImage(
        //       img,
        //     );
        //     if (compressedImagePath != null) {
        //       var result = await FirebaseRepository.saveImageToFirebaseStorage(
        //         imageLocationType: ImageLocationType.receipt,
        //         fileName: ReusableStatics.idGenerator(simple: true),
        //         imageFile: File(compressedImagePath),
        //       );
        //       if (result != null) {
        //         imageUrl.add(result);
        //       }
        //     }
        //   }
        // }

        if (EasyLoading.isShow) EasyLoading.dismiss();
        await EasyLoading.show(status: "save_data".tr);
        ServiceModel serviceModel = ServiceModel(
          documentid: id.isNotEmpty ? id.value : ReusableStatics.idGenerator(),
          productname: productNameCon.value,
          servicedate: serviceDateCon.value,
          storename: storeNameCon.value,
          problemdescription: problemDescCon.value,
          servicedescription: serviceDescCon.value,
          price: priceCon.value,
          currency: currencyCon.value,
          warrantyperioddays: warrantyPeriodCon.value,
          warrantyexpirydate: expiryDateCon.value,
          beforeserviceimages: [],
          afterserviceimages: [],
          servicestatus: statusCon.value,
          pickupdate: pickUpDateCon.value,
          pickupremindersent: false,
          warrantyremindersent: false,
          createdat: Timestamp.now(),
          updatedat: id.isNotEmpty ? Timestamp.now() : null,
        );

        bool result =
            id.isNotEmpty
                ? await FirebaseRepository.updateServiceById(
                  serviceModel: serviceModel,
                  userUid: auth.currentUser!.uid,
                )
                : await FirebaseRepository.addServiceToFirestore(
                  serviceModel: serviceModel,
                  userUid: auth.currentUser!.uid,
                );

        update();
        await EasyLoading.dismiss();
        if (result) {
          bool? result = await ReusableWidgets.notifBottomSheet(
            notifType: NotifType.success,
            subtitle: "success_save_service".tr,
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
    bool? result = await FirebaseRepository.deleteServiceById(
      documentId: id.value,
      userUid: auth.currentUser!.uid,
    );
    if (result == true) {
      Get.back(result: true);
    }
    await EasyLoading.dismiss();
  }
}
