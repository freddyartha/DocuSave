import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docusave/app/data/firebase_repository.dart';
import 'package:docusave/app/mahas/components/images/select_image_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_text_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/mahas_config.dart';
import 'package:docusave/app/mahas/lang/translation_service.dart';
import 'package:docusave/app/mahas/mahas_service.dart';
import 'package:docusave/app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSetupController extends GetxController {
  final InputTextController namaCon = InputTextController(
    type: InputTextType.text,
  );
  final InputTextController emailCon = InputTextController(
    type: InputTextType.email,
  );
  CroppedFile? fileImg;
  RxString tmpProfilePic = "".obs;
  RxString editPictureLabel = "add_image".obs;
  RxBool isLoading = false.obs;
  RxBool buttonActive = false.obs;

  @override
  void onInit() {
    namaCon.value = MahasConfig.userProfile?.name;
    emailCon.value = MahasConfig.userProfile?.email;
    tmpProfilePic.value = MahasConfig.userProfile?.profilepic ?? "";
    if (MahasConfig.userProfile?.profilepic != null) {
      editPictureLabel.value = "change_image";
    }
    namaCon.onChanged = (value) {
      if (!buttonActive.value) buttonActive.value = true;
    };
    emailCon.onChanged = (value) {
      if (!buttonActive.value) buttonActive.value = true;
    };

    super.onInit();
  }

  void pickImageOptions() async {
    await SelectImageComponent.selectImageBottomSheet(
      showRemovePicture:
          fileImg != null || MahasConfig.userProfile?.profilepic != null
              ? true
              : false,
      removePicture: removeImage,
      selectCamera: () async => selectImage(ImageSource.camera),
      selectGallery: () async => selectImage(ImageSource.gallery),
    );
  }

  Future<void> selectImage(ImageSource source) async {
    var data = await SelectImageComponent.selectImageSource(source: source);
    if (data != null) fileImg = data;
    editPictureLabel.value = "change_image";
    if (!buttonActive.value) buttonActive.value = true;
    update();
  }

  void removeImage() {
    fileImg = null;
    editPictureLabel.value = "add_image";
    tmpProfilePic.value = "";
    if (!buttonActive.value) buttonActive.value = true;
    update();
  }

  bool showConfirmationCondition() {
    if (namaCon.value != MahasConfig.userProfile?.name ||
        emailCon.value != MahasConfig.userProfile?.email ||
        fileImg != null ||
        (fileImg == null && tmpProfilePic.value == "")) {
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
      if (!namaCon.isValid) return;
      if (!emailCon.isValid) return;
      if (EasyLoading.isShow) EasyLoading.dismiss();
      await EasyLoading.show();
      isLoading.value = true;
      buttonActive.value = false;
      if (auth.currentUser != null) {
        String? imageUrl;
        if (fileImg != null) {
          imageUrl = await FirebaseRepository.saveImageToFirebaseStorage(
            imageLocationType: ImageLocationType.profile,
            fileName: auth.currentUser!.uid,
            imageFile: File(fileImg!.path),
          );
        }
        if (editPictureLabel.value == "add_image") {
          FirebaseRepository.removeImageFromFirebaseStorage(
            imageLocationType: ImageLocationType.profile,
            fileName: auth.currentUser!.uid,
          );
          MahasConfig.userProfile?.profilepic = null;
        }
        UserModel userModel = UserModel(
          userid: auth.currentUser!.uid,
          name: namaCon.value,
          email: emailCon.value,
          selectedLanguage: TranslationService.locale.languageCode,
          updatedat: Timestamp.now(),
          profilepic: imageUrl ?? MahasConfig.userProfile?.profilepic,
          subscriptionplan: MahasConfig.userProfile?.subscriptionplan,
          createdat: MahasConfig.userProfile?.createdat,
        );
        bool result = await FirebaseRepository.updateUserProfile(
          userModel: userModel,
        );
        update();
        isLoading.value = false;
        await EasyLoading.dismiss();
        if (result == true) {
          MahasConfig.userProfile = userModel;
          fileImg = null;
          bool? result = await ReusableWidgets.notifBottomSheet(
            notifType: NotifType.success,
            subtitle: "success_save_profile".tr,
          );
          if (result != null) Get.back();
        } else {
          buttonActive.value = true;
        }
      }
      update();
      isLoading.value = false;
      await EasyLoading.dismiss();
    }
  }
}
