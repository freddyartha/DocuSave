import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/constants/mahas_colors.dart';
import 'package:docusave/app/mahas/constants/mahas_font_size.dart';
import 'package:docusave/app/mahas/models/menu_item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class SelectImageComponent {
  static Future selectImageBottomSheet({
    required bool showRemovePicture,
    Function()? removePicture,
    Function()? selectGallery,
    Function()? selectCamera,
  }) {
    List<MenuItemModel> imageOptions = [];
    if (selectGallery != null) {
      imageOptions.add(
        MenuItemModel(
          title: "select_gallery",
          icon: Icons.image_outlined,
          onTab: selectGallery,
        ),
      );
    }
    if (selectCamera != null) {
      imageOptions.add(
        MenuItemModel(
          title: "select_camera",
          icon: Icons.camera_alt_outlined,
          onTab: selectCamera,
        ),
      );
    }
    if (showRemovePicture) {
      imageOptions.add(
        MenuItemModel(
          title: "remove_image",
          icon: Icons.delete_outline_rounded,
          onTab: () {
            if (Get.isBottomSheetOpen == true) Get.back();
            removePicture != null ? removePicture() : null;
          },
        ),
      );
    }

    return Get.bottomSheet<bool>(
      enableDrag: false,
      PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          Get.back(result: false);
        },
        child: Container(
          decoration: BoxDecoration(
            color: MahasColors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextComponent(
                    value: "select_source".tr,
                    fontWeight: FontWeight.w600,
                    fontSize: MahasFontSize.h6,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    height: 40,
                    child: GestureDetector(
                      onTap: () => Get.back(result: false),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: MahasColors.black.withValues(alpha: 0.06),
                        ),
                        child: Icon(Icons.close, size: 30),
                      ),
                    ),
                  ),
                ],
              ),
              SafeArea(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: imageOptions.length,
                  itemBuilder:
                      (context, index) => ListTile(
                        onTap: imageOptions[index].onTab,
                        horizontalTitleGap: 10,
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          imageOptions[index].icon,
                          color: MahasColors.darkgray,
                        ),
                        title: TextComponent(
                          value: imageOptions[index].title!.tr,
                        ),
                        trailing: Icon(
                          Icons.chevron_right_rounded,
                          color: MahasColors.darkgray,
                        ),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<List<CroppedFile>?> selectMultipleImages({
    bool cropImages = true,
    CropAspectRatio cropAspectRatio = const CropAspectRatio(
      ratioX: 1,
      ratioY: 1,
    ),
  }) async {
    if (Get.isBottomSheetOpen == true) Get.back();

    final ImagePicker picker = ImagePicker();
    final List<XFile> pickedFiles = await picker.pickMultiImage(
      maxWidth: 1280,
      maxHeight: 720,
    );

    if (pickedFiles.isNotEmpty) {
      if (!cropImages) {
        // Jika tidak ingin crop, konversi langsung ke CroppedFile
        return pickedFiles.map((file) => CroppedFile(file.path)).toList();
      }

      // Jika ingin crop satu per satu
      List<CroppedFile> croppedFiles = [];
      for (var pickedFile in pickedFiles) {
        final cropped = await _cropImage(
          imageFilePath: pickedFile.path,
          cropAspectRatio: cropAspectRatio,
        );
        if (cropped != null) {
          croppedFiles.add(cropped);
        }
      }
      return croppedFiles;
    } else {
      return null;
    }
  }

  static Future<CroppedFile?> selectImageSource({
    required ImageSource source,
    bool allowCrop = true,
    CropAspectRatio cropAspectRatio = const CropAspectRatio(
      ratioX: 1,
      ratioY: 1,
    ),
  }) async {
    if (Get.isBottomSheetOpen == true) Get.back();
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 1280,
      maxHeight: 720,
    );

    if (pickedFile != null) {
      if (allowCrop) {
        return await _cropImage(
          imageFilePath: pickedFile.path,
          cropAspectRatio: cropAspectRatio,
        );
      } else {
        return CroppedFile(pickedFile.path);
      }
    } else {
      return null;
    }
  }

  static Future<CroppedFile?> _cropImage({
    required String imageFilePath,
    required CropAspectRatio cropAspectRatio,
  }) async {
    return await ImageCropper().cropImage(
      sourcePath: imageFilePath,
      aspectRatio: cropAspectRatio,
      compressQuality: 80,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: "image_cropper".tr,
          toolbarColor: MahasColors.primary,
          statusBarColor: MahasColors.primary,
          activeControlsWidgetColor: MahasColors.primary,
          toolbarWidgetColor: Colors.white,
        ),
        IOSUiSettings(title: "image_cropper".tr),
      ],
    );
  }
}
