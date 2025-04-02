import 'package:docusave/app/mahas/components/images/select_image_component.dart';
import 'package:docusave/app/mahas/components/inputs/input_text_component.dart';
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
  RxString editPictureLabel = "add_image".obs;

  void pickImageOptions() async {
    await SelectImageComponent.selectImageBottomSheet(
      removePicture: removeImage,
      selectCamera: () async => selectImage(ImageSource.camera),
      selectGallery: () async => selectImage(ImageSource.gallery),
    );
  }

  Future<void> selectImage(ImageSource source) async {
    var data = await SelectImageComponent.selectImageSource(source: source);
    if (data != null) fileImg = data;
    editPictureLabel.value = "change_image";
    update();
  }

  void removeImage() {
    fileImg = null;
    editPictureLabel.value = "add_image";
    update();
  }
}
