import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docusave/app/data/firebase_repository.dart';
import 'package:docusave/app/mahas/components/inputs/input_text_component.dart';
import 'package:docusave/app/mahas/components/others/reusable_statics.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/mahas_service.dart';
import 'package:docusave/app/models/suggestion_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ProfileSuggestionSetupController extends GetxController {
  RxDouble rating = 5.0.obs;
  final InputTextController feedbackCon = InputTextController(
    type: InputTextType.paragraf,
  );
  final InputTextController suggestionCon = InputTextController(
    type: InputTextType.paragraf,
  );
  RxBool buttonActive = false.obs;

  @override
  void onInit() async {
    activateButton();
    super.onInit();
  }

  bool showConfirmationCondition() {
    if (rating.value != 0.0 &&
        (feedbackCon.value != null || suggestionCon.value != null)) {
      return true;
    } else {
      return false;
    }
  }

  void activateButton() {
    feedbackCon.onChanged = (value) {
      if (!buttonActive.value) buttonActive(true);
    };
    suggestionCon.onChanged = (value) {
      if (!buttonActive.value) buttonActive(true);
    };
  }

  Future<void> saveOnTap() async {
    if (buttonActive.value) {
      FocusScope.of(Get.context!).unfocus();
      bool validation = showConfirmationCondition();
      if (!validation) return;
      if (!feedbackCon.isValid) return;
      if (!suggestionCon.isValid) return;
      buttonActive(false);
      if (auth.currentUser != null) {
        if (EasyLoading.isShow) EasyLoading.dismiss();
        await EasyLoading.show(status: "save_data".tr);
        SuggestionModel suggestionModel = SuggestionModel(
          documentid: ReusableStatics.idGenerator(),
          userid: auth.currentUser!.uid,
          rating: rating.value,
          critique: feedbackCon.value,
          suggestion: suggestionCon.value,
          createdat: Timestamp.now(),
        );

        bool result = await FirebaseRepository.addSuggestionToFirestore(
          suggestionModel: suggestionModel,
        );

        update();
        await EasyLoading.dismiss();
        if (result) {
          bool? result = await ReusableWidgets.notifBottomSheet(
            notifType: NotifType.success,
            subtitle: "success_save_suggestion".tr,
          );
          if (result != null) Get.back(result: true);
        } else {
          buttonActive(true);
        }
      }
    }
  }
}
